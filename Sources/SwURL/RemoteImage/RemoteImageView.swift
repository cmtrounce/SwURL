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
	public typealias ImageProcessing = ((Image) -> AnyView?)
	
	public static func defaultImageProcessing() -> ImageProcessing {
		return { image in
			return AnyView(image.resizable())
		}
	}
 
    var url: URL
    var placeholderImage: Image?
	var imageProcessing: ImageProcessing?
    
    let transitionType: ImageTransitionType

    @ObservedObject
    var remoteImage: RemoteImage = RemoteImage()
    
    public var body: some View {
        TransitioningImage(
			placeholder: placeholderImage?
				.process(with: imageProcessing),
			finalImage: remoteImage.load(url: url).image?
				.process(with: imageProcessing),
			percentageComplete: CGFloat(remoteImage.progress),
			transitionType: transitionType
		)
    }

	public init(
		url: URL,
		placeholderImage: Image? = nil,
		transition: ImageTransitionType = .none,
		imageProcessing: ImageProcessing? = RemoteImageView.defaultImageProcessing()
	) {
        self.placeholderImage = placeholderImage
        self.url = url
        self.transitionType = transition
    }
}

fileprivate extension Image {
	func process(with processing: ((Image) -> AnyView?)?) -> AnyView? {
		if let processing = processing {
			return processing(self)
		}
		
		return AnyView(self)
	}
}
