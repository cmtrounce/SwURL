//
//  File.swift
//  
//
//  Created by Callum Trounce on 14/07/2019.
//

import Foundation
import Combine
import CoreGraphics

public protocol ImageCacheType {
    func store(image: CGImage, for url: URL)
    func image(for url: URL) -> Future<CGImage, Error>
}

/// Strategy to use when storing and retrieving cached images.
public enum ImageCacheStrategy {
    /// Cache images for the duration of the app session. Storage will be invalidated between app launches.
    case inMemory
    /// Persist images between app sessions. Storage will be invalidated by the operating system.
    case persistent
    /// Provide your own `ImageCacheType` to handle storage and retrieval of images.
    /// Use this if you want fine grained control over cache size, cache invalidation, data retrieval.
    case custom(ImageCacheType)
    
    var cache: ImageCacheType {
        switch self {
        case .inMemory:
            return InMemoryImageCache()
        case .persistent:
            return PersistentImageCache()
        case .custom(let cache):
            return cache
        }
    }
}
