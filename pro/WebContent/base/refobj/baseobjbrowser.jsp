<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.net.URLEncoder"%>

<%
String sqlwhere = StringHelper.null2String((String)request.getParameter("sqlwhere"));
sqlwhere=StringHelper.getDecodeStr(sqlwhere);
String reportwhere = StringHelper.null2String((String)request.getParameter("reportwhere"));
String refid = StringHelper.null2String((request.getParameter("id")));
RefobjService refobjService = (RefobjService)BaseContext.getBean("refobjService");
Refobj refobj = refobjService.getRefobj(refid);
if("humres".equals(refobj.getReftable())){
	session.setAttribute("checksqlwhere",sqlwhere);
}
 String idsin=StringHelper.null2String(request.getParameter("idsin"));

List refobjlist = new ArrayList();
Page pageObject = null;
String objname = "";
String keyfield = "";
if(refobj != null){
	String refurl = StringHelper.null2String(refobj.getRefurl());
	objname = StringHelper.null2String(refobj.getViewfield());
	keyfield = StringHelper.null2String(refobj.getKeyfield());
	
	if(!StringHelper.isEmpty(refobj.getFilter())){
		sqlwhere=sqlwhere.equalsIgnoreCase("")?"("+refobj.getFilter()+")":"("+sqlwhere+") AND ("+refobj.getFilter()+")";
	}
	
	if((refurl == null) || refurl.equals("")){
		pageObject = (Page) request.getAttribute("pageObject");
		if (pageObject == null) { 
			if(!StringHelper.isEmpty(sqlwhere)){
	
				sqlwhere=  StringHelper.getEncodeStr(sqlwhere);
				request.getRequestDispatcher("/ServiceAction/com.eweaver.base.refobj.servlet.BaseobjAction?action=search&&refid=" + refid + "&sqlwhere=" + sqlwhere).forward(request, response);
			}else{
				request.getRequestDispatcher("/ServiceAction/com.eweaver.base.refobj.servlet.BaseobjAction?action=search&&refid=" + refid).forward(request, response);
			}
			return ;
		}
		try{
			refobjlist = (List)pageObject.getResult();
		}catch(Exception e){
			refobjlist = null;
		}
		
	}else{
		for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
	        String pName = e.nextElement().toString();
			if(!pName.equalsIgnoreCase("url")){
				String val=StringHelper.null2String(request.getParameter(pName));
				if(pName.equalsIgnoreCase("sqlwhere")) val = sqlwhere; 
					//val=StringHelper.getDecodeStr(sqlwhere);
				else val=URLEncoder.encode(val, "UTF-8");
				if(refurl.indexOf("?")==-1){
					refurl += "?"+pName+"="+val;
				}else{
					if(refurl.indexOf("sqlwhere")>-1){
						if(refurl.indexOf("&")>-1){
							refurl = refurl.substring(0,refurl.lastIndexOf("&"));
						}else{
							refurl=refurl.substring(0,refurl.indexOf("sqlwhere"));
						}
					}
					refurl += "&"+pName+"="+val;
				}
				
			}
	    }
		
		String againrefurl = StringHelper.null2String(refobj.getRefurl());
		if(againrefurl.indexOf("sqlwhere")>-1){
			if("".equals(sqlwhere)){
				sqlwhere = "("+againrefurl.substring(againrefurl.indexOf("sqlwhere")+9,againrefurl.length())+") ";
			}else{
				sqlwhere = sqlwhere + " and ("+againrefurl.substring(againrefurl.indexOf("sqlwhere")+9,againrefurl.length())+") ";
			}
		}
		
	  	String filter=refobj.getFilter();
	  	if(!StringHelper.isEmpty(filter)){
	  		filter= "&sqlwhere=" +StringHelper.getEncodeStr(sqlwhere);
	  	}else{
	  		refurl = refurl+"&sqlwhere=" +StringHelper.getEncodeStr(sqlwhere);
	  	}
	  	
		if(!StringHelper.isEmpty(filter)){
	    	//filter= "&sqlwhere=" +StringHelper.getEncodeStr(filter);
		    response.sendRedirect(request.getContextPath()+refurl+filter+"&keyfield="+keyfield+"&showfield="+objname+"&idsin="+idsin+"&refid="+refobj.getId());
		}else{
		    response.sendRedirect(request.getContextPath()+refurl+"&keyfield="+keyfield+"&showfield="+objname+"&idsin="+idsin+"&refid="+refobj.getId());
		}
		return;
	}
}else{
	response.sendRedirect(request.getContextPath()+"/base/main.jsp");
	return;
}
%>

