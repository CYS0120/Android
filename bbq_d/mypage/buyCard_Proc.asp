<!--#include virtual="/api/include/utf8.asp"-->
<%
    ctype = GetReqStr("ctype","")
    camt = GetReqStr("camt","")
    appNo = GetReqStr("approveNo","")

    Set cards = CardOwnerList("USE")

    cardNo = ""
    message = ""
    returnUrl = ""

    If UBound(cards.mCardDetail) > -1 Then
        For i = 0 To UBound(cards.mCardDetail)
            If Not IsNull(cards.mCardDetail(i).mCardNo) And cards.mCardDetail(i).mCardNo <> "" Then
                cardNo = cards.mCardDetail(i).mCardNo
                Exit For
            End If
        Next
    End If

    If cardNo = "" Then
        Set iCard = CardAutoIssue
        If iCard.mCode = 0 Then
            cardNo = iCard.mCardNo
        End If
    End If

    If cardNo <> "" Then
        Set cCard = New clsReqCardCharge
        cCard.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
        cCard.mBrandCode = PAYCO_BRANDCODE_BBQ
        cCard.mMemberNo = Session("userIdNo")
        cCard.mMerchantCode = PAYCO_MEMBERSHIP_MERCHANTCODE
        cCard.mCardNo = cardNo

        Set payInfo = New clsPayMethods
        payInfo.mPayMethodCode = "23"
        payInfo.mPayAmount = camt
        payInfo.mPayApprovalNo = appNo

        cCard.addPayMethods(payInfo)

        Set cRes = CardCharge(cCard.toJson())

        If cRes.mCode = 0 Then
            message = FormatNumber(camt, 0)&"원이 충전되었습니다."
            returnUrl = "/mypage/cardList2.asp"
        Else
            '충전실패'
            '결제취소.....'
        End If
    Else
        '카드조회 실패'
        '발급실패'
    End If
%>
<script type="text/javascript">
<%If message <> "" Then%>
    showAlertMsg({msg:"<%=message%>"});
<%End If%>
<%If returnUrl <> "" Then%>
    location.href = "<%=returnUrl%>";
<%End If%>
</script>