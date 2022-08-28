//
//  MessageManager.h
//  UBpay
//
//  Created by jkpark on 2020. 2. 26..
//  Copyright © 2019 harex. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@protocol MessageManagerDelegate <NSObject>
@optional
- (void)loaded:(int)opCode :(NSString*)result;
- (void)failed:(int)opCode :(NSString*)msg;
@end

typedef struct {
    char    szProtocol[4];
    char    szMDN[16];
    char    szVMType[3];
    char    szOPCode[3];
    char    cResult;
    //    char    szNo[16];
    char    cReserved;
    unsigned int nLen;
} HEADER;

typedef enum {
    KTFIPHONE=25
} VMTYPE;

@interface MessageManager : NSObject <AsyncSocketDelegate> {
    HEADER              rcvheader;
    NSString*           hostip;
    unsigned int        hostport;
    BOOL                bUseSSL;
}

@property (nonatomic, strong) id<MessageManagerDelegate>delegate;
@property (retain, nonatomic) AsyncSocket *socket;

@property (nonatomic, retain) NSString *mdn;
@property (nonatomic, retain) NSString *vmtype;

+ (instancetype) sharedInstance;
- (instancetype) initWithMode:(BOOL)isDev;
- (void)sendRequest:(int)opCode withParam:(NSString *)param;

@end
