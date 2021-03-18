//
//  ZBBaseDestination.m
//  Pods-ZBLog_Example
//
//  Created by Jumbo on 2021/3/10.
//

#import <ZBObjectiveCBeaver/ZBBaseDestination.h>
#import <ZBObjectiveCBeaver/ZBLog.h>

#ifndef ZB_DEBUG
    #define ZB_DEBUG 0
#endif

#define NSLogDebug(frmt, ...) do{ if(ZB_DEBUG) NSLog((frmt), ##__VA_ARGS__); } while(0)

@implementation ZBLevelString @end
@implementation ZBLevelColor @end

@interface ZBBaseDestination()

@property (nonatomic, strong) NSMutableArray *filters;

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation ZBBaseDestination

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        NSString *uuid = NSUUID.UUID.UUIDString;
        NSString *queueLabel = [NSString stringWithFormat:@"ddlog-queue-%@",uuid];
        _queue = dispatch_queue_create(queueLabel.UTF8String, NULL);
        
        _format = @"$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M";
        
        _asynchronously = YES;
        
        _minLevel = ZBLogLevelVerbose;
        
        _levelString = [ZBLevelString new];
        _levelString.verbose = @"VERBOSE";
        _levelString.debug   = @"DEBUG";
        _levelString.info    = @"INFO";
        _levelString.warning = @"WARNING";
        _levelString.error   = @"ERROR";
        _levelString.all     = @"ALL";
        
        _levelColor = [ZBLevelColor new];
        _levelColor.verbose = @"";   // silver
        _levelColor.debug   = @"";   // green
        _levelColor.info    = @"";   // blue
        _levelColor.warning = @"";   // yellow
        _levelColor.error   = @"";   // red
        _levelColor.all     = @"";   // black
        
        _filters = [NSMutableArray new];
        
        _formatter = [NSDateFormatter new];
    }
    return self;
}

/// send / store the formatted log message to the destination
/// returns the formatted log message for processing by inheriting method
/// and for unit tests (nil if error)
- (NSString *)send:(ZBLogLevel)level
               msg:(NSString *)msg
            thread:(NSString *)thread
              file:(NSString *)file
          function:(NSString *)function
              line:(NSUInteger)line
           context:(id)context {
    
    if ([self.format hasPrefix:@"$J"]) {
        return [self messageToJSON:level msg:msg thread:thread file:file function:function line:line context:context];
    }else {
        return [self formatMessage:_format level:level msg:msg thread:thread file:file function:function line:line context:context];
    }
}

// returns the log payload as optional JSON string
- (NSString *)messageToJSON:(ZBLogLevel)level
                        msg:(NSString *)msg
                     thread:(NSString *)thread
                       file:(NSString *)file
                   function:(NSString *)function
                       line:(NSUInteger)line
                    context:(id)context {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"timestamp"] = @([[NSDate new] timeIntervalSince1970]);
    dict[@"level"] = @(level);
    dict[@"message"] = msg;
    dict[@"thread"] = thread;
    dict[@"file"] = file;
    dict[@"function"] = function;
    dict[@"line"] = @(line);
    if (context) {
        dict[@"context"] = context;
    }
    return [self jsonStringFromDict:dict];
}

////////////////////////////////
// MARK: Format
////////////////////////////////

/// returns the log message based on the format pattern
- (NSString *)formatMessage:(NSString *)format
                      level:(ZBLogLevel)level
                        msg:(NSString *)msg
                     thread:(NSString *)thread
                       file:(NSString *)file
                   function:(NSString *)function
                       line:(NSUInteger)line
                    context:(id)context {
    
    NSString *text = @"";
    
    // Prepend a $I for 'ignore' or else the first character is interpreted as a format character
    // even if the format string did not start with a $.
    NSString *formatStr = [@"$I" stringByAppendingString:format];
    NSArray *phrases = [formatStr componentsSeparatedByString: @"$"];
    
    for (NSString *phrase in phrases) {
        
        if ([phrase isEqualToString:@""]) {
            continue;
        }
        
        // get format char
        NSString *formatChar = [phrase substringToIndex:1];
        NSString *remainingPhrase = [phrase substringFromIndex:1];
        
        if ([formatChar isEqualToString:@"I"]) { // ignore
            
            text = [text stringByAppendingString:remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"L"]) { // Level
            
            text = [text stringByAppendingFormat:@"%@%@", [self levelWord:level], remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"M"]) { // Message
            
            text = [text stringByAppendingFormat:@"%@%@", msg, remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"T"]) { // Thread name
            
            text = [text stringByAppendingFormat:@"%@%@", thread, remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"N"]) { // Name of file without suffix
            
            text = [text stringByAppendingFormat:@"%@%@", [self fileNameWithoutSuffix:file], remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"n"]) { // Name of file with suffix
            
            text = [text stringByAppendingFormat:@"%@%@", [self fileNameOfFile:file], remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"F"]) { // Function
            
            text = [text stringByAppendingFormat:@"%@%@", function, remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"l"]) { // Line
            
            text = [text stringByAppendingFormat:@"%lu%@", (unsigned long)line, remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"D"]) { // Start of datetime format
            
            text = [text stringByAppendingString:[self formatDate:remainingPhrase timeZone:nil]];
            
        }else if ([formatChar isEqualToString:@"d"]) { // Datetime format end
            
            text = [text stringByAppendingString:remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"Z"]) { // start of datetime format in UTC timezone
            
            text = [text stringByAppendingString:[self formatDate:remainingPhrase timeZone:@"UTC"]];
            
        }else if ([formatChar isEqualToString:@"z"]) { // end of datetime format in UTC timezone
            
            text = [text stringByAppendingString:remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"U"]) { // Uptime in the format HH:MM:SS
            
            text = [text stringByAppendingFormat:@"%@%@", [self uptime], remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"C"]) { // Color
            
            text = [text stringByAppendingFormat:@"%@%@", [self colorForLevel:level], remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"c"]) { // color end
            
            text = [text stringByAppendingString:remainingPhrase];
            
        }else if ([formatChar isEqualToString:@"X"]) { // Optional context value of any type (see below)
            
            if (context) {
                text = [text stringByAppendingFormat:@"%@%@", context, remainingPhrase];
            }else {
                text = [text stringByAppendingString:remainingPhrase];
            }
            
        }else {
            
            text = [text stringByAppendingString:phrase];
        }
    }
    
    // right trim only
    return [text stringByReplacingOccurrencesOfString:@"\\s+$" withString:@"" options:(NSRegularExpressionSearch) range:NSMakeRange(0, text.length)];
}

