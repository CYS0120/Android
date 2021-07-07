<!--#include virtual="/api/include/utf8.asp"-->
<%
	viewType = request("viewType")
	If Len(viewType) = 0 And Len(request("pc")) > 0 Then viewType = "DESKTOP"

	If Len(viewType) = 0 Then viewType = ""
	If viewType <> "DESKTOP" Then
		mobrwz = "iPhone|iPod|BalckBerry|Android|Windows CE|LG|MOT|SAMSUNG|SonyEricsson|Mobile|Symbian|Opera Mobi|Opera Mini|IEmobile|Mobile|Igtelecom|PPC"
		spmobrwz = Split(mobrwz, "|")
		agent = Request.ServerVariables("HTTP_USER_AGENT")

		For i = 0 To Ubound(spmobrwz)
			If InStr(agent, spmobrwz(i)) > 0 Then
				Response.write "Go Mobile~<BR>"
				Response.Redirect(g2_bbq_m_url&"/brand/noticeView_smile.asp")
				Exit For
			End If
		Next
	End If

%>
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="공지사항, BBQ치킨">
<meta name="Description" content="공지사항 메인">
<title>공지사항 | BBQ치킨</title>
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
	padding: 10px;
	font-family: 'NanumSquareOTFR';
	font-weight: normal;
	text-align: center;
}

.smile table .smileTitle {
	border-bottom: 1px solid #444444;
	padding: 10px;
	font-size: 15pt;
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
			title: 'ESG 청년 스마일 프로젝트 - 지역별 지원 현황\n',
			titleTextStyle: {color: 'black', fontName: 'NanumSquareOTFR', fontSize: 22, bold: "True", italic: "False"},
			fontName: 'NanumSquareOTFR',
			hAxis: {title: '지역', titleTextStyle: {color: 'black', fontName: 'NanumSquareOTFR', fontSize: 17, italic: "False", bold: "True"}},
			vAxis: {viewWindow: {min: 0, max: 80}},
			width: '100%',
			height: 600,
			isStacked: true,
			series: {1: {targetAxisIndex: 0}, 2: {targetAxisIndex: 1}, 3: {targetAxisIndex: 1}},
			vAxes: {0: {title: '팀수', titleTextStyle: {fontSize: 17, italic: "False", bold: "True"}}, 1: {}},
			chartArea: {left:100, top:100, width:1000, height:600},
			legend: {position: 'top'},
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
			title: 'ESG 청년 스마일 프로젝트 - 일자별 지원 현황 (누적)\n\n',
			titleTextStyle: {color: 'black', fontName: 'NanumSquareOTFR', fontSize: 22, bold: "True", italic: "False"},				
			fontName: 'NanumSquareOTFR',
			hAxis: {title: '일자', titleTextStyle: {color: 'black', fontName: 'NanumSquareOTFR', fontSize: 17, italic: "False", bold: "True"}},
			vAxis: {title: '팀수', titleTextStyle: {color: 'black', fontName: 'NanumSquareOTFR', fontSize: 17, italic: "False", bold: "True"}, minValue: 0},
			width: '100%',
			height: 500,
			colors: ['#22a823', '#e8b723'],
			pointShape: 'circle',
			pointSize: 10,
			// legend: {position: 'none'}
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
			<div class="tab-wrap tab-type3">
				<!--<ul class="tab">
					<li><a href="./eventList.asp"><span>진행중인 이벤트</span></a></li>
					<li><a href="./eventList.asp"><span>지난 이벤트</span></a></li>
					<li class="on"><a href="./noticeList.asp"><span>공지사항</span></a></li>
				</ul>-->
			</div>
<%
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "BP_SMILE_PROJECT_APPLICANT"

		.Parameters.Append .CreateParameter("@KIND", adVarChar, adParamInput, 5, "TOT")
	' 	.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 2, "01")
	' 	.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A03")
	' 	.Parameters.Append .CreateParameter("@BIDX", adInteger, adParamInput, , nidx)

		Set vRs = .Execute
	End With
	Set vCmd = Nothing

	' If Not (vRs.BOF Or vRs.EOF) Then
	' 	Set vCmd = Server.CreateObject("ADODB.Command")
	' 	With vCmd
	' 		.ActiveConnection = dbconn
	' 		.NamedParameters = True
	' 		.CommandType = adCmdStoredProc
	' 		.CommandText = "bp_board_hit"

	' 		.Parameters.Append .CreateParameter("@BIDX", adInteger, adParamInput,, nidx)

	' 		.Execute
	' 	End With
	' 	Set vCmd = Nothing
	' 	CONTENTS = vRs("contents")
	' 	CONTENTS = Replace(CONTENTS,"file.genesiskorea.co.kr/upload/editor_tmp","img.bbq.co.kr/uploads/bbq_d/editor_tmp")
%>


			<!-- 게시판 뷰 -->
			<div class="board-view">
				<div class="top">
					<h3>
						ESG 청년 스마일 프로젝트 지원자 현황
					</h3>
					<ul class="info">
						<li class="date"><strong>등록일 :</strong>2021-07-06</li>
					</ul>
				</div>
				<div class="con smile">
					<table>
						<tr>
							<td width="40%" class="smileTitle">지역</td>
							<td width="15%" class="smileTitle">모집팀수</td>
							<td width="15%" class="smileTitle">지원중</td>
							<td width="15%" class="smileTitle">지원완료</td>
							<td width="15%" class="smileTitle">지원율</td>
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
				<div id="ColumnChart_div" style="margin-top:30px;"></div>
				<div id="LineChart_div" style="margin-top:80px;"></div>
			</div>
			<!-- //게시판 뷰 -->

			<div class="btn-wrap two-up inner mar-t60">
				<a href="/brand/noticeList.asp?gotoPage=<%=gotoPage%>&searchStr=<%=searchStr%>" class="btn btn-lg btn-black"><span>목록</span></a>
			</div>
<%
' 	End If
' 	Set vRs = Nothing
%>
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
