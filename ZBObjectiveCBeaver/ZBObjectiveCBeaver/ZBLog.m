//
//  ZBLog.m
//  Pods-ZBLog_Example
//
//  Created by Jumbo on 2021/3/10.
//

#import "ZBLog.h"
#import "ZBBaseDestination.h"

@interface ZBLog() {
    NSMutableSet *_destinations;
}

@end

@implementation ZBLog

/**
 *  Returns the singleton `ZBLog`.
 *  The instance is used by `ZBLog` class methods.
 *
 *  @return The singleton `ZBLog`.
 */
+ (instancetype)sharedInstance {
    static id sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

// version string of framework
+ (NSString *)version {
    return @"0.1.0";
}

// build number of framework
+ (NSUInteger)build {
    return 100;
}

// a set of active destinations
- (NSMutableSet *)destinations {
    if (!_destinations) {
        _destinations = [[NSMutableSet alloc] init];
    }
    return _destinations;
}

// MARK: Destination Handling

// returns boolean about success
+ (BOOL)addDestination:(ZBBaseDestination *)destination {
    return [self.sharedInstance addDestination:destination];
}

- (BOOL)addDestination:(ZBBaseDestination *)destination {
    if ([self.destinations containsObject:destination]) {
        return NO;
    }
    [self.destinations addObject:destination];
    return YES;
}

// returns boolean about success
+ (BOOL)removeDestination:(ZBBaseDestination *)destination {
    return [self removeDestination:destination];
}

- (BOOL)removeDestination:(ZBBaseDestination *)destination {
    if ([self.destinations containsObject:destination]) {
        return NO;
    }
    [self.destinations removeObject:destination];
    return YES;
}

// if you need to start fresh
+ (void)removeAllDestinations {
    [self removeAllDestinations];
}

- (void)removeAllDestinations {
    [self.destinations removeAllObjects];
}

// returns the amount of destinations
+ (NSInteger)countDestinations {
    return [self countDestinations];
}

- (NSUInteger)countDestinations {
    return self.destinations.count;
}

// returns the current thread name
+ (NSString *)threadName {
    if (NSThread.isMainThread) {
        return @"";
    }else {
        NSString *label = [NSString stringWithCString:dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) encoding:NSUTF8StringEncoding];
        return label ?: NSThread.currentThread.name;
    }
}

// MARK: Levels

// log something generally unimportant (lowest priority)
+ (void)verbose:(const char *)file
       function:(const char *)function
           line:(NSUInteger)line
        context:(id)context
         format:(NSString *)format, ... {
    va_list args;
    
    if (format) {
        va_start(args, format);
        
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        
        va_end(args);
        
        va_start(args, format);
        
        [self.sharedInstance dispatch_send:ZBLogLevelVerbose
                                   message:message
                                    thread:[self threadName]
                                      file:[NSString stringWithFormat:@"%s", file]
                                  function:[NSString stringWithFormat:@"%s", function]
                                      line:line
                                   context:context];
        
        va_end(args);
    }
}

// log something which help during debugging (low priority)
+ (void)debug:(const char *)file
     function:(const char *)function
         line:(NSUInteger)line
      context:(id)context
       format:(NSString *)format, ... {
    va_list args;
    
    if (format) {
        va_start(args, format);
        
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        
        va_end(args);
        
        va_start(args, format);
        
        [self.sharedInstance dispatch_send:ZBLogLevelDebug
                                   message:message
                                    thread:[self threadName]
                                      file:[NSString stringWithFormat:@"%s", file]
                                  function:[NSString stringWithFormat:@"%s", function]
                                      line:line
                                   context:context];
        
        va_end(args);
    }
}

