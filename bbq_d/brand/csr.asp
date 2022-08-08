<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="브랜드스토리, BBQ치킨">
<meta name="Description" content="브랜드스토리 메인">
<title>브랜드스토리 | BBQ치킨</title>
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
				<li>사회공헌활동</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content content-wide">
			<div class="inner">
				<h1 class="ta-l">사회공헌활동</h1>
				<div class="tab-wrap tab-type3 leng2">
					<ul class="tab">
						<li class="on"><a href="./csr.asp"><span>사회공헌활동 게시판</span></a></li>
						<li><a href="./bbcar.asp"><span>찾아가는 치킨릴레이 사연 신청 게시판</span></a></li>
					</ul>
				</div>
			</div>

			<section class="section section_bbqStroy">
				<div class="bbqStroy_happy">
					<div class="inner">
						<h3>사회공헌 갤러리</h3>
						<div class="txt-basic ta-c mar-t40">
							비비큐가 사회에 전하는 따뜻한 마음을 담았습니다.
						</div>
					</div>
				</div>
				
				<%
				dim pageSize: pageSize = 3*3 '열3개 고정 * 줄 3개(변경가능)
				dim totalCount: totalCount = 0
				dim gotoPage
				gotoPage = GetReqStr("gotoPage", "1")
				Set bCmd = Server.CreateObject("ADODB.Command")
				With bCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_board_select"
					.Parameters.Append .CreateParameter("@gubun", adVarChar, adParamInput, 10, "LIST")
					.Parameters.Append .CreateParameter("@brand_code", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
					.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A08")
					.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
					.Parameters.Append .CreateParameter("@page", adInteger, adParamInput, , gotoPage)
					.Parameters.Append .CreateParameter("@TotalCount", adInteger, adParamOutput)
					Set bRs = .Execute

					totalCount = .Parameters("@totalCount").Value
				End With
				Set bCmd = Nothing
				If Not (bRs.BOF Or bRs.EOF) Then
				%>				
					<div class="thumList inner mar-t40">
					<%
						Do Until bRs.EOF
							title = bRs("title")
							url_link = "./csrView.asp?bidx=" & bRs("BIDX") & "&gotoPage=" & gotoPage
							img_link = SERVER_IMGPATH & bRs("imgpath") & "/" & bRs("imgname")

						%>
							<div class="thumItem">
								<a href="<%=url_link%>">
									<img src="<%=img_link%>" alt="<%=title%>">
									<span class="title"><%=title%></span>
								</a>
							</div>
						<%
							bRs.MoveNext
						Loop
						%>
						
					</div>
					<%
				Else
				%>
					<div class="txt-basic ta-c mar-t100">등록된 내역이 없습니다.</div>
				<%
				End If
				%>
				
				<!--
				<div class="thum">
					<ul>
						<li>
							<a href="javascript:goView('1');">
								<img src="https://img.bbq.co.kr:449/uploads/bbq_d/main/자사웹배너(41).png" alt="">
								<span>제목</span>
							</a>
						</li>
						<li>
							<a href="javascript:goView('2');">
								<img src="https://img.bbq.co.kr:449/uploads/bbq_d/main/자사웹배너(41).png" alt="">
								<span>제목ggggggg</span>
							</a>
						</li>
					</ul>
				</div>
				-->

			</section>
			
			<%if totalCount > 0 then %>
			<div class="board-pager-wrap">
				<div class="board-pager" id="paging_list"></div>
			</div>

			<script type="text/javascript">
				var html = makePaging({
					PageSize: "<%=pageSize%>",
					gotoPage: "<%=gotoPage%>",
					TotalCount: "<%=totalCount%>",
					params: ""
				});

				$("#paging_list").html(html);
			</script>
			<%end if%>
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
