//
//  AsyncSocket.h
//  UBpay
//
//  Created by jkpark on 2020. 2. 26..
//  Copyright © 2019 harex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "soc_common2.h"
#import "DS_SSLC.h"

@class AsyncSocket;

#define HRX_WEBVIEW_TIME_INTERVAL       (30)    // 웹뷰 로딩 시간 정의(초)
#define HRX_SOCKET_TIME_OUT             (60)    // 소켓 대기시간(초)
#define HRX_BARCODE_TIME_OUT            (299)   // 바코드 대기시간(초)

@protocol AsyncSocketDelegate
@optional
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err;
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err isWifi:(BOOL)wifi;
- (void)onSocketDidDisconnect:(AsyncSocket *)sock;
- (BOOL)onSocketWillConnect:(AsyncSocket *)sock;
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag;
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag;
- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag;

@end

@interface AsyncSocket : NSObject {
    id	delegate;
    int sock_id;
    void *pSSLContext;
    bool isWifiError;
}

- (id)initWithDelegate:(id)_delegate;
- (BOOL)connectToHost:(NSString*)hostname onPort:(UInt16)port error:(NSError **)errPtr;
- (BOOL)connectToHost:(NSString *)hostname onPort:(UInt16)port withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr;
- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag;
- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
- (void)disconnect;
- (NSString *)connectedHost;
- (UInt16)connectedPort;
- (NSString *)localHost;
- (UInt16)localPort;
- (void)useSSL:(BOOL)bSet;

@end
