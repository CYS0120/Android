#if !defined(___DSTOOLKIT_IPHONE_MAIN_H___)
#define ___DSTOOLKIT_IPHONE_MAIN_H___

# ifdef __cplusplus
#   define XSIGN_API extern "C"
# else
#   define XSIGN_API
# endif

/*
#ifndef  __cplusplus
 #ifndef _BOOL
typedef enum {
 false = 0,
 true = 1
} bool;
#define _BOOL 1
 #endif
#endif
*/
#include "MagicXSign_Type.h"
#include "MagicXSign_ErrCode.h"



/* 1. 기본 */
XSIGN_API int XSIGN_API_Init(void OUT **ppCtx);
XSIGN_API int XSIGN_API_Finish(void IN **ppCtx);
XSIGN_API int XSIGN_API_GetErrInfo(void IN *pCtx, int IN nAllocLen, char OUT *pszErrInfo);
XSIGN_API int XSIGN_API_GetInfo(void IN *pCtx, char OUT szVersion[12]);

/* 2. 바이너리 데이터 핸들 */
XSIGN_API int XSIGN_DSTK_BINSTR_Create(BINSTR OUT *pBinStr);
XSIGN_API int XSIGN_DSTK_BINSTR_Delete(BINSTR IN *pBinStr);
XSIGN_API int XSIGN_DSTK_BINSTR_SetData(unsigned char IN *pData, int IN nDataLen, BINSTR OUT *pBinStr);

/* 3. 인증서 처리 */
XSIGN_API int XSIGN_DSTK_CERT_Load(void IN *pCtx, BINSTR IN *pCert);
XSIGN_API int XSIGN_DSTK_CERT_Unload(void IN *pCtx);
XSIGN_API int XSIGN_DSTK_CERT_GetVersion(void IN *pCtx, int OUT *pVersion);
XSIGN_API int XSIGN_DSTK_CERT_GetSerialNum(void IN *pCtx, int IN nAllocLen, char OUT *pszSerialNum);
XSIGN_API int XSIGN_DSTK_CERT_GetSignatureAlgorithm(void IN *pCtx, int IN nAllocLen, char OUT *pszSignAlg);
XSIGN_API int XSIGN_DSTK_CERT_GetIssuerName(void IN *pCtx, int IN nAllocLen, char OUT *pszIssuerName);
XSIGN_API int XSIGN_DSTK_CERT_GetValidity(void IN *pCtx, char OUT szFrom[25], char OUT szTo[25]);
XSIGN_API int XSIGN_DSTK_CERT_GetSubjectName(void IN *pCtx, int IN nAllocLen, char OUT *pszSubjectName);
XSIGN_API int XSIGN_DSTK_CERT_GetPubKey(void IN *pCtx, int IN nAllocLen, char OUT szPubKeyAlg[50], char OUT *pszPubKey);
XSIGN_API int XSIGN_DSTK_CERT_GetPubKeyAlgorithm(void IN *pCtx, char OUT szPubKeyAlg[70]);
XSIGN_API int XSIGN_DSTK_CERT_GetKeyUsage(void IN *pCtx, int IN nAllocLen, char OUT *pszKeyUsage);
XSIGN_API int XSIGN_DSTK_CERT_GetCertPolicy(void IN *pCtx, int IN nAllocLen, char OUT *pszCertPolicy);
XSIGN_API int XSIGN_DSTK_CERT_GetCertPolicy_PolicyID(void IN *pCtx, int IN nAllocLen, char OUT *pszPolicyID);
XSIGN_API int XSIGN_DSTK_CERT_GetSubjectAltName(void IN *pCtx, int IN nAllocLen, char OUT *pszSubAltName);
XSIGN_API int XSIGN_DSTK_CERT_GetAuthKeyID(void IN *pCtx, int IN nAllocLen, char OUT *pszAKI);
XSIGN_API int XSIGN_DSTK_CERT_GetSubKeyID(void IN *pCtx, int IN nAllocLen, char OUT *pszSKI);
XSIGN_API int XSIGN_DSTK_CERT_GetCRLDP(void IN *pCtx, int IN nAllocLen, char OUT *pszCRLDP);
XSIGN_API int XSIGN_DSTK_CERT_GetAIA(void IN *pCtx, int IN nAllocLen, char OUT *pszAIA);
XSIGN_API int XSIGN_DSTK_CERT_GetSubjectAltName_IdentifyData_RealName(void IN *pCtx, int IN nAllocLen, char OUT *pszRealName);
								    
