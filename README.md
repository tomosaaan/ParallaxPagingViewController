# ParallaxPagingViewController
## Demo
<img src="DocumentContents/Demo.gif" width="200">

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
