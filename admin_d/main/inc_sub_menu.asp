<% 
dim sub_menu : sub_menu = "" 
if PATH_INFO <> "" then 
	sub_menu = replace(replace(PATH_INFO, "/main/", ""), ".asp", "")
end if
%> 
				<div class="section_main_sel">
					<table>
						<tbody>
							<tr>
								<th>
									<ul>
										<li><label><input type="radio" name="curpage" <%if sub_menu = "main_set" then %>checked <% end if %>onClick="document.location.href='main_set.asp?CD=<%=CD%>'">메인 이미지 관리</label></li>
										<li><label><input type="radio" name="curpage" <%if sub_menu = "main_seo" then %>checked <% end if %>onClick="document.location.href='main_seo.asp?CD=<%=CD%>'">검색엔진 최적화(SEO)</label></li>
										<% if CD = "I" then %>
											<li><label><input type="radio" name="curpage" <%if sub_menu = "main_set_m" then %>checked <% end if %>onClick="document.location.href='main_set_m.asp?CD=<%=CD%>'">모바일 메인 이미지 관리</label></li>
											<!--<li><label><input type="radio" name="curpage" onClick="document.location.href='main_set_vod.asp?CD=<%=CD%>'">동영상 연결</label></li>-->
										<% end if %>
										<% if CD = "A" then %>
											<li><label><input type="radio" name="curpage" <%if sub_menu = "main_hit_m" then %>checked <% end if %>onClick="document.location.href='main_hit_m.asp?CD=<%=CD%>'">실시간 인기</label></li>
											<li><label><input type="radio" name="curpage" <%if sub_menu = "main_set_m" then %>checked <% end if %>onClick="document.location.href='main_set_m.asp?CD=<%=CD%>'">모바일 메인 이미지 관리</label></li>
											<li><label><input type="radio" name="curpage" <%if sub_menu = "main_set_sub" then %>checked <% end if %>onClick="document.location.href='main_set_sub.asp?CD=<%=CD%>'">서브 이미지 관리</label></li>
											<li><label><input type="radio" name="curpage" <%if sub_menu = "main_set_sub_m" then %>checked <% end if %>onClick="document.location.href='main_set_sub_m.asp?CD=<%=CD%>'">모바일 서브 이미지 관리</label></li>
										<% end if %>
									</ul>
								</th>
							</tr>
						</tbody>
					</table>
				</div>