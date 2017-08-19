import Vapor
import HTTP


final class TILController {
    private let droplet: Droplet

    init(droplet: Droplet) {
        self.droplet = droplet
    }
    func addRoutes() {
        let til = drop.grouped("til")
        til.get(handler: index)
        til.post(handler: addNew)
        til.post(Acronym.self, "delete", handler: delete)
        // register the view
        til.get("register", handler: registerView)
        til.post("register", handler: register)
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

        var acronym  = Acronym(short: short, long: long)
        try acronym.save()
        return Response(redirect: "/til")
    }


    // Delete with ID path parameter 
    func delete(request: Request, acronym: Acronym) throws -> ResponseRepresentable { 
        try acronym.delete()
    return Response(redirect: "/til")
    }


    // Add the register view
    func registerView(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("register")
    }

    // The POST to make when registering the user
    func register(request: Request) throws -> ResponseRepresentable {
        // We use formURLEncoded because the data wiil be sent from html form
        guard let email = request.formURLEncoded?["email"]?.string, let password = request.formURLEncoded?["password"]?.string,let name = request.formURLEncoded?["name"]?.string else {
            return "Missing email, password, or name"
        }

        _ = try TILUser.register(name: name, email: email, rawPassword: password)
        return Response(redirect: "/users")
    }
}