import Vapor

final class TILUser: Model {
    /// Set to true if the model is retrieved from database
    var exists: Bool = false
    // Needed for conforming to Model
    var id: Node?
    /// User name with validator
    var name: Valid<NameValidator>
    /// email with validator
    var email: Valid<EmailValidator>
    /// password with validator
    var password: Valid<PasswordValidator>
    
    /// Default initializer
    init(name: String, email: String, password: String) throws {
        self.id = nil
        self.name = try name.validated()
        self.email = try email.validated()
        self.password = try password.validated()
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        let nameString = try node.extract("name") as String
        name = try nameString.validated()
        let emailString = try node.extract("email") as String
        email = try emailString.validated()
        let passwordString = try node.extract("password") as String
        password = try passwordString.validated()
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

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name" : name.value,
            "email": email.value,
            "password": password.value
        ])
    }
}