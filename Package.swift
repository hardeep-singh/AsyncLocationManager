// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AsyncLocationManager",
    platforms: [
        .iOS("15.0")
    ],
    products: [.library(name: "LocationManager",
                        targets: ["LocationManager"]),
              ],
    dependencies: [],
    targets: [.target(name: "LocationManager",
                      path: "LocationManager/LocationManager"),
    ]
)
