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
	fileprivate var _imageProcessing: ((Image) -> AnyView)
    
    let transitionType: ImageTransitionType

    @ObservedObject
	private var remoteImage: RemoteImage = RemoteImage()
	
    public var body: some View {
        TransitioningImage(
			placeholder: placeholderImage.process(with: _imageProcessing),
			finalImage: remoteImage.image.process(with: _imageProcessing),
			percentageComplete: CGFloat(remoteImage.progress),
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
		self._imageProcessing = RemoteImageView.defaultImageProcessing()
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
