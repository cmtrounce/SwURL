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
		case result(URL)
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
        queue.async { [weak self] in
            guard
                let self = self,
                var downloadInfo = self.tasks[downloadTask]?.value
            else {
                return
            }
            
            downloadInfo.state = .result(location)
            
            self.tasks[downloadTask]?.send(downloadInfo)
            self.tasks[downloadTask]?.send(completion: .finished)
            SwURLDebug.log(
                level: .info,
                message: "Download of \(downloadInfo.url) finished download to \(location)"
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
                var downloadInfo = self.tasks[downloadTask]?.value
            else {
                return
            }
            
            let fractionDownloaded = Float(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
            
            downloadInfo.state = .progress(fractionDownloaded)
            self.tasks[downloadTask]?.send(downloadInfo)
            
            SwURLDebug.log(
                level: .info,
                message: "Download of \(downloadInfo.url) reached progress: \(fractionDownloaded)"
            )
        }
	}
}
