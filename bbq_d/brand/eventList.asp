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
	curPage = GetReqNum("gotoPage",1)
	pageSize = GetReqNum("pageSize", 10)
	eventGbn = GetReqStr("event", "OPEN")
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
					<li<%If eventGbn = "OPEN" Then%> class="on"<%End If%>><a href="./eventList.asp?event=OPEN"><span>진행중인 이벤트</span></a></li>
					<li<%If eventGbn = "CLOSE" Then%> class="on"<%End If%>><a href="./eventList.asp?event=CLOSE"><span>지난 이벤트</span></a></li>
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

		.Parameters.Append .CreateParameter("@gubun", adVarChar, adParamInput, 10, "LIST")
		.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 2, "01")
		.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A02")
		.Parameters.Append .CreateParameter("@event", adVarChar, adParamInput, 10, eventGbn)
		.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
		.Parameters.Append .CreateParameter("@page", adInteger, adParamInput, , curPage)
		.Parameters.Append .CreateParameter("@TotalCount", adInteger, adParamOutput)

		Set vRs = .Execute

		TotalCount = .Parameters("@TotalCount").Value
	End With
	Set vCmd = Nothing

	If Not (vRs.BOF Or vRs.EOF) Then
%>
			<!-- 이벤트 목록 -->
			<div class="event-list">
<%
		Do Until vRs.EOF
%>
				<div class="box">
					<div class="img"><a href="./eventView.asp?eidx=<%=vRs("BIDX")%>&event=<%=eventGbn%>&gotoPage=<%=gotoPage%>"><img src="<%=vRs("imgpath")&vRs("imgname")%>" onerror="this.src='/images/brand/@event.jpg';" alt=""></a></div>
					<div class="info">
						<p class="subject"><a href="./eventView.asp"><%=vRs("title")%></a></p>
						<p class="date"><%=FormatDateTime(vRs("sdate"),2)%> ~ <%=FormatDateTime(vRs("edate"),2)%></p>
					</div>
				</div>
<%
			vRs.MoveNext
		Loop
%>
			</div>
			<!-- //이벤트 목록 -->
<%
	Else
%>
			<!-- 이벤트 목록 없을 때-->
			<div class="event-list">
				<div class="nomore">
					<div class="img"><img src="/images/brand/ico_nomore.png" alt=""></div>
					<div class="txt">현지 진행중인 이벤트가 없습니다.</div>
				</div>
			</div>
			<!-- //이벤트 목록 없을 때 -->
<%
	End If
	Set vRs = Nothing
%>
			<div class="board-pager-wrap">
				<div class="board-pager" id="paging_list"></div>
			</div>

			<script type="text/javascript">
				var html = makePaging({
					PageSize: "<%=pageSize%>",
					gotopage: "<%=gotopage%>",
					TotalCount: "<%=TotalCount%>",
					params: "event=<%=eventGbn%>"
				})
				$("#paging_list").html(html);
			</script>
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
