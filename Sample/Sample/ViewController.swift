//
//  ViewController.swift
//  Sample
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

import UIKit
import WebKit
import Otafuku

class ViewController: UIViewController {

    var webView: WKWebView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var backItem: UIBarButtonItem!
    @IBOutlet var forwardItem: UIBarButtonItem!
    
    let uiDelegate = WebViewUIController()
    var propertyObserver: WebViewPropertyObserver?
    
    let defaultUrl = NSURL(string: "https://www.bing.com")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: view.frame)
        webView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        webView.allowsBackForwardNavigationGestures = true
        webView.UIDelegate = uiDelegate
        view.addSubview(webView)
        
        view.bringSubviewToFront(progressView)
        
        loadDefaultURL()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let nv = navigationController {
            nv.navigationBarHidden = false
            nv.toolbarHidden = false
        }
        
        propertyObserver = WebViewPropertyObserver(webView: webView, handler:handleWebViewPropertyChange)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        propertyObserver = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: IBAction
    @IBAction func didTouchBackItem() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func didTouchForwardItem() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    func loadDefaultURL() {
        webView.loadRequest(NSURLRequest(URL: defaultUrl))
    }
}

extension ViewController {
    func handleWebViewPropertyChange(property: WebViewPropertyObserver.WebViewProperty) {
        switch property {
        case .Title(let title):
            navigationItem.title = title
            
        case .URL(let URL):
            NSLog("URL is changed to \(URL)")
            
        case .CanGoBack(let canGoBack):
            backItem.enabled = canGoBack
            
        case .CanGoForward(let canGoForward):
            forwardItem.enabled = canGoForward

        case .EstimatedProgress(let progress):
            progressView.progress = progress
            
        case .Loading(let loading):
            NSLog("loading is changed to \(loading)")
            
        case .HasOnlySecureContent(let secureContent):
            NSLog("HasOnlySecureContent is changed to \(secureContent)")
        }
    }
}
