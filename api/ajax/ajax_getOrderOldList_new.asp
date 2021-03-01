<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/g2.asp"-->
<%
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
    If Request.ServerVariables("HTTPS") = "on" Then
        GetUrlProtocol = "https"
    Else
        GetUrlProtocol = "http"
    End If
	GetUrlHost = Request.ServerVariables("HTTP_HOST")
    GetCurrentHost = GetUrlProtocol & "://" & GetUrlHost

	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
		orderList = "[]"
		Response.ContentType = "application/json"
		Response.Write orderList
		Response.End 
	End If

	orderList = "[]"

    pageSize = Request("pageSize")
    curPage = Request("curPage")

    If IsEmpty(pageSize) Or IsNull(pageSize) Or Trim(pageSize) = "" Or Not IsNumeric(pageSize) Then pageSize = 10
    If IsEmpty(curPage) Or IsNull(curPage) Or Trim(curPage) = "" Or Not IsNumeric(curPage) Then curPage = 1

    If Session("userIdNo") <> "" Then
		Set aCmd = Server.CreateObject("ADODB.Command")
		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_member_addr_select_page"

			.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
            .Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
            .Parameters.Append .CreateParameter("@curPage", adInteger, adParamInput, ,curPage)

			Set aRs = .Execute
		End With
		Set aCmd = Nothing


        If Not (aRs.BOF Or aRs.EOF) Then
            aRs.MoveFirst
            orderList = "["
            Do Until aRs.EOF
                If orderList <> "[" Then orderList = orderList & ","

                orderList = orderList & "{"
                orderList = orderList & """is_main"":""" & aRs("is_main") & ""","
                orderList = orderList & """address_main"":""" & aRs("address_main") & ""","
                orderList = orderList & """address_detail"":""" & aRs("address_detail") & ""","
                orderList = orderList & """addr_idx"":""" & aRs("addr_idx") & """"
                orderList = orderList & "}"

                aRs.MoveNext
            Loop
            orderList = orderList & "]"
        End If

        Set aRs = Nothing
    End If

    Response.Write orderList
%>