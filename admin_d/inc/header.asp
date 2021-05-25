<!-- #include virtual="/inc/popup_div.asp" -->

        <script>
            function PWMod(user_idx){
               $.ajax({
                  async: true,
                  type: "POST",
                  url: "../change_pw.asp",
                  data: {"IDX":user_idx},
                  cache: false,
                  dataType: "html",
                  success: function (data) {
                     if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
                     }else{
                        $("#member_info_div").html(data);
                        wrapWindowByMask();
                     }
                  },
                  error: function(data, status, err) {
                     alert(err + '서버와의 통신이 실패했습니다.');
                  }
               });
            }

            $(function() {
               var curURL = document.location.href;
               var curURLsplit = curURL.substring(curURL.lastIndexOf("/") - 6, curURL.lastIndexOf("/"));
               // alert(curURLsplit);

               if (curURLsplit == "coupon") {
                  document.getElementById("changepw").style.display = "none";
               }else{
                  document.getElementById("changepw").style.display = "block";
               }
            });
         </script>

         <!--header-->
         <div class="head_wrap">
               <div class="log_info">
                  <ul>
                     <li>
                        <span><%=SITE_ADM_ID%> 님</span>
                        <span>&nbsp;환영합니다.</span>
                     </li>
                     <li>
                        <span>접속IP:</span>
                        <span><%=GetIPADDR()%></span>
                     </li>
                     <!--li>
                        <span>접속경과시간:</span>
                        <span>05시간 20분</span>
                     </li>
                     <li>
                        <span>자동 로그아웃 남은시간 :</span>
                        <span>50분</span>
                     </li-->
                     <div style='margin-right:10px;' id="changepw" name="changepw" style='display:none;' >
                         <a style='cursor:pointer;' class="logout" onclick="PWMod('<%=SITE_ADM_CD%>')">정보수정</a>
                     </div>
                     <div>
                         <a href="<%=SITE_ADM_DIR%>logout.asp" class="logout">로그아웃</a>
                     </div>
                </ul>
            </div>
        </div>
        <!--//header-->
