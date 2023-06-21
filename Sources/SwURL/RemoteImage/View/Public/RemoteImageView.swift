//
//  RemoteImageView.swift
//  Landmarks
//
//  Created by Callum Trounce on 06/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
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

public struct RemoteImageView: SwURLImageViewType {
    var url: URL
    var placeholderImage: Image?
    private var _imageProcessing: ((Image) -> AnyView)
    private var _loadingIndicator: ((CGFloat) -> AnyView)?
    
    let transitionType: ImageTransitionType
    
    @ObservedObject
    private var remoteImage: RemoteImage = RemoteImage()
    
    public var body: some View {
        TransitioningImage(
            placeholder: placeholderImage.process(with: _imageProcessing),
            finalImage: remoteImage.image.process(with: _imageProcessing),
            loadingIndicator: _loadingIndicator?(CGFloat(remoteImage.progress)),
            transitionType: transitionType
        ).onAppear {
            // bug in swift ui when onAppear called multiple times
            // resulting in duplicate requests.
            if self.remoteImage.shouldRequestLoad {
                self.remoteImage.load(url: self.url)
            }
        }
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
