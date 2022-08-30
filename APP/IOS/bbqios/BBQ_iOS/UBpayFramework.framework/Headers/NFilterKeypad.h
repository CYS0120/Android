//
//  NFilterKeypad.h
//  UBPay
//
//  Created by jkpark on 01/16/2019.
//  Copyright © 2019 harex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@protocol NFilterKeypadDelegate;

@interface NFilterKeypad : NSObject 

@property(nonatomic, strong) id<NFilterKeypadDelegate> delegate;
@property(nonatomic, copy) NSString *tagName;

- (void)showKeypad:(NSDictionary *)dic ofWebView:(WKWebView *)aWebView;
- (void)hideKeypad ;

@end

@protocol NFilterKeypadDelegate <NSObject>
@optional
- (void) didShowKeypad:(NFilterKeypad *)keypad;
- (void) didCloseKeypad:(NFilterKeypad *)keypad;
- (void) didCompletedInput:(NFilterKeypad *)keypad;
- (void) didChangeKeyValue:(NFilterKeypad *)keypad info:(NSDictionary *)keyInfo;
@end
