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
    typedef void (*FN_LOAD_WEB_VIEW)(void* me, const __int32_t sender, const __int32_t view_info, const char* html, const char* waves);
    typedef void (*FN_LOAD_IMAGE_VIEW)(void* me, const __int32_t sender, const __int32_t view_info, const __int32_t image_width, const char* waves);
    typedef void (*FN_REFRESH_IMAGE_VIEW)(void* me);
    typedef void (*FN_CALL_FUNCTION)(void* me, const char* function);
    typedef const char* (*FN_GET_ASSET)(void* me, const char* key);
    typedef const char* (*FN_GET_PREFERENCE)(void* me, const char* key);
    typedef void (*FN_SET_PREFERENCE)(void* me, const char* key, const char* value);
    typedef void (*FN_POST_THREAD_MESSAGE)(void* me, const __int32_t sender, const char* id, const char* command, const char* info);
    typedef void (*FN_ADD_PARAM)(void* me, const char* key, const char* value);
    typedef void (*FN_POST_HTTP)(void* me, const __int32_t sender, const char* id, const char* command, const char* url);
    typedef void (*FN_PLAY_AUDIO)(void* me, const __int32_t index);
    typedef void (*FN_EXIT)(void* me);

    void SetImageData(__uint32_t* pixels);
    
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
                     FN_EXIT exit);
    void BridgeEnd();
    void BridgeCreate();
    void BridgeDestroy();
    void BridgeStart();
    void BridgeStop();
    void BridgeRestart();
    void BridgeEscape();
    void BridgeHandle(const char* id, const char* command, const char* info);
    void BridgeHandleAsync(__int32_t sender, const char* id, const char* command, const char* info);

#ifdef __cplusplus
}
#endif
