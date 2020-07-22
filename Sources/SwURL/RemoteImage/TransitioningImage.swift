//
//  File.swift
//  
//
//  Created by Callum Trounce on 12/06/2019.
//

import Foundation
import SwiftUI

struct TransitioningImage: View {
    var placeholder: AnyView?
    var finalImage: AnyView?
	
	let percentageComplete: CGFloat
    let transitionType: ImageTransitionType
	
	var viewToUse: AnyView? {
		if let finalImage = finalImage {
			return finalImage
		} else {
			return placeholder ?? AnyView(EmptyView())
		}
	}
	
	public var body: some View {
		self.viewToUse
			.transition(self.transitionType.t)
			.animation(self.transitionType.animation)
	}
}


public enum ImageTransitionType {
    case custom(transition: AnyTransition, animation: Animation)
    case none
    
    var t: AnyTransition {
        switch self {
        case .custom(let transition, _):
            return transition
        case .none:
            return .identity
        }
    }
    
    var animation: Animation? {
        switch self {
        case .custom(_, let animation):
            return animation
        case .none:
            return nil
        }
    }
}
