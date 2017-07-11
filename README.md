
<img src="DocumentContents/top.png" width="700">

[![Build Status](https://travis-ci.org/tomokitakahashi/ParallaxPagingViewController.svg?branch=master)](https://travis-ci.org/tomokitakahashi/ParallaxPagingViewController)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)

## Demo
<img src="DocumentContents/Demo.gif" width="200">

## Features

- [ ] Add more example and test 
- [ ] Support Swift4

## Usage

### import 
```swift
import ParallaxPagingViewController
```
### ParallaxViewController
needs extends for pageview

```swift
class ParallaxChildViewController: ParallaxViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
```

```swift
@IBInspectable var parallaxImage: UIImage? // required set image
```

### ParallaxPagingViewController
If you customize pagingViewController, needs extends . 

- initializer

```swift
init(_ viewControllers: [ParallaxViewController] = [])
```

- variable

```swift
var pageSpace: CGFloat      // for page space
```

```swift
var parallaxSpace: CGFloat  // for parallax animation space
```

```swift
var currentPageIndex: Int   // first page view index
```

- function

```swift
func setInfinite(_ enabled: Bool) // set infinite paging enabled
```

```swift
func setViewControllers(controllers: [ParallaxViewController]) // set childViewControllers
```
### ParallaxPagingViewDelegate


- function

```swift
optional func parallaxPagingView(_ pagingViewController: ParallaxPagingViewController, willMoveTo viewController:ParallaxViewController)
```

```swift
optional func parallaxPagingView(_ pagingViewController: ParallaxPagingViewController, didMoveTo viewController:ParallaxViewController)
```
## Requirements
- iOS 8.0 or later
- Swift 3.1 / Xcode 8.3

## installation
[CocoaPods](https://cocoapods.org/)
1. insert to `Podfile` 
`pod 'ParallaxPagingViewController', '~> 1.0'`
2. run 
`pod install`

## LICENSE

```
MIT License

Copyright (c) 2017 Tomoki_Takahashi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
