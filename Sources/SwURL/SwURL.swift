import Combine
import Foundation

public struct SwURL {
    private static let downloader = Downloader()

    /// Set the default ``ImageCacheStrategy`` for SwURL to use.
    /// Can be overriden on ``SwURLImage`` instances via ``SwURLImage/cache(_:)``.
    /// - Parameter type: Caching strategy. See ``ImageCacheStrategy``
    public static func setImageCache(type: ImageCacheStrategy) {
        ImageLoader.shared.defaultCache = type.cache
    }
}
