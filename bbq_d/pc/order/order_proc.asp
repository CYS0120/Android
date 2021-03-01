<!--#include virtual="/api/include/utf8.asp"-->
<%
    Dim addr_idx, branch_id, cart_value, delivery_fee, pay_method, total_amount
    Dim addr_name, mobile, zip_code, address_main, address_detail, delivery_message
    Dim reg_ip

    reg_ip = Request.ServerVariables("REMOTE_ADDR")

    addr_idx = GetReqNum("addr_idx","")
    branch_id = GetReqStr("branch_id","")
    cart_value = GetReqStr("cart_value","")
    delivery_fee = GetReqStr("delivery_fee","")
    order_type = GetReqStr("order_type","")
    pay_method = GetReqStr("pay_method","")

    addr_name = GetReqStr("addr_name","")
    mobile = GetReqStr("mobile","")
    zip_code = GetReqStr("zip_code", "")
    address_main = GetReqStr("address_main","")
    address_detail = GetReqStr("address_detail","")
    delivery_message = GetReqStr("delivery_message","")

    total_amount = GetReqStr("total_amt","")
    coupon_amt = GetReqNum("coupon_amt",0)
    use_point = GetReqStr("use_point", 0)

    discount_amt = GetReqNum("dc_amt",0)
    pay_amt = GetReqNum("pay_amt",0)

    save_point = GetReqStr("save_point", "")
    bbq_card = GetReqStr("bbq_card","")

    If order_type = "" Or (order_type = "D" And (addr_idx = "" Or branch_id = "")) Or (order_type = "P" And branch_id = "") Or cart_value = "" Or pay_method = "" Or total_amount = "" Then
%>
    <script type="text/javascript">
        alert("잘못된 접근입니다.");
    </script>
