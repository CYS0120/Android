<!--#include virtual="/api/include/utf8.asp"-->
<%

    pay_data = GetReqStr("pay_data","")

    Set card = CardAutoIssue

    If card.mCode = 0 Then
        '카드 발급 성공'
        '충전하기'
        Set reqCC = New clsReqCardCharge
        reqCC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
        reqCC.mBrandCode = PAYCO_BRANDCODE_BBQ
        reqCC.mMemberNo = Session("userIdNo")
        reqCC.mCardNo = card.mCardNo
        reqCC.mMerchantCode = PAYCO_MERCHANTCODE_BBQ

        Set pJson = JSON.Parse(pay_data)
        For i = 0 To pJson.length - 1
            Set pM = New clsPayMethods
            pM.mPayMethodCode = pJson.get(i).payMethodCode
            pM.mPayAmount = pJson.get(i).payAmount
            pM.mPayApprovalNo = pJson.get(i).payApprovalNo

            reqCC.addPayMethods(pM)
        Next

        Set resCC = CardCharge(reqCC.toJson())

        If resCC.code = 0 Then
            '충전성공'
            '발급 및 충전 성공'
        Else
            '충전실패'
            '발급받은 카드 삭제???'
        End If
    Else
        '카드 발급 실패'
    End If
%>