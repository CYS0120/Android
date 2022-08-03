<%@Language="VBScript" CODEPAGE="65001" %>
<%
  Response.CharSet="utf-8"
  Session.codepage="65001"
  Response.codepage="65001"
  Response.ContentType="text/html;charset=utf-8"
%>
<%
	BRCD = "1146001"	' prm / 로그인 정보로 수정 필요(필수)
	BRAND_CODE	= "01"

	ServerHost		= "40.82.154.186,1433"
	UserName		= "sa_homepage"
	UserPass		= "home123!@#"
	DatabaseName	= "BBQ"

	Set conn = Server.CreateObject("ADODB.Connection")
	strConnection = "Provider=SQLOLEDB;Persist Security Info=False;User ID="& UserName &";passWord="& UserPass &";Initial Catalog="& DatabaseName &";Data Source="& ServerHost &""
	conn.Open strConnection

	Sql = "Select branch_id, brand_code, branch_name, owner_greeting, pickup_discount, branch_weekday_open, branch_weekday_close"
	Sql = Sql + ", isnull(branch_seats,'0') branch_seats, isnull(branch_services,'0000000000') branch_services, isnull(beer_yn,'N') beer_yn From bt_branch Where branch_id = " & BRCD & " And BRAND_CODE='"& BRAND_CODE &"' "
	Set Rinfo = conn.Execute(Sql)
	If Rinfo.eof Then 
%>
		<script type="text/javascript">
			alert("해당 매장코드가 등록되어있지 않습니다");
			history.back();
		</script>
