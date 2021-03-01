<%
  Response.AddHeader "pragma","no-cache"
	'/********************************************************************************
	' *
	' * 다날 본인인증
	' *
	' * - 인증 완료 페이지
	' *
	' * 시스템 연동에 대한 문의사항이 있으시면 서비스개발팀으로 연락 주십시오.
	' * DANAL Commerce Division Technique supporting Team
	' * EMail : tech@danal.co.kr
	' *
	' ********************************************************************************/

    '/********************************************************************************
	' *
	' * XSS 취약점 방지를 위해 
	' * 모든 페이지에서 파라미터 값에 대해 검증하는 로직을 추가할 것을 권고 드립니다.
	' * XSS 취약점이 존재할 경우 웹페이지를 열람하는 접속자의 권한으로 부적절한 스크립트가 수행될 수 있습니다.
	' * 보안 대책
	' *  - html tag를 허용하지 않아야 합니다.(html 태그 허용시 white list를 선정하여 해당 태그만 허용)
	' *  - <, >, &, " 등의 문자를 replace등의 문자 변환함수를 사용하여 치환해야 합니다.
	' * 
	' ********************************************************************************/
%>
<!--#include file="inc/function.asp"-->
<%
  Dim BgColor

	'Response.write Request.Form("IDEN")

	IDEN = Request.Form("IDEN")
	'IDEN = "0010113"

  '/*
  ' * Get BgColor
  ' */
  BgColor = GetBgColor( BgColor )
%>
<script src="/common/js/libs/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
    $(document).ready(function(){

		var ch = $('#IDEN').val().slice(6,7);
		var year = $('#IDEN').val().slice(0,2);

		var age;
		if(ch == '1' || ch == '2')
			//1900년대
			year = 1900 + parseInt(year);
		else if (ch == '3' || ch == '4')
			//2000년대
			year = 2000 + parseInt(year);

		var dt = new Date();
		age = dt.getFullYear() - year;

		if(age >= 19){
			alert("성인인증이 완료 되었습니다.");					
			opener.document.getElementById("Danal_adult_chk_button").style.display = "none";
			opener.document.pay_form.Danal_adult_chk_ok.value = "Y";
			$('#pay_ok_go_btn', opener.document).removeClass('btn-lightGray').addClass('btn-red');
			window.close();
		}else{
			alert("미성년자는 주류를 구매할 수 없습니다.");
			opener.document.pay_form.Danal_adult_chk_ok.value = "";
			$('#pay_ok_go_btn', opener.document).removeClass('btn-red').addClass('btn-lightGray');
			window.close();
		}
        
    });
</script>
<input type="hidden" name="IDEN" id="IDEN" value="<%=IDEN%>">
<input type="hidden" name="isAdult" id="isAdult" value="">