<html>
  <head>
  
  </head>

<body>
  
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:onSubmit()}";
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
pagemenustr += "{D,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:btnclear_onclick()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->
   <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.refobj.servlet.BaseobjAction?action=search" name="EweaverForm"  method="post">
   <input type="hidden" name="refid" value="<%=refid%>"/>
   <input type="hidden" name="sqlwhere" value="<%=sqlwhere%>"/>
   
    <!--************ searchTable end ************ -->
   <table id=searchTable>
    
      <tr>
		 <td class="FieldName" width=10% nowrap>
			   <%=labelService.getLabelName("402881eb0bcbfd19010bcc16ecb1000b")%>
		 </td>
		 <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="objname" />
		 </td>     
             
   </table>
     <!--************ searchTable end ************ -->
   
<TABLE ID=BrowserTable class=BrowserStyle cellspacing=1>
		<tbody>
			<tr class=Title>
				<TH style="display:none"></TH> <!--表头 字段-->
				<TH nowrap><%=labelService.getLabelName("402881eb0bcbfd19010bcc16ecb1000b")%></TH>
	
			</tr>
     <%
		if (refobjlist != null && refobjlist.size() != 0 ) {
			boolean isLight=false;
			String trclassname="";
			Map refmap = null;
			for (int i=0;i<refobjlist.size();i++){
				refmap = (Map) refobjlist.get(i);  		
	 			isLight=!isLight;
				if(isLight) trclassname="DataLight";
					else trclassname="DataDark";
     %>		
		           <tr class="<%=trclassname%>">
		                <td style="display:none">					    
						    <%=StringHelper.null2String((String) refmap.get(keyfield))%>
						</td>
						<td nowrap><%=StringHelper.null2String((String) refmap.get(objname))%></td>
					</tr>  			
	<%
			}
		}
	%>	
			</tbody>
			
</TABLE>
			<table border="0">
				<tr>
					<td>&nbsp;</td>
					<td nowrap align=center>						
						<%=labelService.getLabelName("402881e60aabb6f6010aabba742d0001")%>[<%=pageObject.getTotalPageCount()%>]
						&nbsp;
						<%=labelService.getLabelName("402881e60aabb6f6010aabbb07a30002")%>[<%=pageObject.getTotalSize()%>]
						&nbsp;
					</td>
					<td nowrap align=center>
						<button  type="button" accessKey="F" onclick="onSearch(1)">
					     <U>F</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbb63210003")%>
				        </button>&nbsp;
						<button  type="button" accessKey="P" onclick="onSearch(<%=pageObject.getCurrentPageNo()==1?1:pageObject.getCurrentPageNo()-1%>)">
					     <U>P</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbba5b80004")%>
				        </button>&nbsp;
				        <button  type="button" accessKey="N" onclick="onSearch(<%=pageObject.getCurrentPageNo()==pageObject.getTotalPageCount()? pageObject.getTotalPageCount():pageObject.getCurrentPageNo()+1%>)">
					     <U>N</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbbdc0a0005")%>
				        </button>&nbsp;
				        <button  type="button" accessKey="L" onclick="onSearch(<%=pageObject.getTotalPageCount()%>)">
					     <U>L</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbc0c900006")%>
				        </button>
					</td>
					<td nowrap align=center>
						<%=labelService.getLabelName("402881e60aabb6f6010aabbc75d90007")%>
						<input type="text" name="pageno" size="2" value="<%=pageObject.getCurrentPageNo()%>" onChange="javascript:onSearch(<%=pageObject.getCurrentPageNo()%>);">
						&nbsp;
						<%=labelService.getLabelName("402881e60aabb6f6010aabbcb3110008")%>
						<input type="text" name="pagesize" size="2" value="<%=pageObject.getPageSize()%>" onChange="javascript:onSearch(<%=pageObject.getCurrentPageNo()%>);">
					</td>
					<td>&nbsp;</td>
				</tr>
			</table>  
	</form>
<script language="javascript" type="text/javascript">
function getArray(id,value){
    window.parent.returnValue = [id,value];
    window.parent.close();
}
function onSearch(pageno){
   	document.EweaverForm.pageno.value=pageno;
	document.EweaverForm.submit();
}    
function onSubmit(){
	document.EweaverForm.submit();
} 
</script>

  </body>
</html>