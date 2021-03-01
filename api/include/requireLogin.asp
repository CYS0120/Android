<%
    If Not CheckLogin() Then
%>
    <script type="text/javascript">
        showConfirmMsg({msg:"로그인이 필요합니다.",ok:function(){
            openLogin();
        },
        cancel: function(){
            location.href = "/";
        }});
    </script>
<%
        Response.End
    End If
%>