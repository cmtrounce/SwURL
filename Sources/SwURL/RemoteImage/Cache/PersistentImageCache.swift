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

@available(iOS 13.0, *)
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
                    print("UNABLE TO RETRIEVE IMAGE DATA FOR URL: ", url)
                    return
                }

                if !self.fileManager.fileExists(atPath: directory.absoluteString) {
                    self.fileManager.createFile(atPath: directory.absoluteString, contents: data, attributes: nil)
                }
                
                try data.write(to: directory)
            } catch {
                print("UNABLE TO STORE IMAGE: ", error.localizedDescription)
            }
        }
    }
    
    public func image(for url: URL) -> Publishers.Future<CGImage, ImageLoadError> {
      
        return Publishers.Future<CGImage, ImageLoadError>.init { [weak self] seal in
            guard let self = self else {
                seal(.failure(.loaderDeallocated))
                return
            }
            
            do {
                let path = try self.storageURL(for: url)
                guard self.fileManager.fileExists(atPath: path.absoluteString) else {
                    seal(.failure(.imageNotFound))
                    return
                }
                
                let data = try Data(contentsOf: path)
                guard let provider = CGDataProvider.init(data: data as CFData), let image = CGImage.init(pngDataProviderSource: provider,
                                                                                                         decode: nil,
                                                                                                         shouldInterpolate: false,
                                                                                                         intent: .defaultIntent) else {
                    seal(.failure(.invalidImageData))
                    return
                }
                seal(.success(image))
            } catch {
                seal(.failure(.generic(underlying: error)))
            }
        }
    }
}


@available(iOS 13.0, *)
private extension PersistentImageCache {
    
    func storageURL(for imageURL: URL) throws -> URL {
        return try FileManager
            .cachesDir()
            .appendingPathComponent(imageURL.lastPathComponent)
    }
    
}

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

