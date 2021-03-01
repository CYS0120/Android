<!--#include virtual="/api/include/utf8.asp"-->
<%
	curPage = GetReqNum("gotoPage",1)
	pageSize = GetReqNum("pageSize", 10)
	eventGbn = GetReqStr("event", "OPEN")
%>
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<script type="text/javascript">
	var page = 1;
	function getList() {
		$.ajax({
			method: "post",
			url: "/api/ajax/ajax_getBoardList.asp",
			data: {brand_code:"01", bbs_code: "A02", event:"<%=eventGbn%>", gotoPage: page, pageSize: 10},
			dataType: "json",
			success: function(res) {
				if(res.result == 0) {
					$.each(res.data, function(k, v){
						var ht = "";

						ht += "<div class=\"box\">\n";
						ht += "\t<div class=\"img\"><a href=\"/brand/eventView.asp?eidx="+v.BIDX+"\"><img src=\""+v.imgpath+v.imgname+"\" onerror=\"this.src='/images/brand/@event.jpg';\" alt=\"\"></a></div>\n";
						ht += "\t<div class=\"info\">\n";
						ht += "\t\t<p class=\"subject\"><a href=\"/brand/eventView.asp?eidx="+v.BIDX+"\">"+v.title+"</a></p>\n";
						ht += "\t\t<p class=\"date\">"+v.sdate+" ~ "+v.edate+"</p>\n";
						ht += "\t</div>\n";
						ht += "</div>\n";

						$("#vlist").append(ht);
					});

					if(res.totalCount <= (page * 10) + res.data.length) {
						$("#btn_more").hide();
					}
					page++;
				} else {
					showAlertMsg({msg:res.message});
				}
			},
			error: function(res) {
				console.log(res);
			}
		});
	}

</script>
</head>

<body>
<div class="wrapper">
<%
	PageTitle = "이벤트"
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
					<li class="on"><a href="./eventList.asp"><span>진행중인 이벤트</span></a></li>
					<li><a href="./eventList.asp"><span>지난 이벤트</span></a></li>
				</ul>
			</div>
			<!--// Tab -->

			<!-- Tab -->
			<!--<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li<%If eventGbn = "OPEN" Then%> class="on"<%End If%>><a href="/event/eventList.asp?event=OPEN"><span>진행중인 이벤트</span></a></li>
					<li<%If eventGbn = "CLOSE" Then%> class="on"<%End If%>><a href="/event/eventList.asp?event=CLOSE"><span>지난 이벤트</span></a></li>
					<li><a href="/brand/noticeList.asp"><span>공지사항</span></a></li>
				</ul>
			</div>-->
			<!--// Tab -->
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

	rowCount = vRs.RecordCount

	If Not (vRs.BOF Or vRs.EOF) Then
%>
			<!-- 이벤트 목록 -->
			<div class="event-list" id="vlist">
<%
		Do Until vRs.EOF
%>
				<div class="box">
					<div class="img"><a href="./eventView.asp?eidx=<%=vRs("BIDX")%>"><img src="<%=vRs("imgpath")&vRs("imgname")%>" onerror="this.src='/images/brand/@event.jpg';" alt=""></a></div>
					<div class="info">
						<p class="subject"><a href="./eventView.asp?eidx=<%=vRs("BIDX")%>"><%=vRs("title")%></a></p>
						<p class="date"><%=FormatDateTime(vRs("sdate"),2)%> ~ <%=FormatDateTime(vRs("edate"), 2)%></p>
					</div>
				</div>
<%
			vRs.MoveNext
		Loop
%>
			</div>
			<!-- //이벤트 목록 -->
<%
	End If
	Set vRs = Nothing
%>
<%
	If rowCount = pageSize Then
%>
			<div class="mar-t80">
				<div class="inner">
					<button type="button" onclick="getList();" class="btn btn-md btn-grayLine w-100p">더보기</button>
				</div>
			</div>
<%
	End If
%>


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