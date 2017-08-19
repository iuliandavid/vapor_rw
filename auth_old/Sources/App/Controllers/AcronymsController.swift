import Vapor
import HTTP

final class AcronymsController{
    
    private let droplet: Droplet

    init(droplet: Droplet) {
        self.droplet = droplet
    }
    func addRoutes() {
        let basic = droplet.grouped("acronyms")
        basic.get(handler: index)
        basic.get(Acronym.self, handler: show)
        basic.post(handler: create)
        basic.delete(Acronym.self, handler: delete)
        basic.patch(Acronym.self, handler: update)
        basic.get(Acronym.self, "user", handler: userIndex)
        
    }

    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Acronym.all().makeNode())
    }

    /// POST a new JSON containing the acronym
    func create(request: Request) throws -> ResponseRepresentable {
        var acronym = try request.acronym()
        try acronym.save()
        return acronym
    }

    /// Searches through the database by acronym.id, 
    /// the one passed in url path
    /// It basically does this : ** GET acronyms/:id **
    /// ``swift 
    /// func findAcronymById(request: Request, acronymID: Int) throws -> ResponseRepresentable {
    /// guard let acronym = try Acronym.find(acronymID) else {
    /// throw Abort.notFound
    ///}
    /// `` 
    func show(request: Request, acronym: Acronym) throws -> ResponseRepresentable {
        /// That's why we return the directly retrieved acronym
        return acronym
    }
   

    /// Pay attention as it issues a PATCH not a PUT
    /// ** PATCH acronyms/:id **
    func update(request: Request, acronym: Acronym) throws -> ResponseRepresentable  {
        ///Get the updates
        let new = try request.acronym()
        /// Get the acronym to be updated ** see show **
        var acronym = acronym
        acronym.short = new.short
        acronym.long = new.long
        try acronym.save()
        return acronym
    }
    
    func delete(request: Request, acronym: Acronym) throws -> ResponseRepresentable {
        try acronym.delete()
        return JSON([:])
    }

    /// List The User For A particular Acronym
    func userIndex(request: Request, acronym: Acronym) throws -> ResponseRepresentable {
        let parrent = try acronym.user()
        return try JSON(node: parrent?.makeNode())
    }
}

/// Useful for converting the request to an Acronym
extension Request {
    func acronym() throws -> Acronym {
        guard let json = json else { throw Abort.badRequest }
        return try Acronym(node: json)
    }
}