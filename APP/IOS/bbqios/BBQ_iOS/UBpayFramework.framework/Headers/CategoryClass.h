//
//  CategoryClass.h
//  UBpay
//
//  Created by younghu min on 2017. 10. 19..
//  Copyright © 2017년 HarexInfoTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryClass : NSObject
+ (instancetype) sharedInstance;

-(id)getNSDataWithBase64EncodedString:(NSString *)string;

- (NSString *) stringWithHexBytes1:(id)data;
- (NSString *) stringWithHexBytes2:(id)data;


- (NSData *)AES256EncryptWithKey:(NSString *)key self:(id)data;
- (NSData *)AES256DecryptWithKey:(NSString *)key self:(id)data;

-(NSString *) AESEncryptDictionary : (NSMutableDictionary *) encDictionary securekey: (NSString *)securekey;
-(NSDictionary *)AESDecryptDictionary : (NSString*) response securekey :(NSString *) securekey;

- (NSString *) base64Encoding:(id)data;
- (NSString *) base64EncodingWithLineLength:(NSUInteger) lineLength with:(id)data;

- (NSString *) stringFromHex:(NSString *)str;
- (NSString *) stringToHex:(NSString *)str;

- (NSDate *)dateBySubtractingWeeks:(NSInteger)weeks with:(NSDate *)date;
- (NSCalendar *)implicitCalendar;

- (NSDate *)dateBySubtractingYears:(NSInteger)years with:(NSDate *)date;
- (NSDate *)dateBySubtractingMonths:(NSInteger)months with:(NSDate *)date;
- (NSDate *)dateBySubtractingDays:(NSInteger)days with:(NSDate *)date;
- (NSDate *)dateBySubtractingHours:(NSInteger)hours with:(NSDate *)date;
- (NSDate *)dateBySubtractingMinutes:(NSInteger)minutes with:(NSDate *)date;
- (NSDate *)dateBySubtractingSeconds:(NSInteger)seconds with:(NSDate *)date;

- (NSString*) urlEncodedString:(NSString *)str;
- (NSString*) urlDecodedString:(NSString *)str;

@end
