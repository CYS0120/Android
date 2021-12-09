<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include file="inc/function.asp"-->
<%
    Session.CodePage = 65001
    Response.Charset = "UTF-8"

    Response.AddHeader "pragma","no-cache"

	cardNo = request("cardNo")
	birthDay = request("birthDay")
	ORI_AMT = request("ORI_AMT")
	AMT = request("AMT")
	mode = request("mode")
  
	'/********************************************************************************
	' *
	' * 다날 휴대폰 결제 취소
	' *
	' * - 결제 취소 요청 페이지
	' *      CP인증 및 결제 취소 정보 전달
	' *
	' * 결제 시스템 연동에 대한 문의사항이 있으시면 서비스개발팀으로 연락 주십시오.
	' * DANAL Commerce Division Technique supporting Team
	' * EMail : tech@danal.co.kr
	' *
	' ********************************************************************************/

    LOC = request("LOC")
    ORDER_NUM = request("ORDER_NUM")
    CALLBACK = request("CALLBACK")


  	Dim TransR

	'/***[ 필수 데이터 ]************************************/  
  	Set TransR = CreateObject("Scripting.Dictionary")
  
	'/******************************************************
	' * ID		: 다날에서 제공해 드린 ID( function 파일 참조 )
	' * PWD		: 다날에서 제공해 드린 PWD( function 파일 참조 )
	' * TID		: 결제 후 받은 거래번호( TID or DNTID )
	' ******************************************************/  
  	TransR.Add "ID", ID
  	TransR.Add "PWD", PWD
	TransR.Add "TID", TID

 	' /***[ 고정 데이터 ]*************************************
        '  * Command      : BILL_CANCEL
        '  * OUTPUTOPTION : 3
        ' ******************************************************/
  	TransR.Add "Command", "BILL_CANCEL"
  	TransR.Add "OUTPUTOPTION", "3"

  
	Set Res = CallTeledit( TransR,false )

	IF Res.Item("Result") = "0" Then		
		Response.Write Map2Str(Res)
		'/**************************************************************************
		' *
		' * 취소 성공에 대한 작업
		' *
		' **************************************************************************/	
        CALLBACK_SCRIPT = ""
        If Len(CALLBACK) > 0 Then
            If CALLBACK = "CLOSE" Then 
                CALLBACK_SCRIPT = "window.close();"
            Else
                CALLBACK_SCRIPT = "parent." & CALLBACK & "()"
            End If
        End If
%>
<script type="text/javascript">
    //console.log("결제 취소되었습니다.");
    //alert("결제 취소되었습니다.");
	parent.alertMsg("point_err");
	parent.ClosePaylayer();
</script>
<%
    Else
        'Response.Write Map2Str(Res)
        '/**************************************************************************
        ' *
        ' * 취소 실패에 대한 작업
        ' *
        ' **************************************************************************/
%>
<script language="javascript">
    console.log('결제 취소되지 않았습니다. <%=Res.Item("ErrMsg")%>');
    alert('결제 취소되지 않았습니다. <%=Res.Item("ErrMsg")%>');
</script>
<%


    End If

%>
