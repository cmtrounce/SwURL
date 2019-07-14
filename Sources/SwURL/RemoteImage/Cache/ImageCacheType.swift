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
    
    func image(for url: URL) -> Publishers.Future<CGImage, ImageLoadError>
    
}

// Predefined caching options
@available(iOS 13.0, *)
public extension ImageCacheType {
    
    static var inMemory: ImageCacheType {
        return InMemoryImageCache()
    }
    
    static var persistent: ImageCacheType {
        return PersistentImageCache()
    }
    
}


