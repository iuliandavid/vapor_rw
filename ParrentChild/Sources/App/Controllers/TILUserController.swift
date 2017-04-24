import Vapor
import HTTP

final class TILUserController: ResourceRepresentable {
    
    func makeResource() -> Resource<TILUser> {
        return Resource(
            index: index,
            store: create,
            show: show,
            modify: update,
            destroy: delete
        )
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
        return user
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
}

/// Useful for convertiong the request to an TILUser
extension Request {
    func user() throws -> TILUser {
        guard let json = json else { throw Abort.badRequest }
        return try TILUser(node: json)
    }
}