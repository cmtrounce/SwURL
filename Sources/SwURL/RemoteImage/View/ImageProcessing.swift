//
//  ImageProcessing.swift
//  SwURL
//
//  Created by Callum Trounce on 18/08/2021.
//

import Foundation
import SwiftUI

enum ImageProcessing {
    public static func `default`() -> ((Image) -> AnyView) {
        return { image in
            return AnyView(image.resizable())
        }
    }
}

extension Optional where Wrapped == Image {
    func process(with processing: ((Image) -> AnyView)?) -> AnyView {
        switch self {
        case .none:
            return AnyView(EmptyView())
        case .some(let image):
            if let processing = processing {
                return AnyView(processing(image))
            }
            
            return AnyView(image)
        }
    }
}
