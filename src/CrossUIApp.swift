//
//  SwiftUIApp.swift
//  cross
//
//  Created by Ali Asadpoor on 6/6/21.
//  Copyright © 2021 shaidin. All rights reserved.
//

import AVFoundation
import SwiftUI

@main
struct CrossUIApp: App
{
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene
    {
        WindowGroup
        {
            appDelegate.the_view_.ignoresSafeArea()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate
{
    var orientationLock = UIInterfaceOrientationMask.all
    var the_view_: CrossUIView!
    var ui_state_: UIState!
    var http_params_:[(String, String)]? = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        ui_state_ = UIState()
        the_view_ = CrossUIView(state: ui_state_)
        BridgeSetup(UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            // LoadView
            {(me, sender, html)->Void in
                let app = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue()
                let file = String(cString : html!)
                DispatchQueue.main.async
                {
                    app.ui_state_.LoadView(sender, file)
                }
        },
            // SetScreenOn
            {(me, screen_on)->Void in
                DispatchQueue.main.async
                {
                    UIApplication.shared.isIdleTimerDisabled = screen_on != 0
                }
        },
            // SetAudioNoSolo
            {(me, audio_no_solo)->Void in
                DispatchQueue.main.async
                {
                    do
                    {
                        try AVAudioSession.sharedInstance().setCategory(
                            audio_no_solo != 0 ? .ambient : .soloAmbient)
                    }
                    catch
                    {
                    }
                }
        },
            // SetLayout
            {(me, portrait, landscape)->Void in
                let app = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue()
                DispatchQueue.main.async
                {
                    app.SetLayout(portrait != 0, landscape != 0)
                }
        },
            // CallFunction
            {(me, function)->Void in
                let app = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue()
                let script = String(cString : function!)
                DispatchQueue.main.async
                {
                    app.ui_state_.WebCallFunction(script)
                }
        },
            // GetPreference
            {(me, key) in
            let preference = UserDefaults.standard.string(forKey: String(cString : key!)) ?? ""
            preference.withCString({(buffer)->Void in
                BridgeStorePreference(buffer)
            })
        },
            // SetPreference
            {(me, key, value) in
                UserDefaults.standard.set(String(cString: value!), forKey: String(cString: key!))
        },
            // AsyncMessage
            {(me, sender, id, command, info) in
                let s_id = String(cString: id!)
                let s_command = String(cString: command!)
                let s_info = String(cString: info!)
                DispatchQueue.main.async
                {
                    BridgeHandleAsync(sender, s_id, s_command, s_info)
                }
        },
            // AddParam
            {(me, key, value) in
                let app = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue()
                app.http_params_!.append((String(cString: key!), String(cString: value!)))
        },
            // PostHttp
            {(me, sender, id, command, url) in
                let app = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue()
                let s_id = String(cString: id!)
                let s_command = String(cString: command!)
                var s_info: String = ""
                let dataURL = URL(string: String(cString: url!))!
                var request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                if (!app.http_params_!.isEmpty)
                {
                    var body = ""
                    for param in app.http_params_!
                    {
                        body.append(param.0.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)
                        body.append("=")
                        body.append(param.1.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)
                        body.append("&")
                    }
                    body.remove(at: body.index(before: body.endIndex))
                    request.httpBody = body.data(using: String.Encoding.utf8)
                }
                let task = URLSession.shared.dataTask(with: request, completionHandler:
                {(data, response, error) in
                    if (error == nil && data != nil && response != nil && (200 ... 299) ~= (response! as! HTTPURLResponse).statusCode)
                    {
                        s_info = String(data: data!, encoding: String.Encoding.utf8)!
                    }
                    DispatchQueue.main.async
                    {
                        BridgeHandleAsync(sender, s_id, s_command, s_info)
                    }
                })
                task.resume()
                app.http_params_?.removeAll()
        },
            // CreateImage
            {(me, id, parent)->Void in
                let app = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue()
                let script =
                    "var img = document.createElement('img');" +
                    "img.setAttribute('id', '" + String(cString : id!) + "');" +
                    "document.getElementById('" + String(cString : parent!) + "').appendChild(img);"
                DispatchQueue.main.async
                {
                    app.ui_state_.WebCallFunction(script)
                }
        },
            // ResetImage
            {(me, sender, index, id)->Void in
                let app = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue()
                let script = "resetImage(" + String(sender) + "," + String(index) + ",'" + String(cString : id!) + "')"
                DispatchQueue.main.async
                {
                    app.ui_state_.WebCallFunction(script)
                }
        },
            // Exit
            {(me) in
                UIApplication.shared.performSelector(onMainThread: #selector(NSXPCConnection.suspend), with: nil, waitUntilDone: false)
        });
        BridgeBegin()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        BridgeEnd()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return orientationLock
    }

    func SetLayout(_ portrait: Bool, _ landscape: Bool)
    {
        if (portrait)
        {
            orientationLock = UIInterfaceOrientationMask.portrait
            if (UIDevice.current.orientation.rawValue != UIInterfaceOrientation.portraitUpsideDown.rawValue)
            {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
        }
        else if (landscape)
        {
            orientationLock = UIInterfaceOrientationMask.landscape
            if (UIDevice.current.orientation.rawValue != UIInterfaceOrientation.landscapeRight.rawValue)
            {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            }
        }
        else
        {
            orientationLock = UIInterfaceOrientationMask.all
        }
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
