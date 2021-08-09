<!--#include virtual="/api/include/utf8.asp"-->
<%
	If GetReferer = GetCurrentHost Then 
	Else 
		Response.Write "{}"
		Response.End 
	End If

    Dim branch_id : branch_id = Request("branch_id")

    Dim cmd, rs

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_branch_select"

        .Parameters.Append .CreateParameter("@branch_id", adVarChar, adParamInput, 20, branch_id)

        Set rs = .Execute
    End With
    Set cmd = Nothing

    If Not (rs.BOF or rs.EOF) then
        rs.MoveFirst

        result = "{"

        result = result & " ""branch_id"":""" & rs("branch_id") & """ ,"
        result = result & " ""brand_code"":""" & rs("brand_code") & """ ,"
        result = result & " ""branch_name"":""" & rs("branch_name") & """ ,"
        result = result & " ""branch_owner_name"":""" & rs("branch_owner_name") & """ ,"
        result = result & " ""branch_phone"":""" & rs("branch_phone") & """ ,"
        result = result & " ""branch_tel"":""" & rs("branch_tel") & """ ,"
        result = result & " ""branch_address"":""" & rs("branch_address") & """ ,"
        result = result & " ""branch_type"":""" & rs("branch_type") & """ ,"
        result = result & " ""branch_seats"":""" & rs("branch_seats") & """ ,"
        result = result & " ""branch_services"":""" & rs("branch_services") & """ ,"
        result = result & " ""branch_weekday_open"":""" & rs("branch_weekday_open") & """ ,"
        result = result & " ""branch_weekday_close"":""" & rs("branch_weekday_close") & """ ,"
        result = result & " ""close_day"":""" & rs("close_day") & """ ,"
        result = result & " ""branch_status"":""" & rs("branch_status") & """ ,"
        result = result & " ""wgs84_x"":" & rs("wgs84_x") & " ,"
        result = result & " ""wgs84_y"":" & rs("wgs84_y") & " ,"
        result = result & " ""online_status"":""" & rs("online_status") & """ ,"
        result = result & " ""lunch_box_yn"":""" & rs("lunch_box_yn") & """ ,"
        result = result & " ""order_yn"":""" & rs("order_yn") & """ ,"
        result = result & " ""coupon_yn"":""" & rs("coupon_yn") & """ ,"
        result = result & " ""cooking_time"":""" & rs("cooking_time") & """ ,"
        result = result & " ""chain_id"":""" & rs("chain_id") & """ ,"
        result = result & " ""BREAK_TIME"":""" & rs("BREAK_TIME") & """ ,"
		result = result & " ""add_price_yn"":""" & rs("add_price_yn") & """ ,"
        result = result & " ""delivery_fee"":" & rs("delivery_fee")

        result = result & "}"

    End If

    Response.Write result
%>