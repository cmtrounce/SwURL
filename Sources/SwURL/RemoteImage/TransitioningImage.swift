//
//  File.swift
//  
//
//  Created by Callum Trounce on 12/06/2019.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public typealias TransitionType = (t: AnyTransition, animation: Animation)

@available(iOS 13.0, *)
struct TransitioningImage: View {
    
    var placeholder: Image?
    var finalImage: Image?
    
    let transitionType: TransitionType
    
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
