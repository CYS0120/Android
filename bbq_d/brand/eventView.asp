<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="비비큐 소식, BBQ치킨">
<meta name="Description" content="비비큐 소식 메인">
<title>비비큐 소식 | BBQ치킨</title>
<script>
jQuery(document).ready(function(e) {
	
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});
	
});
</script>
</head>
<%
	eidx = GetReqStr("eidx","")
	eventGbn = GetReqStr("event","")
	gotoPage = GetReqStr("gotoPage","")

	If eidx = "" Then
%>
	<script type="text/javascript">
		showAlertMsg({msg:"잘못된 접근입니다.", ok: function(){
			location.href = "/brand/eventList.asp?event=<%=eventGbn%>&gotoPage=<%=gotoPage%>";
		}});
	</script>
<%
		Response.End
	End If
%>
<body>	
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	<hr>
	
	<!-- Container -->
	<div class="container">
		<!-- BreadCrumb -->
		<div class="breadcrumb-wrap">
			<ul class="breadcrumb">
				<li>bbq home</li>
				<li>브랜드</li>
				<li>비비큐 소식</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1 class="ta-l">비비큐 소식</h1>
			<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li class="on"><a href="./eventList.asp"><span>진행중인 이벤트</span></a></li>
					<li><a href="./eventList.asp"><span>지난 이벤트</span></a></li>
					<li><a href="./noticeList.asp"><span>공지사항</span></a></li>
				</ul>
			</div>
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
			<div class="board-view">
				<div class="top">
					<h3>
						<%=vRs("title")%>
					</h3>
					<ul class="info">
						<li class="date"><strong>이벤트기간 :</strong> <%=FormatDateTime(vRs("sdate"),2)%> ~ <%=FormatDateTime(vRs("edate"), 2)%></li>
						<li class="hit"><strong>조회수 :</strong> <%=vRs("hit")+1%></li>
					</ul>
				</div>
				<div class="con">
					<%=vRs("contents")%>
				</div>
			</div>
			<!-- //게시판 뷰 -->
<%
	End If
%>

			<div class="btn-wrap two-up inner mar-t60">
				<a href="./eventList.asp?event=<%=eventGbn%>&gotoPage=<%=gotoPage%>" class="btn btn-lg btn-black"><span>목록</span></a>
			</div>

		</article>
		<!--// Content -->	
		
		<!-- QuickMenu -->
		<!--#include virtual="/includes/quickmenu.asp"-->
		<!-- QuickMenu -->

	</div>
	<!--// Container -->
	<hr>
	
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>
