//
//  Created by Callum Trounce on 06/06/2019.
//

import Foundation
import SwiftUI

protocol SwURLImageViewType: ImageOutputCustomisable, View {}

public protocol ImageOutputCustomisable {
    mutating func imageProcessing<ProcessedImage: View>(
        _ processing: @escaping (Image) -> ProcessedImage
    ) -> Self
    mutating func progress<T: View>(_ progress: @escaping (CGFloat) -> T) -> Self
}

@available(*, deprecated, renamed: "SwURLImage")
public typealias RemoteImageView = SwURLImage

public struct SwURLImage: SwURLImageViewType {
    private let url: URL
    private let placeholderImage: Image?
    private let transitionType: ImageTransitionType
    
    private var _imageProcessing: ((Image) -> AnyView)
    private var _loadingIndicator: ((CGFloat) -> AnyView)?
   
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
    
    @State
    private var imageStatus: RemoteImageStatus = .pending
    
    public var body: some View {
        ZStack {
            if finalImage == nil {
                placeholderView
                loadingIndicator
            }
            finalImage
        }.onAppear {
            // bug in swift ui when onAppear called multiple times
            // resulting in duplicate requests.
            if remoteImage.shouldRequestLoad {
                remoteImage.load(url: url)
            }
        }
        .transition(transitionType.t)
        .animation(transitionType.animation)
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
            remoteImage.load(url: url)
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
