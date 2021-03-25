//
//  ZBFilter.m
//  Pods-ZBLog_Example
//
//  Created by Jumbo on 2021/3/12.
//

#import "ZBFilter.h"

@interface ZBFilter()

@property (nonatomic, assign) ZBTargetType targetType;

@property (nonatomic, assign) BOOL required;

@property (nonatomic, assign) ZBLogLevel minLevel;

@end

@implementation ZBFilter

- (instancetype)initWithTarget:(ZBTargetType)target
                      required:(BOOL)required
                      minLevel:(ZBLogLevel)minLevel {
    self = [super init];
    if (self) {
        _targetType = target;
        _required = required;
        _minLevel = minLevel;
    }
    return self;
}

- (ZBTargetType)getTarget {
    return self.targetType;
}

- (BOOL)isRequired {
    return self.required;
}

- (BOOL)isExcluded {
    return NO;
}

/// returns true of set minLevel is >= as given level
- (BOOL)reachedMinLevel:(ZBLogLevel)level {
    return level >= _minLevel;
}

@end

@interface ZBCompareFilter()

@property (nonatomic, assign) ZBComparisonType filterComparisonType;

@end

@implementation ZBCompareFilter

- (instancetype)initWithTarget:(ZBTargetType)target
                      required:(BOOL)required
                      minLevel:(ZBLogLevel)minLevel {
    self = [super initWithTarget:target required:required minLevel:minLevel];
    if (self) {
        ZBComparisonType comparisonType = -1;
        switch (self.getTarget) {
            case ZBTargetTypeFunction:
                
                break;
            case ZBTargetTypePath:
                
                break;
            case ZBTargetTypeMessage:
                
                break;
                
            default:
                break;
        }
        
        self.filterComparisonType = comparisonType;
    }
    return self;
}


- (BOOL)apply:(nonnull NSString *)value {
    if (!value) {
        return false;
    }
    
    return YES;
    
}

- (ZBTargetType)getTarget {
    return ZBTargetTypePath;
}

- (BOOL)isExcluded {
    return YES;
}

- (BOOL)isRequired {
    return YES;
}

- (BOOL)reachedMinLevel:(ZBLogLevel)level {
    return YES;
}

@end
