# SwURL

A Declarative-style SwiftUI wrapper around Asyncronous Image Loading 


# Usage

## Example

```swift
struct LandmarkRow: View {
    var landmark: Landmark
    
    var body: some View {
        HStack {
            RemoteImageView
                .init(url: landmark.imageURL, placeholderImage: Image.init("user"))
                .frame(width: 30, height: 30, alignment: Alignment.center)
                .clipShape(Ellipse().size(width: 30, height: 30))
                .scaledToFit()
            Text(verbatim: landmark.name)
            Spacer()
        }
    }
}
```

