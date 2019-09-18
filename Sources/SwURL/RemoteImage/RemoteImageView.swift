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
    
    let transitionType: ImageTransitionType

    @ObservedObject
    var remoteImage: RemoteImage = RemoteImage()
    
    public var body: some View {
        TransitioningImage.init(
			placeholder: placeholderImage?.resizable(),
			finalImage: remoteImage.load(url: url).image?.resizable(),
			transitionType: transitionType
		)
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
