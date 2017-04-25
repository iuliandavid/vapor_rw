import Foundation
import Vapor
import VaporPostgreSQL
import SwiftyBeaverVapor
import SwiftyBeaver

let drop = Droplet()


// set-up SwiftyBeaver logging destinations (console, file, cloud, ...)
// learn more at http://bit.ly/2ci4mMX
let console = ConsoleDestination()  // log to Xcode Console in color
let file = FileDestination()  // log to file in color
file.logFileURL = URL(fileURLWithPath: "/tmp/VaporLogs.log") // set log file
let sbProvider = SwiftyBeaverProvider(destinations: [console, file])

drop.addProvider(sbProvider)
let log = drop.log.self

// MARK: - Database config
try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations.append(Acronym.self)
drop.preparations.append(TILUser.self)

(drop.view as? LeafRenderer)?.stem.cache = nil
// MARK: - Add BasicController
let basic = BasicController(drop: drop)
basic.addRoutes()

// MARK: - Add Acronyms Resouce
let acronyms = AcronymsController()
drop.resource("acronyms", acronyms)


let til = TILController(droplet: drop)
til.addRoutes()

drop.get("combine") { request in
    guard let rawInput = request.data["input"]?.string else {
        throw Abort.notFound
    }
    let input = try rawInput.validated(by: Count.min(10) && !OnlyAlphanumeric.self)
    return "Validate \(input.value)"
}


// MARK: - Add ValidatorsController
let validators = ValidatorsController(drop: drop)
validators.addRoutes()

// MARK: - Add Users Resouce
let users = TILUserController(droplet: drop)
users.addRoutes()

drop.run()
