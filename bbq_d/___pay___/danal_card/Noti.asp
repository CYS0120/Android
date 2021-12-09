<%
	Response.AddHeader "pragma","no-cache"

	'****************************************************************************
	'* 신용카드 결과 통보. 
	'*  - Noti.asp
	'*     
	'* 결제시스템 연동에 대한 문의사항 있으시면 기술지원팀으로 연락 주십시오.
	'* DANAL Commerce Division Technique supporting Team 
	'* EMAIL : tech@danal.co.kr
	'****************************************************************************
%>
<!--#include file="./inc/function.asp"-->
<%
    RET_STR = Request.Form("DATA")
    RET_STR = URLDecode(RET_STR)
    RET_STR = toDecrypt(RET_STR)

	DT = FormatDateTime(Now, 2)
	DT = Mid(DT,3,2) & Mid(DT,6,2) & Right(DT,2)

	On Error Resume Next
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objOFile = objFSO.OpenTextFile(Server.MapPath(".") & "\log\noti_"& DT & ".log" ,8,True)

	IF Err.Number <> 0 Then
		Response.Write("Fail-Cannot open log file(" & Err.Description & ")")
		Response.End
	End IF

	NDT = FormatDateTime(Now,2) & " " & FormatDateTime(Now,4)

	objOFile.WriteLine("[" & NDT &"] " & RET_STR)
	objOFile.Close()

	Response.Write("OK")

    '***************************************************
	'* Noti 성공 시 결제 완료에 대한 작업
	'* - Noti의 결과에 따라 DB작업등의 코딩을 삽입하여 주십시오.
	'* - ORDERID, AMOUNT 등 결제 거래내용에 대한 검증을 반드시 하시기 바랍니다.
	'****************************************************/
%>