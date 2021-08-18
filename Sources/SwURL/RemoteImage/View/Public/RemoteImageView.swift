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
    mutating func imageProcessing<ProcessedImage: View>(
        _ processing: @escaping (Image) -> ProcessedImage
    ) -> Self
    mutating func progress<T: View>(_ progress: @escaping (CGFloat) -> T) -> Self
}

public struct SwURLImageView: SwURLImageViewType {
    var imageView: SwURLImageViewType
    
    public mutating func imageProcessing<ProcessedImage>(_ processing: @escaping (Image) -> ProcessedImage) -> SwURLImageView where ProcessedImage : View {
        self = .init(imageView: imageView.imageProcessing(processing))
        return self
    }
    
    public mutating func progress<T>(_ progress: @escaping (CGFloat) -> T) -> SwURLImageView where T : View {
        self = .init(imageView: imageView.progress(progress))
        return self
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
