//
//  RemoteImage.swift
//  Landmarks
//
//  Created by Callum Trounce on 06/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

enum RemoteImageStatus {
	case complete(result: CGImage)
	case progress(fraction: Float)
}

class RemoteImage: ObservableObject {
	@Published var imageStatus: RemoteImageStatus = .progress(fraction: 0)

	var request: Cancellable?
	
	var image: Image? {
		guard case let .complete(image) = imageStatus else {
			return nil
		}
		return Image.init(
			image,
			scale: 1,
			label: Text("Image")
		)
	}
	
	var progress: Float {
		guard case let .progress(fraction) = imageStatus else {
			return 0
		}
		return fraction
	}
	
	func load(url: URL) -> Self {
		request = ImageLoader.shared.load(url: url).catch { error -> Just<RemoteImageStatus> in
			SwURLDebug.log(
				level: .warning,
				message: "Failed to load image from url: " + url.absoluteString + "\nReason: " + error.localizedDescription
			)
			return .init(.progress(fraction: 0))
		}
		.eraseToAnyPublisher()
		.receive(on: DispatchQueue.main)
		.assign(to: \RemoteImage.imageStatus, on: self)
		return self
	}
}
