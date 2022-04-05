<!--#include virtual="/api/include/utf8.asp"-->
<%
	'API KEY 검색
	dim api_sql, api_key, api_result

	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
        api_sql = "EXEC bp_daum_coord"
        api_key = "" 

        set rs_api = dbconn.execute(api_sql)
        If Not (rs_api.BOF Or rs_api.EOF) Then
            api_key = rs_api("COORD_API_KEY")
        End If 
        set rs_api = nothing 

        If api_key <> "" Then
            api_result = "{""result"":0,""message"":""" & api_key & """}"
        Else
            api_result = "{""result"":1,""message"":""검색된 결과가 없습니다.""}"
        End If
	Else 
		api_result = "{""result"":1,""message"":""잘못된 접근방식 입니다.""}"
	End If

	Response.Write api_result
%>