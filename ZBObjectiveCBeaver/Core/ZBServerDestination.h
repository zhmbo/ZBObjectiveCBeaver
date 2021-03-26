//
//  ZBServerDestination.h
//  ZBObjectiveCBeaver
//
//  Created by Jumbo on 2021/3/17.
//

#import "ZBBaseDestination.h"

// when to send to server
typedef NS_ENUM(NSUInteger, ZBSendingPoints) {
    ZBSendingPointsVerbose = 0,
    ZBSendingPointsDebug = 1,
    ZBSendingPointsInfo = 5,
    ZBSendingPointsWarning = 8,
    ZBSendingPointsError = 10,
    ZBSendingPointsThreshold = 10 // send to server if points reach that value
};

typedef NS_ENUM(NSUInteger, ZBServerType) {
    ZBServerTypeAVOSCloud,
    ZBServerTypeCustomAPI
};

NS_ASSUME_NONNULL_BEGIN

@interface ZBServerDestination : ZBBaseDestination

- (instancetype)initWithAppID:(NSString *)appID
                    appSecret:(NSString *)appSecret
                encryptionKey:(NSString *)encryptionKey
                    serverURL:(nonnull NSString *)serverURL
              entriesFileName:(nonnull NSString *)entriesFileName
              sendingfileName:(nonnull NSString *)sendingfileName
            analyticsFileName:(nonnull NSString *)analyticsFileName
                   serverType:(ZBServerType)serverType;

///
@property (nonatomic, copy) NSString *appID;

///
@property (nonatomic, copy) NSString *appSecret;

///
@property (nonatomic, copy) NSString *encryptionKey;

/// user email, ID, name, etc.
@property (nonatomic, copy) NSString *analyticsUserName;

///
@property (nonatomic, copy) NSString *analyticsUUID;

@property (nonatomic, assign) ZBSendingPoints sendingPoints;

@property (nonatomic, assign) ZBServerType serverType;

/// executes toNSLog statements to debug the class
@property (nonatomic, assign) BOOL showNSLog;

@property (nonatomic, copy) NSString *serverURL;

@property (nonatomic, strong) NSURL *entriesFileURL;

@property (nonatomic, strong) NSURL *sendingFileURL;

@property (nonatomic, strong) NSURL *analyticsFileURL;

/// does a (manual) sending attempt of all unsent log entries to SwiftyBeaver Platform
- (void)sendNow;

// Send information to custom AVOSCLOUD (https://leancloud.cn/)
- (void)sendToAvosCloudWithDevice:(NSDictionary *)deviceDic logs:(NSArray *)logs complete:(void(^)(BOOL ok))complete;

// Send information to custom server
- (void)sendToCustmAPIWithDevice:(NSDictionary *)deviceDic logs:(NSArray *)logs complete:(void(^)(BOOL ok))complete;

/// log String to toNSLog. Used to debug the class logic
- (void)toNSLog:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
