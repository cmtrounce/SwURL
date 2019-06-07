import XCTest
@testable import SwURL

@available(iOS 13.0, *)
final class SwURLTests: XCTestCase {
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
      
        let _ = RemoteImage.init().load(url: URL.init(string: "https://lorempixel.com/100/100/cats/")!)
        XCTAssert(true)
        
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
