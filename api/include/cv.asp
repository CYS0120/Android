<% ' response.addHeader "P3P","CP=""IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT""" %>
<% Response.AddHeader "P3P", "CP=NOI CURa ADMa DEVa TAIa OUR DELa BUS IND PHY ONL UNI COM NAV INT DEM PRE" %>
<%
    Const DEV_PAYCO_CLIENT_ID = "ZBPyWCXovlNQn0INhjk0"              'PAYCO Client_id 개발용
    Const DEV_PAYCO_CLIENT_SECRET = "sQryLFHyYleLbtVPUDxOYX5Q"      'PAYCO Client_Secret 개발용

    Const REAL_PAYCO_CLIENT_ID = "0Cnas_vcG_xqR2lVMkf5"             'PAYCO Client_id 운영용
    Const REAL_PAYCO_CLIENT_SECRET = "AfngwONqc1uMjiNNCsaLZOyb"     'PAYCO Client_Secret 운영용

    Const DEV_PAYCO_AUTH_URL = "https://alpha-id.bbq.co.kr"
    Const DEV_PAYCO_MEMBERSHIP_URL = "https://alpha-api-membership.payco.com"

    Const REAL_PAYCO_AUTH_URL = "https://id.bbq.co.kr"
    Const REAL_PAYCO_MEMBERSHIP_URL = "https://api-membership.payco.com"

    Const DEV_BBQ_MAIN_URL = "http://bbq.fuzewire.com/"
    Const DEV_BBQ_MOBILE_URL = "http://bbq.fuzewire.com:8010/"
    Const DEV_BBQMALL_URL = "http://bbqmall.fuzewire.com"

	Const REAL_COOP_API_URL = "https://authapi.inumber.co.kr/AuthUse"
	Const DEV_COOP_API_URL = "http://test.authapi.inumber.co.kr:9999/AuthUse"

    Const PAYCO_MEMBERSHIP_COMPANYCODE = "C10007"
    Const PAYCO_MEMBERSHIP_MERCHANTCODE = "M000162"

    Dim PAYCO_CLIENT_ID, PAYCO_CLIENT_SECRET, PAYCO_AUTH_URL, PAYCO_MEMBERSHIP_URL

	if G2_SITE_MODE = "production" then
		PAYCO_CLIENT_ID = REAL_PAYCO_CLIENT_ID
		PAYCO_CLIENT_SECRET = REAL_PAYCO_CLIENT_SECRET

		PAYCO_AUTH_URL = REAL_PAYCO_AUTH_URL
		PAYCO_MEMBERSHIP_URL = REAL_PAYCO_MEMBERSHIP_URL
		COOP_API_URL = REAL_COOP_API_URL
	else ' payco 테스트 세팅
		PAYCO_CLIENT_ID = DEV_PAYCO_CLIENT_ID
		PAYCO_CLIENT_SECRET = DEV_PAYCO_CLIENT_SECRET

	    PAYCO_AUTH_URL = DEV_PAYCO_AUTH_URL
		PAYCO_MEMBERSHIP_URL = DEV_PAYCO_MEMBERSHIP_URL
		COOP_API_URL = DEV_COOP_API_URL
	end if 

    Dim LoginUserName, LoginUserIdNo

'    Dim BBQ_MAIN_URL : BBQ_MAIN_URL = REAL_BBQ_MAIN_URL
'    Dim BBQ_MOBILE_URL : BBQ_MOBILE_URL = REAL_BBQ_MOBILE_URL
'    Dim BBQMALL_URL : BBQMALL_URL = REAL_BBQMALL_URL

