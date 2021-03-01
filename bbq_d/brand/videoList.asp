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

<script>
function open_frame(id) {
	var url = 'https://www.youtube.com/embed/';
	$('#mainVideo').attr('src', url+id);
}
</script>
			<section class="section content-video">
<%
	pageSize = 8
	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_Board_GetList"
		.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
		.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
		.Parameters.Append .CreateParameter("@cPage", adInteger, adParamInput, , 1)
		.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
		.Parameters.Append .CreateParameter("@Order", adVarChar, adParamInput, 5, "TOP")
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
		.Parameters.Append .CreateParameter("@BBS_CODE", adVarChar, adParamInput, 5, "A01")
		Set bRs = .Execute
	End With
	Set bCmd = Nothing
	If Not (bRs.BOF Or bRs.EOF) Then
		TITLE = bRs("TITLE")
		URL_LINK = bRs("URL_LINK")
%>
				<!-- 비디오메인 -->
				<div class="section section_videoMain">
					<div class="video">
						<iframe id="mainVideo" width="740" height="416" src="https://www.youtube.com/embed/<%=URL_LINK%>" title="BBQ CF" allowfullscreen=""></iframe>
					</div>
					<div class="info">
						<p class="subject"><%=TITLE%></p>
					</div>
				</div>
				<!-- //비디오메인 -->
<%	End If %>
				<!-- 비디오 리스트 -->
				<div class="section section_videoList line mar-t50">
<%
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_Board_GetList"
		.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "LIST")
		.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
		.Parameters.Append .CreateParameter("@cPage", adInteger, adParamInput, , curPage)
		.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
		.Parameters.Append .CreateParameter("@Order", adVarChar, adParamInput, 5, "")
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
		.Parameters.Append .CreateParameter("@BBS_CODE", adVarChar, adParamInput, 5, "A01")
		Set vRs = .Execute

		TotalCount = .Parameters("@totalCount").Value
	End With
	Set vCmd = Nothing

	If Not (vRs.BOF Or vRs.EOF) Then
		Do Until vRs.EOF
			TITLE = vRs("TITLE")
			URL_LINK = vRs("URL_LINK")
			IMGNAME = vRs("IMGNAME")
%>
					<div class="box">
						<div class="img"><img src="<%=SERVER_IMGPATH%>/bbsimg/<%=IMGNAME%>" alt="BBQ CF" style="width:284px;height:159px;cursor:pointer" onclick="open_frame('<%=URL_LINK%>')"/></div>
						<div class="txt"><%=TITLE%></div>
					</div>
<%
			num = num - 1
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
			</section>
		
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
