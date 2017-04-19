import Vapor
import HTTP

final class TILController {
    private let droplet: Droplet

    init(droplet: Droplet) {
        self.droplet = droplet
    }
    func addRoutes() {
        droplet.get("til", handler: index)
    }

    func index(request: Request) throws -> ResponseRepresentable {
        let acronyms = try Acronym.all().makeNode()
        let parameters = try Node(node: [
            "acronyms" : acronyms,
        ])
        return try droplet.view.make("index", parameters)
    }
}