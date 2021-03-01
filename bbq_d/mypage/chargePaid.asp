<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
</head>
<body>
<%
    gubun = Request.Cookies("GUBUN")
    seq = Request.Cookies("CARD_SEQ")
    payType = GetReqStr("payType","")

    Response.Cookies("GUBUN") = ""
    Response.Cookies("CARD_SEQ") = ""
    
    Select Case payType
        Case "DANALCARD": payType = "23"
    End Select
    payType = "23"

    workMessage = ""
    returnUrl = ""

    returnCode = GetReqStr("RETURNCODE","")
    tid = GetReqStr("TID","")

    Set aCmd = Server.CreateObject("ADODB.Command")
    With aCmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_payco_card_select_one"

        .Parameters.Append .CreateParameter("@seq", adInteger, adParamInput, , seq)

        Set aRs = .Execute
    End With
    Set aCmd = Nothing

    If Not (aRs.BOF Or aRs.EOF) Then
        receiveName = aRs("target_name")
        receivePhoneNo = aRs("target_mobile")
        content = aRs("gift_message")
        chargeAmount = aRs("charge_amount")
    End If
        outerChargeTradeNo = tid

    If returnCode = "0000" Then
        '충전이면 내 카드목록 조회
        If gubun = "Charge" Then
            Set resC = CardOwnerList("USE")

            ownCardNo = ""

            ' If resC.mCode = 0 Then
            '     For i = 0 To UBound(resC.mCardDetail)
            '         ownCardNo = resC.mCardDetail(i).mCardNo

            '         If ownCardNo <> "" Then
            '             Exit For
            '         End If
            '     Next
            ' End If

            If ownCardNo = "" Then
                Set resC = CardAutoIssue
                If resC.mCode = 0 Then
                    ownCardNo = resC.mCardNo
                End If
            End If

            If ownCardNo <> "" Then
                Set reqC = New clsReqCardCharge
                reqC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
                reqC.mBrandCode = PAYCO_BRANDCODE
                reqC.mMemberNo = Session("userIdNo")
                reqC.mCardNo = ownCardNo
                reqC.mMerchantCode = PAYCO_MERCHANTCODE
                reqC.mOuterChargeTradeNo = outerChargeTradeNo
                Set tmp = New clsPayMethods
                tmp.mPayMethodCode = payType
                tmp.mPayAmount = chargeAmount
                reqC.addPayMethods(tmp)

                Set resC = CardCharge(reqC.toJson())

                If resC.mCode = 0 Then
                    Set aCmd = Server.CreateObject("ADODB.Command")
                    With aCmd
                        .ActiveConnection = dbconn
                        .NamedParameters = True
                        .CommandType = adCmdStoredProc
                        .CommandText = "bp_payco_card_update_cardno"

                        .Parameters.Append .CreateParameter("@seq", adInteger, adParamInput, , seq)
                        .Parameters.Append .CreateParameter("@cardNo", adVarChar, adParamInput, 50, ownCardNo)
                        .Parameters.Append .CreateParameter("@cardGiftTradeNo", adVarChar, adParamInput, 100, resC.mMembershipChargeTradeNo)
                        .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
                        .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

                        .Execute

                        errCode = .Parameters("@ERRCODE").Value
                        errMsg = .Parameters("@ERRMSG").Value
                    End With
                    Set aCmd = Nothing
                End If
                workMessage = FormatNumber(chargeAmount,0) & "원이 충전되었습니다."
                returnUrl = "/mypage/cardList2.asp"
            Else
                workMessage = "충전할 카드가 없습니다."
                returnUrl = "/mypage/card.asp"
            End If
        '선물이면 선물하기
        ElseIf gubun = "Gift" Then
            Set reqC = new clsReqCardSendGift

            reqC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqC.mBrandCode = PAYCO_BRANDCODE
            reqC.mMemberNo = Session("userIdNo")
            reqC.mReceiverName = receiveName
            reqC.mReceiverPhoneNo = receivePhoneNo
            reqC.mOuterChargeTradeNo = outerChargeTradeNo
            reqC.mContent = content
            Set tmp = New clsPayMethods
            tmp.mPayMethodCode = payType
            tmp.mPayAmount = chargeAmount
            reqC.addPayMethods(tmp)

            Set resC = CardSendGift(reqC.toJson())

            If resC.mCode = 0 Then

                Set aCmd = Server.CreateObject("ADODB.Command")
                With aCmd
                    .ActiveConnection = dbconn
                    .NamedParameters = True
                    .CommandType = adCmdStoredProc
                    .CommandText = "bp_payco_card_update_cardno"

                    .Parameters.Append .CreateParameter("@seq", adInteger, adParamInput, , seq)
                    .Parameters.Append .CreateParameter("@cardNo", adVarChar, adParamInput, 50, resC.mCardNo)
                    .Parameters.Append .CreateParameter("@cardGiftTradeNo", adVarChar, adParamInput, 100, resC.mCardGiftTradeNo)
                    .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
                    .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

                    .Execute

                    errCode = .Parameters("@ERRCODE").Value
                    errMsg = .Parameters("@ERRMSG").Value
                End With
                Set aCmd = Nothing
                workMessage = FormatNumber(chargeAmount,0) & "원이 선물되었습니다."
                returnUrl = "/mypage/card.asp"
            Else
                workMessage = "선물보내기에 실패하였습니다."
                returnUrl = "/mypage/card.asp"
            End If
        End If
    End If
%>
<script type="text/javascript">
    $(function(){
        showAlertMsg({msg:"<%=workMessage%>",ok: function(){
            location.href = "<%=returnUrl%>";
        }});
    });
</script>
</body>
</html>