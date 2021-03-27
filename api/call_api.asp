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
            Set req = Server.CreateObject("MSXML2.ServerXMLHTTP")
			lResolve = 10 * 1000		'도메인 확인 시간, default 무한대
			lConnect = 15 * 1000	'서버와의 연결 시간, default 60 초
			lSend    = 15 * 1000	'데이터 전송 시간, default 30 초
			lReceive = 15 * 1000	'데이터 수신 시간, default 30 초

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

            Run = result
        End Function

    End Class
%>