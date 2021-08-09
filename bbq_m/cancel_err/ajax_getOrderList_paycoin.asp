<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/g2.asp"-->
<%
	If GetReferer = GetCurrentHost Then 
	Else 
'		orderList = "[]"
'		Response.ContentType = "application/json"
'		Response.Write orderList
'		Response.End 
	End If

	orderList = "[]"

    pageSize = Request("pageSize")
    curPage = Request("curPage")
    cmobile = Request("cmobile")

    If IsEmpty(pageSize) Or IsNull(pageSize) Or Trim(pageSize) = "" Or Not IsNumeric(pageSize) Then pageSize = 10
    If IsEmpty(curPage) Or IsNull(curPage) Or Trim(curPage) = "" Or Not IsNumeric(curPage) Then curPage = 1




'	sql = ""
'	sql = sql & " SELECT "
'	sql = sql & "     *, t1.order_num as order_num_plus "
'	sql = sql & " FROM bt_paycoin_log T1 WITH(NOLOCK) "
'	sql = sql & " INNER JOIN TB_WEB_ORDER_STATE T2 WITH(NOLOCK) "
'	sql = sql & "     ON T2.order_id = T1.order_num AND T2.state = 'M' "
'	sql = sql & " INNER JOIN ( "
'	sql = sql & "     SELECT "
'	sql = sql & "         * "
'	sql = sql & "     FROM TMP_PAY_ERROR_DANALCARD WITH(NOLOCK) "
'	sql = sql & "     WHERE RESULT_DTS BETWEEN '2020-10-22 11:00' AND '2020-10-23 11:00' "
'	sql = sql & "         AND RESULT_MSG = 'SUCC' "
'	sql = sql & "         AND PAY_TP = 'Paycoin' "
'	sql = sql & " ) T3 "
'	sql = sql & "     ON T3.tid = T1.tid AND T3.cpid = T1.cpid "
'	sql = sql & " where replace(delivery_mobile, '-', '') = '"& cmobile &"' "
'	sql = sql & " ORDER BY T1.TID, T1.regdate, T1.order_num "

	sql = ""
	sql = sql & " SELECT "
	sql = sql & "     T1.order_num AS ORDER_ID, T3.BRANCH_ID, T4.branch_name, T5.phone_region+T5.phone AS HP, T1.amt as AMT "
	sql = sql & " FROM bt_paycoin_log T1 WITH(NOLOCK) "
	sql = sql & " INNER JOIN TB_WEB_ORDER_STATE T2 WITH(NOLOCK) "
	sql = sql & "     ON T2.order_id = T1.order_num AND T2.state = 'M' "
	sql = sql & " INNER JOIN TB_WEB_ORDER_MASTER T5 WITH(NOLOCK) "
	sql = sql & "     ON T5.order_id = T1.order_num "
	sql = sql & " INNER JOIN ( "
	sql = sql & "     SELECT "
	sql = sql & "         * "
	sql = sql & "     FROM TMP_PAY_ERROR_DANALCARD WITH(NOLOCK) "
	sql = sql & "     WHERE RESULT_DTS BETWEEN '2020-10-22 11:00' AND '2020-10-23 11:00' "
	sql = sql & "         AND RESULT_MSG = 'SUCC' "
	sql = sql & "         AND PAY_TP = 'Paycoin' "
	sql = sql & " ) T3 "
	sql = sql & "     ON T3.tid = T1.tid AND T3.cpid = T1.cpid "
	sql = sql & " INNER JOIN bt_branch T4 WITH(NOLOCK) "
	sql = sql & "     ON T4.brand_code = '01' AND T4.branch_id = T3.BRANCH_ID "
	sql = sql & " where T5.phone_region+T5.phone = '"& Replace(cmobile, "-", "") &"' "
	sql = sql & " ORDER BY T1.TID, T1.regdate, T1.order_num "


	Set aRs2 = dbconn.Execute(sql)


	If Not (aRs2.BOF Or aRs2.EOF) Then
		aRs2.MoveFirst
		orderList = "["
		Do Until aRs2.EOF

			If orderList <> "[" Then orderList = orderList & ","

			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_order_select_one_member_paycoin"

				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , "0")
				.Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput, 50, aRs2("ORDER_ID"))
				.Parameters.Append .CreateParameter("@nomember_hp", adVarChar, adParamInput, 20, cmobile)

				Set aRs = .Execute
			End With
			Set aCmd = Nothing

			If Not (aRs.BOF Or aRs.EOF) Then

				orderList = orderList & "{"

				sql = ""
				sql = sql & " select * from BT_ORDER_PAYCOIN_REPAY where order_id='"& aRs2("ORDER_ID") &"' "
				Set aRs3 = dbconn.Execute(sql)
				If Not (aRs3.BOF Or aRs3.EOF) Then
					aRs3.MoveFirst
					orderList = orderList & """REPAY_STATUS"":""" & aRs3("REPAY_STATUS") & ""","
				End If 





				order_view_html = ""
				Sql = "EXEC UP_ORDER_MYMENU_5_paycoin '"& aRs2("ORDER_ID") &"'"
				Set oRs = dbconn.Execute(Sql)
				If Not oRs.Eof Then 
					Do While Not oRs.Eof
						If oRs("M_CSER2") = "1" Then
							If oRs("LIST_TYPE") = "ORDER" Then
								order_view_html = order_view_html & "<tr><th>상품명</th><th>단가</th><th>수량</th><th>금액</th></tr>"
'								orderList = orderList & """order_view_html"":""<tr><th>상품명</th><th>단가</th><th>수량</th><th>금액</th></tr>"","
							ElseIf oRs("LIST_TYPE") = "PAY" Then
								order_view_html = order_view_html & "<tr><th>결제방법</th><th>&nbsp;</th><th>&nbsp;</th><th>금액</th></tr>"
