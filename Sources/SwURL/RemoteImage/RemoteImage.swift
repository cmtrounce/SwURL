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
	case pending
	case complete(result: CGImage)
	case progress(fraction: Float)
}

class RemoteImage: ObservableObject {
	@Published var imageStatus: RemoteImageStatus = .pending
	
	private var request: Cancellable?
	
	@discardableResult
	func load(url: URL) -> Self {
		imageStatus = .progress(fraction: 0)
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

extension RemoteImage {
	var image: Image? {
		switch imageStatus {
		case .complete(let result):
			return Image.init(
				result,
				scale: 1,
				label: Text("Image")
			)
		case .progress, .pending:
			return nil
		}
	}
	
	var progress: Float {
		switch imageStatus {
		case .pending:
			return 0
		case .complete:
			return 1.0
		case .progress(let fraction):
			return fraction
		}
	}
	
	var shouldRequestLoad: Bool {
		switch imageStatus {
		case .pending:
			return true
		default:
			return false
		}
	}
}
