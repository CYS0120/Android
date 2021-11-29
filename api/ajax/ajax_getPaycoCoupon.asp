<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/coop_exchange_proc.asp"-->
<%
	'Dim txtPIN : txtPIN = Request("txtPIN")
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")

	' 111566019243 < 조성배차장님이 주신 테스트 쿠폰
    Dim txtPIN, PIN_save 
    txtPIN = GetReqStr("txtPIN","")
    PIN_save = GetReqStr("PIN_save","")

	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
		Response.Write "{""result"":1,""message"":""잘못된 접근방식 입니다.""}"
		Response.End 
	End If

	'If CheckLogin() Then
	'	USER_ID = Session("userId")
	'Else
	'	Response.Write "{""result"":1,""message"":""로그인 후 이용가능합니다.""}"
	'	Response.End 
	''	USER_ID = "P"& Session.sessionid
	'End If

    USER_IP = GetIPADDR()
    
    Url = COOP_API_URL     
    AuthKey = COOP_AUTH_KEY
    CompCode = COOP_COMPANY_CODE
    BranchCode = "0000"
    AuthPrice = "0"
    AuthDate = Replace(Date, "-", "") & Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)
    ProductCode = "0000"

    'response.write AuthDate

    Dim paycoPin
    paycoPin = GetReqStr("paycoPIN","")
    ' response.write "{""result"":0,""message"":""" & paycoPin & """}"
    Set couponIssueByPin = CouponIssueByPinV2(paycoPin)
    ' response.write "{""result"":0,""message"":""" & couponIssueByPin.mCode & """}"
    ' response.end
    If couponIssueByPin.mCode = 0 Then
        Response.Write "{""result"":0,""message"":""쿠폰 등록이 완료되었습니다.<br>맛있게 드세용 ~ ^^""}"
        response.end
    ElseIf couponIssueByPin.mCode = 3003 Then
        Response.Write "{""result"":1,""message"":""이미 등록되었거나 혜택을 받으신 쿠폰입니다.""}"
        response.end
    Else
        Response.Write "{""result"":1,""message"":""" & couponIssueByPin.mClientMessage & """}"
        response.end
    End If


%>