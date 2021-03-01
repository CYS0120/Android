<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" File="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<%
    Dim dbconn

    Sub DBOpen
        Dim connString
        connString = "Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=BBQ;Data Source=40.82.154.186,1433;User ID=sa_homepage;Password=home123!@#;"
'        connString = "Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=BBQ;Data Source=1.201.140.33;User ID=sa;Password=bbq1205!#;"

        If Not IsObject(dbconn) Then
            Set dbconn = Server.CreateObject("ADODB.Connection")
        End If
        
        If dbconn.State = adStateClosed Then
            dbconn.ConnectionString = connString
            dbconn.CursorLocation = 3
            dbconn.Open
        End If
    End Sub

    Sub DBClose
        If Not (dbconn Is Nothing) Then
            If dbconn.State = adStateOpen Then
                dbconn.Close
            End If
            Set dbconn = Nothing
        End If
    End Sub

    Call DBOpen
%>