#if os(Linux)
import XCTest
@testable import AppTests

XCTMain([
    // Validation
    testCase(AppTests.allTests)
])
#endif
