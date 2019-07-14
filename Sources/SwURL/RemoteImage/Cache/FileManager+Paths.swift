//
//  File.swift
//  
//
//  Created by Callum Trounce on 14/07/2019.
//

import Foundation

extension FileManager {
    
    class func cachesDir() -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return URL.init(string: paths[0])!
    }
    
}