'								orderList = orderList & """order_view_html"":""<tr><th>결제방법</th><th>&nbsp;</th><th>&nbsp;</th><th>금액</th></tr>"","
							End If
						End If
						MENU_NM = oRs("MENU_NM")
						FPRC = oRs("M_FPRC")
						FQTY = oRs("M_FQTY")
						FAMT = oRs("M_FAMT")

						Select Case STATE
							Case "P"
								STATETYPE = "변경가능"
							Case "N"
								STATETYPE = "신규주문"
							Case "M"
								STATETYPE = "주문적용"
							Case "C"
								STATETYPE = "취소요청"
							Case "B"
								STATETYPE = "주문취소"
							Case "Z"
								STATETYPE = "매장취소"
							Case "X"
								STATETYPE = "에러"
						End Select

						If oRs("M_CSER2") = "99" Then
							rowBgColor = "#faf4c0"
							rowColor = "#000000"
						ElseIf oRs("MENU_NM") = "현장결제" Then
							rowBgColor = "#f9808b"
							rowColor = "#000000"
						Else
							rowBgColor = "#FFFFFF"
							rowColor = "#000000"
						End If

						order_view_html = order_view_html & "<tr><td>"& MENU_NM &"</td><td>"& FormatNumber(FPRC, 0) &"원</td><td>"& FQTY &"</td><td>"& FormatNumber(FAMT, 0) &"원</td></tr>"
'						orderList = orderList & """order_view_html"":""<tr><td>"& MENU_NM &"</td><td>"& FormatNumber(FPRC, 0) &"원</td><td>"& FQTY &"</td><td>"& FormatNumber(FAMT, 0) &"원</td></tr>"","

						oRs.MoveNext
					Loop

					orderList = orderList & """order_view_html"":""" & order_view_html & ""","
				End If 
				oRs.close
				Set oRs = Nothing 





				orderList = orderList & """order_idx"":" & aRs("order_idx") & ","
				orderList = orderList & """order_num"":""" & aRs2("ORDER_ID") & ""","
				orderList = orderList & """amt"":""" & aRs2("AMT") & ""","
				orderList = orderList & """brand_code"":""" & aRs("brand_code") & ""","
				orderList = orderList & """brand_name"":""" & aRs("brand_name") & ""","
				orderList = orderList & """branch_id"":""" & aRs("branch_id") & ""","
				orderList = orderList & """branch_name"":""" & aRs("branch_name") & ""","
				orderList = orderList & """order_date"":""" & aRs("order_date") & ""","
				orderList = orderList & """order_date_time"":""" & aRs("order_date_time") & ""","
				orderList = orderList & """menu_name"":""" & aRs("menu_name") & ""","
'				orderList = orderList & """menu_count"":" & aRs("menu_count") & ","
				orderList = orderList & """order_amt"":" & aRs("order_amt") & ","
				orderList = orderList & """order_type"":""" & aRs("order_type") & ""","
				orderList = orderList & """order_type_name"":""" & aRs("order_type_name") & ""","
				orderList = orderList & """pay_type_name"":""" & aRs("pay_type_name") & ""","
'				orderList = orderList & """order_status"":""" & aRs("state") & ""","
				orderList = orderList & """order_status_class"":""" & order_status_class(aRs("order_type"), aRs("order_status_name")) & ""","
				orderList = orderList & """order_status_name"":""" & order_status_txt(aRs("order_type"), aRs("order_status_name")) & ""","
				orderList = orderList & """order_step"":""" & aRs("order_step") & ""","
				orderList = orderList & """addr_idx"":""" & aRs("addr_idx") & ""","
'				orderList = orderList & """membership_yn_code"":""" & aRs("membership_yn_code") & ""","
				orderList = orderList & """branch_tel"":""" & aRs("branch_tel") & ""","
'				orderList = orderList & """wgs84_x"":""" & aRs("wgs84_x") & ""","
'				orderList = orderList & """wgs84_y"":""" & aRs("wgs84_y") & ""","
				orderList = orderList & """delivery_zipcode"":""" & aRs("delivery_zipcode") & ""","
				orderList = orderList & """delivery_address"":""" & aRs("delivery_address") & ""","
				orderList = orderList & """delivery_address_detail"":""" & aRs("delivery_address_detail") & ""","
				orderList = orderList & """delivery_time"":""" & aRs("delivery_time") & """"
				orderList = orderList & "}"

			End If 

			Set aRs = Nothing

			aRs2.MoveNext
		Loop
		orderList = orderList & "]"
	End If

	Set aRs2 = Nothing

    Response.Write orderList
%>