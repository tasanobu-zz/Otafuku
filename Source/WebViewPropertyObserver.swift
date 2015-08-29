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
        case Title(String?)
        case URL(NSURL?)
        case CanGoBack(Bool)
        case CanGoForward(Bool)
        case EstimatedProgress(Float)
        case Loading(Bool)
        case HasOnlySecureContent(Bool)
        
        init?(webView: WKWebView, key: String) {
            switch key {
            case "title":
                self = .Title(webView.title)
                
            case "URL":
                self = .URL(webView.URL)
                
            case "estimatedProgress":
                var progress = Float(webView.estimatedProgress)
                progress = max(0.0, progress)
                progress = min(1.0, progress)
                self = .EstimatedProgress(progress)
                
            case "canGoBack":
                self = .CanGoBack(webView.canGoBack)
                
            case "canGoForward":
                self = .CanGoForward(webView.canGoForward)
                
            case "hasOnlySecureContent":
                self = .HasOnlySecureContent(webView.hasOnlySecureContent)
                
            case "loading":
                self = .Loading(webView.loading)
                
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
            webView?.addObserver(self, forKeyPath: key, options: NSKeyValueObservingOptions.New, context: nil)
        }
    }
    
    private func stopObservingPrpoperties() {
        for key in WebViewProperty.keys {
            webView?.removeObserver(self, forKeyPath: key, context: nil)
        }
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let keyPath = keyPath, let wv = object as? WKWebView, let property = WebViewProperty(webView: wv, key: keyPath) else {
            return
        }
        handler(property)
    }
}
