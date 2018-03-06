<%@ page contentType="text/html; charset=UTF-8" import="java.net.URLEncoder"%>
<%@ include file="/base/init.jsp"%>
<%
String idsin=StringHelper.null2String(request.getParameter("idsin"));
String sqlWhere ="";
sqlWhere = StringHelper.null2String((String)request.getParameter("sqlwhere"));//" hrstatus='4028804c16acfbc00116ccba13802935' ";
String treewhere = StringHelper.getDecodeStr(sqlWhere);
//sqlWhere=URLEncoder.encode(sqlWhere,"utf-8");

/*
String treewhere = StringHelper.null2String((String)request.getParameter("treewhere"));//" hrstatus='4028804c16acfbc00116ccba13802935' ";
if(!treewhere.equalsIgnoreCase(""))
	treewhere=URLEncoder.encode(treewhere,"utf-8");
*/

String viewerId=request.getParameter("id");
String reportId=request.getParameter("reportid");
if(viewerId==null) viewerId="";
String rootId=request.getParameter("rootId");
if(rootId==null) rootId="";

String strMutil=request.getParameter("mutil");//是否多选
if(strMutil==null) strMutil="false";

String strLeaf=request.getParameter("leaf");//是否叶子结点可选
if(strLeaf==null) strLeaf="false";

String strSync=request.getParameter("sync");//是否异步全选
if(strSync==null) strSync="false";
if(strMutil!=null && !strMutil.equalsIgnoreCase("true")) strSync="false";

String level = request.getParameter("level");
if(StringHelper.isEmpty(level)){
	level = "2";
}
String url=request.getContextPath()+"/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerAction?viewerId="+viewerId+"&rootId="+rootId+"&level="+level+"&type=dir";
/*
if(strMutil!=null)url+="&mutil="+strMutil;
if(strSync!=null)url+="&sync="+strSync;
if(strLeaf!=null)url+="&leaf="+strLeaf;
*/
if(!treewhere.equalsIgnoreCase("")){
//将sqlwhere=[abc='23rasfas'&ad=32]等字符串分解为［Wabc=ewfsd&Wad=32］
	//treewhere=treewhere.replaceAll("(\\w+)=", "W$1=");
	//treewhere=treewhere.replaceAll("='([^=']*)'", "=$1");
	treewhere=  StringHelper.getEncodeStr(treewhere);
	url+="&sqlwhere="+treewhere ;
}
if(!StringHelper.isEmpty(request.getParameter("optType"))){
	url+="&optType="+request.getParameter("optType");
}
if(!StringHelper.isEmpty(request.getParameter("orgTypeId"))){
	url+="&orgTypeId="+request.getParameter("orgTypeId");
}
if(!StringHelper.isEmpty(request.getParameter("showtype"))){
	url+="&showtype="+request.getParameter("showtype");
}
if(!StringHelper.null2String(request.getParameter("browser")).equalsIgnoreCase(""))
	url+="&browser="+request.getParameter("browser");

//if(!StringHelper.isEmpty(reportId))
	url+="&iframe=true";//如果未填写reportId，则只有树状Browser
	
if(!StringHelper.isEmpty(request.getParameter("hiddenFlag"))){
	url+="&hiddenFlag="+request.getParameter("hiddenFlag");
}

String selected=StringHelper.null2String(request.getParameter("selected"));
if(!selected.equalsIgnoreCase("")) url+="&selected="+URLEncoder.encode(selected,"utf-8");

String url2=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&browser=1&isformbase=1";
url2+="&reportid="+reportId;
url2+="&sqlwhere="+sqlWhere;

if(!StringHelper.isEmpty(request.getParameter("keyfield")))
	url2+="&keyfield="+request.getParameter("keyfield");

if(!StringHelper.isEmpty(request.getParameter("showfield")))
	url2+="&showfield="+request.getParameter("showfield");

//url="about:blank";
//url2="about:blank";
%>
<HTML><HEAD>
<STYLE type=text/css>PRE {
}
A {
	COLOR:#000000;FONT-WEIGHT: bold; TEXT-DECORATION: none
}
A:hover {
	COLOR:#56275D;TEXT-DECORATION: none
}
</STYLE>

<script type="text/javascript">
var idsin=window.parent.dialogArguments;
var bannerId=0;
<%
String bannerId=StringHelper.null2String(request.getParameter("bid"));
bannerId=bannerId.equalsIgnoreCase("")?"0":bannerId;
out.println("bannerId="+bannerId+";");
%>

var dialogValue;

var tabs=null;
var url="<%=StringHelper.filterJString(url)%>";
var url2="<%=StringHelper.filterJString(url2)%>";
var arItems=[{title: '树状查询',contentEl:'divTab1'}];
<%if(!StringHelper.isEmpty(reportId)){%>
arItems.push({title: '组合查询',contentEl:'divTab2'});
<%}else url2="about:blank";%>
Ext.onReady(function(){
    // basic tabs 1, built from existing content
    var spanHeight=document.getElementById('tabsSpan').clientHeight;

    tabs = new Ext.TabPanel({
        renderTo: 'tabsSpan',
        activeTab:bannerId,
        frame:true,
        resizeTabs:true,
        height:spanHeight,
		enableTabScroll:true,
        //autoHeight:true,
        defaults:{autoWidth: true},
        items:arItems
    });
   <%
    String refid = StringHelper.null2String(request.getParameter("refid"));
    //当browser为组织单元多选的时候，应该能带出原来选择的部门
    if(refid.equals("40287e8e12066bba0112068b730f0e9c")){%>
   		 document.getElementById("iframeTree").src = Ext.isIE ? "<%=url%>&selected=" + idsin : "<%=url%>&selected=<%=idsin%>";
    <%}else{
        if(refid.equals("402883ff3c610d3d013c610d4332004c") || refid.equals("402883ff3c610d3d013c610d4333004d")){%>
    	document.getElementById("iframeTree").src = "<%=url%>&refid=<%=refid%>";
       <%}else{%>
    	document.getElementById("iframeTree").src = Ext.isIE ? "<%=url%>&selected=" + idsin : "<%=url%>&selected=<%=idsin%>";
    <% }}%>
});
</script>
</HEAD>
<body>
<div id="tabsSpan" style="height:100%;">
	<div id="divTab1"  class="x-hide-display" >
    <iframe id="iframeTree" frameborder="0" style="width:100%;height:100%;" ></iframe>
</div>
<%if(!StringHelper.isEmpty(reportId)){%>
	<div id="divTab2"  class="x-hide-display" >
    <iframe frameborder="0" style="width:100%;height:100%;" src="<%=url2%>"></iframe>
</div>
<%}%>
</div>
</body>
</html>
