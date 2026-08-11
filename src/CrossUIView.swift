//
//  SwiftUIView.swift
//  cross
//
//  Created by Ali Asadpoor on 6/5/21.
//  Copyright © 2021 shaidin. All rights reserved.
//

import SwiftUI
import WebKit

class UIState: ObservableObject
{
    weak var web_view_: WebView! = nil
    @Published var html_: String = ""
    var sender_: __int32_t = 0

    func LoadView(_ sender: __int32_t, _ html: String)
    {
        sender_ = sender
        html_ = html
    }

    func WebCallFunction(_ function: String)
    {
        web_view_?.evaluateJavaScript(function)
    }

    func ClearViewRequest()
    {
        html_ = ""
    }
}

struct WebViewWrapper : UIViewRepresentable
{
    @ObservedObject var the_state_: UIState

    class Coordinator
    {
        var sender_: __int32_t?
        var html_: String?
    }

    func makeCoordinator() -> Coordinator
    {
        Coordinator()
    }

    func updateUIView(_ uiView: WebView, context: Context)
    {
        if (!the_state_.html_.isEmpty &&
            (context.coordinator.sender_ != the_state_.sender_ ||
             context.coordinator.html_ != the_state_.html_))
        {
            context.coordinator.sender_ = the_state_.sender_
            context.coordinator.html_ = the_state_.html_
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
    @StateObject private var the_state_: UIState
    @Environment(\.scenePhase) private var scenePhase

    init(state: UIState)
    {
        _the_state_ = StateObject(wrappedValue: state)
    }

    var body: some View
    {
        WebViewWrapper(the_state_: the_state_)
        .onAppear
        {
            BridgeCreate()
            if (scenePhase == .active)
            {
                BridgeStart()
            }
            else
            {
                BridgeStop()
            }
        }
        .onDisappear
        {
            BridgeStop()
            BridgeDestroy()
            the_state_.ClearViewRequest()
        }
        .onChange(of: scenePhase)
        {newScenePhase in
            if (newScenePhase == .active)
            {
                BridgeStart()
            }
            else
            {
                BridgeStop()
            }
        }
    }
}
