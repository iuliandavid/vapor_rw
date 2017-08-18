import Vapor
import HTTP
import Fluent

final class TILUserController {
    
    
    private let droplet: Droplet

    init(droplet: Droplet) {
        self.droplet = droplet
    }
    func addRoutes() {
        let basic = droplet.grouped("users")
        basic.get(handler: index)
        basic.post(handler: create)
        basic.delete(TILUser.self, handler: delete)
        basic.get(TILUser.self, "acronyms", handler: acronymIndex)
        //adding join route to connect a TILUser to a Group
        basic.post(TILUser.self, "join", Group.self, handler: joinGroup)
        basic.get(TILUser.self, "groups", handler: groups)
    }

    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: TILUser.all().makeNode())
    }

    /// POST a new JSON containing the user
    func create(request: Request) throws -> ResponseRepresentable {
        var user = try request.user()
        try user.save()
        return user
    }

    /// Searches through the database by acronym.id, 
    /// the one passed in url path
    /// It basically does this : ** GET users/:id **
    /// ``swift 
    /// func finduserById(request: Request, userID: Int) throws -> ResponseRepresentable {
    /// guard let user = try TILUser.find(userID) else {
    /// throw Abort.notFound
    ///}
    /// `` 
    func show(request: Request, user: TILUser) throws -> ResponseRepresentable {
        /// That's why we return the directly retrieved user
        return try JSON(node: [
            "user" : user.name.value,
            "email" : user.email.value,
            "id" : user.id
        ])
    }

    /// List The Acronymns For A particular User
    func acronymIndex(request: Request, user: TILUser) throws -> ResponseRepresentable {
        let children = try user.acronyms()
        return try JSON(node: children.makeNode())
    }
   

    /// Pay attention as it issues a PATCH not a PUT
    /// ** PATCH users/:id **
    func update(request: Request, user: TILUser) throws -> ResponseRepresentable  {
        ///Get the updates
        let new = try request.user()
        /// Get the user to be updated ** see show **
        var user = user
        user.name = new.name
        user.email = new.email
        user.password = new.password
        try user.save()
        return user
    }
    
    func delete(request: Request, user: TILUser) throws -> ResponseRepresentable {
        try user.delete()
        return JSON([:])
    }

    /// MARK: Sibling relation
    func joinGroup(request:Request, user: TILUser, group: Group) throws -> ResponseRepresentable {
        var pivot = Pivot<TILUser, Group>(user, group)
        try pivot.save()
        return try JSON(node: user.groups())
    }

    /// MARK: Sibling relation
    func groups(request:Request, user: TILUser) throws -> ResponseRepresentable {
        return try JSON(node: user.groups())
    }
}

/// Useful for convertiong the request to an TILUser
extension Request {
    func user() throws -> TILUser {
        guard let json = json else { throw Abort.badRequest }
        return try TILUser(node: json)
    }
}