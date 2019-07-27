//
//  WebView.swift
//  cross
//
//  Created by Null on 7/19/19.
//  Copyright © 2019 shaidin. All rights reserved.
//

import UIKit
import WebKit

class WebView: UIViewController, WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate {

    var view_: WKWebView!
    var sender_: Int32 = 0
    var html_: String = ""
    var web_finish_: ((WKWebView)->Void)! = nil

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.add(self, name: "Handler_")
        view_ = WKWebView(frame: .zero, configuration: webConfiguration)
        view_.uiDelegate = self
        view_.navigationDelegate = self
        view = view_
    }
    
    func CallFunction(_ function: String)
    {
        view_!.evaluateJavaScript(function)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        web_finish_(webView)
    }
    
    override func viewDidLoad()
    {
        web_finish_ =				
        {[sender_](_ webView: WKWebView) in
            webView.evaluateJavaScript("SetReceiver(\(sender_));")
        }
        let url = Bundle.main.url(
            forResource: html_,
            withExtension: "htm",
            subdirectory: "html")!
        view_.loadFileURL(url, allowingReadAccessTo: url)
    }
    
    func userContentController(_ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage)
    {
        do
        {
            let message_data = (message.body as! String).data(using: String.Encoding.utf8)!
            let message_dictionary = try JSONSerialization.jsonObject(with: message_data,
                options: JSONSerialization.ReadingOptions.init()) as! [String : Any]
            DispatchQueue.main.async
            {
                BridgeHandleAsync(
                    message_dictionary["Receiver"] as! __int32_t,
                    message_dictionary["Message"] as? String)
            }
        }
        catch
        {
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType != .linkActivated {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
            let url = navigationAction.request.url
            if ((url) != nil) {
                UIApplication.shared.open(url!)
            }
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return (UIApplication.shared.keyWindow?.rootViewController!.supportedInterfaceOrientations)!
    }
}
