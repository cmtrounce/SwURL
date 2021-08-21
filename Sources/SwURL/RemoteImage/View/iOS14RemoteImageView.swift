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
    
    private var remoteImageToUse: RemoteImage {
        return remoteImage
    }
    
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
    
    public mutating func imageProcessing<ProcessedImage>(_ processing: @escaping (Image) -> ProcessedImage) -> Self where ProcessedImage : View {
        _imageProcessing = { image in
            return AnyView(processing(image))
        }
        return self
    }
    
    public mutating func progress<T>(_ progress: @escaping (CGFloat) -> T) -> Self where T : View {
        _loadingIndicator = { percentageComplete in
            return AnyView(progress(percentageComplete))
        }
        return self
    }
}
