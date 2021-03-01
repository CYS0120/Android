<!--#include virtual="/api/include/g2_script.asp"-->
<script src="/common/js/libs/jquery-1.12.4.min.js"></script>
<script src="/common/js/libs/jquery-ui-1.12.1.js"></script>
<script src="/common/js/libs/jquery.nicescroll.min.js"></script>
<script src="/common/js/common.js?ver=<%=Year(Now) & Right("0"& Month(Now), 2) & Right("0"& Day(Now), 2) & Right("0"& Hour(Now), 2) & Right("0"& Minute(Now), 2) & Right("0"& Second(Now), 2)%>"></script>
<script src="/common/js/global.js?ver=<%=Year(Now) & Right("0"& Month(Now), 2) & Right("0"& Day(Now), 2) & Right("0"& Hour(Now), 2) & Right("0"& Minute(Now), 2) & Right("0"& Second(Now), 2)%>"></script>
<script src="/api/common/functions.js?ver=<%=Year(Now) & Right("0"& Month(Now), 2) & Right("0"& Day(Now), 2) & Right("0"& Hour(Now), 2) & Right("0"& Minute(Now), 2) & Right("0"& Second(Now), 2)%>"></script>
<script src="/common/js/functions.js?ver=<%=Year(Now) & Right("0"& Month(Now), 2) & Right("0"& Day(Now), 2) & Right("0"& Hour(Now), 2) & Right("0"& Minute(Now), 2) & Right("0"& Second(Now), 2)%>"></script>
<script src="/common/js/jquery.blockUI.js?ver=<%=Year(Now) & Right("0"& Month(Now), 2) & Right("0"& Day(Now), 2) & Right("0"& Hour(Now), 2) & Right("0"& Minute(Now), 2) & Right("0"& Second(Now), 2)%>"></script>
<script src="/common/js/jquery.bPopup.js?ver=<%=Year(Now) & Right("0"& Month(Now), 2) & Right("0"& Day(Now), 2) & Right("0"& Hour(Now), 2) & Right("0"& Minute(Now), 2) & Right("0"& Second(Now), 2)%>"></script>
<script type="text/javascript">
    var isLoggedIn = <%If Session("userIdNo") <> "" Then Response.Write "true" Else Response.Write "false" End If%>;
    var returnUrl = "<%=GetReturnUrl%>";
</script>
