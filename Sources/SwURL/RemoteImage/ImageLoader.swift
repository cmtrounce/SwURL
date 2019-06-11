//
//  File 2.swift
//  
//
//  Created by Callum Trounce on 05/06/2019.
//

import Foundation
import SwiftUI
import Combine

public enum ImageLoadError: Error {
    case loaderDeallocated
    case malformedResponse
    case invalidImageData
    case cacheError
    case generic(underlying: Error)
}


@available(iOS 13.0, *)
class ImageLoader {
    
    public typealias ImageLoadPromise = AnyPublisher<CGImage, ImageLoadError>
    
    static let shared = ImageLoader()
    
    private let fileManager = FileManager()
    
    private let cache = ImageCache()
    
    private let networker = Networker()
    
    public func load(url: URL) -> ImageLoadPromise{
        return retrieve(url: url)
    }
}

@available(iOS 13.0, *)
private extension ImageLoader {
    
    /// Retrieves image from URL
    /// - Parameter url: url at which you require the image.
    func retrieve(url: URL) -> ImageLoadPromise {
        let asyncLoad = networker.downloadTask(url: url)
            .mapError(ImageLoadError.generic)
            .flatMap(handleDownload)
            .eraseToAnyPublisher()
        
        return cache
            .image(for: url)
            .catch { error -> ImageLoadPromise in
                return asyncLoad
        }.eraseToAnyPublisher()
    }
 
    /// Handles response of successful download response
    /// - Parameter response: data response from request
    /// - Parameter location: the url fthat was in the request.
    func handleDownload(response: URLResponse, location: URL) -> ImageLoadPromise {
        return Publishers.Future<CGImage, ImageLoadError>.init { [weak self] seal in
            guard let self = self else {
                seal(.failure(.loaderDeallocated))
                return
            }
            
            guard let url = response.url else {
                seal(.failure(.malformedResponse))
                return
            }
            
            do {
                let directory = try self.fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(location.lastPathComponent)
                try self.fileManager.copyItem(at: location, to: directory)
                
                guard
                    let imageSource = CGImageSourceCreateWithURL(directory as NSURL, nil) else {
                        seal(.failure(.cacheError))
                        return
                }
                
                guard let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
                    else {
                        seal(.failure(.cacheError))
                        return
                }
                
                self.cache.store(image: image, for: url)
                seal(.success(image))
            } catch {
                seal(.failure(.generic(underlying: error)))
            }
        }.eraseToAnyPublisher()
    }
}
