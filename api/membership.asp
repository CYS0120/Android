<%
    Dim api, result, oJson

    'PAYCO Membership 로그저장'
    Sub PLog(apiurl, req, res)
        req_url = GetCurrentFullUrl()
        reg_ip = Request.ServerVariables("REMOTE_ADDR")
        req_qs = Request.ServerVariables("QUERY_STRING")

        Set pCmd = Server.CreateObject("ADODB.Command")
        With pCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "tp_payco_log_insert"

            .Parameters.Append .CreateParameter("@req_page", adVarChar, adParamInput, 1000, req_url)
            .Parameters.Append .CreateParameter("@api_url", adVarChar, adParamInput, 1000, apiurl)
            .Parameters.Append .CreateParameter("@req_text", adLongVarWChar, adParamInput, 2147483647, req)
            .Parameters.Append .CreateParameter("@res_text", adLongVarWChar, adParamInput, 2147483647, res)
            .Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 30, reg_ip)

            .Execute
        End With
        Set pCmd = Nothing
    End Sub

    'PAYCO 쿠폰 로그저장'
    Sub Coupon_Log(order_idx, coupon_no, coupon_id, coupon_amt)
        Set pCmd = Server.CreateObject("ADODB.Command")
        With pCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "UP_LOG_PAYCO_COUPON_LOG"

            .Parameters.Append .CreateParameter("@ORDER_IDX", adInteger, adParamInput, , order_idx)
            .Parameters.Append .CreateParameter("@COUPON_NO", adVarChar, adParamInput, 20, coupon_no)
            .Parameters.Append .CreateParameter("@COUPON_ID", adVarChar, adParamInput, 10, coupon_id)
            .Parameters.Append .CreateParameter("@COUPON_AMT", adInteger, adParamInput, , coupon_amt)

            .Execute
        End With
        Set pCmd = Nothing
    End Sub

    ' API 실행용
    Function executeApi(method, reqcontent, data, url)
        Dim apiResult : apiResult = ""
        Set api = New ApiCall

        api.setMethod = method
        api.RequestContentType = reqcontent
        api.SetData = data
        api.SetUrl = url

        apiResult = api.Run

        ' Response.Write result

        If Request.ServerVariables("SERVER_NAME") <> "localhost" Then
            PLog url, data, apiResult
        End If

        Set api = Nothing

        executeApi = apiResult
    End Function

