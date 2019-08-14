//
//  File.swift
//  
//
//  Created by Callum Trounce on 12/06/2019.
//

import Foundation
import SwiftUI


struct TransitioningImage: View {
    
    var placeholder: Image?
    var finalImage: Image?
    
    let transitionType: ImageTransitionType
    
    public var body: some View {
        ZStack {
            if finalImage == nil {
                placeholder?
                    .transition(transitionType.t)
                    .animation(transitionType.animation)
            }
            
            finalImage?
                .transition(transitionType.t)
                .animation(transitionType.animation)
        }
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
