<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="pageNavigator">
<div>
 	<%
 	int cPage = pageObject.getCurrentPageNo();
	int tPage = pageObject.getTotalPageCount();
	%>
	<%if(pageObject.hasPreviousPage()){%>
		<a href="javascript:prePage();">&lt;&lt;</a>
	<%}else{%>
		<span class="disabled">&lt;&lt;</span>
	<%}%>
	
	<%if(tPage<14){%><!-- 总页数小于14全部显示 -->
		<%for(int i=1;i<=tPage;i++){
				if(i!=cPage){%>
					<a href="javascript:goPage('<%=i%>');"><%=i%></a>  				
  			<%}else{%>
  				<span class="current"><%=cPage%></span>
  			<%}
			}
	}else{
		if(cPage<=6){%><!-- 当前页小于6，显示前6页和最后两页 -->
			<%for(int i=1;i<=6;i++){
					if(i!=cPage){%>
						<a href="javascript:goPage('<%=i%>');"><%=i%></a>  					
  				<%}else{%>
  					<span class="current"><%=i%></span>
  				<%}
				}%>
			<span>...</span><a href="javascript:goPage('<%=tPage-1%>');"><%=tPage-1%></a><a href="javascript:goPage('<%=tPage%>');"><%=tPage%></a>
		<%}else if(tPage-cPage<=6){%><!-- 当前页在最后5页中,显示1.2页和最后5页 -->
			<a href="javascript:goPage('1');">1</a><a href="javascript:goPage('2');">2</a><span>...</span>
			<%for(int i=6;i>=0;--i){
					if((tPage-cPage)!=i){%>
  					<a href="javascript:goPage('<%=tPage-i%>');"><%=tPage-i%></a>  					
  				<%}else{%>
  					<span class="current"><%=cPage%></span>
  				<%}
				}%>
	<%}else{%><!-- 显示前两条和最后两条及中间7条 -->
		<a href="javascript:goPage('1');">1</a><a href="javascript:goPage('2');">2</a><span>...</span>
		<%for(int i=3;i>=-3;i--){
			if(i==0){%>
  			<span class="current"><%=cPage%></span>
  		<%}else{%>
  			<a href="javascript:goPage('<%=cPage-i%>');"><%=cPage-i%></a>
  		<%}
		}%>
		<span>...</span><a href="javascript:goPage('<%=tPage-1%>');"><%=tPage-1%></a><a href="javascript:goPage('<%=tPage%>');"><%=tPage%></a>
	<%}
	}%>
    
  <%if(pageObject.hasNextPage()){%>
  	<a href="javascript:nextPage();">&gt;&gt;</a>
	<%}else{%>
		<span class="disabled">&gt;&gt;</span>
	<%}%>
	</div>
	<label>
		<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb07a30002") %><!-- 总记录数 -->[<%=pageObject.getTotalSize()%>]
		<input type="hidden" name="pageno" value="<%=pageObject.getCurrentPageNo()%>">
		<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60059") %><!-- 每页 -->[<input type="text" name="pagesize" size="2" value="<%=pageObject.getPageSize()%>" onChange="javascript:document.VelcroForm.submit();">]
	</label>
</div>