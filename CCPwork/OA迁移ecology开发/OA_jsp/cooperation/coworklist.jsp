<%@ page import="com.eweaver.cowork.model.*"%>
<%@ page import="com.eweaver.app.cooperation.*"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ include file="init.jsp"%>
<%
/*获取协作区信息*/
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
DataService ds = new DataService();
String type = StringHelper.null2String(request.getParameter("type")).equals("")?"1":StringHelper.null2String(request.getParameter("type"));
String tagid = StringHelper.null2String(request.getParameter("tagid"));
String coworkid = StringHelper.null2String(request.getParameter("coworkid"));
if(CoworkHelper.IsNullCoworkset()){
	out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置好协作区关联表单信息后再来操作。</h5>");
	return;
}
List<Map<String,Object>> list = ds.getValues("select * from COWORKTAG where disabled='0' and (userid='"+eweaveruser.getId()+"' or userid is null) and ISDELETE=0 order by ordernum asc");
%>
<html>
<head>
<link  type="text/css" rel="stylesheet" href="/js/jquery/plugins/crselect/crselect.css" />
<link  type="text/css" rel="stylesheet" href="/app/cooperation/css/default.css" />
<% if(userMainPage.getIsUseSkin()){ //当前用户选择的首页是使用皮肤的%>
<link rel="stylesheet" type="text/css" id="main_css" href="<%=currentSkin.getBasePath() %>/cooperation.css"/> 
<% } %>
<script type="text/javascript" language="javascript" src="/app/cooperation/js/openUrl.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/crselect/crselect.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/app/cooperation/js/scripts/boot.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajax.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type="text/javascript">
jQuery(function(){
	jQuery("#navigationiframe, #navigationiframe .mini-panel-viewport, #navigationiframe .mini-panel-body").height(jQuery(window).height()-68);
	jQuery(window).resize(function(){
		var a = jQuery(document.body).height()+37;//alert(h);
		jQuery("#navigationiframe, #navigationiframe .mini-panel-viewport, #navigationiframe .mini-panel-body").height(jQuery(window).height()-68);
	});
	
	jQuery('#allcbox').hide();
	jQuery('#menu1, #allcbox').mouseover(function(){
		jQuery('#allcbox').show();
	});
	jQuery('#menu1, #allcbox').mouseout(function(){
		jQuery('#allcbox').hide();
	});
	
	$("#searchtype").CRselectBox();
	mini.parse();
});

function resize2() {
	window.parent.resize();
	// force ie10 redraw
	/**if(navigator.userAgent.indexOf('MSIE 10.0') != -1) {
		var w = document.body.clientWidth;
		document.body.style.width = w + 1 + 'px';
		setTimeout(function(){
			document.body.style.width = w - 1 + 'px';
			document.body.style.width = 'auto';
		}, 0);  // 这个延时时间看情况可能需要适当调大
	}  **/     
} 
self.setInterval("resize2()",1000);

var tagid="402881e83abf0214013abf0220810290";
var callbox=0;

function orderList(param){
	var searchtype = document.getElementById("searchtype").value;
	var searchobjname = document.getElementById("searchobjname").value;
	var order = "unimportant";
	if(param=="important"){
		order=param;
	}
	if (window.frames[0]) {
		   var src = window.frames[0].document.location.href + "";
		   if(src.indexOf("/app/cooperation/coworknavigation.jsp") > -1){
			   window.frames[0].document.location.href="/app/cooperation/coworknavigation.jsp?type=<%=type %>&tagid="+tagid+"&searchtype="+searchtype+"&searchobjname="+searchobjname+"&order="+order;
		   }
	}
}

