# PlaygroundVCHelpers

[![CI Status](https://img.shields.io/travis/ThryvInc/playground-vc-helpers.svg?style=flat)](https://travis-ci.org/ThryvInc/playground-vc-helpers)
[![Version](https://img.shields.io/cocoapods/v/PlaygroundVCHelpers.svg?style=flat)](https://cocoapods.org/pods/PlaygroundVCHelpers)
[![License](https://img.shields.io/cocoapods/l/PlaygroundVCHelpers.svg?style=flat)](https://cocoapods.org/pods/PlaygroundVCHelpers)
[![Platform](https://img.shields.io/cocoapods/p/PlaygroundVCHelpers.svg?style=flat)](https://cocoapods.org/pods/PlaygroundVCHelpers)

## Example

PlaygroundVCHelpers allows you to work with storyboard and xib based UIViewControllers in the Live View of playgrounds.

For xibs, just instantiate a VC with no arguments and pass it to `loadViewFromNib`, optionally passing a nib name (defaults to the class name).

For storyboards, use `loadVCFromStoryboard` to pass in the name of the storyboard and either: the storyboardId for the VC, or set `isInitialVC` to true.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

PlaygroundVCHelpers is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PlaygroundVCHelpers'
```

## Author

Elliot Schrock, @elliot_schrock on Twitter.

## License

PlaygroundVCHelpers is available under the MIT license. See the LICENSE file for more info.
