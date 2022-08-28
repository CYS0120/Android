//
//  CocoaSecurity 1.1
//
//  Created by Kelp on 12/5/12.
//  Modified by netcanis on 01/07/2019.
//  Copyright (c) 2012 Kelp http://kelp.phate.org/
//  MIT License
//  CocoaSecurity is core. It provides AES encrypt, AES decrypt, Hash(MD5, HmacMD5, SHA1~SHA512, HmacSHA1~HmacSHA512) messages.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSException.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - CocoaSecurityResult
@interface CocoaSecurityResult : NSObject

@property (strong, nonatomic, readonly) NSData *data;
@property (strong, nonatomic, readonly) NSString *hex;
@property (strong, nonatomic, readonly) NSString *hexLower;
@property (strong, nonatomic, readonly) NSString *base64;
@property (strong, nonatomic, readonly) NSString *utf8String;
@property (strong, nonatomic, readonly) NSString *eucKrString;

- (id)initWithBytes:(unsigned char[_Nonnull])initData length:(NSUInteger)length;

@end


#pragma mark - CocoaSecurity
@interface CocoaSecurity : NSObject
#pragma mark - AES Encrypt
+ (CocoaSecurityResult *)aesEncrypt:(NSString *)data key:(NSString *)key;
+ (CocoaSecurityResult *)aesEncrypt4Harex:(NSString *)data key:(NSString *)key;// 군인공제회 - aesEncrypt
+ (CocoaSecurityResult *)aesEncrypt:(NSString *)data hexKey:(NSString *)key hexIv:(NSString *)iv;
+ (CocoaSecurityResult *)aesEncrypt:(NSString *)data key:(NSData *)key iv:(NSData *)iv;
+ (CocoaSecurityResult *)aesEncryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv;
#pragma mark AES Decrypt
+ (CocoaSecurityResult *)aesDecryptWithBase64:(NSString *)data key:(NSString *)key;
+ (CocoaSecurityResult *)aesDecrypt4HarexWithBase64:(NSString *)data key:(NSString *)key;// 군인공제회 - aesDecrypt
+ (CocoaSecurityResult *)aesDecryptWithBase64:(NSString *)data hexKey:(NSString *)key hexIv:(NSString *)iv;
+ (CocoaSecurityResult *)aesDecryptWithBase64:(NSString *)data key:(NSData *)key iv:(NSData *)iv;
+ (CocoaSecurityResult *)aesDecryptWithHex:(NSString *)data key:(NSString *)key;
+ (CocoaSecurityResult *)aesDecryptWithHex:(NSString *)data hexKey:(NSString *)key hexIv:(NSString *)iv;
+ (CocoaSecurityResult *)aesDecryptWithHex:(NSString *)data key:(NSData *)key iv:(NSData *)iv;
+ (CocoaSecurityResult *)aesDecryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv;

#pragma mark - MD5
+ (CocoaSecurityResult *)md5:(NSString *)hashString;
+ (CocoaSecurityResult *)md5WithData:(NSData *)hashData;
#pragma mark HMAC-MD5
+ (CocoaSecurityResult *)hmacMd5:(NSString *)hashString hmacKey:(NSString *)key;
+ (CocoaSecurityResult *)hmacMd5WithData:(NSData *)hashData hmacKey:(NSString *)key;

#pragma mark - SHA
+ (CocoaSecurityResult *)sha1:(NSString *)hashString;
+ (CocoaSecurityResult *)sha1WithData:(NSData *)hashData;
+ (CocoaSecurityResult *)sha224:(NSString *)hashString;
+ (CocoaSecurityResult *)sha224WithData:(NSData *)hashData;
+ (CocoaSecurityResult *)sha256:(NSString *)hashString;
+ (CocoaSecurityResult *)sha256WithData:(NSData *)hashData;
+ (CocoaSecurityResult *)sha384:(NSString *)hashString;
+ (CocoaSecurityResult *)sha384WithData:(NSData *)hashData;
+ (CocoaSecurityResult *)sha512:(NSString *)hashString;
+ (CocoaSecurityResult *)sha512WithData:(NSData *)hashData;
#pragma mark HMAC-SHA
+ (CocoaSecurityResult *)hmacSha1:(NSString *)hashString hmacKey:(NSString *)key;
+ (CocoaSecurityResult *)hmacSha1WithData:(NSData *)hashData hmacKey:(NSString *)key;
+ (CocoaSecurityResult *)hmacSha224:(NSString *)hashString hmacKey:(NSString *)key;
+ (CocoaSecurityResult *)hmacSha224WithData:(NSData *)hashData hmacKey:(NSString *)key;
+ (CocoaSecurityResult *)hmacSha256:(NSString *)hashString hmacKey:(NSString *)key;
+ (CocoaSecurityResult *)hmacSha256WithData:(NSData *)hashData hmacKey:(NSString *)key;
+ (CocoaSecurityResult *)hmacSha384:(NSString *)hashString hmacKey:(NSString *)key;
+ (CocoaSecurityResult *)hmacSha384WithData:(NSData *)hashData hmacKey:(NSString *)key;
+ (CocoaSecurityResult *)hmacSha512:(NSString *)hashString hmacKey:(NSString *)key;
+ (CocoaSecurityResult *)hmacSha512WithData:(NSData *)hashData hmacKey:(NSString *)key;
@end


