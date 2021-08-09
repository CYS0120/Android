<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/api/include/db_open.asp"-->
<%
	If GetReferer = GetCurrentHost Then 
	Else 
		orderList = "[]"
		Response.ContentType = "application/json"
		Response.Write orderList
		Response.End 
	End If

    Dim order_idx : order_idx = Request("order_idx")

    If IsEmpty(order_idx) Or IsNull(order_idx) Or Trim(order_idx) = "" Or Not IsNumeric(order_idx) Then order_idx = "" End If

	orderList = "[]"
	orderList_side = ""
	coupon_pin_yn = ""
	menu_use_yn = ""

	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_order_detail_select_main"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing

	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst
		orderList = "["
		Do Until aRs.EOF
			If orderList <> "[" Then orderList = orderList & ","

			orderList = orderList & "{"
			orderList = orderList & """order_idx"":" & aRs("order_idx") & ","
			orderList = orderList & """order_detail_idx"":" & aRs("order_detail_idx") & ","
			orderList = orderList & """menu_idx"":" & aRs("menu_idx") & ","
			orderList = orderList & """menu_option_idx"":" & aRs("menu_option_idx") & ","
			orderList = orderList & """menu_price"":" & aRs("menu_price") & ","
			orderList = orderList & """menu_qty"":" & aRs("menu_qty") & ","
			orderList = orderList & """menu_name"":""" & aRs("menu_name") & ""","
			orderList = orderList & """thumb_file_path"":""" & aRs("thumb_file_path") & ""","
			orderList = orderList & """thumb_file_name"":""" & aRs("thumb_file_name") & """"


			Sql = "Select * From bt_menu with(NOLOCK) Where menu_idx = '" & aRs("menu_idx") &"'"
			Set Rinfo = dbconn.Execute(Sql)
			If Rinfo.eof Then 
			else
				if Rinfo("use_yn") <> "Y" then 
					menu_use_yn = "Y"
				end if 
			End If


			if trim(aRs("coupon_pin")) <> "" then 
				coupon_pin_yn = "Y"
			end if 


				orderList_side = ""

				Set aCmd = Server.CreateObject("ADODB.Command")
				With aCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_order_detail_select_side"

					.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
					.Parameters.Append .CreateParameter("@upper_order_detail_idx", adInteger, adParamInput, , aRs("order_detail_idx"))

					Set aRs_sub = .Execute
				End With
				Set aCmd = Nothing

				If Not (aRs_sub.BOF Or aRs_sub.EOF) Then
					aRs_sub.MoveFirst

					Do Until aRs_sub.EOF
						if orderList_side = "" then 
							orderList_side = ", ""side"":["
						else
							orderList_side = orderList_side & ", "
						end if 

						orderList_side = orderList_side & "{"
						orderList_side = orderList_side & """order_idx"":" & aRs_sub("order_idx") & ","
						orderList_side = orderList_side & """order_detail_idx"":" & aRs_sub("order_detail_idx") & ","
						orderList_side = orderList_side & """menu_idx"":" & aRs_sub("menu_idx") & ","
						orderList_side = orderList_side & """menu_option_idx"":" & aRs_sub("menu_option_idx") & ","
						orderList_side = orderList_side & """menu_price"":" & aRs_sub("menu_price") & ","
						orderList_side = orderList_side & """menu_qty"":" & aRs_sub("menu_qty") & ","
						orderList_side = orderList_side & """menu_name"":""" & aRs_sub("menu_name") & """"
						orderList_side = orderList_side & "}"



						Sql = "Select * From bt_menu (NOLOCK) Where menu_idx = '" & aRs_sub("menu_idx") &"'"
						Set Rinfo = dbconn.Execute(Sql)
						If Rinfo.eof Then 
						else
							if Rinfo("use_yn") = "Y" then 
								menu_use_yn = "Y"
							end if 
						End If


						aRs_sub.MoveNext
					Loop

					orderList_side = orderList_side & "]"

					orderList = orderList & orderList_side
				End If

				Set aRs_sub = Nothing



			orderList = orderList & "}"

			aRs.MoveNext
		Loop
		orderList = orderList & "]"
	End If

	Set aRs = Nothing

	if coupon_pin_yn = "Y" then 
		orderList = "{""result"":""0001"",""message"":""E-쿠폰으로 구매한 상품이 있을경우 다시담기를 할 수 없습니다.""}"
	end if 

	if menu_use_yn = "Y" then 
		orderList = "{""result"":""0001"",""message"":""판매중지된 상품이 존재합니다. 다시담기를 할 수 없습니다.""}"
	end if 

    Response.Write orderList
%>