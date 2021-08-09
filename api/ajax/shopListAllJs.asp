<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/api/include/db_open.asp"-->
<%
	If GetReferer = GetCurrentHost Then 
	Else 
		result = "[]"
		Response.ContentType = "application/json"
		Response.Write result
		Response.End 
	End If

    Dim result, aCmd, rs

    Dim lat : lat = Request("lat")
    Dim lng : lng = Request("lng")
    Dim schVal : schVal = Request("search_text")

    If IsEmpty(lat) Or IsNull(lat) Or Trim(lat) = "" Or Not IsNumeric(lat) Then lat = "" End If

    If lat = "" Then
        result = "[]"
    Else
        Set aCmd = Server.CreateObject("ADODB.Command")

        With aCmd
            .ActiveConnection = dbconn
            ' .NamedParameters = True
            .CommandType = adCmdText
            ' .CommandText = "exec bp_branch_select_distance_near "&lat &", "&lng 
            .CommandText = "exec bp_branch_select_distance_near_all "&lat &", "&lng &", '"&schVal &"'" 

            ' .Parameters.Append .CreateParameter("@lat", adDecimal, adParamInput, , lat)
            ' .Parameters.Append .CreateParameter("@lng", adDecimal, adParamInput, , lng)
            
            Set rs = .Execute
        End With
        Set aCmd = Nothing

        result = "["

        Dim i : i = 0
        If Not (rs.BOF Or rs.EOF) Then
            rs.MoveFirst
            Do Until rs.EOF
                If i > 0 Then result = result & ","
                
                result = result & "{"

                result = result & """distance"":" & rs("distance") & " ,"
                result = result & """branch_id"":""" & rs("branch_id") & ""","
                result = result & """branch_name"":""" & rs("branch_name") & ""","
		        result = result & """brand_code"":""" & rs("brand_code") & """ ,"
'		        result = result & """branch_owner_name"":""" & rs("branch_owner_name") & """ ,"
'		        result = result & """branch_phone"":""" & rs("branch_phone") & """ ,"
		        result = result & """branch_tel"":""" & rs("branch_tel") & """ ,"
		        result = result & """branch_address"":""" & rs("branch_address") & """ ,"
		        result = result & """branch_type"":""" & rs("branch_type") & """ ,"
		        result = result & """branch_seats"":""" & rs("branch_seats") & """ ,"
		        result = result & """branch_services"":""" & rs("branch_services") & """ ,"
		        result = result & """branch_weekday_open"":""" & rs("branch_weekday_open") & """ ,"
		        result = result & """branch_weekday_close"":""" & rs("branch_weekday_close") & """ ,"
		        result = result & """close_day"":""" & rs("close_day") & """ ,"
		        result = result & """branch_status"":""" & rs("branch_status") & """ ,"
		        result = result & """wgs84_x"":" & rs("wgs84_x") & " ,"
		        result = result & """wgs84_y"":" & rs("wgs84_y") & " ,"
		        result = result & """online_status"":""" & rs("online_status") & """ ,"
		        result = result & """lunch_box_yn"":""" & rs("lunch_box_yn") & """ ,"
		        result = result & """order_yn"":""" & rs("order_yn") & """ ,"
		        result = result & """membership_yn_code"":""" & rs("membership_yn_code") & """ ,"
		        result = result & """coupon_yn"":""" & rs("coupon_yn") & """ ,"
		        result = result & """yogiyo_yn"":""" & rs("yogiyo_yn") & """ ,"
		        result = result & """cooking_time"":""" & rs("cooking_time") & """ ,"
		        result = result & """chain_id"":""" & rs("chain_id") & """ ,"
		        result = result & """delivery_fee"":" & rs("delivery_fee")
                result = result & "}"
                rs.MoveNext
                i = i + 1
            Loop
        End If

        result  = result & "]"
    End If
    Response.ContentType = "application/json"
    Response.Write result
%>