//
//  SwURLExampleApp.swift
//  SwURLExample
//
//  Created by Callum Trounce on 20/06/2023.
//

import SwiftUI
import SwURL

@main
struct SwURLExampleApp: App {
    init() {
        SwURLDebug.loggingEnabled = true
    }
    
    var body: some Scene {
        WindowGroup {
            ListView()
        }
    }
}
