//
//  File.swift
//  
//
//  Created by Callum Trounce on 14/07/2019.
//

import Foundation

extension FileManager {
    class func cachesDir() -> URL {
        if let savedPath = UserDefaults.standard.url(forKey: "SwURLCacheDestinationDirectory") {
            return savedPath
        } else {
            let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
            let path = paths[0]
            let url = URL.init(fileURLWithPath: path)
            UserDefaults.standard.set(url, forKey: "SwURLCacheDestinationDirectory")
            return url
        }
    }
}
