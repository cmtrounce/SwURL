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
	@Atomic private var tasks: [URLSessionDownloadTask: CurrentValueSubject<DownloadInfo, Error>] = [:]
	
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
				state: .progress(0)
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
		
		downloadInfo.state = .result(location)
		
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
		
		downloadInfo.state = .progress(fractionDownloaded)  
		tasks[downloadTask]?.send(downloadInfo)
		
		SwURLDebug.log(
			level: .info,
			message: "Download of \(downloadInfo.url) reached progress: \(fractionDownloaded)"
		)
	}
}
