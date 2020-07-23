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
	public typealias ImageProcessing = ((Image) -> Image)
	
	public static func defaultImageProcessing() -> ImageProcessing {
		return { image in
			return image.resizable()
		}
	}
 
    var url: URL
    var placeholderImage: Image?
	var imageProcessing: ImageProcessing?
    
    let transitionType: ImageTransitionType

    @ObservedObject
	var remoteImage: RemoteImage = RemoteImage()
	var image: Image? {
		switch remoteImage.imageStatus {
		case .complete(let result):
			return Image.init(
				result,
				scale: 1,
				label: Text("Image")
			)
		case .progress:
			return nil
		}
	}
	
	var progress: Float {
		switch remoteImage.imageStatus {
		case .complete:
			return 1.0
		case .progress(let fraction):
			return fraction
		}
	}
	
    public var body: some View {
        TransitioningImage(
			placeholder: placeholderImage.process(with: imageProcessing),
			finalImage: image.process(with: imageProcessing),
			percentageComplete: CGFloat(progress),
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
		self.imageProcessing = imageProcessing
		remoteImage.load(url: url)
    }
}

fileprivate extension Optional where Wrapped == Image {
	func process(with processing: ((Image) -> Image)?) -> AnyView {
		switch self {
		case .none:
			return AnyView(EmptyView())
		case .some(let image):
			if let processing = processing {
				return AnyView(processing(image))
			}
			
			return AnyView(image)
		}
	}
}
