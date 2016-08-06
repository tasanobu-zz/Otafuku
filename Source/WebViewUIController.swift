//
//  WebViewUIController.swift
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
import Kamagari

public class WebViewUIController: NSObject, WKUIDelegate {
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        return nil
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        AlertBuilder(message: message, preferredStyle: .alert)
            .addAction(title: NSLocalizedString("OK", comment: "")) { _ in completionHandler() }
            .build()
            .kam_show()
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        AlertBuilder(message: message, preferredStyle: .alert)
            .addAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in completionHandler(false) }
            .addAction(title: NSLocalizedString("OK", comment: "")) { _ in completionHandler(true) }
            .build()
            .kam_show()
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String?) -> Void) {
        
        // variable to keep a reference to UIAlertController
        var avc: UIAlertController?
        
        let okHandler: () -> Void = { handler in
            if let avc = avc, let textField = avc.textFields?.first {
                completionHandler(textField.text)
            } else {
                completionHandler("")
            }
        }
        
        avc = AlertBuilder(title: nil, message: prompt, preferredStyle: .alert)
            .addTextFieldHandler() { $0.text = defaultText }
            .addAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in completionHandler("") }
            .addAction(title: NSLocalizedString("OK", comment: "")) { _ in okHandler() }
            .build()
        avc?.kam_show()
    }
}
