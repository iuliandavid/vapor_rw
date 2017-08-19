import Vapor

let drop = Droplet()


drop.get { request in
    return try JSON(node: [
      "message" : "Hello Iuli from Vapor"
    ])
}

drop.get("iulis") { request in
    return try JSON(node: [
      "message" : "This is NEW"
    ])
}

drop.get("iulis", "there") { request in
    return try JSON(node: [
      "message" : "Too many hellos"
    ])
}

drop.get("beers", Int.self) { request, beers in
    return try JSON(node: [
      "Number of beers drank" : "\(beers)"
    ])
}

drop.post("post") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    return try JSON(node: [
      "Hello" : "\(name)"
    ])
}

drop.run()
