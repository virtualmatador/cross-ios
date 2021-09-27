//
//  WebView.swift
//  cross
//
//  Created by Null on 7/19/19.
//  Copyright © 2020 shaidin. All rights reserved.
//

import WebKit

class SchemaHandlerCross: NSObject, WKURLSchemeHandler
{
    var data_: UnsafeMutableRawPointer?
    var size_: __int32_t = 0

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask)
    {
        BridgeFeedUri(UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
              urlSchemeTask.request.url?.absoluteString,
        {(me, data, size)->Void in
            let handler = Unmanaged<SchemaHandlerCross>.fromOpaque(me!).takeUnretainedValue()
            handler.data_ = data;
            handler.size_ = size;
        })
        urlSchemeTask.didReceive(URLResponse(url: urlSchemeTask.request.url!, mimeType: "", expectedContentLength: Int(size_), textEncodingName: nil))
        if (data_ != nil)
        {
            urlSchemeTask.didReceive(Data.init(bytes: data_!, count: Int(size_)))
        }
        urlSchemeTask.didFinish()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask)
    {
    }
}

class SchemaHandlerAsset: NSObject, WKURLSchemeHandler
{
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask)
    {
        let fileName = urlSchemeTask.request.url?.absoluteString.replacingOccurrences(of: "asset://", with: "assets/")
        let data = try! Data.init(contentsOf: Bundle.main.url(forResource: fileName, withExtension: "")!)
        urlSchemeTask.didReceive(URLResponse(url: urlSchemeTask.request.url!, mimeType: "", expectedContentLength: Int(data.count), textEncodingName: nil))
        urlSchemeTask.didReceive(data)
        urlSchemeTask.didFinish()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask)
    {
    }
}

class WebView: WKWebView, WKScriptMessageHandler, WKNavigationDelegate
{
    var sender_: __int32_t = 0

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        configuration.setURLSchemeHandler(SchemaHandlerCross.init(), forURLScheme: "cross")
        configuration.setURLSchemeHandler(SchemaHandlerAsset.init(), forURLScheme: "asset")
        super.init(frame: frame, configuration: configuration)
        self.configuration.userContentController.add(self, name: "Handler_")
        navigationDelegate = self
        scrollView.bounces = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func LoadView(_ sender: __int32_t, _ html: String)
    {
        sender_ = sender
        let url = Bundle.main.url(
            forResource: html,
            withExtension: "htm",
            subdirectory: "assets")!
        loadFileURL(url, allowingReadAccessTo: url)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        webView.evaluateJavaScript(
            "var Handler = window.webkit.messageHandlers.Handler_;" +
            "var Handler_Receiver = \(sender_);" +
            "function CallHandler(id, command, info)" +
            "{" +
                "Handler.postMessage(JSON.stringify({\"Receiver\": Handler_Receiver, \"id\": id, \"command\": command, \"info\": info}));" +
            "}" +
            "var cross_asset_domain_ = 'asset://';" +
            "var cross_asset_async_ = false;" +
            "var cross_pointer_type_ = 'touch';" +
            "var cross_pointer_upsidedown_ = false;"
            )
        BridgeHandleAsync(sender_, "body", "ready", "")
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
                    message_dictionary["Receiver"] as! Int32,
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
        if (navigationAction.navigationType != .linkActivated || navigationAction.sourceFrame.webView?.url?.path == navigationAction.request.url?.path)
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
