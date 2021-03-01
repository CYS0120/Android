<!-- #include virtual="/admin_d/inc/config.asp" -->
<%
	If Not FncIsBlank(SITE_ADM_CD) Then 
		Response.redirect "./main/main_set.asp"
		Response.End 
	End If
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/admin_d/inc/head.asp" -->
<script language="javascript">
function RefreshImage(valImageId) {
	var objImage = document.getElementById(valImageId)
	if (objImage == undefined) {
		return;
	}
	var now = new Date();
	objImage.src = objImage.src.split('?')[0] + '?x=' + now.toUTCString();
}
function LoginCheck(){
	var f = document.LoginFrm;
	if(f.user_id.value==''){alert('아이디를 입력해주세요');f.user_id.focus();return false;}
	if(f.user_pass.value==''){alert('비밀번호를 입력해주세요');f.user_pass.focus();return false;}
	if(f.txtCaptcha.value==''){alert('보안코드를 입력해주세요');f.txtCaptcha.focus();return false;}
	if (f.saveAdminId.checked == true) {
		setCookie("CHSHOP_ADM_ID", f.user_id.value, 365);
	}
	$.ajax({
		async: false,
		type: "POST",
		url: "login_proc.asp",
		data: $("#LoginFrm").serialize(),
		dataType : "text",
		success: function(data) {
			if (data.split("^")[0] == "Y") {
				document.location.href="./";
			}else{
				alert(data.split("^")[1]);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
	return false;
}
function Init() {
	var f = document.LoginFrm;
	f.saveAdminId.checked = ((f.user_id.value = getCookie("CHSHOP_ADM_ID")) != "");
}
</script>
</head>
<body style="height:auto;min-height:0;" onload="Init()">
    <div class="wrap">
        <div class="section_login">
            <div class="login_tit">
                <div class="top_tit">
                    <span class="first_tit">NO.1 Franchise Group by 2025Y</span>
                    <span class="second_tit">GENESIS BBQ GROUP</span>
                    <span class="third_tit">Genesism BBQ Group Integrated Menegement System</span>
                </div>
            </div>
            <div class="login_content">
                <div class="login_location">
                    <div class="captin">
                        <img src="img/captin.png" alt="" class="cap" >
		                <form id="LoginFrm" name="LoginFrm" method="post" onSubmit="return LoginCheck()">
                            <div class="login_input">
                                <div><input type="text" name="user_id" placeholder="User Id"></div>
                                <div><input type="password" name="user_pass" placeholder="Password"></div>
                                <div class="security">
                                    <ul>
                                        <li>
                                            <img src="./captcha/captcha.asp" id="imgCaptcha" name="imgCaptcha" width="198">
                                            <img src="img/redo-alt.png" alt="" class="refresh" id="refresh" onClick="javascript:RefreshImage('imgCaptcha'); document.LoginFrm.txtCaptcha.focus();"><label for="refresh" style="cursor:pointer;font-size:12px;">새로고침</label>
                                        </li>
                                        <li><input type="text" name="txtCaptcha" placeholder="보안코드입력" alt="새로고침 [F8]" onKeyUp="javascript:if (event.keyCode == 119) { RefreshImage('imgCaptcha'); document.LoginFrm.txtCaptcha.focus(); } else { this.value=this.value.toUpperCase(); }"></li>
                                    </ul>
                                </div>
                                <div class="id_save">
                                    <ul>
                                        <li>
                                            <label for="id_check">
                                                <input type="checkbox" id="id_check" name="saveAdminId">
                                                ID Save
                                            </label>
                                        </li>
                                        <!--li><a>Password</a></li-->
                                    </ul>
                                </div>
                                <div><input type="submit" value="Login"></div>
                            </div>
                        </form>
                        <img src="img/login_bg.png" alt="" class="loginbg">
                    </div>
                    
                </div>
            </div>
        </div>
<%	FOTTER_LOGIN = "Y" %>
<!-- #include virtual="/admin_d/inc/footer.asp" -->
    </div>
</body>
</html>