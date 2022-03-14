<%
	' 상품권 사용처리를 위한 상품권번호 조회
	giftcard_serial  = "" 
	dim giftcardAmt_serial : giftcardAmt_serial = ""
	dim pay_transaction_id : pay_transaction_id = ""
	Set pCmd = Server.CreateObject("ADODB.Command")
	With pCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_payment_detail_select_pg"

		.Parameters.Append .CreateParameter("@order_num", advarchar, adParamInput, 40, order_num)
		.Parameters.Append .CreateParameter("@pay_method", advarchar, adParamInput, 20, "GIFTCARD")

		Set pRs = .Execute
	End With
	Set pCmd = Nothing

	Do until pRs.EOF
		pay_transaction_id = pRs("pay_transaction_id")
		if Len(pay_transaction_id) >= 12 then
			pay_detail_idx     = pRs("pay_detail_idx")
			pay_amt            = pRs("pay_amt")
			giftcard_serial    = giftcard_serial    & pay_transaction_id & "||"
			giftcardPdx_serial = giftcardPdx_serial & pay_detail_idx     & "||"
			giftcardAmt_serial = giftcardAmt_serial & pay_amt            & "||"
		end if 
		
		pRs.MoveNext
	Loop
	set pRs = Nothing

	if giftcard_serial <> "" then 
		giftcard_serial    = Left(giftcard_serial,    Len(giftcard_serial)-2)
		giftcardPdx_serial = Left(giftcardPdx_serial, Len(giftcardPdx_serial)-2)
		giftcardAmt_serial = Left(giftcardAmt_serial, Len(giftcardAmt_serial)-2)
	end if 
	'// 상품권 사용처리를 위한 상품권번호 조회

	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','" & giftcard_serial & "','','inc_giftcard_use-start')"
	dbconn.Execute(Sql)

	' 상품권 1장씩 사용 처리 
	dim jsonGiftcard : jsonGiftcard = ""
	dim arrGiftcard : arrGiftcard = split(giftcard_serial, "||") ' 상품권 번호 
	dim arrGiftcardPdx : arrGiftcardPdx = split(giftcardPdx_serial, "||") ' pay_detail_idx  
	dim arrGiftcardAmt : arrGiftcardAmt = split(giftcardAmt_serial, "||") ' 상품권 금액  
	dim arrGiftcardErr : arrGiftcardErr = split(giftcard_serial, "||") ' Error 상품권 번호 
	dim arrGiftcardMsg : arrGiftcardMsg = split(giftcard_serial, "||") ' Error 상품권 내용 
    
	dim giftcardErrAmt : giftcardErrAmt = 0
	dim giftcardAmt : giftcardAmt = 0

	For i = 0 To Ubound(arrGiftcard)
		arrGiftcardErr(i) = ""
		arrGiftcardMsg(i) = ""
				   
		If arrGiftcard(i) <> "" Then 
			jsonGiftcard = "{ ""SRV"":""HOMEPAGE"",""GIFTCARD"":["
			jsonGiftcard = jsonGiftcard & "{""SN"":""" & arrGiftcard(i) & """}"
			jsonGiftcard = jsonGiftcard & "]}"
		
			' 상품권 조회
			Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")  '(2022.2.25 변경) CreateObject("MSXML2.ServerXMLHTTP")
			httpRequest.Open "POST", "http://api-2.bbq.co.kr/api/VoucherInfo/", False
			httpRequest.SetRequestHeader "Authorization", "BF84B3C90590"  
			httpRequest.SetRequestHeader "Content-Type", "application/json"
			httpRequest.Send jsonGiftcard 
			'// 상품권 조회
					
			Sql = " INSERT INTO bt_giftcard_log(source_id, order_num, giftcard_no, api_nm, in_param, out_param, MA_RTN_CD, MA_RTN_MSG, regdate) " _
				& " VALUES ( '" & Request.ServerVariables("PATH_INFO") & "', '"& order_num &"','"& arrGiftcard(i) &"','http://api-2.bbq.co.kr/api/VoucherInfo/','"& jsonGiftcard &"','"& httpRequest.responseText &"','"& "" &"','"& "" &"', GETDATE() ) "
			dbconn.Execute(Sql)

			'조회 상품권 text -> json
			Set oJSON = New aspJSON

			postResponse = "{""list"" : " & httpRequest.responseText & "}"
            Set httpRequest = Nothing
			oJSON.loadJSON(postResponse)
			Set this = oJSON.data("list")

			MA_RTN_CD  = this.item("Voucher_INFO").item("MA_RTN_CD") '  
			MA_RTN_MSG = this.item("Voucher_INFO").item("MA_RTN_MSG") ' 사용여부
			'// 조회 상품권 text -> json

			If MA_RTN_CD = "0000" Then 	'정상적으로 조회 완료
				arrGiftcard(i) = this.item("Voucher_INFO").item("data").item(0).item("SN")

				MA_RTN_CD = "" 

				If arrGiftcard(i) <> "" Then 
					jsonGiftcard = "{ ""U_CD_BRAND"":""" & brand_code & """," _
									& """U_CD_PARTNER"":""" & branch_id & """," _
									& """ORDER_ID"":""" & order_num & """," _
									& """SRV"":""HOMEPAGE""," _
									& """GIFTCARD"":["				                   
					jsonGiftcard = jsonGiftcard & "{""SN"":""" & arrGiftcard(i) & """, ""AMT"":""" & arrGiftcardAmt(i) & """}"
					jsonGiftcard = jsonGiftcard & "]}" 

					' 상품권 사용
					Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")  '(2022.2.25 변경) CreateObject("MSXML2.ServerXMLHTTP")
					httpRequest.Open "POST", "http://api-2.bbq.co.kr/api/VoucherUse/", False
					httpRequest.SetRequestHeader "Authorization", "BF84B3C90590"  
					httpRequest.SetRequestHeader "Content-Type", "application/json"
					httpRequest.Send jsonGiftcard 
					'// 상품권 사용
					
					Sql = " INSERT INTO bt_giftcard_log(source_id, order_num, giftcard_no, api_nm, in_param, out_param, MA_RTN_CD, MA_RTN_MSG, regdate) " _
						& " VALUES ( '" & Request.ServerVariables("PATH_INFO") & "', '"& order_num &"','"& arrGiftcard(i) &"','http://api-2.bbq.co.kr/api/VoucherUse/','"& jsonGiftcard &"','"& httpRequest.responseText &"','"& "" &"','"& "" &"', GETDATE() ) "
					dbconn.Execute(Sql)
					
					'사용 상품권 text -> json
					Set gJSON = New aspJSON
					gpostResponse = "{""list"" : " & httpRequest.responseText & "}" 
            		Set httpRequest = Nothing

					gJSON.loadJSON(gpostResponse)
					Set this = gJSON.data("list") 
					
					MA_RTN_CD  = this.item("Voucher_Use").item("MA_RTN_CD") '  
					MA_RTN_MSG = this.item("Voucher_Use").item("MA_RTN_MSG") ' 사용여부
					'// 사용 상품권 text -> json	
					 
                     
					If MA_RTN_CD = "0000" THEN 
						Set this1 = this.item("Voucher_Use").item("data").item(0) '1건 사용이라서 item(0)
						Set pCmd = Server.CreateObject("ADODB.Command")
						With pCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_giftcard_status"
			
							.Parameters.Append .CreateParameter("@mode"           , adVarChar, adParamInput, 30,"giftcard_use"       )
							.Parameters.Append .CreateParameter("@order_num"      , adVarChar, adParamInput,100, order_num           )
							.Parameters.Append .CreateParameter("@giftcard_number", adVarChar, adParamInput,100, this1.item("SN")    )
							.Parameters.Append .CreateParameter("@u_cd_brand"     , adVarChar, adParamInput, 10, brand_code          )
							.Parameters.Append .CreateParameter("@u_cd_partner"   , adVarChar, adParamInput, 50, branch_id           )
							.Parameters.Append .CreateParameter("@ok_num"         , adVarChar, adParamInput, 50, this1.item("OK_NUM"))
							.Execute
						End With
						Set pCmd = Nothing
                        
						giftcardAmt = giftcardAmt + arrGiftcardAmt(i)
					Else   
						'사용처리 결과 비정상 상품권
						arrGiftcardErr(i) = this.item("Voucher_Use").item("data").item(0).item("SN") '1건 조회라서 item(0)
						arrGiftcardMsg(i) = this.item("Voucher_Use").item("data").item(0).item("RTN_MSG")
						giftcardErrAmt = giftcardErrAmt + arrGiftcardAmt(i) 
					End If '// If MA_RTN_CD = "0000" THEN  
				end if 
			Else
				'사용불가 상품권
				arrGiftcardErr(i) = this.item("Voucher_INFO").item("data").item(0).item("SN") '1건 조회라서 item(0)
				arrGiftcardMsg(i) = this.item("Voucher_INFO").item("data").item(0).item("RTN_MSG")
				giftcardErrAmt = giftcardErrAmt + arrGiftcardAmt(i) 
			end if 
		End If
	Next
	'// 상품권 1장씩 사용 처리 

	dim giftcardErr_serial : giftcardErr_serial = "" 

	'에러 상품권 처리 
	For i = 0 To Ubound(arrGiftcardErr)
		if arrGiftcardErr(i) <> "" and len(arrGiftcardErr(i)) >= 12 then 
			giftcardErr_serial = giftcardErr_serial & arrGiftcardErr(i) & "||" 

			Set pCmd = Server.CreateObject("ADODB.Command")
			With pCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_payment_detail_err_insert"

				.Parameters.Append .CreateParameter("@order_idx",      adInteger, adParamInput, , order_idx)
				.Parameters.Append .CreateParameter("@pay_detail_idx", adInteger, adParamInput, , arrGiftcardPdx(i))
				.Parameters.Append .CreateParameter("@pay_err_msg",    advarchar, adParamInput, 1000, arrGiftcardMsg(i))

				.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
				.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

				.Execute

				errCode = .Parameters("@ERRCODE").Value
				errMsg = .Parameters("@ERRMSG").Value
			End With
			Set pCmd = Nothing
		end if 
	Next 
	'//에러 상품권 처리 
    
	if giftcardErr_serial <> "" then 
		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','/giftcardErr_serial : "& giftcardErr_serial &"/discount_amt : "& cstr(giftcardAmt) &"','" & giftcardAmt & "','Giftcard_use-err')"
		dbconn.Execute(Sql)
	end if 
%>