<%
        Response.End
    End If

    If order_type = "P" And addr_idx = "" Then addr_idx = 0
    ' Response.Write cart_value

    Dim aCmd, aRs

    Dim cJson : Set cJson = JSON.Parse(cart_value)

    Dim order_item, order_idx, order_num, errCode, errMsg

    Dim mmid, mmtype, mmidno

    If Session("userIdNo") <> "" Then
        mmid = Session("userIdx")
        mmtype = "Member"
        mmidno = Session("userIdNo")
    Else
        Randomize Timer
        mmid = 0
        mmtype = "NonMember"
        mmidno = "P" & Round(( Rnd * 10000000 ), 0)
    End If

    Set aCmd = Server.CreateObject("ADODB.Command")

    With aCmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_order_insert"

        .Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, "W")
        .Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 10, "01")
        .Parameters.Append .CreateParameter("@member_id", adInteger, adParamInput,, mmid)
        .Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, mmtype)
        .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, mmidno)
        .Parameters.Append .CreateParameter("@branch_id", adInteger, adParamInput, , branch_id)
        ' .Parameters.Append .CreateParameter("@order_status", adVarChar, adParamInput, 10, "")
        .Parameters.Append .CreateParameter("@order_type", adVarChar, adParamInput, 10, order_type)
        .Parameters.Append .CreateParameter("@pay_type", adVarChar, adParamInput, 20, pay_method)
        .Parameters.Append .CreateParameter("@order_amt", adCurrency, adParamInput,,total_amount)
        .Parameters.Append .CreateParameter("@delivery_fee", adCurrency, adParamInput,,delivery_fee)
        .Parameters.Append .CreateParameter("@discount_amt", adCurrency, adParamInput,,discount_amt)
        .Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, pay_amt)
        ' .Parameters.Append .CreateParameter("@order_date", adVarChar, adParamInput, 20, "")
        ' .Parameters.Append .CreateParameter("@delivery_date", adVarChar, adParamInput, 20, "")
        .Parameters.Append .CreateParameter("@order_channel", adVarChar, adParamInput, 10, "2")
        .Parameters.Append .CreateParameter("@addr_idx", adInteger, adParamInput, , addr_idx)
        .Parameters.Append .CreateParameter("@delivery_zipcode", adVarChar, adParamInput, 10, zip_code)
        .Parameters.Append .CreateParameter("@delivery_address", adVarChar, adParamInput, 500, address_main)
        .Parameters.Append .CreateParameter("@delivery_address_detail", adVarChar, adParamInput, 500, address_detail)
        .Parameters.Append .CreateParameter("@delivery_mobile", adVarChar, adParamInput, 20, mobile)
        .Parameters.Append .CreateParameter("@delivery_message", adVarChar, adParamInput, 1000, delivery_message)
        .Parameters.Append .CreateParameter("@coupon_idx", adInteger, adParamInput,, 0)
        .Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 30, reg_ip)
        ' .Parameters.Append .CreateParameter("@order_item", adVarChar, adParamInput, 2000, order_item)
        .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamOutput)
        .Parameters.Append .CreateParameter("@order_num", adVarChar, adParamOutput, 50)
        .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
        .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

        .Execute

        order_idx = .Parameters("@order_idx").Value
        order_num = .Parameters("@order_num").Value
        errCode = .Parameters("@ERRCODE").Value
        errMsg = .Parameters("@ERRMSG").Value

    End With

    Set aCmd = Nothing

    If order_idx = 0 Then
        Response.Write "{""result"":1, ""result_msg"":""주문이 실패하였습니다.""}"
        Response.End
    End If

    Dim iLen : iLen = cJson.length

    Dim order_detail_idx, upper_order_detail_idx

    Dim dd : dd = FormatDateTime(Now, 2)
    Dim dt : dt = FormatDateTime(Now, 4)

    For i = 0 To iLen - 1
        ' If order_item <> "" Then order_item = order_item & ";"
        upper_order_detail_idx = 0

        Set aCmd = Server.CreateObject("ADODB.Command")
        With aCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_detail_insert"

            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
            .Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , cJson.get(i).value.idx)
            .Parameters.Append .CreateParameter("@menu_option_idx", adInteger, adParamInput, , cJson.get(i).value.opt)
            .Parameters.Append .CreateParameter("@menu_qty", adInteger, adParamInput,, cJson.get(i).value.qty)
            .Parameters.Append .CreateParameter("@coupon_idx", adInteger, adParamInput, , 0)
            .Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 30, reg_ip)
            .Parameters.Append .CreateParameter("@order_detail_idx", adInteger, adParamOutput)
            .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
            .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

            .Execute

            order_detail_idx = .Parameters("@order_detail_idx").Value
            errCode = .Parameters("@ERRCODE").Value
            errMsg = .Parameters("@ERRMSG").Value
            upper_order_detail_idx = order_detail_idx
        End With
        Set aCmd = Nothing
        ' order_item = order_item & cJson.get(i).value.idx & "_" & cJson.get(i).value.opt &"_" & cJson.get(i).value.qty

        If JSON.hasKey(cJson.get(i).value, "side") Then
            For Each skey In cJson.get(i).value.side.enumerate()

                Set aCmd = Server.CreateObject("ADODB.Command")
                With aCmd
                    .ActiveConnection = dbconn
                    .NamedParameters = True
                    .CommandType = adCmdStoredProc
                    .CommandText = "bp_order_detail_insert"

                    .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
                    .Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , cJson.get(i).value.side.get(skey).idx)
                    .Parameters.Append .CreateParameter("@menu_option_idx", adInteger, adParamInput, , cJson.get(i).value.side.get(skey).opt)
                    .Parameters.Append .CreateParameter("@menu_qty", adInteger, adParamInput,, cJson.get(i).value.side.get(skey).qty)
                    .Parameters.Append .CreateParameter("@coupon_idx", adInteger, adParamInput, , 0)
                    .Parameters.Append .CreateParameter("@upper_order_detail_idx", adInteger, adParamInput,, upper_order_detail_idx)
                    .Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 30, reg_ip)
                    .Parameters.Append .CreateParameter("@order_detail_idx", adInteger, adParamOutput)
                    .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
                    .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

                    .Execute

                    order_detail_idx = .Parameters("@order_detail_idx").Value
                    errCode = .Parameters("@ERRCODE").Value
                    errMsg = .Parameters("@ERRMSG").Value
                End With
                Set aCmd = Nothing

                ' If order_item <> "" Then order_item = order_item & ";"
                ' order_item = order_item &  cJson.get(i).value.side.get(skey).idx & "_" & cJson.get(i).value.side.get(skey).opt & "_" & cJson.get(i).value.side.get(skey).qty
            Next
        End If
    Next

    Response.Write "{""result"":0, ""result_msg"":""주문이 저장되었습니다."", ""order_idx"":"& order_idx &",""order_num"":""" & order_num & """}"


    ' Response.Write order_item
%>