/* 4. 인증서 검증 */
XSIGN_API int XSIGN_DSTK_CERT_AddCACert(void IN *pCtx, BINSTR IN *pTrustedCert);

// 20121108-tamrin
// 인증서 검증 추가
XSIGN_API int XSIGN_DSTK_CERT_SetVerifyEnv(void IN *pCtx, int IN nRange);
XSIGN_API int XSIGN_DSTK_CERT_SimpleVerify(void IN *pCtx, BINSTR IN *pCert);


/* 5. 개인키 */
XSIGN_API int XSIGN_DSTK_PRIKEY_Encrypt(void IN *pCtx, int IN nSymAlg, char IN *pszPasswd, BINSTR IN *pPriKey, BINSTR OUT *pEncPriKey);
XSIGN_API int XSIGN_DSTK_PRIKEY_Decrypt(void IN *pCtx, char IN *pszPasswd, BINSTR IN *pEncPriKey, BINSTR OUT *pPriKey);
XSIGN_API int XSIGN_DSTK_PRIKEY_ChangePasswd(void IN *pCtx, char IN *pszOldPasswd, char IN *pszNewPasswd, BINSTR IN *pEncPriKey, BINSTR OUT *pNewPriKey);


/* 6. 암호 메시지 (CMS) */
XSIGN_API int XSIGN_DSTK_CMS_SignData(void IN *pCtx, int IN nOption, BINSTR IN *pCert, BINSTR IN *pPriKey, BINSTR IN *pTBSData, char IN *pszSignTime, BINSTR OUT *pSignedData);
XSIGN_API int XSIGN_DSTK_CMS_VerifyData(void IN *pCtx, int IN nOption, BINSTR IN *pSignedData, BINSTR INOUT *pData, int OUT *pSignerCertCnt);
XSIGN_API int XSIGN_DSTK_CMS_GetSignerCert(void IN *pCtx, int IN nIndex, BINSTR OUT *pSignerCert, char OUT szSignTime[20]);
XSIGN_API int XSIGN_DSTK_CMS_EncryptData(void IN *pCtx, int IN nOption, BINSTR IN *pCert, BINSTR IN *pTBEData, int IN nSymAlg, BINSTR OUT *pEnvelopedData);
XSIGN_API int XSIGN_DSTK_CMS_DecryptData(void IN *pCtx, BINSTR IN *pCert, BINSTR IN *pPriKey, BINSTR IN *pEnvelopedData, BINSTR OUT *pData);
XSIGN_API int XSIGN_DSTK_CMS_SignAndEncData(void IN *pCtx, int IN nOption, BINSTR IN *pCert, BINSTR IN *pPriKey, BINSTR IN *pRecCert, BINSTR IN *pData, int IN nSymAlg, BINSTR OUT *pSignedAndEnvlopedData);
XSIGN_API int XSIGN_DSTK_CMS_VerifyAndDecData(void IN *pCtx, int IN nOption, BINSTR IN *pCert, BINSTR IN *pPriKey, BINSTR IN *pSignedAndEnvlopedData, BINSTR OUT *pData, BINSTR OUT *pSignerCert);