// returns the string of a level
- (NSString *)levelWord:(ZBLogLevel)level {
    
    NSString *str = @"";
    
    switch (level) {
        case ZBLogLevelDebug:
            str = _levelString.debug; break;
            
        case ZBLogLevelInfo:
            str = _levelString.info; break;
            
        case ZBLogLevelWarning:
            str = _levelString.warning; break;
            
        case ZBLogLevelError:
            str = _levelString.error; break;
            
        case ZBLogLevelVerbose:
            str = _levelString.verbose; break;
            
        case ZBLogLevelAll:
            str = _levelString.all; break;
            
        default:
            break;
    }
    
    return str;
}

// returns color string for level
- (NSString *)colorForLevel:(ZBLogLevel)level {
    
    NSString *color = @"";
    
    switch (level) {
        case ZBLogLevelDebug:
            color = _levelColor.debug; break;
            
        case ZBLogLevelInfo:
            color = _levelColor.info; break;
            
        case ZBLogLevelWarning:
            color = _levelColor.warning; break;
            
        case ZBLogLevelError:
            color = _levelColor.error; break;
            
        case ZBLogLevelVerbose:
            color = _levelColor.verbose; break;
            
        case ZBLogLevelAll:
            color = _levelColor.all; break;
            
        default:
            break;
    }
    
    return color;
}

// returns the filename of a path
- (NSString *)fileNameOfFile:(NSString *)file {
    NSArray *fileParts = [file componentsSeparatedByString:@"/"];
    if (fileParts.lastObject) {
        return fileParts.lastObject;
    }
    return @"";
}

// returns the filename without suffix (= file ending) of a path
- (NSString *)fileNameWithoutSuffix:(NSString *)file {
    NSString *fileName = [self fileNameOfFile:file];
    
    if (![fileName isEqualToString:@""]) {
        NSArray *fileNameParts = [fileName componentsSeparatedByString:@"."];
        if (fileNameParts.firstObject) {
            return fileNameParts.firstObject;
        }
    }
    return @"";
}

/// returns a formatted date string
/// optionally in a given abbreviated timezone like "UTC"
- (NSString *)formatDate:(NSString *)dateFormat timeZone:(NSString *)timeZone {
    if (!timeZone) {
        _formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:timeZone];
    }
    _formatter.dateFormat = dateFormat;
    NSString *dateStr = [_formatter stringFromDate:[NSDate new]];
    return dateStr;
}

/// returns a uptime string
- (NSString *)uptime {
    double interval = [[NSDate new] timeIntervalSinceDate:[NSDate new]];
    
    int hours = (int)interval / 3600;
    int minutes = (int)(interval / 60) - (int)(hours * 60);
    int seconds = (int)(interval) - ((int)(interval / 60) * 60);
    
    NSInteger x = 100000000;
    NSInteger y = interval * x;
    NSInteger z = y % x;
    int milliseconds = (float)z/100000000.0;
    
    return [NSString stringWithFormat:@"%0.2d:%0.2d:%0.2d.%03d", hours, minutes, seconds, milliseconds];
}

// turns dict into JSON-encoded string
- (NSString *)jsonStringFromDict:(NSDictionary *)dict {
    
    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {
        
        NSLogDebug(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //remove spaces from strings
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};

    //remove the newline character from the string
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}

////////////////////////////////
// MARK: Filters
////////////////////////////////

/// Add a filter that determines whether or not a particular message will be logged to this destination
- (void)addFilter:(id)filter {
    [self.filters addObject:filter];
}

/// Remove a filter from the list of filters
- (void)removeFilter:(id)filter {
# warning TODO
    [self.filters removeObject:filter];
}

/// Answer whether the destination has any message filters
/// returns boolean and is used to decide whether to resolve
/// the message before invoking shouldLevelBeLogged
- (BOOL)hasMessageFilters {
# warning TODO
    return YES;
}

/// checks if level is at least minLevel or if a minLevel filter for that path does exist
/// returns boolean and can be used to decide if a message should be logged or not
- (BOOL)shouldLevelBeLogged:(ZBLogLevel)level
                       path:(NSString *)path
                   function:(NSString *)function
                    message:(NSString *)message {
    if (_filters.count <= 0) {
        if (level >= _minLevel) {
            
            NSLogDebug(@"filters are empty and level >= minLevel");
            
            return YES;
            
        }else {
            
            NSLogDebug(@"filters are empty and level < minLevel");
            
            return NO;
            
        }
    }
# warning TODO add filters
    
    return YES;
}

- (void)dealloc {
    #if !OS_OBJECT_USE_OBJC
    if (_queue) {
        dispatch_release(_queue);
    }
    #endif
}
@end

