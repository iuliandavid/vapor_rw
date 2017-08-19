import Vapor
import HTTP
import VaporPostgreSQL

final class BasicController {
    
    private let droplet: Droplet

    init(drop: Droplet) {
        self.droplet = drop
    }

    func addRoutes() {
    // Adding a prefix to routes 
    let basic = droplet.grouped("basic")
    basic.get("version", handler: version)
    basic.get("model", handler: model)
    
    let api = droplet.grouped("api/v1")
    api.get("all", handler: all)
    api.get("all",Int.self, handler: findAcronymById)
    api.post("acronym", handler:new)
    api.get("first", handler:first)
    api.get("afks", handler:afks)
    api.get("not-afks", handler:notAfks)
    api.get("update", handler:update)
    api.put("update",Int.self, handler: update)
    api.delete("delete",Int.self, handler: delete)
    api.delete("acronym/delete",String.self, handler: delete)
    api.delete("acronym/del", handler: delete)
    }
    
    // MARK: - BASIC ROUTE
    func version(request: Request) throws -> ResponseRepresentable {
    if let db = droplet.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("SELECT version()")
        return try JSON(node: version)
    } else {
        return "No db connection"
    }
    }
    
    func model(request: Request) throws -> ResponseRepresentable {
    let acronym = Acronym(short: "AFK", long: "Away From Keyboard")
    return try acronym.makeJSON()
    }
    
    // MARK: - API Route
    func all(request: Request) throws -> ResponseRepresentable {
    return try JSON(node: Acronym.all().makeNode())
    }
    
    func findAcronymById(request: Request, acronymID: Int) throws -> ResponseRepresentable {
    guard let acronym = try Acronym.find(acronymID) else {
    throw Abort.notFound
    }
    return try JSON(node: acronym.makeNode())
    }


    func new(request: Request) throws -> ResponseRepresentable {
    
    var acronym  = try Acronym(node: request.json)
    try acronym.save()
    return acronym
}

func first(request: Request) throws -> ResponseRepresentable {

    return try JSON(node: Acronym.query().first()?.makeNode())
}

// Filter example
func afks(request: Request) throws -> ResponseRepresentable {
    return try JSON(node: Acronym.query().filter("short", "AFK").all().makeNode())
}

// Filter NOT example
func notAfks(request: Request) throws -> ResponseRepresentable {
    log.verbose("notAfks")
    return try JSON(node: Acronym.query().filter("short",.notEquals, "AFK").all().makeNode())
}


// First test update with query parameter
func update(request: Request) throws -> ResponseRepresentable {
    log.verbose("First test update with query parameter")
    guard var first = try Acronym.query().first(), let long = request.data["long"]?.string else {
        throw Abort.badRequest
    }

    first.long = long
    try first.save()
    return first
}

// Update with put and path parameter
func update(request: Request, acronymId: Int) throws -> ResponseRepresentable {
log.verbose("Update with put and path parameter")
    
 guard var acronym = try Acronym.find(acronymId), let json = request.json else {
    throw Abort.notFound
  }
  let short = try json.extract("short") ?? acronym.short
  let long = try json.extract("long") ?? acronym.long
  acronym.short = short
  acronym.long = long
  try acronym.save()
  return acronym
}


// Delete with ID path parameter 
func delete(request: Request, acronymId: Int) throws -> ResponseRepresentable { 
    log.verbose("Delete with ID path parameter")
 guard let acronym = try Acronym.find(acronymId) else {
    throw Abort.notFound
  }
  try acronym.delete()
  return acronym
}

// Delete with Query on path parameter
func delete(request: Request, shortAcronym: String) throws -> ResponseRepresentable { 
    log.verbose("Delete with Query on path parameter")
 let acronyms = try Acronym.query().filter("short", shortAcronym) 
  
  try acronyms.delete()

  return try JSON(node: Acronym.all().makeNode())
}

// Delete with query parameter
func delete(request: Request) throws -> ResponseRepresentable { 
    log.verbose("Delete with query parameter")

   guard let shortAcronym = request.data["filter"]?.string  else {
      throw Abort.notFound  
   }
  let acronyms = try Acronym.query().filter("short", shortAcronym) 
  
  try acronyms.delete()
  
  return try JSON(node: Acronym.all().makeNode())
}
}