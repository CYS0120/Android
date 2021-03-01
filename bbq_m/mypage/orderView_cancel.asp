<!-- #include virtual="/inc/config.asp" -->
<!--#include virtual="/api/include/db_open.asp"-->
<%
	CUR_PAGE_CODE = "B"
	PROCESS_PAGE = "Y"
%>

<%
orderid		= InjRequest("orderid")
cms_type	= InjRequest("cms_type")
username	= "고객 직접취소" ' 없음
sms_msg		= "고객 직접취소"
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
	' 상태가 P (고객주문접수) 인지 체크
	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_order_select_one"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
		.Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput, 50, orderid)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing

	' 주문이 있는지 없는지
	If Not (aRs.BOF Or aRs.EOF) Then
		vOrderStatus = aRs("order_status")

		' 결제 취소 할수 있는 상태인지
		if vOrderStatus <> "P" then 
			Response.Write "E^이미 매장에 주문이 전달 되어 온라인 취소가 불가능 합니다."
			Response.End 
		end if 
	Else
		Response.Write "E^결제 취소가 실패했습니다"
		Response.End 
	end if 


    host = CANCEL_BBQ_DOMAIN & "/pay/pay_cancel.asp"
    params = "order_id="&orderid&"&sms_msg="&sms_msg
	html_result = URL_Send(host, params)
'    Response.write "result_full : " & html_result & "<BR>"
    arr_result = Split(html_result, "|")

    If Trim(arr_result(0)) = "SUCC" Then
		Response.Write "Y^결제 취소 되었습니다"
    Else
		Response.Write "E^결제 취소가 실패했습니다"&arr_result(1)
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