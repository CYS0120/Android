<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->

<script type="text/javascript">
	var page = 1;
	var perPage = 10;

	$(function(){
		getTradeList();
	});

	function getTradeList() {
		$.ajax({
			method: "post",
			url: "/api/ajax/ajax_getPointTradeList.asp",
			data: {accountType: "SAVE", perPage: perPage, page: page},
			dataType: "json",
			success: function(tList) {
				var ht = "";

				if(tList.message == "SUCCESS") {
					if(tList.totalCount == 0) {
						$("#btn_more").hide();
					} else {
						$.each(tList.tradeList, function(k, v){
							var validStart = "";
							var validEnd = "";
							if(v.hasOwnProperty("tradeDate")) {
								validStart = (v.tradeDate!= ""? v.tradeDate.substr(0,4)+"-"+v.tradeDate.substr(4,2)+"-"+v.tradeDate.substr(6,2): "");
							}
							if(v.hasOwnProperty("validEndDate")) {
								validEnd = (v.validEndDate != ""? v.validEndDate.substr(0,4)+"-"+v.validEndDate.substr(4,2)+"-"+v.validEndDate.substr(6,2): "");
							}

							ht += "<div class=\"box\">\n";
							ht += "\t<div class=\"top\">\n";
							ht += "\t\t<div class=\"lef\">\n";
							ht += "\t\t\t<span class=\"ico-branch red\">비비큐 치킨</span>\n";
							ht += "\t\t</div>\n";
							switch(v.pointTradeTypeName.replace(/ /g,"")) {
								case "적립":
									ht += "\t\t<div class=\"rig\">+"+addCommas(v.tradePoint)+"P</div>\n";
									break;
								case "적립취소":
									ht += "\t\t<div class=\"rig\">-"+addCommas(v.tradePoint)+"P</div>\n";
									break;
								case "적립사용":
									ht += "\t\t<div class=\"rig\">-"+addCommas(v.tradePoint)+"P</div>\n";
									break;
								case "적립사용취소":
									ht += "\t\t<div class=\"rig\">+"+addCommas(v.tradePoint)+"P</div>\n";
									break;
								case "충전":
									ht += "\t\t<div class=\"rig\">+"+addCommas(v.tradePoint)+"P</div>\n";
									break;
								case "충전취소":
									ht += "\t\t<div class=\"rig\">-"+addCommas(v.tradePoint)+"P</div>\n";
									break;
								case "충전사용":
									ht += "\t\t<div class=\"rig\">-"+addCommas(v.tradePoint)+"P</div>\n";
									break;
							}
							ht += "\t</div>\n";
							ht += "\t<dl>\n";
							switch(v.merchantTypeName) {
								case "ONLINE":
									ht += "\t\t<dt>[온라인] "+v.detailTradeReasonName+"</dt>\n";
									break;
								case "OFFLINE":
									ht += "\t\t<dt>[오프라인] "+v.detailTradeReasonName+"</dt>\n";
									break;
							}
							ht += "\t\t<dd>발생일자 : "+validStart+" / 소멸예정일 : "+validEnd+"</dd>\n";
							ht += "\t</dl>\n";
							ht += "</div>\n";
						});

						$("#point_list").append(ht);

						if(tList.tradeList.length == 0 || tList.totalCount <= perPage * page) {
							$("#btn_more").hide();
						} else {
							page++;
						}
					}
				} else {
					$("#btn_more").hide();
				}
			}

		});
	}
</script>

</head>

<%
	Set pPoint = PointGetPointBalance("SAVE", 30)
%>

<body>

<div class="wrapper">

	<%
		PageTitle = "포인트"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content inbox1000">

			<!-- 포인트 요약 -->
			<div class="point-display">
				<div class="div-table">
					<div class="tr">
						<div class="td">
							<dl>
								<dt>사용가능 포인트</dt>
								<dd><span><%=FormatNumber(pPoint.mTotalPoint,0)%></span> P</dd>
							</dl>
						</div>
						<div class="td">
							<dl>
								<dt>소멸예정 포인트</dt>
								<dd><span class="black"><%=FormatNumber(pPoint.mTotalExtinctionExpectedPoint,0)%></span> P</dd>
							</dl>
							<p>(<%=FormatDateTime(DateAdd("d",30,Date),2)%>)</p>
						</div>
					</div>
				</div>
			</div>
			<!-- //포인트 요약 -->

			<!-- 포인트 적립내역 -->
			<section class="section section_pointList">
				<div class="section-header">
					<h3>포인트 적립내역</h3>
				</div>

				<div class="list" id="point_list">
<!-- 
					<div class="box">
						<div class="top">
							<div class="lef">
								<span class="ico-branch red">비비큐 치킨</span>
							</div>
							<div class="rig">+1,000P</div>
						</div>
						<dl>
							<dt>[온라인] 주문 적립</dt>
							<dd>발생일자 : 2018-01-30 / 소멸예정일 : 2018-12-30</dd>
						</dl>
					</div>
					<div class="box">
						<div class="top">
							<div class="lef">
								<span class="ico-branch yellow">비비큐몰</span>
							</div>
							<div class="rig">-1,000P</div>
						</div>
						<dl>
							<dt>[온라인] 주문 적립</dt>
							<dd>발생일자 : 2018-01-30 / 소멸예정일 : -</dd>
						</dl>
					</div>
 -->
				</div>

				<div>
					<button type="button"  id="btn_more" onclick="getTradeList();" class="btn_middle btn-grayLine mar-t20">더보기</button>
				</div>
			</section>
			<!-- //포인트 적립내역 -->

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
