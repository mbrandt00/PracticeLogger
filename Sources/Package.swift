// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "ApolloGQL",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14),
        .tvOS(.v12),
        .watchOS(.v5),
    ],
    products: [
        .library(name: "ApolloGQL", targets: ["ApolloGQL"]),
        .library(name: "Mocks", targets: ["Mocks"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "ApolloGQL",
            dependencies: [
                .product(name: "ApolloAPI", package: "apollo-ios"),
            ],
            path: "./Sources"
        ),
        .target(
            name: "Mocks",
            dependencies: [
                .product(name: "ApolloTestSupport", package: "apollo-ios"),
                .target(name: "ApolloGQL"),
            ],
            path: "./Mocks"
        ),
    ]
)
