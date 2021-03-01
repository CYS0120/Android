<!--#include virtual="/api/include/utf8.asp"-->
<%
    order_idx = GetReqNum("order_idx","")
    order_num = GetReqStr("order_num","")
    pay_method = GetReqStr("pay_method", "")
    domain = GetReqStr("domain","")
    ' point_data = GetReqStr("use_point_data","")

    save_point = GetReqStr("save_point","")
    bbq_card = GetReqStr("bbq_card","")

    If order_idx = "" Or (save_point = "" And bbq_card = "") Then
        Response.Write "{""result"":false,""message"":""정보가 불확실합니다.""}"
    ElseIf save_point = "0" And bbq_card = "[]" Then
        Response.Write "{""result"":true, ""message"":""사용하는 멤버십 없음""}"
    Else
        Set reqC = New clsReqOrderUseListForOrder
        reqC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
        reqC.mMerchantCode = PAYCO_MEMBERSHIP_MERCHANTCODE
        reqC.mMemberNo = Session("userIdNo")
        reqC.mServiceTradeNo = order_num

        total_amount = 0
        '주문 기본정보 조회'
        Set pCmd = Server.CreateObject("ADODB.Command")
        With pCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_select_one_membership"

            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

            Set pRs = .Execute
        End With
        Set pCmd = Nothing

        If Not (pRs.BOF Or pRs.EOF) Then
            ' reqC.mMerchantCode = pRs("branch_id")
            member_idx = pRs("member_id")
            member_idno = pRs("member_idno")
            member_type = pRs("member_type")
            order_amt = pRs("order_amt")
            delivery_fee = pRs("delivery_fee")
            discount_amt = pRs("discount_amt")
        Else
            Response.Write "{""result"":false,""message"":""주문정보가 잘못되었습니다.""}"
            Response.End
        End If

        '주문 상세조회'
        Set pCmd = Server.CreateObject("ADODB.Command")
        With pCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_detail_select"
            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, order_idx)
            Set pRs = .Execute
        End With
        Set pCmd = Nothing

        If Not (pRs.BOF Or pRs.EOF) Then
            pRs.MoveFirst
            Do Until pRs.EOF
                total_amount = total_amount + (pRs("menu_price") * pRs("menu_qty"))

                Set pItem = New clsProductList
                If pRs("upper_order_detail_idx") = 0 Then
                    pitem.mProductClassCd = "M"
                    pItem.mProductClassNm = "메인"
                Else
                    pitem.mProductClassCd = "S"
                    pItem.mProductClassNm = "사이드"
                End If
                pItem.mProductCd = pRs("menu_idx")
                pItem.mProductNm = pRs("menu_name")
                pItem.mTargetUnitPrice = pRs("menu_price")
                pItem.mUnitPrice = pRs("menu_price")
                pItem.mProductCount = pRs("menu_qty")

                reqC.addProductList(pItem)
                pRs.MoveNext
            Loop
        End If

        reqC.mTotalOrderAmount = total_amount

        If save_point > 0 Then
            Set tPL = New clsPointList
            tPL.mAccountTypeCode = "SAVE"
            tPL.mUsePoint = save_point

            reqC.addPointList(tPL)
        End If
        Set pJson = JSON.Parse(bbq_card)
        
        If pJson.length > 0 Then
            For i = 0 To pJson.length - 1
                Set tPL = New clsPointList
                tPL.mAccountTypeCode = "PAY"
                tPL.mUsePoint = pJson.get(i).usePoint
                tPL.mCardNo = pJson.get(i).cardNo

                reqC.addPointList(tPL)
            Next
        End If

        Set resC = OrderUseListForOrder(reqC.toJson())

        If resC.mMessage = "SUCCESS" Then
            'order_idx에 해당하는 pay_idx 있는지 확인.
            '멤버십을 사용하면 멤버십에서 pay_idx 생성되기때문에
            Set pCmd = Server.CreateObject("ADODB.Command")
            With pCmd
                .ActiveConnection = dbconn
                .NamedParameters = True
                .CommandType = adCmdStoredProc
                .CommandText = "bp_order_pay_select"

                .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)

                Set pRs = .Execute
            End With
            Set pCmd = Nothing

            If Not (pRs.BOF Or pRs.EOF) Then
                pay_idx = pRs("pay_idx")
            Else
                '생성된 pay_idx가 없으므로 새로 생성'
                Set pCmd = Server.CreateObject("ADODB.Command")
                With pCmd
                    .ActiveConnection = dbconn
                    .NamedParameters = True
                    .CommandType = adCmdStoredProc
                    .CommandText = "bp_pay_insert"

                    .Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , member_idx)
                    .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, member_idno)
                    .Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, member_type)
                    .Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,,reqC.mTotalOrderAmount)
                    .Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "REQUEST")

                    .Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamOutput)
                    .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
                    .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

                    .Execute

                    pay_idx = .Parameters("@pay_idx").Value
                    errCode = .Parameters("@ERRCODE").Value
                    errMsg = .Parameters("@ERRMSG").Value
                End With
                Set pCmd = Nothing

                '생성된 pay_idxd와 order_idx 연결'
                Set pCmd = Server.CreateObject("ADODB.Command")
                With pCmd
                    .ActiveConnection = dbconn
                    .NamedParameters = True
                    .CommandType = adCmdStoredProc
                    .CommandText = "bp_order_pay_insert"

                    .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
                    .Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput, ,pay_idx)

                    .Execute
                End With
                Set pCmd = Nothing
            End If
            Set pRs = Nothing

            'pay_detail 생성
            '카드별 사용 포인트 추가
            For i = 0 To UBound(resC.mPointUseList)
                If resC.mPointUseList(i).mUsePoint > 0 Then
                    Set pCmd = Server.CreateObject("ADODB.Command")
                    With pCmd
                        .ActiveConnection = dbconn
                        .NamedParameters = True
                        .CommandType = adCmdStoredProc
                        .CommandText = "bp_pay_detail_insert"

                        .Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,,pay_idx)
                        .Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 20, "PAYCOPOINT")
                        .Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, resC.mCode)
                        .Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, resC.mPointUseList(i).mAccountTypeCode)  '적립/충전'
                        .Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, resC.mPointUseList(i).mCardNo)
                        .Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput, , resC.mPointUseList(i).mUsePoint)
                        .Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, "")
                        .Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, resC.mCode)
                        If resC.mCode <> 0 Then
                            .Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, resC.mMessage)
                        Else
                            .Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, "")
                        End If
                        .Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, resC.toJson())

                        .Execute
                    End With
                    Set pCmd = Nothing
                End If
            Next

            Response.Write "{""result"":true,""message"":""멤버십 사용이 처리되었습니다.""}"
        Else
            Response.Write "{""result"":false,""message"":""" & resC.mMessage & """}"
        End If
    End If
%>