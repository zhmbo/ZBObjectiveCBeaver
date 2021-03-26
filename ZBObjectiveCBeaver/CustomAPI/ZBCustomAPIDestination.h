//
//  ZBCustomAPIDestination.h
//  ZBObjectiveCBeaver
//
//  Created by Jumbo on 2021/3/26.
//

#import "ZBServerDestination.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBCustomAPIDestination : ZBServerDestination

+ (ZBCustomAPIDestination *)destWithAppID:(NSString *)appID
                                appSecret:(NSString *)appSecret
                          serverURLString:(NSString *)serverURLString
                            encryptionKey:(NSString *)encryptionKey;
@end

NS_ASSUME_NONNULL_END