'----------------------------------------------------------------------------------------------'
'포인트 시작
'----------------------------------------------------------------------------------------------'
    'accountTypeCode : 충전포인트-PAY, 적립포인트-SAVE, 둘다-ALL
    'expiredPeriod : 소멸예정포인트계산일수 (단위-일)
    Function PointGetPointBalance(accountTypeCode, expiredPeriod)
        ' Response.Write data & "<br>"
        req_str = ""
        api_url = "/point/getPointBalance"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     result = "{""code"":0,""message"":""SUCCESS"",""result"":{""queryDate"":""20190128110625"",""pointList"":[{""accountTypeCode"":""SAVE"",""accountTypeName"":""적립포인트"",""cardNo"":null,""restPoint"":43000,""accumulatedPlusPoint"":43000,""accumulatedUsePoint"":0,""accumulatedExpirePoint"":0,""extinctionExpectPoint"":0}]}}"
        ' Else
            Dim reqClass : Set reqClass = New clsReqPointGetPointBalance
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            'reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mAccountTypeCode = accountTypeCode
            reqClass.mExpirePeriod = expiredPeriod

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
        ' End If

        Set oJson = JSON.Parse(result)

		'Response.write result

        Dim resClass : Set resClass = New clsResPointGetPointBalance
        resClass.Init(oJson)

        ' Response.Write JSON.stringify(oJson, null, 2)

        Set PointGetPointBalance = resClass
        ' Response.Write "code > " & balance.code & ", message > " & balance.message

    End Function

    'startYmd: YYYYMMDD
    'endYmd: YYYYMMDD
    'accountTypeCode: 충전포인트-PAY, 적립포인트-SAVE
    'cardNo: 옵션. 카드번호가 있는경우 해당 카드거래내역만 조회, 없으면 전체조회
    'perPage: 한번에 조회할 목록수
    'page: 페이지번호
    Function PointGetTradeList(startYmd, endYmd, accountTypeCode, cardNo, perPage, page)
        req_str = ""
        api_url = "/point/getTradeList"
        result = ""

        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     If accountTypeCode = "PAY" Then
        '         result = "{""code"":0,""message"":""SUCCESS"",""result"":{""totalCount"":3,""queryDate"":""20190130141913"",""tradeList"":[{""tradeDate"":""20190130141147"",""accountType"":""PAY"",""accountTypeName"":""비비큐 충전금"",""cardNo"":null,""pointTradeNo"":""2019013090067748"",""pointTradeMark"":""PLUS"",""pointTradeTypeName"":""충전"",""detailTradeReasonName"":""결제"",""tradePoint"":20000,""snapshotTotalRestPoint"":60000,""validStartDate"":""20190130141147"",""validEndDate"":""20240130235959"",""tradeCompanyCode"":""C10007"",""tradeMerchantCode"":""M000162"",""tradeMerchantName"":""판교점"",""merchantTypeName"":""ONLINE"",""serviceTradeNo"":null},{""tradeDate"":""20190130130622"",""accountType"":""PAY"",""accountTypeName"":""비비큐 충전금"",""cardNo"":null,""pointTradeNo"":""2019013090067747"",""pointTradeMark"":""PLUS"",""pointTradeTypeName"":""충전"",""detailTradeReasonName"":""결제"",""tradePoint"":20000,""snapshotTotalRestPoint"":40000,""validStartDate"":""20190130130622"",""validEndDate"":""20240130235959"",""tradeCompanyCode"":""C10007"",""tradeMerchantCode"":""M000162"",""tradeMerchantName"":""판교점"",""merchantTypeName"":""ONLINE"",""serviceTradeNo"":null},{""tradeDate"":""20190130125137"",""accountType"":""PAY"",""accountTypeName"":""비비큐 충전금"",""cardNo"":null,""pointTradeNo"":""2019013090067746"",""pointTradeMark"":""PLUS"",""pointTradeTypeName"":""충전"",""detailTradeReasonName"":""결제"",""tradePoint"":20000,""snapshotTotalRestPoint"":20000,""validStartDate"":""20190130125137"",""validEndDate"":""20240130235959"",""tradeCompanyCode"":""C10007"",""tradeMerchantCode"":""M000162"",""tradeMerchantName"":""판교점"",""merchantTypeName"":""ONLINE"",""serviceTradeNo"":null}]}}"
        '     Else
        '         result = "{""code"":0,""message"":""SUCCESS"",""result"":{""totalCount"":0,""queryDate"":""20190127015625"",""tradeList"":[]}}"
        '     End If
        '     '{"code":0,"message":"SUCCESS","totalCount":"0","queryDate":"20190127015625"}
        ' Else
            Dim reqClass : Set reqClass = New clsReqPointGetTradeList
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
'            reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mStartYmd = startYmd
            reqClass.mEndYmd = endYmd
            reqClass.mAccountTypeCode = accountTypeCode
'            reqClass.mCardNo = cardNo
            reqClass.mPerPage = perPage
            reqClass.mPage = page

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            ' Response.Write result

        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResPointGetTradeList
        resClass.Init(oJson)

        Set PointGetTradeList = resClass
    End Function

    Function PointTrade(tradeType, point, description)
        req_str = ""
        api_url = "/point/trade"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     doLog = False
        ' Else
            Dim reqClass : Set reqClass = New clsReqPointTrade
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            ' reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mTradeType = tradeType
            reqClass.mPoint = point
            reqClass.mDescription = description

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            Response.Write result

        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResPointTrade
        resClass.Init(oJson)

        Set PointTrade = resClass
    End Function
'----------------------------------------------------------------------------------------------'
'포인트 종료
'----------------------------------------------------------------------------------------------'

