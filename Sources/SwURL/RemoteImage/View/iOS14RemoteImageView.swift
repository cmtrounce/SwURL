//
//  SwURLImage.swift
//  SwURL
//
//  Created by Callum Trounce on 18/08/2021.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
public struct iOS14RemoteImageView: SwURLImageViewType {
    var url: URL
    var placeholderImage: Image?
    private var _imageProcessing: ((Image) -> AnyView) = ImageProcessing.default()
    private var _loadingIndicator: ((CGFloat) -> AnyView)?
    
    let transitionType: ImageTransitionType
    
    @StateObject private var remoteImage: RemoteImage = RemoteImage()
    
    public var body: some View {
        TransitioningImage(
            placeholder: placeholderImage.process(with: _imageProcessing),
            finalImage: remoteImage.image.process(with: _imageProcessing),
            loadingIndicator: _loadingIndicator?(CGFloat(remoteImage.progress)),
            transitionType: transitionType
        ).onAppear {
            remoteImage.load(url: url)
        }
    }
    
    init(
        url: URL,
        placeholderImage: Image? = nil,
        transition: ImageTransitionType = .none
    ) {
        self.placeholderImage = placeholderImage
        self.url = url
        self.transitionType = transition
    }
    
    public func imageProcessing<ProcessedImage>(_ processing: @escaping (Image) -> ProcessedImage) -> Self where ProcessedImage : View {
        var mut = self
        mut._imageProcessing = { image in
            return AnyView(processing(image))
        }
        return mut
    }
    
    public func progress<T>(_ progress: @escaping (CGFloat) -> T) -> Self where T : View {
        var mut = self
        mut._loadingIndicator = { percentageComplete in
            return AnyView(progress(percentageComplete))
        }
        return mut
    }
}
