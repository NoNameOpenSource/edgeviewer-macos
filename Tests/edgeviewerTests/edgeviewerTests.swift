import XCTest
@testable import edgeviewer

class edgeviewerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(edgeviewer().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
