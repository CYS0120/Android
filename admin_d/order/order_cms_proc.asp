<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
orderid		= InjRequest("orderid")
cms_type	= InjRequest("cms_type")
username	= InjRequest("username")
sms_msg		= InjRequest("note1")
proc		= InjRequest("proc")

If FncIsBlank(orderid) Or FncIsBlank(username) Or FncIsBlank(sms_msg) Or FncIsBlank(proc) Then 
	Response.Write "E^필수 정보를 모두 입력해 주세요"
	Response.End
End If 

If proc = "C" Then
	cms_type = "CANC"
Else
	cms_type = "INFO"
End If


If proc = "C" Then	'주문취소 처리
    host = CANCEL_BBQ_DOMAIN & "/pay/pay_cancel.asp"
    'host = "/pay/pay_cancel.asp"  ' 2021-07 더페이 상품권 복수 처리 테스트용
    
	params = "order_id=" & orderid & "&sms_msg=" & sms_msg
	 
	html_result = URL_Send(host, params)
    'Response.write "result_full : " & html_result & "<BR>"
    arr_result = Split(html_result&"|", "|")

    If Trim(arr_result(0)) = "SUCC" Then
		Response.Write "Y^등록 되었습니다"
    Else
		Response.Write "E^결제 취소가 실패했습니다" & arr_result(1)
		Response.End 
    End If
Else
	Response.Write "Y^등록 되었습니다"
End If 

Sql = "	Insert "& BBQHOME_DB &".DBO.T_CMS_LOG(orderid, username, note1, regdate, cms_type) " & _
	"	Values('"& orderid &"','"& username &"','"& sms_msg &"', GetDate(), '"& cms_type &"')"
conn.Execute(Sql)

conn.Close
Set conn = Nothing 
%>