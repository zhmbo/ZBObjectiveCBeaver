//
//  ZBViewController.m
//  ZBObjectiveCBeaver
//
//  Created by itzhangbao on 03/13/2021.
//  Copyright (c) 2021 itzhangbao. All rights reserved.
//

#import "ZBViewController.h"
#import <ZBObjectiveCBeaver.h>

@interface ZBViewController ()

@end

@implementation ZBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // console test
    [self zb_consoleTest];
    
    // file test
    [self zb_fileTest];
    
    // server test
    [self zb_serverTest];
}

- (void)zb_consoleTest {
    ZBConsoleDestinatioin *dest = [ZBConsoleDestinatioin new];
    dest.minLevel = ZBLogLevelError;
    dest.format = @"$Dyyyy-dd HH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M";
    [ZBLog addDestination:dest];
}

- (void)zb_fileTest {
    ZBFileDestination *dest = [ZBFileDestination new];
    dest.minLevel = ZBLogLevelError;
    [ZBLog addDestination:dest];
}

- (void)zb_serverTest {
    ZBServerDestination *dest = [[ZBServerDestination alloc] initWithAppID:@"MmnrG9" appSecret:@"pndOge0lss9Dgex8upuqvemud7nusyiv" encryptionKey:@"xpqiay3ubzdfvtzpwzvfa2x9odqz5std"];
    dest.minLevel = ZBLogLevelError;
    dest.showNSLog = YES;
    [ZBLog addDestination:dest];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    ZBLogWarn(@"zb log warning.");
//    ZBLogInfo(@"zb log info.");
//    ZBLogInfo(@"zb log verbose.");
    ZBLogInfo(@"oc 1zb log error.");
    ZBLogInfo(@"oc 2zb log error.");
    ZBLogInfo(@"oc 3zb log error.");
    ZBLogInfo(@"oc 4zb log error.");
    ZBLogInfo(@"oc 5zb log error.");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
