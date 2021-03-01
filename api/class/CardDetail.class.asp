<%
Class clsCardDetail
    Public mCardNo, mCardStatusCode, mCardStatusName, mNickNm, mIssueYmdt, mRegisterYmdt, mRestPayPoint, mOwnerMemberNo, mOwnerMemberName, mOwnerSavePoint, mMinChargePoint, mMaxChargePoint, mRefundAble, mRefundAbleBaseAmount, mRefundFeeAmount, mRefundAmount

    Public Function Init(ByRef obj)
        If JSON.hasKey(obj, "cardNo") Then
            mCardNo = obj.cardNo
        End If
        If JSON.hasKey(obj, "cardStatusCode") Then
            mCardStatusCode = obj.cardStatusCode
        End If
        If JSON.hasKey(obj, "cardStatusName") Then
            mCardStatusName = obj.cardStatusName
        End If
        If JSON.hasKey(obj, "nickNm") Then
            mNickNm = obj.nickNm
        End If
        If JSON.hasKey(obj, "issueYmdt") Then
            mIssueYmdt = obj.issueYmdt
        End If
        If JSON.hasKey(obj, "registerYmdt") Then
            mRegisterYmdt = obj.registerYmdt
        End If
        If JSON.hasKey(obj, "restPayPoint") Then
            mRestPayPoint = obj.restPayPoint
        End If
        If JSON.hasKey(obj, "ownerMemberNo") Then
            mOwnerMemberNo = obj.ownerMemberNo
        End If
        If JSON.hasKey(obj, "ownerMemberName") Then
            mOwnerMemberName = obj.ownerMemberName
        End If
        If JSON.hasKey(obj, "ownerSavePoint") Then
            mOwnerSavePoint = obj.ownerSavePoint
        End If
        If JSON.hasKey(obj, "minChargePoint") Then
            mMinChargePoint = obj.minChargePoint
        End If
        If JSON.hasKey(obj, "maxChargePoint") Then
            mMaxChargePoint = obj.maxChargePoint
        End If
        If JSON.hasKey(obj, "refundAble") Then
            mRefundAble = obj.refundAble
        End If
        If JSON.hasKey(obj, "refundAbleBaseAmount") Then
            mRefundAbleBaseAmount = obj.refundAbleBaseAmount
        End If
        If JSON.hasKey(obj, "refundFeeAmount") Then
            mRefundFeeAmount = obj.refundFeeAmount
        End If
        If JSON.hasKey(obj, "refundAmount") Then
            mRefundAmount = obj.refundAmount
        End If
    End Function

    Private Sub Class_Initialize
        mCardNo = ""
        mCardStatusCode = ""
        mCardStatusName = ""
        mNickNm = ""
        mIssueYmdt = ""
        mRegisterYmdt = ""
        mRestPayPoint = 0
        mOwnerMemberNo = ""
        mOwnerMemberName = ""
        mOwnerSavePoint = 0
        mMinChargePoint = 0
        mMaxChargePoint = 0
        mRefundAble = false
        mRefundAbleBaseAmount = 0
        mRefundFeeAmount = 0
        mRefundAmount = 0
    End Sub

    Private Sub Class_Terminate
    End Sub

    Public Function toJson
        cResult = ""

        If mCardNo <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """cardNo"":""" & mCardNo & """"
        End If
        If mCardStatusCode <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """cardStatusCode"":""" & mCardStatusCode & """"
        End If
        If mCardStatusName <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """cardStatusName"":""" & mCardStatusName & """"
        End If
        If mNickNm <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """nickNm"":""" & mNickNm & """"
        End If
        If mIssueYmdt <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """issueYmdt"":""" & mIssueYmdt & """"
        End If
        If mRegisterYmdt <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """registerYmdt"":""" & mRegisterYmdt & """"
        End If
        If cResult <> "" Then cResult = cResult & ","
        cResult = cResult & """restPayPoint"":" & mRestPayPoint
        If mOwnerMemberNo <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """ownerMemberNo"":""" & mOwnerMemberNo & """"
        End If
        If mOwnerMemberName <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """ownerMemberName"":""" & mOwnerMemberName & """"
        End If
        If cResult <> "" Then cResult = cResult & ","
        cResult = cResult & """ownerSavePoint"":" & mOwnerSavePoint
        If cResult <> "" Then cResult = cResult & ","
        cResult = cResult & """minChargePoint"":" & mMinChargePoint
        If cResult <> "" Then cResult = cResult & ","
        cResult = cResult & """maxChargePoint"":" & mMaxChargePoint
        If cResult <> "" Then cResult = cResult & ","
        cResult = cResult & """refundAble"":" & IIF(mRefundAble,"true","false")
        If cResult <> "" Then cResult = cResult & ","
        cResult = cResult & """refundAbleBaseAmount"":" & mRefundAbleBaseAmount
        If cResult <> "" Then cResult = cResult & ","
        cResult = cResult & """refundFeeAmount"":" & mRefundFeeAmount
        If cResult <> "" Then cResult = cResult & ","
        cResult = cResult & """refundAmount"":" & mRefundAmount

        cResult = "{" & cResult & "}"
        toJson = cResult
    End Function
End Class
%>