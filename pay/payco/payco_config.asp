<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Session.CodePage = "65001"
    Response.CharSet = "UTF-8"
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
    ' Response.CharSet = "euc-kr"
%>
<%
	'Option Explicit
	'-----------------------------------------------------------------------------
	' PAYCO 연동 환경설정 페이지 ( ASP )
	' payco_config.asp
	' 2015-03-25	PAYCO기술지원 <dl_payco_ts@nhnent.com>
	'
	' ASP 에서는 JSON 형태를 지원하지 않기 때문에 하단 파일(json_for_asp/aspJSON1.17.asp)을 include 합니다.
	' 출처 : http://code.google.com/p/aspjson/, http://www.aspjson.com/
	'
	' payco_util.asp 는 PAYCO와 통신하기 위한 필수 함수들을 모아놓은 파일입니다. 
	' 반드시 include 하시기 바랍니다.
	'-----------------------------------------------------------------------------
%>
<!--#include file="payco_util.asp"-->
<!--#include file="json_for_asp/aspJSON1.17.asp"-->
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

	AppWebPath = urlProtocol & "://" & Request.ServerVariables("HTTP_HOST") & "/pay/payco"

	'-----------------------------------------------------------------------------
	' 캐릭터셋 지정
	'-----------------------------------------------------------------------------
	Response.charset = "UTF-8"
	'Response.charset = "EUC-KR"

	'---------------------------------------------------------------------------------
	' 가맹점 코드 선언 ( 가맹점 수정 부분 )
	'---------------------------------------------------------------------------------
	Dim sellerKey
	Dim cpId, productId, deliveryId, deliveryReferenceKey
	Dim orderMethod, payMode
	Dim WebMode

	'sellerKey				=	"S0FSJE"									'(필수) 가맹점 코드 - 파트너센터에서 알려주는 값으로, 초기 연동 시 PAYCO에서 쇼핑몰에 값을 전달한다.
	'cpId					=	"PARTNERTEST"								'(필수) 상점ID, 30자 이내
	'productId				=	"PROD_EASY"									'(필수) 상품ID, 50자 이내
	deliveryId				=	"DELIVERY_PROD"								'(필수) 배송비상품ID, 50자 이내, EASYPAY 용
	deliveryReferenceKey	=	"DV0001"									'(필수) 가맹점에서 관리하는 배송비상품 연동 키, 100자 이내, 고정, EASYPAY 용
	orderMethod				=	"EASYPAY"									'(필수) 주문유형(=결재유형) - 체크아웃형 : CHECKOUT - 간편결제형+가맹점 id 로그인 : EASYPAY_F , 간편결제형+가맹점 id 비로그인(PAYCO 회원구매) : EASYPAY
	payMode					=	"PAY2"										'결제모드 ( PAY1 - 결제인증, 승인통합 / PAY2 - 결제인증, 승인분리 )
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
	appMode = "REAL"		' REAL - 실서버 운영, TEST - 개발(테스트)
	LogUse = True			' Log 사용 여부 ( True = 사용, False = 미사용 )

	'---------------------------------------------------------------------------------
	' API 주소 설정 ( appMode 에 따라 테스트와 실서버로 분기됩니다. )
	'---------------------------------------------------------------------------------
	Dim URL_reserve, URL_approval, URL_cancel_check, URL_cancel, URL_upstatus, URL_cancelMileage, URL_checkUsability, URL_verifyPayment

	Select Case UCase(appMode)
		Case "TEST"
			URL_reserve = "https://alpha-api-bill.payco.com/outseller/order/reserve"
			URL_approval = "https://alpha-api-bill.payco.com/outseller/payment/approval"
			URL_cancel_check = "https://alpha-api-bill.payco.com/outseller/order/cancel/checkAvailability"
			URL_cancel = "https://alpha-api-bill.payco.com/outseller/order/cancel"
			URL_upstatus = "https://alpha-api-bill.payco.com/outseller/order/updateOrderProductStatus"
			URL_cancelMileage = "https://alpha-api-bill.payco.com/outseller/order/cancel/partMileage"
			URL_checkUsability = "https://alpha-api-bill.payco.com/outseller/code/checkUsability"
			URL_verifyPayment = "https://alpha-api-bill.payco.com/outseller/payment/approval/getDetailForVerify"
		Case "REAL"
			URL_reserve = "https://api-bill.payco.com/outseller/order/reserve"
			URL_approval = "https://api-bill.payco.com/outseller/payment/approval"
			URL_cancel_check = "https://api-bill.payco.com/outseller/order/cancel/checkAvailability"
			URL_cancel = "https://api-bill.payco.com/outseller/order/cancel"
			URL_upstatus = "https://api-bill.payco.com/outseller/order/updateOrderProductStatus"
			URL_cancelMileage = "https://api-bill.payco.com/outseller/order/cancel/partMileage"
			URL_checkUsability = "https://api-bill.payco.com/outseller/code/checkUsability"
			URL_verifyPayment = "https://api-bill.payco.com/outseller/payment/approval/getDetailForVerify"
	End Select

	'---------------------------------------------------------------------------------
	' 로그 파일 선언 ( 루트경로부터 \Payco\asp\log 폴더까지 생성을 해 놓습니다. )
	'---------------------------------------------------------------------------------
	Dim Write_LogFile
	Write_LogFile = "C:\Web_Log\pay\payco\log\Payco_Log_"+Replace(FormatDateTime(Now,2),"-","")+"_asp.txt"

%>
