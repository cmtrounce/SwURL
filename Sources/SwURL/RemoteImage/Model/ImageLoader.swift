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

enum ImageLoadError: Error {
    case loaderDeallocated
    case malformedResponse
    case invalidImageData
    case cacheError
    case imageNotFound
    case generic(underlying: Error)
}

class ImageLoader {
    typealias ImageLoadPromise = AnyPublisher<RemoteImageStatus, ImageLoadError>
    
    static let shared = ImageLoader()
    
    private let fileManager = FileManager.default
    
    var defaultCacheType: ImageCacheType = InMemoryImageCache()
    
    private let downloader = Downloader()
    
    func load(
        url: URL,
        cacheType: ImageCacheType?
    ) -> ImageLoadPromise {
        return retrieve(url: url, cacheType: cacheType)
    }
}

extension ImageLoader {
    private func retrieve(url: URL, cacheType: ImageCacheType?) -> ImageLoadPromise {
        let asyncLoad = Deferred { [unowned self] in
            self.downloader.download(from: url)
                .tryMap { downloadInfo in
                    try self.handleDownload(
                        downloadInfo: downloadInfo,
                        cacheType: cacheType ?? self.defaultCacheType
                    )
                }
                .mapError { error -> ImageLoadError in
                    if let error = error as? ImageLoadError {
                        return error
                    }
                    return .generic(underlying: error)
                }
                .eraseToAnyPublisher()
        }
        
        return Deferred { [unowned self] in
            let cacheTypeForRequest = cacheType ?? self.defaultCacheType
            return cacheTypeForRequest.image(for: url)
                .map(RemoteImageStatus.complete)
                .catch { error in
                    return asyncLoad
                }
        }
        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
        .eraseToAnyPublisher()
    }
    
    private func handleDownload(
        downloadInfo: DownloadInfo,
        cacheType: ImageCacheType
    ) throws -> RemoteImageStatus {
        switch downloadInfo.state {
        case .progress(let fractionCompleted):
            SwURLDebug.log(
                level: .info,
                message: "Image download progress: \(fractionCompleted)"
            )
            return .progress(fraction: fractionCompleted)
        case .result(let data):
            do {
                let image = try createAndStoreImage(
                    from: data,
                    requestURL: downloadInfo.url,
                    using: cacheType
                )
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
    private func createAndStoreImage(
        from data: Data,
        requestURL: URL,
        using cacheType: ImageCacheType
    ) throws -> CGImage {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
            SwURLDebug.log(
                level: .error,
                message: "failed to create an image source for request: " + requestURL.absoluteString
            )
            throw ImageLoadError.cacheError
        }
        
        guard let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            SwURLDebug.log(
                level: .error,
                message: "failed to create an image from source for request" + requestURL.absoluteString
            )
            throw ImageLoadError.cacheError
        }
        
        cacheType.store(image: image, for: requestURL)
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
