//
//  File.swift
//  
//
//  Created by Callum Trounce on 12/06/2019.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
struct TransitioningImage: View {
    
    var placeholder: Image?
    var finalImage: Image?
    
    let transitionType: (t: AnyTransition, animation: Animation)
    
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
