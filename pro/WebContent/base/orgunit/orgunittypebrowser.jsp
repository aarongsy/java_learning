<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunittype"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunittypeService"%>
<%@ include file="/base/init.jsp"%>
<%
String area = StringHelper.null2String((String)request.getParameter("area"));
OrgunittypeService orgunittypeService = (OrgunittypeService)BaseContext.getBean("orgunittypeService");
%>
<html>
<head>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.7.2.min.js"></script>
</head>
<body>
  		<!-- 标题 -->
  		<%titlename=labelService.getLabelName("402881eb0bcbfd19010bcc187bfa000c ");%>
  		
<!--页面菜单开始-->     
<%
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:onReturn()}";
pagemenustr += "{Q,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:btnclear_onclick()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 
			
			<table ID=BrowserTable class=BroswerStyle cellspacing=1>	
				<TBODY>
				<tr class="Header">
					<th width="0%" style="display:none">id</th>
					<th width="100%"><%=labelService.getLabelName("402881eb0bcbfd19010bcc187bfa000c ")%></th>
				</tr>
<%
			List list = orgunittypeService.getOrgunittypeList();
			Orgunittype orgunittype = null;
			boolean isLight=false;
			String trclassname="";
			if(area.equalsIgnoreCase("1")){
				for (int i = 0; i < list.size(); i++) {
					orgunittype = (Orgunittype) list.get(i);					
					isLight=!isLight;
					if(isLight) trclassname="DataLight";
					else trclassname="DataDark";
						if(StringHelper.null2String(orgunittype.getCol1()).equalsIgnoreCase("1")){
%>
				<tr class="<%=trclassname%>">
				<!-- 内容行 -->				
					<td style="display:none">
						<%=orgunittype.getId()%>
					</td>
					<td>
					<%=orgunittype.getObjname()%>
					</td>
			
<%}}
			}else{
				for (int i = 0; i < list.size(); i++) {
					orgunittype = (Orgunittype) list.get(i);					
					isLight=!isLight;
					if(isLight) trclassname="DataLight";
					else trclassname="DataDark";
%>
				<tr class="<%=trclassname%>">
				<!-- 内容行 -->				
					<td style="display:none">
						<%=orgunittype.getId()%>
					</td>
					<td>
					<%=orgunittype.getObjname()%>
					</td>
<%}} %>	
			</tbody>
		</table>


<script>
	function onReturn(){
		if(!Ext.isSafari){
	        window.parent.close();
 		}else{
 	        parent.win.close();
 		}
	}
	var dialogValue;
	function btnclear_onclick(){
		getArray("0","");
	}
	
	function getEvent(){
		if(document.all){
			return window.event;//如果是ie
		}
		func=getEvent.caller;
		while(func!=null){
			var arg0=func.arguments[0];
			if(arg0){
				if((arg0.constructor==Event || arg0.constructor ==MouseEvent)||(typeof(arg0)=="object" && arg0.preventDefault && arg0.stopPropagation)){
					return arg0;
				}
			}
			func=func.caller;
		}
		return null;
	}

		
	jQuery(function($){
			var BrowserTable  = $("#BrowserTable");
			BrowserTable.on("click", function(){
				var evt=getEvent();
				var e=evt.srcElement || evt.target;
				if(e.tagName == "TD"){
					//alert(e+"---"+evt+"==="+e.tagName+"---2"+e.parentElement.tagName+"--3--");
					getArray ((e.parentElement.cells)[0].innerHTML,(e.parentElement.cells)[1].innerHTML);
				}else if(e.tagName == "A"){
					getArray ((e.parentElement.parentElement.cells)[0].innerHTML,(e.parentElement.cells)[1].innerHTML)
				}
			});
			
			BrowserTable.on("mouseover", function(){
				var evt=getEvent();
				var e=evt.srcElement || evt.target;
				if(e.tagName == "TD"){
					$(e.parentElement).attr("class","Selected");
				}else if(e.tagName == "A"){
					$(e.parentElement.parentElement).attr("class","Selected");
				}
			});
			
			BrowserTable.on("mouseout", function(){
				var p;
				var evt=getEvent();
				var e=evt.srcElement || evt.target;
				if(e.tagName == "TD"||e.tagName == "A"){
					if(e.tagName == "TD" ){
						p = e.parentElement
					}else if(e.tagName == "A"){
						p = e.parentElement.parentElement;
					}
					if(p.RowIndex%2){
						$(p).attr("class","DataLight");
					}else{
						$(p).attr("class","DataDark");
					}
				}
			});
	});
	
    function getArray(id,value){
        if(!Ext.isSafari){
		    window.parent.returnValue = [id,value];
	        window.parent.close();
 		}else{
 		   dialogValue=[id,value];
 	       parent.win.close();
 		}
    }
</script>
</body></html>

