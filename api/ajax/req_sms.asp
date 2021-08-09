<!--#include virtual="/api/include/utf8.asp"-->
<%
	If GetReferer = GetCurrentHost Then 
	Else
        Response.Write "{""result"":2,""message"":""전화번호가 불확실합니다.""}"
		Response.End 
	End If

	Randomize Timer
    mobile = GetReqStr("mobile","")

    If mobile = "" Then
        Response.Write "{""result"":2,""message"":""전화번호가 불확실합니다.""}"
        Response.End
    End If
    TopValue = 999999
'    app_num = LEFT(ROUND(RND * 10000000,0), 6) ' 가끔 5자리 인증번호가 가서 강제로 6자리로 만듬.
    app_num = LEFT(LEFT(ROUND(RND * 10000000,0), 6)&"0", 6)

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_nonmember_sms_insert_ver2"

        .Parameters.Append .CreateParameter("@mobile", adVarChar, adParamInput, 20, mobile)
        .Parameters.Append .CreateParameter("@app_num", adVarChar, adParamInput, 6, app_num)
		
		.Parameters.Append .CreateParameter("@ERRCODE", adVarChar, adParamOutput, 4)	'결과코드 (0000 : 성공, 이외 : 실패)
		.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)	'

		.Execute
		errCode = .Parameters("@ERRCODE").Value
		errMsg = .Parameters("@ERRMSG").Value
    End With
    Set cmd = Nothing

	If errCode = "0" Then 
	Else
		Response.Write "{""result"":3,""message"":"""& errMsg &"""}"
		Response.End
	End If 
	
	If TESTMODE = "Y" Then 
		errCode = "0000"
	Else 
		DEST_PHONE = mobile	'	수신자 연락처
		SEND_PHONE = "15889282"	'	발신자 연락처
		AUTH_NO	= app_num		'	승인번호 (인증번호)
		SERVICE_NM = "비비큐 비회원주문"	'	서비스명 (예, 비비큐 주문하기 / 비비큐)

		Set aCmd = Server.CreateObject("ADODB.Command")
		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "GNSIS_SMS.GNSIS_SMS.DBO.PRC_SET_SMS_AUTH_NO"

			.Parameters.Append .CreateParameter("@DEST_PHONE", adVarChar, adParamInput, 20, DEST_PHONE)
			.Parameters.Append .CreateParameter("@SEND_PHONE", adVarChar, adParamInput, 20, SEND_PHONE)
			.Parameters.Append .CreateParameter("@AUTH_NO", adVarChar, adParamInput, 10, AUTH_NO)
			.Parameters.Append .CreateParameter("@SERVICE_NM", adVarChar, adParamInput, 40, SERVICE_NM)
			.Parameters.Append .CreateParameter("@RET", adVarChar, adParamOutput, 4)	'결과코드 (0000 : 성공, 이외 : 실패)

			.Execute
			errCode = .Parameters("@RET").Value

		End With
		Set aCmd = Nothing
	End If 
	If errCode = "0000" Then
'       Response.Write "{""result"":0,""message"":""문자가 발송되었습니다.\n인증번호를 입력해주세요."",""num"":"""&app_num&"""}"
		Response.Write "{""result"":0,""message"":""문자가 발송되었습니다.\n인증번호를 입력해주세요.""}"
	Else
		Response.Write "{""result"":3,""message"":""인증번호가 발급되지 않았습니다.\n다시 시도해주세요.""}"
	End If
    Set rs = Nothing
%>