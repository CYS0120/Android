//
//  CreditCardVC.h
//  SelvyOCRforCreditCardDemo
//
//  Created by selvas on 2018. 9. 8..
//  Copyright © 2018년 SelvasAI. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "SelvyCreditCardDelegate.h"

// 신용카드 촬영 ViewController
// 신용카드를 촬영하고 인식 결과를 전달
@interface CreditCardVC : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, SelvyCreditCardDelegate>

@property (copy, nonatomic) NSString *aes256key; // AES-256 에서 사용할 키 값 : 32 Byte (256 bit)
@property (copy, nonatomic) NSString *aes256iv; // AES-256 에서 사용한 IV 키 값 : 16 Byte (128 bit)
@property (weak, nonatomic) id<SelvyCreditCardDelegate> recognitionDelegate;

@end
