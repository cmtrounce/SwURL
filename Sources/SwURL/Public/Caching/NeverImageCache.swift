//
//  Created by Callum Trounce on 30/06/2023.
//

import Foundation
import Combine
import CoreGraphics

// Never store images. Never attempt to retrieve images from cache.
final class NeverImageCache: ImageCacheType {
    struct CacheNotImplemented: Error {}
    
    func store(image: CGImage, for url: URL) {
    
    }
    
    func image(for url: URL) -> Future<CGImage, Error> {
        return Future { promise in
            promise(.failure(CacheNotImplemented()))
        }
    }
}