'----------------------------------------------------------------------------------------------'
'쿠폰 시작
'----------------------------------------------------------------------------------------------'
    ' StatusCode : ALL - 모두, USED - 사용함, NONE - 미사용
    ' IncludeExired : 쿠폰 기간 만료, Y/N
    ' PerPage : 한번에 조회할 목록수
    ' Page : 페이지번호
    Function CouponGetHoldList(StatusCode, IncludeExired, PerPage, Page)
        ' Response.Write data & "<br>"
        req_str = ""
        api_url = "/coupon/getHoldList"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     result = "{""code"":0,""message"":""SUCCESS"",""result"":{""queryDate"":""20190121193205"",""totalCount"":0,""holdList"":[]}}"
        ' Else
            Dim reqClass : Set reqClass = New clsReqCouponGetHoldList
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            'reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mStatusCode = StatusCode
            reqClass.mIncludeExpired = IncludeExired
            reqClass.mPerPage = PerPage
            reqClass.mPage = Page

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCouponGetHoldList
        resClass.Init(oJson)

        Set CouponGetHoldList = resClass
    End Function


    Function CouponGetDetail(couponId)
        ' Response.Write data & "<br>"
        req_str = ""
        api_url = "/coupon/getDetail"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     result = "{""code"":0,""message"":""SUCCESS"",""result"":{""queryDate"":""20190121193205"",""totalCount"":0,""holdList"":[]}}"
        ' Else
			Dim reqDetailClass : Set reqDetailClass = New clsReqCouponGetDetail
			reqDetailClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
			reqDetailClass.mCouponId = couponHoldList.mHoldList(i).mCouponId

			req_str = reqDetailClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
        ' End If

        Set oJson = JSON.Parse(result)

		Dim resDetailClass : Set resDetailClass = New clsResCouponGetDetail
        resDetailClass.Init(oJson)

        Set CouponGetDetail = resDetailClass
    End Function

    'startYmd : 조회시작일자
    'endYmd : 조회종료일자
    'perPage : 한번에 조회할 목록수
    'page : 페이지번호
    Function CouponGetUseList(startYmd, endYmd, perPage, page)
        req_str = ""
        api_url = "/coupon/getUseList"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        ' Else
            Dim reqClass : Set reqClass = New clsReqCouponGetUseList
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mStartYmd = startYmd
            reqClass.mEndYmd = endYmd
            reqClass.mPerPage = perPage
            reqClass.mPage = page

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCouponGetUseList
        resClass.Init(oJson)

        Set CouponGetUseList = resClass
    End Function

    Function CouponIssue(couponId)
        req_str = ""
        api_url = "/coupon/issue"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        ' Else
            Dim reqClass : Set reqClass = New clsReqCouponIssue
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mCouponId = couponId

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCouponIssue
        resClass.Init(oJson)

        Set CouponIssue = resClass
    End Function

    Function CouponIssueByPinV2(pinNo)
        req_str = ""
        api_url = "/coupon/issueByPinV2"
        result = ""

        Dim reqClass : Set reqClass = New clsReqCouponIssueByPinV2
        reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
        reqClass.mMemberNo = Session("userIdNo")
        reqClass.mPinNo = pinNo

        req_str = reqClass.toJson()

        result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCouponIssueByPinV2
        resClass.Init(oJson)

        Set CouponIssueByPinV2 = resClass
    End Function

'----------------------------------------------------------------------------------------------'
'쿠폰 종료
'----------------------------------------------------------------------------------------------'