/* 7. 본인확인 (VID) */
XSIGN_API int XSIGN_DSTK_VID_GetRandomFromPriKey(void IN *pCtx, BINSTR IN *pPriKey, BINSTR OUT *pRandom);
XSIGN_API int XSIGN_DSTK_VID_Verify(void IN *pCtx, BINSTR IN *pCert, BINSTR IN *pRandom, char IN *pszIDN);



/* 10. 개인정보 이동 */
XSIGN_API int XSIGN_DSTK_PFX_Export(void IN *pCtx, int IN nOption, char IN *pszPasswd, BINSTR IN *pCert, BINSTR IN *pPriKey, BINSTR OUT *pPFX);
XSIGN_API int XSIGN_DSTK_PFX_Import(void IN *pCtx, char IN *pszPasswd, BINSTR IN *pPFX, BINSTR OUT *pCert, BINSTR OUT *pPriKey, BINSTR OUT *pCaPubs);


/* 13. 암호 알고리즘 */
XSIGN_API int XSIGN_DSTK_CRYPT_SetRSAVersion(void IN *pCtx, int IN nRSAVersion); 
XSIGN_API int XSIGN_DSTK_CRYPT_SetPaddingType(void IN *pCtx, int IN nPaddingType); 
XSIGN_API int XSIGN_DSTK_CRYPT_GenKeyPair(void IN *pCtx, int IN nAlg, BINSTR OUT *pPriKey, BINSTR OUT *pPubKey) ;
XSIGN_API int XSIGN_DSTK_CRYPT_GenRandom(void IN *pCtx, int IN nLen, BINSTR OUT *pRandom);
XSIGN_API int XSIGN_DSTK_CRYPT_GenKeyAndIV(void IN *pCtx, int IN nSymAlg);
XSIGN_API int XSIGN_DSTK_CRYPT_SetKeyAndIV(void IN *pCtx, int IN nSymAlg, BINSTR IN *pKey, BINSTR IN *pIV);
XSIGN_API int XSIGN_DSTK_CRYPT_GetKeyAndIV(void IN *pCtx, int IN *pSymAlg, BINSTR OUT *pKey, BINSTR OUT *pIV);
XSIGN_API int XSIGN_DSTK_CRYPT_Encrypt(void IN *pCtx, BINSTR IN *pPlainText, BINSTR OUT *pCipherText);
XSIGN_API int XSIGN_DSTK_CRYPT_Decrypt(void IN *pCtx, BINSTR IN *pCipherText, BINSTR OUT *pPlainText);
XSIGN_API int XSIGN_DSTK_CRYPT_Sign(void IN *pCtx, BINSTR IN *pPubKey, BINSTR IN *pPriKey, int IN nHashAlg, BINSTR IN *pTBSData, BINSTR OUT *pSignature);
XSIGN_API int XSIGN_DSTK_CRYPT_Verify(void IN *pCtx, BINSTR IN *pPubKey, int IN nHashAlg, BINSTR IN *pData, BINSTR IN *pSignature);
XSIGN_API int XSIGN_DSTK_CRYPT_AsymEncrypt(void IN *pCtx, int IN nKeyType, BINSTR IN *pKey, BINSTR IN *pTBEData, BINSTR OUT *pEncData);
XSIGN_API int XSIGN_DSTK_CRYPT_AsymDecrypt(void IN *pCtx, int IN nKeyType, BINSTR IN *pKey, BINSTR IN *pEncData, BINSTR OUT *pData);
XSIGN_API int XSIGN_DSTK_CRYPT_Hash(void IN *pCtx, int IN nHashAlg, BINSTR IN *pTBHData, BINSTR OUT *pDigest);
XSIGN_API int XSIGN_DSTK_CRYPT_GenMAC(void IN *pCtx, int IN nMACAlg, char IN *pszPasswd, BINSTR IN *pTBMData, BINSTR OUT *pMAC);
XSIGN_API int XSIGN_DSTK_CRYPT_VerifyMAC(void IN *pCtx, int IN nMACAlg, char IN *pszPasswd, BINSTR IN *pData, BINSTR IN *pMAC);

