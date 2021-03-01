<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "SUPER"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%

IDX	= InjRequest("IDX")
If FncIsBlank(IDX) Then 
	Response.Write "E^삭제할 계정을 선택해 주세요"
	Response.End
End If 

Sql = "	update bt_admin_user set use_yn = 'N', del_yn = 'Y' Where user_idx = " & IDX
conn.Execute(Sql)

Response.Write "Y^삭제 되었습니다"

%>