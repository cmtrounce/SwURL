//
//  File.swift
//  
//
//  Created by Callum Trounce on 11/06/2019.
//

import Foundation
import Combine

struct DownloadInfo {
    enum State {
        case progress(Float)
        case result(Data)
    }
    
    let url: URL
    var state: State
}

final class Downloader: NSObject {
    private let queue = DispatchQueue(
        label: "SWURL.DownloaderQueue" + UUID().uuidString,
        qos: .userInitiated,
        attributes: .concurrent
    )
    
    private var tasks: [URLSessionDownloadTask: CurrentValueSubject<DownloadInfo, Error>] = [:]
    
    private lazy var session: URLSession = { [weak self] in
        let urlSession = URLSession.init(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        return urlSession
    }()
    
    func download(from url: URL) -> CurrentValueSubject<DownloadInfo, Error> {
        // Only place where `tasks` is written to, therefore place barrier flag.
        queue.sync(flags: .barrier) {
            let task = session.downloadTask(with: url)
            let subject = CurrentValueSubject<DownloadInfo, Error>.init(
                DownloadInfo.init(
                    url: url,
                    state: .progress(0)
                )
            )
            tasks[task] = subject
            task.resume()
            return subject
        }
    }
}

extension Downloader: URLSessionDownloadDelegate {
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        SwURLDebug.log(
            level: .info,
            message: "[Downloader] Image download task of \(downloadTask.debugDescription) did finish and downloaded to \(location)"
        )
        
        var resultData: Data?
        queue.sync(flags: .barrier) {
            do {
                resultData = try Data(contentsOf: location)
            } catch {
                SwURLDebug.log(
                    level: .info,
                    message: "[Downloader] Encountered error while trying to convert downloaded content to Data for task \(downloadTask.debugDescription), location: \(location)"
                )
                resultData = nil
            }
        }
        
        queue.async { [weak self] in
            guard
                let resultData = resultData
            else {
                SwURLDebug.log(
                    level: .error,
                    message: "[Downloader] Failed to retrieve data downloaded for task \(downloadTask.debugDescription). Unable to send finished event."
                )
                return
            }
            
            guard
                let self = self,
                let valueSubject = self.tasks[downloadTask]
            else {
                SwURLDebug.log(
                    level: .error,
                    message: "[Downloader] Failed to retrieve finished download info for task \(downloadTask.debugDescription). Unable to send finished event."
                )
                return
            }
            
            let downloadURL = valueSubject.value.url
            let finishedInfo = DownloadInfo(
                url: downloadURL,
                state: .result(resultData)
            )
            
            valueSubject.send(finishedInfo)
            valueSubject.send(completion: .finished)
            
            SwURLDebug.log(
                level: .info,
                message: "[Downloader] Sent event of \(downloadURL) finishing download to data"
            )
        }
    }
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        queue.async { [weak self] in
            guard
                let self = self,
                let valueSubject = self.tasks[downloadTask]
            else {
                SwURLDebug.log(
                    level: .error,
                    message: "[Downloader] Failed to retrieve progressing download info for task \(downloadTask.debugDescription). Unable to send progress event."
                )
                return
            }
            
            let fractionDownloaded = Float(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
            let url = valueSubject.value.url
            let progressInfo = DownloadInfo(
                url: url,
                state: .progress(fractionDownloaded)
            )
            valueSubject.send(progressInfo)
            
            SwURLDebug.log(
                level: .info,
                message: "[Downloader] Download of \(url) reached progress: \(fractionDownloaded)"
            )
        }
    }
}
