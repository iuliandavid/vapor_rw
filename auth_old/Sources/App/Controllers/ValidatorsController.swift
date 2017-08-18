import Vapor
import HTTP
import VaporPostgreSQL

final class ValidatorsController {
    
    private let droplet: Droplet

    init(drop: Droplet) {
        self.droplet = drop
    }

    func addRoutes() {
        droplet.get("email", handler: emailValidator)
        droplet.get("password", handler: passwordValidator)
        droplet.get("name", handler: nameValidator)
        //Endpoints with only passes or tested
        droplet.get("passes", handler: passes)
        droplet.get("tested", handler: tested)

    }

    private func emailValidator(request: Request) throws -> ResponseRepresentable {
        let input: Valid<EmailValidator> = try request.data["input"].validated()
        
        return "Validate \(input.value)"
    }

    private func nameValidator(request: Request) throws -> ResponseRepresentable {
        let input: Valid<NameValidator> = try request.data["input"].validated()
        
        return "Validate \(input.value)"
    }

    private func passwordValidator(request: Request) throws -> ResponseRepresentable {
        let input: Valid<PasswordValidator> = try request.data["input"].validated()
        
        return "Validate \(input.value)"
    }

    private func passes(request: Request) throws -> ResponseRepresentable {
        guard let input = request.data["input"]?.string else {
            throw Abort.badRequest
        }
        
        let passed = input.passes(PasswordValidator.self)
        return "Passes: \(passed)"
    }

    private func tested(request: Request) throws -> ResponseRepresentable {
        guard let input = request.data["input"]?.string else {
            throw Abort.badRequest
        }
        
        let tested = try input.tested(by: PasswordValidator.self)

        return "Validate \(tested)"
    }
}