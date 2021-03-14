# SMSCodeInputView

[![CI Status](https://img.shields.io/travis/Lalafo-iOS/SMSCodeInputView.svg?style=flat)](https://travis-ci.org/Lalafo-iOS/SMSCodeInputView)
[![Version](https://img.shields.io/cocoapods/v/SMSCodeInputView.svg?style=flat)](https://cocoapods.org/pods/SMSCodeInputView)
[![License](https://img.shields.io/cocoapods/l/SMSCodeInputView.svg?style=flat)](https://cocoapods.org/pods/SMSCodeInputView)
[![Platform](https://img.shields.io/cocoapods/p/SMSCodeInputView.svg?style=flat)](https://cocoapods.org/pods/SMSCodeInputView)

## Example

<p float="left">
  <img src="https://github.com/Lalafo-iOS/SMSCodeInputView/blob/develop/Assets/Simulator-1.png" width="248" hspace="20">
  <img src="https://github.com/Lalafo-iOS/SMSCodeInputView/blob/develop/Assets/Simulator-2.png" width="248" hspace="20">
  <img src="https://github.com/Lalafo-iOS/SMSCodeInputView/blob/develop/Assets/Simulator-3.png" width="248">
</p>

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

SMSCodeInputView is compatible with Swift 4.x+.
iOS 10.0+

## Installation

SMSCodeInputView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SMSCodeInputView'
```

## Usage

SMSCodeInputView can be created from code or it can set as outlet class in xib/storyboard. <br\>
SMSCodeInputView supports self-sizing (like UILabel), so if you are using xib/storyboard set low prioirity to width and height constraints.
Settings:

Set number of digits in code:
```swift
var numberOfDigits: Int
```

Signle digit size
```swift
var digitSize: CGSize
```

Spacing between digits
```swift
var digitSpacing: CGFloat
```

Hide symbols in UITextField:
```swift
var isSecureTextEntry: Bool
```

Set font:
```swift
var font: UIFont
```

Set text color
```swift
var textColor: UIColor 
```

Set edges around the digit
```swift
var borderEdges: UIRectEdge
```

Border color for active state digit
```swift
var activeDigitBorderColor: UIColor
```

Border color for normal state digit
```swift
var noramlDigitBorderColor: UIColor
```

Border color for error state digit
```swift
var errorDigitBorderColor: UIColor
```

Border width for active state digit
```swift
var activeDigitBorderWidth: CGFloat
```

Border width for noraml state digit
```swift
var noramlDigitBorderWidth: CGFloat
```

Border width for error state digit
```swift
var errorDigitBorderWidth: CGFloat
```

Border width for filled state digit
```swift
var filledDigitBorderWidth: CGFloat
```

Digit background for active state
```swift
var activeDigitBackgrounColor: UIColor
```

Digit background for normal state
```swift
var normalDigitBackgroundColor: UIColor
```

Digit background for error state
```swift
var errorDigitBackgroundColor: UIColor
```

## Author

Sergey Zalozniy, s.zalozniy1900@gmail.com

## License

SMSCodeInputView is available under the MIT license. See the LICENSE file for more info.
