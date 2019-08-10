//
//  WebView.swift
//  cross
//
//  Created by Null on 7/19/19.
//  Copyright © 2019 shaidin. All rights reserved.
//

import WebKit

class WebView: WKWebView, WKScriptMessageHandler, WKNavigationDelegate
{

    var web_finish_: String = ""

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.configuration.userContentController.add(self, name: "Handler_")
        self.configuration.preferences.javaScriptEnabled = true;
        navigationDelegate = self
    }

    func LoadView(_ sender: Int32, _ html: String)
    {
        web_finish_ =
            "var Handler = window.webkit.messageHandlers.Handler_;" +
            "var Handler_Receiver = \(sender);" +
            "function CallHandler(id, command, info)" +
            "{" +
                "Handler.postMessage(JSON.stringify(" +
                "{\"Receiver\": Handler_Receiver, \"id\": id, \"command\": command, \"info\": info}));" +
            "}"
        let url = Bundle.main.url(
            forResource: html,
            withExtension: "htm",
            subdirectory: "html")!
        loadFileURL(url, allowingReadAccessTo: url)
    }
    
    func CallFunction(_ function: String)
    {
        evaluateJavaScript(function)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        if (!web_finish_.isEmpty)
        {
            webView.evaluateJavaScript(web_finish_)
        }
    }
    
    func Clear()
    {
        web_finish_ = ""
        load(URLRequest(url: URL(string:"about:blank")!))
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
                    message_dictionary["id"] as? String,
                    message_dictionary["command"] as? String,
                    message_dictionary["info"] as? String)
            }
        }
        catch
        {
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        if (navigationAction.navigationType != .linkActivated)
        {
            decisionHandler(.allow)
        }
        else
        {
            decisionHandler(.cancel)
            let url = navigationAction.request.url
            if (url != nil)
            {
                UIApplication.shared.open(url!)
            }
        }
    }
}
