//
//  File.swift
//  
//
//  Created by Callum Trounce on 14/07/2019.
//

import Foundation
import CoreGraphics
import CoreImage

extension CGImage {
    var dataRepresentation: Data? {
        if let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil) {
            CGImageDestinationAddImage(destination, self, nil)
            if CGImageDestinationFinalize(destination) {
                let data = mutableData as Data
                return data
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
