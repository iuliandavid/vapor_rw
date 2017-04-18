import Vapor

final class Acronym: Model {
    // Needed for conforming to Model
    var id: Node?
    /// Acronym name: e.g.: AFK
    var short: String
    /// Acronym meaning: e.g. : Away From Keyboard
    var long: String
    /// Set to true if the model is retrieved from database
    var exists: Bool = false
    /// Default initializer
    init(short: String, long: String) {
        self.id = nil
        self.long = long
        self.short = short   
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        short = try node.extract("short")
        long = try node.extract("long")
    }
    /// Creates the database based on the name and fields passed
    public static func prepare(_ database: Database ) throws {
        try database.create("acronyms") { acronymDef in 
            // Column id will take the default  model definition
            acronymDef.id()
            // Column ** short ** will be of type String -> Char or varchar in 
            // SQL creation
            acronymDef.string("short")
            // Column ** long ** will be of type String -> Char or varchar in 
            // SQL creation
            acronymDef.string("long")
        }
    }

    /// Defines the drop database
    static func revert(_ database: Database ) throws {
        try database.delete("acronyms")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "short" : short,
            "long": long
        ])
    }
}