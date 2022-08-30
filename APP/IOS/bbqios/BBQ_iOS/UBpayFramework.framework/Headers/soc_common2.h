#ifndef __SOC_COMMON_H__
#define __SOC_COMMON_H__
#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/stat.h>

#define C_LISTEN_QNO       			5
#define RET_SOCK_FAIL				-1
#define RET_OK						1
#define TRUE						1
#define FALSE						0

#define C_SLEEP_CNT					(gnTimeOutSec * 10)
#define C_SLEEP_TIME				100

#ifdef __cplusplus
extern "C" {
#endif

//extern int	gnAlarm;
extern int  ServerCreatConnection2(int nPort);
extern int  ServerWaitConnection2(int nSocketId, char* pszClientIp);
extern int  SocketSetting2(int nSocketId);
extern long	SocketRecvBlock2( int nSocId, char* pszBuf, long lLen );
extern long	SocketSendBlock2( int nSocId, char* pszBuf, long lLen );
extern void SocketClose2(int nSockId);
extern int  ClientCreatConnection2(char* ipaddr, int nPort);
//extern int Send(int nSocket, char* buf, int len, int flags);
extern int SendWait2(int nSocket, char* buf, int len, int flags);
extern int RecvWait2(int nSockId, void* pBuffer, int nRecvLen, int flags);
extern void SLEEP2(int nMillSec);
extern void SocSetTimeOut2(int nSec);
	int     ClientCreatConnection_timeout(char* ipaddr, int nPort, int sec);

#ifdef __cplusplus
}
#endif


#endif
