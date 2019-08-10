//
//  AppDelegate.swift
//  cross
//
//  Created by Ali Asadpoor on 1/15/19.
//  Copyright © 2019 Shaidin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var temp_buffer_: String?
    var view_controller_: ViewController?
    var root_controller_: RootController?
    var http_params_:[(String, String)]? = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        BridgeBegin(UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
             // NeedRestart
            {(me)->Void in
                DispatchQueue.main.async
                {
                    BridgeRestart()
                }
        },
            // LoadWebView
            {(me, sender, view_info, html)->Void in
                let vc = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue().view_controller_!
                vc.LoadWebView(sender, view_info, String(cString : html!))
        },
            // LoadImageView
            {(me, sender, view_info, image_width)->Void in
                let vc = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue().view_controller_!
                vc.LoadImageView(sender, view_info, image_width)
        },
            // RefreshImageView
            {(me)->Void in
                let vc = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue().view_controller_!
                vc.image_view_.Refresh()
        },
            // CallFunction
            {(me, function)->Void in
                let vc = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue().view_controller_!
                vc.web_view_.CallFunction(String(cString : function!))
        },
            // GetAsset
            {(me, key) in
                let app = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue()
                let path = Bundle.main.path(
                    forResource: String(cString : key!),
                    ofType: "",
                    inDirectory: "assets")!
                app.temp_buffer_ = try! String(contentsOfFile: path)
                return UnsafePointer<Int8>(app.temp_buffer_);
        },
            // GetPreference
            {(me, key) in
                let app = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue()
                app.temp_buffer_ = UserDefaults.standard.string(forKey: String(cString : key!)) ?? ""
                return UnsafePointer<Int8>(app.temp_buffer_)
        },
            // SetPreference
            {(me, key, value) in
                UserDefaults.standard.set(String(cString: value!), forKey: String(cString: key!))
        },
            // PostThreadMessage
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
            {(me, sender, url, id, command) in
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
            // Exit
            {(me) in
                UIApplication.shared.performSelector(onMainThread: #selector(NSXPCConnection.suspend), with: nil, waitUntilDone: false)
        });

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        root_controller_!.UnloadController()
        {
            BridgeStop()
            BridgeDestroy()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        root_controller_!.LoadController()
        {
            BridgeCreate()
            BridgeStart()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        BridgeEnd()
    }

}

