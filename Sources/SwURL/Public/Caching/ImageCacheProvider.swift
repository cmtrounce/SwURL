//
//  File.swift
//  
//
//  Created by Callum Trounce on 14/07/2019.
//

import Foundation
import Combine
import CoreGraphics

/// Provide a custom implementation for retrieval and storage of downloaded images.
public protocol ImageCacheProvider {
    /// Store image for a given URL.
    /// - Parameters:
    ///   - image: The downloaded image.
    ///   - url: The URL used to retrieve the image.
    func store(image: CGImage, for url: URL)
    /// Retrieve a stored image for the given URL
    /// - Parameter url: The URL for the image resource
    /// - Returns: The request for the image.
    func image(for url: URL) -> Future<CGImage, Error>
}
