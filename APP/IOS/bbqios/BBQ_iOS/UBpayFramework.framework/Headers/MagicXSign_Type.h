#if !defined(___DSTOOLKIT_IPHONE_TYPE_H___)
#define ___DSTOOLKIT_IPHONE_TYPE_H___




#define		FILE_NPKI_SIGNCERT		"signCert.der"
#define		FILE_NPKI_SIGNKEY		"signPri.key"
#define		FILE_NPKI_KMCERT		"kmCert.der"
#define		FILE_NPKI_KMKEY			"kmPri.key"
#define		FILE_GPKI_SIGNCERT		"_sig.cer"
#define		FILE_GPKI_SIGNKEY		"_sig.key"
#define		FILE_GPKI_KMCERT		"_env.cer"
#define		FILE_GPKI_KMKEY			"_env.key"

#define		FILE_NPKI_CERT			".der"
#define		FILE_GPKI_CERT			".cer"

#define		FILE_CERT_FILEEXT		".der"
#define		FILE_KEY_FILEEXT		".key"

#define		FILE_NPKI_ROOTCA_DIR	"KISA"
#define		FILE_GPKI_ROOTCA_DIR	"Government of Korea"
#define		FILE_PPKI_ROOTCA_DIR	"RootCA"

#define		DEPTH_CA				1
#define		DEPTH_GPKI_USER			2
#define		DEPTH_NPKI_USER			3


/* 인증기관 종류 */
#define PKI_TYPE_NPKI						0x0001	/* 공인 인증 기관 */
#define PKI_TYPE_GPKI						0x0002	/* 행안부 인증 기관 */
#define PKI_TYPE_PPKI						0x0004	/* 사설 인증 기관 */

// 공인인증기관 종류
#define CA_TYPE_CROSSCERT					1		// CrossCert
#define CA_TYPE_SIGNGATE					2		// 
#define CA_TYPE_YESSIGN						3		// 
#define CA_TYPE_SIGNKOREA					4		// 
#define CA_TYPE_KTNET						5		// 
#define CA_TYPE_DREAMSECURITY				6		// 

/* 인증기관 종류 */
#define CERT_TYPE_ROOTCA					0x0001	/* 루트 인증서  */
#define CERT_TYPE_CA						0x0002	/* CA 인증서  */
#define CERT_TYPE_USER						0x0003	/* 사용자 인증서  */
#define CERT_TYPE_GPKI_COMPANY				0x0004	/* GPKI 기업 인증서  */
#define CERT_TYPE_GPKI_PRIVATE				0x0005	/* GPKI 개인 인증서  */

/* 인증서 종류 */
#define CERT_ALL							0x00	/* 모든 인증서 */
#define CERT_SIGN							0x01	/* 서명용 */
#define CERT_KM								0x02	/* 암호화용 */
#define CERT_CA 							0x03	/* CA  */


/* 데이터 종류 */
#define DATA_CA_CERT						0x01	/* CA 인증서 */
#define DATA_SIGN_CERT						0x02	/* 서명용 인증서 */
#define DATA_KM_CERT						0x03	/* 암호화용 인증서 */
#define DATA_ARL							0x05	/* 인증기관 폐지 목록 */ 
#define DATA_CRL							0x06	/* 사용자 인증서 폐지 목록 */
#define DATA_DELTA_CRL						0x07	/* Delta 인증서 폐지 목록 */
#define DATA_CTL							0x08	/* 인증서 신뢰 목록 */









/* DSTK */

typedef struct {
	unsigned char *pData;							/* 데이터의 포인터 */
	int nLen;										/* 데이터의 길이 */
} BINSTR;


/* 함수 인자 속성 */
#define IN											/* 입력 인자 */
#define OUT											/* 출력 인자 */
#define INOUT										/* 입출력 인자 */

