//
//  ZBCustomAPIDestination.m
//  ZBObjectiveCBeaver
//
//  Created by Jumbo on 2021/3/26.
//

#import "ZBCustomAPIDestination.h"
#import "NSDictionary+ZBEx.h"
#import "ZBAES256.h"

@implementation ZBCustomAPIDestination

+ (ZBCustomAPIDestination *)destWithAppID:(NSString *)appID
                                appSecret:(NSString *)appSecret
                          serverURLString:(NSString *)serverURLString
                            encryptionKey:(NSString *)encryptionKey
{
    return [[self alloc] initWithAppID:appID
                             appSecret:appSecret
                         encryptionKey:encryptionKey
                             serverURL:serverURLString
                       entriesFileName:@""
                       sendingfileName:@""
                     analyticsFileName:@""
                            serverType:ZBServerTypeCustomAPI];
}

// Send information to custom server
- (void)sendToCustmAPIWithDevice:(NSDictionary *)deviceDic logs:(NSArray *)logs complete:(void(^)(BOOL ok))complete {
    
    NSMutableDictionary *payload = [NSMutableDictionary new];
    payload[@"device"] = deviceDic;
    payload[@"entries"] = logs;
    
    NSString *str = [payload toJsonString];
    if (str && ![str isEqualToString:@""]) {
        //toNSLog(str)  // uncomment to see full payload
        [self toNSLog:[NSString stringWithFormat:@"Encrypting %ld log entries ...", (long)logs.count]];
        
        NSString *encryptedStr = [self encrypt:str];
        if (encryptedStr.length > 0) {
            [self toNSLog:[NSString stringWithFormat:@"Sending %ld encrypted log entries %lu chars) to server ...", (long)logs.count, (unsigned long)encryptedStr.length]];
            __weak __typeof__(self) weakSelf = self;
            [self sendToServerAsync:encryptedStr complete:^(BOOL ok, NSInteger status) {
                [weakSelf toNSLog:[NSString stringWithFormat:@"Sent %lu encrypted log entries to server, received ok: %d", (unsigned long)logs.count, ok]];
                if (complete) {
                    complete(ok);
                }
            }];
        }
    }
}

// sends a string to the zb beaver server, returns ok if status 200 and HTTP status
- (void)sendToServerAsync:(NSString *)str complete:(void(^)(BOOL ok, NSInteger status))complete {
    
    NSUInteger timeout = 10.0;
    
    if (str.length > 0 && self.queue != nil) {
        // create operation queue which uses current serial queue of destination
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.underlyingQueue = self.queue;
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session =
        [NSURLSession sessionWithConfiguration:config
                                      delegate:nil
                                 delegateQueue:operationQueue];
        
        [self toNSLog:@"assembling request ..."];
        
        NSString *serverURLStr = (self.serverURL && self.serverURL.length > 0) ? self.serverURL : @"https://api.swiftybeaver.com/api/entries/";
        // assemble request
        NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverURLStr] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:timeout];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        // Authorization
        NSData *credentials = [[NSString stringWithFormat:@"%@:%@", self.appID, self.appSecret] dataUsingEncoding:NSUTF8StringEncoding];
        if (!credentials) {
            if (complete) {
                complete(NO, 0);
            }
            return;
        }
        NSString *base64Credentials = [credentials base64EncodedStringWithOptions:0];
        [request setValue:[NSString stringWithFormat: @"Basic %@", base64Credentials] forHTTPHeaderField:@"Authorization"];
        
        // POST parameters
        NSDictionary *params = @{@"payload": str};
        NSError *error = nil;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        [request setHTTPBody:bodyData];
        if (error) {
            [self toNSLog:[NSString stringWithFormat:@"Error! Could not create JSON for server payload."]];
            if (complete) {
                complete(NO, 0);
            }
            return;
        }
        [self toNSLog: [NSString stringWithFormat:@"sending params: %@", params]];
        [self toNSLog:@"sending..."];
        
        // send request async to server on destination queue
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            BOOL ok = NO;
            NSInteger status = 0;
            [self toNSLog: @"received response server"];
            
            if (error) {
                [self toNSLog:[NSString stringWithFormat:@"Error! Could not send entries to server %@.", error]];
            }else {
                
                if (response) {
                    status = [(NSHTTPURLResponse *)response statusCode];
                    if (status == 200) {
                        // all went well, entries were uploaded to server
                        ok = YES;
                    }else {
                        // status code was not 200
                        [self toNSLog:[NSString stringWithFormat:@"Error! Sending entries to server failed with status code %ld", (long)status]];
                    }
                }
            }
            if (complete) {
                complete(ok, status);
            }
        }];
        [task resume];
        [session finishTasksAndInvalidate];
    }
}

/**
 生成随机字母
 */
- (NSString *)randomString:(NSInteger)number {
    NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:number];
    for (int i = 0; i < number; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    return randomString;
}

/// returns AES-256 CBC encrypted optional string
- (NSString *)encrypt:(NSString *)str {
    NSString *vi = [self randomString:16];
    return [NSString stringWithFormat:@"%@%@",vi, KADSYAESCBCEncryptData(str, self.encryptionKey, vi)];
}
@end
