# YM-API - Unofficial Swift Yandex Music Library

<p align="center">
    <a href="https://github.com/apple/swift">
        <img src="https://img.shields.io/badge/language-swift-orange.svg">
    </a>
    <a href="http://cocoapods.org/pods/YM-API">
        <img src="https://img.shields.io/cocoapods/v/YM-API.svg?style=flat">
    </a>
    <a href="http://cocoapods.org/pods/YM-API">
        <img src="https://img.shields.io/cocoapods/p/YM-API.svg?style=flat">
    </a>
    <a href="https://raw.githubusercontent.com/p0rterB/YM-API/master/LICENSE">
        <img src="https://img.shields.io/cocoapods/l/YM-API.svg?style=flat">
    </a>
</p>

Fully ported Yandex Music API Swift implementation.

[Russian Readme (Readme на русском)](https://github.com/p0rterB/YM-API/blob/main/README_RU.md)

Thanks to [MarshalX](https://github.com/MarshalX) for his [Yandex Music API research](https://habr.com/ru/post/462607) and the [python library](https://github.com/MarshalX/yandex-music-api).

## Content

- [Introduction](#Introduction)

- [Setup](#Setup)

- [Getting started](#Getting-started)

- [Examples](#Usage-examples)

- [Sample application](#Application-example)

- [Getting help](#Getting-help)

- [Gratitude](#Gratitude)

- [License](#License)

## Introduction

The library provides an interface for interacting with the Yandex Music API.

macOS 10.14+ and iOS 10.0+ are supported by the module.

### Yandex personal data access

Constant values [CLIENT_ID and CLIENT_SECRET](https://github.com/p0rterB/YM-API/blob/master/Classes/API/YMClient.swift#L11)
were borrowed from the Yandex Music official application at Microsoft Store. 
Since the API is private and only used internally, it is impossible to register own application for now on
[oauth.yandex.ru](https://oauth.yandex.ru), and therefore, use your own constant values.

## Setup

YM-API is available with CocoaPods. To install a module, just add the module name to the Podfile:

- iOS
```ruby
platform :ios, '10.0'
...
pod 'YM-API'
```

- macOS
```ruby
platform :osx, '10.14'
...
pod 'YM-API'
```

## Getting started

You can interact with the API through [YMClient](https://github.com/p0rterB/YM-API/blob/main/Classes/API/YMClient.swift) instance.

You can initialize the client in 2 ways:

### Basic, at first launch or logout state

```swift
import YM_API

let client = YMClient.initialize(device: YMDevice, lang: ApiLanguage)
```
**device** parameter - Device info. Essentially needed during working with play queues
```swift
let device = YMDevice(os: "iOS", osVer: "14.6", manufacturer: "Apple",
    model: "iPhone8,4", clid: "app-store", 
    deviceId: UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased(),
    uuid: UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased())
```
**lang** parameter - Yandex Music localization. There are 7 options to choose from:
```swift
enum ApiLanguage: String {
    case en//English
    case uz//Uzbek
    case uk//Ukrainian
    case us//English (US)
    case ru//Russian
    case kk//Kazakh
    case hy//Armenian
}
```

### Extended, if there is an active session

```swift
import YM_API

let client = YMClient.initialize(device: YMDevice, lang: ApiLanguage, 
    uid: Int, token: String, xToken: String)
```
**uid** parameter - Account ID

**token** parameter - Account token

**xToken** parameter - Passport Yandex access token

To work with the service in the absence of an active session, you must sign in.

Authorization contains 3 steps. Main requirement is using WKWebView

**I Step** - Generate authorization init url

```swift
//String - url string
//URLRequest? - url generated request
let pair: (String, URLRequest?) = client.generateInitAuthSessionRequest()
```

**II Step** - Sign in *passport.yandex.ru* through WKWebView as official Yandex Music app does

```swift
webView_auth.navigationDelegate = self//Required for extracting trackID and Ya-Client-Cookie from passed auth challenge
webView_auth.load(request)
```

**III Step** - Generate X-Token and yandex music access token with extracted trackID and Ya-Client-Cookie

## Usage examples

If you have an initialized client with authorized session, you can use all available methods from the API.

### Retrieving a list of generated daily playlists in the context of the feed

```swift
client.getFeed { result in
    guard let feed = try? result.get() else {return}
    let playlists = feed.generatedPlaylists
}
```

### Retrieving playlist tracks data

Option with calling a function from a playlist track instance
```swift
playlist.tracks?[index].fetchTrack(completion: { result in
    //Actions with track data
})
```

Option with calling a function from a client instance
```swift
let trackIds = playlist.tracks?.map{ track in return track.trackId }
client.getTracks(trackIds: trackIds, positions: false) { result in
    //Actions with tracks data
}
```

### Retrieving the track download link

```swift
var track: Track!
... acquiring track data...
track.getDownloadLink(codec: .mp3, bitrate: .kbps_192) {result in
    //Actions with download link
}
```

## Application example

<p align="center">
<img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Images/appIcon.png?raw=true">
</p>

An application for iOS (11.0+) was created for this API.
It implements a working minimum: playlists generated by Yandex, displaying its content, playing songs including local play queue, the ability to like or dislike them, display the 'my collection' tracks with the ability to listen and search tracks. Also you can use this app on CarPlay through control centre trick.
Its source code is publicly available.

<p align="center">
<img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/feed.png?raw=true">          <img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/playlistOfDay.png?raw=true">          <img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/nowPlaying.png?raw=true">          <img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/nowPlayingQueue.png?raw=true">          <img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/favourite.png?raw=true">          <img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/searchSuggestions.png?raw=true">          <img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/searchResults.png?raw=true">
</p>

Visit [this page](https://github.com/p0rterB/YM-API/tree/master/Project/ios/Rave), to see the example application source.

### Setup application ways

This application can be installed on your device for testing in several ways:

### Free and simple
 You need mac and XCode. Plus you need to have a basic developer account (without paid license) and the Apple device added to it.
 Update the pod dependencies in the project and just compile the sample application project for your device. The installed application will be available for 7 days due to the limitations of the basic developer account.
 
 ### Advanced and paid
 You need mac and and a developer account with a paid license.
 On the [Apple Developer site](https://developer.apple.com/account/) you need to prepare the infrastructure for uploading: certificates, application ID (basic capabilities set), provision profiles set.
  So you can use the application not only on your personal device (App Store Connect public testing through TestFlight) and not for 7 days.
  P.S. And if you want to show the whole breadth of your soul and, perhaps, thank the creator, you can upload the application to TestFlight for open testing and share the link, which I will post here =)

## Getting help

If you find problems or want to suggest a new feature in the API itself
create an [issue](https://github.com/p0rterB/YM-API/issues/new/choose)

I don't plan to add anything cardinal to the application itself - it is an example of using the API

## License

You can copy, distribute and modify the software
provided that modifications are described and licensed free of charge in accordance with
c [LGPL-3](https://www.gnu.org/licenses/lgpl-3.0.html). Artworks
derivatives (including modifications or anything statically linked to the library)
may only be distributed in accordance with the LGPL-3, but applications that
use a library, optional.
