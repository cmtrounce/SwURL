# SwURL

Declarative-style SwiftUI wrapper around asyncronous networking operations.

# Get it

SwURL is available as a Swift Package, install guide coming soon, for now just Google it.

# RemoteImageView

Asyncrounously download and display images delaritively.

In-memory caching and image fetching done in background. Currently tested with basic `List` as seen in Example

As everyone gets to understand SwiftUI more, this project will evolve and get more features.

## Example

`RemoteImageView` is initialised with a `URL` and a placeholder `Image`. Upon initialisation, a resized image will be downloaded in the background and placeholder displayed as the image is loading.

`LandmarkRow` is used in a `List`

```swift
struct LandmarkRow: View {
    var landmark: Landmark
    
    var body: some View {
        HStack {
            RemoteImageView
                .init(url: landmark.imageURL, placeholderImage: Image.init("placeholder_location"))
                .frame(width: 30, height: 30, alignment: Alignment.center)
                .clipShape(Ellipse().size(width: 30, height: 30))
                .scaledToFit()
            Text(verbatim: landmark.name)
            Spacer()
        }
    }
}
```

