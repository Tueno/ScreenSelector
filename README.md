# ScreenSelector

Provides screen selector UI for iOS.

![preview](https://github.com/Tueno/ScreenSelector/blob/master/preview.gif?raw=true)

## Feature
### ScreenSelectorView
* IBDesignable supporting.
* IBInspectable supporting.
* Can use your custom preview view that is compatible with ScreenPreviewViewProtocol.
* Can show preview view's specular reflection.

### ScreenSelectorViewController
* Wrapper class of `ScreenSelectorView`.
* Easy to use.

## Usage

* Extend `ScreenSelectorViewController` and set `UIViewController` instance that conforms to `ScreenSelectorPreviewable` protocol to `previewableScreens` property.

OR

* Add `ScreenSelectorView` instance to any view and set `dataSource` and `delegate`. (You can use custom preview view class.) 

(See `Example` for details.)

## Requirements

* iOS8.0+
* Xcode7.3+

## Installation

### Carthage

Add this line to your Cartfile.
```ogdl
github "Tueno/ScreenSelector"
```

