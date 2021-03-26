//
//  ZBAVOSCloudDestination.h
//  ZBObjectiveCBeaver
//
//  Created by Jumbo on 2021/3/26.
//

#import "ZBServerDestination.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBAVOSCloudDestination : ZBServerDestination

+ (ZBAVOSCloudDestination *)destWithAppID:(NSString *)appID
                                   appKey:(NSString *)appKey
                          serverURLString:(NSString *)serverURLString;
@end

NS_ASSUME_NONNULL_END
