# Getting Started

Learn how to integrate SwURL into your codebase, using ``SwURLImage``. Create your own view that supports placeholder images and smooth transitions.

## Writing your first view

To get started, all you need is a URL of where you want to retrieve an image from. 
In this example, we'll be creating a view that displays an avatar of a user, which includes an image.

SwURL provides a type, ``SwURLImage`` that allows you to asynchronously load the image in.

```swift
import SwiftUI

struct UserAvatarView: View {
    let imageURL: URL

    var body: some View {
        SwURLImage(
            url: imageURL
        )
    }
}
```

### Placeholder Image

Want a placeholder to display while the image is being fetched? No problem! 
Use the `placeholderImage` parameter, and pass in a placeholder image from your bundle.

```swift
import SwiftUI

struct UserAvatarView: View {
    let imageURL: URL

    var body: some View {
        SwURLImage(
            url: imageURL
            placeholderImage: Image("placeholder-avatar-image")
        )
    }
}
```

### Transitions

Need a smooth fade between placeholder and final loaded image? 
Use the `transition` parameter.

```swift
import SwiftUI

struct UserAvatarView: View {
    let imageURL: URL

    var body: some View {
        SwURLImage(
            url: imageURL
            placeholderImage: Image("placeholder-avatar-image"),
            transition: .custom(transition: .opacity, animation: .easeIn)
        )
    }
}
```
