<%
	Response.AddHeader "pragma","no-cache"

	'****************************************************************************
	'* �ſ�ī�� ��� �뺸. 
	'*  - Noti.asp
	'*     
	'* �����ý��� ������ ���� ���ǻ��� �����ø� ������������� ���� �ֽʽÿ�.
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
	'* Noti ���� �� ���� �Ϸῡ ���� �۾�
	'* - Noti�� ����� ���� DB�۾����� �ڵ��� �����Ͽ� �ֽʽÿ�.
	'* - ORDERID, AMOUNT �� ���� �ŷ����뿡 ���� ������ �ݵ�� �Ͻñ� �ٶ��ϴ�.
	'****************************************************/
%>