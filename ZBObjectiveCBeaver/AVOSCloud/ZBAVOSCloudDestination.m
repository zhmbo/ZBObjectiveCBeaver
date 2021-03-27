//
//  ZBAVOSCloudDestination.m
//  ZBObjectiveCBeaver
//
//  Created by Jumbo on 2021/3/26.
//

#import "ZBAVOSCloudDestination.h"

#if __has_include(<AVOSCloud/AVOSCloud.h>)
#import <AVOSCloud/AVOSCloud.h>
#else
#import "AVOSCloud.h"
#endif

@implementation ZBAVOSCloudDestination

+ (ZBAVOSCloudDestination *)destWithAppID:(NSString *)appID
                                   appKey:(NSString *)appKey
                          serverURLString:(NSString *)serverURLString {
    
    [AVOSCloud setApplicationId:appID
                      clientKey:appKey
                serverURLString:serverURLString];
    [AVOSCloud setAllLogsEnabled:YES];
    
    return [[self alloc] initWithAppID:appID
                             appSecret:appKey
                         encryptionKey:@""
                             serverURL:serverURLString
                       entriesFileName:@""
                       sendingfileName:@""
                     analyticsFileName:@""
                            serverType:ZBServerTypeAVOSCloud];
}

// Send information to custom AVOSCLOUD (https://leancloud.cn/)
- (void)sendToAvosCloudWithDevice:(NSDictionary *)deviceDic logs:(NSArray *)logs complete:(void(^)(BOOL ok))complete {
    
    //toNSLog(str)  // uncomment to see full payload
    [self toNSLog:[NSString stringWithFormat:@"Encrypting %ld log entries ...", (long)logs.count]];
    
    AVObject *avObj = [AVObject objectWithClassName:@"Device" dictionary:deviceDic];
//    avObj.objectId = self.uuid;
    NSMutableArray *obArr1 = [NSMutableArray new];
    [obArr1 addObject:avObj];
    
    for (NSDictionary *dict in logs) {
        AVObject *avObj = [AVObject objectWithClassName:@"Logs" dictionary:dict];
        [obArr1 addObject:avObj];
    }
    [self toNSLog:[NSString stringWithFormat:@"Sending %ld log) to server ...", (long)logs.count]];
    __weak typeof(self) _self = self;
    [AVObject saveAllInBackground:obArr1 block:^(BOOL succeeded, NSError * _Nullable error) {
        
        [_self toNSLog:[NSString stringWithFormat:@"Sent %lu encrypted log entries to server, received ok: %d", (unsigned long)obArr1.count, succeeded]];
        if (complete) {
            complete(succeeded);
        }
    }];
}
@end
