import Combine
import Foundation

public struct SwURL {
    private static let downloader = Downloader()

    /// Set the default `ImageCacheStrategy` for SwURL to use.
    /// Image cache strategy can be overriden on a `SwURLImage` basis.
    /// - Parameter type: Caching strategy. See `ImageCacheStrategy`
    public static func setImageCache(type: ImageCacheStrategy) {
        ImageLoader.shared.defaultCacheType = type.cache
    }
}
