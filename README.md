Otafuku
===
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![CocoaPods](https://img.shields.io/cocoapods/v/Future.svg)]()
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Issues](https://img.shields.io/github/issues/nghialv/Future.svg?style=flat
)](https://github.com/nghialv/Future/issues?state=open)

Otafuku provides utility classes to use WKWebView.

## Features
- ```WebViewUIController``` to handle WKUIDelegate methods by presenting an alert as usual browsers do.
- ```WebViewPropertyObserver``` to notify WKWebView property value change via a registered closure and Swift enum. With this class, no KVO code is needed to know WKWebView property value change.

## Usage
#### WebViewUIController

```WebViewUIController``` handles WKUIDelegate.  
As shown below, simply declare a property of ```WebViewUIController``` and set it to WKWebView.UIDelegate in UIViewController.viewDidLoad.

```
class ViewController: UIViewController {
    let uiDelegate = WebViewUIController()

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.UIDelegate = uiDelegate
    }
}
```

#### WebViewPropertyObserver
```WebViewPropertyObserver``` notifies WKWebView property value change.  
As shown below, declare a property of ```WebViewPropertyObserver``` to retain its object throughout the ViewController's life cycle.  
To initialize, pass a WKWebView object and a closure handling WKWebView's property change.    

```
class ViewController: UIViewController {
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var backItem: UIBarButtonItem!
    @IBOutlet var forwardItem: UIBarButtonItem!

    var propertyObserver: WebViewPropertyObserver?

    override func viewDidLoad() {
        super.viewDidLoad()
        propertyObserver = WebViewPropertyObserver(webView: webView, handler:handleWebViewPropertyChange)
    }

    func handleWebViewPropertyChange(property: WebViewPropertyObserver.WebViewProperty) {
        switch property {
        case .Title(let title):
            navigationItem.title = title
        case .URL(let URL):
            // do something with URL
            break
        case .CanGoBack(let canGoBack):
            backItem.enabled = canGoBack
        case .CanGoForward(let canGoForward):
            forwardItem.enabled = canGoForward
        case .EstimatedProgress(let progress):
            progressView.progress = progress
        case .Loading(let loading):
            // do something with loading
            break
        case .HasOnlySecureContent(let secureContent):
            // do something with secureContent
            break
        }
    }
}
```

## Requirements
- iOS 8.0+
- Swift 3.0
- Xcode 8.0

## Installation
- Install with CocoaPods

```
platform :ios, '8.0'
use_frameworks!

pod 'Otafuku'
```

## License
Otafuku is released under the MIT license. See LICENSE for details.
