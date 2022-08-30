#ifndef DS_SSLC_H
#define DS_SSLC_H


// DS_SSL ERROR Definition
#define SSL_NO_ERR									0
#define SSL_ERROR									-1
#define SSL_TIMEOUT									-99
#define SSL_INIT_ERR								-100
#define SSL_SOCKET_ERR								-101
#define SSL_HANDSHAKE_ERR							-102
#define SSL_X509CERT_ERR							-103
#define SSL_WTLSCERT_ERR							-104
#define SSL_DATA_WRONG								-105
#define SSL_PASSWD_WRONG							-106
#define SSL_CIPHER_WRONG							-107
#define SSL_RSA_ENCRYPT_ERR							-108
#define SSL_RSA_DECRYPT_ERR							-109
#define SSL_ENCRYPT_ERR								-110
#define SSL_DECRYPT_ERR								-111
#define SSL_MAC_ERR									-112
#define SSL_LICENSE_ERR								-113
#define SSL_CERTINIT_ERR							-114
#define SSL_SETCERTENV_ERR							-115
#define SSL_TRUSTEDCERT_ERR							-116
#define SSL_VERIFYCERT_ERR							-117
#define SSL_VERIFYSKI_ERR							-118
#define SSL_VERIFY_VALIDATE_ERR						-119
#define SSL_MEM_ALLOC_ERR							-120

#define SSL_RECORD_HEADER_LEN			5

// SSL handshake return value
#define SSL_HANDSHAKE_SUCCESS           0
#define SSL_HANDSHAKE_SEND				1
#define SSL_HANDSHAKE_SEND_RECV			2
#define SSL_HANDSHAKE_RECV				3
#define SSL_HANDSHAKE_CONTINUE			4

// Certificate Verfify Option
#define CERT_VERIFY_NONE				0	// 인증서 검증 안함
#define CERT_VERIFY_FULLPATHANDDATE		5	// 인증서 체인 검증 및 유효기간 검증
#define CERT_VERIFY_FULLPATHONLY		6	// 인증서 체임 검증(유효기간 검증 안함)

#if defined(WIN32) || defined(MAGICNET_EXPORTS)
#	ifdef _USRDLL
#		ifdef __cplusplus
#			define SSLEXPORT extern "C" __declspec(dllexport)
#		else
#			define SSLEXPORT __declspec(dllexport)
#		endif
#	elif defined(_LIB)
#		define SSLEXPORT extern
#	else
#		ifdef SSLCLIENTLIB_EXPORTS
#			ifdef __cplusplus
#				define SSLEXPORT extern "C" __declspec(dllimport)
#			else
#				define SSLEXPORT __declspec(dllimport)
#			endif
#		else
#			define SSLEXPORT extern
#		endif
#	endif
#else
# ifdef __cplusplus
#   define SSLEXPORT extern "C"
# else
#   define SSLEXPORT
# endif
#endif

#ifdef __cplusplus
extern "C" {
#endif


SSLEXPORT int SSL_Begin(void** pMe);                                                          
SSLEXPORT int SSL_End(void* pMe);                                                             
SSLEXPORT int SSL_HandShake(void* pMe, unsigned char *pBuffer, unsigned short *nLen, int *pnStatus);         
SSLEXPORT int SSL_Encrypt(void* pMe, void* pInData, unsigned short nInData, void* pOutData);  
SSLEXPORT int SSL_Decrypt(void* pMe, void* pInData, unsigned short nInData, void* pOutData);  
SSLEXPORT int SSL_getRecordBodyLen(unsigned char* pBuffer);

SSLEXPORT int SSL_CertEnvInit(void* pMe, char *pszWorkPath, char *pszConfigPath, char *pSKI, int nVerifyOption);
SSLEXPORT int SSL_AddTrustedCert(void* pMe, unsigned char *pszTrustedCert, int nTrustedCertLen);
SSLEXPORT int SSL_GetServerCert( void* pMe, unsigned char* pCert, int *pnLen );
SSLEXPORT int SSL_GetDSTKError( void* pMe );

#ifdef __cplusplus
}
#endif



#endif   /* DS_SSLC_H */

