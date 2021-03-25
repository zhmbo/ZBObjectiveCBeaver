//
//  ZBAES256.h
//  ZBObjectiveCBeaver
//
//  Created by Jumbo on 2021/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - AES CBC 加解密

NSString * KADSYAESCBCEncryptData(NSString *content, NSString *key, NSString *iv);

NSString * KADSYAESCBCDecryptData(NSString *content, NSString *key, NSString *iv);

@interface NSData(ZBAES256)
/**
 AES CBC 128位加密模式
 */
- (nullable NSData *)AESCBC128EncryptWithKey:(NSString *)key gIv:(NSString *)Iv;
/**
AES CBC 128位解密模式
*/
- (nullable NSData *)AESCBC128DecryptWithKey:(NSString *)key gIv:(NSString *)Iv;
/**
AES CBC 256位加密模式
*/
- (nullable NSData *)AESCBC256EncryptWithKey:(NSString *)key gIv:(NSString *)Iv;
/**
AES CBC 256位解密模式
*/
- (nullable NSData *)AESCBC256DecryptWithKey:(NSString *)key gIv:(NSString *)Iv;

/**
AES CBC 256位解密模式
*/
- (nullable NSData *)AESCBC256OpenDecryptWithKey:(NSString *)key gIv:(NSString *)Iv;

@end

NS_ASSUME_NONNULL_END
