<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">

<head>
<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->
<meta name="Keywords" content="카드, BBQ치킨">
<meta name="Description" content="카드">
<title>카드 | BBQ치킨</title>
</head>

<%

	pageSize = GetReqNum("pageSize", 10)
	gotopage = GetReqNum("gotopage",1)
%>
<%
	PageTitle = "카드내역"
%>

<body>
<div class="wrapper">
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

			<section class="section section_cardList2 mar-t60">
				<div class="section-header">
					<div class="btn-wrap">
						<!-- <button type="button" class="btn btn-md btn-red w-100p"><span>충전하기</span></button> -->
						<p class="explain"></p>
					</div>
				</div>
				<div class="section-body" id="trade_list">
					<!-- Order List -->
					<div class="area">

						<%
							sDt = DateAdd("m",-1,Date)
							eDt = Date

							sDt = DatePart("yyyy", sDt)&Right("00"&DatePart("m",sDt),2)&"01"
							eDt = Replace(FormatDateTime(eDt,2),"-","")

							Set tList = PointGetTradeList(sDt, eDt, "PAY", "", pageSize, gotopage)

							totalCount = 0

							If tList.mCode = 0 Then
								gotopage = gotopage + 1
								totalCount = tList.mTotalCount

								For i = 0 To UBound(tList.mTradeList)
									idx = totalCount - (pageSize * (gotopage-1) ) - i
									cardNo = tList.mTradeList(i).mCardNo
									tradeDate = Mid(tList.mTradeList(i).mTradeDate,1,4)&"."&Mid(tList.mTradeList(i).mTradeDate,5,2)&"."&Mid(tList.mTradeList(i).mTradeDate,7,2)
									incomeAmt = "-"
									beforeAmt = "-"
									tradeAmt = "-"
									afterAmt = "-"
									serviceTradeNo = "-"

									tradePoint = tList.mTradeList(i).mTradePoint
									snapshotPoint = tList.mTradeList(i).mSnapshotTotalRestPoint
									If tList.mTradeList(i).mServiceTradeNo <> "" Then
										serviceTradeNo = tList.mTradeList(i).mServiceTradeNo
									End If

									Select Case Replace(tList.mTradeList(i).mPointTradeTypeName," ","")
										Case "충전":
										incomeAmt = FormatNumber(tradePoint,0)
										beforeAmt = FormatNumber(snapshotPoint - tradePoint,0)
										tradeAmt = FormatNumber(tradePoint, 0)
										afterAmt = FormatNumber(snapshotPoint,0)
										Case "충전취소":
										incomeAmt = "-"&FormatNumber(tradePoint,0)
										beforeAmt = FormatNumber(snapshotPoint - tradePoint,0)
										tradeAmt = "-"&FormatNumber(tradePoint, 0)
										afterAmt = FormatNumber(snapshotPoint,0)
										Case "충전사용":
										beforeAmt = FormatNumber(tradePoint + snapshotPoint, 0)
										tradeAmt = "-"&FormatNumber(tradePoint, 0)
										afterAmt = FormatNumber(snapshotPoint, 0)
									End Select
						%>

						<div class="box">
							<h4 class="prod">[<%=tList.mTradeList(i).mPointTradeTypeName%>] <%=cardNo%></h4>
							<table border="1" cellspacing="0" >
								<caption>카드 내역</caption>
								<colgroup>
									<col style="width:40%;">
									<col style="width:auto;">									
								</colgroup>
								
								<tbody>
									<tr>
										<th>거래일시</th>
										<td><%=tradeDate%></td>
									</tr>
									<!-- <tr>
										<th>사용가맹점</th>
										<td>여섯글자매장점</td>
									</tr> -->
									<tr>
										<th>거래금액</th>
										<td><%=tradeAmt%></td>
									</tr>
									<tr>
										<th>거래후금액</th>
										<td><%=afterAmt%></td>
									</tr>									
								</tbody>
							</table>
						</div>

						<%
								Next
							End If
						%>						
						<%
							If totalCount <= pageSize Then
						%>

						<!-- Button More -->
						<div class="btn-wrap mar-t20">
							<button type="button" id="btn_more" onclick="getPTList();" class="btn btn-md btn-grayLine w-100p btn_list_more"><span>더보기</span></button>
							<p class="explain">-정상적인 사용 내역은 pc에서 확인해주세요</p>
						</div>
						<!--// Button More -->

						<%
							End If
						%>

					</div>
					<!--// Order List -->
					
				</div>
			</section>

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<script type="text/javascript">
		var page = <%=gotopage%>;
		var pageSize = <%=pageSize%>;
		function getPTList() {
			$.ajax({
				method: "post",
				url: "/api/ajax/ajax_getPointTradeList.asp",
				data: {start:"<%=sDt%>", end: "<%=eDt%>", accountType: "PAY", cardNo: "", perPage: pageSize, page: page},
				dataType: "json",
				success: function(res) {
					if(res.code == 0) {
						$.each(res.tradeList, function(k,v) {
							var ht = "";

							var cardNo = (v.hasOwnProperty("cardNo")?v.cardNo: "");
							var tradeDate = (v.hasOwnProperty("tradeDate")? v.tradeDate.substr(0,4)+"."+v.tradeDate.substr(4,2)+"."+v.tradeDate.substr(6,2): "");
							var incomeAmt = "-";
							var beforeAmt = "-";
							var tradeAmt = "-";
							var afterAmt = "-";
							var serviceTradeNo = "-";

							var tradePoint = (v.hasOwnProperty("tradePoint")? v.tradePoint: 0);
							var snapshotPoint = (v.hasOwnProperty("snapshotTotalRestPoint")? v.snapshotTotalRestPoint: 0);
							if (v.hasOwnProperty("serviceTradeNo") && v.serviceTradeNo != "") {
								serviceTradeNo = v.serviceTradeNo;
							}

							switch( (v.hasOwnProperty("pointTradeTypeName")? v.pointTradeTypeName.replace(/ /g,""): "") ) {
								case "충전":
								tradeAmt = addCommas(Number(tradePoint));
								afterAmt = addCommas(Number(snapshotPoint));
								break;
								case "충전취소":
								tradeAmt = "-" + addCommas(Number(tradePoint));
								afterAmt = addCommas(Number(snapshotPoint));
								break;
								case "충전사용":
								tradeAmt = "-" + addCommas(Number(tradePoint));
								afterAmt = addCommas(Number(snapshotPoint));
								break;
							}

							ht += "<div class=\"box\">\n";
							ht += "\t<h4 class=\"prod\">["+(v.hasOwnProperty("pointTradeTypeName")? v.pointTradeTypeName:"")+"] "+cardNo+"</h4>\n";
							ht += "\t<table border=\"1\" cellspacing=\"0\" >\n";
							ht += "\t\t<caption>카드 내역</caption>\n";
							ht += "\t\t<colgroup>\n";
							ht += "\t\t\t<col style=\"width:40%;\">\n";
							ht += "\t\t\t<col style=\"width:auto;\">\n";
							ht += "\t\t</colgroup>\n";
							ht += "\t\t<tbody>\n";
							ht += "\t\t\t<tr>\n";
							ht += "\t\t\t\t<th>거래일시</th>\n";
							ht += "\t\t\t\t<td>"+tradeDate+"</td>\n";
							ht += "\t\t\t</tr>\n";
							// ht += "\t\t\t<tr>\n";
							// ht += "\t\t\t\t<th>사용가맹점</th>\n";
							// ht += "\t\t\t\t<td>여섯글자매장점</td>\n";
							// ht += "\t\t\t</tr>\n";
							ht += "\t\t\t<tr>\n";
							ht += "\t\t\t\t<th>거래금액</th>\n";
							ht += "\t\t\t\t<td>"+tradeAmt+"</td>\n";
							ht += "\t\t\t</tr>\n";
							ht += "\t\t\t<tr>\n";
							ht += "\t\t\t\t<th>거래후금액</th>\n";
							ht += "\t\t\t\t<td>"+afterAmt+"</td>\n";
							ht += "\t\t\t</tr>\n";
							ht += "\t\t</tbody>\n";
							ht += "\t</table>\n";
							ht += "</div>\n";

							$(ht).insertBefore($("#btn_more").parent());
							// $("#trade_list").insertBefore(ht);
						});

						if(res.tradeList.length == 0 || res.tradeList.length < pageSize) {
							$("#btn_more").hide();
						} else {
							page++;
						}
					} else {
						$("#btn_more").hide();
					}
				}
			});
		}
	</script>

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->