function tagList(tagid){
	 if (window.frames[0]) {
		   var src = window.frames[0].document.location.href + "";
		   if(src.indexOf("/app/cooperation/coworknavigation.jsp") > -1){
	  			var cboxs = window.frames[0].document.getElementsByName("cowork_cbox");
	  			var temp=true;
	  			for(var i=0;i<cboxs.length;i++){
	  				if(cboxs[i].checked){
	  					temp=false;
	  					var requestid=cboxs[i].value+"";
	  					var action ="batchChangeCoWorkTag";
	  					if(tagid.indexOf("402881e83abf0214013abf0220810292")>-1){
	  						action="changeCoWorkTag";
	  					}
	  					if(tagid.indexOf("402881e83abf0214013abf0220810291")>-1){
	  						action="readCoWork";
	  					}
	  					Ext.Ajax.timeout = 900000;
			  			Ext.Ajax.request({
			  			       url: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action="+action,
			  			       params:{requestid:requestid,tagid:tagid},
			  			       sync:true,
			  			       success: function(res) {
			  			    	    if(tagid.indexOf("402881e83abf0214013abf0220810292")>-1){
					  			        var xml=res.responseXML;
					  		            var cellHtml = xml.getElementsByTagName("cell")[0].text+"";
					  		            if(cellHtml && cellHtml!=""){
					  		            	if (window.frames[0]) {
						  		    			   var src = window.frames[0].document.location.href + "";
						  		    			   if(src.indexOf("/app/cooperation/coworknavigation.jsp") > -1){
								  		            	var div = window.frames[0].document.getElementById(requestid+"_tagimg");
								  		 	    	        div.innerHTML=cellHtml;
						  		    			   }
					  		            	}
					  		            }
			  			    	    }else if(tagid.indexOf("402881e83abf0214013abf0220810291")>-1){
			  			    	    	var xml=res.responseXML;
					  		            var cellHtml = xml.getElementsByTagName("cell")[0].text+"";
					  		            if(cellHtml && cellHtml!=""){
					  		            	if (window.frames[0]) {
					  		    			   var src = window.frames[0].document.location.href + "";
					  		    			   if(src.indexOf("/app/cooperation/coworknavigation.jsp") > -1){
						  		            	     var div = window.frames[0].document.getElementById(requestid+"_tipimg");
						  		 	    	             div.innerHTML=cellHtml;
					  		    			   }
					  		            	}
					  		            }
			  			    	    }
			  			       }
			  		    });
	  				}
	  			}
	  			if(temp){
	  				alert("请选择要标记的协作！");
	  			}else{
		  			if (window.frames[0]) {
						window.frames[0].document.location.reload();
					}
	  			}
		   }
	  }
}

//搜索
function querystore(){
	var searchtype = document.getElementById("searchtype").value;
	var searchobjname = document.getElementById("searchobjname").value;
	 if (window.frames[0]) {
		   var src = window.frames[0].document.location.href + "";
		   if(src.indexOf("/app/cooperation/coworknavigation.jsp") > -1){
			   window.frames[0].document.location.href="/app/cooperation/coworknavigation.jsp?type=<%=type %>&tagid="+tagid+"&searchtype="+searchtype+"&searchobjname="+searchobjname;
		   }
	 }
}

document.onkeydown = function(e){
    if(!e) e = window.event;//火狐中是 window.event
    if((e.keyCode || e.which) == 13){
    	querystore();
    }
 }

function onItemClick(e) {
    var item = e.item;
    var isLeaf = e.isLeaf;
    if (isLeaf) {
       var text = item.text;
       var id = item.id+"";
       if(id=="tagmanager"){
    	   onUrl('/app/cooperation/coworktag.jsp','标签管理','tagtabs');
       }else if(id=="allcbox"){
    	   if (window.frames[0]) {
    		   var src = window.frames[0].document.location.href + "";
    		   if(src.indexOf("/app/cooperation/coworknavigation.jsp") > -1){
	    			var cboxs = window.frames[0].document.getElementsByName("cowork_cbox");
	    			for(var i=0;i<cboxs.length;i++){
	    				if(callbox==0){
	    					cboxs[i].checked="checked";
	    				}else{
	    					cboxs[i].checked="";
	    				}
	    			}
	    			callbox = (0-callbox)+1;
    		   }
    	   }
       }else if(id.indexOf("yes_")>-1 || id.indexOf("no_")>-1){
    	   tagList(id);
       }else if(id=="important" || id=="unread"){
    	   orderList(id);
       }else if(id.length==32){
    	     tagid = id;
    	     var searchtype = document.getElementById("searchtype").value;
    		 var searchobjname = document.getElementById("searchobjname").value;
    		 if (window.frames[0]) {
    			   var src = window.frames[0].document.location.href + "";
    			   if(src.indexOf("/app/cooperation/coworknavigation.jsp") > -1){
    				   window.frames[0].document.location.href="/app/cooperation/coworknavigation.jsp?type=<%=type %>&tagid="+tagid+"&searchtype="+searchtype+"&searchobjname="+searchobjname;
    			   }
    		 }
       }
    }            
}
function allcboxClick(){
	if (window.frames[0]) {
    		   var src = window.frames[0].document.location.href + "";
    		   if(src.indexOf("/app/cooperation/coworknavigation.jsp") > -1){
	    			var cboxs = window.frames[0].document.getElementsByName("cowork_cbox");
	    			for(var i=0;i<cboxs.length;i++){
	    				if(callbox==0){
	    					cboxs[i].checked="checked";
	    				}else{
	    					cboxs[i].checked="";
	    				}
	    			}
	    			callbox = (0-callbox)+1;
    		   }
    	   }
}
</script>
<style>

