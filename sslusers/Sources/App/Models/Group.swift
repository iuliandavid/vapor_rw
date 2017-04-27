/// Model class for a group
/// A user may be in one or many groups
import Vapor
import Fluent

final class Group: Model {
    /// When using a different name than the class/struct name
    static var entity = "groups"
    /// Set to true if the model is retrieved from database
    var exists: Bool = false
    // Needed for conforming to Model
    var id: Node?
    /// Group name with validator
    /// Can be GAMERS or BIKERS
    var name: Valid<NameValidator>
   
    
    /// Default initializer
    init(name: String) throws {
        self.id = nil
        self.name = try name.validated()
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        let nameString = try node.extract("name") as String
        name = try nameString.validated()
    }
    
    /// Creates the database based on the name and fields passed
    public static func prepare(_ database: Database ) throws {
        try database.create("groups") { groupDef in 
            // Column id will take the default  model definition
            groupDef.id()
            // Column ** name ** will be of type String -> Char or varchar in 
            // SQL creation
            groupDef.string("name")
        }
    }

    /// Defines the drop database
    static func revert(_ database: Database ) throws {
        try database.delete("groups")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name" : name.value
        ])
    }
}

/// Extension to get all Users for certain group
extension Group {
    func users() throws -> [TILUser] {
        let users: Siblings<TILUser> = try siblings()
        return try users.all()
    }
}