<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->
<style>
.smile table {
	width: 100%;
	border-top: 1px solid #444444;
	border-collapse: collapse;
	font-family: 'NanumSquareOTFR';
	font-weight: normal;
}

.smile table td {
	border-bottom: 1px solid #444444;
	padding: 9px;
	font-family: 'NanumSquareOTFR';
	font-weight: normal;
	text-align: center;
}

.smile table .smileTitle {
	border-bottom: 1px solid #444444;
	padding: 10px;
	font-size: 11pt;
	text-align: center;
	font-family: 'NanumSquareOTFR';
	font-weight: bold;
	background-color: #ffef42;
}
.smile table .smileContent {
	border-bottom: 1px solid #444444;
	padding: 10px;
	padding-left: 20px;
	font-family: 'NanumSquareOTFR';
}
.smile table .smileTotal {
	border-bottom: 1px solid #444444;
	padding: 10px;
	padding-left: 20px;
	font-family: 'NanumSquareOTFR';
	font-weight: bold;
	background-color: #fff58c;
}
</style>
<%
    ' 지역별 지원팀수
	Dim region, aCmd1, rs1

    Set aCmd1 = Server.CreateObject("ADODB.Command")
    Set rs1 = Server.CreateObject("ADODB.Recordset")

    With aCmd1
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "BP_SMILE_PROJECT_APPLICANT"

        .Parameters.Append .CreateParameter("@KIND", adVarChar, adParamInput, 10, "REGION")

    End With        
    rs1.open aCmd1

    region = ""

    Dim i : i = 0
	' Dim arr(6)
	' arr(0) = "#ff3700"
	' arr(1) = "#ff5d30"
	' arr(2) = "#ff7d59"
	' arr(3) = "#ff977a"
	' arr(4) = "#ffb19c"
	' arr(5) = "#ffcdbf"

    If Not (rs1.BOF Or rs1.EOF) Then
        rs1.MoveFirst
        Do Until rs1.EOF
            If i > 0 Then region = region & ","
            
            ' region = region & "[""" & rs1("REGION") & """," & rs1("SUBMIT_CNT") & ", 'color: " & arr(i) & "']"
            region = region & "[""" & rs1("REGION") & """," & rs1("SUBMIT_CNT") & "," & rs1("REMAIN") & "," & rs1("WRITING_CNT") & "]"

            rs1.MoveNext
            i = i + 1
        Loop
    End If

    rs1.close
    set rs1 = nothing

	' 일자별 지원팀수
    Dim date, aCmd2, rs2

    Set aCmd2 = Server.CreateObject("ADODB.Command")
    Set rs2 = Server.CreateObject("ADODB.Recordset")

    With aCmd2
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "BP_SMILE_PROJECT_APPLICANT"

        .Parameters.Append .CreateParameter("@KIND", adVarChar, adParamInput, 10, "DATE")

    End With        
    rs2.open aCmd2

    date = ""

    Dim j : j = 0

    If Not (rs2.BOF Or rs2.EOF) Then
        rs2.MoveFirst
        Do Until rs2.EOF
            If j > 0 Then date = date & ","
            
            date = date & "[""" & rs2("DATE") & """," & rs2("SUBMIT_CNT") & "," & rs2("WRITING_CNT") & "]"

            rs2.MoveNext
            j = j + 1
        Loop
    End If

    rs2.close
    set rs2 = nothing

%>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
	google.charts.load('current', {'packages': ['corechart', 'line', 'bar']});
    google.charts.setOnLoadCallback(drawColumnChart);
    google.charts.setOnLoadCallback(drawLineChart);

	function drawColumnChart() {
		var data = google.visualization.arrayToDataTable([
			// ['지역', '지원자수', {role: 'style'}],
			['지역', '지원완료', '잔여팀수', '지원중'],
			<%=region%>
		]);

		var options = {
			// title: '지역별 지원 현황\n',
			// titleTextStyle: {color: 'black', fontName: 'NanumSquareOTFR', fontSize: 13, bold: "True", italic: "False"},
			fontName: 'NanumSquareOTFR',
			hAxis: {title: '지역', titleTextStyle: {color: 'black', fontName: 'NanumSquareOTFR', fontSize: 11, italic: "False", bold: "True"}},
			vAxis: {viewWindow: {min: 0, max: 80}},
			width: '100%',
			height: 300,
			isStacked: true,
			series: {1: {targetAxisIndex: 0}, 2: {targetAxisIndex: 1}, 3: {targetAxisIndex: 1}},
			vAxes: {0: {title: '팀수', titleTextStyle: {fontSize: 11, italic: "False", bold: "True"}}, 1: {}},
			chartArea: {left:100, top:100, width:1000, height:600, title: 'aa'},
			legend: {position: 'none'},
			colors: ['#2bd92e', '#ffc926']
		};

		var chart = new google.charts.Bar(document.getElementById('ColumnChart_div'));
		// var chart = new google.visualization.ColumnChart(document.getElementById('ColumnChart_div'));

		chart.draw(data, google.charts.Bar.convertOptions(options));
		// chart.draw(data, options);
	}

	function drawLineChart() {
		var data = google.visualization.arrayToDataTable([
			['일자', '지원완료', '지원중'],
			<%=date%>
		]);

		var options = {
			// title: '일자별 지원 현황 (누적)\n',
			// titleTextStyle: {color: 'black', fontName: 'NanumSquareOTFR', fontSize: 13, bold: "True", italic: "False"},				
			fontName: 'NanumSquareOTFR',
			hAxis: {title: '일자', titleTextStyle: {color: 'black', fontName: 'NanumSquareOTFR', fontSize: 11, italic: "False", bold: "True"}},
			vAxis: {title: '팀수', titleTextStyle: {color: 'black', fontName: 'NanumSquareOTFR', fontSize: 11, italic: "False", bold: "True"}, minValue: 0},
			width: '100%',
			height: 250,
			colors: ['#22a823', '#e8b723'],
			pointShape: 'circle',
			pointSize: 10,
			legend: {position: 'in', textStyle: {fontSize:9}}
		};

		var chart = new google.visualization.LineChart(document.getElementById('LineChart_div'));

		chart.draw(data, options);
	}

</script>
</head>

<%
	gotoPage = GetReqStr("gotoPage","")
	searchStr = GetReqStr("searchStr","")
%>


<body>

<div class="wrapper">

	<%
		PageTitle = "고객센터"
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
			<div class="tab-type4">
				<ul class="tab">
					<li><a href="/customer/faqList.asp">자주하는 질문</a></li>
					<li><a href="/customer/inquiryList.asp">고객의소리</a></li>
					<li class="on"><a href="/brand/noticeList.asp">공지사항</a></li>
				</ul>
			</div>
			<!--// Tab -->

<%
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "BP_SMILE_PROJECT_APPLICANT"

		.Parameters.Append .CreateParameter("@KIND", adVarChar, adParamInput, 5, "TOT")

		Set vRs = .Execute
	End With
	Set vCmd = Nothing
%>
			<!-- 게시판 뷰 -->
			<div class="inbox1000">
				<div class="board-view">
					<div class="top">
						<h3>
							ESG 청년 스마일 프로젝트 지원자 현황
						</h3>
						<ul class="info">
							<li class="date">등록일 : 2021-07-06</li>
						</ul>
					</div>
					<div class="con smile">
						<table>
							<tr>
								<td width="25%" class="smileTitle">지역</td>
								<td width="19%" class="smileTitle">모집팀수</td>
								<td width="18%" class="smileTitle">지원중</td>
								<td width="19%" class="smileTitle">지원완료</td>
								<td width="19%" class="smileTitle">지원율</td>
							</tr>
<%
				submit = 0
				writing = 0
				do until vRs.eof
					submit = submit + vRs("SUBMIT_CNT")
					writing = writing + vRs("WRITING_CNT")
%>
							<tr>
								<td class="smileContent"><%=vRs("RECRUITNOTICEREGION")%></td>
								<td class="smileContent"><%=vRs("RECRUITNOTICEWIN")%></td>
								<td class="smileContent"><%=vRs("WRITING_CNT")%></td>
								<td class="smileContent"><%=vRs("SUBMIT_CNT")%></td>
								<td class="smileContent"><%=FormatNumber(vRs("SUBMIT_CNT")*100/vRs("RECRUITNOTICEWIN"),0)%> %</td>
							</tr>
<%
					vRs.movenext
				Loop
%>
							<tr>
								<td class="smileTotal">전체</td>
								<td class="smileTotal">200</td>
								<td class="smileTotal"><%=writing%></td>
								<td class="smileTotal"><%=submit%></td>
								<td class="smileTotal"><%=FormatNumber(submit*100/200,0)%> %</td>
							</tr-->
						</table>
					</div>
					<div style="margin-top:30px;">지역별 지원 현황</div>
					<div id="ColumnChart_div" style="margin-top:5px;"></div>
					<div style="margin-top:20px;">일자별 지원 현황 (누적)</div>
					<div id="LineChart_div"></div>
				</div>


				<div class="btn-wrap one mar-t20">
					<a href="javascript:history.back();" class="btn btn-red btn_middle">목록</a>
				</div>
				
			</div>
			<!-- //게시판 뷰 -->


		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
