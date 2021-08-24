<!--#include virtual="/api/include/utf8.asp"-->
<%
	'Option Explicit
	'-----------------------------------------------------------------------------
	' SGPAY 연동 환경설정 페이지 ( ASP )
	' sgpay.inc.asp
	' 2019-12-10	Sewoni31™
	'
	' ASP 에서는 JSON 형태를 지원하지 않기 때문에 하단 파일(json/JSON_2.0.4.asp)을 include 합니다.
	'-----------------------------------------------------------------------------
%>
<!--#include file="sgpay.util.asp"-->
<!--#include file="config/aspJSON1.17.asp"-->
<!--#include file="config/KISA_SHA256.asp" -->
<!--#include file="config/KISA_SEED_CBC.asp" -->
<!--#include file="config/base64.asp" -->
<!--#include file="config/stdpayFunction.asp" -->
<%
	'---------------------------------------------------------------------------------
	'
	' 환경변수 선언
	'
	'-----------------------------------------------------------------------------
	Dim AppWebPath

	'---------------------------------------------------------------------------------
	' 가맹점 API 가 호출 당할 경우 도메인 또는 아이피 셋팅하기 위한 변수 ( 도메인이 있을 경우 도메인을 셋팅하시면 됩니다. )
	' 용도 : serviceUrl 및 returnUrl, nonBankbookDepositInformUrl 용.
	' API 호출시 http:// 부터 경로를 전체적으로 써줘야 HttpRequest 통신시 오류발생 안함.
	'---------------------------------------------------------------------------------
	If Request.ServerVariables("HTTPS") = "on" Then
		urlProtocol = "https"
	Else
		urlProtocol = "http"
	End If

	AppWebPath = urlProtocol & "://" & Request.ServerVariables("HTTP_HOST")

	'-----------------------------------------------------------------------------
	' 캐릭터셋 지정
	'-----------------------------------------------------------------------------
	Response.charset = "UTF-8"


	'-----------------------------------------------------------------------------
	' USER-AGENT 구분
	'-----------------------------------------------------------------------------
	WebMode = Request.ServerVariables("HTTP_USER_AGENT")
	If Not (InStr(LCase(WebMode),"android") = 0 And InStr(LCase(WebMode),"iphone") = 0 And InStr(LCase(WebMode),"mobile") = 0) Then
		WebMode = "MOBILE"
	Else
		WebMode = "PC"
	End If


	'---------------------------------------------------------------------------------
	' 운영/개발 설정
	' Log 사용 여부 설정
	'---------------------------------------------------------------------------------
	Dim appMode, LogUse
	'appMode = "-test"		' REAL - 실서버 운영, TEST - 개발(테스트)
	LogUse = True			' Log 사용 여부 ( True = 사용, False = 미사용 )


	'-----------------------------------------------------------------------------
	' 기업 / 가맹점 코드 선언
	'-----------------------------------------------------------------------------
	Dim g_CORPNO, g_MERTNO, s_MERTNO
	If G2_SITE_MODE = "local" Then
		g_CORPNO = "0001"		' 기업 관리번호
		g_MERTNO = "0001-00010"	' 가맹점 관리번호					
	Else
		g_CORPNO = "0001"		' 기업 관리번호
		g_MERTNO = "0001-00010"	' 가맹점 관리번호					
	End If
	s_MERTNO = "0001-00001"

	'-----------------------------------------------------------------------------
	' 회원 번호 고정 (개발용)
	'-----------------------------------------------------------------------------

	Dim g_corpMemberNo, g_userMngNo
	If G2_SITE_MODE = "local" Then
		g_corpMemberNo = "10007012717313001"
		g_userMngNo = "S21070000036"
	end if


	'---------------------------------------------------------------------------------
	' 로그 파일 선언 ( 루트경로부터 \sgpay\log 폴더까지 생성을 해 놓습니다. )
	'---------------------------------------------------------------------------------
	Dim Write_LogFile
	Write_LogFile = Server.MapPath(".") + "\log\sgpay_Log_"+Replace(FormatDateTime(Now,2),"-","")+"_asp.txt"


	'-----------------------------------------------------------------------------
	' 암호화 모듈 및 키 선언
	'-----------------------------------------------------------------------------
	dim g_HASHKEY, g_SEEDKEY, g_SEEDIV
	g_HASHKEY 	= "F3149950A7B6289723F325833F580001"
	g_SEEDKEY 	= "gkR791mVtQlbbuwtcMfs1Q=="
    g_SEEDIV 	= "STDP000173087816"


	'---------------------------------------------------------------------------------
	' 구매 상품을 변수에 셋팅 ( JSON 문자열을 생성 )
	'---------------------------------------------------------------------------------
	Set jsonOrder = New aspJson			'JSON 을 작성할 OBJECT 선언
	jsonOrder.data.Add "corpNo", CStr(g_CORPNO)
	jsonOrder.data.Add "mertNo", g_MERTNO
	jsonOrder.data.Add "Member", memberToken


	'---------------------------------------------------------------------------------
	' API 주소 설정 ( appMode 에 따라 테스트와 실서버로 분기됩니다. )
	'---------------------------------------------------------------------------------
	Dim sgPayDomain, sgPayPayUrl, sgPayCancelUrl
	If G2_SITE_MODE = "local" Then
		sgPayDomain			= "https://stg-stdpay.kbstar.com/std"		' 운영 테스트서버
	Else
		sgPayDomain			= "https://stdpay.kbstar.com/std"			' 운영 실서버
	End If
	
	sgPay_MemRegUrl		= sgPayDomain & "/stdpay/su/memreg"			' SG Pay 가입 URL
	sgPay_PayUrl		= sgPayDomain & "/stdpay/su/payreqauth"		' 간편결제 결제요청 URL
	sgPay_CancelUrl		= sgPayDomain & "/api/payinfo/paycancel"	' SG Pay 취소 URL
	sgpay_OrdPayinfoUrl	= sgPayDomain & "/api/payinfo/ordpayinfo"	' SG Pay 주문 정보 URL
	sgpay_PaymentUrl	= sgPayDomain & "/stdpay/su/payreqauth"		' SG Pay 결제 URL
	sgpay_MyPageUrl		= sgPayDomain & "/stdpay/su/mypage"			' SG Pay 간편결제 설정 URL
	sgpay_payselUrl		= sgPayDomain & "/api/payinfo/paysel"		' SG Pay 회원 결제수단 조회 URL
	sgpay_MemInfoUrl	= sgPayDomain & "/api/memberinfo/meminfo"	' SG Pay 회원 정보 조회 URL
	sgpay_MemUnRegUrl	= sgPayDomain & "/api/memberinfo/memunreg"	' SG Pay 회원 해제 URL
%>