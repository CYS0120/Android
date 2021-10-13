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
        if len(REFERERURL) = 0 or instr(REFERERURL, g2_bbq_m_url) < 0 then
			REFERERURL = "/"
		end if
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
	mertNo 			= g_MERTNO			        ' [필수] 가맹점관리번호	
	corpMemberNo 	= g_corpMemberNo		    ' [필수] 기업(가맹점) 회원번호 - (SEED 암호화 대상필드)

	introYn 		= "N"		                ' [옵션] 인트로 화면 표시여부 (Y/N)
	regUiType 		= "R2"		                ' [옵션] 가입 UI타입 , ① R1 : 약관동의, 본인인증 분리 UI,	② R2 : 약관동의, 본인인증 통합UI, *Default :R1
	selPayUiType 	= "S1"	                    ' [옵션] 결제수단 선택 UI 타입, ① S1 : 결제수단 선택버튼(카드,계좌) 분리 UI, ② S2 : 결제수단 선택 버튼 통합 UI, *Default :S1
	userNm 			= request("userNm")		    ' [옵션] 회원 실명  - (URL Encoding 대상필드) 가맹점별Optional Required
	hNum 			= replace(Session("userPhone"), "-", "")			' [옵션] ‘-‘(하이폰)제외한 고객 휴대폰번호 - (SEED 암호화 대상필드)
	hCorp 			= request("hCorp")			' [옵션] 휴대폰 통신사 
	email 			= request("email")			' [옵션] 이메일
	addrMain 		= request("addrMain")		' [옵션] 주소 
	addrDet 		= request("addrDet")		' [옵션] 상세주소
	returnUrl 		= REFERERURL		        ' [필수] 회원가입 결과전달 URL - (URL Encoding 대상필드) 
	
	'공통 CSS
	biImgUrl 		= request("biImgUrl")
	content 		= request("content")
	bgColor 		= request("bgColor")
	mainColor 		= request("mainColor")
	secuKeypadType 	= request("secuKeypadType")


	' 회원가입요청 URL
	requestURL = requestDomain & "/stdpay/su/memreg"
	

	'-------------------------------------------------------
	' 2. 암호화 대상 필드 Seed 암호화  
	'-------------------------------------------------------
	corpMemberNo = seedEncrypt(g_corpMemberNo, g_SEEDKEY, g_SEEDIV)
	hNum = seedEncrypt(hNum, g_SEEDKEY, g_SEEDIV)
	
	'-------------------------------------------------------
	' 3. URLEncode 대상 필드 encode처리(UTF-8)  
	'-------------------------------------------------------
	userNm 			= Server.URLencode(userNm)
	addrMain 		= Server.URLencode(addrMain)
	addrDet 		= Server.URLencode(addrDet)
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
	srcStr = srcStr & "&introYn=" & introYn
	srcStr = srcStr & "&regUiType=" & regUiType
	srcStr = srcStr & "&selPayUiType=" & selPayUiType
	srcStr = srcStr & "&userNm=" & userNm
	srcStr = srcStr & "&hCorp=" & hCorp
	srcStr = srcStr & "&email=" & email
	srcStr = srcStr & "&addrMain=" & addrMain
	srcStr = srcStr & "&addrDet=" & addrDet
	srcStr = srcStr & "&returnUrl=" & returnUrl
	srcStr = srcStr & "&hashKey=" & g_HASHKEY
	
	signature = SHA256_Encrypt(srcStr)
	
%>


<!DOCTYPE html>
<html>
<body onload="document.getElementById('SendForm').submit();">
<!--body-->
<form id="SendForm" name="SendForm" method="POST" action="<%=sgPay_MemRegUrl%>">
	<input type="hidden" name="corpNo" 			id="corpNo" 		value="<%=corpNo%>">	
	<input type="hidden" name="mertNo" 			id="mertNo" 		value="<%=mertNo%>">
	<input type="hidden" name="corpMemberNo" 	id="corpMemberNo" 	value="<%=corpMemberNo%>">
	<input type="hidden" name="introYn" 		id="introYn" 		value="<%=introYn%>">
	<input type="hidden" name="regUiType" 		id="regUiType" 		value="<%=regUiType%>">
	<input type="hidden" name="selPayUiType" 	id="selPayUiType" 	value="<%=selPayUiType%>">
	<input type="hidden" name="userNm" 			id="userNm" 		value="<%=userNm%>">
	<input type="hidden" name="hCorp" 			id="hCorp" 			value="<%=hCorp%>">
	<input type="hidden" name="email" 			id="email" 			value="<%=email%>">
	<input type="hidden" name="addrMain" 		id="addrMain" 		value="<%=addrMain%>">
	<input type="hidden" name="addrDet" 		id="addrDet" 		value="<%=addrDet%>">
	<input type="hidden" name="returnUrl" 		id="returnUrl" 		value="<%=returnUrl%>">
	<input type="hidden" name="signature" 		id="signature" 		value="<%=signature%>">
	<input type="hidden" name="biImgUrl" 		id="biImgUrl" 		value="<%=biImgUrl%>">
	<input type="hidden" name="content" 		id="content" 		value="<%=content%>">
	<input type="hidden" name="bgColor" 		id="bgColor" 		value="<%=bgColor%>">
	<input type="hidden" name="mainColor" 		id="mainColor" 		value="<%=mainColor%>">
	<input type="hidden" name="secuKeypadType" 	id="secuKeypadType" value="<%=secuKeypadType%>">
</form>
</body>
</html>