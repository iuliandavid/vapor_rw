import XCTest
@testable import App
@testable import Vapor
@testable import HTTP
@testable import VaporPostgreSQL
@testable import validationTests


class AppTests: XCTestCase {
    static let allTests: [(String, (AppTests) -> () throws -> Void)] = [
        ("testMyEmailValidator", testMyEmailValidator)
    ]
    
    func testMyEmailValidator() {
        //let failed: Valid<EmailValidator>? = try? "a*cd".validated()
        // XCTAssert(failed == nil)
        let acronym = Acronym(short: "AFK", long: "Away From Keyboard")
       // let response:ResponseRepresentable? = try? acronym.makeJSON()
       // XCTAssert(response != nil)
    }
}
