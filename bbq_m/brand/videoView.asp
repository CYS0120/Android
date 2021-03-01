<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

</head>

<%
	vidx = GetReqStr("vidx","")
	gotoPage = GetReqStr("gotoPage","")

	If vidx = "" Then
%>

<script type="text/javascript">
	showAlertMsg({msg:"질못된 접근입니다.", ok: function(){
		location.href = "/brand/videoList.asp?gotoPage=<%=gotoPage%>";
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

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content">

			<!-- Tab -->
			<div class="tab-wrap tab-type2">
				<ul class="tab">
					<li class="on"><a href="/brand/bbq.asp"><span>브랜드스토리</span></a></li>
					<li><a href="/brand/noticeList.asp"><span>공지사항</span></a></li>
				</ul>
			</div>
			<!--// Tab -->

			<!-- Tab -->
			<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li><a href="/brand/bbq.asp"><span>비비큐 이야기</span></a></li>
					<li><a href="/brand/oliveList.asp"><span>올리브 이야기</span></a></li>
					<li class="on"><a href="/brand/videoList.asp"><span>영상콘텐츠</span></a></li>
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
					.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A01")
					.Parameters.Append .CreateParameter("@BIDX", adInteger, adParamInput,, vidx)

					Set vRs = .Execute
				End With
				Set vCmd = Nothing

				If Not (vRs.BOF Or vRs.EOF) Then
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
							<li class="hit">조회수 : <%=vRs("hit")%></li>
						</ul>
					</div>
					<div class="con">
						<div class="iframe-video">
							<iframe src="<%=vRs("url_link")%>" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
						</div>
						<%=vRs("contents")%>
					</div>
				</div>
			</div>
			<!-- //게시판 뷰 -->

			<%
				Else
			%>

			<script type="text/javascript">
				showAlertMsg({msg:"검색된 결과가 없습니다.", ok: function(){
					location.href = "/brand/videoList.asp?gotoPage=<%=gotoPage%>";
				}});
			</script>

			<%
				End If
			%>

			<div class="mar-t40">
				<div class="inner">
					<a href="/brand/videoList.asp?gotoPage=<%=gotoPage%>" class="btn btn-lg btn-black w-100p">목록</a>
				</div>
			</div>

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
