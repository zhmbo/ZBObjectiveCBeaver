//
//  ZBBaseDestination.h
//  Pods-ZBLog_Example
//
//  Created by Jumbo on 2021/3/10.
//

#import <Foundation/Foundation.h>

#import "ZBLog.h"

#if OS_OBJECT_USE_OBJC
    #define DISPATCH_QUEUE_REFERENCE_TYPE strong
#else
    #define DISPATCH_QUEUE_REFERENCE_TYPE assign
#endif

NS_ASSUME_NONNULL_BEGIN

@interface ZBLevelString : NSObject
@property (nonatomic, copy) NSString *verbose;
@property (nonatomic, copy) NSString *debug;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *warning;
@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) NSString *all;
@end

@interface ZBLevelColor : NSObject
@property (nonatomic, copy) NSString *verbose;
@property (nonatomic, copy) NSString *debug;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *warning;
@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) NSString *all;
@end

@interface ZBBaseDestination : NSObject

/**
 each destination instance must have an own serial queue to ensure serial output
 GCD gives it a prioritization between User Initiated and Utility
 */
@property (nonatomic, DISPATCH_QUEUE_REFERENCE_TYPE, readonly) dispatch_queue_t queue;

/// output format pattern, see documentation for syntax
@property (nonatomic, strong) NSString *format;

/// do not log any message which has a lower level than this one
@property (nonatomic, assign) ZBLogLevel minLevel;

/// runs in own serial background thread for better performance
@property (nonatomic, assign) BOOL asynchronously;

/// set custom log level words for each level
@property (nonatomic, strong) ZBLevelString *levelString;

// For a colored log level word in a logged line
// empty on default
@property (nonatomic, strong) ZBLevelColor *levelColor;

/// send / store the formatted log message to the destination
/// returns the formatted log message for processing by inheriting method
/// and for unit tests (nil if error)
- (NSString *)send:(ZBLogLevel)level
               msg:(NSString *)msg
            thread:(NSString *)thread
              file:(NSString *)file
          function:(NSString *)function
              line:(NSUInteger)line
           context:(id)context;

/// Add a filter that determines whether or not a particular message will be logged to this destination
- (void)addFilter:(id)filter;

/// Remove a filter from the list of filters
- (void)removeFilter:(id)filter;

/// Answer whether the destination has any message filters
/// returns boolean and is used to decide whether to resolve
/// the message before invoking shouldLevelBeLogged
- (BOOL)hasMessageFilters;

/// checks if level is at least minLevel or if a minLevel filter for that path does exist
/// returns boolean and can be used to decide if a message should be logged or not
- (BOOL)shouldLevelBeLogged:(ZBLogLevel)level
                       path:(NSString *)path
                   function:(NSString *)function
                    message:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
