//
//  File.swift
//  
//
//  Created by Callum Trounce on 14/07/2019.
//

import Foundation
import CoreGraphics
import CoreImage
import Combine


public class PersistentImageCache: ImageCacheType {
    
    /// Specific queue to assist with concurrency.
    private let queue = DispatchQueue.init(label: "cacheQueue", qos: .userInteractive)
    
    private let fileManager = FileManager.default
    
    private let cachesDirectory = FileManager.cachesDir()

    public func store(image: CGImage, for url: URL) {
      
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                let directory = try self.storageURL(for: url)
                guard let data = image.dataRepresentation else {
                    SwURLDebug.log(level: .error, message: "UNABLE TO RETRIEVE IMAGE DATA FOR URL: " + url.absoluteString)
                    return
                }

                if !self.fileManager.fileExists(atPath: directory.absoluteString) {
                    self.fileManager.createFile(atPath: directory.absoluteString, contents: data, attributes: nil)
                }
                
                try data.write(to: directory)
				SwURLDebug.log(level: .info, message: "Image for resource at " + url.absoluteString + " was stored to " + directory.absoluteString)
            } catch {
                SwURLDebug.log(level: .error, message: "UNABLE TO STORE IMAGE: " + error.localizedDescription)
            }
        }
    }
    
    public func image(for url: URL) -> Future<CGImage, ImageLoadError> {
        
        return Future<CGImage, ImageLoadError>.init { [weak self] seal in
            guard let self = self else {
                seal(.failure(.loaderDeallocated))
                return
            }
            
            do {
                let path = try self.storageURL(for: url)
				let data = try Data(contentsOf: path)
				guard
					let provider = CGDataProvider.init(data: data as CFData),
					let image = CGImage.init(
						pngDataProviderSource: provider,
						decode: nil,
						shouldInterpolate: false,
						intent: .defaultIntent
					) else {
						seal(.failure(.invalidImageData))
						return
				}
				
				SwURLDebug.log(level: .info, message: "Image found in persistent cache for resource at URL: " + url.absoluteString)
				seal(.success(image))
			} catch {
				SwURLDebug.log(level: .info, message: "Image not found in persistent cache for resource at URL: " + url.absoluteString)
                seal(.failure(.generic(underlying: error)))
            }
        }
    }
}



private extension PersistentImageCache {
    
    func storageURL(for imageURL: URL) throws -> URL {
        return FileManager
            .cachesDir()
            .appendingPathComponent(imageURL.lastPathComponent)
    }
    
}
