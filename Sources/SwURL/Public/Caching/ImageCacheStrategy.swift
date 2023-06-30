//
//  Created by Callum Trounce on 30/06/2023.
//

import Foundation

/// Strategy to use when storing and retrieving cached images.
public enum ImageCacheStrategy {
    /// Cache images for the duration of the app session. Storage will be invalidated between app sessions.
    case inMemory
    /// Persist images between app sessions. Storage will be invalidated by the operating system.
    case persistent
    /// Provide your own `ImageCacheProvider` to handle storage and retrieval of images.
    /// Use this if you want fine grained control over cache size, cache invalidation, data retrieval.
    case custom(ImageCacheProvider)
    /// Never store images. Never attempt to retrieve images from cache.
    /// Always attempt to load images from network.
    case never
    
    var cache: ImageCacheProvider {
        switch self {
        case .inMemory:
            return InMemoryImageCache.shared
        case .persistent:
            return PersistentImageCache.shared
        case .custom(let cache):
            return cache
        case .never:
            return NeverImageCache()
        }
    }
}
