import Vapor

import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations.append(Acronym.self)

drop.get("version") { request in
    if let db = drop.database?.driver as? PostgreSQLDriver {
      let version = try db.raw("SELECT version()")
      return try JSON(node: version)
    } else {
      return "No db connection"
    }
    
}

drop.get("model") { request in
    let acronym = Acronym(short: "AFK", long: "Away From Keyboard")
    return try acronym.makeJSON()
}


drop.get("acronyms") { request in 
    return try JSON(node: Acronym.all().makeNode())
}

drop.get("acronyms", Int.self) { request, acronymID in 
    guard let acronym = try Acronym.find(acronymID) else {
    throw Abort.notFound
  }
    return try JSON(node: acronym.makeNode())
}

drop.post("acronym") { request in
    var acronym  = try Acronym(node: request.json)
    try acronym.save()
    return acronym
}

drop.get("first") { request in
    return try JSON(node: Acronym.query().first()?.makeNode())
}

// Filter example
drop.get("afks") { request in 
    return try JSON(node: Acronym.query().filter("short", "AFK").all().makeNode())
}

// Filter example
drop.get("not-afks") { request in 
    return try JSON(node: Acronym.query().filter("short",.notEquals, "AFK").all().makeNode())
}


// First test update
drop.get("update") { request in
    guard var first = try Acronym.query().first(), let long = request.data["long"]?.string else {
        throw Abort.badRequest
    }

    first.long = long
    try first.save()
    return first
}

// Update with put
drop.put("acronym", Int.self) { request, acronymId in
    
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


// Delete with delete
drop.delete("acronym", Int.self) { request, acronymId in
    
 guard var acronym = try Acronym.find(acronymId) else {
    throw Abort.notFound
  }
  try acronym.delete()
  return acronym
}

// Delete with delete
drop.delete("acronym/delete", String.self) { request, shortAcronym in
    
 var acronyms = try Acronym.query().filter("short", shortAcronym) 
  
  try acronyms.delete()

  return try JSON(node: Acronym.all().makeNode())
}

// Delete with delete
drop.delete("acronym/del") { request in

   guard let shortAcronym = request.data["filter"]?.string  else {
      throw Abort.notFound  
   }
 var acronyms = try Acronym.query().filter("short", shortAcronym) 
  
  try acronyms.delete()
  
  return try JSON(node: Acronym.all().makeNode())
}

drop.run()
