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
	' * �ٳ� �޴��� ���� ���
	' *
	' * - ���� ��� ��û ������
	' *      CP���� �� ���� ��� ���� ����
	' *
	' * ���� �ý��� ������ ���� ���ǻ����� �����ø� ���񽺰��������� ���� �ֽʽÿ�.
	' * DANAL Commerce Division Technique supporting Team
	' * EMail : tech@danal.co.kr
	' *
	' ********************************************************************************/

    LOC = request("LOC")
    ORDER_NUM = request("ORDER_NUM")
    CALLBACK = request("CALLBACK")


  	Dim TransR

	'/***[ �ʼ� ������ ]************************************/  
  	Set TransR = CreateObject("Scripting.Dictionary")
  
	'/******************************************************
	' * ID		: �ٳ����� ������ �帰 ID( function ���� ���� )
	' * PWD		: �ٳ����� ������ �帰 PWD( function ���� ���� )
	' * TID		: ���� �� ���� �ŷ���ȣ( TID or DNTID )
	' ******************************************************/  
  	TransR.Add "ID", ID
  	TransR.Add "PWD", PWD
	TransR.Add "TID", TID

 	' /***[ ���� ������ ]*************************************
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
		' * ��� ������ ���� �۾�
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
    //console.log("���� ��ҵǾ����ϴ�.");
    //alert("���� ��ҵǾ����ϴ�.");
	parent.alertMsg("point_err");
	parent.ClosePaylayer();
</script>
<%
    Else
        'Response.Write Map2Str(Res)
        '/**************************************************************************
        ' *
        ' * ��� ���п� ���� �۾�
        ' *
        ' **************************************************************************/
%>
<script language="javascript">
    console.log('���� ��ҵ��� �ʾҽ��ϴ�. <%=Res.Item("ErrMsg")%>');
    alert('���� ��ҵ��� �ʾҽ��ϴ�. <%=Res.Item("ErrMsg")%>');
</script>
<%


    End If

%>
