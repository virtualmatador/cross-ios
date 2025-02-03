//
//  BridgeCore.h
//  cross
//
//  Created by Ali Asadpoor on 4/7/19.
//  Copyright © 2019 Shaidin. All rights reserved.
//

#include <stdint.h>

#ifdef __cplusplus
extern "C"
{
#endif

    typedef void (*FN_NEED_RESTART)(void* me);
    typedef void (*FN_LOAD_VIEW)(void* me, const __int32_t sender, const __int32_t view_info, const char* html);
    typedef void (*FN_CALL_FUNCTION)(void* me, const char* function);
    typedef void (*FN_GET_PREFERENCE)(void* me, const char* key);
    typedef void (*FN_SET_PREFERENCE)(void* me, const char* key, const char* value);
    typedef void (*FN_ASYNC_MESSAGE)(void* me, const __int32_t sender, const char* id, const char* command, const char* info);
    typedef void (*FN_ADD_PARAM)(void* me, const char* key, const char* value);
    typedef void (*FN_POST_HTTP)(void* me, const __int32_t sender, const char* id, const char* command, const char* url);
    typedef void (*FN_CREATE_IMAGE)(void* me, const char* id, const char* parent);
    typedef void (*FN_RESET_IMAGE)(void* me, const __int32_t sender, const __int32_t index, const char* id);
    typedef void (*FN_EXIT)(void* me);

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
                     FN_EXIT exit);
    void BridgeBegin();
    void BridgeEnd();
    void BridgeCreate();
    void BridgeDestroy();
    void BridgeStart();
    void BridgeStop();
    void BridgeRestart();
    void BridgeFeedUri(void* me, const char* uri, void(*consume)(void* me, void* data, __int32_t size));
    void BridgeEscape();
    void BridgeHandle(const char* id, const char* command, const char* info);
    void BridgeHandleAsync(__int32_t sender, const char* id, const char* command, const char* info);
    void BridgeStorePreference(const char* preference);

#ifdef __cplusplus
}
#endif
