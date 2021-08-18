<p align="center">
  <img src="https://i.imgur.com/iHgsHBs.png" alt="SwURL"/>
</p>

![Build Status](https://app.bitrise.io/app/0cc93118a793b6f9/status.svg?token=6ITVosjDjjYgfYcVRGMuUw&branch=master)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)

Asyncrounously download and display images in Swift UI. Supports progress indicators, placeholders and image transitions.

# RemoteImageView

Asyncrounously download and display images declaratively. Supports progress indicators, placeholders and image transitions. Flexible caching options. 

Flexible caching and image fetching done in background. Currently tested with basic `List` as seen in Example

This is an evolving project, if you have any ideas or feedback - feel free to create an issue or get in touch.

![Fading Transition!](https://media.giphy.com/media/kFCKkcURNhI0AVG19y/giphy.gif)


## "But, `AsyncImage`"

It's great that Apple now has official support for async images, however:

Unlike `AsyncImage`,  `RemoteImageView`
- Is supported from iOS 13
- Supports caching (in memory, on disk, and custom)
- Powerful, modular way to 
- Supports progress indicators
- Has in depth, customisable logging


## Configuration

Enable or disable debug logging 

```swift 
SwURLDebug.loggingEnabled = true
```


Choose between **global** persistent or in-memory (default) caching

 ```swift
 SwURL.setImageCache(type: .inMemory)
 ```

 ```swift
 SwURL.setImageCache(type: .persistent)
 ```
 
 ... or provide your own caching implementation by using `ImageCacheType`
 
  ```swift
 SwURL.setImageCache(type: .custom(ImageCacheType))
 ```

## Usage

`RemoteImageView` is initialised with a `URL`, placeholder `Image` (default nil)  and a `.custom` `ImageTransitionType` (default `.none`). 

Upon initialisation, a resized image will be downloaded in the background and placeholder displayed as the image is loading, transitioning to the downloaded image when complete.

`LandmarkRow` is used in a `List`

## Example

```swift
struct LandmarkRow: View {
	var landmark: Landmark
	
	var body: some View {
		HStack {
			RemoteImageView(
				url: landmark.imageURL,
				placeholderImage: Image.init("placeholder_avatar"),
				transition: .custom(transition: .opacity, animation: .easeOut(duration: 0.5))
			).imageProcessing({ image in
				return image
					.resizable()
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
			}).progress({ progress in    
    				return MyProgressBarView(progress: progress)
			})
			Text(verbatim: landmark.name)
			Spacer()
		}
	}
}
```

## Available Parameters

| Name | Description |Default|
| :--- | :--- | :--- |
| url | `URL` of the remote source image. | _none_ |
| placeholderImage | _(optional)_<br />`Image` to display whilst remote image data is being fetched and decoded. | `nil` |
| transition | _(optional)_<br />transition to occur when showing the loaded image. | `nil` |

## Progress / Loading Indicators

Using function `.progress` . 
Display a loading indicator on top of the placeholder as the image loads.
Once the image has finished downloading, the supplied loading indicator will hide
Call `progress` on your `RemoteImageView` and return `some View` 

### Example

```swift

).progress({ progress in    
    return MyProgressBarView(progress: progress)
})

```

## Image Processing

Using function `.imageProcessing` . 
Process your placeholder and loaded images once they've been loaded. Apply resizing, aspect ratio, clipping and more!
Call `imageProcessing` on your `RemoteImageView` and return `some View` 

### Example

```swift

).imageProcessing({ image in    
    return image
        .resizable()
        .renderingMode(.template)
        .aspectRatio(contentMode: .fit)
})

```

This gives you the power to return any `View` you want.
`RemoteImageView` applies `resizable()` on all images by default.

# Get it

SwURL is available only through `Swift Package Manager`

* Open Xcode
* Go to `File > Swift Packages > Add Package Dependency...`
* Paste this Github Repo URL ( https://github.com/cmtrounce/SwURL ) into the search bar. 
* Select the SwURL repo from the search results.
* Choose the branch/version you want to clone. The most recent release is the most stable but you can choose branches  `master` and `develop` for the most up to date changes.
* Confirm and enjoy!

# Contact

Join the SwURL Gitter community at https://gitter.im/SwURL-package/community and message me directly. Recommended for quicker response time.

You can also follow/message me on Twitter at https://twitter.com/ctrounce94
