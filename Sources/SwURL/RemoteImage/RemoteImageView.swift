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
	public static func defaultImageProcessing() -> ((Image) -> AnyView) {
		return { image in
			return AnyView(image.resizable())
		}
	}
 
    var url: URL
    var placeholderImage: Image?
	fileprivate var _imageProcessing: ((Image) -> AnyView) = RemoteImageView.defaultImageProcessing()
    
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
			placeholder: placeholderImage.process(with: _imageProcessing),
			finalImage: image.process(with: _imageProcessing),
			percentageComplete: CGFloat(progress),
			transitionType: transitionType
		).onAppear {
			self.remoteImage.load(url: self.url)
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
    }
}

public extension RemoteImageView {
	func imageProcessing<ProcessedImage: View>(
		_ processing: @escaping (Image) -> ProcessedImage
	) -> some View {
		var mut = self
		mut._imageProcessing = { image in
			return AnyView(processing(image))
		}
		return mut
	}
}

fileprivate extension Optional where Wrapped == Image {
	func process(with processing: ((Image) -> AnyView)?) -> AnyView {
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
