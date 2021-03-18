//
//  ZBConsoleDestinatioin.m
//  Pods-ZBLog_Example
//
//  Created by Jumbo on 2021/3/13.
//

#import <ZBObjectiveCBeaver/ZBConsoleDestinatioin.h>

@implementation ZBConsoleDestinatioin

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.levelColor.verbose = @"💜 ";   // silver
        self.levelColor.debug   = @"💚 ";   // green
        self.levelColor.info    = @"💙 ";   // blue
        self.levelColor.warning = @"💛 ";   // yellow
        self.levelColor.error   = @"❤️ ";   // red
        self.levelColor.all     = @"🖤 ";   // black
    }
    return self;
}

- (NSString *)send:(ZBLogLevel)level msg:(NSString *)msg thread:(NSString *)thread file:(NSString *)file function:(NSString *)function line:(NSUInteger)line context:(id)context {
    NSString *formattedString = [super send:level msg:msg thread:thread file:file function:function line:line context:context];
     
    if (formattedString) {
        if (_useNSLog) {
            NSLog(@"%@", formattedString);
        }else {
            printf("%s\n", [formattedString UTF8String]);
        }
    }
    return formattedString;
}

@end
