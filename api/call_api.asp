 <%
    Class ApiCall
        Public req
        Private reqMethod
        Private apiUrl
        Private req_content_type
        Private req_authorization
        Private res_content_type
        Private data

        Private Sub Class_Initialize()
            req_content_type = "application/x-www-form-urlencoded"
            reqMethod = "POST"
            data = ""
            res_content_type = ""
        End Sub

        Private Sub Class_Terminate()
            Set req = Nothing
        End Sub

        Public Property Let SetMethod(method)
            reqMethod = method
        End Property

        Public Property Let SetUrl(url)
            apiUrl = url
        End Property

        Public Property Let RequestContentType(content_type)
            req_content_type = content_type
        End Property

        Public Property Let Authorization(auth)
            req_authorization = auth
        End Property

        Public Property Let SetData(d)
            data = d
        End Property

        Public Property Let ResponseContentType(content_type)
            res_content_type = content_type
        End Property

        Public Function Run
            On Error Resume Next
            Set req = Server.CreateObject("MSXML2.ServerXMLHTTP")
			lResolve = 10 * 1000		'도메인 확인 시간, default 무한대
			lConnect = 10 * 1000	'서버와의 연결 시간, default 60 초
			lSend    = 10 * 1000	'데이터 전송 시간, default 30 초
			lReceive = 10 * 1000	'데이터 수신 시간, default 30 초

			req.setTimeouts lResolve, lConnect, lSend, lReceive
            req.Open reqMethod, apiUrl, False
            If req_content_type <> "" Then
                req.SetRequestHeader "Content-Type", req_content_type
            End If
            If req_authorization <> "" Then
                req.SetRequestHeader "Authorization", req_authorization
            End If
            req.Send data

            If res_content_type <> "" Then
                Response.AddHeader "Content-Type", res_content_type
            End If
            Response.CharSet = "UTF-8"

            Dim result : result = ""

            result = req.responseText

            Set req = Nothing

            If Err.Number <> 0 Then
                result = Err.Description
                Err.Clear
                
                'API 통신 확인을 위한 로그
                Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& Session("userIdx") &"','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / ApiUrl "& C_STR(apiUrl) & " / Data " & C_STR(data) & " / Err.Description " & result & " / HOST " & Request.ServerVariables("HTTP_HOST") & " / HTTP_URL " & Request.ServerVariables("HTTP_URL") & " / REFERER " & Request.ServerVariables("HTTP_REFERER") & " / REMOTE_ADDR " & Request.ServerVariables("REMOTE_ADDR") & " / " & Request.ServerVariables("HTTP_USER_AGENT") & "','0','call_api')"
                dbconn.Execute(Sql)

            End If
            Run = result
        End Function

    End Class
%>