#pragma mark - CocoaSecurityEncoder
@interface CocoaSecurityEncoder : NSObject
- (NSString *)base64:(NSData *)data;
- (NSString *)hex:(NSData *)data useLower:(BOOL)isOutputLower;
@end


#pragma mark - CocoaSecurityDecoder
@interface CocoaSecurityDecoder : NSObject
- (NSData *)base64:(NSString *)data;
- (NSData *)hex:(NSString *)data;
@end

NS_ASSUME_NONNULL_END

/*
 Usage :
 
 [MD5]
 CocoaSecurityResult *md5 = [CocoaSecurity md5:@"kelp"];
 // md5.hex = 'C40C69779E15780ADAE46C45EB451E23'
 // md5.hexLower = 'c40c69779e15780adae46c45eb451e23'
 // md5.base64 = 'xAxpd54VeAra5GxF60UeIw=='
 
 [SHA256]
 CocoaSecurityResult *sha256 = [CocoaSecurity sha256:@"kelp"];
 // sha256.hexLower = '280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9'
 // sha256.base64 = 'KA+LuMQ9Uy84nvDipTISILB4KwZSBdzfy42PAu1RFbk='
 
 CocoaSecurityResult *sha256 = [CocoaSecurity sha256:@"테스트"];
 NSLog(@"%@", [sha256 base64]);
 NSLog(@"%@", [sha256 hexLower]);
 // bc19d3b3c9e45818c670965f21e9a65e2cb6ef2b91265dbb4baa82124977a58d
 
 [default AES Encrypt]
 key -> SHA384(key).sub(0, 32)
 iv -> SHA384(key).sub(32, 16)
 CocoaSecurityResult *aesDefault = [CocoaSecurity aesEncrypt:@"kelp" key:@"key"];
 // aesDefault.base64 = 'ez9uubPneV1d2+rpjnabJw=='
 
 [AES256 Encrypt]
 CocoaSecurityResult *aes256 = [CocoaSecurity aesEncrypt:@"kelp"
 hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
 hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
 // aes256.base64 = 'WQYg5qvcGyCBY3IF0hPsoQ=='
 
 [AES256 Decrypt]
 CocoaSecurityResult *aes256Decrypt = [CocoaSecurity aesDecryptWithBase64:@"WQYg5qvcGyCBY3IF0hPsoQ=="
 hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
 hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
 // aes256Decrypt.utf8String = 'kelp'
 
 [HEX Encode]
 CocoaSecurityEncoder *encoder = [CocoaSecurityEncoder new];
 NSString *str1 = [encoder hex:[@"kelp" dataUsingEncoding:NSUTF8StringEncoding] useLower:NO];
 // str1 = '6B656C70'
 
 [HEX Decode]
 CocoaSecurityDecoder *decoder = [CocoaSecurityDecoder new];
 NSData *data1 = [decoder hex:@"CC0A69779E15780ADAE46C45EB451A23"];
 // data1 = <cc0a6977 9e15780a dae46c45 eb451a23>
 
 [BASE64 Encode]
 NSString *str2 = [encoder base64:[@"kelp" dataUsingEncoding:NSUTF8StringEncoding]];
 // str2 = 'a2VscA=='
 
 [BASE64 Decode]
 NSData *data2 = [decoder base64:@"zT1PS64MnXIUDCUiy13RRg=="];
 // data2 = <cd3d4f4b ae0c9d72 140c2522 cb5dd146>
 
 [BASE64 encode/decode]
 CocoaSecurityEncoder *encoder = [CocoaSecurityEncoder new];
 CocoaSecurityDecoder *decoder = [CocoaSecurityDecoder new];
 NSString *str2 = [encoder base64:[@"안녕하세요!" dataUsingEncoding:NSUTF8StringEncoding]];
 NSLog(@"%@", str2);
 NSData *data2 = [decoder base64:str2];
 NSLog(@"%@", data2);
 NSLog(@"%@", [data2 toStr]);
 */
