//
//  SelvyCreditCardRecognizer.h
//  SelvyCreditCardRecognizer
//
//  Created by selvasAI on 2018. 8. 8..
//  Copyright © 2018년 SelvasAI. All rights reserved.
//

#import "SelvyCreditCardInfo.h"

/*!
 * @class   SelvyCreditCardRecognizer
 * @abstract    SelvyCreditCardRecognizer 클래스
 * @discussion  신용카드 인식 클래스
 */
@interface SelvyCreditCardRecognizer : NSObject

/*!
 * @discussion  버전 정보 스트링을 리턴
 * @return  NSString  버전 정보 스트링
 */
+ (NSString *)getVersion;

/*!
 * @discussion  신용카드 인식기 엔진의 객체를 리턴
 * @return  id  신용카드 인식기 엔진의 객체
 */
+ (id)getInstance;

/*!
 * @discussion  신용카드 인식기 엔진 초기화
 * @return  int  엔진 초기화 결과
 */
- (int)initialize;

/*!
 * @discussion  신용카드 인식기 엔진 초기화
 * @param   bundleResourcePath  롬파일 및 라이선스 파일이 위치한 번들 resource 경로
 * @return  int  엔진 초기화 결과
 */
- (int)initialize:(NSString *)bundleResourcePath;

/*!
 * @discussion  신용카드 인식
 * @param   image    신용카드 이미지
 * @return  int  신용카드 인식 성공 여부
 */
- (int)recognize:(UIImage *)image;

/*!
 * @discussion  신용카드 인식. key, iv 값이 유효한 경우 카드번호를 암호화하며 해당 값이 유효하지 않을 경우 카드번호를 암호화 하지 않음
 * @param   image    신용카드 이미지
 * @param   key 암호화에 사용될 키(길이 : 32byte(256bit))
 * @param   iv 암호화에 사용될 Initialization Vector(길이 : 16byte(128bit))
 * @return  int  신용카드 인식 성공 여부
 */
- (int)recognize:(UIImage *)image key:(NSString *)key iv:(NSString *)iv;

/*!
 * @discussion  신용카드 인식기 엔진 해제
 */
- (void)finalize;

/*!
 * @discussion  신용카드 인식 결과를 리턴
 * @return  SelvyCreditCardInfo  신용카드 인식 결과
 */
- (SelvyCreditCardInfo *)getResult;

// AES-256 복호화
/*!
 * @discussion  복호화 결과를 리턴
 * @param   data 복호화 할 데이터
 * @param   key 복호화에 사용될 키(길이 : 32byte(256bit))
 * @param   iv 복호화에 사용될 Initialization Vector(길이 : 16byte(128bit))
 * @return  NSString 복호화 된 데이터의 NSString (데이터가 유효하지 않거나 키값 길이가 맞지 않을 경우 nil 리턴)
 */
+ (NSString *)decryptDataToStringUsingAES:(NSData *)data key:(NSString *)key iv:(NSString *)iv;

/*!
 * @discussion  주어진 NSData를 NSString 타입으로 리턴
 * @param   data NSString 타입으로 변경할 NSData
 * @return  NSString 변경된 결과(데이터가 유효하지 않을 경우 nil 리턴)
 */
+ (NSString *)dataToString:(NSData *)data;

@end
