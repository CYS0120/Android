<!--#include virtual="/api/include/utf8.asp"-->
<%
	If GetReferer = GetCurrentHost Then 
	Else 
'		Response.Write "{""result"":1,""message"":""잘못된 접근방식 입니다."",""totalCount"":0,data:[]}"
'		Response.End 
	End If

    brand_code = GetReqStr("brand_code","")
    bbs_code = GetReqStr("bbs_code","")
    gotoPage = GetReqNum("gotoPage", 1)
    pageSize = GetReqNum("pageSize", 10)
    eventGbn = GetReqStr("eventGbn","OPEN")

	' ★★★★★★★★★★★★★★ 삭제해야됨 ★★★★★★★★★★★★★★★★★★★★★
'	if eventGbn = "OPEN" then 
'		eventGbn  = "CLOSE"
'		eventGbn_YN = "Y"
'	end if 
	' ★★★★★★★★★★★★★★ // 삭제해야됨 ★★★★★★★★★★★★★★★★★★★★★

    If brand_code = "" Or bbs_code = "" Then
        Response.Write "{""result"":1,""message"":""정보가 불확실합니다."",""totalCount"":0,data:[]}"
        Response.End
    End If

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_board_select"

        .Parameters.Append .CreateParameter("@gubun", adVarChar, adParamInput, 10, "LIST")
        .Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 2, brand_code)
        .Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, bbs_code)
		.Parameters.Append .CreateParameter("@event", adVarChar, adParamInput, 10, eventGbn)
        .Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput,, pageSize)
        .Parameters.Append .CreateParameter("@page", adInteger, adParamInput, , gotoPage)
        .Parameters.Append .CreateParameter("@TotalCount", adInteger, adParamOutput)

        Set rs = .Execute

        TotalCount = .Parameters("@TotalCount").Value
    End With
    Set cmd = Nothing

    ' TotalCount = 10
    ' Cnt = 1
    If Not (rs.BOF Or rs.EOF) Then
        result = ""
        Do Until rs.EOF

            temp = ""

            If temp <> "" Then temp = temp & ","
            temp = temp & """BIDX"":" & rs("BIDX")
            If temp <> "" Then temp = temp & ","
            temp = temp & """brand_code"":""" & rs("brand_code") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """bbs_code"":""" & rs("bbs_code") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """top_fg"":""" & rs("top_fg") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """sdate"":""" & rs("sdate") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """edate"":""" & rs("edate") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """edate_fg"":""" & rs("edate_fg") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """title"":""" & Replace(rs("title"),"""","\""") & """"
            If temp <> "" Then temp = temp & ","
'            temp = temp & """contents"":""" & Replace(rs("contents"),"""","\""") & """"
            temp = temp & """contents"":""" & replace(Replace(rs("contents"),"""","\"""),chr(13)&chr(10),"") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """subtitle"":""" & Replace(rs("subtitle"),"""","\""") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """url_link"":""" & rs("url_link") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """etcdate_fg"":""" & rs("etcdate_fg") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """etcdate"":""" & rs("etcdate") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """imgpath"":""" & rs("imgpath") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """imgname"":""" & rs("imgname") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """filepath"":""" & rs("filepath") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """filename"":""" & rs("filename") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """open_fg"":""" & rs("open_fg") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """hit"":" & rs("hit")
            If temp <> "" Then temp = temp & ","
            temp = temp & """reg_name"":""" & rs("reg_name") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """reg_user_idx"":" & rs("reg_user_idx")
            If temp <> "" Then temp = temp & ","
            temp = temp & """reg_date"":""" & rs("reg_date") & """"
            If temp <> "" Then temp = temp & ","
            temp = temp & """reg_ip"":""" & rs("reg_ip") & """"
            If temp <> "" Then temp = temp & ","
            If rs("mod_user_idx") <> "" Then
                temp = temp & """mod_user_idx"":" & rs("mod_user_idx")
            Else
                temp = temp & """mod_user_idx"":null"
            End If

'            If temp <> "" Then temp = temp & ","
'            If rs("mod_date") <> "" Then
'                temp = temp & """mode_date"":""" & rs("mode_date") & """"
'            Else
'                temp = temp & """mode_date"":null"
'            End If



	' ★★★★★★★★★★★★★★ 복구 ★★★★★★★★★★★★★★★★★★★★★
            If temp <> "" Then temp = temp & ","
            temp = temp & """eventGbn"":""" & eventGbn & """"
	' ★★★★★★★★★★★★★★ //복구 ★★★★★★★★★★★★★★★★★★★★★



			' ★★★★★★★★★★★★★★ 삭제해야됨 ★★★★★★★★★★★★★★★★★★★★★
'			if eventGbn_YN = "Y" then 
'				eventGbn = "OPEN"
'				If temp <> "" Then temp = temp & ","
'				temp = temp & """eventGbn"":""" & eventGbn & """"
'			end if 
			' ★★★★★★★★★★★★★★ // 삭제해야됨 ★★★★★★★★★★★★★★★★★★★★★



            If temp <> "" Then temp = temp & ","
            If rs("mod_ip") <> "" Then
                temp = temp & """mod_ip"":""" & rs("mod_ip") & """"
            Else
                temp = temp & """mod_ip"":null"
            End If

            temp = "{" & temp & "}"

            If result <> "" Then result = result & ","

            result = result & temp

            ' If Cnt < 10 Then
            '     Cnt = Cnt + 1
            ' Else
            rs.MoveNext
            ' End If
        Loop

        result = "[" & result & "]"

        Response.Write "{""result"":0,""message"":""검색되었습니다."",""totalCount"":" & TotalCount & ", ""data"":" & result & "}"
    Else
        Response.Write "{""result"":2,""message"":""결과가 없습니다."",""totalCount:0,, data:[]}"
    End If
    Set rs = Nothing
%>