<script src="/common/js/libs/jquery-1.12.4.min.js"></script>
<script src="/common/js/libs/jquery-ui-1.12.1.js"></script>
<script src="/common/js/libs/jquery.nicescroll.min.js"></script>
<script src="/common/js/common.js"></script>
<script src="/common/js/global.js"></script>
<script src="/api/common/functions.js"></script>
<script src="/common/js/functions.js"></script>
<script type="text/javascript">
    var isLoggedIn = <%If Session("userIdNo") <> "" Then Response.Write "true" Else Response.Write "false" End If%>;
    var returnUrl = "<%=GetReturnUrl%>";
</script>