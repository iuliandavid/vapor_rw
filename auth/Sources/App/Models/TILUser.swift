import Vapor
import Fluent
import Turnstile
/// As of this moment only for generating the hash of the password
import TurnstileCrypto

/// For Authentication
import Auth

final class TILUser: Model,User {
    /// When using a different name than the class/struct name
    static var entity = "users"
    /// Set to true if the model is retrieved from database
    var exists: Bool = false
    // Needed for conforming to Model
    var id: Node?
    /// User name with validator
    var name: Valid<NameValidator>
    /// email with validator
    var email: Valid<EmailValidator>
    /// The hash of the password
    var password: String
    
    /// Default initializer
    init(name: String, email: String, rawPassword: String) throws {
        self.id = nil
        self.name = try name.validated()
        self.email = try email.validated()
        // validate the password
        let validatedPassword: Valid<PasswordValidator> = try rawPassword.validated()
        // encrypt it
        self.password = BCrypt.hash(password: validatedPassword.value)
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        let nameString = try node.extract("name") as String
        name = try nameString.validated()
        let emailString = try node.extract("email") as String
        email = try emailString.validated()
        let passwordString = try node.extract("password") as String
        self.password = passwordString
        //try? BCrypt.verify(password: credentials.password, matchesHash: password)
    }
    
    /// Creates the database based on the name and fields passed
    public static func prepare(_ database: Database ) throws {
        try database.create("users") { userDef in 
            // Column id will take the default  model definition
            userDef.id()
            // Column ** name ** will be of type String -> Char or varchar in 
            // SQL creation
            userDef.string("name")
            // Column ** email ** will be of type String -> Char or varchar in 
            // SQL creation
            userDef.string("email")
             // Column ** password ** will be of type String -> Char or varchar in 
            // SQL creation
            userDef.string("password")
        }
    }

    /// Defines the drop database
    static func revert(_ database: Database ) throws {
        try database.delete("users")
    }

    /// Create the register function
    static func register(name: String, email: String, rawPassword: String) throws -> TILUser {
        var newUser = try TILUser(name: name, email: email, rawPassword: rawPassword)
        //test to see if the email does not already exists
        if try TILUser.query().filter("email", newUser.email.value).first() == nil {
            try newUser.save()
            return newUser
        } else {
            throw AccountTakenError()
        }
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name" : name.value,
            "email": email.value,
            "password": password
        ])
    }
}



extension TILUser {
    /// Extension to get all Acronyms for certain user
    func acronyms() throws -> [Acronym] {
        return try children(nil, Acronym.self).all()
    }
    /// Extension to get all groups for certain user
    func groups() throws -> [Group] {
        let groups: Siblings<Group> = try siblings()
        return try groups.all()
    }

}

extension TILUser: Authenticator {
    
    static func authenticate(credentials: Credentials) throws -> User {
        var user: TILUser?

        // Since we're using basic authentication we will use UsernamePassword
        switch credentials {
        case let credentials as UsernamePassword:
            let fetchedUser = try TILUser.query()
                .filter("email", credentials.username)
                .first()
            /// hash the password received and compare wiht db
            if let password = fetchedUser?.password, password != "",
                (try? BCrypt.verify(password: credentials.password, matchesHash: password)) == true {
                    user = fetchedUser
                }
          // Adding session cookie as user id
        case let credentials as Identifier: 
            user = try TILUser.find(credentials.id)
        default:
            throw UnsupportedCredentialsError()
        }
        
    if let user = user {
        log.verbose("User authenticated: \(user)")
        return user
    } else {
        throw IncorrectCredentialsError()
    }

    }


    static func register(credentials: Credentials)  throws -> User {
        throw Abort.badRequest
    }
}