<!--#include file="json.asp"-->
<%

Class PosResult_Coop

    public m_CouponType
    public m_CompCode
    public m_CouponNum
    public m_BranchCode
    public m_PosNum
    public m_CouponName
    public m_StartDay
    public m_EndDay
    public m_UsePrice
    public m_BalPrice
    public m_SelPrice
    public m_DUsePrice
    public m_UseYN
    public m_ProductState
    public m_AuthDate
    public m_BrandAuthCode
    public m_OriginalAuthCode
    public m_ProductCode
    public m_PosTime

    public m_ResultCode
    public m_ResultMsg
    public m_ResultProductCode
    public m_ErrorCode

    Sub CouponCall(Url, AuthKey, OperType, CouponNum, BranchCode, AuthPrice, AuthDate, BrandAuthCode, OriginalAuthCode, ProductCode)

        Url = "https://authapi.inumber.co.kr/AuthUse"
        if OperType = "info" then
            ProcessType = "L0"
        elseif OperType = "use" then
            ProcessType = "L1"
        elseif OperType = "cancel" then
            ProcessType = "L2"
        elseif OperType = "rollback" then
            ProcessType = "L3"
        else
            m_ResultCode = "001"
            m_ErrorCode = "1000"
            m_ResultMsg = "처리 유형(OperType)에 설정되지 않았습니다."
            m_ResultProductCode = ""
            exit sub
        end if

        if left(CouponNum, 2) = "85" then
            CouponType = "02"
        else
            CouponType = "00"
        end if

        CompCode = "BQ01"
        PosNum = "0000"

        if len(AuthDate) = 0 then AuthDate = Replace(Date, "-", "") & Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)

        ' 유효성 검사 (승인번호)
        if OperType = "cancel" and len(BrandAuthCode) = 0 then
            m_ResultCode = "001"
            m_ErrorCode = "1001"
            m_ResultMsg = "결제 취소시 승인번호가 반드시 필요합니다."
            m_ResultProductCode = ""
            exit sub
        end if


        strjson = "{  ""AuthKey"": """&AuthKey&""",  ""ProcessType"": """&ProcessType&""",  "
                strjson = strjson & " ""CouponType"": """&CouponType&""", "
                strjson = strjson & " ""CompCode"": """&CompCode&""", "
                strjson = strjson & " ""CouponNum"": """&CouponNum&""", "
                strjson = strjson & " ""BranchCode"": """&BranchCode&""", "
                strjson = strjson & " ""PosNum"": """&PosNum&""", "
                strjson = strjson & " ""AuthPrice"": """&AuthPrice&""", " 
                strjson = strjson & " ""AuthDate"": """&AuthDate&""", "
                strjson = strjson & " ""BrandAuthCode"": """&BrandAuthCode&""", "
                strjson = strjson & " ""OriginalAuthCode"": """&OriginalAuthCode&""", "
                strjson = strjson & " ""ProductCode"": """&ProductCode&""" }"

    'response.write strjson
    'response.end

    '-- 실제 통신 | 시작 --
    Set httpObj = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
        lResolve = 15 * 1000	'도메인 확인 시간, default 무한대
        lConnect = 15 * 1000	'서버와의 연결 시간, default 60 초
        lSend    = 15 * 1000	'데이터 전송 시간, default 30 초
        lReceive = 15 * 1000	'데이터 수신 시간, default 30 초
        httpObj.SetTimeouts lResolve, lConnect, lSend, lReceive
        httpObj.open "POST", Url, False
        httpObj.SetRequestHeader "Content-Type", "application/json"
        httpObj.SetRequestHeader "x-api-key", AuthKey
        httpObj.Send strjson
        httpObj.WaitForResponse

        If httpObj.Status = "200" Then
            '--성공
            isJsonParse = true
            result = httpObj.responseText
            'Response.Write result
        else
            '--오류
            'Response.Write httpObj.Status
        end if
    Set httpObj = Nothing
    '-- 실제 통신 | 끝 --



    ' ---------------------------------------------------------------------------
    '-- 응답 Json 파싱 | 시작 --
    if isJsonParse = true then
        Set jResult = JSON.parse(join(array(result)))
            ResultCd = jResult.ResultCode
            ResultMsg = jResult.ResultMsg
            ProductCode = jResult.ProductCode

            m_ResultCode = ResultCd
            m_ResultMsg = ResultMsg
            m_ResultProductCode = ProductCode

            m_CouponType = jResult.CouponType
            m_CompCode = jResult.CompCode
            m_CouponNum = jResult.CouponNum
            m_BranchCode = jResult.BranchCode
            m_PosNum = jResult.PosNum
            m_CouponName = jResult.CouponName
            m_StartDay = jResult.StartDay
            m_EndDay = jResult.EndDay
            m_UsePrice = jResult.UsePrice
            m_BalPrice = jResult.BalPrice
            m_SelPrice = jResult.SelPrice
            m_DUsePrice = jResult.DUsePrice
            m_UseYN = jResult.UseYN
            m_AuthDate = jResult.AuthDate
            m_BrandAuthCode = jResult.BrandAuthCode
            m_OriginalAuthCode = jResult.OriginalAuthCode
            m_ProductCode = jResult.ProductCode
        
            m_ErrorCode = m_ResultCode
            m_ResultMsg = m_ResultMsg

        Set jResult = Nothing
    else
        m_ResultCode = "9999"
        m_ErrorCode = m_ResultCode
        m_ResultMsg = m_ResultMsg
    End if
    '-- 응답 Json 파싱 | 끝 --

    end Sub
 

    Function ErrorCode(ErrCode)
        Dim Descript
        Select Case ErrCode
            Case "0000" Descript = "완료"
            Case "1000" Descript = "처리 유형(OperType)에 설정되지 않았습니다." '1000 번대 오류코드 자체 정의         
            Case "1001" Descript = "결제 취소시 승인번호가 반드시 필요합니다." '1000 번대 오류코드 자체 정의         
            Case "8001" Descript = "미존재 쿠폰입니다."
            Case "8002" Descript = "비정상 쿠폰 번호입니다."
            Case "8003" Descript = "기간만료 쿠폰입니다."
            Case "8005" Descript = "사용된 쿠폰입니다."
            Case "8006" Descript = "쿠폰타입 불일치 합니다."
            Case "8099" Descript = "결제취소 쿠폰입니다."
            Case "9981" Descript = "입력데이터 형식오류(NULL) 입니다."
            Case "9982" Descript = "데이터 오류입니다."
            Case "9983" Descript = "데이터 처리 실패입니다."          
            Case "9999" Descript = "기타 오류 입니다."
            Case Else Descript = "오류 입니다."
        End Select

        ErrorCode = Descript

    End Function


End Class

%>