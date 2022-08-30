//
//  SelvyCreditCardInfo.h
//  SelvyCreditCardRecognizer
//
//  Created by selvasAI on 2018. 8. 8..
//  Copyright © 2018년 SelvasAI. All rights reserved.
//

/*!
 * @constant    SELVY_CREDITCARD_INFO_IS_VALID  인식 성공 및 유효한 정보
 */
static int const SELVY_CREDITCARD_INFO_IS_VALID = 1;
/*!
 * @constant    SELVY_CREDITCARD_INFO_IS_NOT_VALID  인식 성공 및 유효하지 않은 정보
 */
static int const SELVY_CREDITCARD_INFO_IS_NOT_VALID = 0;
/*!
 * @constant    SELVY_CREDITCARD_INFO_IS_NOT_RECOGNIZED  인식 실패
 */
static int const SELVY_CREDITCARD_INFO_IS_NOT_RECOGNIZED = -1;
// Constant ]]

/*!
 * @class   SelvyCreditCardInfo
 * @abstract    SelvyCreditCardInfo 클래스
 * @discussion  신용카드 인식 결과 클래스
 */
@interface SelvyCreditCardInfo : NSObject

/*!
 * @@property numberValidationInfo
 * @brief   카드 번호 유효성
 */
@property int numberValidationInfo;
/*!
 * @@property numberCount
 * @brief   카드 번호 자릿수
 */
@property int numberCount;
/*!
 * @@property number
 * @brief   카드 번호 스트링
 */
@property (strong, nonatomic) NSString* number;

/*!
 * @@property number
 * @brief   암호화 된 카드 번호 NSData
 */
@property (strong, nonatomic) NSData* encryptNumber;

/*!
 * @@property expiryValidationInfo
 * @brief   카드 유효기간 유효성
 */
@property int expiryValidationInfo;

/*!
 * @@property expiryMonth
 * @brief   카드 유효기간 월 스트링
 */
@property (strong, nonatomic) NSString* expiryMonth;
/*!
 * @@property expiryYear
 * @brief   카드 유효기간 년 스트링
 */
@property (strong, nonatomic) NSString* expiryYear;

@end
