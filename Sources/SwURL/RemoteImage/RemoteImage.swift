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

    var didChange = PassthroughSubject<Image?, Never>()

    typealias PublisherType = PassthroughSubject<Image?, Never>

    var request: Cancellable?
    
    var image: Image? = nil {
        willSet {
            guard image == nil else { return }
            self.didChange.send(self.image)
        }
    }
    
    func load(url: URL) -> Self {
        request = ImageLoader.shared.load(url: url).map { cgImage -> Image in
            Image.init(cgImage, scale: 1, label: Text(url.lastPathComponent))
        }
        .assign(to: \RemoteImage.image, on: self)
        

        return self
    }
}