/* 14. BASE64 */
XSIGN_API int XSIGN_DSTK_BASE64_Encode(void IN *pCtx, BINSTR IN *pData, BINSTR OUT *pEncData);
XSIGN_API int XSIGN_DSTK_BASE64_Decode(void IN *pCtx, BINSTR IN *pEncData, BINSTR OUT *pData);


/* 19. 유틸 */
XSIGN_API int XSIGN_DSTK_UTIL_AddObject(void IN *pCtx, BINSTR IN *pObj, BINSTR OUT *pObjs);
XSIGN_API int XSIGN_DSTK_UTIL_GetObjectCount(void IN *pCtx, BINSTR IN *pObjs, int OUT *pCnt);
XSIGN_API int XSIGN_DSTK_UTIL_GetObject(void IN *pCtx, BINSTR IN *pObjs, int IN nIndex, BINSTR OUT *pObj);


/* 20. File유틸 */
XSIGN_API int XSIGN_DSTK_MEDIA_UseKeyChain(void IN *pCtx, IN bool bStat);
XSIGN_API int XSIGN_DSTK_MEDIA_ReadFile(void IN *pCtx, IN char *pszFilename, BINSTR OUT *pData);
XSIGN_API int XSIGN_DSTK_MEDIA_WriteFile(void IN *pCtx, IN char *pszFilename,  BINSTR IN *pData);
XSIGN_API int XSIGN_DSTK_MEDIA_DeleteFile(void IN *pCtx, IN char *pszFilename);
XSIGN_API int XSIGN_DSTK_MEDIA_DISK_ReadCert(void IN *pCtx, char IN *pszPath, BINSTR OUT *pCert);
XSIGN_API int XSIGN_DSTK_MEDIA_DISK_ReadPriKey(void IN *pCtx, char IN *pszPath, char IN *pszPasswd, BINSTR OUT *pPriKey);

XSIGN_API int XSIGN_DSTK_MEDIA_ReadCertType(void IN *pCtx, IN int nCertIndex, IN int nOption,OUT char *szCertType);
XSIGN_API int XSIGN_DSTK_MEDIA_RootCertLoad(void IN *pCtx,int IN iPkiType);
XSIGN_API int XSIGN_DSTK_MEDIA_RootCertUnload(void IN *pCtx);
XSIGN_API int XSIGN_DSTK_MEDIA_RootCertGetCertCount(void IN *pCtx, OUT int *pnCertCount);
XSIGN_API int XSIGN_DSTK_MEDIA_RootCertReadCert(void IN *pCtx, IN int nCertIndex,  IN int nKeyType, OUT BINSTR *pbsCert);