/* RSA 버전 */
#define RSA_ENC_V15							0x01	/* RSA V1.5의 암복호화 수행*/ 
#define RSA_ENC_V20							0x02	/* RSA V2.0의 암복호화 수행 (OAEP) */
#define RSA_SIGN_V15							0x04	/* RSA v1.5 서명/검중 사용 */
#define RSA_SIGN_V20							0x08	/* RSA v2.0 서명/검증 사용 (PSS) */
	
/* CMS 옵션 */
#define OPT_NONE							0x00	/* 옵션 없음 */
#define OPT_USE_PKCS7						0x01	/* PKCS#7의 메시지 사용	*/
#define OPT_USE_CONTNET_INFO				0x02	/* ContentInfo 사용 */
#define OPT_NO_CONTENT						0x04	/* 원본메시지 포함하지 않음 */
#define OPT_ENC_PRIKEY_FORMAT				0x10	/* 입력하는 개인키가 암호화된 개인키 (PFX에서 사용)*/	
#define OPT_SK_SECURITIES_FORMAT			0x20	/* SK 증권에서 사용되는 서명 메시지 형식 */
#define OPT_SIGNGATE_FORMAT					0x20	/* 코스콤(SignGate) 형식으로 서명 */

/* 데이터 종류 */
#define DATA_CA_CERT						0x01	/* CA 인증서 */
#define DATA_SIGN_CERT						0x02	/* 서명용 인증서 */
#define DATA_KM_CERT						0x03	/* 암호화용 인증서 */
#define DATA_ARL							0x05	/* 인증기관 폐지 목록 */ 
#define DATA_CRL							0x06	/* 사용자 인증서 폐지 목록 */
#define DATA_DELTA_CRL						0x07	/* Delta 인증서 폐지 목록 */
#define DATA_CTL							0x08	/* 인증서 신뢰 목록 */

/* PEM 인코딩 데이터 종류 */
#define PEM_DATA_NO_HEADER_TAIL				0x00	/* PEM형식에서 첫번째와 마지막라인을 넣지않음 */
#define PEM_DATA_X509_CERT					0x01	/* X509 Certificate */
#define PEM_DATA_WTLS_CERT					0x02	/* WTLS Certificate */
#define PEM_DATA_CRL						0x03	/* Certificate Revocation List (CRL) */
#define PEM_DATA_CTL						0x04	/* Certificate Trust List (CTL) */
#define PEM_DATA_PKCS7						0x05	/* PKCS#7 */

/* 인증서 종류 */
#define CERT_SIGN							0x01	/* 서명용 */
#define CERT_KM								0x02	/* 암호화용 */
#define CERT_OCSP							0x03	/* OCSP 서버용 */ 
#define CERT_TSA							0x04	/* TSA 서버용 */

/* 인증서 검증 범위 */
#define CERT_VERIFY_FULL_PATH				0x01	/* 전체 경로 검증 */
#define CERT_VERIFY_ROOT2CA_CERT			0x02	/* CA 인증서까지만 검증 */
#define CERT_VERIFY_ONLY_USER_CERT			0x04	/* 사용자 인증서만 검증 */
#define CERT_VERIFY_POLICY_NONE				0x10	/* 사설 인증서와 같이 사용자 인증서에서 인증서 정책을 사용하지 않는경우에 지정함 */
#define CERT_VERIFY_STRICTLY				0x20	/* 인증서 규격에 맞게 세밀하게 확인할 경우 지정함 */

/* 인증서 폐지 여부 확인 방법 */
#define CERT_REV_CHECK_NONE					0x00	/* 폐지 여부 확인 하지 않음 */
#define CERT_REV_CHECK_ARL					0x01	/* ARL 확인 */
#define CERT_REV_CHECK_CRL					0x02	/* CRL 확인 */
#define CERT_REV_CHECK_OCSP					0x04	/* OCSP 확인 */ 
#define CERT_REV_CHECK_ALL					0x07	/* ARL, CRL, OCSP 모두 확인 */

/* 비 대칭키 종류 */
#define KEY_PRIVATE							0x01	/* 개인키 */
#define KEY_PUBLIC							0x02	/* 공개키 */
#define KEY_CERT							0x04	/* 인증서 */

