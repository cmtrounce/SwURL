//
//  RemoteImageView.swift
//  Landmarks
//
//  Created by Callum Trounce on 06/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import SwiftUI

public struct RemoteImageView: View {
    var url: URL
    var placeholderImage: Image?
	var imageRenderingMode: Image.TemplateRenderingMode?
    
    let transitionType: ImageTransitionType

    @ObservedObject
    var remoteImage: RemoteImage = RemoteImage()
    
    public var body: some View {
        TransitioningImage(
			placeholder: placeholderImage?
				.resizable()
				.renderingMode(imageRenderingMode),
			finalImage: remoteImage.load(url: url).image?
				.resizable()
				.renderingMode(imageRenderingMode),
			transitionType: transitionType
		)
    }

	public init(
		url: URL,
		placeholderImage: Image? = nil,
		transition: ImageTransitionType = .none,
		imageRenderingMode: Image.TemplateRenderingMode? = nil
	) {
        self.placeholderImage = placeholderImage
        self.url = url
        self.transitionType = transition
		self.imageRenderingMode = imageRenderingMode
    }
}
