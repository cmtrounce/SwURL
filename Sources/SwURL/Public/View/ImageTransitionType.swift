//
//  File.swift
//  
//
//  Created by Callum Trounce on 21/06/2023.
//

import Foundation
import SwiftUI

// Transition between placeholder content and final loaded image.
public enum ImageTransitionType {
    /// No transition, final image will be instantly presented when loaded.
    case none
    ///  Provide a custom transition between the loading state and the final image.
    ///  - Parameter transition: The `AnyTransition` to perform between placeholder content and final image. e.g. `AnyTransition.opacity`
    ///  - Parameter animation: The `Animation` to apply to the `transition`.
    ///
    ///  e.g. `custom(transition: .opacity, animation: .easeIn(duration: 2))` will fade between the placeholder content and the final image over 2 seconds.
    case custom(
        transition: AnyTransition,
        animation: Animation
    )
}
