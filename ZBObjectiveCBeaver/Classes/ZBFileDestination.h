//
//  ZBFileDestination.h
//  ZBObjectiveCBeaver
//
//  Created by Jumbo on 2021/3/16.
//

#import <ZBObjectiveCBeaver/ZBBaseDestination.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBFileDestination : ZBBaseDestination

///
@property (nonatomic, strong) NSURL *logFileURL;

///
@property (nonatomic, assign) BOOL syncAfterEachWrite;

@end

NS_ASSUME_NONNULL_END
