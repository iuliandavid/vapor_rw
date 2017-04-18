import Vapor

let drop = Droplet()

drop.get("template") { _ in
    return try drop.view.make("hello", Node(node: ["name": "Iuli"]))
}

drop.get("template2", String.self) { _, name in
    return try drop.view.make("hello", Node(node: ["name": name]))
}

drop.get("template3") { _ in
   let users = try ["Tudor", "Alex", "Cristina"].makeNode()
    return try drop.view.make("hello2", Node(node: ["users": users]))
}

drop.get("usersAndEmails") { _ in
   let users = try [
     ["name": "Tudor", "email":"tudor@tudor.com"].makeNode(),
    ["name": "Alex", "email":"alex@ales.com"].makeNode(),
     ["name": "Andree", "email":"andree@andree.com"].makeNode()
   ].makeNode()
    return try drop.view.make("hello3", Node(node: ["users": users]))
}
drop.run()
