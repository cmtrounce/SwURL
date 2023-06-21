import Combine
import Foundation

public struct SwURL {
    public typealias SwURLImage = RemoteImageView
    
    private static let downloader = Downloader()

    public static func setImageCache(type: ImageCacheStrategy) {
        ImageLoader.shared.cache = type.cache
    }
}
