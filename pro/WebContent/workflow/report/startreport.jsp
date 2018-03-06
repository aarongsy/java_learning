<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>

<%
  String html="";
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
ReportdefService reportdefService= (ReportdefService) BaseContext.getBean("reportdefService");
 String reportid=StringHelper.null2String(request.getParameter("reportid"));
//报表权限控制
    ModuleService moduleService = (ModuleService) BaseContext.getBean("moduleService");
Map reportperMap = reportdefService.getReportdefPer();
//报表权限控制
  int level = 9;
 String url="/workflow/report/reportsearch.jsp?reportid=";
    String isreport="1";
%>
<html>
  <head>
   <style>
#div0,#div1,#div2,#div3{width:22%;height:100%;float:left;}
     ul{margin-left:25px;}
   /*   *.li{  list-style-type:CIRCLE;}*/
      a:link, a:visited {text-decoration: underline; color: blue}
      a:hover {text-decoration: underline; color: red; }

</style>
    <script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>

    <script src='<%=request.getContextPath()%>/dwr/interface/ModuleService.js'></script>
    <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajaxqueue.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type="text/javascript">
function insertUL(str, i){
    Ext.DomHelper.insertHtml("beforeEnd",Ext.getDom("div"+i),str);
}
function expand(id){
	var o;
	if(id){
		o = document.getElementById(id);
	}else{
		o = event.srcElement;
		while(o.tagName!="LI"){
			if(o.tagName=="A"){
				location.href = o.href;
				return false;
			}
			o = o.parentNode;
		}
	}
	if(!o) return false;
	if(o.getAttribute("loaded")){
		/*if(o.getAttribute("expanding")){
			for(var i=0;i<o.childNodes.length;i++){
				var n = o.childNodes[i];
				if(n.tagName=="UL"){
					n.style.display = n.style.display=="none" ? "" : "none";
				}
			}
		}*/
	}else{
		load(o);
	}
}
function load(o){
     o.loaded = "true";
	 o.expanding = "true";
    Ext.Ajax.request({
        url:contextPath + '/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=getreportlist',
        params:{pid:o.id},
        success: function(res) {
            data = eval(res.responseText);
            if (data) {
                o.appendChild(createEl(o, data));
                var nodes = o.childNodes;
                for (var i = 0; i < nodes.length; i++) {
                    if (nodes[i].tagName == "UL") {
                        for (var j = 0; j < nodes[i].childNodes.length; j++) {
                            if (nodes[i].childNodes[j].level <<%=level%>) {
                                $(nodes[i].childNodes[j].id).bind('click', expandHandler);
                                $(nodes[i].childNodes[j].id).trigger('click');
                            }
                        }
                    }
                }
            }
            resizeMainPageBodyHeight();/*调整主页面的body高度*/
        }
    });

}

function createEl(parentObj,data,module){
	var u = document.createElement("UL");

	for(var i=0;i<data.length;i++){
		var l = document.createElement("LI");
		l.id = data[i].id;
        if(module=='module'){
            var objname=ignoreSpaces(data[i].objname);
            l.innerHTML ="<b>"+ objname+"</b>";

        }else{
            var objname=ignoreSpaces(data[i].objname);
            l.innerHTML = "<span><a href=\"javascript:onUrl('<%=url%>" + data[i].id +"','"+objname+ "')\" ><img src=<%=request.getContextPath()%>/images/base/search.gif border=0></a></span><a href=javascript:onSearchByWorkflowid('"+data[i].id+"','"+objname+"','"+data[i].formid+"')>"+objname+"</a>";
        }
		l.level = parseInt(parentObj.level) + 1;
		$(l).bind("click",expandHandler);
		u.appendChild(l);
	}
	return u;
}
var expandHandler=function(ev){
       var o = ev.target;
       ev.stopPropagation();
		while(o.tagName!="LI"){
			if(o.tagName=="A"){
				location.href = o.href;
				return false;
			}
			o = o.parentNode;
		}
	if(!o) return false;
	if(o.getAttribute("loaded")){
		/*if(o.getAttribute("expanding")){
			for(var i=0;i<o.childNodes.length;i++){
				var n = o.childNodes[i];
				if(n.tagName=="UL"){
					n.style.display = n.style.display=="none" ? "" : "none";
				}
			}
		}*/
	}else{
		load(o);
	}
    };
function expandToLevel(){
    $('LI').bind('click',expandHandler);
    $('LI').trigger('click');

}
window.onload = function(){
	<%
	List list = moduleService.getModules(reportid,isreport);
	int size = list.size();
	if(size>0){
		for(int i=0;i<size;i++){
			Module module = (Module)list.get(i);
			int dsporder=(module.getDsporder()==null)?-1:module.getDsporder();
			html = "<ul><li id=\""+module.getId()+"\" level=\"1\" >";
			html+="<b>"+module.getObjname()+"</b>";
			html += "</li></ul>";
			html +="<br>";
			html +="<br>";
			if(dsporder>0)
			out.print("insertUL('"+html+"', "+(dsporder-1)%4+");");
			else
			out.print("insertUL('"+html+"', "+i%4+");");

		}
	}
	%>
	expandToLevel();
}
 </script>
  </head>
  <body>
<br>
<div id="div0"></div>
<div id="div1"></div>
<div id="div2"></div>
<div id="div3"></div>
  
</body>
<script language="javascript"> 
  function onSearchByWorkflowid(reportid,title,formid){
	//parent.HomePageIframe2.location.href="/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid="+reportid;
      if(formid=='402881e80c33c761010c33c8594e0005'){
          onUrl("/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&reportid="+reportid,title,'rep'+reportid,null,'page_find');

      }else{
          onUrl("/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid="+reportid,title,'rep'+reportid,null,'page_find');

      }
  }
  function ignoreSpaces(string) {
var temp = "";
string = '' + string;
splitstring = string.split(" ");
for(i = 0; i < splitstring.length; i++)
temp += splitstring[i];
return temp;
}
</script>
</html>