' ======================================================================
' 다날정보
' ======================================================================
'Const DANAL_CPID = "A010002002"
'Const DANAL_PWD = "bbbbb"
'Const DANAL_ITEMCODE = "1270000000"
' Const DANAL_CPID = "9010S32463"
' Const DANAL_PWD = "1x7kwDpk0d"
' Const DANAL_ITEMCODE = "22S0dj0005"

 Const DANAL_CPID_OLD = "9010S32463"
 Const DANAL_PWD_OLD = "1x7kwDpk0d"

 Dim DANAL_CPID : DANAL_CPID = ""
 Dim DANAL_PWD : DANAL_PWD = "2RiJCWD3Ap"
 Dim DANAL_ITEMCODE : DANAL_ITEMCODE = "22S0dj0005"

' 다날 카드 결제 정보 // 테스트
'Const DANAL_CPID_CARD = "9810030929"
'Const DANAL_PWD_CARD = "20ad459ab1ad2f6e541929d50d24765abb05850094a9629041bebb726814625d"
' 다날 카드 결제 정보 // 실결제
' Const DANAL_CPID_CARD = ""
 Const DANAL_PWD_CARD = "fdc0684f239b3f44038760f73788c147e235e90b8ef16b0855d8c0288316213f"

' 치킨대학 다날 카드 결제 정보
Const CKUNIV_DANAL_CPID_CARD = "9010S32463"
Const CKUNIV_DANAL_SUBCPID_CARD = "S0VMF02110"
Const CKUNIV_DANAL_PWD_CARD = "fdc0684f239b3f44038760f73788c147e235e90b8ef16b0855d8c0288316213f"
Const CANCEL_CKUNIV_DOMAIN	= "http://www.ckuniversity.com"

Const PAYCO_BRANDCODE_BBQ = "B0000022"
Const PAYCO_MERCHANTCODE_BBQ = "M000162"
Const PAYCO_BRANDCODE_CHICKEN_VIL = "B0000023"
Const PAYCO_MERCHANTCODE_CHICKEN_VIL = "M000164"
Const PAYCO_BRANDCODE_BABEQUE = "B0000024"
Const PAYCO_MERCHANTCODE_BABEQUE = "M000165"
Const PAYCO_BRANDCODE_U9 = "B0000025"
Const PAYCO_MERCHANTCODE_U9 = "M000166"
Const PAYCO_BRANDCODE_ALLTOKK = "B0000026"
Const PAYCO_MERCHANTCODE_ALLTOKK = "M000167"
Const PAYCO_BRANDCODE_SOSIN = "B0000027"
Const PAYCO_MERCHANTCODE_SOSIN = "M000171"
Const PAYCO_BRANDCODE_WATAMI = "B0000028"
Const PAYCO_MERCHANTCODE_WATAMI = "M000169"
Const PAYCO_BRANDCODE_JIBBAP = "B0000029"
Const PAYCO_MERCHANTCODE_JIBBAP = "M000170"
Const PAYCO_BRANDCODE_CHICKEN_UNI = "B0000030"
Const PAYCO_MERCHANTCODE_CHICKEN_UNI = "M000168"

Const COOP_COMPANY_CODE = "BQ01"
Const COOP_AUTH_KEY = "g9PJGmeh6BaSfprJx1xkAQ"

Const GOOGLE_MAP_API_KEY = "AIzaSyAySOVfqHAHc71tG7grwX55uLdpWClDrsk"
Const JUSO_API_KEY = "U01TX0FVVEgyMDIwMDcxNDExMTY1NDEwOTk1MDg="
Const JUSO_API_KEY_XY = "U01TX0FVVEgyMDIwMTAwNjExNDc1MDExMDI1OTk="

