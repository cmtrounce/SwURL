import Combine
import Foundation

public struct SwURL {
    private static let downloader = Downloader()

    public static func setImageCache(type: ImageCache) {
        ImageLoader.shared.cache = type.cache
    }
}
