import FluentProvider
import SwiftyBeaverProvider
import PostgreSQLProvider

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
        try addProvider(SwiftyBeaverProvider.Provider.self)
        try addProvider(PostgreSQLProvider.Provider.self)
        // try addConfigurable(middleware: AuthMiddleware(user: TILUser.self), name: "auth")
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
        preparations.append(Post.self)
    }
}