'----------------------------------------------------------------------------------------------'
'주문 시작
'----------------------------------------------------------------------------------------------'
    Function OrderGetListForOrder(data)
        req_str = ""
        api_url = "/order/getListForOrder"
        result = ""
        doLog = True
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     result = "{""code"":0,""message"":""SUCCESS"",""result"":{""queryDate"":""20190118182027"",""couponList"":[],""pointList"":[{""accountTypeCode"":""SAVE"",""accountTypeName"":""적립포인트"",""cardNo"":"""",""restPoint"":0,""useMinSavePoint"":0,""useMaxSavePoint"":0,""useSavePointUnit"":10}]}}"
        ' Else
            req_str = data

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
        ' End If
        ' Response.Write result

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResOrderGetListForOrder
        resClass.Init(oJson)

        Set OrderGetListForOrder = resClass
    End Function

    Function OrderGetListForOrderV2(data)
        req_str = ""
        api_url = "/order/getListForOrderV2"
        result = ""
        doLog = True
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     result = "{""code"":0,""message"":""SUCCESS"",""result"":{""queryDate"":""20190118182027"",""couponList"":[],""pointList"":[{""accountTypeCode"":""SAVE"",""accountTypeName"":""적립포인트"",""cardNo"":"""",""restPoint"":0,""useMinSavePoint"":0,""useMaxSavePoint"":0,""useSavePointUnit"":10}]}}"
        ' Else
            req_str = data

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
        ' End If
        ' Response.Write result

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResOrderGetListForOrder
        resClass.Init(oJson)

        Set OrderGetListForOrderV2 = resClass
    End Function

    Function OrderUseListForOrder(data)
        req_str = ""
        api_url = "/order/useListForOrder"
        result = ""
        doLog = True
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     doLog = False
        ' Else
            req_str = data
            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
        ' End If
		
        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResOrderUseListForOrder
        resClass.Init(oJson)
		'Response.write result
        Set OrderUseListForOrder = resClass

    End Function

    ' serviceTradeNo : 가맹점에서 생성한 주문거래번호
    Function OrderCancelListForOrder(order_idx)

        ' 취소시 merchantcode -> branch_id 로 변경되어야 함에 따른 수정중...
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
            branch_id = pRs("branch_id")
            order_num = pRs("order_num")

            order_status = pRs("order_status")

            If order_status <> "" And order_status <> "B" Then
                result = "{""code"":0,""message"":""SUCCESS"",""result"":{""queryDate"":""20190121193205"",""totalCount"":0,""holdList"":[]}}"
                'Response.Write "{""result"":1,""message"":""멤버십 취소가 가능한 상태가 아닙니다.""}"
                'Response.End
            Else
                req_str = ""
                api_url = "/order/cancelListForOrder"
                result = ""
                ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
                '     result = "{""code"":0,""message"":""SUCCESS"",""result"":{""cancelDate"":""20190128204023"",""couponCancelList"":[],""pointCancelList"":[{""accountTypeCode"":""SAVE"",""usePoint"":5000,""cancelDate"":""20190128204024"",""cardNo"":""""}]}}"
                ' Else
                    Dim reqClass : Set reqClass = New clsReqOrderCancelListForOrder
                    reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
                    reqClass.mMerchantCode = branch_id'PAYCO_MERCHANTCODE
                    reqClass.mMemberNo = Session("userIdNo")
                    reqClass.mServiceTradeNo = order_num

                    req_str = reqClass.toJson()

                    result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
                ' End If
                'Response.write result
            End If
        Else
            result = "{""code"":0,""message"":""SUCCESS"",""result"":{""queryDate"":""20190121193205"",""totalCount"":0,""holdList"":[]}}"
            'Response.Write "{""result"":1,""message"":""주문정보가 잘못되었습니다.""}"
            'Response.End
        End If

        
        Set oJson = JSON.Parse(result)
		'Response.write result
        Dim resClass : Set resClass = New clsResOrderCancelListForOrder
		'Response.write result
        resClass.Init(oJson)
		'Response.write result
        Set OrderCancelListForOrder = resClass
    End Function

    Function OrderCancelListForOrderV2(serviceTradeNo, branch_id)
        req_str = ""
        api_url = "/order/cancelListForOrder"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     result = "{""code"":0,""message"":""SUCCESS"",""result"":{""cancelDate"":""20190128204023"",""couponCancelList"":[],""pointCancelList"":[{""accountTypeCode"":""SAVE"",""usePoint"":5000,""cancelDate"":""20190128204024"",""cardNo"":""""}]}}"
        ' Else
            Dim reqClass : Set reqClass = New clsReqOrderCancelListForOrder
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mMerchantCode = branch_id'PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mServiceTradeNo = serviceTradeNo

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResOrderCancelListForOrder
        resClass.Init(oJson)
        Set OrderCancelListForOrderV2 = resClass
    End Function

    Function OrderComplete(data)
        req_str = ""
        api_url = "/order/complete"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     ' result = "{""companyCode"":""C10007"",""merchantCode"":""M000162"",""memberNo"":""10007004142832003"",""serviceTradeNo"":""W20000000000016"",""orderYmdt"":""2019-01-23 08:08"",""saveYn"":""Y"",""deliveryCharge"":2000,""outerPayMethodList"":[],""productList"":[{""productClassCd"":""M"",""productClassNm"":""상품"",""productCd"":""285"",""productNm"":""순살바삭칸치킨"",""unitPrice"":18000,""targetUnitPrice"":0,""productCount"":1,""productSaveYn"":""Y""},{""productClassCd"":""S"",""productClassNm"":""사이드"",""productCd"":""129"",""productNm"":""쉐킷쉐킷 치즈맛"",""unitPrice"":4500,""targetUnitPrice"":0,""productCount"":1,""productSaveYn"":""Y""}]}"
        '     result = "{""code"":0,""message"":""SUCCESS"",""result"":{""orderNo"":""2019012300246660"",""orderDate"":""20190123080857""}}"
        '     ' {"result":0, "result_msg":"주문이 저장되었습니다.", "order_idx":16,"order_num":"W20000000000016"}
        ' Else
            ' Response.Write data
            req_str = data

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            ' Response.Write result
        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResOrderComplete
        resClass.Init(oJson)

        Set OrderComplete = resClass
    End Function

    Function OrderDecision(data)
        req_str = ""
        api_url = "/order/decision"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            ' Response.Write data
            req_str = data

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            ' Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResOrderDecision
        resClass.Init(oJson)

        Set OrderDecision = resClass
    End Function

    Function OrderDecisionSimple(data)
        req_str = ""
        api_url = "/order/simple/decision"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            ' Response.Write data
            req_str = data

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            ' Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResOrderDecisionSimple
        resClass.Init(oJson)

        Set OrderDecisionSimple = resClass
    End Function

    Function OrderCancel(data)
        req_str = ""
        api_url = "/order/simple/cancel"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            ' Response.Write data
            req_str = data

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            ' Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResOrderCancel
        resClass.Init(oJson)

        Set OrderCancel = resClass
    End Function
'----------------------------------------------------------------------------------------------'
'주문 종료
'----------------------------------------------------------------------------------------------'

'----------------------------------------------------------------------------------------------'
'카드 시작
'----------------------------------------------------------------------------------------------'
    ' SearchType : ALL(전체), USE(폐기 카드제외)  , null일 경우 전체
    Function CardOwnerList(SearchType)
        req_str = ""
        api_url = "/card/ownerList"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     result = "{""code"":0,""message"":""SUCCESS"",""result"":[{""cardNo"":""777100073980943734"",""cardStatusCode"":""USE"",""cardStatusName"":""정상"",""pauseReasonCode"":null,""pauseReasonDesc"":null,""nickNm"":null,""registerYmdt"":""20190107160118"",""issueYmdt"":""20190107160118"",""restPayPoint"":0}]}"
        ' Else
            Dim reqClass : Set reqClass = New clsReqCardOwnerList
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mBrandCode = PAYCO_BRANDCODE
            ' reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mSearchType = SearchType

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardOwnerList
        resClass.Init(oJson)

        Set CardOwnerList = resClass
    End Function

    ' cardNo : 실물카드 번호
    ' cardPinNo : 실물카드 핀번호 사용업체의 경우
    ' cardNickName : 카드별칭
    Function CardRegRealCard(cardNo, cardPinNo, cardNickName)
        req_str = ""
        api_url = "/card/regRealCard"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     result = "{}"
        ' Else
            Dim reqClass : Set reqClass = New clsReqCardRegRealCard
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mBrandCode = PAYCO_BRANDCODE
            ' reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mCardNo = cardNo
            reqClass.mCardPinNo = cardPinNo
            reqClass.mCardNickName = cardNickName

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardRegRealCard
        resClass.Init(oJson)

        Set CardRegRealCard = resClass
    End Function

    Function CardAutoIssue
        req_str = ""
        api_url = "/card/autoIssue"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     result = "{}"
        ' Else
            Dim reqClass : Set reqClass = New clsReqCardAutoIssue
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            ' reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mBrandCode = PAYCO_BRANDCODE
            reqClass.mMemberNo = Session("userIdNo")

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardAutoIssue
        resClass.Init(oJson)

        Set CardAutoIssue = resClass
    End Function

    ' cardNo : 조회할 카드 번호
    Function CardDetail(cardNo)
        req_str = ""
        api_url = "/card/detail"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     result = "{}"
        ' Else
            Dim reqClass : Set reqClass = New clsReqCardDetail
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            ' reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mBrandCode = PAYCO_BRANDCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mCardNo = cardNo

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardDetail
        resClass.Init(oJson)

        Set CardDetail = resClass
    End Function

    Function CardChangeNickName(cardNo, newNickName)
        req_str = ""
        api_url = "/card/changeNickName"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     result = "{}"
        ' Else
            Dim reqClass : Set reqClass = New clsReqCardChangNickName
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mCardNo = cardNo
            reqClass.mNewNickName = newNickName

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardChangeNickName
        resClass.Init(oJson)

        Set CardChangeNickName = resClass
    End Function

    Function CardChangeStatus(cardNo, toBeStatus, pauseReason)
        req_str = ""
        api_url = "/card/changeStatus"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            Dim reqClass : Set reqClass = New clsReqCardChangeStatus
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mCardNo = cardNo
            reqClass.mToBeStatus = toBeStatus
            reqClass.mPauseReason = pauseReason

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardChangStatus
        resClass.Init(oJson)

        Set CardChangeStatus = resClass
    End Function


    Function CardMovePoint(cardNo, targetCardNo)
        req_str = ""
        api_url = "/card/movePoint"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            Dim reqClass : Set reqClass = New clsReqCardMovePoint
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mCardNo = cardNo
            reqClass.mTargetCardNo = targetCardNo

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardMovePoint
        resClass.Init(oJson)

        Set CardMovePoint = resClass
    End Function

    Function CardCharge(data)
        req_str = ""
        api_url = "/card/charge"
        result = ""
        ' If Request.ServerVariables("SERVER_NAME") = "localhost" Then
        '     result = "{}"
        ' Else
            req_str = data

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        ' End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardCharge
        resClass.Init(oJson)

        Set CardCharge = resClass
    End Function

    Function CardChargeInfoList(cardNo)
        req_str = ""
        api_url = "/card/chargeInfoList"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            Dim reqClass : Set reqClass = New clsReqCardChargeInfoList
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mCardNo = cardNo

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardChargeInfoList
        resClass.Init(oJson)

        Set CardChargeInfoList = resClass
    End Function

    Function CardChargeInfo(membershipChargeTradeNo)
        req_str = ""
        api_url = "/card/chargeInfo"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            Dim reqClass : Set reqClass = New clsReqCardChargeInfo
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mMembershipChargeTradeNo = membershipChargeTradeNo

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardChargeInfo
        resClass.Init(oJson)

        Set CardChargeInfo = resClass
    End Function

    Function CardChargeCancel(membershipChargeTradeNo, outerChargeCancelTradeNo)
        req_str = ""
        api_url = "/card/chargeCancel"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            Dim reqClass : Set reqClass = New clsReqCardChargeCancel
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mMembershipChargeTradeNo = membershipChargeTradeNo
            reqClass.mOuterChargeCancelTradeNo = outerChargeCancelTradeNo

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardChargeCancel
        resClass.Init(oJson)

        Set CardChargeCancel = resClass
    End Function

    Function CardVerifyGift(data)
        req_str = ""
        api_url = "/card/verifyGift"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            req_str = data

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardVerifyGift
        resClass.Init(oJson)

        Set CardVerifyGift = resClass
    End Function

    Function CardSendGift(data)
        req_str = ""
        api_url = "/card/sendGift"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            req_str = data

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardSendGift
        resClass.Init(oJson)

        Set CardSendGift = resClass
    End Function

    Function CardSendGiftList
        req_str = ""
        api_url = "/card/sendGiftList"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            Dim reqClass : Set reqClass = New clsReqCardSendGiftList
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardSendGiftList
        resClass.Init(oJson)

        Set CardSendGiftList = resClass
    End Function

    Function CardCancelSendGift(cardGiftTradeNo, outerCancelChargeTradeNo)
        req_str = ""
        api_url = "/card/cancelSendGift"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            Dim reqClass : Set reqClass = New clsReqCardCancelSendGift
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")
            reqClass.mCardGiftTradeNo = cardGiftTradeNo
            reqClass.mOuterCancelChargeTradeNo = outerCancelChargeTradeNo

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            'Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResCardCancelSendGift
        resClass.Init(oJson)

        Set CardCancelSendGift = resClass
    End Function
'----------------------------------------------------------------------------------------------'
'카드 종료
'----------------------------------------------------------------------------------------------'

'----------------------------------------------------------------------------------------------'
'회원 시작
'----------------------------------------------------------------------------------------------'
    Function UserGetInfo
        req_str = ""
        api_url = "/user/getInfo"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{""code"":0,""message"":""SUCCESS"",""result"":{""memberGradeCode"":""NORMAL"",""memberGradeName"":""일반"",""memberUpgradeConditionList"":[],""memberBenefitList"":[],""payAcmRateList"":[{""payMethodCode"":""CASH"",""payMethodName"":""현금"",""acmRate"":3.0},{""payMethodCode"":""CASH_RECEIPT"",""payMethodName"":""현금영수증"",""acmRate"":3.0},{""payMethodCode"":""CREDIT_CARD"",""payMethodName"":""신용카드"",""acmRate"":3.0},{""payMethodCode"":""ETC"",""payMethodName"":""기타"",""acmRate"":3.0},{""payMethodCode"":""MEMBERSHIP_CARD"",""payMethodName"":""멤버십카드"",""acmRate"":3.0}]}}"
        Else
            Dim reqClass : Set reqClass = New clsReqUserGetInfo
            reqClass.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            'reqClass.mMerchantCode = PAYCO_MERCHANTCODE
            reqClass.mMemberNo = Session("userIdNo")

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            ' Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResUserGetInfo
        resClass.Init(oJson)

        Set UserGetInfo = resClass
    End Function

    Function UserDormancyHistories(ymd, size, page)
        req_str = ""
        api_url = "/user/dormancyHistories"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{""code"":0,""message"":""SUCCESS"",""result"":{""memberGradeCode"":""NORMAL"",""memberGradeName"":""일반"",""memberUpgradeConditionList"":[],""memberBenefitList"":[],""payAcmRateList"":[{""payMethodCode"":""CASH"",""payMethodName"":""현금"",""acmRate"":3.0},{""payMethodCode"":""CASH_RECEIPT"",""payMethodName"":""현금영수증"",""acmRate"":3.0},{""payMethodCode"":""CREDIT_CARD"",""payMethodName"":""신용카드"",""acmRate"":3.0},{""payMethodCode"":""ETC"",""payMethodName"":""기타"",""acmRate"":3.0},{""payMethodCode"":""MEMBERSHIP_CARD"",""payMethodName"":""멤버십카드"",""acmRate"":3.0}]}}"
        Else
            Dim reqClass : Set reqClass = New clsReqUserDormancyHistories
            reqClass.mServiceCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mYmd = ymd
            reqClass.mSize = size
            reqClass.mPage = page

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            ' Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResUserDormancyHistories
        resClass.Init(oJson)

        Set UserDormancyHistories = resClass
    End Function


    Function UserWithdrawalHistories
        req_str = ""
        api_url = "/user/withdrawalHistories"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{}"
        Else
            Dim reqClass : Set reqClass = New clsReqUserWithdrawalHistories
            reqClass.mServiceCode = PAYCO_MEMBERSHIP_COMPANYCODE
            reqClass.mYmd = ymd
            reqClass.mSize = size
            reqClass.mPage = page

            req_str = reqClass.toJson()

            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)

            ' Response.Write result
        End If

        Set oJson = JSON.Parse(result)

        Dim resClass : Set resClass = New clsResUserWithdrawalHistories
        resClass.Init(oJson)

        Set UserWithdrawalHistories = resClass
    End Function
'----------------------------------------------------------------------------------------------'
'회원 종료
'----------------------------------------------------------------------------------------------'


'----------------------------------------------------------------------------------------------'
'인증
'----------------------------------------------------------------------------------------------'
    Function AuthGetToken(code)
        Set api = New ApiCall

        api.SetMethod = "POST"
        api.RequestContentType = "application/x-www-form-urlencoded"
        api.Authorization = "Basic " & PAYCO_CLIENT_SECRET
        api.SetData = "grant_type=authorization_code&clinet_id=" & PAYCO_CLIENT_ID & "&code=" & code
        api.SetUrl = PAYCO_AUTH_URL & "/oauth2/token"

        result = api.Run

        Set api = Nothing

        Set AuthGetToken = JSON.Parse(result)
    End Function

    Function AuthGetMember
        Set api = New ApiCall

        api.SetMethod = "POST"
        api.RequestContentType = "application/json"
        api.Authorization = "Bearer " & Session("access_token")
        api.SetDat = "{""scope"":""ADMIN""}"
        api.SetUrl = PAYCO_AUTH_URL & "/api/member/me"

        result = api.Run

        Set api = Nothing

        Set AuthGetMember = JSON.Parse(result)
    End Function
'----------------------------------------------------------------------------------------------'
'인증
'----------------------------------------------------------------------------------------------'

%>