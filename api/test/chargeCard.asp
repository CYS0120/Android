<!--#include virtual="/api/include/utf8.asp"-->
<%
    cardno = GetReqStr("cardno","")
    charge = GetReqStr("charge","")

    If cardno = "" Or charge = "" Or Session("userIdNo") = "" Then
        Response.Write "Cardno 또는 charge 없음"
        Response.End
    End If

    outerChargeTradeNo = DatePart("yyyy",Now)&DatePart("m",Now)&DatePart("d",Now)&Datepart("h",Now)&Datepart("n", Now)&DatePart("s", Now)
    Response.Write outerChargeTradeNo

    Set reqC = New clsReqCardCharge

    reqC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
    reqC.mBrandCode = PAYCO_BRANDCODE_BBQ
    reqC.mMemberNo = Session("userIdNo")
    reqC.mCardNo = cardno
    reqC.mMerchantCode = PAYCO_MEMBERSHIP_MERCHANTCODE
    reqC.mOuterChargeTradeNo = outerChargeTradeNo
    Set k = new clsPayMethods
    k.mPayMethodCode = "23"
    k.mPayAmount = charge
    reqC.addPayMethods(k)

    Set resC = CardCharge(reqC.toJson())

    If resC.mCode = 0 Then
        Response.Write "충전 ("&cardno&") : " & resC.mChargePoint
    Else
        Response.Write "오류 : " & resC.mMessage
    End If
%>