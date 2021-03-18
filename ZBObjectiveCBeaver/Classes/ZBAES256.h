//
//  ZBAES256.h
//  ZBObjectiveCBeaver
//
//  Created by Jumbo on 2021/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(ZBAES256)
 
- (NSString *)aes256_encrypt:(NSString *)key;
- (NSString *)aes256_decrypt:(NSString *)key;
 
@end

@interface NSData(ZBAES256)
 
- (NSData *)aes256_encrypt:(NSString *)key;
- (NSData *)aes256_decrypt:(NSString *)key;
 
@end

NS_ASSUME_NONNULL_END
