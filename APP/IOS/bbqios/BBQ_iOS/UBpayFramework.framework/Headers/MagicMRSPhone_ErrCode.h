#ifndef	_MAGICMRSPHONE_ERRCODE_H
#define	_MAGICMRSPHONE_ERRCODE_H

#define	MAGICMRSPHONE_OK					0	// 정상
#define	MAGICMRSPHONE_FAIL					-1	// 실패

#define	MAGICMRSPHONE_INVALID_INPUT			101	// INPUT 인자가 옳바르지 않음
#define	MAGICMRSPHONE_INVALID_OUTPUT		102	// OUTPUT 인자가 NULL이 아님
#define	MAGICMRSPHONE_ALLOC_MEMORY			103	// 메모리 할당 실패
#define	MAGICMRSPHONE_STOPAPI				104	// StopAPI에 의한 종료
#define	MAGICMRSPHONE_ALREADY_INITIALIZED	105	// API가 이미 초기화 되어 있음
#define	MAGICMRSPHONE_NOT_INITIALIZED		106	// API가 초기화가 안됨
#define	MAGICMRSPHONE_TIMEOUT				107	// 서버 응답 Timeout
#define	MAGICMRSPHONE_NOT_CONNECT			201	// 서버 접속 실패
#define	MAGICMRSPHONE_NOT_SEND				202	// 서버 송신 실패
#define	MAGICMRSPHONE_NOT_RECV				203	// 서버 수신 실패
#define	MAGICMRSPHONE_INPUT_ASN1			301	// ANS1 Input 실패
#define	MAGICMRSPHONE_OUTPUT_ASN1			302	// ANS1 Output 실패
#define	MAGICMRSPHONE_INVALID_OPCODE		303	// 유효하지 않은 OPCODE
#define	MAGICMRSPHONE_INVALID_HASH			304	// Hash 검증 실패
#define MAGICMRSPHONE_NOT_EXIST_SERVER_ERR	305	// 서버 에러코드가 없음
#define MAGICMRSPHONE_PARSING_SERVER_ERR	306 // 서버 에러코드에 해당하는 Client 에러값이 없음
#define MAGICMRSPHONE_INVALID_APP_HASH		307 // 어플리케이션 해쉬값이 다름
#define MAGICMRSPHONE_EMPTY_APP_HASH		308 // 어플리케이션 해쉬값이 없음(MagicMRSPhone_SetAppValue()를 호출해야 함)
#define MAGICMRSPHONE_SEND_QH9000			309 // OPCODE QH9000이 정해진 시간(15초) 내에 수신되지 않았습니다.
#define MAGICMRSPHONE_INVALID_SVC_TYPE		310 // 요청한 서비스 타입이 올바르지 않습니다.
#define MAGICMRSPHONE_INVALID_APPID			311 // appIdentifier가 올바르지 않습니다.
#define MAGICMRSPHONE_READ_MODULE			312 // 이동모듈 바이너리 가져오기 실패
#define	MAGICMRSPHONE_DSTOOLKIT				401	// DSToolKit 에러
#define MAGICMRSPHONE_TM					402	// TrustM 에러

#define	MAGICMRSPHONE_NOT_SUPORTED			999	// 지원하지 않음

#endif	// _CERTMOVEWIFI_ERRCODE_H
