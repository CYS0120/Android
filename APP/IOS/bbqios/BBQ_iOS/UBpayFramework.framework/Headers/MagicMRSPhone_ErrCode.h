#ifndef	_MAGICMRSPHONE_ERRCODE_H
#define	_MAGICMRSPHONE_ERRCODE_H

#define	MAGICMRSPHONE_OK					0	// ����
#define	MAGICMRSPHONE_FAIL					-1	// ����

#define	MAGICMRSPHONE_INVALID_INPUT			101	// INPUT ���ڰ� �ǹٸ��� ����
#define	MAGICMRSPHONE_INVALID_OUTPUT		102	// OUTPUT ���ڰ� NULL�� �ƴ�
#define	MAGICMRSPHONE_ALLOC_MEMORY			103	// �޸� �Ҵ� ����
#define	MAGICMRSPHONE_STOPAPI				104	// StopAPI�� ���� ����
#define	MAGICMRSPHONE_ALREADY_INITIALIZED	105	// API�� �̹� �ʱ�ȭ �Ǿ� ����
#define	MAGICMRSPHONE_NOT_INITIALIZED		106	// API�� �ʱ�ȭ�� �ȵ�
#define	MAGICMRSPHONE_TIMEOUT				107	// ���� ���� Timeout
#define	MAGICMRSPHONE_NOT_CONNECT			201	// ���� ���� ����
#define	MAGICMRSPHONE_NOT_SEND				202	// ���� �۽� ����
#define	MAGICMRSPHONE_NOT_RECV				203	// ���� ���� ����
#define	MAGICMRSPHONE_INPUT_ASN1			301	// ANS1 Input ����
#define	MAGICMRSPHONE_OUTPUT_ASN1			302	// ANS1 Output ����
#define	MAGICMRSPHONE_INVALID_OPCODE		303	// ��ȿ���� ���� OPCODE
#define	MAGICMRSPHONE_INVALID_HASH			304	// Hash ���� ����
#define MAGICMRSPHONE_NOT_EXIST_SERVER_ERR	305	// ���� �����ڵ尡 ����
#define MAGICMRSPHONE_PARSING_SERVER_ERR	306 // ���� �����ڵ忡 �ش��ϴ� Client �������� ����
#define MAGICMRSPHONE_INVALID_APP_HASH		307 // ���ø����̼� �ؽ����� �ٸ�
#define MAGICMRSPHONE_EMPTY_APP_HASH		308 // ���ø����̼� �ؽ����� ����(MagicMRSPhone_SetAppValue()�� ȣ���ؾ� ��)
#define MAGICMRSPHONE_SEND_QH9000			309 // OPCODE QH9000�� ������ �ð�(15��) ���� ���ŵ��� �ʾҽ��ϴ�.
#define MAGICMRSPHONE_INVALID_SVC_TYPE		310 // ��û�� ���� Ÿ���� �ùٸ��� �ʽ��ϴ�.
#define MAGICMRSPHONE_INVALID_APPID			311 // appIdentifier�� �ùٸ��� �ʽ��ϴ�.
#define MAGICMRSPHONE_READ_MODULE			312 // �̵���� ���̳ʸ� �������� ����
#define	MAGICMRSPHONE_DSTOOLKIT				401	// DSToolKit ����
#define MAGICMRSPHONE_TM					402	// TrustM ����

#define	MAGICMRSPHONE_NOT_SUPORTED			999	// �������� ����

#endif	// _CERTMOVEWIFI_ERRCODE_H
