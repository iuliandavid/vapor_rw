import PackageDescription

let package = Package(
    name: "siblings",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/postgresql-provider.git", majorVersion: 1),
        .Package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver-Vapor.git", majorVersion: 1),
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
    ]
)

