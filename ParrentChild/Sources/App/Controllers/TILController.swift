import Vapor
import HTTP


final class TILController {
    private let droplet: Droplet

    init(droplet: Droplet) {
        self.droplet = droplet
    }
    func addRoutes() {
        droplet.get("til", handler: index)
        droplet.post("til", handler: addNew)
        droplet.post("til", Acronym.self, "delete", handler: delete)
    }

    func index(request: Request) throws -> ResponseRepresentable {
        let acronyms = try Acronym.all().makeNode()
        let parameters = try Node(node: [
            "acronyms" : acronyms,
        ])
        return try droplet.view.make("index", parameters)
    }

    func addNew(request: Request) throws -> ResponseRepresentable {
        guard let short = request.data["short"]?.string, let long = request.data["long"]?.string else {
            throw Abort.badRequest
        }

        var acronym  = try Acronym(short: short, long: long)
        try acronym.save()
        return Response(redirect: "/til")
    }


    // Delete with ID path parameter 
    func delete(request: Request, acronym: Acronym) throws -> ResponseRepresentable { 
        try acronym.delete()
    return Response(redirect: "/til")
    }
}