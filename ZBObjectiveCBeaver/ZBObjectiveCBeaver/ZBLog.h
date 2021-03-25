//
//  ZBLog.h
//  Pods-ZBLog_Example
//
//  Created by Jumbo on 2021/3/10.
//

#import <Foundation/Foundation.h>

@class ZBBaseDestination;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Flags accompany each log. They are used together with levels to filter out logs.
 */
typedef NS_OPTIONS(NSUInteger, ZBLogFlag){
    /**
     *  0...00001 ZBLogFlagError
     */
    ZBLogFlagError      = (1 << 0),

    /**
     *  0...00010 ZBLogFlagWarning
     */
    ZBLogFlagWarning    = (1 << 1),

    /**
     *  0...00100 ZBLogFlagInfo
     */
    ZBLogFlagInfo       = (1 << 2),

    /**
     *  0...01000 ZBLogFlagDebug
     */
    ZBLogFlagDebug      = (1 << 3),

    /**
     *  0...10000 ZBLogFlagVerbose
     */
    ZBLogFlagVerbose    = (1 << 4)
};

/**
 *  Log levels are used to filter out logs. Used together with flags.
 */
typedef NS_ENUM(NSUInteger, ZBLogLevel){
    /**
     *  No logs
     */
    ZBLogLevelOff       = 0,

    /**
     *  Error logs only
     */
    ZBLogLevelError     = (ZBLogFlagError),

    /**
     *  Error and warning logs
     */
    ZBLogLevelWarning   = (ZBLogLevelError   | ZBLogFlagWarning),

    /**
     *  Error, warning and info logs
     */
    ZBLogLevelInfo      = (ZBLogLevelWarning | ZBLogFlagInfo),

    /**
     *  Error, warning, info and debug logs
     */
    ZBLogLevelDebug     = (ZBLogLevelInfo    | ZBLogFlagDebug),

    /**
     *  Error, warning, info, debug and verbose logs
     */
    ZBLogLevelVerbose   = (ZBLogLevelDebug   | ZBLogFlagVerbose),

    /**
     *  All logs (1...11111)
     */
    ZBLogLevelAll       = NSUIntegerMax
};

/**
 *  Extracts just the file name, no path or extension
 *
 *  @param filePath input file path
 *  @param copy     YES if we want the result to be copied
 *
 *  @return the file name
 */
FOUNDATION_EXTERN NSString * __nullable DDExtractFileNameWithoutExtension(const char *filePath, BOOL copy);

/**
 * The THIS_FILE macro gives you an NSString of the file name.
 * For simplicity and clarity, the file name does not include the full path or file extension.
 *
 * For example: ZBLogWarn(@"%@: Unable to find thingy", THIS_FILE) -> @"MyViewController: Unable to find thingy"
 **/
#define THIS_FILE         (DDExtractFileNameWithoutExtension(__FILE__, NO))

/**
 * The THIS_METHOD macro gives you the name of the current objective-c method.
 *
 * For example: ZBLogWarn(@"%@ - Requires non-nil strings", THIS_METHOD) -> @"setMake:model: requires non-nil strings"
 *
 * Note: This does NOT work in straight C functions (non objective-c).
 * Instead you should use the predefined __FUNCTION__ macro.
 **/
#define THIS_METHOD       NSStringFromSelector(_cmd)

@interface ZBLog : NSObject

/**
 *  Returns the singleton `ZBLog`.
 *  The instance is used by `ZBLog` class methods.
 */
@property (class, nonatomic, strong, readonly) ZBLog *sharedInstance;

/// version string of framework
@property (class, nonatomic, strong, readonly) NSString *version; // UPDATE ON RELEASE!

/// build number of framework
@property (class, nonatomic, assign, readonly) NSUInteger build; // version 1.2.1 -> 1210, UPDATE ON RELEASE!

/// a set of active destinations
@property (nonatomic, strong, readonly) NSMutableSet *destinations;

/// returns boolean about success
+ (BOOL)addDestination:(ZBBaseDestination *)destination;

/// returns boolean about success
+ (BOOL)removeDestination:(ZBBaseDestination *)destination;

/// if you need to start fresh
+ (void)removeAllDestinations;

/// returns the amount of destinations
+ (NSInteger)countDestinations;

/// log something generally unimportant (lowest priority)
+ (void)verbose:(const char *)file
       function:(const char *)function
           line:(NSUInteger)line
        context:(nullable id)context
         format:(NSString *)format, ... NS_FORMAT_FUNCTION(5,6);

/// log something which help during debugging (low priority)
+ (void)debug:(const char *)file
     function:(const char *)function
         line:(NSUInteger)line
      context:(nullable id)context
       format:(NSString *)format, ... NS_FORMAT_FUNCTION(5,6);

/// log something which you are really interested but which is not an issue or error (normal priority)
+ (void)info:(const char *)file
    function:(const char *)function
        line:(NSUInteger)line
     context:(nullable id)context
      format:(NSString *)format, ... NS_FORMAT_FUNCTION(5,6);

/// log something which may cause big trouble soon (high priority)
+ (void)warning:(const char *)file
       function:(const char *)function
           line:(NSUInteger)line
        context:(nullable id)context
         format:(NSString *)format, ... NS_FORMAT_FUNCTION(5,6);

/// log something which will keep you awake at night (highest priority)
+ (void)error:(const char *)file
     function:(const char *)function
         line:(NSUInteger)line
      context:(nullable id)context
       format:(NSString *)format, ... NS_FORMAT_FUNCTION(5,6);

/// custom logging to manually adjust values, should just be used by other frameworks
+ (void)custom:(ZBLogLevel)level
          file:(const char *)file
      function:(const char *)function
          line:(NSUInteger)line
       context:(nullable id)context
        format:(NSString *)format, ... NS_FORMAT_FUNCTION(6,7);

@end

NS_ASSUME_NONNULL_END
