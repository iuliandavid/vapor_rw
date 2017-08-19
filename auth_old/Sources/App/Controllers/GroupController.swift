import Vapor
import HTTP

final class GroupController {
    
    
    private let droplet: Droplet

    init(droplet: Droplet) {
        self.droplet = droplet
    }
    func addRoutes() {
        let basic = droplet.grouped("groups")
        basic.get(handler: index)
        basic.post(handler: create)
        basic.delete(Group.self, handler: delete)
        basic.get(Group.self, "users", handler: usersIndex)
        
    }

    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Group.all().makeNode())
    }

    /// POST a new JSON containing the group
    func create(request: Request) throws -> ResponseRepresentable {
        var group = try request.group()
        try group.save()
        return group
    }

    /// Searches through the database by group.id, 
    /// the one passed in url path
    /// It basically does this : ** GET groups/:id **
    /// ``swift 
    /// func findgroupById(request: Request, groupID: Int) throws -> ResponseRepresentable {
    /// guard let group = try Group.find(groupID) else {
    /// throw Abort.notFound
    ///}
    /// `` 
    func show(request: Request, group: Group) throws -> ResponseRepresentable {
        /// That's why we return the directly retrieved group
        return try JSON(node: [
            "group" : group.name.value,
            "id" : group.id
        ])
    }

    

    /// Pay attention as it issues a PATCH not a PUT
    /// ** PATCH groups/:id **
    func update(request: Request, group: Group) throws -> ResponseRepresentable  {
        ///Get the updates
        let new = try request.group()
        /// Get the group to be updated ** see show **
        var group = group
        group.name = new.name
        try group.save()
        return group
    }
    
    func delete(request: Request, group: Group) throws -> ResponseRepresentable {
        try group.delete()
        return JSON([:])
    }

    /// Get all users from the seleceted group
    func usersIndex(request: Request, group: Group) throws -> ResponseRepresentable {
        return try JSON(node: group.users())
    }
}

/// Useful for converting the request to an Group
extension Request {
    func group() throws -> Group {
        guard let json = json else { throw Abort.badRequest }
        return try Group(node: json)
    }
}