<%
	End If

	branch_id	= Rinfo("branch_id")
	brand_code	= Rinfo("brand_code")
	branch_name	= Rinfo("branch_name")
	owner_greeting	= Rinfo("owner_greeting")
	pickup_discount	= Rinfo("pickup_discount")
	open_hour		= left(Rinfo("branch_weekday_open"),2)
	open_minute		= right(Rinfo("branch_weekday_open"),2)
	close_hour		= left(Rinfo("branch_weekday_close"),2)
	close_minute	= right(Rinfo("branch_weekday_close"),2)
	branch_seats	= Rinfo("branch_seats")
	parking_yn	= left(Rinfo("branch_services"),1)
	wifi_yn		= Mid(Rinfo("branch_services"),3,1)
	group_yn	= Mid(Rinfo("branch_services"),4,1)
	beer_yn		= Rinfo("beer_yn")

	conn.Close
	Set Rinfo = Nothing
	Set conn = Nothing
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<style>
	table {width:100%;border-top:2px solid #595959;border-collapse: collapse;font-size:20px;}
	table tr {height:40px;}
	table tr th {background:#f9f9f9;font-weight:bold;border:1px solid #dddddd;vertical-align:middle;}
	table tr td {border:1px solid #dddddd;vertical-align: middle;font-weight:normal;font-size:20px;}

	.content {padding:20px;margin-left:20px;min-height:100%;}
	.section_store {width:100%;}
	.section_store .store_info {width:100%;}
	.section_store .store_info table.store_info_detail tr td {text-align:left;padding:0 12px;padding-left:21px;}
	.section_store .store_title {width:100%;margin-bottom:15px;}
	.section_store .store_title span {font-weight:bold;font-size:25px;}

	input{padding:0;margin:0;border:0 none;vertical-align:middle;}
	input[type="number"] {height:30px;padding-left:12px;text-align:right;padding-right:5px;margin-right:5px;font-size:19px;border:1px solid #cccccc;}
	input[type="text"] {width:700px;height:30px;padding-left:12px;text-align:left;padding-right:5px;margin-right:5px;font-size:19px;border:1px solid #cccccc;}
	button, input[type=button], input[type=submit] {cursor: pointer;}
	.btn_red125 {height:37px;width:125px;background:#e41937;font-size:20px;color:#fff;display:inline-block;line-height:37px;font-weight:bold;}

	select {height:30px;width:100px;padding-left:5px;text-align:left;padding-right:5px;margin-right:5px;font-size:19px;border:1px solid #cccccc;}

</style>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript">
function InputCheck(){
	var f = document.inputfrm;
	$.ajax({
		async: true,
		type: "POST",
		url: "store_pickupDC_proc.asp",
		data: $("#inputfrm").serialize(),
		dataType: "json",
		success: function (res) {
			alert(res.result_msg);
			if(res.result == "00"){
				location.reload();
			}
		},
		error: function(res, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}

function onlyNum(objtext1){ 
	var inText = objtext1.value; 
	var ret; 
	for (var i = 0; i <= inText.length; i++) { 
		ret = inText.charCodeAt(i);
		if ((ret <= 47 && ret > 31) || ret >= 58)  { 
			alert("숫자만을 입력하세요"); 
			objtext1.value = ""; 
			objtext1.focus();
			return false; 
		}
	}
	return true; 
}
</script>
</head>
<body>
	<div class="content">
		<div class="section section_store">
			<div class="store_info">
			<form id="inputfrm" name="inputfrm" method="post">
			<input type="hidden" name="branch_id" value="<%=branch_id%>">
				<div class="store_title"><span>BBQ 자사앱 매장 정보 설정</span></div>
				<table class="store_info_detail">
					<colgroup>
						<col width="22%">
						<col width="78%">
					</colgroup>
					<tr>
						<th>매장코드</th>
						<td><%=branch_id%></td>
					</tr>
					<tr>
						<th>매장명</th>
						<td><%=branch_name%></td>
					</tr>
					<tr>
						<th>인사말</th>
						<td>
							<input type="text" name="owner_greeting" value="<%=owner_greeting%>">
						</td>
					</tr>
					<tr>
						<th>포장할인 금액</th>
						<td>
							<input type="number" step="100" name="pickup_discount" value="<%=pickup_discount%>" onkeyup="onlyNum(this);">원 
							<span>(숫자만 입력)</span>
						</td>
					</tr>
					<tr>
						<th>영업시간</th>
						<td>
							<select name="open_hour">
								<option value="00" <%If open_hour="00" Then%>selected <%End If%>>00</option>
								<option value="01" <%If open_hour="01" Then%>selected <%End If%>>01</option>
								<option value="02" <%If open_hour="02" Then%>selected <%End If%>>02</option>
								<option value="03" <%If open_hour="03" Then%>selected <%End If%>>03</option>
								<option value="04" <%If open_hour="04" Then%>selected <%End If%>>04</option>
								<option value="05" <%If open_hour="05" Then%>selected <%End If%>>05</option>
								<option value="06" <%If open_hour="06" Then%>selected <%End If%>>06</option>
								<option value="07" <%If open_hour="07" Then%>selected <%End If%>>07</option>
								<option value="08" <%If open_hour="08" Then%>selected <%End If%>>08</option>
								<option value="09" <%If open_hour="09" Then%>selected <%End If%>>09</option>
								<option value="10" <%If open_hour="10" Then%>selected <%End If%>>10</option>
								<option value="11" <%If open_hour="11" Then%>selected <%End If%>>11</option>
								<option value="12" <%If open_hour="12" Then%>selected <%End If%>>12</option>
								<option value="13" <%If open_hour="13" Then%>selected <%End If%>>13</option>
								<option value="14" <%If open_hour="14" Then%>selected <%End If%>>14</option>
								<option value="15" <%If open_hour="15" Then%>selected <%End If%>>15</option>
								<option value="16" <%If open_hour="16" Then%>selected <%End If%>>16</option>
								<option value="17" <%If open_hour="17" Then%>selected <%End If%>>17</option>
								<option value="18" <%If open_hour="18" Then%>selected <%End If%>>18</option>
								<option value="19" <%If open_hour="19" Then%>selected <%End If%>>19</option>
								<option value="20" <%If open_hour="20" Then%>selected <%End If%>>20</option>
								<option value="21" <%If open_hour="21" Then%>selected <%End If%>>21</option>
								<option value="22" <%If open_hour="22" Then%>selected <%End If%>>22</option>
								<option value="23" <%If open_hour="23" Then%>selected <%End If%>>23</option>
							</select>시
							<select name="open_minute">
								<option value="00" <%If open_minute="00" Then%>selected <%End If%>>00</option>
								<option value="01" <%If open_minute="01" Then%>selected <%End If%>>01</option>
								<option value="02" <%If open_minute="02" Then%>selected <%End If%>>02</option>
								<option value="03" <%If open_minute="03" Then%>selected <%End If%>>03</option>
								<option value="04" <%If open_minute="04" Then%>selected <%End If%>>04</option>
								<option value="05" <%If open_minute="05" Then%>selected <%End If%>>05</option>
								<option value="06" <%If open_minute="06" Then%>selected <%End If%>>06</option>
								<option value="07" <%If open_minute="07" Then%>selected <%End If%>>07</option>
								<option value="08" <%If open_minute="08" Then%>selected <%End If%>>08</option>
								<option value="09" <%If open_minute="09" Then%>selected <%End If%>>09</option>
								<option value="10" <%If open_minute="10" Then%>selected <%End If%>>10</option>
								<option value="11" <%If open_minute="11" Then%>selected <%End If%>>11</option>
								<option value="12" <%If open_minute="12" Then%>selected <%End If%>>12</option>
								<option value="13" <%If open_minute="13" Then%>selected <%End If%>>13</option>
								<option value="14" <%If open_minute="14" Then%>selected <%End If%>>14</option>
								<option value="15" <%If open_minute="15" Then%>selected <%End If%>>15</option>
								<option value="16" <%If open_minute="16" Then%>selected <%End If%>>16</option>
								<option value="17" <%If open_minute="17" Then%>selected <%End If%>>17</option>
								<option value="18" <%If open_minute="18" Then%>selected <%End If%>>18</option>
								<option value="19" <%If open_minute="19" Then%>selected <%End If%>>19</option>
								<option value="20" <%If open_minute="20" Then%>selected <%End If%>>20</option>
								<option value="21" <%If open_minute="21" Then%>selected <%End If%>>21</option>
								<option value="22" <%If open_minute="22" Then%>selected <%End If%>>22</option>
								<option value="23" <%If open_minute="23" Then%>selected <%End If%>>23</option>
								<option value="24" <%If open_minute="24" Then%>selected <%End If%>>24</option>
								<option value="25" <%If open_minute="25" Then%>selected <%End If%>>25</option>
								<option value="26" <%If open_minute="26" Then%>selected <%End If%>>26</option>
								<option value="27" <%If open_minute="27" Then%>selected <%End If%>>27</option>
								<option value="28" <%If open_minute="28" Then%>selected <%End If%>>28</option>
								<option value="29" <%If open_minute="29" Then%>selected <%End If%>>29</option>
								<option value="30" <%If open_minute="30" Then%>selected <%End If%>>30</option>
								<option value="31" <%If open_minute="31" Then%>selected <%End If%>>31</option>
								<option value="32" <%If open_minute="32" Then%>selected <%End If%>>32</option>
								<option value="33" <%If open_minute="33" Then%>selected <%End If%>>33</option>
								<option value="34" <%If open_minute="34" Then%>selected <%End If%>>34</option>
								<option value="35" <%If open_minute="35" Then%>selected <%End If%>>35</option>
								<option value="36" <%If open_minute="36" Then%>selected <%End If%>>36</option>
								<option value="37" <%If open_minute="37" Then%>selected <%End If%>>37</option>
								<option value="38" <%If open_minute="38" Then%>selected <%End If%>>38</option>
								<option value="39" <%If open_minute="39" Then%>selected <%End If%>>39</option>
								<option value="40" <%If open_minute="40" Then%>selected <%End If%>>40</option>
								<option value="41" <%If open_minute="41" Then%>selected <%End If%>>41</option>
								<option value="42" <%If open_minute="42" Then%>selected <%End If%>>42</option>
								<option value="43" <%If open_minute="43" Then%>selected <%End If%>>43</option>
								<option value="44" <%If open_minute="44" Then%>selected <%End If%>>44</option>
								<option value="45" <%If open_minute="45" Then%>selected <%End If%>>45</option>
								<option value="46" <%If open_minute="46" Then%>selected <%End If%>>46</option>
								<option value="47" <%If open_minute="47" Then%>selected <%End If%>>47</option>
								<option value="48" <%If open_minute="48" Then%>selected <%End If%>>48</option>
								<option value="49" <%If open_minute="49" Then%>selected <%End If%>>49</option>
								<option value="50" <%If open_minute="50" Then%>selected <%End If%>>50</option>
								<option value="51" <%If open_minute="51" Then%>selected <%End If%>>51</option>
								<option value="52" <%If open_minute="52" Then%>selected <%End If%>>52</option>
								<option value="53" <%If open_minute="53" Then%>selected <%End If%>>53</option>
								<option value="54" <%If open_minute="54" Then%>selected <%End If%>>54</option>
								<option value="55" <%If open_minute="55" Then%>selected <%End If%>>55</option>
								<option value="56" <%If open_minute="56" Then%>selected <%End If%>>56</option>
								<option value="57" <%If open_minute="57" Then%>selected <%End If%>>57</option>
								<option value="58" <%If open_minute="58" Then%>selected <%End If%>>58</option>
								<option value="59" <%If open_minute="59" Then%>selected <%End If%>>59</option>
							</select>분
							~
							<select name="close_hour">
								<option value="00" <%If close_hour="00" Then%>selected <%End If%>>00</option>
								<option value="01" <%If close_hour="01" Then%>selected <%End If%>>01</option>
								<option value="02" <%If close_hour="02" Then%>selected <%End If%>>02</option>
								<option value="03" <%If close_hour="03" Then%>selected <%End If%>>03</option>
								<option value="04" <%If close_hour="04" Then%>selected <%End If%>>04</option>
								<option value="05" <%If close_hour="05" Then%>selected <%End If%>>05</option>
								<option value="06" <%If close_hour="06" Then%>selected <%End If%>>06</option>
								<option value="07" <%If close_hour="07" Then%>selected <%End If%>>07</option>
								<option value="08" <%If close_hour="08" Then%>selected <%End If%>>08</option>
								<option value="09" <%If close_hour="09" Then%>selected <%End If%>>09</option>
								<option value="10" <%If close_hour="10" Then%>selected <%End If%>>10</option>
								<option value="11" <%If close_hour="11" Then%>selected <%End If%>>11</option>
								<option value="12" <%If close_hour="12" Then%>selected <%End If%>>12</option>
								<option value="13" <%If close_hour="13" Then%>selected <%End If%>>13</option>
								<option value="14" <%If close_hour="14" Then%>selected <%End If%>>14</option>
								<option value="15" <%If close_hour="15" Then%>selected <%End If%>>15</option>
								<option value="16" <%If close_hour="16" Then%>selected <%End If%>>16</option>
								<option value="17" <%If close_hour="17" Then%>selected <%End If%>>17</option>
								<option value="18" <%If close_hour="18" Then%>selected <%End If%>>18</option>
								<option value="19" <%If close_hour="19" Then%>selected <%End If%>>19</option>
								<option value="20" <%If close_hour="20" Then%>selected <%End If%>>20</option>
								<option value="21" <%If close_hour="21" Then%>selected <%End If%>>21</option>
								<option value="22" <%If close_hour="22" Then%>selected <%End If%>>22</option>
								<option value="23" <%If close_hour="23" Then%>selected <%End If%>>23</option>
							</select>시
							<select name="close_minute">
								<option value="00" <%If close_minute="00" Then%>selected <%End If%>>00</option>
								<option value="01" <%If close_minute="01" Then%>selected <%End If%>>01</option>
								<option value="02" <%If close_minute="02" Then%>selected <%End If%>>02</option>
								<option value="03" <%If close_minute="03" Then%>selected <%End If%>>03</option>
								<option value="04" <%If close_minute="04" Then%>selected <%End If%>>04</option>
								<option value="05" <%If close_minute="05" Then%>selected <%End If%>>05</option>
								<option value="06" <%If close_minute="06" Then%>selected <%End If%>>06</option>
								<option value="07" <%If close_minute="07" Then%>selected <%End If%>>07</option>
								<option value="08" <%If close_minute="08" Then%>selected <%End If%>>08</option>
								<option value="09" <%If close_minute="09" Then%>selected <%End If%>>09</option>
								<option value="10" <%If close_minute="10" Then%>selected <%End If%>>10</option>
								<option value="11" <%If close_minute="11" Then%>selected <%End If%>>11</option>
								<option value="12" <%If close_minute="12" Then%>selected <%End If%>>12</option>
								<option value="13" <%If close_minute="13" Then%>selected <%End If%>>13</option>
								<option value="14" <%If close_minute="14" Then%>selected <%End If%>>14</option>
								<option value="15" <%If close_minute="15" Then%>selected <%End If%>>15</option>
								<option value="16" <%If close_minute="16" Then%>selected <%End If%>>16</option>
								<option value="17" <%If close_minute="17" Then%>selected <%End If%>>17</option>
								<option value="18" <%If close_minute="18" Then%>selected <%End If%>>18</option>
								<option value="19" <%If close_minute="19" Then%>selected <%End If%>>19</option>
								<option value="20" <%If close_minute="20" Then%>selected <%End If%>>20</option>
								<option value="21" <%If close_minute="21" Then%>selected <%End If%>>21</option>
								<option value="22" <%If close_minute="22" Then%>selected <%End If%>>22</option>
								<option value="23" <%If close_minute="23" Then%>selected <%End If%>>23</option>
								<option value="24" <%If close_minute="24" Then%>selected <%End If%>>24</option>
								<option value="25" <%If close_minute="25" Then%>selected <%End If%>>25</option>
								<option value="26" <%If close_minute="26" Then%>selected <%End If%>>26</option>
								<option value="27" <%If close_minute="27" Then%>selected <%End If%>>27</option>
								<option value="28" <%If close_minute="28" Then%>selected <%End If%>>28</option>
								<option value="29" <%If close_minute="29" Then%>selected <%End If%>>29</option>
								<option value="30" <%If close_minute="30" Then%>selected <%End If%>>30</option>
								<option value="31" <%If close_minute="31" Then%>selected <%End If%>>31</option>
								<option value="32" <%If close_minute="32" Then%>selected <%End If%>>32</option>
								<option value="33" <%If close_minute="33" Then%>selected <%End If%>>33</option>
								<option value="34" <%If close_minute="34" Then%>selected <%End If%>>34</option>
								<option value="35" <%If close_minute="35" Then%>selected <%End If%>>35</option>
								<option value="36" <%If close_minute="36" Then%>selected <%End If%>>36</option>
								<option value="37" <%If close_minute="37" Then%>selected <%End If%>>37</option>
								<option value="38" <%If close_minute="38" Then%>selected <%End If%>>38</option>
								<option value="39" <%If close_minute="39" Then%>selected <%End If%>>39</option>
								<option value="40" <%If close_minute="40" Then%>selected <%End If%>>40</option>
								<option value="41" <%If close_minute="41" Then%>selected <%End If%>>41</option>
								<option value="42" <%If close_minute="42" Then%>selected <%End If%>>42</option>
								<option value="43" <%If close_minute="43" Then%>selected <%End If%>>43</option>
								<option value="44" <%If close_minute="44" Then%>selected <%End If%>>44</option>
								<option value="45" <%If close_minute="45" Then%>selected <%End If%>>45</option>
								<option value="46" <%If close_minute="46" Then%>selected <%End If%>>46</option>
								<option value="47" <%If close_minute="47" Then%>selected <%End If%>>47</option>
								<option value="48" <%If close_minute="48" Then%>selected <%End If%>>48</option>
								<option value="49" <%If close_minute="49" Then%>selected <%End If%>>49</option>
								<option value="50" <%If close_minute="50" Then%>selected <%End If%>>50</option>
								<option value="51" <%If close_minute="51" Then%>selected <%End If%>>51</option>
								<option value="52" <%If close_minute="52" Then%>selected <%End If%>>52</option>
								<option value="53" <%If close_minute="53" Then%>selected <%End If%>>53</option>
								<option value="54" <%If close_minute="54" Then%>selected <%End If%>>54</option>
								<option value="55" <%If close_minute="55" Then%>selected <%End If%>>55</option>
								<option value="56" <%If close_minute="56" Then%>selected <%End If%>>56</option>
								<option value="57" <%If close_minute="57" Then%>selected <%End If%>>57</option>
								<option value="58" <%If close_minute="58" Then%>selected <%End If%>>58</option>
								<option value="59" <%If close_minute="59" Then%>selected <%End If%>>59</option>
							</select>분						</td>
					</tr>
					<tr>
						<th>좌석 수</th>
						<td>
							<input type="number" step="1" name="branch_seats" value="<%=branch_seats%>" onkeyup="onlyNum(this);">석
							<span>(숫자만 입력)</span>
						</td>
					</tr>
					<tr>
						<th>주차</th>
						<td>
							<select name="parking_yn" value="">
								<option value="1" <%If parking_yn = "1" Then%>selected <%End If%>>가능</option>
								<option value="0" <%If parking_yn = "0" Then%>selected <%End If%>>불가능</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>와이파이</th>
						<td>
							<select name="wifi_yn" value="">
								<option value="1" <%If wifi_yn = "1" Then%>selected <%End If%>>가능</option>
								<option value="0" <%If wifi_yn = "0" Then%>selected <%End If%>>불가능</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>단체</th>
						<td>
							<select name="group_yn" value="">
								<option value="1" <%If group_yn = "1" Then%>selected <%End If%>>가능</option>
								<option value="0" <%If group_yn = "0" Then%>selected <%End If%>>불가능</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>수제맥주 취급</th>
						<td>
							<select name="beer_yn" value="">
								<option value="Y" <%If beer_yn = "Y" Then%>selected <%End If%>>취급</option>
								<option value="N" <%If beer_yn = "N" Then%>selected <%End If%>>미취급</option>
							</select>
						</td>
					</tr>
				</table>
				<div style="margin-top:20px">
					<input type="button" class="btn_red125" onClick="InputCheck()" value="저 장">
				</div>
			</form>
			</div>
		</div>
	</div>
</body>
</html>