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
		
		return Deferred { [unowned self] in
			self.cache.image(for: url)
				.map(RemoteImageStatus.complete)
				.catch { error in
					return asyncLoad
			}
		}
		.subscribe(on: DispatchQueue.global(qos: .userInitiated))
		.eraseToAnyPublisher()
	}
	
	/// Handles response of successful download response
    /// - Parameter response: data response from request
    /// - Parameter location: the url fthat was in the request.
    func handleDownload(downloadInfo: DownloadInfo) throws -> RemoteImageStatus {
		switch downloadInfo.state {
		case .progress(let fractionCompleted):
			SwURLDebug.log(
				level: .info,
				message: "Image download progress: \(fractionCompleted)"
			)
			return .progress(fraction: fractionCompleted)
		case .result(let downloadLocationURL):
			do {
				let image = try createAndStoreImage(at: downloadLocationURL, requestURL: downloadInfo.url)
				return .complete(result: image)
			} catch {
				SwURLDebug.log(
					level: .error,
					message: "FileManager failed with error: " + error.localizedDescription
				)
				throw ImageLoadError.generic(underlying: error)
			}
		}
    }
	
	/// Attempts to create and store downloaded image using the file manager.
	/// - Parameters:
	///   - location: the location at which the downladed resource is stored.
	///   - requestURL: the original url used to request the resource
	/// - Throws: When the function fails to create and store the downloaded image
	/// - Returns: A created CGImage
	private func createAndStoreImage(at location: URL, requestURL: URL) throws -> CGImage {
		let directory = try fileManager.url(
			for: searchPathDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: true
		).appendingPathComponent(location.lastPathComponent)
		
		try fileManager.copyItem(at: location, to: directory)
		
		guard let imageSource = CGImageSourceCreateWithURL(directory as NSURL, nil) else {
			SwURLDebug.log(
				level: .error,
				message: "failed to create an image source at directory: " + directory.absoluteString
			)
			throw ImageLoadError.cacheError
		}
		
		guard let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
			SwURLDebug.log(
				level: .error,
				message: "failed to create an image from source at directory" + directory.absoluteString
			)
			throw ImageLoadError.cacheError
		}
		
		cache.store(image: image, for: requestURL)
		return image
	}

	var searchPathDirectory: FileManager.SearchPathDirectory {
		#if os(iOS)
		return FileManager.SearchPathDirectory.documentDirectory
		#else
		return FileManager.SearchPathDirectory.cachesDirectory
		#endif
	}
}
