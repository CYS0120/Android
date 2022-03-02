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
            dim err_desc : err_desc = ""
            Set req = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")  '(2022.2.25 변경) CreateObject("MSXML2.ServerXMLHTTP")
			lResolve = 10 * 1000		'도메인 확인 시간, default 무한대
			lConnect = 10 * 1000	'서버와의 연결 시간, default 60 초
			lSend    = 15 * 1000	'데이터 전송 시간, default 30 초
			lReceive = 15 * 1000	'데이터 수신 시간, default 30 초

			req.setTimeouts lResolve, lConnect, lSend, lReceive
            req.Open reqMethod, apiUrl, False
            
            If Err.Number <> 0 Then
                err_desc = replace(C_STR(Err.Number) & " " &  C_STR(Err.Source)  & " " & Err.Description, "'", "")
                Err.Clear
                
                'API 통신 확인을 위한 로그
                Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& Session("userIdx") &"','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / Err.Description " & err_desc & " / req_content_type " & req_content_type & " / ReqContent_type " & req_content_type & " / ReqAuthorization " & req_authorization & " / ResContent_type " & res_content_type & " / ApiUrl " & C_STR(apiUrl) & " / Data " & C_STR(data) & " / RESULT - / HOST " & Request.ServerVariables("HTTP_HOST") & " / HTTP_URL " & Request.ServerVariables("HTTP_URL") & " / REFERER " & Request.ServerVariables("HTTP_REFERER") & " / REMOTE_ADDR " & Request.ServerVariables("REMOTE_ADDR") & " / " & Request.ServerVariables("HTTP_USER_AGENT") & "','0','call_api-err1')"
                dbconn.Execute(Sql)
                err_desc = "" 
            End If

            If req_content_type <> "" Then
                req.SetRequestHeader "Content-Type", req_content_type
            End If
            If req_authorization <> "" Then
                req.SetRequestHeader "Authorization", req_authorization
            End If
            
            If Err.Number <> 0 Then
                err_desc = replace(C_STR(Err.Number) & " " &  C_STR(Err.Source)  & " " & Err.Description, "'", "")
                Err.Clear
                
                'API 통신 확인을 위한 로그
                Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& Session("userIdx") &"','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / Err.Description " & err_desc & " / req_content_type " & req_content_type & " / ReqContent_type " & req_content_type & " / ReqAuthorization " & req_authorization & " / ResContent_type " & res_content_type & " / ApiUrl " & C_STR(apiUrl) & " / Data " & C_STR(data) & " / RESULT - / HOST " & Request.ServerVariables("HTTP_HOST") & " / HTTP_URL " & Request.ServerVariables("HTTP_URL") & " / REFERER " & Request.ServerVariables("HTTP_REFERER") & " / REMOTE_ADDR " & Request.ServerVariables("REMOTE_ADDR") & " / " & Request.ServerVariables("HTTP_USER_AGENT") & "','0','call_api-err2')"
                dbconn.Execute(Sql)
                err_desc = "" 
            End If

            req.Send data

            Dim result : result = "{}"
            If Err.Number <> 0 Then
                err_desc = replace(C_STR(Err.Number) & " " &  C_STR(Err.Source)  & " " & Err.Description, "'", "")
                Err.Clear

                'API 통신 확인을 위한 로그
                Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& Session("userIdx") &"','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / Status " & C_STR(req.Status) & " / Err.Description " & err_desc & " / req_content_type " & req_content_type & " / ReqContent_type " & req_content_type & " / ReqAuthorization " & req_authorization & " / ResContent_type " & res_content_type & " / ApiUrl " & C_STR(apiUrl) & " / Data " & C_STR(data) & " / RESULT - / HOST " & Request.ServerVariables("HTTP_HOST") & " / HTTP_URL " & Request.ServerVariables("HTTP_URL") & " / REFERER " & Request.ServerVariables("HTTP_REFERER") & " / REMOTE_ADDR " & Request.ServerVariables("REMOTE_ADDR") & " / " & Request.ServerVariables("HTTP_USER_AGENT") & "','0','call_api-err3')"
                dbconn.Execute(Sql)
                err_desc = "" 
                
                for i = 0 to 4 '5번 재시도
                    Sleep(1)
                    
                    '새로운 req 객체 사용
                    Set req_new = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")
                    req_new.setTimeouts lResolve, lConnect, lSend, lReceive
                    req_new.Open reqMethod, apiUrl, False
                    If req_content_type <> "" Then
                        req_new.SetRequestHeader "Content-Type", req_content_type
                    End If
                    If req_authorization <> "" Then
                        req_new.SetRequestHeader "Authorization", req_authorization
                    End If

                    req_new.Send data

                    If Err.Number = 0 Then
                        If res_content_type <> "" Then
                            Response.AddHeader "Content-Type", res_content_type
                        End If
                        Response.CharSet = "UTF-8"
                        result = req_new.responseText
                        Set req_new = Nothing

                        Exit For
                    else
                        err_desc = replace(C_STR(Err.Number) & " " &  C_STR(Err.Source)  & " " & Err.Description, "'", "")
                        Err.Clear

                        Set req_new = Nothing

                        'API 통신 확인을 위한 로그
                        Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& Session("userIdx") &"','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / Status " & C_STR(req.Status) & " / Err.Description " & err_desc & " / req_content_type " & req_content_type & " / ReqContent_type " & req_content_type & " / ReqAuthorization " & req_authorization & " / ResContent_type " & res_content_type & " / ApiUrl " & C_STR(apiUrl) & " / Data " & C_STR(data) & " / RESULT - / HOST " & Request.ServerVariables("HTTP_HOST") & " / HTTP_URL " & Request.ServerVariables("HTTP_URL") & " / REFERER " & Request.ServerVariables("HTTP_REFERER") & " / REMOTE_ADDR " & Request.ServerVariables("REMOTE_ADDR") & " / " & Request.ServerVariables("HTTP_USER_AGENT") & "','0','call_api-err3-"& C_STR(i) &"')"
                        dbconn.Execute(Sql)
                        err_desc = "" 
                    end if 
                next 
            Else
                If res_content_type <> "" Then
                    Response.AddHeader "Content-Type", res_content_type
                End If
                Response.CharSet = "UTF-8"
                'Err 없으면 req 객체 사용
                result = req.responseText
            End If

            Set req = Nothing

            Run = result
        End Function

    End Class
%>