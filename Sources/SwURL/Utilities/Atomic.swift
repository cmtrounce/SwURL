//
//  Atomic.swift
//  SwURL
//
//  Created by Callum Trounce on 04/08/2021.
//

import Foundation

@propertyWrapper
final class Atomic<Value> {
    private var value: Value
    private let queue = DispatchQueue(
        label: "SWURL.propertyWrapper.atomic" + UUID().uuidString,
        qos: .userInitiated,
        attributes: .concurrent
    )
  
    var wrappedValue: Value {
        get {
            queue.sync {
                value
            }
        }
        set {
            queue.async(flags: .barrier) {
                self.value = newValue
            }
        }
    }
    
    init(wrappedValue value: Value) {
        self.value = value
    }
}
