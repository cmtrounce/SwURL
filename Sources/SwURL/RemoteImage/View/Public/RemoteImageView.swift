//
//  RemoteImageView.swift
//  Landmarks
//
//  Created by Callum Trounce on 06/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import SwiftUI

public protocol SwURLImageViewType {
    func imageProcessing<ProcessedImage: View>(
        _ processing: @escaping (Image) -> ProcessedImage
    ) -> Self
    func progress<T: View>(_ progress: @escaping (CGFloat) -> T) -> Self
}

public struct SwURLImageView: SwURLImageViewType {
    var imageView: SwURLImageViewType
    
    public func imageProcessing<ProcessedImage>(_ processing: @escaping (Image) -> ProcessedImage) -> SwURLImageView where ProcessedImage : View {
        return .init(imageView: imageView.imageProcessing(processing))
    }
    
    public func progress<T>(_ progress: @escaping (CGFloat) -> T) -> SwURLImageView where T : View {
        return .init(imageView: imageView.progress(progress))
    }
}

public func RemoteImageView(
    url: URL,
    placeholderImage: Image? = nil,
    transition: ImageTransitionType = .none
) -> SwURLImageView {
    if #available(iOS 14.0, *) {
        return SwURLImageView(
            imageView: iOS14RemoteImageView(
                url: url,
                placeholderImage: placeholderImage,
                transition: transition
            )
        )
    } else {
        return SwURLImageView(
            imageView: iOS13RemoteImageView(
                url: url,
                placeholderImage: placeholderImage,
                transition: transition
            )
        )
    }
}
