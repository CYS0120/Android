<!--#include virtual="/api/include/g2_script.asp"-->
<script src="/common/js/libs/jquery-1.12.4.min.js"></script>
<script src="/common/js/libs/jquery-ui-1.12.1.js"></script>
<script src="/common/js/libs/jquery.mobile.custom.min.js?ver=202001007122020"></script>
<script src="/common/js/libs/plugin.js?ver=202001007122020"></script>
<script src="/common/js/common.js?ver=202001007122020"></script>
<script src="/common/js/global.js?ver=20210602_075100"></script>
<script src="/common/js/libs/swiper.min.js?ver=202001007122020"></script>
<script src="/api/common/functions.js?ver=20210909110003"></script>
<script src="/common/js/functions.js?ver=20210909100003"></script>
<script src="/common/js/proj4js-combined.js?ver=202001007122020"></script>
<% IF FALSE THEN %>
<script src="/common/js/libs/jquery.mobile.custom.min.js?ver=202001007122020"></script>
<script src="/common/js/libs/plugin.js?ver=202001007122020"></script>
<script src="/common/js/common.js?ver=202001007122020"></script>
<script src="/common/js/global.js?ver=202001007122020"></script>
<script src="/common/js/libs/swiper.min.js?ver=202001007122020"></script>
<script src="/api/common/functions.js?ver=20210615172801"></script>
<script src="/common/js/functions.js?ver=20210615172801"></script>
<% END IF %>
<script src="/api/common/JsBarcode.all.min.js"></script>

<script type="text/javascript">
    var isLoggedIn = <%If Session("userIdNo") <> "" Then Response.Write "true" Else Response.Write "false" End If%>;
    var returnUrl = "<%=GetReturnUrl%>";
</script>


<!-- 하단 네비게이션 스크립트 -->
<!-- <script type="text/javascript" src="/common/js/jquery-1.12.4.min.js"></script> -->
<script type="text/javascript" src="/common/js/more.js"></script>


<!-- 메뉴리스트 아코디언 -->
<!-- <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>  -->