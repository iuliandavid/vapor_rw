import Vapor

class PasswordValidator: ValidationSuite {

    static func validate(input value: String) throws {
        // Password should contain at least 1 number and at least one upperCase character
        let range = value.range(of: "^(?=.*[0-9])(?=.*[A-Z])", options: .regularExpression)

        guard let _ = range else {
            throw error(with: value)
        }
        // let evaluation = Email.self && Count.containedIn(low: 6, high: 64)
        
        try value.validated(by: Count.min(6) && Count.max(64)) 
    }
}