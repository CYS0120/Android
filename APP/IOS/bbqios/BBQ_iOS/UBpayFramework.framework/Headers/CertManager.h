//
//  CertManager.h
//  UBPay
//
//  Created by JinJaehoon on 2017. 8. 10..
//  Copyright © 2017년 younghu min. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MagicMRSPhone.h"
#import "MagicXSign_Type.h"
#import "MagicXSign_Main.h"
#import "MagicXSign_ErrCode.h"

#define    MRS_SAMPLE_STAT_READY            0    // 인증서 이동 쓰레드 상태
#define    MRS_SAMPLE_STAT_KEY                1    // 인증서 이동 인증키 발급
#define    MRS_SAMPLE_STAT_END                2    // 인증서 이동 이동 완료
#define    MRS_SAMPLE_STAT_CONTIUNE        3    // 인증서 이동 대기
#define MRS_SAMPLE_STAT_CANCEL            4
#define MRS_SAMPLE_STAT_TIMEOUT         5 //인증서 타임 아웃
#define INDICATOR_VIEW    93451124
#define LABELTAG    9900

#define TAG_ALERT_TYPE_GET_CERT_SUCCESS 6110
#define TAG_ALERT_TYPE_GET_CERT_CANCEL 6111
#define TAG_ALERT_TYPE_GET_CERT_ACCEPTED 6112
#define TAG_ALERT_TYPE_GET_CERT_CANCEL_SUCCESS 6113
#define TAG_ALERT_TYPE_GET_CERT_TIMEOUT 6114

@protocol CertDelegate<NSObject>
@optional
-(void) setSerial:(NSString *)text serial2:(NSString*) serial2 serial3:(NSString*) serial3;
-(void) onSave;
-(void) alertMessage:(NSString *) msg;
-(void) toastMessage: (NSString *) msg;
@end

@class CertManager;

@interface Cert : NSObject {
    
    NSString                        *marServerIP;
    int                             marServerPort;
    NSString                        *marServerSID;
    MAGICMRSPHONE_SERVICETYPEINFO    serviceTypeInfo;
    char                            szMoveAuthString[14];                // 승인번호 12자리
    int                             iMode;
    int                             iTimer;
    NSMutableString                 *nsStrLog;
    
    id<CertDelegate>      certDelegate;
    CertManager          *certManager;
    
    void* pCtx;
}

@property (nonatomic, retain) id<CertDelegate> certDelegate;
- (id)initWithDelegate:(id)_delegate;
- (void) loadCert;

@end

@interface CertManager : NSObject {
    int iCertType;
    int iPkiType;
    int iSelect;
    int iCertDetail;
    void* pCtx;
    NSMutableArray            *certList;
}


@property (nonatomic, retain) NSMutableArray* certList;
@property (nonatomic, readonly) void* pCtx;

// Add by chlee 2012.03.21
@property (nonatomic, retain) NSMutableArray *unexpiredCertIndexList;

+ (instancetype) sharedInstance;
-(void)reloadCert;

-(int)CertDelete:(int)row;
-(int)CertChangePassword:(int)row oldpwd:(NSString*)oldpwd newpwd:(NSString*)newpwd;
-(BOOL)checkPassword:(int)row :(NSString*)passwd;
- (int) checkPassword2:(int)row pwd:(NSString *)passwd ssn:(NSString *) ssn;
-(int)CertVerify:(int)row ident:(NSString*)ident passwd:(NSString*)passwd;
-(NSData*)CertSign:(int)row rawData:(NSString*)rawData withPasswd:(NSString*)passwd;
-(NSString*)getCPW:(NSString*)pCVC :(NSString*)pCPW :(NSString*)pYYMM;
-(NSString*)getCPW2:(NSString*)pCVC :(NSString*)pCPW :(NSString*)pYYMM;    // for shinhan
-(NSString*)asymEncrypt:(unsigned char*)byPubKey keylen:(int)keylen input:(NSString*)input;
-(NSString*)asymEncrypt2:(NSString*)pubKey input:(NSString*)input;
- (NSString*)asymEncrypt3:(NSString*)pubKey input:(NSString*)input;
- (NSString*)asymEncrypt33:(NSString*)pubKey input:(NSString*)input;
- (NSString*)asymEncrypt4:(NSString*)pubKey input:(NSString*)input juMin:(NSString *)juMin accNum:(NSString *)accNum;

// Modify by chlee 2013.04.29
// 공인인증 본인확인을 위해 NSData를 암호화하는 메소드 추가
- (NSString *)asymEncryptData:(NSString *)pubKey input:(NSData *)input;
//

// Add by chlee 2012.03.21
// 유효한 인증서 갯수 반환
- (void)reloadUnexpiredCert;
- (NSInteger)getUnexpiredCertCount;

// Add by chlee 2012.03.30
// 개인 확인용 VID 추출
- (NSString *)getVIDRandomWithCertIndex:(NSInteger)index certPassword:(NSString *)password;
// cert를 통채로 읽어 오기
- (NSString *)getCertWithIndex:(NSInteger)index;
//

// Add by chlee 2013.04.29
// VID Random을 NSData 형태로 반환
- (NSData *)getVIDRandomBinWithCertIndex:(NSInteger)index certPassword:(NSString *)password;

@end





@interface NSString (Base64)
-(NSString *)base64Encoded;
-(NSString *)base64Decoded;
@end


@interface NSData (Addition)

- (void)clear;

@end

