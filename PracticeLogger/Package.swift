//
//  Package.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import Foundation

let package = Package(
    dependencies: [
        ...
        .package(
            url: "https://github.com/supabase/supabase-swift.git",
            from: "2.0.0"
        ),
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: [
                .product(
                    name: "Supabase", // Auth, Realtime, Postgrest, Functions, or Storage
                    package: "supabase-swift"
                ),
            ]
        ),
    ]
)
