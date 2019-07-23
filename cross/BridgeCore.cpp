//
//  BridgeCore.cpp
//  cross
//
//  Created by Ali Asadpoor on 4/7/19.
//  Copyright © 2019 Shaidin. All rights reserved.
//

#include "BridgeCore.h"
#include "../../core/bridge.h"
#include "../../core/interface.h"


void* me_;
FN_ON_RESTART on_restart_;
FN_LOAD_WEB_VIEW load_web_view_;
FN_LOAD_IMAGE_VIEW load_image_view_;
FN_REFRESH_IMAGE_VIEW refresh_image_view_;
FN_CALL_FUNCTION call_function_;
FN_GET_ASSET get_asset_;
FN_GET_PREFERENCE get_preference_;
FN_SET_PREFERENCE set_preference_;
FN_POST_THREAD_MESSAGE post_thread_message_;
__int32_t* pixels_;

void bridge::OnRestart()
{
    on_restart_(me_);
}

void bridge::LoadWebView(const __int32_t sender, const __int32_t view_info, const char* html)
{
    load_web_view_(me_, sender, view_info, html);
}

void bridge::LoadImageView(const __int32_t sender, const __int32_t view_info)
{
    load_image_view_(me_, sender, view_info);
}

void bridge::RefreshImageView()
{
    refresh_image_view_(me_);
}

__int32_t* bridge::GetPixels()
{
    return pixels_;
}

void bridge::ReleasePixels(__int32_t *pixels)
{
}

void bridge::CallFunction(const char* function)
{
    call_function_(me_, function);
}

std::string bridge::GetAsset(const char *key)
{
    return get_asset_(me_, key);
}

std::string bridge::GetPreference(const char* key)
{
    return get_preference_(me_, key);
}

void bridge::SetPreference(const char* key, const char* value)
{
    set_preference_(me_, key, value);
}

void bridge::PostThreadMessage(__int32_t sender, const char* message)
{
    post_thread_message_(me_, sender, message);
}

void BridgeBegin(void* me,
                 FN_ON_RESTART on_restart,
                 FN_LOAD_WEB_VIEW load_web_view,
                 FN_LOAD_IMAGE_VIEW load_image_view,
                 FN_REFRESH_IMAGE_VIEW refresh_image_view,
                 FN_CALL_FUNCTION call_function,
                 FN_GET_ASSET get_asset,
                 FN_GET_PREFERENCE get_preference,
                 FN_SET_PREFERENCE set_preference,
                 FN_POST_THREAD_MESSAGE post_thread_message)
{
    me_ = me;
    on_restart_ = on_restart;
    load_web_view_ = load_web_view;
    load_image_view_ = load_image_view;
    refresh_image_view_ = refresh_image_view;
    call_function_ = call_function;
    get_asset_ = get_asset;
    get_preference_ = get_preference;
    set_preference_ = set_preference;
    post_thread_message_ = post_thread_message;
    interface::Begin();
}

void BridgeEnd()
{
    interface::End();
}

void BridgeCreate()
{
    interface::Create();
}

void BridgeDestroy()
{
    interface::Destroy();
}

void BridgeStart()
{
    interface::Start();
}

void BridgeStop()
{
    interface::Stop();
}

void BridgeRestart()
{
    interface::Restart();
}

void BridgeSetImageData(__int32_t* pixels)
{
    pixels_ = pixels;
}

void BridgeRunImageView(__int32_t sender, __int32_t width, __int32_t height)
{
    interface::RunImageView(sender, width, height);
}

void BridgeHandle(__int32_t sender, const char* message)
{
    interface::Handle(sender, message);
}
