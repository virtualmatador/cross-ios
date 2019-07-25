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

    typedef void (*FN_ON_RESTART)(void* me);
    typedef void (*FN_LOAD_WEB_VIEW)(void* me, const __int32_t sender, const __int32_t view_info, const char* html);
    typedef void (*FN_LOAD_IMAGE_VIEW)(void* me, const __int32_t sender, const __int32_t view_info, const __int32_t image_width);
    typedef void (*FN_REFRESH_IMAGE_VIEW)(void* me);
    typedef void (*FN_CALL_FUNCTION)(void* me, const char* function);
    typedef const char* (*FN_GET_ASSET)(void* me, const char* key);
    typedef const char* (*FN_GET_PREFERENCE)(void* me, const char* key);
    typedef void (*FN_SET_PREFERENCE)(void* me, const char* key, const char* value);
    typedef void (*FN_POST_THREAD_MESSAGE)(void* me, const __int32_t sender, const char* message);
    typedef void (*FN_GET_PIXELS)(void* me);
    typedef void (*FN_RELEASE_PIXELS)(void* me);

    void BridgeBegin(void* me,
                     FN_ON_RESTART on_restart,
                     FN_LOAD_WEB_VIEW load_web_view,
                     FN_LOAD_IMAGE_VIEW load_image_view,
                     FN_REFRESH_IMAGE_VIEW refresh_image_view,
                     FN_CALL_FUNCTION call_function,
                     FN_GET_ASSET get_asset,
                     FN_GET_PREFERENCE get_preference,
                     FN_SET_PREFERENCE set_preference,
                     FN_POST_THREAD_MESSAGE post_thread_message);
    void BridgeEnd();
    void BridgeCreate();
    void BridgeDestroy();
    void BridgeStart();
    void BridgeStop();
    void BridgeRestart();
    void BridgeSetImageData(__int32_t* pixels);
    void BridgeRunImageView(__int32_t sender, __int32_t dpi, __int32_t width, __int32_t height);
    void BridgeHandle(__int32_t sender, const char *message);

#ifdef __cplusplus
}
#endif