XSIGN_API int XSIGN_DSTK_MEDIA_Load(void IN *pCtx, IN int nPKIType, IN int nCertType, IN int nKeyType);
XSIGN_API int XSIGN_DSTK_MEDIA_Reload(void IN *pCtx);
XSIGN_API int XSIGN_DSTK_MEDIA_Unload(void IN *pCtx);
XSIGN_API int XSIGN_DSTK_MEDIA_GetCertCount(void IN *pCtx,OUT int *pnCertCount);
XSIGN_API int XSIGN_DSTK_MEDIA_ReadCert(void IN *pCtx, IN int nCertIndex,  IN int nKeyType, OUT BINSTR *pbsCert);
XSIGN_API int XSIGN_DSTK_MEDIA_ReadPriKey(void IN *pCtx, IN int nCertIndex,  IN int nKeyType, char *pszPasswd, OUT BINSTR *pbsKey);
XSIGN_API int XSIGN_DSTK_MEDIA_ReadEncPriKey(void IN *pCtx, IN int nCertIndex,  IN int nKeyType, OUT BINSTR *pbsKey);
XSIGN_API int XSIGN_DSTK_MEDIA_DeleteCert(void IN *pCtx, IN int nCertIndex);
XSIGN_API int XSIGN_DSTK_MEDIA_WriteCertAndPriKey(void IN *pCtx,int nSymAlg, IN char* pszPasswd, IN BINSTR hbsCert, IN BINSTR hbsPriKey);
XSIGN_API int XSIGN_DSTK_MEDIA_WriteCertAndEndPriKey(void IN *pCtx, IN BINSTR hbsCert, IN BINSTR hbsEncPriKey);
XSIGN_API int XSIGN_DSTK_MEDIA_WriteCertAndEndPriKeyWithKMCert(void IN *pCtx, IN BINSTR hbsCert, IN BINSTR hbsEncPriKey, IN BINSTR hbsKMCert, IN BINSTR hbsEncKMPriKey);
XSIGN_API int XSIGN_DSTK_MEDIA_WritePfx(void IN *pCtx,IN char* pszPasswd, IN BINSTR hbsPfx, OUT BINSTR *hbsSignCert, OUT BINSTR *hbsSignPri, OUT BINSTR *hbsKMCert, OUT BINSTR *hbsKMPri);
XSIGN_API int XSIGN_DSTK_MEDIA_ChangePriKeyPasswd(void IN *pCtx, IN int nCertIndex, IN char* pszOldPasswd, IN char* pszNewPasswd);
XSIGN_API int XSIGN_DSTK_MEDIA_CertVerify(void IN *pCtx, IN int nCertIndex);
XSIGN_API int XSIGN_DSTK_MEDIA_CheckVID(void IN *pCtx, IN int nCertIndex, IN char *szPassword,IN char *szVID);
XSIGN_API int XSIGN_DSTK_MEDIA_SignDataEx(void IN *pCtx, IN int nCertIndex, IN int nSignType, IN char *szPassword,IN BINSTR hbsTBSData,OUT BINSTR *hbsSignedData);
XSIGN_API int XSIGN_DSTK_MEDIA_SignData(void IN *pCtx, IN int nCertIndex, IN char *szPassword,IN BINSTR hbsTBSData,OUT BINSTR *hbsSignedData);
XSIGN_API int XSIGN_DSTK_MEDIA_CryptSign(void IN *pCtx, IN int nCertIndex, IN char *szPassword,IN BINSTR hbsTBSData,OUT BINSTR *hbsSign);
XSIGN_API int XSIGN_DSTK_MEDIA_ResetKeyChain(void IN *pCtx);



// 인증서 발급
XSIGN_API int XSIGN_CERTCMP_IssueCert(void IN *pCtx,int iCAType, const char *szIP,int iPort,char *szPass,const char *szIssueData1, const char* szIssueData2, BINSTR *hbsSignCert,BINSTR *hbsSignKey,BINSTR *hbsKMCert,BINSTR *hbsKMKey);
// 인증서 갱신
XSIGN_API int XSIGN_CERTCMP_UpdateCert(void IN *pCtx,int iCAType, const char *szIP,int iPort,char *szPass,BINSTR *hbsSignCert,BINSTR *hbsSignKey,BINSTR *hbsKMCert,BINSTR *hbsKMKey);
// 인증서 효력정지
XSIGN_API int XSIGN_CERTCMP_HoldCert(void IN *pCtx,int iCAType, const char *szIP,int iPort,char *szPass,BINSTR *hbsSignCert,BINSTR *hbsSignKey,BINSTR *hbsKMCert,BINSTR *hbsKMKey);
// 인증서 페기
XSIGN_API int XSIGN_CERTCMP_RevokeCert(void IN *pCtx,int iCAType, const char *szIP,int iPort,char *szPass,BINSTR *hbsSignCert,BINSTR *hbsSignKey,BINSTR *hbsKMCert,BINSTR *hbsKMKey);





#endif /* !defined(___DSTOOLKIT_IPHONE_MAIN_H___) */

