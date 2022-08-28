//
//  CryptoUtil.h
//  제로페이 모바일 상품권 결제
//
//  Created by netcanis on 2020/07/09.
//  Copyright © 2020 harexinfotech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CryptoUtil : NSObject

+(NSString *)encrypt:(NSString *)masterKey msg:(NSString *)msg;
+(NSString *)encrypt:(Byte *)key iv:(Byte *)iv msg:(NSString *)msg;

+(NSString *)decrypt:(NSString *)masterKey msg:(NSString *)base64Str;
+(NSString *)decrypt:(Byte *)key iv:(Byte *)iv msg:(NSString *)base64Str;

+(NSData *)getSHA256:(NSString *)msg;

+(NSString *)zpphashHMACKey:(NSInteger)length;
+(NSString *)hmacSha256:(NSString *)secret payload:(NSString *)payload;

@end

NS_ASSUME_NONNULL_END

