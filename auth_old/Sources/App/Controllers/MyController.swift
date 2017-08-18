import Vapor
import HTTP
import VaporPostgreSQL

final class MyController {
    
    private let droplet: Droplet
    
    init(drop: Droplet) {
        self.droplet = drop
    }
    
    func addRoutes(){
        droplet.post("upload") { req in
        let name = req.data["name"]
        let _ = req.data["image"] // or req.multipart["image"]
    
        log.verbose("Name: \(name)")
         return "Submitted with a POST request"
        }
        
    }
    
    
}
