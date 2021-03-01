<%

Class PosResult
    public m_ProductCode
    public m_StatusCode
    public m_ErrorCode
    public m_ErrorMessage
    public m_AdmitNum
    public m_UsedBranchCode
    public m_UsedBranchName
    public m_UsedDate
    public m_UsedTime
    public m_EventCode

    '' OperType 타입 종류
    ' info : 조회
    ' use : 사용처리
    ' cancel : 취소처리
    Sub Smartcon_Proc (OperType, CouponNum, BranchCode, BranchName, PosCode, PosDate, PosTime, AdmitNum)

        PosTime = Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)

        strUrl = "http://183.111.10.70/edenredauth/smartconposauthproc.sc?"

        if OperType = "info" then
            MsgSubCode = "100"
        Elseif OperType = "use" then
            MsgSubCode = "101"
        elseif OperType = "cancel" then
            MsgSubCode = "102"
        else
            exit sub
        end if

        strUrl = strUrl & "MsgSubCode=" & MsgSubCode & "&notuseSup=1&supID=EC0164&CouponNum=" & CouponNum
        strUrl = strUrl & "&BranchCode=" & BranchCode
        strUrl = strUrl & "&PosCode=" & PosCode
        strUrl = strUrl & "&PosDate=" & PosDate
        strUrl = strUrl & "&PosTime=" & PosTime
        strUrl = strUrl & "&AdmitNum=" & AdmitNum
        strUrl = strUrl & "&BranchName=" & Server.URLEncode(BranchName)

        Set xmlHttp = Server.Createobject("MSXML2.ServerXMLHTTP")
        xmlHttp.Open "GET", strUrl, False
        xmlHttp.SetTimeouts 6000, 6000, 6000, 6000  ' 6초 타임아웃 설정

        xmlHttp.setRequestHeader "User-Agent", "asp httprequest"
		xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded,charset=euc-kr"
        xmlHttp.Send

        if xmlHttp.status = 200 then

            Set dom = xmlHttp.responseXML
            'response.write dom.xml & "<br><br>"

            Set itemStausCode = dom.getElementsByTagName("StatusCode")
            m_StatusCode = itemStausCode(0).Text

            Set itemErrorCode = dom.getElementsByTagName("ErrorCode")
            m_ErrorCode = itemErrorCode(0).Text

            Set itemErrorMessage = dom.getElementsByTagName("ErrorMessage")
            m_ErrorMessage = itemErrorMessage(0).Text

            Set itemAdmitNum = dom.getElementsByTagName("AdmitNum")
            m_AdmitNum = itemAdmitNum(0).Text

            Set itemProductCode = dom.getElementsByTagName("ProductCode")
            if itemProductCode.length > 0 then
                m_ProductCode = itemProductCode(0).Text
            else
                m_ProductCode = ""
            end if

            Set itemUsedBranchCode = dom.getElementsByTagName("UsedBranchCode")
            if itemUsedBranchCode.length > 0 then
                m_UsedBranchCode = itemUsedBranchCode(0).Text
            else
                m_UsedBranchCode = ""
            end if

            Set itemUsedBranchName = dom.getElementsByTagName("UsedBranchName")
            if itemUsedBranchName.length > 0 then
                m_UsedBranchName = itemUsedBranchName(0).Text
            else
                m_UsedBranchName = ""
            end if

            Set itemUsedDate = dom.getElementsByTagName("UsedDate")
            if itemUsedDate.length > 0 then
                m_UsedDate = itemUsedDate(0).Text
            else
                m_UsedDate = ""
            end if

            Set itemUsedTime = dom.getElementsByTagName("UsedTime")
            if itemUsedTime.length > 0 then
                m_UsedTime = itemUsedTime(0).Text
            else
                m_UsedTime = ""
            end if

            Set itemEventCode = dom.getElementsByTagName("EventCode")
            if itemEventCode.length > 0 then
                m_EventCode = itemEventCode(0).Text
            else
                m_EventCode = ""
            end if
        else
            m_StatusCode = "001"
            m_ErrorCode = "E9901"
            m_ErrorMessage = "통신 지연으로 요청이 처리되지 않았습니다."
        end if

        xmlHttp.abort()
        set xmlHttp = Nothing
    end Sub

    Sub ProcCheck (CouponNum, BranchCode, BranchName, PosCode, PosDate, PosTime)

        PosTime = Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)

        strUrl = "http://b2b.giftsmartcon.com/edenredauth/smartconposauthproc.sc?"

        strUrl = strUrl & "MsgSubCode=100&notuseSup=1&supID=EC0164&CouponNum=" & CouponNum
        strUrl = strUrl & "&BranchCode=" & BranchCode
        strUrl = strUrl & "&PosCode=" & PosCode
        strUrl = strUrl & "&PosDate=" & PosDate
        strUrl = strUrl & "&PosTime=" & PosTime
        strUrl = strUrl & "&AdmitNum=" & ""
        strUrl = strUrl & "&BranchName=" & Server.URLEncode(BranchName)

        Set xmlHttp = Server.Createobject("MSXML2.ServerXMLHTTP")
        xmlHttp.Open "GET", strUrl, False
        xmlHttp.setRequestHeader "User-Agent", "asp httprequest"
		xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded,charset=euc-kr"
        xmlHttp.Send

        if xmlHttp.status = 200 then

            Set dom = xmlHttp.responseXML
            'response.write dom.xml & "<br><br>"

            Set itemStausCode = dom.getElementsByTagName("StatusCode")
            m_StatusCode = itemStausCode(0).Text

            Set itemErrorCode = dom.getElementsByTagName("ErrorCode")
            m_ErrorCode = itemErrorCode(0).Text

            Set itemErrorMessage = dom.getElementsByTagName("ErrorMessage")
            m_ErrorMessage = itemErrorMessage(0).Text

            Set itemAdmitNum = dom.getElementsByTagName("AdmitNum")
            m_AdmitNum = itemAdmitNum(0).Text

            Set itemProductCode = dom.getElementsByTagName("ProductCode")
            if itemProductCode.length > 0 then
                m_ProductCode = itemProductCode(0).Text
            else
                m_ProductCode = ""
            end if

            Set itemUsedBranchCode = dom.getElementsByTagName("UsedBranchCode")
            if itemUsedBranchCode.length > 0 then
                m_UsedBranchCode = itemUsedBranchCode(0).Text
            else
                m_UsedBranchCode = ""
            end if

            Set itemUsedBranchName = dom.getElementsByTagName("UsedBranchName")
            if itemUsedBranchName.length > 0 then
                m_UsedBranchName = itemUsedBranchName(0).Text
            else
                m_UsedBranchName = ""
            end if

            Set itemUsedDate = dom.getElementsByTagName("UsedDate")
            if itemUsedDate.length > 0 then
                m_UsedDate = itemUsedDate(0).Text
            else
                m_UsedDate = ""
            end if

            Set itemUsedTime = dom.getElementsByTagName("UsedTime")
            if itemUsedTime.length > 0 then
                m_UsedTime = itemUsedTime(0).Text
            else
                m_UsedTime = ""
            end if

            Set itemEventCode = dom.getElementsByTagName("EventCode")
            if itemEventCode.length > 0 then
                m_EventCode = itemEventCode(0).Text
            else
                m_EventCode = ""
            end if
        else
            m_StatusCode = "001"
            m_ErrorCode = "E9901"
            m_ErrorMessage = "통신 지연으로 요청이 처리되지 않았습니다."
        end if

        xmlHttp.abort()
        set xmlHttp = Nothing
    end Sub


    Sub ProcExchange (CouponNum, BranchCode, BranchName, PosCode, PosDate, PosTime)

        PosTime = Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)

        strUrl = "http://b2b.giftsmartcon.com/edenredauth/smartconposauthproc.sc?"

        strUrl = strUrl & "MsgSubCode=101&notuseSup=1&supID=EC0164&CouponNum=" & CouponNum
        strUrl = strUrl & "&BranchCode=" & BranchCode
        strUrl = strUrl & "&PosCode=" & PosCode
        strUrl = strUrl & "&PosDate=" & PosDate
        strUrl = strUrl & "&PosTime=" & PosTime
        strUrl = strUrl & "&BranchName=" & Server.URLEncode(BranchName)

        Set xmlHttp = Server.Createobject("MSXML2.ServerXMLHTTP")
        xmlHttp.Open "GET", strUrl, False
        xmlHttp.setRequestHeader "User-Agent", "asp httprequest"
		xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded,charset=euc-kr"
        xmlHttp.Send

        if xmlHttp.status = 200 then

            Set dom = xmlHttp.responseXML
            'response.write dom.xml & "<br><br>"

            Set itemStausCode = dom.getElementsByTagName("StatusCode")
            m_StatusCode = itemStausCode(0).Text

            Set itemErrorCode = dom.getElementsByTagName("ErrorCode")
            m_ErrorCode = itemErrorCode(0).Text

            Set itemErrorMessage = dom.getElementsByTagName("ErrorMessage")
            m_ErrorMessage = itemErrorMessage(0).Text

            Set itemAdmitNum = dom.getElementsByTagName("AdmitNum")
            m_AdmitNum = itemAdmitNum(0).Text

            Set itemProductCode = dom.getElementsByTagName("ProductCode")
            if itemProductCode.length > 0 then
                m_ProductCode = itemProductCode(0).Text
            else
                m_ProductCode = ""
            end if

            Set itemUsedBranchCode = dom.getElementsByTagName("UsedBranchCode")
            if itemUsedBranchCode.length > 0 then
                m_UsedBranchCode = itemUsedBranchCode(0).Text
            else
                m_UsedBranchCode = ""
            end if

            Set itemUsedBranchName = dom.getElementsByTagName("UsedBranchName")
            if itemUsedBranchName.length > 0 then
                m_UsedBranchName = itemUsedBranchName(0).Text
            else
                m_UsedBranchName = ""
            end if

            Set itemUsedDate = dom.getElementsByTagName("UsedDate")
            if itemUsedDate.length > 0 then
                m_UsedDate = itemUsedDate(0).Text
            else
                m_UsedDate = ""
            end if

            Set itemUsedTime = dom.getElementsByTagName("UsedTime")
            if itemUsedTime.length > 0 then
                m_UsedTime = itemUsedTime(0).Text
            else
                m_UsedTime = ""
            end if

            Set itemEventCode = dom.getElementsByTagName("EventCode")
            if itemEventCode.length > 0 then
                m_EventCode = itemEventCode(0).Text
            else
                m_EventCode = ""
            end if
        else
            m_StatusCode = "001"
            m_ErrorCode = "E9901"
            m_ErrorMessage = "통신 지연으로 요청이 처리되지 않았습니다."
        end if

        xmlHttp.abort()
        set xmlHttp = Nothing
    end Sub


    Sub ProcUnexchange (CouponNum, BranchCode, BranchName, PosCode, PosDate, PosTime)

        PosTime = Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)

        strUrl = "http://b2b.giftsmartcon.com/edenredauth/smartconposauthproc.sc?"

        strUrl = strUrl & "MsgSubCode=102&notuseSup=1&supID=EC0164&CouponNum=" & CouponNum
        strUrl = strUrl & "&BranchCode=" & BranchCode
        strUrl = strUrl & "&PosCode=" & PosCode
        strUrl = strUrl & "&PosDate=" & PosDate
        strUrl = strUrl & "&PosTime=" & PosTime
        strUrl = strUrl & "&BranchName=" & Server.URLEncode(BranchName)

        Set xmlHttp = Server.Createobject("MSXML2.ServerXMLHTTP")
        xmlHttp.Open "GET", strUrl, False
        xmlHttp.setRequestHeader "User-Agent", "asp httprequest"
		xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded,charset=euc-kr"
        xmlHttp.Send

        if xmlHttp.status = 200 then

            Set dom = xmlHttp.responseXML
            'response.write dom.xml & "<br><br>"

            Set itemStausCode = dom.getElementsByTagName("StatusCode")
            m_StatusCode = itemStausCode(0).Text

            Set itemErrorCode = dom.getElementsByTagName("ErrorCode")
            m_ErrorCode = itemErrorCode(0).Text

            Set itemErrorMessage = dom.getElementsByTagName("ErrorMessage")
            m_ErrorMessage = itemErrorMessage(0).Text

            Set itemAdmitNum = dom.getElementsByTagName("AdmitNum")
            m_AdmitNum = itemAdmitNum(0).Text

            Set itemProductCode = dom.getElementsByTagName("ProductCode")
            if itemProductCode.length > 0 then
                m_ProductCode = itemProductCode(0).Text
            else
                m_ProductCode = ""
            end if

            Set itemUsedBranchCode = dom.getElementsByTagName("UsedBranchCode")
            if itemUsedBranchCode.length > 0 then
                m_UsedBranchCode = itemUsedBranchCode(0).Text
            else
                m_UsedBranchCode = ""
            end if

            Set itemUsedBranchName = dom.getElementsByTagName("UsedBranchName")
            if itemUsedBranchName.length > 0 then
                m_UsedBranchName = itemUsedBranchName(0).Text
            else
                m_UsedBranchName = ""
            end if

            Set itemUsedDate = dom.getElementsByTagName("UsedDate")
            if itemUsedDate.length > 0 then
                m_UsedDate = itemUsedDate(0).Text
            else
                m_UsedDate = ""
            end if

            Set itemUsedTime = dom.getElementsByTagName("UsedTime")
            if itemUsedTime.length > 0 then
                m_UsedTime = itemUsedTime(0).Text
            else
                m_UsedTime = ""
            end if

            Set itemEventCode = dom.getElementsByTagName("EventCode")
            if itemEventCode.length > 0 then
                m_EventCode = itemEventCode(0).Text
            else
                m_EventCode = ""
            end if
        else
            m_StatusCode = "001"
            m_ErrorCode = "E9901"
            m_ErrorMessage = "통신 지연으로 요청이 처리되지 않았습니다."
        end if

        xmlHttp.abort()
        set xmlHttp = Nothing
    end Sub

    Function ErrorCode(ErrCode)
        Dim Descript
        Select Case ErrCode
            Case "E0000" Descript = "성공"
            Case "E0001" Descript = "연동 프로토콜 버전이 일치하지 않습니다."
            Case "E0002" Descript = "전송한 쿠폰 번호가 일치하지 않습니다."
            Case "E0003" Descript = "이 쿠폰은 본 매장에서 사용할 수 없습니다."
            Case "E0004" Descript = "쿠폰번호 검증에 실패했습니다. 다시 확인하시기 바랍니다. (=result invalid)"
            Case "E0005" Descript = "쿠폰 번호가 유효하지 않습니다. 다시 확인하시기 바랍니다.(=result not exist)"
            Case "E0006" Descript = "이미 사용된 쿠폰입니다."
            Case "E0007" Descript = "사용 기간이 경과되어 사용할 수 없는 쿠폰입니다."
            Case "E0008" Descript = "잘못된 데이터를 수신했습니다. 다시 시도해 주시기 바랍니다."
            Case "E0009" Descript = "사용되지 않은 쿠폰입니다."
            Case "E0010" Descript = "이미 교환취소되었습니다."
            Case "E0011" Descript = "교환당일이 아니면 반품이 불가능합니다."
            Case "E0012" Descript = "수신번호가 일치하지 않습니다."
            Case "E0013" Descript = "헤더의 수신자번호처리 타입이 제휴사관련 동록 내용과  다릅니다."
            Case "E0100" Descript = "서버에서 에러가 발생했습니다. 잠시 후 다시 시도해 주세요."
            Case "E0101" Descript = "해당하는 승인번호가 존재하지 않습니다."
            Case "E0102" Descript = "미교환상태여서 교환취소를 할 수 없습니다."
            Case "E0103" Descript = "해당 제휴사에서 교환되지 않았으므로 교환취소 할 수 없습니다."
            Case "E0104" Descript = "반품(교환취소) 가능기간이 지나서 반품이 불가능합니다."
            Case "E0105" Descript = "망취소가 정상 처리 되었습니다."
            Case "E0106" Descript = "입력 승인번호 오류입니다."
            Case "E0107" Descript = "교환처리 지점 코드가  일치하지 않습니다."
            Case "E9000" Descript = "접속이 허용되지 않은 IP입니다."
            Case "E9001" Descript = "잘못된 파라메터입니다."
            Case "E9901" Descript = "통신 지연으로 요청이 처리되지 않았습니다."
            Case Else Descript = "Error"
        End Select

        ErrorCode = Descript

    End Function

End Class


'SET Result = NEW PosResult
'Result.ProcExchange "111723957135","testcode","테스트","00","20140812","133412"

'response.write Result.m_StatusCode & "<br>"
'response.write Result.m_ErrorCode & "<br>"

'Result.ProcUnexchange "111723957135","testcode","테스트","00","20140812","133412"
'Result.Smartcon_Proc "cancel", "111512334150", "1146001", "1146001", "0", Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)
'response.write Result.m_StatusCode & "<br>"
'response.write Result.m_ErrorCode & "<br>"

%>