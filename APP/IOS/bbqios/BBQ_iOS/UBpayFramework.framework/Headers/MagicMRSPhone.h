#ifndef _MAGICMRSPHONE_H
#define _MAGICMRSPHONE_H

#include "MagicMRSPhone_Type.h"
#include "MagicMRSPhone_ErrCode.h"

#if defined(WIN32)
#	if defined(MAGICMRSPHONE_EXPORTS)
#		define MAGICMRSPHONE_API extern "C" __declspec(dllexport)
#	elif defined(MAGICMRSPHONE_IMPORTS)
#		ifdef __cplusplus
#			define MAGICMRSPHONE_API extern "C" __declspec(dllimport)
#		else
#			define MAGICMRSPHONE_API __declspec(dllimport) 
#	    endif
#   else
#		ifdef __cplusplus
#			define MAGICMRSPHONE_API extern "C"
#		else
#			define MAGICMRSPHONE_API extern 
#		endif
#	endif
#else
#	ifdef __cplusplus
#		define MAGICMRSPHONE_API extern "C"
#	else
#		define MAGICMRSPHONE_API extern 
#	endif
#endif


MAGICMRSPHONE_API int MagicMRSPhone_Init( void** ppCtx );
MAGICMRSPHONE_API void MagicMRSPhone_UnInit( void** ppCtx );
MAGICMRSPHONE_API int MagicMRSPhone_GetVersion( char szVersion[12] );
MAGICMRSPHONE_API int MagicMRSPhone_SetNetwork( void* pCtx, int nNetworkType );
MAGICMRSPHONE_API int MagicMRSPhone_ReadyMove( void* pCtx, MAGICMRSPHONE_SERVICEINFO* pServiceInfo );
MAGICMRSPHONE_API int MagicMRSPhone_IsPrintAuthCode( void* pCtx, MAGICMRSPHONE_AUTHCODEINFO* pAuthCodeInfo );
MAGICMRSPHONE_API int MagicMRSPhone_WhatKindOfService( void* pCtx, MAGICMRSPHONE_SERVICETYPEINFO* pServiceTypeInfo );
MAGICMRSPHONE_API int MagicMRSPhone_ImportCertificate( void* pCtx, MAGICMRSPHONE_CERTIFICATE* pCertificate );
MAGICMRSPHONE_API int MagicMRSPhone_ExportCertificate( void* pCtx, MAGICMRSPHONE_CERTIFICATE* pCertificate );
MAGICMRSPHONE_API int MagicMRSPhone_VerifyCertificate( void* pCtx, MAGICMRSPHONE_VERIFYCERTIFICATE* pVerifyCertificate );
MAGICMRSPHONE_API void MagicMRSPhone_StopAPI( void* pCtx, int nTimeout );

#endif	// _MAGICMRSPHONE_H