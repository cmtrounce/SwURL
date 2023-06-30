//
//  Created by Callum Trounce on 30/06/2023.
//

import Foundation
import Combine
import CoreGraphics

final class NoCache: ImageCacheType {
    enum NoCacheError: Error {
        case notImplemented
    }
    
    func store(image: CGImage, for url: URL) {
    
    }
    
    func image(for url: URL) -> Future<CGImage, Error> {
        return Future { promise in
            promise(.failure(NoCacheError.notImplemented))
        }
    }
}
