//
//  ZBFilter.h
//  Pods-ZBLog_Example
//
//  Created by Jumbo on 2021/3/12.
//

#import <Foundation/Foundation.h>
#import "ZBLog.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZBTargetType) {
    ZBTargetTypePath,
    ZBTargetTypeFunction,
    ZBTargetTypeMessage
};

typedef NS_ENUM(NSUInteger, ZBComparisonType) {
    ZBComparisonTypeStartsWith,
    ZBComparisonTypeContains,
    ZBComparisonTypeExcludes,
    ZBComparisonTypeEndsWith,
    ZBComparisonTypeEquals,
    ZBComparisonTypeCustom
};

/// FilterType is a protocol that describes something that determines
/// whether or not a message gets logged. A filter answers a Bool when it
/// is applied to a value. If the filter passes, it shall return true,
/// false otherwise.
///
/// A filter must contain a target, which identifies what it filters against
/// A filter can be required meaning that all required filters against a specific
/// target must pass in order for the message to be logged.
@protocol ZBFilterType <NSObject>

- (BOOL)apply:(NSString *)value;
- (ZBTargetType)getTarget;
- (BOOL)isRequired;
- (BOOL)isExcluded;
- (BOOL)reachedMinLevel:(ZBLogLevel)level;

@end

@interface ZBFilter : NSObject

@end

/// CompareFilter is a FilterType that can filter based upon whether a target
/// starts with, contains or ends with a specific string. CompareFilters can be
/// case sensitive.
@interface ZBCompareFilter : ZBFilter<ZBFilterType>

@end

NS_ASSUME_NONNULL_END
