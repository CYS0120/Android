<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
</head>
<%
	eidx = GetReqStr("eidx","")
	eventGbn = GetReqStr("event","")
	gotoPage = GetReqStr("gotoPage","")

	If eidx = "" Then
%>
	<script type="text/javascript">
		showAlertMsg({msg:"잘못된 접근입니다.", ok: function(){
			history.back();
		}});
	</script>
<%
		Response.End
	End If
%>
<body>
<div class="wrapper">
<%
	PageTitle = "브랜드"
%>
	<!--#include virtual="/includes/header.asp"-->
	<hr>

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		<hr>
			
		<!-- Content -->
		<article class="content">

			<!-- Tab -->
			<div class="tab-wrap tab-type2">
				<ul class="tab">
					<li><a href="/brand/bbq.asp"><span>브랜드스토리</span></a></li>
					<li class="on"><a href="/brand/eventList.asp"><span>비비큐 소식</span></a></li>
				</ul>
			</div>
			<!--// Tab -->

			<!-- Tab -->
			<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li class="on"><a href="/brand/eventList.asp"><span>진행중인 이벤트</span></a></li>
					<li><a href="/brand/eventList.asp"><span>지난 이벤트</span></a></li>
					<li><a href="/brand/noticeList.asp"><span>공지사항</span></a></li>
				</ul>
			</div>
			<!--// Tab -->
<%
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_board_select"

		.Parameters.Append .CreateParameter("@gubun", adVarChar, adParamInput, 10, "ONE")
		.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 2, "01")
		.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A02")
		.Parameters.Append .CreateParameter("@BIDX", adInteger, adParamInput, , eidx)

		Set vRs = .Execute
	End With
	Set vCmd = Nothing

	If Not (vRs.BOF Or vRs.EOF) Then
		Set vCmd = Server.CreateObject("ADODB.Command")
		With vCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_board_hit"

			.Parameters.Append .CreateParameter("@BIDX", adInteger, adParamInput,, eidx)

			.Execute
		End With
		Set vCmd = Nothing
%>

			<!-- 게시판 뷰 -->
			<div class="inner">
				<div class="board-view">
					<div class="top">
						<h3>
							<%=vRs("title")%>
						</h3>
						<ul class="info">
							<li class="date">등록일 : <%=FormatDateTime(vRs("reg_date"),2)%></li>
							<li class="hit">조회수 : <%=vRs("hit")+1%></li>
						</ul>
					</div>
					<div class="con">
						<%=vRs("contents")%>
					</div>
				</div>
			</div>
			<!-- //게시판 뷰 -->
<%
	End If
%>
			<div class="mar-t40">
				<div class="inner">
					<a href="javascript:history.back();" class="btn btn-lg btn-black w-100p">목록</a>
				</div>
			</div>



		</article>
		<!--// Content -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->
	</div>
	<!--// Container -->
	<hr>

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>