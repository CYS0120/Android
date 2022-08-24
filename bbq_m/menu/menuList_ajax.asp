<!--#include virtual="/api/include/utf8.asp"-->
<% Call DBOpen %>
<%
	category_idx = GetReqStr("cidx",0)

	dim m_i : m_i = 0

	if category_idx = "103" then 

		Set aCmd = Server.CreateObject("ADODB.Command")

		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "UP_MENU_LIST_GUBUN"

			.Parameters.Append .CreateParameter("@GUBUN", adInteger, adParamInput, , category_idx)

			Set aRs = .Execute
		End With

		Set aCmd = Nothing

	elseif category_idx = "99999" then 

		Set aCmd = Server.CreateObject("ADODB.Command")

		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_sidemenu_select"

			Set aRs = .Execute
		End With

		Set aCmd = Nothing

	elseif category_idx = "58" then 

		Set aCmd = Server.CreateObject("ADODB.Command")

		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_sidemenu_select_kind_sel"

			.Parameters.Append .CreateParameter("@kind_sel", adInteger, adParamInput, , category_idx)

			Set aRs = .Execute
		End With

		Set aCmd = Nothing

	else

		Set aCmd = Server.CreateObject("ADODB.Command")

		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_category_menu_list"

			.Parameters.Append .CreateParameter("@category_idx", adInteger, adParamInput, , category_idx)
			' .Parameters.Append .CreateParameter("@use_yn", adVarChar, adParamInput, 1, "N")

			Set aRs = .Execute
		End With

		Set aCmd = Nothing
	end if 

	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst

		Do Until aRs.EOF

			' 배달이면서 수제 맥주 일경우 미노출 : 20210427 추가 (수제맥주 세트)
			IF order_type = "D" and aRs("KIND_SEL") = "115" Then
				anc_display = "N"
			End if 

			if aRs("menu_type") = "B" then ' B : 일반메뉴(M으로 변경해야됨) / S : 사이드메뉴
				vMenuType_plus = "M"
			else
				vMenuType_plus = aRs("menu_type")
			end if

			If aRs("KIND_SEL") = "133" Then
				If Not CheckLogin() Then
%>
					<!--#include virtual="/api/include/requireLogin.asp"-->
<%
				End If

			End If
%>

			<div name="menu_div" id="list_div_<%=m_i%>" data-menuname="<%=aRs("menu_name")%>" data-menuidx="<%=aRs("menu_idx")%>" data-menucate="<%=category_idx%>" class="menuBox menu_cate_<%=category_idx%> menu_list_idx_<%=category_idx%>_<%=aRs("menu_idx")%>" <% if anc_display = "N" then %>style="display:none"<% end if %>>
				<ul class="menuWrap" onclick="location.href='/menu/menuView.asp?midx=<%=aRs("menu_idx")%>'">
					<li class="menuImg"><img src="<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")&aRs("thumb_file_name")%>"></li>
					<li class="menuText">
						<h4><%=aRs("menu_name")%></h4>
						<p><span>가격</span><strong><%=FormatNumber(aRs("menu_price"),0)%>원</strong></p>
					</li>
				</ul>

				<div class="menuList_btn clearfix">
					<button type="button" class="btn btn_list_cart btn_newImg" onClick="addMenuNGo('<%=vMenuType_plus%>$$<%=aRs("menu_idx")%>$$<%=aRs("menu_option_idx")%>$$<%=aRs("menu_price")%>$$<%=aRs("menu_name")%>$$<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")&aRs("thumb_file_name")%>$$$$<%=aRs("KIND_SEL")%>', false);">장바구니 담기</button>
					<a href="javascript: addMenuNGo('<%=vMenuType_plus%>$$<%=aRs("menu_idx")%>$$<%=aRs("menu_option_idx")%>$$<%=aRs("menu_price")%>$$<%=aRs("menu_name")%>$$<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")&aRs("thumb_file_name")%>$$$$<%=aRs("KIND_SEL")%>', true);" class="btn btn_list_order btn_newImg">주문하기</a>
				</div>
			</div>

<%

			m_i = m_i + 1

			aRs.MoveNext
		Loop
	End If

	Set aRs = Nothing

	call DBClose
%>
