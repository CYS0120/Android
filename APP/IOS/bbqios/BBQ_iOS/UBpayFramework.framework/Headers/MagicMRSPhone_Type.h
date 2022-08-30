#ifndef _MAGICMRSPHONE_TYPE_H
#define _MAGICMRSPHONE_TYPE_H

#define MAGICMRSPHONE_SERVICETYPE_EXPORT	10000			// 인증서 내보내기
#define MAGICMRSPHONE_SERVICETYPE_IMPORT	10001			// 인증서 가져오기
#define MAGICMRSPHONE_SERVICETYPE_SIGNED	10002			// 전자서명 하기

typedef struct tagMagicMRSPhoneHostInfo
{
	char*	pszHostAddress;					// Phone G/W 주소
	int		nHostPort;						// Phone G/W 포트
}MAGICMRSPHONE_HOSTINFO, *PMAGICMRSPHONE_HOSTINFO;


typedef struct tagMagicMRSPhoneUserInfo
{
	char*	pszPhoneNumber;					// 단말기 고유번호
	char*	pszMinNumber;					// 단말기 고유번호
	int		nServiceType;					// 서비스 타입
	char*	pszIdentifier;					// Application 식별번호
}MAGICMRSPHONE_USERINFO, *PMAGICMRSPHONE_USERINFO;


typedef struct tagMagicMRSPhoneServiceInfo
{
	MAGICMRSPHONE_HOSTINFO	hostInfo;					// Phone G/W 서버정보 구조체
	MAGICMRSPHONE_USERINFO	userInfo;					// 서비스 사용자 정보 구조체
}MAGICMRSPHONE_SERVICEINFO, *PMAGICMRSPHONE_SERVICEINFO;


typedef struct tagMagicMRSPhoneAppInfo
{
	char*			pszAppName;							// 이동 라이브러리를 사용하는 어플리케이션의 이름
	char*			pszAppVersion;					// 이동 라이브러리를 사용하는 어플리케이션의 버전
}MAGICMRSPHONE_APPHINFO, *PMAGICMRSPHONE_APPINFO;


typedef struct tagMagicMRSPhoneDeviceInfo
{
	char*			pszDeviceSerial;					// 기기 시리얼 번호
	char*			pszOSName;							// 기기 OS 이름
	char*			pszOSVersion;						// 기기 OS 버전
	char*			pszPhoneNumber;						// 기기 휴대폰 번호
}MAGICMRSPHONE_DEVICEINFO, *PMAGICMRSPHONE_DEVICEINFO;


typedef struct tagMagicMRSPhoneAppHashInfo
{
	MAGICMRSPHONE_APPHINFO		appInfo;				// 이동 라이브러리를 사용하는 어플리케이션의 정보
	MAGICMRSPHONE_DEVICEINFO	deviceInfo;				// 이동 라이브러리를 사용하는 기기의 정보
}MAGICMRSPHONE_APPHASHINFO, *PMAGICMRSPHONE_APPHASHINFO;


typedef struct tagMagicMRSPhoneAuthCodeInfo
{
	int			nPcStatus;					// PC상태(0:접속, 1:미접속)
	char		szAuthCode[16];				// 인증번호
	bool		bInputAuthCode;				// 인증번호 출력 여부
}MAGICMRSPHONE_AUTHCODEINFO, *PMAGICMRSPHONE_AUTHCODEINFO;


typedef struct tagMagicMRSPhoneServiceTypeInfo
{
	int			nServiceType;				// 서비스 타입(0:인증서 내보내기, 1:인증서 가져오기, 2:서명하기)
}MAGICMRSPHONE_SERVICETYPEINFO, *PMAGICMRSPHONE_SERVICETYPEINFO;


typedef struct tagMagicMRSPhoneCertificate
{
	unsigned char*	pSignCert;				// 서명용 인증서 버퍼
	unsigned int	nSignCertSize;			// 서명용 인증서 버퍼 사이즈
	unsigned char*	pSignPri;				// 서명용 개인키 버퍼
	unsigned int	nSignPriSize;			// 서명용 인증서 버퍼 사이즈
	unsigned char*	pKmCert;				// 암호화용 인증서 버퍼
	unsigned int	nKmCertSize;			// 암호화용 인증서 사이즈
	unsigned char*	pKmPri;					// 암호화용 개인키 버퍼
	unsigned int	nKmPriSize;				// 암호화용 개인키 버퍼 사이즈
	int				nCertUsage;				// 서명용:USAGE_SIGN, 암호화용:USAGE_KM, 모두:USAGE_ALL
}MAGICMRSPHONE_CERTIFICATE, *PMAGICMRSPHONE_CERTIFICATE;


typedef struct tagMagicMRSPhoneVerifyCertificate
{
	MAGICMRSPHONE_HOSTINFO	hostInfo;				// Phone G/W 서버정보 구조체
	char*					pszPhoneNumber;			// 단말기 고유번호
	char*					pszMinNumber;			// 단말기 고유번호
	unsigned char*			pCertificate;			// 인증서 버퍼
	unsigned int			nCertificateSize;		// 인증서 버퍼 사이즈
	char*					pszIdentifier;			// Application 식별번호
	int						nCertStatus;			// 검증한 결과(0:유효, 1:폐지, 2:효력정지)
}MAGICMRSPHONE_VERIFYCERTIFICATE, *PMAGICMRSPHONE_VERIFYCERTIFICATE;

#endif //_CERTMOVEWIFI_TYPE_H