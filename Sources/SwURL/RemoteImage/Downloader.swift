//
//  File.swift
//  
//
//  Created by Callum Trounce on 11/06/2019.
//

import Foundation
import Combine

struct DownloadInfo {
	let url: URL
	var progress: Float
	var resultURL: URL?
}

class Downloader: NSObject {
	var tasks: [URLSessionDownloadTask: CurrentValueSubject<DownloadInfo, Error>] = [:]
	
	private lazy var session: URLSession = { [weak self] in
		let urlSession = URLSession.init(
			configuration: .default,
			delegate: self,
			delegateQueue: OperationQueue()
		)
		return urlSession
	}()
	
	func download(from url: URL) -> CurrentValueSubject<DownloadInfo, Error> {
		let task = session.downloadTask(with: url)
		let subject = CurrentValueSubject<DownloadInfo, Error>.init(
			DownloadInfo.init(
				url: url,
				progress: 0,
				resultURL: nil
			)
		)
		tasks[task] = subject
		task.resume()
		return subject
	}
}

extension Downloader: URLSessionDownloadDelegate {
	func urlSession(
		_ session: URLSession,
		downloadTask: URLSessionDownloadTask,
		didFinishDownloadingTo location: URL
	) {
		guard var downloadInfo = tasks[downloadTask]?.value else {
			return
		}
		
		downloadInfo.resultURL = location
		downloadInfo.progress = 1
		
		tasks[downloadTask]?.send(downloadInfo)
		tasks[downloadTask]?.send(completion: .finished)
		SwURLDebug.log(
			level: .info,
			message: "Download of \(downloadInfo.url) finished download to \(location)"
		)
	}
	
	func urlSession(
		_ session: URLSession,
		downloadTask: URLSessionDownloadTask,
		didWriteData bytesWritten: Int64,
		totalBytesWritten: Int64,
		totalBytesExpectedToWrite: Int64
	) {
		guard var downloadInfo = tasks[downloadTask]?.value else {
			return
		}
		
		let fractionDownloaded = Float(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
		
		downloadInfo.progress = fractionDownloaded
		tasks[downloadTask]?.send(downloadInfo)
		
		SwURLDebug.log(
			level: .info,
			message: "Download of \(downloadInfo.url) reached progress: \(fractionDownloaded)"
		)
	}
}
