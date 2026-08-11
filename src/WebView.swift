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
    private class FeedResult
    {
        var data = Data()
    }

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask)
    {
        let result = FeedResult()
        let feed =
        {
            BridgeFeedUri(
                UnsafeMutableRawPointer(Unmanaged.passUnretained(result).toOpaque()),
                urlSchemeTask.request.url?.absoluteString,
                {(me, data, size)->Void in
                    guard let me = me, let data = data, size > 0 else
                    {
                        return
                    }
                    let result = Unmanaged<FeedResult>.fromOpaque(me).takeUnretainedValue()
                    result.data = Data(bytes: data, count: Int(size))
                })
        }
        if (Thread.isMainThread)
        {
            feed()
        }
        else
        {
            DispatchQueue.main.sync(execute: feed)
        }
        urlSchemeTask.didReceive(URLResponse(
            url: urlSchemeTask.request.url!, mimeType: "",
            expectedContentLength: result.data.count, textEncodingName: nil))
        if (!result.data.isEmpty)
        {
            urlSchemeTask.didReceive(result.data)
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
    private var navigation_receivers_: [ObjectIdentifier: __int32_t] = [:]

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
        let url = Bundle.main.url(
            forResource: html,
            withExtension: "htm",
            subdirectory: "assets")!
        navigation_receivers_.removeAll()
        if let navigation = loadFileURL(url, allowingReadAccessTo: url)
        {
            navigation_receivers_[ObjectIdentifier(navigation)] = sender
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        guard let navigation = navigation,
              let receiver = navigation_receivers_.removeValue(
                forKey: ObjectIdentifier(navigation))
        else
        {
            return
        }
        webView.evaluateJavaScript(
            "var Handler = window.webkit.messageHandlers.Handler_;" +
            "var Handler_Receiver = \(receiver);" +
            "function CallHandler(id, command, info)" +
            "{" +
                "Handler.postMessage(JSON.stringify({\"Receiver\": Handler_Receiver, \"id\": id, \"command\": command, \"info\": info}));" +
            "}" +
            "var cross_asset_domain_ = 'asset://';" +
            "var cross_asset_async_ = false;" +
            "var cross_pointer_type_ = 'touch';" +
            "var cross_pointer_upsidedown_ = false;"
            )
        BridgeHandleAsync(receiver, "body", "ready", "")
    }
    
    func userContentController(_ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage)
    {
        do
        {
            guard let body = message.body as? String,
                  let message_data = body.data(using: .utf8),
                  let message_dictionary = try JSONSerialization.jsonObject(
                    with: message_data) as? [String : Any],
                  let receiver = message_dictionary["Receiver"] as? NSNumber,
                  let id = message_dictionary["id"] as? String,
                  let command = message_dictionary["command"] as? String,
                  let info = message_dictionary["info"] as? String
            else
            {
                return
            }
            DispatchQueue.main.async
            {
                BridgeHandleAsync(
                    receiver.int32Value, id, command, info)
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
