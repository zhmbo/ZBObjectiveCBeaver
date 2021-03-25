//
//  ZBConsoleDestination-Test.m
//  ZBObjectiveCBeaverTests
//
//  Created by Jumbo on 2021/3/25.
//

#import <XCTest/XCTest.h>
#import "ZBObjectiveCBeaver/ZBObjectiveCBeaver.h"

@interface ZBConsoleDestination_Test : XCTestCase

@end

@implementation ZBConsoleDestination_Test

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    ZBConsoleDestinatioin *dest = [[ZBConsoleDestinatioin alloc] init];
    dest.minLevel = ZBLogLevelError;
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
