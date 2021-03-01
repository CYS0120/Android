<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="/common/js/libs/jquery-1.12.4.min.js"></script>

<script language="javascript">
function getAddr(){
	$.ajax({
		 url :"http://www.juso.go.kr/addrlink/addrCoordApiJsonp.do"  //인터넷망
		,type:"post"
		,data:$("#form").serialize()
		,dataType:"jsonp"
		,crossDomain:true
		,success:function(jsonStr){
			$("#list").html("");
			var errCode = jsonStr.results.common.errorCode;
			var errDesc = jsonStr.results.common.errorMessage;
			if(errCode != "0"){
				alert(errCode+"="+errDesc);
			}else{
				if(jsonStr != null){
					makeListJson(jsonStr);
				}
			}
		}
	    ,error: function(xhr,status, error){
	    	alert("에러발생");
	    }
	});
}

function makeListJson(jsonStr){
	var htmlStr = "";
	htmlStr += "<table>";
	$(jsonStr.results.juso).each(function(){
		htmlStr += "<tr>";
//		htmlStr += "<td>"+this.admCd+"</td>";
//		htmlStr += "<td>"+this.rnMgtSn+"</td>";
//		htmlStr += "<td>"+this.bdMgtSn+"</td>";
//		htmlStr += "<td>"+this.udrtYn+"</td>";
//		htmlStr += "<td>"+this.buldMnnm+"</td>";
//		htmlStr += "<td>"+this.buldSlno+"</td>";
		htmlStr += "<td>"+this.entX+"</td>";
		htmlStr += "<td>"+this.entY+"</td>";
//		htmlStr += "<td>"+this.bdNm+"</td>";
		htmlStr += "</tr>";
	});
	htmlStr += "</table>";
	$("#list").html(htmlStr);
}
</script>
<title>Insert title here</title>
</head>
<body>
<form name="form" id="form" method="post">
	<input type="text" name="resultType" value="json"/> <!-- 요청 변수 설정 (검색결과형식 설정, json) --> 
	<input type="text" name="confmKey" value="U01TX0FVVEgyMDIwMTAwNjExNDc1MDExMDI1OTk="/><!-- 요청 변수 설정 (승인키) -->
	<input type="text" name="admCd" value="1171010700"/> <!-- 요청 변수 설정 (행정구역코드) -->
	<input type="text" name="rnMgtSn" value="117104169061"/><!-- 요청 변수 설정 (도로명코드) --> 
	<input type="text" name="udrtYn" value="0"/> <!-- 요청 변수 설정 (지하여부) -->
	<input type="text" name="buldMnnm" value="21"/><!-- 요청 변수 설정 (건물본번) --> 
	<input type="text" name="buldSlno" value="0"/><!-- 요청 변수 설정 (건물부번) -->
	<input type="button" onClick="getAddr();" value="좌표검색하기"/>
	<div id="list" ></div><!-- 검색 결과 리스트 출력 영역 -->
</form>
</body>
</html> 

<!-- 
admCd: "1171010700"
bdKdcd: "0"
bdMgtSn: "1171010700101900007027180"
bdNm: "큰바위빌딩"
buldMnnm: "21"
buldSlno: "0"
detBdNmList: ""
emdNm: "가락동"
emdNo: "01"
engAddr: "21, Dongnam-ro 18-gil, Songpa-gu, Seoul"
jibunAddr: "서울특별시 송파구 가락동 190-7 큰바위빌딩"
liNm: ""
lnbrMnnm: "190"
lnbrSlno: "7"
mtYn: "0"
rn: "동남로18길"
rnMgtSn: "117104169061"
roadAddr: "서울특별시 송파구 동남로18길 21 (가락동)"
roadAddrPart1: "서울특별시 송파구 동남로18길 21"
roadAddrPart2: " (가락동)"
sggNm: "송파구"
siNm: "서울특별시"
udrtYn: "0"
zipNo: "05783"
 -->
