<%
  Response.AddHeader "pragma","no-cache"
  
	'/******************************************************************************** 
	' *
	' * 다날 본인인증
	' *
	' * - 인증 확인 페이지
	' *	인증 확인 및 기타 정보 수신
	' *
	' * 시스템 연동에 대한 문의사항이 있으시면 서비스개발팀으로 연락 주십시오.
	' * DANAL Commerce Division Technique supporting Team 
	' * EMail : tech@danal.co.kr 
	' *
	' ********************************************************************************/

    '/********************************************************************************
	' *
	' * XSS 취약점 방지를 위해 
	' * 모든 페이지에서 파라미터 값에 대해 검증하는 로직을 추가할 것을 권고 드립니다.
	' * XSS 취약점이 존재할 경우 웹페이지를 열람하는 접속자의 권한으로 부적절한 스크립트가 수행될 수 있습니다.
	' * 보안 대책
	' *  - html tag를 허용하지 않아야 합니다.(html 태그 허용시 white list를 선정하여 해당 태그만 허용)
	' *  - <, >, &, " 등의 문자를 replace등의 문자 변환함수를 사용하여 치환해야 합니다.
	' * 
	' ********************************************************************************/
%>
<!--#include file="./inc/function.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>다날 본인인증</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
</head>
<%
	Dim TransR, Addition, Res
	Dim nConfirmOption, TID
	
	Set TransR = CreateObject("Scripting.Dictionary")

	TID = Request.Form("TID")
	
	'/*
	' * initialize
	' */
	Res = null
	
	'/*
	' * CONFIRM
	' * - CONFIRMOPTION 
	' *	0 : NONE( default )
	' * 	1 : CPID 및 ORDERID 체크 
	' * - IDENOPTION
	' * 0 : 생년월일(6자리) 및 성별 IDEN 필드로 Return (ex : 1401011)
	' * 1 : 생년월일(8자리) 및 성별 별개 필드로 Return (연동 매뉴얼 참조. ex : DOB=20140101&SEX=1)
	' */
	nConfirmOption = "0"
	nIdenOption = "0"
	TransR.Add "TXTYPE", "CONFIRM"
	TransR.Add "TID", TID
	TransR.Add "CONFIRMOPTION", nConfirmOption
	TransR.Add "IDENOPTION", nIdenOption
	
	'/*
	' * CONFIRMOPTION이 1이면 CPID, ORDERID 필수 전달
	' */
	IF nConfirmOption = "1" Then
		TransR.Add "CPID", ID
		TransR.Add "ORDERID", ORDERID
	End IF
	
	Set Res = CallTrans(TransR,false)
	
	IF Res.Item("RETURNCODE") = "0000" Then

		'/**************************************************************************
		' *
		' * 인증 성공에 대한 작업
		' *
		' **************************************************************************/
%>
<body>
<form name="CPCGI" action="./Success.asp" method="post">
<%
	MakeFormInputHTTP Request.Form , "TID"
	MakeFormInput Res , Array("RETURNCODE","RETURNMSG")
%>
</form>
<script>
	document.CPCGI.submit();
</script>
</body>
</html>
<%
	Else
 		'/**************************************************************************
		' *
		' * 인증 실패에 대한 작업
		' *
		' **************************************************************************/		
		RETURNCODE 	= Res.Item("RETURNCODE")
		RETURNMSG 	= Res.Item("RETURNMSG")
		AbleBack 	= false
		BackURL 	= Request.Form("BackURL")
		BgColor 	= Request.Form("BgColor")
%>
<!--#include file="Error.asp"-->
<%
	End IF
%>
