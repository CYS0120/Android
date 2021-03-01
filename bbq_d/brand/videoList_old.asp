<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="브랜드스토리, BBQ치킨">
<meta name="Description" content="브랜드스토리 메인">
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
	curPage = GetReqNum("gotoPage", 1)
	pageSize = GetReqNum("pageSize", 10)
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
				<li>브랜드스토리</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1 class="ta-l">브랜드스토리</h1>
			<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li><a href="./bbq.asp"><span>비비큐 이야기</span></a></li>
					<li><a href="./oliveList.asp"><span>올리브 이야기</span></a></li>
					<li class="on"><a href="./videoList.asp"><span>영상콘텐츠</span></a></li>
				</ul>
			</div>

<%
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_board_select"

		.Parameters.Append .CreateParameter("@gubun", adVarChar, adParamInput, 10, "BEST")
		.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 2, "01")
		.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A01")

		Set vRs = .Execute
	End With
	Set vCmd = Nothing

	If Not (vRs.BOF Or vRs.EOF) Then
%>
			<!-- 비디오메인 -->
			<div class="section section_videoMain">
				<div class="video">
					<a href="./videoView.asp?vidx=<%=vRs("BIDX")%>&gotoPage=<%=gotoPage%>"><img src="<%=vRs("imgpath")&vRs("imgname")%>" width="740px" height="416px" onerror="this.src='http://placehold.it/740x416';" alt=""/></a>
				</div>
				<div class="info">
					<p class="subject"><%=vRs("title")%></p>
					<p class="con"><%=vRs("contents")%></p>
					<p class="link">
						<a href="./videoView.asp?vidx=<%=vRs("BIDX")%>&gotoPage=<%=gotoPage%>" class="btn btn-sm btn-grayLine">영상보기</a>
					</p>
				</div>
			</div>
			<!-- //비디오메인 -->
<%
	End If
	Set vRs = Nothing
%>
			<!-- 비디오 리스트 -->
			<div class="section section_videoList line mar-t50">
<%
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_board_select"

		.Parameters.Append .CreateParameter("@gubun", adVarChar, adParamInput, 10, "LIST")
		.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 2, "01")
		.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A01")
		.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
		.Parameters.Append .CreateParameter("@page", adInteger, adParamInput, , curPage)
		.Parameters.Append .CreateParameter("@TotalCount", adInteger, adParamOutput)

		Set vRs = .Execute

		TotalCount = .Parameters("@TotalCount").Value
	End With
	Set vCmd = Nothing

	If Not (vRs.BOF Or vRs.EOF) Then
		Do Until vRs.EOF
%>
				<div class="box">
					<div class="img"><a href="./videoView.asp?vidx=<%=vRs("BIDX")%>&gotoPage=<%=gotoPage%>"><img src="<%=vRs("imgpath")&vRs("imgname")%>" width="284px" height="159px" onerror="this.src='http://placehold.it/284x159';" alt=""/></a></div>
					<div class="txt"><a href="./videoView.asp?vidx=<%=vRs("BIDX")%>&gotoPage=<%=gotoPage%>"><%=vRs("title")%></a></div>
				</div>
<%
			vRs.MoveNext
		Loop
	End If
	Set vRs = Nothing
%>
			</div>
			<!-- //비디오 리스트 -->



			<div class="board-pager-wrap">
				<div class="board-pager" id="paging_list"></div>
			</div>
			<script type="text/javascript">
				var html = makePaging({
					PageSize: "<%=pageSize%>",
					gotoPage: "<%=curPage%>",
					TotalCount: "<%=TotalCount%>",
					params: ""
				});

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
