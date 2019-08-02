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

@available(iOS 13.0, *)
class RemoteImage: BindableObject {

    var willChange = PassthroughSubject<Image?, Never>()

    typealias PublisherType = PassthroughSubject<Image?, Never>

    var request: Cancellable?

    var image: Image? = nil {
        willSet {
            guard image == nil else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.willChange.send(self.image)
            }
        }
    }
    
    func load(url: URL) -> Self {
        DispatchQueue.global(qos: .userInitiated)
            .async { [unowned self] in
                
            self.request = ImageLoader.shared.load(url: url)
                .map { cgImage -> Image in
                    SwURLDebug.log(level: .info, message: "Image successfully retrieved from url: " + url.absoluteString)
                    return Image.init(cgImage,
                                      scale: 1,
                                      label: Text(url.lastPathComponent))
                }.catch { error -> Just<Image?>  in
                    SwURLDebug.log(level: .warning, message: "Failed to load image from url: " + url.absoluteString + "\nReason: " + error.localizedDescription)
                    return .init(nil)
                }.eraseToAnyPublisher()
                .assign(to: \RemoteImage.image, on: self)
        }
        
        return self
    }
}
