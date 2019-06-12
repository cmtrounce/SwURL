# SwURL

Declarative-style SwiftUI wrapper around asyncronous image views

# Get it

* Open Xcode
* Go to `File > Swift Packages > Add Package Dependency...`
* Paste in this Github Repo URL ( https://github.com/cmtrounce/SwURL )
* Select the latest release version or enter  `master`  or `develop`  branch for the most cutting edge version.
* Confirm and enjoy!

# RemoteImageView

Asyncrounously download and display images declaratively. Supports placeholders and image transitions.

In-memory caching and image fetching done in background. Currently tested with basic `List` as seen in Example

As everyone gets to understand SwiftUI more, this project will evolve and get more features.

![Fading Transition!](https://media.giphy.com/media/kFCKkcURNhI0AVG19y/giphy.gif)

## Example

`RemoteImageView` is initialised with a `URL`, placeholder `Image` (default nil)  and a `.custom` `ImageTransitionType` (default `.none`). 

Upon initialisation, a resized image will be downloaded in the background and placeholder displayed as the image is loading, transitioning to the downloaded image when complete.

`LandmarkRow` is used in a `List`

```swift
struct LandmarkRow: View {
    var landmark: Landmark
    
    var body: some View {
        HStack {
            RemoteImageView(url: landmark.imageURL,
                            placeholderImage: Image.init("user"),
                            transition: .custom(transition: .opacity,
                                                animation: .basic(duration: 0.5, curve: .easeInOut)))
            Text(verbatim: landmark.name)
            Spacer()
        }
    }
}
```

