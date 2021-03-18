//
//  ZBServerDestination.h
//  ZBObjectiveCBeaver
//
//  Created by Jumbo on 2021/3/17.
//

#import <ZBObjectiveCBeaver/ZBBaseDestination.h>

// when to send to server
typedef NS_ENUM(NSUInteger, ZBSendingPoints) {
    ZBSendingPointsVerbose = 0,
    ZBSendingPointsDebug = 1,
    ZBSendingPointsInfo = 5,
    ZBSendingPointsWarning = 8,
    ZBSendingPointsError = 10,
    ZBSendingPointsThreshold = 10 // send to server if points reach that value
};

NS_ASSUME_NONNULL_BEGIN

@interface ZBServerDestination : ZBBaseDestination

- (instancetype)initWithAppID:(NSString *)appID
                    appSecret:(NSString *)appSecret
                encryptionKey:(NSString *)encryptionKey;

- (instancetype)initWithAppID:(NSString *)appID
                    appSecret:(NSString *)appSecret
                encryptionKey:(NSString *)encryptionKey
                    serverURL:(NSURL *)serverURL
              entriesFileName:(NSString *)entriesFileName
              sendingfileName:(NSString *)sendingfileName
            analyticsFileName:(NSString *)analyticsFileName;

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

/// executes toNSLog statements to debug the class
@property (nonatomic, assign) BOOL showNSLog;

@property (nonatomic, strong) NSURL *serverURL;

@property (nonatomic, strong) NSURL *entriesFileURL;

@property (nonatomic, strong) NSURL *sendingFileURL;

@property (nonatomic, strong) NSURL *analyticsFileURL;

/// does a (manual) sending attempt of all unsent log entries to SwiftyBeaver Platform
- (void)sendNow;
@end

NS_ASSUME_NONNULL_END
