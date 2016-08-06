//
//  WebViewPropertyObserver.swift
//  Otafuku
//
// Copyright (c) 2015 Kazunobu Tasaka
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import WebKit

public class WebViewPropertyObserver: NSObject {
    public enum WebViewProperty {
        static let keys = ["title", "URL", "estimatedProgress", "canGoBack", "canGoForward", "hasOnlySecureContent", "loading"]
        case title(String?)
        case url(Foundation.URL?)
        case canGoBack(Bool)
        case canGoForward(Bool)
        case estimatedProgress(Float)
        case loading(Bool)
        case hasOnlySecureContent(Bool)
        
        init?(webView: WKWebView, key: String) {
            switch key {
            case "title":
                self = .title(webView.title)
                
            case "URL":
                self = .url(webView.url)
                
            case "estimatedProgress":
                var progress = Float(webView.estimatedProgress)
                progress = max(0.0, progress)
                progress = min(1.0, progress)
                self = .estimatedProgress(progress)
                
            case "canGoBack":
                self = .canGoBack(webView.canGoBack)
                
            case "canGoForward":
                self = .canGoForward(webView.canGoForward)
                
            case "hasOnlySecureContent":
                self = .hasOnlySecureContent(webView.hasOnlySecureContent)
                
            case "loading":
                self = .loading(webView.isLoading)
                
            default:
                return nil
            }
        }
    }
    
    private weak var webView: WKWebView?
    private let handler: WebViewPropertyChangeHandler
    public typealias WebViewPropertyChangeHandler = (WebViewProperty) -> ()
    
    public init(webView: WKWebView, handler: WebViewPropertyChangeHandler) {
        self.webView = webView
        self.handler = handler
        super.init()
        startObservingProperties()
    }
    
    deinit {
        stopObservingPrpoperties()
    }
    
    private func startObservingProperties() {
        for key in WebViewProperty.keys {
            webView?.addObserver(self, forKeyPath: key, options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    
    private func stopObservingPrpoperties() {
        for key in WebViewProperty.keys {
            webView?.removeObserver(self, forKeyPath: key, context: nil)
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
        guard let keyPath = keyPath, let wv = object as? WKWebView, let property = WebViewProperty(webView: wv, key: keyPath) else {
            return
        }
        handler(property)
    }
}
