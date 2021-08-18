//
//  SwURLImage.swift
//  SwURL
//
//  Created by Callum Trounce on 18/08/2021.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
struct iOS14RemoteImageView: SwURLImageViewType {
    var url: URL
    var placeholderImage: Image?
    private var _imageProcessing: ((Image) -> AnyView)
    private var _loadingIndicator: ((CGFloat) -> AnyView)?
    
    let transitionType: ImageTransitionType

    @StateObject
    private var remoteImage: RemoteImage = RemoteImage()
    
    var body: some View {
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

    init(
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
    
    func imageProcessing<ProcessedImage>(_ processing: @escaping (Image) -> ProcessedImage) -> iOS14RemoteImageView where ProcessedImage : View {
        var mut = self
        mut._imageProcessing = { image in
            return AnyView(processing(image))
        }
        return mut
    }
    
    func progress<T>(_ progress: @escaping (CGFloat) -> T) -> iOS14RemoteImageView where T : View {
        var mut = self
        mut._loadingIndicator = { percentageComplete in
            return AnyView(progress(percentageComplete))
        }
        return mut
    }
}
