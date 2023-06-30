//
//  Created by Callum Trounce on 06/06/2019.
//

import Foundation
import SwiftUI

@available(*, deprecated, renamed: "SwURLImage")
public typealias RemoteImageView = SwURLImage

/// A view that asynchronously loads and displays an image. Supports custom placeholders, transitions and progress indicators.
public struct SwURLImage: View {
    private let url: URL
    private let placeholderImage: Image?
    private let transitionType: ImageTransitionType
    
    private var _imageProcessing: ((Image) -> AnyView)
    private var _loadingIndicator: ((CGFloat) -> AnyView)?
    private var _overrideCache: ImageCacheProvider?
   
    private var placeholderView: AnyView? {
        return placeholderImage.process(with: _imageProcessing)
    }
    
    private var finalImage: AnyView? {
        return remoteImage.image.process(with: _imageProcessing)
    }
    
    private var loadingIndicator: AnyView? {
        return _loadingIndicator?(CGFloat(remoteImage.progress))
    }
    
    @ObservedObject
    private var remoteImage: RemoteImage = RemoteImage()
    
    public var body: some View {
        ZStack {
            if finalImage == nil {
                placeholderView
                loadingIndicator
            }
            finalImage
                .transition(transitionType.t)
        }
        .onAppear {
            // bug in swift ui when onAppear called multiple times
            // resulting in duplicate requests.
            if remoteImage.shouldRequestLoad {
                remoteImage.load(url: url, cache: _overrideCache)
            }
        }
        .animation(transitionType.animation, value: remoteImage.imageStatus.identifier)
    }
    
    public init(
        url: URL,
        placeholderImage: Image? = nil,
        transition: ImageTransitionType = .none
    ) {
        self.placeholderImage = placeholderImage
        self.url = url
        self.transitionType = transition
        self._imageProcessing = ImageProcessing.default()
        
        if remoteImage.shouldRequestLoad {
            remoteImage.load(url: url, cache: _overrideCache)
        }
    }
    
    /// Apply additional processing to the final image. This is where you can set the aspect ratio, size, borders, and more.
    /// - Parameter processing: The transformation to the final image. Can return any View type, not just an image.
    /// - Returns: A copy with the modifications applied.
    public func imageProcessing<ProcessedImage>(_ processing: @escaping (Image) -> ProcessedImage) -> Self where ProcessedImage : View {
        var mut = self
        mut._imageProcessing = { image in
            return AnyView(processing(image))
        }
        return mut
    }
    
    /// Observe the current download progress of the specific image, and present another view. i.e. a loading bar.
    /// - Parameter progress:A fractional indication of download progress of the image, returns a view to render based on the download progress of the image.
    /// - Returns: A copy with the modifications applied.
    public func progress<T>(_ progress: @escaping (CGFloat) -> T) -> Self where T : View {
        var mut = self
        mut._loadingIndicator = { percentageComplete in
            return AnyView(progress(percentageComplete))
        }
        return mut
    }
    
    /// Applies a particular image cache to this specific image.
    /// - Parameter imageCacheStrategy: Cache strategy for this image
    /// - Returns: A copy of this image with the cache applied.
    public func cache(_ imageCacheStrategy: ImageCacheStrategy) -> Self {
        var mut = self
        mut._overrideCache = imageCacheStrategy.cache
        return mut
    }
}

// MARK: - ImageTransitionType helpers.

extension ImageTransitionType {
    fileprivate var t: AnyTransition {
        switch self {
        case .custom(let transition, _):
            return transition
        case .none:
            return .identity
        }
    }
    
    fileprivate var animation: Animation? {
        switch self {
        case .custom(_, let animation):
            return animation
        case .none:
            return nil
        }
    }
}
