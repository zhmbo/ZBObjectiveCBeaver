//
//  ZBConsoleDestinatioin.h
//  Pods-ZBLog_Example
//
//  Created by Jumbo on 2021/3/13.
//

#import "ZBBaseDestination.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBConsoleDestinatioin : ZBBaseDestination

/// use NSLog instead of print, default is false
@property (nonatomic, assign) BOOL useNSLog;

@end

NS_ASSUME_NONNULL_END
