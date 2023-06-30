//
//  File.swift
//  
//
//  Created by Callum Trounce on 14/07/2019.
//

import Foundation

/// Manage debug settings.
public struct SwURLDebug {
    /// Enable SwURL internal logging
    public static var isLoggingEnabled = false
    
    static func log(level: LogLevel, message: String) {
        guard isLoggingEnabled else { return }
        print("[SwURLDebug \(level.label)]\n\(message)\n----------------")
        if level == .fatal {
            fatalError(message)
        }
    }
}

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
