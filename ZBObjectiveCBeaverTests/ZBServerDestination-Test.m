//
//  ZBServerDestination-Test.m
//  ZBObjectiveCBeaverTests
//
//  Created by Jumbo on 2021/3/24.
//

#import <XCTest/XCTest.h>
#import "ZBObjectiveCBeaver/ZBObjectiveCBeaver.h"

@interface ZBServerDestination_Test : XCTestCase

@end

@implementation ZBServerDestination_Test

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    ZBServerDestination *dest =
    [ZBServerDestination avosCloudAppID:@"P2KV6oTocgdFJFdeVWNHhWxT-MdYXbMMI"
                              appSecret:@"4ivNxvzl0e1YGIaEya7LjDo9"
                              serverURL:@""];
    dest.minLevel = ZBLogLevelError;
    dest.showNSLog = YES;
    [ZBLog addDestination:dest];
    
    ZBLogInfo(@"zb server test");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
