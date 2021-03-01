<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "SUPER"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
user_idx	= InjRequest("user_idx")
menuA1	= InjRequest("menuA1")
menuA2	= InjRequest("menuA2")
menuB1	= InjRequest("menuB1")
menuB2	= InjRequest("menuB2")
menuC1	= InjRequest("menuC1")
menuC2	= InjRequest("menuC2")
menuD1	= InjRequest("menuD1")
menuD2	= InjRequest("menuD2")
menuE1	= InjRequest("menuE1")
menuE2	= InjRequest("menuE2")
menuF1	= InjRequest("menuF1")
menuF2	= InjRequest("menuF2")
menuG1	= InjRequest("menuG1")
menuG2	= InjRequest("menuG2")
menuH1	= InjRequest("menuH1")
menuH2	= InjRequest("menuH2")


If FncIsBlank(user_idx) Then 
	Response.Write "E^필수 정보를 모두 입력해 주세요"
	Response.End
End If 

menuA1 = Replace(menuA1," ","")
menuA2 = Replace(menuA2," ","")
menuB1 = Replace(menuB1," ","")
menuB2 = Replace(menuB2," ","")
menuC1 = Replace(menuC1," ","")
menuC2 = Replace(menuC2," ","")
menuD1 = Replace(menuD1," ","")
menuD2 = Replace(menuD2," ","")
menuE1 = Replace(menuE1," ","")
menuE2 = Replace(menuE2," ","")
menuF1 = Replace(menuF1," ","")
menuF2 = Replace(menuF2," ","")
menuG1 = Replace(menuG1," ","")
menuG2 = Replace(menuG2," ","")
menuH1 = Replace(menuH1," ","")
menuH2 = Replace(menuH2," ","")

'On Error Resume Next

Sql = "	Update bt_admin_user Set menuA1 = '"& menuA1 &"',menuA2 = '"& menuA2 &"',menuB1 = '"& menuB1 &"',menuB2 = '"& menuB2 &"',menuC1 = '"& menuC1 &"',menuC2 = '"& menuC2 &"',menuD1 = '"& menuD1 &"',menuD2 = '"& menuD2 &"',menuE1 = '"& menuE1 &"',menuE2 = '"& menuE2 &"',menuF1 = '"& menuF1 &"',menuF2 = '"& menuF2 &"',menuG1 = '"& menuG1 &"',menuG2 = '"& menuG2 &"',menuH1 = '"& menuH1 &"',menuH2 = '"& menuH2 &"' Where user_idx = " & user_idx
conn.Execute(Sql)
Response.Write "Y^수정 되었습니다"

'If Err.number <> 0 then
'	Response.Write "E^"& Err.Description
'End If
conn.Close
Set conn = Nothing 
%>