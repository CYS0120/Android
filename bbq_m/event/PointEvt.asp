<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/includes/top.asp"-->

<%
    If Not CheckLogin() Then
%>

<script type="text/javascript">
	showConfirmMsg({msg:"로그인 후 참여 가능합니다.",ok:function(){
	<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
		window.BBQAndroid.AOSLogin('openLogin()');
		document.location.replace("/");
	<% else %>
		openLogin();
		document.location.replace("/");
	<% End If %>
	},
	cancel: function(){
		history.back();
	}});
</script>

<%
        Response.End
    End If

	If Date > "2019-05-20" Then 
%>

<script type="text/javascript">
	alert("종료된 이벤트 입니다.");
	history.back();
</script>

<%
        Response.End
	End If 

	REG_IP = Request.ServerVariables("REMOTE_ADDR")

	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_event_point_check"

		.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , Session("userIdx"))
		.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
		.Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 15, REG_IP)
		.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
		.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

		.Execute

		errCode = .Parameters("@ERRCODE").Value
		errMsg = .Parameters("@ERRMSG").Value
	End With
	Set aCmd = Nothing

	dbconn.close
	Set dbconn = Nothing
%>

<script type="text/javascript">
	alert("<%=errMsg%>");
	document.location.replace("/");
</script>
