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

enum RemoteImageStatus: Equatable {
	case complete(result: CGImage)
	case progress(fraction: Float)
}

class RemoteImage: ObservableObject {
	@Published var imageStatus: RemoteImageStatus = .progress(fraction: 0)
	
	var request: Cancellable?
	
	@discardableResult
	func load(url: URL) -> Self {
		request = ImageLoader.shared
			.load(url: url).catch { error -> Just<RemoteImageStatus> in
				SwURLDebug.log(
					level: .warning,
					message: "Failed to load image from url: " + url.absoluteString + "\nReason: " + error.localizedDescription
				)
				return .init(.progress(fraction: 0))
		}
		.eraseToAnyPublisher()
		.subscribe(on: DispatchQueue.global(qos: .userInitiated))
		.receive(on: DispatchQueue.main)
		.sink(receiveCompletion: { completion in
			switch completion {
			case .finished:
				SwURLDebug.log(
					level: .info,
					message: "ImageLoader.load observable request did finish"
				)
			}
		}, receiveValue: { [weak self] value in
			self?.imageStatus = value
		})

		return self
	}
}
