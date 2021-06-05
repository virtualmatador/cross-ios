//
//  BridgeCore.cpp
//  cross
//
//  Created by Ali Asadpoor on 4/7/19.
//  Copyright © 2019 Shaidin. All rights reserved.
//

#include "BridgeCore.h"
#include "../../core/src/bridge.h"
#include "../../core/src/interface.h"


void* me_;
FN_NEED_RESTART need_restart_;
FN_LOAD_WEB_VIEW load_web_view_;
FN_LOAD_IMAGE_VIEW load_image_view_;
FN_REFRESH_IMAGE_VIEW refresh_image_view_;
FN_CALL_FUNCTION call_function_;
FN_GET_ASSET get_asset_;
FN_GET_PREFERENCE get_preference_;
FN_SET_PREFERENCE set_preference_;
FN_POST_THREAD_MESSAGE post_thread_message_;
FN_ADD_PARAM add_param_;
FN_POST_HTTP post_http_;
FN_PLAY_AUDIO play_audio_;
FN_EXIT exit_;
std::uint32_t* pixels_;

void bridge::NeedRestart()
{
    need_restart_(me_);
}

void bridge::LoadWebView(const std::int32_t sender, const std::int32_t view_info, const char* html, const char* waves)
{
    load_web_view_(me_, sender, view_info, html, waves);
}

void bridge::LoadImageView(const std::int32_t sender, const std::int32_t view_info, const std::int32_t image_width, const char* waves)
{
    load_image_view_(me_, sender, view_info, image_width, waves);
}

void bridge::RefreshImageView()
{
    refresh_image_view_(me_);
}

std::uint32_t* bridge::GetPixels()
{
    return pixels_;
}

void bridge::ReleasePixels(std::uint32_t *pixels)
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

void bridge::PostThreadMessage(std::int32_t sender, const char* id, const char* command, const char* info)
{
    post_thread_message_(me_, sender, id, command, info);
}

void bridge::AddParam(const char* key, const char* value)
{
    add_param_(me_, key, value);
}

void bridge::PostHttp(std::int32_t sender,  const char* id, const char* command, const char* url)
{
    post_http_(me_, sender, id, command, url);
}

void bridge::PlayAudio(const std::int32_t index)
{
    play_audio_(me_, index);
}

void bridge::Exit()
{
    exit_(me_);
}

void SetImageData(std::uint32_t* pixels)
{
    pixels_ = pixels;
}

void BridgeBegin(void* me,
                 FN_NEED_RESTART on_restart,
                 FN_LOAD_WEB_VIEW load_web_view,
                 FN_LOAD_IMAGE_VIEW load_image_view,
                 FN_REFRESH_IMAGE_VIEW refresh_image_view,
                 FN_CALL_FUNCTION call_function,
                 FN_GET_ASSET get_asset,
                 FN_GET_PREFERENCE get_preference,
                 FN_SET_PREFERENCE set_preference,
                 FN_POST_THREAD_MESSAGE post_thread_message,
                 FN_ADD_PARAM add_param,
                 FN_POST_HTTP post_http,
                 FN_PLAY_AUDIO play_audio,
                 FN_EXIT exit)
{
    me_ = me;
    need_restart_ = on_restart;
    load_web_view_ = load_web_view;
    load_image_view_ = load_image_view;
    refresh_image_view_ = refresh_image_view;
    call_function_ = call_function;
    get_asset_ = get_asset;
    get_preference_ = get_preference;
    set_preference_ = set_preference;
    post_thread_message_ = post_thread_message;
    add_param_ = add_param;
    post_http_ = post_http;
    play_audio_ = play_audio;
    exit_ = exit;
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

void BridgeEscape()
{
    interface::Escape();
}

void BridgeHandle(const char* id, const char* command, const char* info)
{
    interface::Handle(id, command, info);
}

void BridgeHandleAsync(std::int32_t sender, const char* id, const char* command, const char* info)
{
    interface::HandleAsync(sender, id, command, info);
}
