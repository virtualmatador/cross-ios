//
//  BridgeCore.cpp
//  cross
//
//  Created by Ali Asadpoor on 4/7/19.
//  Copyright © 2019 Shaidin. All rights reserved.
//

#include "BridgeCore.h"
#include "../extern/core/src/bridge.h"
#include "../extern/core/src/cross.h"

void* me_;
FN_NEED_RESTART need_restart_;
FN_LOAD_VIEW load_view_;
FN_CALL_FUNCTION call_function_;
FN_GET_PREFERENCE get_preference_;
FN_SET_PREFERENCE set_preference_;
FN_ASYNC_MESSAGE async_message_;
FN_ADD_PARAM add_param_;
FN_POST_HTTP post_http_;
FN_CREATE_IMAGE create_image_;
FN_RESET_IMAGE reset_image_;
FN_EXIT exit_;

std::string preference_;

void bridge::NeedRestart()
{
    need_restart_(me_);
}

void bridge::LoadView(const std::int32_t sender, const std::int32_t view_info, const char* html)
{
    load_view_(me_, sender, view_info, html);
}

void bridge::CallFunction(const char* function)
{
    call_function_(me_, function);
}

std::string bridge::GetPreference(const char* key)
{
    get_preference_(me_, key);
    return preference_;
}

void bridge::SetPreference(const char* key, const char* value)
{
    set_preference_(me_, key, value);
}

void bridge::AsyncMessage(std::int32_t sender, const char* id, const char* command, const char* info)
{
    async_message_(me_, sender, id, command, info);
}

void bridge::AddParam(const char* key, const char* value)
{
    add_param_(me_, key, value);
}

void bridge::PostHttp(std::int32_t sender,  const char* id, const char* command, const char* url)
{
    post_http_(me_, sender, id, command, url);
}

void bridge::CreateImage(const char* id, const char* parent)
{
    create_image_(me_, id, parent);
}

void bridge::ResetImage(const std::int32_t sender, const std::int32_t index, const char *id)
{
    reset_image_(me_, sender, index, id);
}

void bridge::Exit()
{
    exit_(me_);
}

void BridgeSetup(void* me,
                 FN_NEED_RESTART on_restart,
                 FN_LOAD_VIEW load_view,
                 FN_CALL_FUNCTION call_function,
                 FN_GET_PREFERENCE get_preference,
                 FN_SET_PREFERENCE set_preference,
                 FN_ASYNC_MESSAGE async_message,
                 FN_ADD_PARAM add_param,
                 FN_POST_HTTP post_http,
                 FN_CREATE_IMAGE create_image,
                 FN_RESET_IMAGE reset_image,
                 FN_EXIT exit)
{
    me_ = me;
    need_restart_ = on_restart;
    load_view_ = load_view;
    call_function_ = call_function;
    get_preference_ = get_preference;
    set_preference_ = set_preference;
    async_message_ = async_message;
    add_param_ = add_param;
    post_http_ = post_http;
    create_image_ = create_image;
    reset_image_ = reset_image;
    exit_ = exit;
}

void BridgeBegin()
{
    cross::Begin();
}

void BridgeEnd()
{
    cross::End();
}

void BridgeCreate()
{
    cross::Create();
}

void BridgeDestroy()
{
    cross::Destroy();
}

void BridgeStart()
{
    cross::Start();
}

void BridgeStop()
{
    cross::Stop();
}

void BridgeRestart()
{
    cross::Restart();
}

void BridgeFeedUri(void* me, const char* uri, void(*consume)(void* me, void* data, __int32_t size))
{
    cross::FeedUri(uri, [&](const std::vector<unsigned char>& data)
    {
        consume(me, (void*)data.data(), (__int32_t)data.size());
    });
}

void BridgeEscape()
{
    cross::Escape();
}

void BridgeHandle(const char* id, const char* command, const char* info)
{
    cross::Handle(id, command, info);
}

void BridgeHandleAsync(std::int32_t sender, const char* id, const char* command, const char* info)
{
    cross::HandleAsync(sender, id, command, info);
}

void BridgeStorePreference(const char* preference)
{
    preference_ = preference;
}
