<!--#include virtual="/api/include/utf8.asp"-->
<%
	title_nm = "콘텐츠"
%>

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="<%=title_nm%>, BBQ치킨">
<meta name="Description" content="<%=title_nm%> 메인">
<title><%=title_nm%> | BBQ치킨</title>
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
			<h1 class="ta-l"><%=title_nm%></h1>
			<!--#include file="brand_tab.asp"-->
<%
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_board_select"

		.Parameters.Append .CreateParameter("@gubun", adVarChar, adParamInput, 10, "LIST")
		.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 2, "01")
		.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A07")
		.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
		.Parameters.Append .CreateParameter("@page", adInteger, adParamInput, , curPage)
		.Parameters.Append .CreateParameter("@TotalCount", adInteger, adParamOutput)

		Set vRs = .Execute

		TotalCount = .Parameters("@TotalCount").Value
	End With
	Set vCmd = Nothing

	If Not (vRs.BOF Or vRs.EOF) Then
%>
			<!-- 목록 -->
			<div class="event-list">
<%
		Do Until vRs.EOF
%>
				<div class="box">
					<div class="img"><a href="./contentsView.asp?idx=<%=vRs("BIDX")%>&gotoPage=<%=gotoPage%>"><img src="<%=SERVER_IMGPATH%><%=vRs("imgpath")%>/<%=vRs("imgname")%>" alt=""></a></div>
					<div class="info">
						<p class="subject"><a href="./contentsView.asp?idx=<%=vRs("BIDX")%>&gotoPage=<%=gotoPage%>"><%=vRs("title")%></a></p>
					</div>
				</div>
<%
			vRs.MoveNext
		Loop
%>
			</div>
			<!-- //목록 -->
<%
	Else
%>
			<!-- 목록 없을 때-->
			<div class="event-list">
				<div class="nomore">
					<div class="img"><img src="/images/brand/ico_nomore.png" alt=""></div>
					<div class="txt">현재 목록이 없습니다.</div>
				</div>
			</div>
			<!-- //목록 없을 때 -->
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
						gotoPage: "<%=curPage%>",
						TotalCount: "<%=TotalCount%>",
						params: ""
					});

					$("#paging_list").html(html);
				</script>
			</section>
		</article>
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
