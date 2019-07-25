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
    var vc_: ViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        BridgeBegin(UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
             // OnRestart
            {(me)->Void in
                DispatchQueue.main.async
                {
                    BridgeRestart()
                }
        },
            // LoadWebView
            {(me, sender, view_info, html)->Void in
                let vc = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue().vc_!
                vc.web_view_.sender_ = sender
                vc.web_view_.html_ = String(cString : html!)
                vc.image_view_.ReleasePixels()
                vc.ActivateView(vc.web_view_, view_info)
        },
            // LoadImageView
            {(me, sender, view_info, image_width)->Void in
                let vc = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue().vc_!
                vc.image_view_.sender_ = sender
                vc.image_view_.image_width_ = image_width
                vc.ActivateView(vc.image_view_, view_info)
        },
            // RefreshImageView
            {(me)->Void in
                let vc = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue().vc_!
                vc.image_view_.Refresh()
        },
            // CallFunction
            {(me, function)->Void in
                let vc = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue().vc_!
                vc.web_view_.CallFunction(String(cString : function!))
        },
            // GetAsset
            {(me, key) in
                let vc = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue().vc_!
                let path = Bundle.main.path(
                    forResource: String(cString : key!),
                    ofType: "",
                    inDirectory: "assets")!
                vc.temp_buffer_ = try! String(contentsOfFile: path)
                return UnsafePointer<Int8>(vc.temp_buffer_);
        },
            // GetPreference
            {(me, key) in
                let vc = Unmanaged<AppDelegate>.fromOpaque(me!).takeUnretainedValue().vc_!
                vc.temp_buffer_ = UserDefaults.standard.string(forKey: String(cString : key!)) ?? ""
                return UnsafePointer<Int8>(vc.temp_buffer_)
        },
            // SetPreference
            {(me, key, value) in
                UserDefaults.standard.set(String(cString: value!), forKey: String(cString: key!))
        },
            // PostThreadMessage
            {(me, sender, message) in
                DispatchQueue.main.async {
                    BridgeHandle(sender, message)
                }
        });

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        BridgeStop()
        BridgeDestroy()
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
        BridgeCreate()
        BridgeStart()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        BridgeEnd()
    }

}