// log something which you are really interested but which is not an issue or error (normal priority)
+ (void)info:(const char *)file
    function:(const char *)function
        line:(NSUInteger)line
     context:(id)context
      format:(NSString *)format, ... {
    va_list args;
    
    if (format) {
        va_start(args, format);
        
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        
        va_end(args);
        
        va_start(args, format);
        
        [self.sharedInstance dispatch_send:ZBLogLevelInfo
                                   message:message
                                    thread:[self threadName]
                                      file:[NSString stringWithFormat:@"%s", file]
                                  function:[NSString stringWithFormat:@"%s", function]
                                      line:line
                                   context:context];
        
        va_end(args);
    }
}

// log something which may cause big trouble soon (high priority)
+ (void)warning:(const char *)file
       function:(const char *)function
           line:(NSUInteger)line
        context:(id)context
         format:(NSString *)format, ... {
    va_list args;
    
    if (format) {
        va_start(args, format);
        
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        
        va_end(args);
        
        va_start(args, format);
        
        [self.sharedInstance dispatch_send:ZBLogLevelWarning
                                   message:message
                                    thread:[self threadName]
                                      file:[NSString stringWithFormat:@"%s", file]
                                  function:[NSString stringWithFormat:@"%s", function]
                                      line:line
                                   context:context];
        
        va_end(args);
    }
}

// log something which will keep you awake at night (highest priority)
+ (void)error:(const char *)file
     function:(const char *)function
         line:(NSUInteger)line
      context:(id)context
       format:(NSString *)format, ... {
    va_list args;
    
    if (format) {
        va_start(args, format);
        
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        
        va_end(args);
        
        va_start(args, format);
        
        [self.sharedInstance dispatch_send:ZBLogLevelError
                                   message:message
                                    thread:[self threadName]
                                      file:[NSString stringWithFormat:@"%s", file]
                                  function:[NSString stringWithFormat:@"%s", function]
                                      line:line
                                   context:context];
        
        va_end(args);
    }
}

// custom logging to manually adjust values, should just be used by other frameworks
+ (void)custom:(ZBLogLevel)level
          file:(const char *)file
      function:(const char *)function
          line:(NSUInteger)line
       context:(id)context
        format:(NSString *)format, ... {
    va_list args;
    
    if (format) {
        va_start(args, format);
        
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        
        va_end(args);
        
        va_start(args, format);
        
        [self.sharedInstance dispatch_send:level
                                   message:message
                                    thread:[self threadName]
                                      file:[NSString stringWithFormat:@"%s", file]
                                  function:[NSString stringWithFormat:@"%s", function] line:line
                                   context:context];
        
        va_end(args);
    }
}

// internal helper which dispatches send to dedicated queue if minLevel is ok
- (void)dispatch_send:(ZBLogLevel)level
              message:(NSString *)message
               thread:(NSString *)thread
                 file:(NSString *)file
             function:(NSString *)function
                 line:(NSUInteger)line
              context:(id)context {
    
    for (ZBBaseDestination *dest in self.destinations) {
        
        NSString *resolvedMessage;
        
        if (!dest.queue) continue;
        
        resolvedMessage = resolvedMessage == nil && dest.hasMessageFilters ? message : resolvedMessage;
        
        if ([dest shouldLevelBeLogged:level path:file function:function message:message]) {
            // try to convert msg object to String and put it on queue
            NSString *msgStr = resolvedMessage == nil ? message :resolvedMessage;
            
            NSString *f = [self stripParams:function];
            
            if (dest.asynchronously) {
                dispatch_async(dest.queue, ^{
                    [dest send:level msg:msgStr thread:thread file:file function:f line:line
                       context:context];
                });
            }else {
                dispatch_sync(dest.queue, ^{
                    [dest send:level msg:msgStr thread:thread file:file function:f line:line
                       context:context];
                });
            }
        }
    }
}

- (NSString *)stripParams:(NSString *)function {
    NSString *f = function;
    NSRange range = [f rangeOfString:@"("];
    
    if (range.location != NSNotFound) {
        f = [f substringToIndex:range.location];
    }
    f = [f stringByAppendingString:@"()"];
    return f;
}

@end
