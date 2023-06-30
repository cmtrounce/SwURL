<p align="center">
  <img src="https://i.imgur.com/iHgsHBs.png" alt="SwURL"/>
</p>

[![Build Status](https://app.bitrise.io/app/0cc93118a793b6f9/status.svg?token=6ITVosjDjjYgfYcVRGMuUw&branch=master)](https://app.bitrise.io/app/0cc93118a793b6f9)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)

Asyncrounously download and display images in Swift UI. Supports progress indicators, placeholders and image transitions.

# `SwURLImage`

Asyncrounously download and display images declaratively. Supports progress indicators, placeholders and image transitions. Flexible caching options. 

Flexible caching and image fetching done in background. Currently tested with basic `List` as seen in Example

<img width="250" src="https://github.com/cmtrounce/SwURL/assets/10603129/7c3d517d-b85e-4127-ae59-009a1e5c2229" />

## "But, `AsyncImage`"

It's great that Apple now has official support for async images, however:

Unlike `AsyncImage`,  `SwURLImage`:
- Is supported from iOS 13
- Supports caching (in memory, on disk, and custom)
- Supports progress indicators (including download fraction) and custom transitions
- Has in depth, customisable logging

# Getting Started

## Get it

SwURL is available only through `Swift Package Manager`

* Open Xcode
* Go to `File > Swift Packages > Add Package Dependency...`
* Paste this Github Repo URL ( https://github.com/cmtrounce/SwURL ) into the search bar. 
* Select the SwURL repo from the search results.
* Choose the branch/version you want to clone. The most recent release is the most stable but you can choose branches  `master` and `develop` for the most up to date changes.
* Confirm and enjoy!

## Read the Documentation

Get started by reading the documentation in your browser [here](https://cmtrounce.github.io/documentation/swurl/).

The documentation includes usage examples and makes the code easier to explore.

There is also an example project in this repo that you can give a try.


# Contact

Join the SwURL Gitter community at https://gitter.im/SwURL-package/community and message me directly. Recommended for quicker response time.

You can also follow/message me on Twitter at https://twitter.com/cmtrounce
