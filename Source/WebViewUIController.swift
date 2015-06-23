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

class WebViewUIController: NSObject {
}

extension WebViewUIController: WKUIDelegate {
    
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.loadRequest(navigationAction.request)
        return nil
    }
    
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        UIAlertController.showAlert(message: message) { _ in completionHandler() }
    }
    
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        UIAlertController(title: message, message: nil, preferredStyle: .Alert)
            .addAction(title: String.localized(key: "Cancel"), style: .Cancel) { _ in completionHandler(false) }
            .addAction(title: String.localized(key: "OK")) { _ in completionHandler(true) }
            .show()
    }
    
    func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String!) -> Void) {
        let avc = UIAlertController(title: prompt, message: nil, preferredStyle: .Alert)
        avc.addTextFieldHandler() { textField in textField.text = defaultText }
            .addAction(title: String.localized(key: "Cancel"), style: .Cancel) { _ in completionHandler("") }
            .addAction(title: String.localized(key: "OK")) { _ in
                var input = ""
                if let textField = avc.textFields?.first as? UITextField {
                    input = textField.text
                }
                completionHandler(input)
            }
            .show()
    }
}
