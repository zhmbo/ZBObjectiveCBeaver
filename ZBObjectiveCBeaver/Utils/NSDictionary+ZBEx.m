//
//  NSObject+NSDictionary_Ex.m
//  ZBObjectiveCBeaver
//
//  Created by Jumbo on 2021/3/26.
//

#import "NSDictionary+ZBEx.h"

@implementation NSDictionary (ZBEx)

// turns dict into JSON-encoded string
- (NSString *)toJsonString {
    
    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {
        
        NSLog(@"%@", error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0, jsonString.length};

    //remove spaces from strings
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0, mutStr.length};

    //remove the newline character from the string
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}
@end
