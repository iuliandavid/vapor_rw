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


// MARK: - Add BasicController
let basic = BasicController()
basic.addRoutes(drop: drop)






drop.run()
