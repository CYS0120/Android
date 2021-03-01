<%
    dim tab_class(3)

    if title_nm = "비비큐 이야기" then
        tab_class(0) = " class=""on"""
        tab_class(1) = ""
        tab_class(2) = ""
    elseif title_nm = "올리브 이야기" then
        tab_class(0) = ""
        tab_class(1) = " class=""on"""
        tab_class(2) = ""
    elseif title_nm = "콘텐츠" then
        tab_class(0) = ""
        tab_class(1) = ""
        tab_class(2) = " class=""on"""
    else
        tab_class(0) = ""
        tab_class(1) = ""
        tab_class(2) = ""
    end if
%>
			<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li <%=tab_class(0)%>><a href="./bbq.asp"><span>비비큐 이야기</span></a></li>
					<li <%=tab_class(1)%>><a href="./oliveList.asp"><span>올리브 이야기</span></a></li>
					<li <%=tab_class(2)%>><a href="./contentsList.asp"><span>콘텐츠</span></a></li>
				</ul>
			</div>
<%
%>