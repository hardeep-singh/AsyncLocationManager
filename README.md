# AsyncLocationManager

[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat)
[![Swift](https://img.shields.io/badge/Swift-5.5-orange?style=flat)](https://img.shields.io/badge/Swift-5.5-Orange?style=flat)
[![Platforms](https://img.shields.io/badge/platforms-iOS--13%20|%20macOS(beta)%20|%20watchOS--6(beta)%20|%20tvOS(beta)-orange?style=flat)](https://img.shields.io/badge/platforms-iOS--13%20|%20macOS(beta)%20|%20watchOS--6(beta)%20|%20tvOS(beta)-orange?style=flat)

A wrapper for the Apple CoreLocation framework with the new Concurrency Model

### Install
---

#### [Cocoapods](https://cocoapods.org)
```
pod 'AsyncLocationManager'
```

#### [SPM](https://swift.org/package-manager/)

Add the following line to your Package.swift file in the dependencies section:

```swift
.package(url: "https://github.com/hardeep-singh/AsyncLocationManager.git, .upToNextMajor(from: "1.0.1"))
```

### How to Use LocationManager
---

Create instance of the LocationManager

```swift
 let locationManager = LocationManager()
```

Request Location Authorization permissions

```swift
let authorizationStatus = try await locationManager.requestAuthorizationPermission(.always)
```
Request a single location
```swift
let location = try await locationManager.requestLocation()
```

Start monitoring and updating location
```swift
for await location in  await locationManager.startUpdatingLocation() {
    switch location {
    case .didFailWithError(let error):
        print("Location:- \(error)")
    case .didPaused:
        print("Location Did Paused")
        break
    case .didResume:
        print("Location Did Resume")
        break
    case .didUpdateLocations(let locations):
        print("Location Did Update:- \(locations)")
        break
    }
}
```