</style>
</head>
<body class="bodyCoworklist">
<input type="checkbox" id="allcbox" onclick="allcboxClick()" style="position:absolute;top:46;"/>

<table cellpadding="0px" cellspacing="0px" border="0" width="100%">
	<tr>
	    <td width="22%">
	    <button type="button" style="height:24px;width:88px;margin:10px 0;CURSOR: hand;" 
	    		onclick="javascript:onUrl('/app/cooperation/createcowork.jsp','新建协作','createtab');">
				<img src="/images/silk/comment_add.gif" style="vertical-align:middle;">
				新建协作</button>
	    </td>
		<td>
			<div class="search" style="">
				<div class="searchtype">
					<select id="searchtype" name="searchtype">
						<option value="0">
							所有分类
						</option>
						<%
						list = ds.getValues("SELECT reftable,keyfield,viewfield FROM refobj WHERE ID='"+CoworkHelper.getParams("coworktype")+"'");
						   if(list!=null && list.size()>0){
							   for(int i=0;i<list.size();i++){
								   Map<String,Object> m =list.get(i);
								   String reftable=StringHelper.null2String(m.get("reftable"));
								   String keyfield=StringHelper.null2String(m.get("keyfield"));
								   String viewfield=StringHelper.null2String(m.get("viewfield"));
								   List<Map<String,String>> l = ds.getValues("select "+keyfield+","+viewfield+" from "+reftable+" where requestid in (select id from formbase where isdelete=0)");
								   if(l!=null && l.size()>0){
									   for(int j=0;j<l.size();j++){
										   Map<String,String> m1 =l.get(j);
										   String refid=StringHelper.null2String(m1.get(keyfield));
										   String keyobjname=StringHelper.null2String(m1.get(viewfield));
						%>
						<option value="<%=refid %>">
							<%=keyobjname %>
						</option>
						<%}}}} %>
					</select>
				</div>
				<div class="searchcontent">
					<input type="text" name="searchobjname" id="searchobjname" />
				</div>
				<div class="searchbutton" onclick="javascript:querystore();"></div>
			</div>
		</td>
	</tr>
	<tr  style="height: auto;" valign="top" >
		<td colspan="2">
			<!--  begin 协作区列表显示 -->
			<ul id="menu1" class="mini-menubar" style="width:100%;border:0;" url="/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=coworkmenu" onitemclick="onItemClick" textField="text" idField="id" parentField="pid" >
			</ul>   
			<div id="navigationiframe" name="navigationiframe" class="mini-panel" title="header" iconCls="icon-add" style="width:100%;height:525px;border:0px;" showToolbar="false" showHeader="false" showCollapseButton="false" showFooter="false" bodyStyle="padding:0;" url="/app/cooperation/coworknavigation.jsp?type=<%=type %>&tagid=<%=tagid %>&coworkid=<%=coworkid %>" expanded="true" >
			</div>		
			<!--  end  协作区列表显示 -->
		</td>
	</tr>
</table>
	</body>
</html>
