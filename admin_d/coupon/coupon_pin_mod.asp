<!-- #include virtual="/inc/config.asp" -->
<!-- #include virtual="/inc/admin_check.asp" -->
<%
'  -------------------------------------------------------------------------------
'  기본 변수 선언
'  -------------------------------------------------------------------------------
	'//리퀘스트 처리-------------------------
	Dim CPNID, PIN, S_TYPE, VAL_INT

	Dim sReslult, Msg

	PIN = InjRequest("PIN")
	S_TYPE = InjRequest("S_TYPE")

    Dim Param

	Dim objRs
	Dim objCmd

	Set objCmd = Server.CreateObject("ADODB.Command")

	If Len(PIN) > 0 Then

        If Left(S_TYPE, 1) = "I" Then
            
            WITH objCmd

                .ActiveConnection = conn
                .CommandTimeout = 3000
                .CommandText = BBQHOME_DB &".DBO.UP_COUPON_INIT"
                .CommandType = adCmdStoredProc

                .Parameters.Append .CreateParameter("@PIN",advarchar,adParamInput,50, PIN)
                .Parameters.Append .CreateParameter("@RETURN_VAL",advarchar,adParamOutPut,4)

                .Execute

                sReslult = .Parameters("@RETURN_VAL")
            END WITH

            Msg = sReslult
            If sReslult = "0000" Then
                Msg = "해당 쿠폰이 초기화 되었습니다."
            ElseIf sReslult = "9999" Then
                Msg = "정상 사용된 내역이 있습니다. 점검바랍니다."
            End If

        ElseIf Left(S_TYPE, 1) = "A" And Len(S_TYPE) = 3 Then

            WITH objCmd

                .ActiveConnection = conn
                .CommandTimeout = 3000
                .CommandText = BBQHOME_DB &".DBO.UP_COUPON_MOD"
                .CommandType = adCmdStoredProc

                .Parameters.Append .CreateParameter("@PIN",advarchar,adParamInput,50, PIN)
                .Parameters.Append .CreateParameter("@S_TYPE",advarchar,adParamInput,2, Left(S_TYPE, 2))
                .Parameters.Append .CreateParameter("@S_VAL",adInteger,adParamInput,, 1)
                .Parameters.Append .CreateParameter("@RETURN_VAL",advarchar,adParamOutPut,4)

                .Execute

                sReslult = .Parameters("@RETURN_VAL")
            END WITH

            Msg = sReslult
            If sReslult = "0000" Then
                Msg = "쿠폰설정이 변경 되었습니다."
            ElseIf sReslult = "1111" Then
                Msg = "파라메터 값이 올바르지 않습니다.."
            ElseIf sReslult = "9999" Then
                Msg = "핀 번호가 없습니다."
            End If

		Else
            Msg = "연장 기일을 선택해 주세요."
        End If

	End If

%>

<script language="javascript">

    alert("<%=Msg%>");
    parent.location.reload();

</script>

<%
	Set objRs= Nothing
	Set objCmd = Nothing

	conn.Close
	Set conn = Nothing
%>