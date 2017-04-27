import Vapor

class EmailValidator: ValidationSuite {

    static func validate(input value: String) throws {
        // let evaluation = Email.self && Count.containedIn(low: 6, high: 64)
        let evaluation = Email.self && Count.min(6) && Count.max(64)
        try evaluation.validate(input: value)
    }
}