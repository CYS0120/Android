<%
'스탬프적립소진내역조회 탭
'포인트거래내역조회 탭
Class clsTradeList
    Public mTradeDate, mPointAccountType, mAccountTypeName, mCardNo, mPointTradeNo, mPointTradEtypeName, mDetailTradeReasonName, mTradePoint, mSnapshotTotalRestPoint, mValidStartYmd, mValidEndYmd, mTradeCompanyCode, mTradeMerchantCode, mMerchantTypeName, mServiceTradeNo
    Public mStampId, mStampName, mSaveType, mTradeType, mTradeStampCount, mAccumulatedStampCount, mStampFinishCount, mCouponIssueCount

    Public Function Init(ByRef obj)
        If JSON.hasKey(obj, "tradeDate") Then
            mTradeDate = obj.tradeDate
        End If
        If JSON.hasKey(obj, "pointAccountType") Then
            mPointAccountType = obj.pointAccountType
        End If
        If JSON.hasKey(obj, "accountTypeName") Then
            mAccountTypeName = obj.accountTypeName
        End If
        If JSON.hasKey(obj, "cardNo") Then
            mCardNo = obj.cardNo
        End If
        If JSON.hasKey(obj, "pointTradeNo") Then
            mPointTradeNo = obj.pointTradeNo
        End If
        If JSON.hasKey(obj, "pointTradEtypeName") Then
            mPointTradEtypeName = obj.pointTradEtypeName
        End If
        If JSON.hasKey(obj, "detailTradeReasonName") Then
            mDetailTradeReasonName = obj.detailTradeReasonName
        End If
        If JSON.hasKey(obj, "tradePoint") Then
            mTradePoint = obj.tradePoint
        End If
        If JSON.hasKey(obj, "snapshotTotalRestPoint") Then
            mSnapshotTotalRestPoint = obj.snapshotTotalRestPoint
        End If
        If JSON.hasKey(obj, "validStartYmd") Then
            mValidStartYmd = obj.validStartYmd
        End If
        If JSON.hasKey(obj, "validEndYmd") Then
            mValidEndYmd = obj.validEndYmd
        End If
        If JSON.hasKey(obj, "validEndYmd") Then
            mTradeCompanyCode = obj.tradeCompanyCode
        End If
        If JSON.hasKey(obj, "tradeMerchantCode") Then
            mTradeMerchantCode = obj.tradeMerchantCode
        End If
        If JSON.hasKey(obj, "merchantTypeName") Then
            mMerchantTypeName = obj.merchantTypeName
        End If
        If JSON.hasKey(obj, "serviceTradeNo") Then
            mServiceTradeNo = obj.serviceTradeNo
        End If

        If JSON.hasKey(obj, "stampId") Then
            mStampId = obj.stampId
        End If
        If JSON.hasKey(obj, "stampName") Then
            mStampName = obj.stampName
        End If
        If JSON.hasKey(obj, "saveType") Then
            mSaveType = obj.saveType
        End If
        If JSON.hasKey(obj, "tradeType") Then
            mTradeType = obj.tradeType
        End If
        If JSON.hasKey(obj, "tradeStampCount") Then
            mTradeStampCount = obj.tradeStampCount
        End If
        If JSON.hasKey(obj, "accumulatedStampCount") Then
            mAccumulatedStampCount = obj.accumulatedStampCount
        End If
        If JSON.hasKey(obj, "stampFinishCount") Then
            mStampFinishCount = obj.stampFinishCount
        End If
        If JSON.hasKey(obj, "couponIssuecount") Then
            mCouponIssueCount = obj.couponIssuecount
        End If
    End Function

    Private Sub Class_Initialize
        '공통
        mTradeDate = ""
        mTradeCompanyCode = ""
        mTradeMerchantCode = ""
        mMerchantTypeName = ""
        mServiceTradeNo = ""

        '포인트거래내역조회
        mPointAccountType = ""
        mAccountTypeName = ""
        mCardNo = ""
        mPointTradeNo = 0
        mPointTradEtypeName = ""
        mDetailTradeReasonName = ""
        mTradePoint = 0
        mSnapshotTotalRestPoint = 0
        mValidStartYmd = ""
        mValidEndYmd = ""

        '스탬프적립소진내역조회탭
        mStampId = ""
        mStampName = ""
        mSaveType = ""
        mTradeType = ""
        mTradeStampCount = 0
        mAccumulatedStampCount = 0
        mStampFinishCount = 0
        mCouponIssueCount = 0
    End Sub

    Private Sub Class_Terminate
    End Sub

    Function toJson
        cResult = ""

        If mTradeDate <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """tradeDate"":""" & mTradeDate & """"
        End If
        If mPointAccountType <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """pointAccountType"":""" & mPointAccountType & """"
        End If
        If mAccountTypeName <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """tradeDate"":""" & mAccountTypeName & """"
        End If
        If mCardNo <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """cardNo"":""" & mCardNo & """"
        End If
        If mPointTradeNo <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """pointTradeNo"":" & mPointTradeNo
        End If
        If mPointTradEtypeName <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """pointTradEtypeName"":""" & mPointTradEtypeName & """"
        End If
        If mDetailTradeReasonName <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """detailTradeReasonName"":""" & mDetailTradeReasonName & """"
        End If
        If mTradePoint <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """tradePoint"":" & mTradePoint
        End If
        If mSnapshotTotalRestPoint <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """snapshotTotalRestPoint"":" & mSnapshotTotalRestPoint
        End If
        If mValidStartYmd <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """validStartYmd"":""" & mValidStartYmd & """"
        End If
        If mValidEndYmd <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """validEndYmd"":""" & mValidEndYmd & """"
        End If
        If mTradeCompanyCode <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """tradeCompanyCode"":""" & mTradeCompanyCode & """"
        End If
        If mTradeMerchantCode <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """tradeMerchantCode"":""" & mTradeMerchantCode & """"
        End If
        If mMerchantTypeName <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """merchantTypeName"":""" & mMerchantTypeName & """"
        End If
        If mServiceTradeNo <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """serviceTradeNo"":""" & mServiceTradeNo & """"
        End If
        If mStampId <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """stampId"":""" & mStampId & """"
        End If
        If mStampName <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """stampName"":""" & mStampName & """"
        End If
        If mSaveType <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """saveType"":""" & mSaveType & """"
        End If
        If mTradeType <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """tradeType"":""" & mTradeType & """"
        End If
        If mTradeStampCount <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """tradeStampCount"":" & mTradeStampCount
        End If
        If mAccumulatedStampCount <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """accumulatedStampCount"":" & mAccumulatedStampCount
        End If
        If mStampFinishCount <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """stampFinishCount"":" & mStampFinishCount
        End If
        If mCouponIssueCount <> "" Then
            If cResult <> "" Then cResult = cResult & ","
            cResult = cResult & """couponIssueCount"":" & mCouponIssueCount
        End If

        cResult = "{" & cResult & "}"
        toJson = cResult
    End Function
End Class
%>