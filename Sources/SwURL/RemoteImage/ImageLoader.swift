//
//  File 2.swift
//  
//
//  Created by Callum Trounce on 05/06/2019.
//

import Foundation
import CoreGraphics
import CoreImage
import Combine

public enum ImageLoadError: Error {
    case loaderDeallocated
    case malformedResponse
    case invalidImageData
    case cacheError
    case imageNotFound
    case generic(underlying: Error)
}


class ImageLoader {
    public typealias ImageLoadPromise = AnyPublisher<RemoteImageStatus, ImageLoadError>
    
    static let shared = ImageLoader()
    
    private let fileManager = FileManager()
    
    var cache: ImageCacheType = InMemoryImageCache()
    
    private let downloader = Downloader()
    
    public func load(url: URL) -> ImageLoadPromise {
        return retrieve(url: url)
    }
}


private extension ImageLoader {
    
    /// Retrieves image from URL
    /// - Parameter url: url at which you require the image.
	func retrieve(url: URL) -> ImageLoadPromise {
		let asyncLoad = Deferred { [unowned self] in
			self.downloader.download(from: url)
				.tryMap(self.handleDownload)
				.mapError { error -> ImageLoadError in
					if let error = error as? ImageLoadError {
						return error
					}
					return .generic(underlying: error)
			}
			.eraseToAnyPublisher()
		}
		
		return cache.image(for: url)
			.map(RemoteImageStatus.complete)
			.catch { error in
				return asyncLoad
		}.eraseToAnyPublisher()
	}
	
	/// Handles response of successful download response
    /// - Parameter response: data response from request
    /// - Parameter location: the url fthat was in the request.
    func handleDownload(downloadInfo: DownloadInfo) throws -> RemoteImageStatus {
        let url = downloadInfo.url
		guard let location = downloadInfo.resultURL else {
			SwURLDebug.log(
				level: .info,
				message: "Result url not present in handleDownload.\nProgress \(downloadInfo.progress)"
			)
			return .progress(fraction: downloadInfo.progress)
		}
		
		do {
			let directory = try self.fileManager.url(
				for: searchPathDirectory,
				in: .userDomainMask,
				appropriateFor: nil,
				create: true
			).appendingPathComponent(location.lastPathComponent)
			
			try self.fileManager.copyItem(at: location, to: directory)
			
			guard let imageSource = CGImageSourceCreateWithURL(directory as NSURL, nil) else {
				throw ImageLoadError.cacheError
			}
			
			guard let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
				throw ImageLoadError.cacheError
			}
			
			self.cache.store(image: image, for: url)
			return .complete(result: image)
		} catch {
			throw ImageLoadError.generic(underlying: error)
		}
    }

	var searchPathDirectory: FileManager.SearchPathDirectory {
		#if os(iOS)
		return FileManager.SearchPathDirectory.documentDirectory
		#else
		return FileManager.SearchPathDirectory.cachesDirectory
		#endif
	}
}
