<!--#include file="sgpay.inc.asp" -->
<%
'/****************************************************************************
'/	WPAY 표준
'/	
'/	회원 가입 요청 CI 옵션 (화면 UI)
'/****************************************************************************
%>
<%
    REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If Not CheckLogin() Then
        if len(REFERERURL) = 0 then REFERERURL = "/"
%>
<script>
	alert('회원 서비스입니다.');
</script>
<%
        response.redirect REFERERURL
		Response.End
	End If

	'-------------------------------------------------------
	' 1. 파라미터 설정
	'-------------------------------------------------------
	' 입력 파라미터
	corpNo 			= g_CORPNO			        ' [필수] 기업관리번호
	mertNo 			= s_MERTNO			        ' [필수] 가맹점관리번호	
	corpMemberNo 	= Session("userIdNo")	    ' [필수] 기업(가맹점) 회원번호 - (SEED 암호화 대상필드)
	userMngNo 		= GetuserMngNo(Session("userIdNo"))' [필수] 간편결제 회원관리번호 - (SEED 암호화 대상필드)

    if userMngNo = "" then
		server.transfer("/pay/sgpay2/sgpay_MemReg.asp")
%>
<script>
	// if(confirm('가입되지 않은 사용자입니다. 비비큐페이 가입페이지로 이동하시겠습니까?'))
    // {
    //     var win_reg = window.open("/pay/sgpay2/sgpay_MemReg.asp");
    //     if(win_reg == null) alert("팝업이 차단되어 있습니다. 가입을 위해서는 팝업차단을 해제하여 주시기 바랍니다.");
    // }

    // location.replace("/");
</script>
<%
        response.end
    end if
%>
<script>
    console.log("<%=corpMemberNo%>");    
</script>
<%

    returnUrl 		= REFERERURL		        ' [필수] 회원가입 결과전달 URL - (URL Encoding 대상필드) 
	
	'공통 CSS
	biImgUrl 		= request("biImgUrl")
	content 		= request("content")
	bgColor 		= request("bgColor")
	mainColor 		= request("mainColor")
	secuKeypadType 	= request("secuKeypadType")

	'-------------------------------------------------------
	' 2. 암호화 대상 필드 Seed 암호화  
	'-------------------------------------------------------
    ' response.write "corpMemberNo : " & Session("userIdNo") & "<BR>"
    ' response.write "userMngNo : " & userMngNo & "<BR>"

	corpMemberNo 	= seedEncrypt(Session("userIdNo"), g_SEEDKEY, g_SEEDIV)
	userMngNo 		= seedEncrypt(userMngNo, g_SEEDKEY, g_SEEDIV)
	
	'-------------------------------------------------------
	' 3. URLEncode 대상 필드 encode처리(UTF-8)  
	'-------------------------------------------------------
	returnUrl 		= Server.URLencode(returnUrl)

	biImgUrl 		= Server.URLencode(biImgUrl)
	content 		= Server.URLencode(content)
	bgColor 		= Server.URLencode(bgColor)
	mainColor 		= Server.URLencode(mainColor)
	secuKeypadType 	= Server.URLencode(secuKeypadType)
	
	
	
	'-------------------------------------------------------
	' 3. 위변조 방지체크를 위한 signature 생성
	'   (순서주의:연동규약서 참고)
	'-------------------------------------------------------
	srcStr = "corpNo=" & corpNo
	srcStr = srcStr & "&mertNo=" & mertNo
	srcStr = srcStr & "&corpMemberNo=" & corpMemberNo
	srcStr = srcStr & "&userMngNo=" & userMngNo
	srcStr = srcStr & "&disPayUiType=" & disPayUiType
	srcStr = srcStr & "&cashReceiptYn=" & cashReceiptYn
	srcStr = srcStr & "&payHistYn=" & payHistYn
	srcStr = srcStr & "&cashBackHistYn=" & cashBackHistYn
	srcStr = srcStr & "&returnUrl=" & returnUrl

	signature = srcStr & "&hashKey=" & g_HASHKEY
	
	signature = SHA256_Encrypt(signature)
	
%>


<!DOCTYPE html>
<html>
<body onload="document.getElementById('SendForm').submit();">
<!--body-->
<form id="SendForm" name="SendForm" method="POST" action="<%=sgpay_MyPageUrl%>">
	<input type="hidden" name="corpNo" 			id="corpNo" 		value="<%=corpNo%>">	
	<input type="hidden" name="mertNo" 			id="mertNo" 		value="<%=mertNo%>">
	<input type="hidden" name="corpMemberNo" 	id="corpMemberNo" 	value="<%=corpMemberNo%>">
	<input type="hidden" name="userMngNo" 		id="userMngNo" 		value="<%=userMngNo%>">
	<input type="hidden" name="disPayUiType" 	id="disPayUiType" 	value="<%=disPayUiType%>">
	<input type="hidden" name="cashReceiptYn" 	id="cashReceiptYn" 	value="<%=cashReceiptYn%>">
	<input type="hidden" name="payHistYn" 		id="payHistYn" 		value="<%=payHistYn%>">
	<input type="hidden" name="cashBackHistYn" 	id="cashBackHistYn" value="<%=cashBackHistYn%>">
	<input type="hidden" name="returnUrl" 		id="returnUrl" 		value="<%=returnUrl%>">
	<input type="hidden" name="signature" 		id="signature" 		value="<%=signature%>">
	<input type="hidden" name="biImgUrl" 		id="biImgUrl" 		value="<%=biImgUrl%>">
	<input type="hidden" name="content" 		id="content" 		value="<%=content%>">
	<input type="hidden" name="bgColor" 		id="bgColor" 		value="<%=bgColor%>">
	<input type="hidden" name="mainColor" 		id="mainColor" 		value="<%=mainColor%>">
	<input type="hidden" name="secuKeypadType" 	id="secuKeypadType" value="<%=secuKeypadType%>">
</form>
<script>
    console.log("<%=userMngNo%>");    
</script>
</body>
</html>