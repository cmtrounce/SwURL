//
//  File.swift
//  
//
//  Created by Callum Trounce on 14/07/2019.
//

import Foundation

enum LogLevel {
    case info
    case warning
    case error
    case fatal
    
    var label: String {
        switch self {
            
        case .info:
            return "INFO ℹ️"
        case .warning:
            return "WARNING ⚠️"
        case .error:
            return "ERROR 🚨"
        case .fatal:
            return "FATAL ☢️"
        }
    }
}

public struct SwURLDebug {
    
    public static var loggingEnabled = false
    
    static func log(level: LogLevel, message: String) {
        guard loggingEnabled else { return }
        print("[SwURLDebug \(level.label)]\n\(message)\n----------------")
        if level == .fatal {
            fatalError(message)
        }
    }
    
}
