//
//  ZBFileDestination.m
//  ZBObjectiveCBeaver
//
//  Created by Jumbo on 2021/3/16.
//

#import <ZBObjectiveCBeaver/ZBFileDestination.h>

#ifndef DD_NSLOG_LEVEL
    #define DD_NSLOG_LEVEL 2
#endif

#define NSLogError(frmt, ...)    do{ if(DD_NSLOG_LEVEL >= 1) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogWarn(frmt, ...)     do{ if(DD_NSLOG_LEVEL >= 2) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogInfo(frmt, ...)     do{ if(DD_NSLOG_LEVEL >= 3) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogDebug(frmt, ...)    do{ if(DD_NSLOG_LEVEL >= 4) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogVerbose(frmt, ...)  do{ if(DD_NSLOG_LEVEL >= 5) NSLog((frmt), ##__VA_ARGS__); } while(0)

@interface ZBFileDestination()

@end

@implementation ZBFileDestination

- (instancetype)init
{
    self = [super init];
    if (self) {
        _syncAfterEachWrite = NO;
        
        if (!_logFileURL) {
            NSURL *baseURL = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;
            _logFileURL = [baseURL URLByAppendingPathComponent:@"Logs/ZBObjectiveCBeaver.log" isDirectory:NO];
        }
    }
    return self;
}

// platform-dependent logfile directory default
- (instancetype)initWithLogFileURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.logFileURL = url;
    }
    return self;
}

// append to file. uses full base class functionality
- (NSString *)send:(ZBLogLevel)level msg:(NSString *)msg thread:(NSString *)thread file:(NSString *)file function:(NSString *)function line:(NSUInteger)line context:(id)context {
    NSString *formattedString = [super send:level msg:msg thread:thread file:file function:function line:line context:context];
    
    if (![formattedString isEqualToString:@""]) {
        [self saveToFile:formattedString];
    }
    
    return formattedString;
}

// appends a string as line to a file.
// returns boolean about success
- (BOOL)saveToFile:(NSString *)str {
    if (!_logFileURL) {
        return NO;
    }
    
    NSString *line = [str stringByAppendingString:@"\n"];
    NSData *data = [line dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return NO;
    }
    
    return [self write:data to:_logFileURL];
}

- (BOOL)write:(NSData *)data to:(NSURL *)url {
    __block BOOL success = NO;
    NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
    NSError *error = nil;
    [coordinator coordinateWritingItemAtURL:url options:0 error:&error byAccessor:^(NSURL * _Nonnull newURL) {
        
        NSError *error = nil;
            
        if (![[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
            
            NSURL *directoryURL = url.URLByDeletingLastPathComponent;
            if (![[NSFileManager defaultManager] fileExistsAtPath:directoryURL.path]) {
                [[NSFileManager defaultManager] createDirectoryAtURL:directoryURL withIntermediateDirectories:YES attributes:nil error:&error];
            }
            
            [[NSFileManager defaultManager] createFileAtPath:url.path contents:nil attributes:nil];
        }
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingToURL:url error:&error];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        if (_syncAfterEachWrite) {
            [fileHandle synchronizeFile];
        }
        [fileHandle closeFile];
        
        if (error) {
            NSLogError(@"Failed writing file with error:%@", error.description);
        }else {
            success = YES;
        }
        
    }];
    
    if (error) {
        NSLogError(@"Failed writing file with error:%@", error.description);
    }
    
    return success;
}

@end
