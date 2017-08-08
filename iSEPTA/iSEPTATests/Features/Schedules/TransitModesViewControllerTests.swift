// Septa. 2017

// SEPTA.org, created on 8/7/2017.

import XCTest
@testable import Septa

/// TransitModesViewControllerTests purpose: Testing functionality of toolbar and tableview
class TransitModesViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAsyncCalback() {

        let expectation = self.expectation(description: "myExpectation")
        DispatchQueue.main.async {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}