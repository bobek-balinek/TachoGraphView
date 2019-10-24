import XCTest
@testable import TachoGraphView

final class TachoGraphViewTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TachoGraphView(frame: .zero).segments.count, 0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
