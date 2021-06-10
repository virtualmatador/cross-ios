//
//  SwiftUIApp.swift
//  colorcode
//
//  Created by Ali Asadpoor on 6/6/21.
//

import SwiftUI
import AVFoundation

@main
class CrossUIApp: App
{
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var the_view_: CrossUIView!
    var temp_buffer_: String?
    var http_params_:[(String, String)]? = []
    var players_: [AVAudioPlayer?] = []

    required init()
    {
        the_view_ = CrossUIView(appDelegate: appDelegate)
        BridgeBegin(UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
             // NeedRestart
            {(me)->Void in
                DispatchQueue.main.async
                {
                    BridgeRestart()
                }
        },
            // LoadWebView
            {(me, sender, view_info, html, waves)->Void in
                let app = Unmanaged<CrossUIApp>.fromOpaque(me!).takeUnretainedValue()
                app.the_view_.LoadWebView(sender, view_info, String(cString : html!))
                app.loadAudio(String(cString: waves!))
        },
            // LoadImageView
            {(me, sender, view_info, image_width, waves)->Void in
                let app = Unmanaged<CrossUIApp>.fromOpaque(me!).takeUnretainedValue()
                app.the_view_.LoadImageView(sender, view_info, image_width)
                app.loadAudio(String(cString: waves!))
        },
            // RefreshImageView
            {(me)->Void in
                let app = Unmanaged<CrossUIApp>.fromOpaque(me!).takeUnretainedValue()
                app.the_view_.ImageRefresh()
        },
            // CallFunction
            {(me, function)->Void in
                let app = Unmanaged<CrossUIApp>.fromOpaque(me!).takeUnretainedValue()
                app.the_view_.WebCallFunction(String(cString : function!))
        },
            // GetAsset
            {(me, key) in
                let app = Unmanaged<CrossUIApp>.fromOpaque(me!).takeUnretainedValue()
                let path = Bundle.main.path(
                    forResource: String(cString : key!),
                    ofType: "",
                    inDirectory: "assets")!
                app.temp_buffer_ = try! String(contentsOfFile: path)
                return UnsafePointer<Int8>(app.temp_buffer_)
        },
            // GetPreference
            {(me, key) in
                let app = Unmanaged<CrossUIApp>.fromOpaque(me!).takeUnretainedValue()
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
                let app = Unmanaged<CrossUIApp>.fromOpaque(me!).takeUnretainedValue()
                app.http_params_!.append((String(cString: key!), String(cString: value!)))
        },
            // PostHttp
            {(me, sender, id, command, url) in
                let app = Unmanaged<CrossUIApp>.fromOpaque(me!).takeUnretainedValue()
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
            // PlayAudio
            {(me, index) in
                let app = Unmanaged<CrossUIApp>.fromOpaque(me!).takeUnretainedValue()
                if (app.players_[Int(index)] != nil)
                {
                    app.players_[Int(index)]!.currentTime = 0
                    app.players_[Int(index)]!.play()
                }
        },
            // Exit
            {(me) in
                UIApplication.shared.performSelector(onMainThread: #selector(NSXPCConnection.suspend), with: nil, waitUntilDone: false)
        });
        BridgeCreate()
        BridgeStart()
    }
    
    deinit
    {
        BridgeEnd()
    }

    func loadAudio(_ waves: String)
    {
        let wave_arr = waves.split{$0 == " "}.map(String.init)
        players_.removeAll()
        for wave in wave_arr
        {
            let url = Bundle.main.url(
            forResource: wave,
            withExtension: "wav",
            subdirectory: "assets/wave")!
            let player = try? AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            players_.append(player)
        }
    }
    
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene
    {
        WindowGroup
        {
            the_view_
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate
{
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return orientationLock
    }
}