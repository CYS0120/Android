<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="비비큐 소식, BBQ치킨">
<meta name="Description" content="비비큐 소식 메인">
<title>공지사항 | BBQ치킨</title>
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
	gotoPage = GetReqNum("gotoPage",1)
	pageSize = GetReqNum("pageSize", 10)
	searchStr = GetReqStr("searchStr", "")
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
				<li>공지사항</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1 class="ta-l">공지사항</h1>
			<!--<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li><a href="./eventList.asp?event=OPEN"><span>진행중인 이벤트</span></a></li>
					<li><a href="./eventList.asp?event=CLOSE"><span>지난 이벤트</span></a></li>
					<li class="on"><a href="./noticeList.asp"><span>공지사항</span></a></li>
				</ul>
			</div>-->

			<div class="icon-top">
				<div class="img"><img src="/images/brand/ico_big_notice.gif" alt=""></div>
				<h3>BBQ의 새롭고 다양한 소식들을 전해드립니다. 꼭 알아두셔야 할 사항이나 유익한 정보도 확인하세요.</h3>
			</div>

			<table border="1" cellspacing="0" class="tbl-list">
				<caption>상품문의</caption>
				<colgroup>
					<col style="width:106px;">
					<col style="width:auto;">
					<col style="width:180px;">
					<col style="width:150px;">
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>작성일</th>
						<th>조회</th>
					</tr>
				</thead>
				<tbody>
					<tr style="background-color:#ffabab">
						<td></td>
						<td class="ta-l">
							<a href="./noticeView_smile.asp">ESG 청년 스마일 프로젝트 지원자 현황</a>
						</td>
						<td>2021-07-05</td>
						<td>-</td>
					</tr>
<%
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_Board_NoticeList"
		.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "LIST")
		.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
		.Parameters.Append .CreateParameter("@cPage", adInteger, adParamInput, , gotoPage)
		.Parameters.Append .CreateParameter("@sKey", adVarChar, adParamInput, 20, "TITLE")
		.Parameters.Append .CreateParameter("@sWord", adVarChar, adParamInput, 50, searchStr)
		.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
		.Parameters.Append .CreateParameter("@BBS_CODE", adVarChar, adParamInput, 5, "A03")
		Set vRs = .Execute

		TotalCount = .Parameters("@totalCount").Value
	End With
	Set vCmd = Nothing
	If TotalCount = 0 Then
		first  = 1
	Else
		first  = pageSize * (gotoPage - 1)
	End If 

	If Not (vRs.BOF Or vRs.EOF) Then
		num	= TotalCount - first
		Do Until vRs.EOF
%>
					<tr>
						<td><%=num%></td>
						<td class="ta-l">
							<a href="./noticeView.asp?nidx=<%=vRs("BIDX")%>&gotoPage=<%=gotoPage%>"><%=vRs("title")%></a>
						</td>
						<td><%=FormatDateTime(vRs("reg_date"),2)%></td>
						<td><%=vRs("hit")%></td>
					</tr>
<%
			num = num - 1
			vRs.MoveNext
		Loop
	End If
	Set vRs = Nothing
%>
				</tbody>
			</table>

			<div class="board-pager-wrap">
				<div class="board-pager" id="paging_list"></div>
			</div>

			<script type="text/javascript">
				var html = makePaging({
					PageSize: "<%=pageSize%>",
					gotoPage: "<%=gotoPage%>",
					TotalCount: "<%=TotalCount%>",
					params: ""
				});

				$("#paging_list").html(html);
			</script>
			<div class="mar-t30 ta-c search-board">
				<form>
					<input type="text" placeholder="글제목" name="searchStr" value="<%=searchStr%>">
					<button type="submit" class="btn btn-md3 btn-black">검색</button>
				</form>
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
