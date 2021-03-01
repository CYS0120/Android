<div class="page_num">
	<div class="paging_before">
		<a href="?page=1<%=Detail%>" class="btn_arrow">&#60;&#60;</a>
<%
	If total_block <= block Then 
		  last_page = total_page
	End If  
	If block > 1 Then 
		my_page = first_page - 1
%>
		<a href="?page=<%=my_page%><%=Detail%>" class="btn_arrow">&#60;</a>
<%	Else %>
		<a href="javascript:;" class="btn_arrow">&#60;</a>
<%	End If %>
	</div>
	<div class="">
		<ul>
<%	For direct_page = first_page To last_page
		If int(page) = int(direct_page) Then	%>
			<li><a href="javascript:;" class="on"><%=direct_page%></a></li>
<%		else	%>
			<li><a href="?page=<%=direct_page%><%=Detail%>"><%=direct_page%></a></li>
<%		End If
	Next	%>
		</ul>
	</div>
	<div class="board_paging_after">
<%
	If block < total_block Then 
		my_page = last_page+1	%>
		<a href="?page=<%=my_page%><%=Detail%>" class="btn_arrow">&#62;</a>
<%	else	%>
		<a href="javascript:;" class="btn_arrow">&#62;</a>
<%	End If	%>
		<a href="?page=<%=total_page%><%=Detail%>" class="btn_arrow">&#62;&#62;</a>
	</div>
</div>