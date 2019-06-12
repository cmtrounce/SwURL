//
//  RemoteImageView.swift
//  Landmarks
//
//  Created by Callum Trounce on 06/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public struct RemoteImageView: View {
    
    var url: URL
    
    var placeholderImage: Image?
    
    @State
    var remoteImage: RemoteImage = RemoteImage()
    
    public var body: some View {
        TransitioningImage.init(placeholder: placeholderImage,
                                finalImage: remoteImage.load(url: url).image,
                                transitionType: (.opacity, .basic(duration: 0.5, curve: .easeOut)))
    }
    
    public init(url: URL, placeholderImage: Image) {
        self.placeholderImage = placeholderImage
        self.url = url
    }
}
