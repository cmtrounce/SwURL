//
//  File.swift
//  
//
//  Created by Callum Trounce on 14/07/2019.
//

import Foundation
import Combine
import CoreGraphics

/// Provide a custom implementation for retrieval and storage of downloaded images.
public protocol ImageCacheType {
    /// Store image for a given URL.
    /// - Parameters:
    ///   - image: The downloaded image.
    ///   - url: The URL used to retrieve the image.
    func store(image: CGImage, for url: URL)
    /// Retrieve a stored image for the given URL
    /// - Parameter url: The URL for the image resource
    /// - Returns: The request for the image.
    func image(for url: URL) -> Future<CGImage, Error>
}

/// Strategy to use when storing and retrieving cached images.
public enum ImageCacheStrategy {
    /// Cache images for the duration of the app session. Storage will be invalidated between app sessions.
    case inMemory
    /// Persist images between app sessions. Storage will be invalidated by the operating system.
    case persistent
    /// Provide your own `ImageCacheType` to handle storage and retrieval of images.
    /// Use this if you want fine grained control over cache size, cache invalidation, data retrieval.
    case custom(ImageCacheType)
    /// No cache, always retrieve images from network
    case noCache
    
    var cache: ImageCacheType {
        switch self {
        case .inMemory:
            return InMemoryImageCache.shared
        case .persistent:
            return PersistentImageCache.shared
        case .custom(let cache):
            return cache
        case .noCache:
            return NoCache()
        }
    }
}
