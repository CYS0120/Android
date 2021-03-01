<!--#include virtual="/api/include/utf8.asp"-->
<%
    receiveName = GetReqStr("receiveName","")
    receivePhone = GetReqStr("receivePhone","")
    content = GetReqStr("content", "")

    pay_data = GetReqStr("pay_data","")

    If receiveName = "" Or receivePhone = "" Or pay_data = "" Then

        Response.End
    End If

    Set pJson = JSON.Parse(pay_data)

    Set reC = New clsReqCardSendGift
    reC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
    reC.mMerchantCode = PAYCO_MEMBERSHIP_MERCHANTCODE
    rec.mMemberNo = Session("userIdNo")

    reC.mReceiveName = receiveName
    reC.mReceivePhoneNo = receivePhone
    rec.mContent = content

    totAmt = 0

    For i = 0 To UBound(pJson)
        totAmt = pJson.get(i).payAmount

        Set pMethod = New clsPayMethods
        pMethod.mPayMethodCode = pJson.get(i).payMethodCode
        pMethod.mPayAmount = pJson.get(i).payAmount
        pMethod.mPayApprovalNo = pJson.get(i).payApprovalNo

        reC.addPayMethods(pMethod)
    Next

    Set reS = CardSendGift(reC.toJson())

    If res.mCode = 0 Then
        Response.Write "{""result"":0,""message"":""선물이 전송되었습니다.""}"
    Else
        Response.Write "{""result"":1,""message"":""선물이 전송되지 않았습니다.""}"
    End If
%>