//
//  File 2.swift
//  
//
//  Created by Callum Trounce on 05/06/2019.
//

import Foundation
import SwiftUI
import Combine

@available(iOS 13.0, *)
class ImageCache {
    
    private let cache = NSCache<NSURL, CGImage>()
    
    private let queue = DispatchQueue.init(label: "cacheQueue", qos: .userInteractive)
    
    func store(image: CGImage, for url: URL) {
        queue.async { [unowned cache] in
            cache.setObject(image, forKey: url as NSURL)
        }
    }
    
    func image(for url: URL) -> Publishers.Future<CGImage, ImageLoadError> {
        return Publishers.Future<CGImage, ImageLoadError>.init { [weak self] seal in
            guard let self = self else {
                seal(.failure(ImageLoadError.loaderDeallocated))
                return
            }
            
            self.queue.async {
                if let cached = self.cache.object(forKey: url as NSURL) {
                    seal(.success(cached))
                    return
                }
                
                seal(.failure(.cacheError))
            }
        }
    }
}
