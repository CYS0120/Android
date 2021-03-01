<!--#include virtual="/api/include/utf8.asp"-->

<%
	curPage = GetReqNum("gotoPage",1)
	pageSize = GetReqNum("pageSize", 5)
	eventGbn = GetReqStr("event", "OPEN")

	if eventGbn = "WINNER" then 
		bbs_code = "A06"
	else
		bbs_code = "A02"
	end if 
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
			data: {brand_code:"01", bbs_code: "<%=bbs_code%>", eventGbn:"<%=eventGbn%>", gotoPage: page, pageSize: <%=pageSize%>},
			dataType: "json",
			success: function(res) {
				if(res.result == 0) {
					$.each(res.data, function(k, v){
						var ht = "";

						ht += '<div class="box">';
						ht += '	<div class="img">';

						if (v.eventGbn == "CLOSE") {
							ht += '	<div class="img_close">종료</div>';
						}

						ht += '		<a href="/brand/eventView.asp?eidx='+ v.BIDX +'&event='+ v.eventGbn +'"><img src="<%=SERVER_IMGPATH%>/bbsimg/'+ v.imgname +'" alt="" onerror="this.src=\'/images/common/btn_header_logo.png\'"></a>';
						ht += '	</div>';
						ht += '	<div class="info">';
						ht += '		<p class="subject">';

						if (v.eventGbn == "CLOSE") {
							ht += '	<span>[종료]</span>';
						}

						ht += '			<a href="/brand/eventView.asp?eidx='+ v.BIDX +'&event='+ v.eventGbn +'">'+ v.title +'</a>';
						ht += '		</p>';
						ht += '		<p class="date"><span>이벤트 기간 : </span>'+ v.sdate +' ~ '+ v.edate +'</p>';
						ht += '	</div>';
						ht += '</div>';

//						ht += "<div class=\"box\">\n";
//						ht += "\t<div class=\"img\"><a href=\"/brand/eventView.asp?eidx="+v.BIDX+"\"><img src=\"<%=SERVER_IMGPATH%>/bbsimg/"+v.imgname+"\" onerror=\"this.src='/images/brand/@event.jpg';\" alt=\"\"></a></div>\n";
//						ht += "\t<div class=\"info\">\n";
//						ht += "\t\t<p class=\"subject\"><a href=\"/brand/eventView.asp?eidx="+v.BIDX+"\">"+v.title+"</a></p>\n";
//						ht += "\t\t<p class=\"date\">"+v.sdate+" ~ "+v.edate+"</p>\n";
//						ht += "\t</div>\n";
//						ht += "</div>\n";

						$("#vlist").append(ht);
					});

					if(res.totalCount <= Number(((page-1) * <%=pageSize%>) + res.data.length) ) {
//						$("#btn_more").hide();
						$(".event_btn").hide();
					} else {
						$(".event_btn").show(0);
					}

					page++;
				} else {
					showAlertMsg({msg:res.message});
				}
			},
			error: function(res) {
				console.log(res);
				$(".event_btn").hide();
			}
		});
	}


	$(function(){
		getList();
	});
</script>

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "이벤트"
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
			<div class="tab-wrap tab-type3">
				<ul class="tab event_tab">
					<li<%If eventGbn = "OPEN" Then%> class="on"<%End If%>><a href="/brand/eventList.asp?event=OPEN"><span>진행중인 이벤트</span></a></li>
					<li<%If eventGbn = "WINNER" Then%> class="on"<%End If%>><a href="/brand/eventList.asp?event=WINNER"><span>당첨자 발표</span></a></li>
					<li<%If eventGbn = "CLOSE" Then%> class="on"<%End If%>><a href="/brand/eventList.asp?event=CLOSE"><span>지난 이벤트</span></a></li>
					<!--<li><a href="/brand/noticeList.asp"><span>공지사항</span></a></li>-->
				</ul>
			</div>
			<!--// Tab -->



			<!-- 이벤트 목록 -->
			<div class="event-list inbox1000" id="vlist"></div>
			<!-- //이벤트 목록 -->



			<div class="event_btn" style="display:none">
				<button type="button" onclick="getList();" class="btn btn-red btn_middle">더보기</button>
			</div>

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
