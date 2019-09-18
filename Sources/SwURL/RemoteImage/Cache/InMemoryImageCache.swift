//
//  File 2.swift
//  
//
//  Created by Callum Trounce on 05/06/2019.
//

import Foundation
import SwiftUI
import Combine

public class InMemoryImageCache: ImageCacheType {
    private let cache = NSCache<NSURL, CGImage>()
    
    /// Specific queue to assist with concurrency.
    private let queue = DispatchQueue.init(label: "cacheQueue", qos: .userInteractive)
    
    /// Asyncronously stores an image in the cache
    /// - Parameter image: the image which you wish to store
    /// - Parameter url: the url at which you wish to associate with the image.
    public func store(image: CGImage, for url: URL) {
        queue.async { [weak cache] in
            cache?.setObject(image, forKey: url as NSURL)
        }
    }
    
    /// Asyncronously retrieves an image from the cache based on the provided url
    /// - Parameter url: the url at  which you wish to retrieve an image for.
    public func image(for url: URL) -> Future<CGImage, ImageLoadError> {
        return Future<CGImage, ImageLoadError>.init { [weak self] seal in
            guard let self = self else {
                seal(.failure(ImageLoadError.loaderDeallocated))
                return
            }
            
            if let cached = self.cache.object(forKey: url as NSURL) {
                seal(.success(cached))
            } else {
                // for some reason it occasionally crashes here saying an event has already been sent to the subscriber,
                // but that's not possible inside this if statement. Can anyone spot what's up?
                seal(.failure(.cacheError))
            }
        }
    }
}
