//
//  SwiftUIView.swift
//  cross
//
//  Created by Ali Asadpoor on 6/5/21.
//  Copyright © 2021 shaidin. All rights reserved.
//

import SwiftUI
import AVFoundation
import WebKit

class UIState: ObservableObject
{
    weak var web_view_: WebView! = nil
    @Published var html_: String = ""
    var sender_: __int32_t = 0
    var view_info_: __int32_t = 0
}

struct WebViewWrapper : UIViewRepresentable
{
    @ObservedObject var the_state_: UIState

    func updateUIView(_ uiView: WebView, context: Context)
    {
        if (!the_state_.html_.isEmpty)
        {
            uiView.setNeedsLayout()
            uiView.LoadView(the_state_.sender_, the_state_.html_)
        }
    }

    func makeUIView(context: Context) -> WebView
    {
        let wv = WebView()
        the_state_.web_view_ = wv;
        return wv
    }
}

struct CrossUIView: View
{
    @ObservedObject var the_state_: UIState = UIState()

    @State var oldScenePhase: ScenePhase = ScenePhase.background
    @Environment(\.scenePhase) private var scenePhase

    weak var appDelegate: AppDelegate!

    func LoadView(_ sender: __int32_t, _ view_info: __int32_t, _ html: String)
    {
        UIApplication.shared.isIdleTimerDisabled = (view_info & 4) != 0
        if ((view_info & 1) != 0)
        {
            appDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            if (UIDevice.current.orientation.rawValue != UIInterfaceOrientation.portraitUpsideDown.rawValue)
            {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
        }
        else if ((view_info & 2) != 0)
        {
            appDelegate.orientationLock = UIInterfaceOrientationMask.landscape
            if (UIDevice.current.orientation.rawValue != UIInterfaceOrientation.landscapeRight.rawValue)
            {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            }
        }
        else
        {
            appDelegate.orientationLock = UIInterfaceOrientationMask.all
        }
        UINavigationController.attemptRotationToDeviceOrientation()
        do
        {
            if ((view_info & 8) != 0)
            {
                try AVAudioSession.sharedInstance().setCategory(
                    AVAudioSession.Category.ambient)
            }
            else
            {
                try AVAudioSession.sharedInstance().setCategory(
                    AVAudioSession.Category.soloAmbient)                
            }
        }
        catch
        {
        }
        the_state_.view_info_ = view_info
        the_state_.sender_ = sender
        the_state_.html_ = html
    }
    
    func WebCallFunction(_ function: String)
    {
        the_state_.web_view_.evaluateJavaScript(function);
    }

    var body: some View
    {
        WebViewWrapper(the_state_: the_state_)
        .onChange(of: scenePhase)
        {newScenePhase in
            switch newScenePhase
            {
              case .active:
                if (oldScenePhase == .background)
                {
                    BridgeCreate()
                    oldScenePhase = .inactive
                }
                if (oldScenePhase == .inactive)
                {
                    BridgeStart()
                }
              case .inactive:
                if (oldScenePhase == .active)
                {
                    BridgeStop()
                }
                else if (oldScenePhase == .background)
                {
                    BridgeCreate()
                }
              case .background:
                if (oldScenePhase == .active)
                {
                    BridgeStop()
                    oldScenePhase = .inactive
                }
                if (oldScenePhase == .inactive)
                {
                    BridgeDestroy()
                }
            }
            oldScenePhase = newScenePhase
        }
    }
}
