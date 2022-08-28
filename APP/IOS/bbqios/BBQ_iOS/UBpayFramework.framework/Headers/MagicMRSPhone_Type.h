#ifndef _MAGICMRSPHONE_TYPE_H
#define _MAGICMRSPHONE_TYPE_H

#define MAGICMRSPHONE_SERVICETYPE_EXPORT	10000			// ������ ��������
#define MAGICMRSPHONE_SERVICETYPE_IMPORT	10001			// ������ ��������
#define MAGICMRSPHONE_SERVICETYPE_SIGNED	10002			// ���ڼ��� �ϱ�

typedef struct tagMagicMRSPhoneHostInfo
{
	char*	pszHostAddress;					// Phone G/W �ּ�
	int		nHostPort;						// Phone G/W ��Ʈ
}MAGICMRSPHONE_HOSTINFO, *PMAGICMRSPHONE_HOSTINFO;


typedef struct tagMagicMRSPhoneUserInfo
{
	char*	pszPhoneNumber;					// �ܸ��� ������ȣ
	char*	pszMinNumber;					// �ܸ��� ������ȣ
	int		nServiceType;					// ���� Ÿ��
	char*	pszIdentifier;					// Application �ĺ���ȣ
}MAGICMRSPHONE_USERINFO, *PMAGICMRSPHONE_USERINFO;


typedef struct tagMagicMRSPhoneServiceInfo
{
	MAGICMRSPHONE_HOSTINFO	hostInfo;					// Phone G/W �������� ����ü
	MAGICMRSPHONE_USERINFO	userInfo;					// ���� ����� ���� ����ü
}MAGICMRSPHONE_SERVICEINFO, *PMAGICMRSPHONE_SERVICEINFO;


typedef struct tagMagicMRSPhoneAppInfo
{
	char*			pszAppName;							// �̵� ���̺귯���� ����ϴ� ���ø����̼��� �̸�
	char*			pszAppVersion;					// �̵� ���̺귯���� ����ϴ� ���ø����̼��� ����
}MAGICMRSPHONE_APPHINFO, *PMAGICMRSPHONE_APPINFO;


typedef struct tagMagicMRSPhoneDeviceInfo
{
	char*			pszDeviceSerial;					// ��� �ø��� ��ȣ
	char*			pszOSName;							// ��� OS �̸�
	char*			pszOSVersion;						// ��� OS ����
	char*			pszPhoneNumber;						// ��� �޴��� ��ȣ
}MAGICMRSPHONE_DEVICEINFO, *PMAGICMRSPHONE_DEVICEINFO;


typedef struct tagMagicMRSPhoneAppHashInfo
{
	MAGICMRSPHONE_APPHINFO		appInfo;				// �̵� ���̺귯���� ����ϴ� ���ø����̼��� ����
	MAGICMRSPHONE_DEVICEINFO	deviceInfo;				// �̵� ���̺귯���� ����ϴ� ����� ����
}MAGICMRSPHONE_APPHASHINFO, *PMAGICMRSPHONE_APPHASHINFO;


typedef struct tagMagicMRSPhoneAuthCodeInfo
{
	int			nPcStatus;					// PC����(0:����, 1:������)
	char		szAuthCode[16];				// ������ȣ
	bool		bInputAuthCode;				// ������ȣ ��� ����
}MAGICMRSPHONE_AUTHCODEINFO, *PMAGICMRSPHONE_AUTHCODEINFO;


typedef struct tagMagicMRSPhoneServiceTypeInfo
{
	int			nServiceType;				// ���� Ÿ��(0:������ ��������, 1:������ ��������, 2:�����ϱ�)
}MAGICMRSPHONE_SERVICETYPEINFO, *PMAGICMRSPHONE_SERVICETYPEINFO;


typedef struct tagMagicMRSPhoneCertificate
{
	unsigned char*	pSignCert;				// ����� ������ ����
	unsigned int	nSignCertSize;			// ����� ������ ���� ������
	unsigned char*	pSignPri;				// ����� ����Ű ����
	unsigned int	nSignPriSize;			// ����� ������ ���� ������
	unsigned char*	pKmCert;				// ��ȣȭ�� ������ ����
	unsigned int	nKmCertSize;			// ��ȣȭ�� ������ ������
	unsigned char*	pKmPri;					// ��ȣȭ�� ����Ű ����
	unsigned int	nKmPriSize;				// ��ȣȭ�� ����Ű ���� ������
	int				nCertUsage;				// �����:USAGE_SIGN, ��ȣȭ��:USAGE_KM, ���:USAGE_ALL
}MAGICMRSPHONE_CERTIFICATE, *PMAGICMRSPHONE_CERTIFICATE;


typedef struct tagMagicMRSPhoneVerifyCertificate
{
	MAGICMRSPHONE_HOSTINFO	hostInfo;				// Phone G/W �������� ����ü
	char*					pszPhoneNumber;			// �ܸ��� ������ȣ
	char*					pszMinNumber;			// �ܸ��� ������ȣ
	unsigned char*			pCertificate;			// ������ ����
	unsigned int			nCertificateSize;		// ������ ���� ������
	char*					pszIdentifier;			// Application �ĺ���ȣ
	int						nCertStatus;			// ������ ���(0:��ȿ, 1:����, 2:ȿ������)
}MAGICMRSPHONE_VERIFYCERTIFICATE, *PMAGICMRSPHONE_VERIFYCERTIFICATE;

#endif //_CERTMOVEWIFI_TYPE_H