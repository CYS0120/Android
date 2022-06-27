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

	Sql = "Select * From bt_branch Where branch_id = " & BRCD & " And BRAND_CODE='"& BRAND_CODE &"' "
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
	pickup_discount	= Rinfo("pickup_discount")

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
	button, input[type=button], input[type=submit] {cursor: pointer;}
	.btn_red125 {height:37px;width:125px;background:#e41937;font-size:20px;color:#fff;display:inline-block;line-height:37px;font-weight:bold;}

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
		dataType: "text",
		success: function (data) {
			alert(data.split("^")[1]);
			if(data.split("^")[0] == 'Y'){
				location.reload();
			}
		},
		error: function(data, status, err) {
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
				<div class="store_title"><span>BBQ 자사앱 포장할인 금액 설정</span></div>
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
						<th>포장할인 금액</th>
						<td>
							<input type="number" step="100" name="pickup_discount" value="<%=pickup_discount%>" onkeyup="onlyNum(this);">원 
							<span>(숫자만 입력)</span>
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