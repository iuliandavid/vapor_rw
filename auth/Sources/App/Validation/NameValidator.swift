import Vapor

class NameValidator: ValidationSuite {

    static func validate(input value: String) throws {

        try Count.containedIn(low: 6, high: 64).validate(input: value)
        // Password should contain at least 1 number and at least one upperCase character
        let range = value.range(of: "^[a-z ,.'-]+$", options: [.regularExpression, .caseInsensitive])

        guard let _ = range else {
            throw error(with: value)
        }
        // // let evaluation = Email.self && Count.containedIn(low: 6, high: 64)
        // let evaluation = Email.self && Count.min(6) && Count.max(64)
        // try evaluation.validate(input: value)
    }
}