//
//  SwiftUIView.swift
//  colorcode
//
//  Created by Ali Asadpoor on 6/5/21.
//

import SwiftUI
import AVFoundation

class UIState: ObservableObject
{
    @Published var showWeb_: Bool = false
    @Published var showImage_: Bool = false
    @Published var showButton_: Bool = false

    weak var web_view_: WebView! = nil
    var html_: String = ""

    weak var image_view_: ImageView! = nil
    var image_width_: Int32 = 0

    var sender_: Int32 = 0
    var view_info_: Int32 = 0
}

struct WebViewWrapper : UIViewRepresentable
{
    @ObservedObject var the_state_: UIState

    func updateUIView(_ uiView: WebView, context: Context)
    {
        uiView.LoadView(the_state_.sender_, the_state_.html_)
    }
    func makeUIView(context: Context) -> WebView
    {
        let wv = WebView()
        wv.setup()
        the_state_.web_view_ = wv;
        return wv
    }
}

struct ImageViewWrapper : UIViewRepresentable
{
    @ObservedObject var the_state_: UIState

    func updateUIView(_ uiView: ImageView, context: Context)
    {
        uiView.LoadView(the_state_.sender_, the_state_.image_width_)
    }
    func makeUIView(context: Context) -> ImageView
    {
        let iv = ImageView()
        the_state_.image_view_ = iv
        return iv
    }
}

struct CrossUIView: View
{
    @ObservedObject var the_state_: UIState = UIState()

    @State var oldScenePhase: ScenePhase = ScenePhase.active
    @Environment(\.scenePhase) private var scenePhase

    weak var appDelegate: AppDelegate!

    func LoadWebView(_ sender: Int32, _ view_info: Int32, _ html: String)
    {
        the_state_.showImage_ = false
        ActivateView(view_info)
        the_state_.sender_ = sender
        the_state_.html_ = html
        the_state_.showWeb_ = true
    }
    
    func WebCallFunction(_ function: String)
    {
        the_state_.web_view_.evaluateJavaScript(function);
    }

    func LoadImageView(_ sender: Int32, _ view_info: Int32, _ image_width: Int32)
    {
        the_state_.showWeb_ = false
        ActivateView(view_info)
        the_state_.sender_ = sender
        the_state_.image_width_ = image_width
        the_state_.showImage_ = true
     }
    
    func ImageRefresh()
    {
        the_state_.image_view_.Refresh()
    }
    
    func ActivateView(_ view_info: Int32)
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
        the_state_.view_info_ = view_info
        the_state_.showButton_ = (the_state_.view_info_ & 8) != 0
    }
     
    var body: some View
    {
        ZStack
        {
            if (the_state_.showWeb_)
            {
                WebViewWrapper(the_state_: the_state_)
            }
            if (the_state_.showImage_)
            {
                ImageViewWrapper(the_state_: the_state_)
                    .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                .onChanged { value in
                                    the_state_.image_view_.touch_moved(value.location)
                                }
                                .onEnded { _ in
                                    the_state_.image_view_.touch_ended()
                                }
                        )
            }
            if (the_state_.showButton_)
            {
                VStack
                {
                    HStack
                    {
                        Spacer()
                        Button(action: { BridgeEscape()}, label: { Image("MenuClose") })
                    }
                    Spacer()
                }
            }
        }
        .onChange(of: scenePhase)
        {newScenePhase in
            switch newScenePhase
            {
              case .active:
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
                if (oldScenePhase == .inactive)
                {
                    BridgeDestroy()
                }
            }
            oldScenePhase = newScenePhase
        }
    }
}
