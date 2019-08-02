//
//  File.swift
//  
//
//  Created by Callum Trounce on 14/07/2019.
//

import Foundation
import Combine
import CoreGraphics

@available(iOS 13.0, *)
public protocol ImageCacheType {
    
    func store(image: CGImage, for url: URL)
    
    func image(for url: URL) -> Future<CGImage, ImageLoadError>
    
}

@available(iOS 13.0, *)
public enum ImageCache {
    case inMemory
    case persistent
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
