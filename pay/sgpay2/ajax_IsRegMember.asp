<!--#include file="sgpay.inc.asp" -->
<%
	' //-------------------------------------------------------
	' // 1. 파라미터 설정
	' //-------------------------------------------------------
	' // 입력 파라미터
	corpMemberNo 	= request("corpMemberNo")	'// [필수] 기업(가맹점) 회원번호 - (SEED 암호화 대상필드)

    userMngNo = GetuserMngNo(corpMemberNo)
    response.write userMngNo
%>