/* 비 대칭키 알고리즘*/
#define ASYM_ALG_RSA_1024					0x10	/* RSA 1024 bit*/
#define ASYM_ALG_KCDSA_1024					0x20	/* KCDSA 1024 bit*/
#define ASYM_ALG_ECC_CURVE_5				0x30	/* ECC Curve5*/
#define ASYM_ALG_RSA_2048					0x40	/* RSA 2048 bit*/

/* 대칭키 알고리즘 */
#define SYM_ALG_DES_CBC						0x10	/* DES CBC */ 
#define SYM_ALG_3DES_CBC					0x20	/* 3DES CBC */
#define SYM_ALG_SEED_CBC					0x30	/* SEED CBC */
#define SYM_ALG_ARIA_CBC					0x40	/* ARIA CBC */
#define SYM_ALG_RC4_CBC						0x80	/* RC4 CBC */
#define SYM_ALG_NEAT_CBC					0xE0	/* NEAT CBC */
#define SYM_ALG_NES_CBC						0xF0	/* NES CBC */

/* 대칭키 암/복호화 패딩 */
#define PADDING_TYPE_PKCS5					0x01	/* PKCS#5 Padding */
#define PADDING_TYPE_SSL					0x02	/* SSL Padding */
#define PADDING_TYPE_NONE					0x03	/* no padding */

/* 해쉬 알고리즘 */
#define HASH_ALG_SHA1						0x01	/* SAH1 */
#define HASH_ALG_MD5						0x02	/* MD5 : NOT SUPPORTED */
#define HASH_ALG_HAS160						0x03	/* HAS160 : NOT SUPPORTED */ 
#define HASH_ALG_SHA256						0x04	/* SHA256 */

/* MAC 알고리즘 */
#define MAC_ALG_SHA1_HMAC					0x01	/* SAH1 HMAC */ 
#define MAC_ALG_MD5_HMAC					0x02	/* MD5 HMAC : NOT SUPPORTED*/
#define MAC_ALG_DES_MAC						0x03	/* DES-CBC MAC */
#define MAC_ALG_SHA256_HMAC					0x04	/* SHA256 HMAC */

/* 인증서 관리를 위해서 사용할 프로토콜 */
#define PROTOCOL_TCP_IP						0x01	/* TCP/IP */
#define PROTOCOL_HTTP						0x02	/* HTTP */

/* 인증서 관리 시 접속할 공인인증기관 */
#define CA_CROSS_CERT						0x01	/* 전자인증 */
#define CA_KOSCOM							0x02	/* 코스콤 */
#define CA_KTNET							0x03	/* 한국무역정보통신 */
#define CA_SIGN_GATE						0x04	/* 정보인증 */
#define CA_YES_SIGN							0x05	/* 금결원 */

/* 인증서 관리시 옵션 */
#define CMP_OPT_HARD2TOKEN					0x01	/* 인증서/키 갱신 시, 옵션으로 하드의 인증서를 토큰에서 갱신 */
#define CMP_OPT_TOKEN2HARD					0x02	/* 인증서/키 갱신 시, 옵션으로 토큰의 인증서를 하드에서 갱신 */

/* 폐지 사유 */
#define REASON_CODE_UNUSED					0x01	/* 알 수 없음 */
#define REASON_CODE_KEY_COMPROMISE			0x02 	/* 키 손상 */
#define REASON_CODE_AFFILIATION_CHANGED		0x03 	/* 소속, 이름의 변경 */
#define REASON_CODE_SUPERSEDED				0x04 	/* 인증서 재발급 */
#define REASON_CODE_CESSATION_OF_OPERATION	0x05	/* 더 이상 사용 안함 */
#define REASON_CODE_CERTIFICATE_HOLD		0x06 	/* 인증서 효력정지 */
#define REASON_CODE_PRIVILEGE_WITHDRAWN		0x07 	/* 더 이상 권한 없음 */

#endif /* !defined(___DSTOOLKIT_IPHONE_TYPE_H___) */
