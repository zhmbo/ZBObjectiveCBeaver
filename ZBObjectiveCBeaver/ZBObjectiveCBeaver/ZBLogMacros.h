//
//  ZBLogMacros.h
//  Pods
//
//  Created by Jumbo on 2021/3/13.
//

#ifndef ZBLogMacros_h
#define ZBLogMacros_h

// Disable legacy macros
#ifndef ZD_LEGACY_MACROS
    #define ZD_LEGACY_MACROS 0
#endif

#import "ZBLog.h"

/**
 * The constant/variable/method responsible for controlling the current log level.
 **/
#ifndef LOG_LEVEL_DEF
    #define LOG_LEVEL_DEF ddLogLevel
#endif

/**
 * Whether async should be used by log messages, excluding error messages that are always sent sync.
 **/
#ifndef LOG_ASYNC_ENABLED
    #define LOG_ASYNC_ENABLED YES
#endif

/**
 * These are the two macros that all other macros below compile into.
 * These big multiline macros makes all the other macros easier to read.
 **/
#define LOG_MACRO(lvl, fnct, ctx, frmt, ...)   \
        [ZBLog custom : lvl                    \
                 file : __FILE__               \
             function : fnct                   \
                 line : __LINE__               \
              context : ctx                    \
               format : (frmt), ## __VA_ARGS__]

/**
 * Ready to use log macros with no context or tag.
 **/
#define LOG_MAYBE(lvl, fnct, ctx, frmt, ...) \
        do { if((lvl) != 0) LOG_MACRO(lvl, fnct, ctx, frmt, ##__VA_ARGS__); } while(0)

#define ZBLogError(frmt, ...)     LOG_MAYBE(ZBLogLevelError,   __PRETTY_FUNCTION__, nil, frmt, ##__VA_ARGS__)
#define ZBLogWarn(frmt, ...)      LOG_MAYBE(ZBLogLevelWarning, __PRETTY_FUNCTION__, nil, frmt, ##__VA_ARGS__)
#define ZBLogInfo(frmt, ...)      LOG_MAYBE(ZBLogLevelInfo,    __PRETTY_FUNCTION__, nil, frmt, ##__VA_ARGS__)
#define ZBLogDebug(frmt, ...)     LOG_MAYBE(ZBLogLevelDebug,   __PRETTY_FUNCTION__, nil, frmt, ##__VA_ARGS__)
#define ZBLogVerbose(frmt, ...)   LOG_MAYBE(ZBLogLevelVerbose, __PRETTY_FUNCTION__, nil, frmt, ##__VA_ARGS__)

#endif /* ZBLogMacros_h */
