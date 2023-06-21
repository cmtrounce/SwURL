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
    var loadingIndicator: AnyView?
    
    let transitionType: ImageTransitionType
    
    public var body: some View {
        withAnimation {
            ZStack {
                if finalImage == nil {
                    placeholder
                        .transition(transitionType.t)
                        .animation(transitionType.animation)
                    
                    loadingIndicator
                }
                
                finalImage?
                    .transition(transitionType.t)
                    .animation(transitionType.animation)
            }
        }
    }
}

// MARK: - ImageTransitionType helpers.

extension ImageTransitionType {
    fileprivate var t: AnyTransition {
        switch self {
        case .custom(let transition, _):
            return transition
        case .none:
            return .identity
        }
    }
    
    fileprivate var animation: Animation? {
        switch self {
        case .custom(_, let animation):
            return animation
        case .none:
            return nil
        }
    }
}
