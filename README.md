# SwURL

Declarative-style SwiftUI wrapper around Asyncronous Image Loading 

# Get it

SwURL is available as a Swift Package, install guide coming soon, for now just Google it.


# Usage

## Example

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