'	Create By Goldman
'	========================================================================================
	Const SITE_BRAND_CODE_BBQ		= "01"
	Const SITE_BRAND_CODE_ALLTOKK	= "04"
	Const SITE_BRAND_CODE_CHICKEN_VIL = "06"
	Const SITE_BRAND_CODE_CHICKEN_VILA = "61"	'명가식
	Const SITE_BRAND_CODE_CHICKEN_VILB = "62"	'철판닭갈비
	Const SITE_BRAND_CODE_CHICKEN_VILC = "63"	'도리마루
	Const SITE_BRAND_CODE_BABEQUE	= "08"
	Const SITE_BRAND_CODE_UNINE		= "10"
	Const SITE_BRAND_CODE_WATAMI	= "23"
	Const SITE_BRAND_CODE_SOSIN		= "11"
	Const SITE_BRAND_CODE_HAPPY		= "32"
	Const SITE_BRAND_CODE_CHICKEN_UNI	= "33"
	Const SITE_BRAND_CODE_START		= "34"
	Const SITE_BRAND_CODE_GLOBAL	= "35"
	Const SITE_BRAND_CODE_GROUP		= "36"

	Const SITE_DOMAINURL_BBQ		= "https://www.bbq.co.kr"		'BBQ치킨
	Const SITE_DOMAINURL_HAPPY		= "NO"	'행복한집밥
	Const SITE_DOMAINURL_CKPLACE	= "https://www.ckpalace.co.kr"		'닭익는마을
	Const SITE_DOMAINURL_BARBECUE	= "https://www.bbqbarbecue.co.kr"		'참숯바베큐
	Const SITE_DOMAINURL_UNINE		= "http://www.ukuya.co.kr"		'우쿠야
	Const SITE_DOMAINURL_ALLTOKK	= "http://www.alltokk.co.kr"		'올떡
	Const SITE_DOMAINURL_BELIEF		= "https://www.soshin.co.kr"		'소신275°C
	Const SITE_DOMAINURL_WATAMI		= "http://www.watamikorea.com"		'와타미
	Const SITE_DOMAINURL_CHICKEN_UNI	= "http://www.ckuniversity.com"		'치킨대학
	Const SITE_DOMAINURL_START		= "https://www.bbqchangup.co.kr:446"		'창업센터
	Const SITE_DOMAINURL_GLOBAL		= "http://www.bbqglobal.com"		'제너시스글로벌
	Const SITE_DOMAINURL_GROUP		= "http://www.genesiskorea.co.kr"		'제너시스그룹
	Const SITE_DOMAINURL_BBQMALL	= "http://mall.bbq.co.kr"		'비비큐몰

	Const MSITE_DOMAINURL_BBQ		= "https://m.bbq.co.kr"		'BBQ치킨
	Const MSITE_DOMAINURL_HAPPY		= "NO"	'행복한집밥
	Const MSITE_DOMAINURL_CKPLACE	= "http://m.ckpalace.co.kr"		'닭익는마을
	Const MSITE_DOMAINURL_BARBECUE	= "http://m.bbqbarbecue.co.kr"		'참숯바베큐
	Const MSITE_DOMAINURL_UNINE		= "http://m.ukuya.co.kr"		'우쿠야
	Const MSITE_DOMAINURL_ALLTOKK	= "http://m.alltokk.co.kr"		'올떡
	Const MSITE_DOMAINURL_BELIEF	= "http://m.soshin.co.kr"		'소신275°C
	Const MSITE_DOMAINURL_WATAMI	= "http://www.watamikorea.com/m/"		'와타미
	Const MSITE_DOMAINURL_CHICKEN_UNI	= "http://m.ckuniversity.com"		'치킨대학
	Const MSITE_DOMAINURL_START		= "https://m.bbqchangup.co.kr:446"		'창업센터
	Const MSITE_DOMAINURL_GLOBAL	= "https://www.bbqglobal.com"		'제너시스글로벌	모바일페이지 없음
	Const MSITE_DOMAINURL_GROUP		= "http://m.genesiskorea.co.kr"		'제너시스그룹
	Const MSITE_DOMAINURL_BBQMALL	= "http://mall.bbq.co.kr"		'비비큐몰

	Const FILE_SERVERURL	= "https://img.bbq.co.kr:449"

	BBQHOME_DB	= "BBQ_HOME"
	TESTMODE	= "N"			'테스트용
'	========================================================================================

'고객센터 전화번호 (2021.10 더페이)
SERVICE_CENTER_TEL = "1588-9282" '080-3436-0507에서 변경 
%>