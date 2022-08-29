<!--#include virtual="/api/include/utf8.asp"-->
<%
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
		Response.Write "{""result"":1,""message"":""잘못된 접근방식 입니다.""}"
		Response.End 
	End If

    event_cd = GetReqStr("event_cd","")
    coupon_id = GetReqStr("cpnid","")
    coupon_no = GetReqStr("cpnno","")
    If Len(coupon_id) = 0 Then coupon_id = "" End If
    If Len(coupon_no) = 0 Then coupon_no = "" End If

    If event_cd = "" Then
        Response.Write "{""result"":1,""message"":""이벤트 정보가 불확실합니다.""}"
        Response.End
    End If

    If Not CheckLogin() Then
        Response.Write "{""result"":2,""message"":""로그인이 필요합니다.""}"
        Response.End
    End If

    If Len(coupon_id) > 0 And coupon_no <> "" Then
        Set CouponUse = CouponRedeem(coupon_no)
        If CouponUse.mCode = 0 Then
            Set cmd = Server.CreateObject("ADODB.Command")
            With cmd
                .ActiveConnection = dbconn
                .NamedParameters = True
                .CommandType = adCmdStoredProc
                .CommandText = "UP_EVENT_OFFLINE_MEMBER"

                .Parameters.Append .CreateParameter("@TP", adVarChar, adParamInput, 10, "USE")
                .Parameters.Append .CreateParameter("@EVENT_CD", adVarChar, adParamInput, 10, event_cd)
                .Parameters.Append .CreateParameter("@MEMBER_IDNO", adVarChar, adParamInput, 20 , Session("userIdNo"))
                .Parameters.Append .CreateParameter("@ORDER_ID", adVarChar, adParamInput, 40, "")
                .Parameters.Append .CreateParameter("@MESSAGE", adVarChar, adParamInput, 1000 , "")
                .Parameters.Append .CreateParameter("@COUPON_ID", adVarChar, adParamInput, 10, coupon_id)
                .Parameters.Append .CreateParameter("@COUPON_NO", adVarChar, adParamInput, 16 , coupon_no)
                .Parameters.Append .CreateParameter("@RSTMSG", adVarChar, adParamOutput, 500)

                .Execute

                rstMsg = .Parameters("@RSTMSG").Value
            End With
            Set cmd = Nothing

            Response.Write "{""result"":0,""message"":""" & rstMsg & """}"
            Response.End
        ElseIf CouponUse.mCode = 2105 Then
            Response.Write "{""result"":1,""message"":""이벤트 기간이 아닙니다.<br>쿠폰 유효기간을 확인해주세요.""}"
            Response.End
        ElseIf CouponUse.mCode = 2104 Then
            Response.Write "{""result"":1,""message"":""이미 사용되었거나 존재하지 않는 쿠폰입니다.""}"
            Response.End
        Else
            Response.Write "{""result"":1,""message"":""쿠폰 사용 처리 중 오류가 발생했습니다.""}"
            Response.End
        End If
    Else
        Set cmd = Server.CreateObject("ADODB.Command")
        With cmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "UP_EVENT_OFFLINE_MEMBER"

            .Parameters.Append .CreateParameter("@TP", adVarChar, adParamInput, 10, "USE")
            .Parameters.Append .CreateParameter("@EVENT_CD", adVarChar, adParamInput, 10, event_cd)
            .Parameters.Append .CreateParameter("@MEMBER_IDNO", adVarChar, adParamInput, 20 , Session("userIdNo"))
            .Parameters.Append .CreateParameter("@ORDER_ID", adVarChar, adParamInput, 40, "")
            .Parameters.Append .CreateParameter("@MESSAGE", adVarChar, adParamInput, 1000 , "")
            .Parameters.Append .CreateParameter("@COUPON_ID", adVarChar, adParamInput, 10, coupon_id)
            .Parameters.Append .CreateParameter("@COUPON_NO", adVarChar, adParamInput, 16 , coupon_no)
            .Parameters.Append .CreateParameter("@RSTMSG", adVarChar, adParamOutput, 500)

            .Execute

            rstMsg = .Parameters("@RSTMSG").Value
        End With
        Set cmd = Nothing

        Response.Write "{""result"":0,""message"":""" & rstMsg & """}"
        Response.End
    End If


%>