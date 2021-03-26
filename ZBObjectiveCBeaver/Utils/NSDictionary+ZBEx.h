//
//  NSObject+NSDictionary_Ex.h
//  ZBObjectiveCBeaver
//
//  Created by Jumbo on 2021/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ZBEx)

// turns dict into JSON-encoded string
- (NSString *)toJsonString;

@end

NS_ASSUME_NONNULL_END
