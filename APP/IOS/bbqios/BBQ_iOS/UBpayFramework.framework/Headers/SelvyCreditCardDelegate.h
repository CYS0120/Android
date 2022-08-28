//
//  CreditCardDelegate.h
//  CreditCardRecognizer
//
//  Created by selvasAI on 2018. 8. 8..
//  Copyright © 2018년 SelvasAI. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @typedef CreditCardError
 * @brief   신용카드 인식 에러 종류
 * @constant    CreditCardErrorCamera  카메라 초기화 실패
 * @constant    CreditCardErrorEngine   엔진 에러
 * @constant    CreditCardErrorRecognize    인식 실패
 */
typedef NS_ENUM(NSInteger, CreditCardError) {
    CreditCardErrorCamera,
    CreditCardErrorEngine,
    CreditCardErrorRecognize,
} __TVOS_PROHIBITED;

/*!
 * @protocol    SelvyCreditCardDelegate
 * @abstract    SelvyCreditCardRecognizer 의 인식 결과를 전달하는 프로토콜
 * @discussion  신용카드 인식의 결과(성공/실패) 및 그에 따른 자세한 정보(인식 결과 혹은 실패 메시지)를 전달하는 프로토콜
 */
@protocol SelvyCreditCardDelegate<NSObject>

@required
/*!
 * @discussion  신용카드 촬영 및 인식 성공 시, 결과 전달
 * @param   cardImage 인식에 사용된 카드 이미지
 * @param   cardNumber 카드 번호 스트링
 * @param   expiryMonth 카드 유효기간 월 스트링
 * @param   expiryYear 카드 유효기간 년 스트링
 */
- (void)onCreditCardDetected:(UIImage *)cardImage cardNumber:(NSString *)cardNumber expiryMonth:(NSString *)expiryMonth expiryYear:(NSString *)expiryYear;

/*!
 * @discussion  신용카드 촬영화면에서 촬영이나 인식 실패 시, 결과 전달
 * @param   errorCode 신용카드 인식 실패 코드
 */
- (void)onCreditCardError:(CreditCardError)errorCode;

// OCR 스캔 화면에서 닫기 시 Delegate 추가
- (void)onCreditCardCancel;

@end
