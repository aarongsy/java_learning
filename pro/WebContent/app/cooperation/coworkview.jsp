<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.base.service.DocbaseService"%>
<%@ page import="com.eweaver.document.base.model.Docbase"%>
<%@ page import="com.eweaver.document.base.model.Docattach"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.model.Categorylink"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.InputStream" %>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService" %>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.cowork.service.CoworksetService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.cowork.model.Coworkset" %>
<%@ page import="com.eweaver.base.SQLMap" %>
<%@ page import="com.eweaver.app.cooperation.*" %>
<%
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
String defaultAvator = "/app/cooperation/images/avator.png";
String currentUserAvator = StringHelper.isEmpty(currentuser.getImgfile()) ? defaultAvator : "/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+currentuser.getImgfile();
/*获取协作区设置信息*/
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
//新建文档的
String targeturlfordoc = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=addrefdoc&docid=";
DataService ds = new DataService();
//获取参数
String requestid = StringHelper.null2String(request.getParameter("id")).trim();
CoWorkService cwService = new CoWorkService();
if(CoworkHelper.IsNullCoworkset()){
	out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置好协作区关联表单信息后再来操作。</h5>");
	return;
}else{
	//协作区--日志--查看
	ds.executeSql("insert into coworklog (id,deliverid,coworkid,operator,operatedate,operatetime,replyid,operatetype,isdelete) values ('"
			+IDGernerator.getUnquieID()+"','','"+requestid+"','"+eweaveruser.getId()+"','"+DateHelper.getCurrentDate()+"','"+DateHelper.getCurrentTime()+"','',3,0)");
}
//是否启用附件大小控件检测
String weatherCheckFileSize=StringHelper.null2String(setitemService0.getSetitem("402881e50b14f840010b14fbae82000b").getItemvalue());
//文档附件大小
String maxFileSize=StringHelper.null2String(setitemService0.getSetitem("402881e50b14f840010b153bbc17000b").getItemvalue());
CoWorkService cwservice = new CoWorkService();
int isclose=NumberHelper.string2Int(ds.getValue("select isclose from COWORKBASE where id='"+requestid+"'"),0);
String stopsql="";
if(SQLMap.DBTYPE_SQLSERVER.equals(SQLMap.getDbtype())){
	stopsql = "SELECT count(*) FROM coworkrule WHERE requestid='"+requestid+"' and datetype=1 and enddate is not null and endtime is not null and enddate+' '+SUBSTRING(endtime,len('0'+endtime)-7,len('0'+endtime)) < CONVERT(varchar, getdate(), 120 ) and isdelete=0 GROUP BY requestid";
}else if(SQLMap.DBTYPE_ORACLE.equals(SQLMap.getDbtype())){
	stopsql = "SELECT count(*) FROM coworkrule WHERE requestid='"+requestid+"' and datetype=1 and enddate is not null and endtime is not null and to_date(enddate||' '|| to_char(to_date(endtime,'HH24:mi:ss'),'HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss') < to_date(to_char(SYSDATE,'yyyy-MM-dd HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss') and isdelete=0 GROUP BY requestid";
}
int isstop=NumberHelper.string2Int(ds.getValue(stopsql),0);

List<Map<String,Object>> rulelist = ds.getValues("select * from COWORKRULE where requestid='"+requestid+"' and isdelete=0");
Map<String,Object> rulemap = new HashMap<String,Object>();
if(rulelist!=null && rulelist.size()>0){
	rulemap = rulelist.get(0);
}
String editmode = "1";
if(StringHelper.isEmpty(editmode))editmode = "0";
int canedit = 0;
String formid=StringHelper.null2String(CoworkHelper.getParams("mainformid"));
String replyformid=StringHelper.null2String(CoworkHelper.getParams("replyformid"));
String replyformname=StringHelper.null2String(CoworkHelper.getParams("replyform"));
String layoutid=StringHelper.null2String(ds.getValue("SELECT showlayoutid FROM COWORKRULE WHERE requestID='"+requestid+"'"));
String formobjname=StringHelper.null2String(CoworkHelper.getParams("mainform"));;
String title =StringHelper.null2String(CoworkHelper.getParams("title"));;
String titleobjname =StringHelper.null2String(CoworkHelper.getParams("titleobjname"));
String subject=StringHelper.null2String(ds.getValue("select "+titleobjname+" from "+formobjname+" where requestid='"+requestid+"'"));
String coworktypefield =StringHelper.null2String(CoworkHelper.getParams("coworktype"));
String coworkremarkid = StringHelper.null2String(CoworkHelper.getParams("coworkremark"));
String coworkremark=StringHelper.null2String(ds.getValue("select "+ds.getValue("SELECT fieldname FROM formfield WHERE ID='"+coworkremarkid+"'")+" from "+formobjname+" where requestid='"+requestid+"'"));
String replyfield=StringHelper.null2String(CoworkHelper.getParams("replyfield"));
String replyfieldname=StringHelper.null2String(CoworkHelper.getParams("replycontent"));
String operatedatefield = StringHelper.null2String(CoworkHelper.getParams("replydate"));
String operatetimefield = StringHelper.null2String(CoworkHelper.getParams("replytime"));
String replyuserfield = StringHelper.null2String(CoworkHelper.getParams("replymembers"));
String replymembersid = StringHelper.null2String(CoworkHelper.getParams("replymembersid"));

//初始化Service类
CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
FormService fs = (FormService) BaseContext.getBean("formService");
FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
FormBaseService fbs = (FormBaseService)BaseContext.getBean("formbaseService");
CategoryService cs = (CategoryService)BaseContext.getBean("categoryService");
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
Map parameters = new HashMap();
String bNewworkflow = "1"; //是否新建表单
String bView="1"; //如果只去显示布局则 String bView="1";
String bWorkflowform="2";
String bviewmode="2"; 
String workflowid=""; 
String nodeid="";
String initparameterstr ="";

Map initparameters = new HashMap();
if("1".equals(editmode)){ // 编辑页面
	bNewworkflow="0";
	initparameters.put("requestid",requestid);
	initparameters.put("editmode",editmode);
	parameters.put("layoutid",layoutid);
	parameters.put("bView",bView);
	parameters.put("bNewworkflow",bNewworkflow);
	parameters.put("bWorkflowform",bWorkflowform);
	parameters.put("initparameters",initparameters); 
	parameters.put("bviewmode",bviewmode);
	parameters.put("requestid",requestid);
	parameters.put("workflowid",workflowid);
	parameters.put("formid",formid);
	parameters.put("nodeid",nodeid);
}else{ //首次打开新建
	parameters.put("bNewworkflow",bNewworkflow);
	parameters.put("bView",bView);
	parameters.put("bWorkflowform",bWorkflowform);
	parameters.put("bviewmode",bviewmode);
	parameters.put("workflowid",workflowid);
	parameters.put("nodeid",nodeid);
	parameters.put("formid",formid);
	parameters.put("layoutid",layoutid);
	parameters.put("initparameters",initparameters);
}
parameters = fs.WorkflowView(parameters);
layoutid = StringHelper.null2String(parameters.get("layoutid"));
String needcheckfields = StringHelper.null2String(parameters.get("needcheck"));
String formcontent = StringHelper.null2String(parameters.get("formcontent"));
String fieldcalscript = StringHelper.null2String(parameters.get("fieldcalscript"));
String onaddrowscript = StringHelper.null2String(parameters.get("onaddrowscript"));
String triggercalscript=StringHelper.null2String(parameters.get("triggercalscript"));
String ufscript=StringHelper.null2String(parameters.get("ufscript"));
String directscript=StringHelper.null2String(parameters.get("directscript"));
String fieldJSFormulas=StringHelper.null2String(parameters.get("fieldJSFormulas"));
String categoryfield="";
if (!StringHelper.isEmpty(formid)) {
    List<Formfield> fields = formfieldService.getAllFieldByFormId(formid);
    for(Formfield field:fields){
        if(field.getFieldname().equalsIgnoreCase("categoryid")){
           categoryfield="field_"+field.getId();
            break;
        }
    }
}
%>
<html>
  <head>
    <title>交流页</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="">
	<meta http-equiv="description" content="">
	<link rel="stylesheet" href="<%= request.getContextPath()%>/css/eweaver.css" type="text/css">
<link  type="text/css" rel="stylesheet" href="/app/cooperation/css/default.css" />
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/dwr/interface/SelectitemService.js'></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/dwr/util.js'></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/ux/ajax.js"></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/js/workflow.js'></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/js/document.js'></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
<LINK media=screen href="<%= request.getContextPath()%>/js/src/widget/templates/HtmlTabSet.css" type="text/css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/tx/jquery.autocomplete.css" />
<script type="text/javascript" language="javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/CKEditorExt.js"></script>
<script language="javascript">
var editor; //格式文本编辑框
var isShowLeftMenu = false;
function levelMouseOver(){
	if(isShowLeftMenu){
		//document.getElementById("LeftHideShow").style.background = "url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj2.png) no-repeat 0 50%";
	}else{
		//document.getElementById("LeftHideShow").style.background = "url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj2_1.png) no-repeat 0 50%";
	}
}
function levelMouseOut(){
	if(isShowLeftMenu){
		//document.getElementById("LeftHideShow").style.background = "url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj1.png) no-repeat 0 50%";
	}else{
		//document.getElementById("LeftHideShow").style.background = "url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj1_1.png) no-repeat 0 50%";
	}
}
function mnToggleleft(){
	with(window.parent.document.getElementById("frameBottom")){
		if(cols == '0,*'){
			cols = '404,*';
			//window.document.getElementById("LeftHideShow").style.background = "url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj1_1.png) no-repeat 0 50%";
			window.document.getElementById("LeftHideShow").title = ''
			isShowLeftMenu = false;
		}else{
			cols = '0,*';
			//window.document.getElementById("LeftHideShow").style.background = "url(<%= request.getContextPath()%>/app/cooperation/images/bg_zj1.png) no-repeat 0 50%";
			window.document.getElementById("LeftHideShow").title = ''
			isShowLeftMenu = true;
		}
	}
}
/**引用协作*/
function insertQuote(replyid){
	 var sel;
	 DWREngine.setAsync(false);//同步     
	 var sql="select <%=replyfieldname%> as content,<%=operatedatefield%> as opdate,<%=operatetimefield%> as optime,<%=replyuserfield%> as opor from <%=replyformname%> where requestid ='"+replyid+"'";
     DataService.getValues(sql,{              
         callback:function(data) {       
            if(data.length >=1){  
              for(var i =0;i<data.length;i++){ 
            	var opdate = data[i].opdate;
            	var optime = data[i].optime;
            	var opor;
            	DWREngine.setAsync(false);//同步
            	DataService.getValues("select objname as objname from humres where id='"+data[i].opor+"'",{              
		         callback:function(d) {
		            	opor=d[0].objname;	
		         }});
		         var htmlStr="<div id=\"\" class=\"replyDivBase\">";
		             htmlStr +="[引用]&nbsp;&nbsp;"+opor+"&nbsp;<span class=\"replyDivBase11\">"+opdate+" "+optime+"</span><br>"+data[i].content+"</div>";
			     var ta ="<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" bgcolor=\"#F5F5F5\">";
                     ta +="<tr bgcolor=\"#F5FAFA\" ><td style=\"width:80%;border-bottom: solid #E6E6E6 1px;border-right: solid #E6E6E6 1px;border-left: solid #E6E6E6 1px;border-top: solid #E6E6E6 1px;\" valign=\"top\" >";
                     ta += htmlStr+"</td></tr></table>";
				editor.html(ta);
	          }
            }
         }
     });
}

 var fckBasePath= '<%= request.getContextPath()%>/app/cooperation/js/fck/';
 var contextPath='<%= request.getContextPath()%>';
 </script>
<style>
.imgdiv{
	display:inline;
}	
.imgdiv .avatar {
    width:30;
    height:30;
	background:#FFF;
	padding:1px;
	border:1px solid #DFE8F6;
	top:0px !important;
	top:0px;
}

.a{float:left; border-width:1px 0; border-color:#D6E0E8; border-style:solid;}
.b{height:20px; border-width:0 1px; border-color:#D6E0E8; border-style:solid; margin:0 -1px; background:#E5ECF2; position:relative; float:left;}
.c{line-height:10px; color:#F6F8F9; background:#F6F8F9; border-bottom:2px solid #eeeeee;}
.d{padding:0 8px 0 5px; line-height:22px; font-size:11px; color:#666; clear:both; margin-top:-10px; cursor:pointer;}
</style>
  </head>
  <body class="bodyCoworkview">
  <input type="hidden" id="weatherCheckFileSize" value="<%=weatherCheckFileSize%>" />
  <input type="hidden" id="maxFileSize" value="<%=maxFileSize%>" />
  <table width="100%" height="100%">
	<tr height="100%" valign="top">
	<td width="22" align="left" style="cursor: hand; background-color:red;background:url(/app/cooperation/images/shadow.jpg);background-repeat:repeat-y;" onclick="mnToggleleft()">
       <div id="LeftHideShow" name="LeftHideShow"  style="CURSOR: hand;height:550;"  class="open open_closed" onmouseover="levelMouseOver()" onmouseout="levelMouseOut()">
       </div>
    </td>
	<td id="oTd2" valign="top">
	    <script type="text/javascript">
	     function changeTR(obj){
	    	 var remark1 = document.getElementById("remark1");
	    	 var remark2 = document.getElementById("remark2");
	    	 var infotable = document.getElementById("infotable");
	    	 if(remark1.style.display=='none'){
	    		 remark1.style.display='block';
	    	 }else{
	    		 remark1.style.display='none';
	    	 }
	    	 if(remark2.style.display=='none'){
	    		 remark2.style.display='block';
	    	 }else{
	    		 remark2.style.display='none';
	    	 }
	    	 if(infotable.style.display=='none'){
	    		 infotable.style.display='block';
	    	 }else{
	    		 infotable.style.display='none';
	    	 }
	    	 var changebtn = document.getElementById("changebtn");
	    	 if(obj=='open'){
	    		 changebtn.innerHTML="<a onclick=\"javascrip:changeTR('close');\">收缩<<</a>";
	    	 }else{
	    		 changebtn.innerHTML="<a onclick=\"javascrip:changeTR('open');\">展开>></a>";
	    	 }
	     }
	     var remarkview = 1;
	     function changRemarkView(){
		     var tr1=document.getElementById("formathtml");
		     var tr2=document.getElementById("unformathtml");
		       if(remarkview == 1){
		          tr1.style.display="none";
		          tr2.style.display="";
		          remarkview = 0;
		       }else{
		          tr1.style.display="";
		          tr2.style.display="none";
		          remarkview = 1;
		       }
	     }
	    </script>
<!-- begin 协作创建信息 -->	    

 <%
 String creatorid = StringHelper.null2String(ds.getValue("select CREATOR from coworkbase where id='"+requestid+"'"));
 String sql1="select BEGINDATE from COWORKRULE where requestid='"+requestid+"'";
 String begindate =StringHelper.null2String(ds.getValue(sql1));
 String enddate="永久有效";
 String sql4 ="select datetype from COWORKRULE where requestid='"+requestid+"'";
 int datetype = NumberHelper.string2Int(ds.getValue(sql4),0);
 if(datetype==1){
	 String sql2="select ENDDATE from COWORKRULE where requestid='"+requestid+"'";
	 enddate=StringHelper.null2String(ds.getValue(sql2));
 }
 String sql3 = "SELECT createdate||' '||createtime FROM  coworkbase where id='"+requestid+"'";
 if(SQLMap.DBTYPE_SQLSERVER.equals(SQLMap.getDbtype())){
	 sql3 = "SELECT createdate+' '+createtime FROM  coworkbase where id='"+requestid+"'";
 }
 String createdate = StringHelper.null2String(ds.getValue(sql3));
 Humres creatorHrm = humresService.getHumresById(creatorid);
 String creator = creatorHrm.getObjname();
 String creatorAvator = StringHelper.isEmpty(creatorHrm.getImgfile()) ? defaultAvator : "/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+creatorHrm.getImgfile();
 String helper="";
 %>
 <div style="font:18px Microsoft YaHei;font-weight:bold;margin:15px 0 10px 0;"><%=subject %></div>
 <table style="width:100%;">
 <tr>
 	<td style="width:40px;"><img src="<%=creatorAvator %>" style="width:32;"/></td>
 	<td style="font:11px Microsoft YaHei;">创建人：<a href="javascript:onUrl('/humres/base/humresinfo.jsp?id=<%=creatorid %>','<%=creator %>','tab<%=creatorid %>')" style="color:blue;"><%=creator %></a>&nbsp;&nbsp;<span style="color:#999;font-size:11px;"><%=createdate %></span>&nbsp;&nbsp;有效期：<span style="color:#999;font-size:11px;"><%=begindate %> / <%=enddate %></span><br/>
  负责人：
   <%
   Map<String,String> userids = cwservice.getCoworkOperator(requestid,"2");
   Set<String> set = userids.keySet();
   int size=1;
   for(String s:set){
	   %>
	   <a href="javascript:onUrl('/humres/base/humresinfo.jsp?id=<%=s %>','<%=userids.get(s) %>','tab<%=s %>')"> <%=userids.get(s) %></a><%=size!=userids.size()?",":""%>
  <% 
  size++;
  }
  %>
  </td>
  <td style="text-align: right;vertical-align:bottom;">
	<button  type="button" class="simple" onclick="javascript:changRemarkView();">
		<img src="/app/cooperation/images/arrowdown.png" style="vertical-align:middle;">
		显示详细
	</button>
  </td>
  </tr>
 </table>
<!-- end 协作标题 -->
<!-- begin 协作描述 -->
<% 
String remarkHTML = "";
if("".equals(coworkremark.trim())){ 
	remarkHTML="无详细内容。";
}else{
	remarkHTML=cwService.Html2Text(coworkremark);
}
%>
<TABLE  border="0" style="display:block;" id="infotable" cellpadding="0" cellspacing="0"  width="100%">
<tr id="formathtml" style="display:;">
<td>
<div class="coworkcontent">
<%=remarkHTML %>
</div>
</td>
</tr>
<tr id="unformathtml" style="display: none;">
<td>
<div class="coworkcontent">
<%=coworkremark %>
</div>
<%=formcontent %>
</td>
</tr>
<tr style="height: 10px;">
<td>
</td>
</tr>
</TABLE>
<!-- end  协作描述 -->
<!-- begin 获取布局 -->
<script type="text/javascript">
	     function changeTable(obj){
	    	 var addinfotable = document.getElementById("addinfotable");
	    	 if(addinfotable.style.display=='none'){
	    		 addinfotable.style.display='block';
	    	 }else{
	    		 addinfotable.style.display='none';
	    	 }
	     }
</script>
<!-- 回复协作的form -->
<%if(!(isstop==1 || isclose==1)){ %>
<form action="/ServiceAction/com.eweaver.app.cooperation.CoworkAction" target="_self" enctype="multipart/form-data"  name="EweaverForm"  id="EweaverForm"  method="post">
<input type="hidden" id="action" name="action" value="replycowork">
<input type="hidden" id="coworkrequestid" name="coworkrequestid" value="<%=requestid %>">
<input type="hidden" id="type" name="type" value="deliver">
<input type="hidden" id="formid" name="formid" value="<%=replyformid %>">
<input type="hidden" id="field_<%=replymembersid%>" name="field_<%=replymembersid%>" value="<%=eweaveruser.getId() %>">
<!-- begin 附加功能 -->
<table>
<tr>
	<td width="62" valign="top"><img src="<%=currentUserAvator%>" style="width:48px;"/></td>
	<td valign="top" align="left">
		<textarea id="field_<%=replyfield %>" name="field_<%=replyfield %>" style="width:100%;height:46px;border:1px solid #CFCFCC;background-color:#f9ffff;overflow:auto;"></textarea>
	</td>
</tr>
</table>
<script type="text/javascript" language="javascript" src="/js/kindeditor/kindeditor-min.js"></script>
<script type="text/javascript" language="javascript" src="/js/kindeditor/lang/zh_CN.js"></script>
<script> 
KindEditor.ready(function(K) {
	editor = K.create('textarea[name="field_<%=replyfield %>"]', {
		themeType: 'e-weaver',
		height: '70px',
		minHeight: 70,
		resizeType : 1,
		uploadJson : '/js/kindeditor/jsp/upload_json.jsp',
	    fileManagerJson : '/js/kindeditor/jsp/file_manager_json.jsp',
		allowPreviewEmoticons : false,
		allowImageUpload : true,
		imageTabIndex:1,
		items : /*[
			'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic', 'underline',
			'removeformat', '|', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist',
			'insertunorderedlist', '|', 'emoticons', 'image', 'link']*/
			['source','undo','redo',
			'|','formatblock','fontname','fontsize','forecolor','hilitecolor','bold','italic','underline','strikethrough','removeformat',
			'|', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist','insertunorderedlist',
            '|','image','table','emoticons','link','|','fullscreen']
	});
});
</script>
<TABLE  border="0" style="display: none;" id="addinfotable" cellpadding="0" cellspacing="0"  width="100%">
<tr style="height:8px;">
<td colspan="2"></td>
</tr>
<tr>
<td width="62" valign="top">&nbsp;</td>
<td>
<%
layoutid = ds.getValue("SELECT showaddlayout FROM COWORKRULE WHERE requestID='"+requestid+"'");
formid = StringHelper.null2String(CoworkHelper.getParams("replyformid"));
editmode="0";
parameters = new HashMap();
bNewworkflow = "1"; //是否新建表单
bView="0";
bWorkflowform="2";
bviewmode="2"; 
workflowid=""; 
nodeid="";
initparameterstr ="";
initparameters = new HashMap();
if("1".equals(editmode)){ // 编辑页面
	bNewworkflow="0";
	initparameters.put("requestid",requestid);
	initparameters.put("editmode",editmode);
	parameters.put("layoutid",layoutid);
	parameters.put("bView",bView);
	parameters.put("bNewworkflow",bNewworkflow);
	parameters.put("bWorkflowform",bWorkflowform);
	parameters.put("initparameters",initparameters); 
	parameters.put("bviewmode",bviewmode);
	parameters.put("requestid",requestid);
	parameters.put("workflowid",workflowid);
	parameters.put("formid",formid);
	parameters.put("nodeid",nodeid);
}else{ //首次打开新建
	parameters.put("bNewworkflow",bNewworkflow);
	parameters.put("bView",bView);
	parameters.put("bWorkflowform",bWorkflowform);
	parameters.put("bviewmode",bviewmode);
	parameters.put("workflowid",workflowid);
	parameters.put("nodeid",nodeid);
	parameters.put("formid",formid);
	parameters.put("layoutid",layoutid);
	parameters.put("initparameters",initparameters);
}
parameters = fs.WorkflowView(parameters);
layoutid = StringHelper.null2String(parameters.get("layoutid"));
needcheckfields = StringHelper.null2String(parameters.get("needcheck"));
formcontent = StringHelper.null2String(parameters.get("formcontent"));
fieldcalscript = StringHelper.null2String(parameters.get("fieldcalscript"));
onaddrowscript = StringHelper.null2String(parameters.get("onaddrowscript"));
triggercalscript=StringHelper.null2String(parameters.get("triggercalscript"));
ufscript=StringHelper.null2String(parameters.get("ufscript"));
directscript=StringHelper.null2String(parameters.get("directscript"));
fieldJSFormulas=StringHelper.null2String(parameters.get("fieldJSFormulas"));
categoryfield="";
if (!StringHelper.isEmpty(formid)) {
    List<Formfield> fields = formfieldService.getAllFieldByFormId(formid);
    for(Formfield field:fields){
        if(field.getFieldname().equalsIgnoreCase("categoryid")){
           categoryfield="field_"+field.getId();
            break;
        }
    }
}
%>
<script>
var fieldJSFormulas = <%=fieldJSFormulas%>;
var needchecklists = "field_<%=replyfield %>,<%=needcheckfields%>";
var id = "<%=StringHelper.null2String(CoworkHelper.getCoworkset().getId())%>";
var workflowid = "<%=StringHelper.null2String(workflowid)%>";
var nodeid = "<%=StringHelper.null2String(nodeid)%>";
</script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script><!-- 之前的jquery不支持属性*= -->
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/aop.pack.js"></script>    
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css" />
<script type="text/javascript" language="javascript" src="/js/jquery/plugins/uploadify/jquery.uploadify-3.1.min.js"></script>
<style type="text/css" >
    .x-panel-btns-ct {
          padding: 0px;
      }
</style>
<script type="text/javascript">
    var jq = jQuery.noConflict();
    var win;
	function getrefobj(inputname, inputspan, refid, param, viewurl, isneed){
	    //if (document.getElementById(inputname.replace("field", "input")) != null) {
	    //    document.getElementById(inputname.replace("field", "input")).value = "";
	   // }
	    var fck = param.indexOf("function:");
	    if (fck > -1) {
	    }
	    else {
	        var param = parserRefParam(inputname, param);
	    }
	    var idsin = document.all(inputname).value;
	    var url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
	    if (idsin.length > 900) { //当idsin过长时，ie的url不支持过长的地址
	        url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param;
	    }
	    var id;
	    /*
	     * 因为岗位的Browser框页面代码结构不支持使用ext窗口打开并取值的情况，故在safari浏览器的环境下使用模态对话框打开岗位browser
	     * safari浏览器也可以很好的支持模态对话框,以下其他类别的Browser框类同
	     */
	    var isStationBrowserInSafari = jQuery.browser.safari && (refid == '402881e510efab3d0110efba0e820008' || refid == '40288041120a675e01120a7ce31a0019');
	    //流程单选 || 工作流程单选 || 工作流程多选
		var isWorkflowBrowserInSafari = jQuery.browser.safari && (refid == '402881980cf7781e010cf8060910009b' || refid == '402880371d60e90c011d6107be5c0008' || refid == '40288032239dd0ca0123a2273d270006');	
		//员工多选
		var isHumresBrowserInSafari = jQuery.browser.safari && refid == '402881eb0bd30911010bd321d8600015';	
		if(!Ext.isSafari){
	        try {
	            // id=openDialog(url,idsin);
	            id = window.showModalDialog(url, idsin, 'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
	        } 
	        catch (e) {
	            return
	        }
	        if (id != null) {
	            if (id[0] != '0') {
	                document.all(inputname).value = id[0];
	                document.all(inputspan).innerHTML = id[1];
	                if (fck > -1) {
	                    funcname = param.substring(9);
	                    scripts = "valid=" + funcname + "('" + id[0] + "');";
	                    eval(scripts);
	                    if (!valid) { //valid默认的返回true;
	                        document.all(inputname).value = '';
	                        if (isneed == '0') 
	                            document.all(inputspan).innerHTML = '';
	                        else 
	                            document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                    }
	                }
	            }
	            else {
	                document.all(inputname).value = '';
	                if (isneed == '0') 
	                    document.all(inputspan).innerHTML = '';
	                else 
	                    document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                
	            }
	        }
	    }
	    else {
	      url = '/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
	         id=onPopup(url);
	          if (id != null) {
	                if (id[0] != '0') {
	                    document.all(inputname).value = id[0];
	                    WeaverUtil.fire(document.all(inputname));
	                    document.all(inputspan).innerHTML = id[1];
	                    if (fck > -1) {
	                        funcname = param.substring(9);
	                        scripts = "valid=" + funcname + "('" + id[0] + "');";
	                        eval(scripts);
	                        if (!valid) { //valid默认的返回true;
	                            document.all(inputname).value = '';
	                            if (isneed == '0') 
	                                document.all(inputspan).innerHTML = '';
	                            else 
	                                document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                        }
	                    }
	                }
	                else {
	                    document.all(inputname).value = '';
	                    if (isneed == '0') 
	                        document.all(inputspan).innerHTML = '';
	                    else 
	                        document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                    
	                }
	            }
	         /*
	      
	        var callback = function(){
	            try {
	                id = dialog.getFrameWindow().dialogValue;
	            } 
	            catch (e) {
	            }
	            if (id != null) {
	                if (id[0] != '0') {
	                    document.all(inputname).value = id[0];
	                    WeaverUtil.fire(document.all(inputname));
	                    document.all(inputspan).innerHTML = id[1];
	                    if (fck > -1) {
	                        funcname = param.substring(9);
	                        scripts = "valid=" + funcname + "('" + id[0] + "');";
	                        eval(scripts);
	                        if (!valid) { //valid默认的返回true;
	                            document.all(inputname).value = '';
	                            if (isneed == '0') 
	                                document.all(inputspan).innerHTML = '';
	                            else 
	                                document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                        }
	                    }
	                }
	                else {
	                    document.all(inputname).value = '';
	                    if (isneed == '0') 
	                        document.all(inputspan).innerHTML = '';
	                    else 
	                        document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                    
	                }
	            }
	        }
		    var winHeight = Ext.getBody().getHeight() * 0.9;
		    var winWidth = Ext.getBody().getWidth() * 0.9;
		    if(winHeight>500){//最大高度500
		    	winHeight = 500;
		    }
		    if(winWidth>880){//最大宽度800
		    	winWidth = 880;
		    }
	        if (!win) {
	            win = new Ext.Window({
	                layout: 'border',
	                width:winWidth,
	                height:winHeight,
	                plain: true,
	                modal: true,
	                items: {
	                    id: 'dialog',
	                    region: 'center',
	                    iconCls: 'portalIcon',
	                    xtype: 'iframepanel',
	                    frameConfig: {
	                        autoCreate: {
	                            id: 'portal',
	                            name: 'portal',
	                            frameborder: 0
	                        },
	                        eventsFollowFrameLinks: false
	                    },
	                    closable: false,
	                    autoScroll: true
	                }
	            });
	        }
	        win.close = function(){
	            this.hide();
	            win.getComponent('dialog').setSrc('about:blank');
	            callback();
	        }
	        win.render(Ext.getBody());
	        var dialog = win.getComponent('dialog');
	        dialog.setSrc(url);
	        win.show();*/
	    }
	}
    function  newrefobj(inputname,inputspan,doctype,viewurl,isneed,docdir){
        params = ""
        targeturl = "<%=URLEncoder.encode(targeturlfordoc, "UTF-8")%>"
        var url = "/base/popupmain.jsp?url=/document/base/docbasecreate.jsp?categoryid="+docdir+"&doctypeid="+doctype+params+"&targetUrl="+targeturl;
        var id;
        try{
            id = openDialog(url);

        }catch(e){return}
          if (id!=null) {

    if (id[0] != '0') {

		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
    }
    function onEdit(){
    	document.location.href="/app/cooperation/createcowork.jsp?requestid=<%=requestid%>&editmode=1&isedit=1";
    }
    
    function onSave2(){
       var id = document.getElementById('id2').value;
	   var orgid=document.getElementById('orgid2').value;
	   var creator=document.getElementById('creator2').value;
	   var createdate=document.getElementById('createdate2').value;
	   var createtime=document.getElementById('createtime2').value;
	   var coworklevel="";
		  var radio=document.getElementsByName("coworklevel2");
		  for(var i=0;i<radio.length;i++){
			if(radio[i].checked==true){
			  coworklevel=radio[i].value;
			  break;
			}
		  }
	   var begindate=document.getElementById('begindate2').value;
	   var begintime=document.getElementById('begintime2').value;
	   var datetype=document.getElementById('datetype2').value;
	   var enddate=document.getElementById('enddate2').value;
	   var endtime=document.getElementById('endtime2').value;
	   var isshowunread=document.getElementById('isshowunread2').value;
	   var isreply=document.getElementById('isreply2').value;
	   var isshowreply=document.getElementById('isshowreply2').value;
	   var isquote=document.getElementById('isquote2').value;
	   var isshowadd=document.getElementById('isshowadd2').value;
	   var viewtype=document.getElementById('viewtype2').value;
	   var showlayoutid=document.getElementById('showlayoutid2').value;
	   var showaddlayout=document.getElementById('showaddlayout2').value;
	   if(begindate=='' || begintime=='' || enddate=='' || endtime=='' ){
	     pop('<%=labelService.getLabelNameByKeyId("402881e40aae0af9010aaeb4b38d0002")%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000d")%>',null,'cancel')//必填项不能为空
	       return;
	   }
	   Ext.Ajax.request({
	       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=saverule',
	       params:{id:id,requestid:'<%=requestid%>',orgid:orgid,creator:creator,createdate:createdate,createtime:createtime,coworklevel:coworklevel,begindate:begindate,begintime:begintime,datetype:datetype,enddate:enddate,endtime:endtime,isshowunread:isshowunread,isreply:isreply,isshowreply:isshowreply,isquote:isquote,isshowadd:isshowadd,viewtype:viewtype,showlayoutid:showlayoutid,showaddlayout:showaddlayout},
	       sync:true,
	       success: function() {
	           pop( '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460007")%>');//设置成功！
	       }
	   });
    }
    
    function checkEmpty(obj,spanstr){
	var value = obj.value;
	if(value && value!=''){
		document.getElementById(spanstr).innerHTML="";
	}else{
		document.getElementById(spanstr).innerHTML="<img src='<%=request.getContextPath()%>/images/base/checkinput.gif'>";
	}
    }
</script>
<%=formcontent %>
</td>
</tr>
</TABLE>
<!-- end 获取布局 -->
<div style="text-align: right;">
	<button  type="button" class="simple" onclick="javascript:changeTable('open');">
		<img src="/app/cooperation/images/arrowdown.png" style="vertical-align:middle;">
		附加功能
	</button>
	<button type="button" style="height:24px;width:90px;margin-top:5px;CURSOR: hand;" onclick="javascript:onSubmit(2);">
		<img src="/images/silk/comments_add.gif" style="vertical-align:middle;">
		发表评论
	</button>
</div>
<!-- end 附加功能 -->
</form>
<%} %>
<!-- begin交流主内容 -->
<table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
<tr>
<td>
<iframe width="100%" height="auto" BORDER="0" FRAMEBORDER="0" noresize="noresize" src="<%= request.getContextPath()%>/app/cooperation/reply/replymain.jsp?requestid=<%=requestid %>" name="replyframe1" id="replyframe1" scrolling="no">
</iframe>
</td>
</tr>
</table>
<!-- end 交流主内容 -->
</td>
</tr>
</table>
  </body>
</html>
<%if(!(isstop==1 || isclose==1)){ %>
<!--<script type="text/javascript" language="javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
此应用覆盖了 src="/js/jquery/plugins/uploadify/jquery.uploadify-3.1.min.js 的应用 -->
<SCRIPT type="text/javascript" language="javascript">
  var tableformatted = false; 
  var inputid;
  var spanid;
  var temp;
[].indexOf || (Array.prototype.indexOf = function(v){
	for(var i = this.length; i-- && this[i] !== v;);
	return i;
});

jq(document).ready(function($){
    <%=ufscript%>
    <%=directscript%>
   $.Autocompleter.Selection = function(field, start, end) {
         var flag;
       if(Ext.isIE){
         flag= field.createTextRange; //在firefox下span不显示 原因是因为  firefox不支持createTextRange 
       }else{
         flag=true;
       }
       if(flag){
           if (Ext.isIE) { 
               var selRange = field.createTextRange();
               selRange.collapse(true);
               selRange.moveStart("character", start);
               selRange.moveEnd("character", end);
               selRange.select();
           }
        if(inputid==undefined||spanid==undefined)
           return;
         var len=field.value.indexOf("  ");
           var lenspance=field.value.indexOf(" ");
             if(temp==0&&len>0){
             temp=1;
         var  length=field.value.length;
           var data=field.value;
        document.getElementById(inputid).value=field.value.substring(0,field.value.indexOf("  "));
       document.getElementById('field'+spanid+'span').innerHTML= data.substring(len,length);
         }else if(temp==0&&lenspance>0){

           var data=field.value;
        document.getElementById(inputid).value=data;
       document.getElementById('field'+spanid+'span').innerHTML= data;
             }else
             {
               document.getElementById(inputid).value="";

             }
 } else if( field.setSelectionRange ){
        field.setSelectionRange(start, end);
	} else {
           if( field.selectionStart ){
			field.selectionStart = start;
			field.selectionEnd = end;
		}
	}
	field.focus();
};
});

	var strSQLs = new Array();
	var strValues = new Array();
   <%=triggercalscript%>
 function checkUnique(obj,param,isonly,fieldname,tablename){
    if(obj.value.trim()=='')
    return;
     if(isonly==1||param=="")
     {
        param="select "+fieldname+" from "+tablename+" where "+fieldname+" = ? and requestid in (select id from formbase where isdelete=0)";
     }
    param=param.replace("?","'"+obj.value.ReplaceAll("'","''")+"'");
   if(SQL(param)!=''){
      alert('<%=labelService.getLabelNameByKeyId("402883d934c119410134c11941a20000") %>') ;//数据已存在,请重新输入！
      obj.value='';
      obj.focus();
   }

  }
  function checkdirect(obj)
  {
      inputid=obj.id;
      spanid=obj.name;
      temp=0;
  }
  function SQL(param){
				param = encode(param);

				if(strSQLs.indexOf(param)!=-1){
					var retval = getValidStr(strValues[strSQLs.indexOf(param)]);
					return retval;

				}else{
                    var _url= "/ServiceAction/com.eweaver.base.DataAction?sql="+param;
                    var retval;
                    Ext.Ajax.request({
                        url:_url,
                        sync:true,                        
                        success: function(res) {
                                  var doc=res.responseXML;
                                  var root = doc.documentElement;
                            retval = getValidStr(root.text);
                            strSQLs.push(param);
                            strValues.push(retval);
                        }
                    });
					return retval;
				}             
			}
function onCal(){
	try{
		var rowindex = 0;
		<%=fieldcalscript%>
		function SUM(param){
			var result = 0;
			for(index=0;index<rowindex;index++){
				tmpval = 0;
				try{
					tmpval = eval(param)*1;
				}catch(e){
					tmpval = 0;
				}
				result += tmpval;
			}
			rowindex = 0;
			return result;
		}
		function RMB(param){
			var tmpval = eval(param)*1;
			var result =  convertCurrency(tmpval);
			return result;
		}
		function COUNT(param){
			var result = 0;
			for(index=0;index<rowindex;index++){
				tmpval = 0;
				try{
					tmpval = eval(param)*1;
				}catch(e){
					tmpval = 0;
				}
				if(tmpval != 0)
					result ++;
			}
			rowindex = 0;
			return result;
		}
		function PROD(param){
			var result = 1;
			for(index=0;index<rowindex;index++){
				tmpval = 1;
				try{
					tmpval = eval(param)*1;
				}catch(e){
					tmpval = 1;
				}
				result = result * tmpval;
			}
			rowindex = 0;
			return result;
		}
		function MAX(param, thisindex){
			this.tempIndex = index;//用于进这个函数志强的index值
			var result = 0;
			for(index=0;index<thisindex;index++){
				tmpval = 0;
				try{
					tmpval = eval(param)*1;
				}catch(e){
					tmpval = 0;
				}
				if(tmpval > result)
					result = tmpval;
			}
			index = this.tempIndex;//还原在被此函数用了的index值
			return result;
		}
	}catch(e){
	}
}
function onAddRow(){
	onCal();
	try{
		<%=onaddrowscript%>
		for(var i = 0; i < fieldJSFormulas.length; i++){
			var f = fieldJSFormulas[i];
			if(f.isDetailField){
				bindJsCodeToField(f.fieldid, f.code, f.eventMode, false, f.htmltype, f.fieldtype, f.isDetailField);
			}
		}
	}catch(e){}
}

      function formatTable(t) {
          if (t.innerHTML.indexOf('oTable') < 0)
              return;
          var datarow ;
          for (i = 0; i < t.rows.length; i++) {
              tablerow = t.rows[i];
              if (tablerow.cells[0] && tablerow.cells[0].firstChild && tablerow.cells[0].firstChild.id && tablerow.cells[0].firstChild.id.indexOf('oTable') == 0) {
                  datarow = t.rows[i];
              }
          }
          if (datarow == null)
              return;
          var rowheight = new Array();
          tablecount = datarow.cells.length;
          rowcount = datarow.cells[0].firstChild.rows.length;
          equalrowcount=0;
          if (rowcount > 10)
              caldelay = 10000;
          for (i = 0; i < rowcount; i++) {
              equalcount = 0;
              for (j = 0; j < tablecount; j++) {
                  otable = datarow.cells[j].firstChild;
                  orows = otable.rows;
                  if (j > 0 && orows[i].clientHeight == datarow.cells[j - 1].firstChild.rows[i].clientHeight)
                      equalcount++
                  if (!rowheight[i])
                      rowheight[i] = orows[i].clientHeight;
                  else if (rowheight[i] < orows[i].clientHeight)
                      rowheight[i] = orows[i].clientHeight;
              }
              if (equalcount == tablecount - 1){
                  equalrowcount++;
              }
          }
          if(equalrowcount==rowcount)
            return;
          for (i = 0; i < datarow.cells.length; i++) {
              otable = datarow.cells[i].firstChild;
              orows = otable.rows;
              for (j = 0; j < orows.length; j++) {
                  orows[j].cells[0].style.height = rowheight[j];
              }
          }
      }
onAddRow();
var task=new Ext.util.DelayedTask(onCal);
</script>
<SCRIPT FOR = document EVENT = onselectionchange>
var caldelay=200;
task.delay(caldelay,null,this);
</SCRIPT>
<script language="javascript">

    //*************************简易Javascript Map(start)*************************//
    var objectKey = new Array(100);
    var objectValue = new Array(100);
    var timevalue = "";
    function getMapValue(key){
        for(var i=0;i<objectKey.length;i++){
            if(objectKey[i]==key){
                timevalue = objectValue[i];
            }
        }
    }
    //*************************简易Javascript Map(end)*************************//

    //*************************页面加载后将$currenttime$字段的值放置在MAP中保存起来(start)*************************//
	<%
	List list = formlayoutService.findFormlayoutfieldByLayoutid(layoutid);
	Map map = new HashMap();
	for (int i = 0; i < list.size(); i++) {
		Formlayoutfield formlayoutfield = (Formlayoutfield) list.get(i);
		if("$currenttime$".equals(formlayoutfield.getFormula()==null?"":formlayoutfield.getFormula().trim())){
    %>
        if(document.all("field_<%=formlayoutfield.getFieldname()%>")!=null){
            objectKey[<%=i%>]="field_<%=formlayoutfield.getFieldname()%>";
            objectValue[<%=i%>]=document.all("field_<%=formlayoutfield.getFieldname()%>").value;
        }else{
            var i=0;
            while(document.all("field_<%=formlayoutfield.getFieldname()%>_"+i)!=null){
                objectKey[<%=i++%>]="field_<%=formlayoutfield.getFieldname()%>_"+i;
                objectValue[<%=i++%>]=document.all("field_<%=formlayoutfield.getFieldname()%>_"+i).value;
                i++;
            }
        }
    <%
        }
	}%>
//*************************页面加载后将$currenttime$字段的值放置在MAP中保存起来(end)*************************//
function onDelete(link){
	delmessage="<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>";
	if(confirm(delmessage)){
		document.all("action").value="deleteformbase";
		document.all("targetUrl").value=link;
		document.EweaverForm.submit();
	}
}
function onSubmit(issave){
	editor.sync();
	//needchecklists = "<%=needcheckfields%>";
		if(typeof(onSubmitBefore)=='function'){
			
		try{
			var submitBefore = onSubmitBefore(issave);
			if(!submitBefore) return;
		}catch(e){alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0055") %>'+e.description);return;}//执行提交前事件函数onSubmitBefore时异常:
	}
  checkfields="requestname,"+needchecklists;//填写必须输入的input name，逗号分隔
  checkmessage="发表内容不能为空！";
	onCal();
	if(typeof(onSubmitBefore)=='function'){
		try{
			var submitBefore = onSubmitBefore(issave);

		if(!submitBefore) return;
		}catch(e){alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0055") %>'+e.description);return;}//执行提交前事件函数onSubmitBefore时异常:
	}

  var needcheck = 0;
  if(issave == 0){

  }else
   		needcheck = 1;

  if(needcheck == 1){
	  if(checkForm(EweaverForm,checkfields,checkmessage)){
	  		/*if(issave == 1)
  				document.all("issave").value = "1";
	  		if(issave == 3)
  				document.all("isundo").value = "1";
	  		*/
            <%if(!StringHelper.isEmpty(categoryfield)){%>
          if(document.getElementById('<%=categoryfield%>'))
            document.getElementById('categoryid').value=document.getElementById('<%=categoryfield%>').value;
            <%}%>

 //*************************提交之前将用户没有修改的当前时间字段标识一下,交给后台更新(start)**************************//
    for(var num=0;num<objectKey.length;num++){
        if(objectKey[num]!=""&&objectKey[num]!=null){
            getMapValue(objectKey[num]);
            if(timevalue==document.all(objectKey[num]).value){
                document.all(objectKey[num]).value="$currenttime$";
            }
        }
    }
    //*************************提交之前将用户没有修改的当前时间字段标识一下,交给后台更新(end)**************************//
               document.EweaverForm.submit();
	  }
  }
  //document.all("isreject").value = "0";
}
 function onSubmitNew(issave)
 {
	if(typeof(onSubmitBefore)=='function'){	
		try{
			var submitBefore = onSubmitBefore(issave);
			if(!submitBefore) return;
		}catch(e){alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0055") %>'+e.description);return;}//执行提交前事件函数onSubmitBefore时异常:
	}
	//needchecklists = "<%=needcheckfields%>";
  checkfields="requestname,"+needchecklists;//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空
  document.all('subnew').value='createnew';

	onCal();

  var needcheck = 0;
  if(issave == 0){

  }else
   		needcheck = 1;

  if(needcheck == 1){
	  if(checkForm(EweaverForm,checkfields,checkmessage)){
	  		/*if(issave == 1)
  				document.all("issave").value = "1";
	  		if(issave == 3)
  				document.all("isundo").value = "1";
	  		*/
            <%if(!StringHelper.isEmpty(categoryfield)){%>
          if(document.getElementById('<%=categoryfield%>'))
            document.getElementById('categoryid').value=document.getElementById('<%=categoryfield%>').value;
            <%}%>
	   		document.EweaverForm.submit();
	  }
  }
 }
function doAction(requestid,customid){
       Ext.Ajax.request({
                   url: '/ServiceAction/com.eweaver.workflow.form.servlet.FormbaseAction?action=doaction',
                   params:{requestid:requestid,customid:customid},
                   sync:true,
                   success: function(res) {
                       if(res.responseText == 'noright')
                       {
                            Ext.Msg.buttonText={ok:'<%=labelService.getLabelName("确定")%>'};
                         Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0056") %>') ;//编辑权限的人才可以变更卡片数据！
                       }else{
                            Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934c11ccb0134c11ccbb80000") %>',function(){//变更卡片数据成功！
                              window.location.href='/workflow/request/formbase.jsp?requestid='+requestid;
                           });

                       }
                   }
               });
}

function checkFileSize(filepath,maxSize){
    var size=getFileSize(filepath);
    if(size>maxSize)return false;
    return true;
}
    
function getFileSize(filepath){
	if(filepath==''){
		return null;
	}
	try{
		filecheck.FilePath=filepath;
		var size=filecheck.getFileSize()/(1024*1024);
	    return size;
	}
	catch(e){
		alert(e);
		return null;
	}
	return null;
}

    function importDetail(requestid,categoryid,layoutid){
          this.daliog1.getComponent('dlgpanel').setSrc('<%= request.getContextPath()%>/workflow/form/exportdrecordbyexcel.jsp?requestid='+requestid+'&categoryid='+categoryid+'&layoutid='+layoutid);
          this.daliog1.show();
    }
    
    function printcategory(requestid,categoryid){
    	onUrl('/workflow/request/formbaseprintpre.jsp?requestid='+requestid+'&categoryid='+categoryid,'打印','tab402881eb0bcd354e010bcdc91c700028');
    }
    
    function loadView(vid,cid,_params,_callback){
        if(Ext.isEmpty(_params))_params='';
        $(cid).style.height="50px";
        $(cid).style.width="100%";
        var myMask = new Ext.LoadMask($(cid), {msg:"<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0057") %>",removeMask:true});//请稍等,数据加载中...
        var ofg={
            url: contextPath+'/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerAction?action=partview',
            method:'POST',
            timeout:180000,//三分钟
            success:function(resp,opt){
                myMask.hide();
                var ret=resp.getResponseHeader.ret;
                if(parseInt(ret)<0){
                    opt.failure(resp,opt);
                }else{
                    $(cid).innerHTML=resp.responseText;
                    if(typeof(_callback)=='function')_callback();
                }
            },
            failure:function(resp,opt){
                myMask.hide();
                alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0058") %>{'+vid+'}<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0059") %>:'+resp);//视图模板     加载错误
                $(cid).innerHTML='<pre>'+resp.responseText+'</pre>';
            },
            //headers:{ 'my-header': 'foo'}
            params:{id:vid,where:_params}
        };
        myMask.show();
        Ext.Ajax.request(ofg);
    }//end fun.
    //---------------------
    function addrowbyexcel(id) {

	var ids=window.showModalDialog(contextPath+'/base/popupmain.jsp?url='+contextPath+'/document/file/fileuploadbrowser.jsp?mode=1');
	if(!ids) {
		return;
	}
	var docid = ids[0];
	var myMask = new Ext.LoadMask(Ext.getBody(), {
			msg: '<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005a") %>',//正在导入,请稍后...
			removeMask: true //完成后移除
		});
	myMask.show();
	Ext.Ajax.request({    
		   url : contextPath+'/ServiceAction/com.eweaver.workflow.request.servlet.XlsFormAction',    
		   //params :参数列表    
		   timeout:300000,
		   sync:true,
		   params : {    
				 //取得所选第一行中id列的值    
				  docid:docid,
				  formid:id    
			},    
			//success:响应成功后的回调函数    
		   success : function(response) {    
				// 解码JSON格式数据为一个对象.返回的数据为json数据.{id:'1'}  
				 myMask.hide();
				// alert('0');
				if(response.responseText == '') {
					alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005b") %>');//文件内容为空,请选择正确的文件
					return;
				}
				var respText = eval(response.responseText);   
				//alert(response.responseText);
				var j = 0;
				var l = (respText.length);
				if(l > 0) {
					 var el = document.getElementsByTagName('input');       
					 var len = el.length;     
					  
					 for(var i=0; i<len; i++) {               
						if((el[i].type=='checkbox') && (el[i].name=='check_node_'+id)) {      
							el[i].checked = true;       
							maxIndex = el[i].value;    
						}       
					 }      
					 delrow(id);     	 
				}
				//alert(response.responseText);
				for(var one = 0; one < l; one++) { 
					//maxIndex = one;
					//alert(respText[one].length);
					var ll = respText[one].length;
					addrow(id); 
					maxIndex++;
					for(var key = 0;key < ll;key ++)  {
						if(respText[one][key]) {
							var cellid = respText[one][key].id;
							var obj = Ext.getDom('field_'+cellid+'_'+maxIndex); 
							var objspan = Ext.getDom('field_'+cellid+'_'+maxIndex+'span'); 
							if(objspan && obj.type == 'hidden') { 
								objspan.innerHTML = respText[one][key].value; 	
								obj.value=respText[one][key].value;	
								var btn = Ext.getDom('button_'+cellid+'_'+maxIndex);
								if(btn){
									getrefobjview(obj,objspan,btn);
								}									
							}
							//alert(obj.type);
							if(obj && obj.type == 'text'){ 
								obj.value=respText[one][key].value;
							}

							if(obj && obj.tagName == 'SELECT'){
								DWREngine.setAsync(false);
								obj.value=respText[one][key].value;
								obj.fireEvent('onchange');
								DWREngine.setAsync(true);
							}
							if(obj && obj.type == 'checkbox'){ 
								obj.value=respText[one][key].value;
								if(obj.value == '1') {
									obj.checked=true;
								} else {
									obj.checked=false;
								}
							}  
							 if(obj && obj.tagName == 'TEXTAREA'){ 
									obj.innerText=respText[one][key].value;										
							}
						}
				}  
					
				}
				 //alert('1');
			},    
	   //failure:处理当http返回是404或500的错误,不是业务错误       
		   failure : function(response) {    
					   Ext.Msg.alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005c") %>');//错误, 无法访问后台
					myMask.hide();
		   }    
	})   
}

    function getrefobjview(obj,objspan,btn){
    	//对browser显示进行处理---start--- 	
			DWREngine.setAsync(false);
			var start = btn.onclick.toString().indexOf(objspan.id)+objspan.id.length+3;
			var refobjid = btn.onclick.toString().substring(start,start+32);
			if(refobjid){
				var sql = "";
				var browservalues = obj.value.split(",");
				var sql = "select reftable,keyfield,viewfield from refobj where ID='"+refobjid+"'";
				var reftable = "";
				var keyfield = "";
				var viewfield = "";
				 DataService.getValues(sql,{                                               
			          callback: function(data){   
			              if(data && data.length>0){ 
			            	  reftable = data[0].reftable;
			            	  keyfield = data[0].keyfield;
			            	  viewfield = data[0].viewfield;
			              } 
			          }                 
			      }); 
			      var showtext = "";
				for(var i=0;i<browservalues.length;i++){
			      if(browservalues[i].length==32){
						sql =  "select "+viewfield+" from "+reftable+" where "+keyfield+"= '"+browservalues[i]+"'";
						DataService.getValue(sql,function(value){
							if(showtext==""){
								showtext=value;
							}else{
								showtext=showtext+","+value;
							}
						});
					}
			      }
				objspan.innerHTML=showtext;
			}
			DWREngine.setAsync(true);
	//对browser显示进行处理---end---
    }
    //---------------------
     function impmaintablebyexcel(id) {
		var ids=openDialog('/base/popupmain.jsp?url=/document/file/fileuploadbrowser.jsp?mode=1');
		if(!ids) {
			return;
		}
		var docid = ids[0];
		var myMask = new Ext.LoadMask(Ext.getBody(), {
                        msg: '<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005a") %>',//正在导入,请稍后...
                        removeMask: true //完成后移除
                    });
                myMask.show();
         Ext.Ajax.request({    
                   url : '/ServiceAction/com.eweaver.workflow.request.servlet.XlsFormAction?action=impmaintable',    
                   //params :参数列表    
                   params : {    
                         //取得所选第一行中id列的值    
                          docid:docid,
                          formid:id    
                    },    
                    //success:响应成功后的回调函数    
                   success : function(response) {    
                        // 解码JSON格式数据为一个对象.返回的数据为json数据.{id:'1'}  
                         myMask.hide();
                        if(response.responseText == '') {
							alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005b") %>');//文件内容为空,请选择正确的文件
							return;
						}
                        var respText = eval(response.responseText);   
						var j = 0;
						var l = (respText.length);
                        for(var one = 0; one < l; one++) { 
							var ll = respText[one].length;
							//alert(ll);
	                        for(var key = 0;key < ll;key ++)  {
	                        	if(respText[one][key]) {
	                        		var cellid = respText[one][key].id;
	                        		var obj = Ext.getDom('field_'+cellid); 
	                        		var objspan = Ext.getDom('field_'+cellid+'span'); 
	                        	
									if(objspan && obj.type == 'hidden') { 
										objspan.innerHTML = respText[one][key].value; 	
										obj.value=respText[one][key].value;
										var btn = Ext.getDom('button_'+cellid);
										if(btn){
											getrefobjview(obj,objspan,btn);
										}		
																			
									} else if(obj && (obj.type == 'text' || obj.tagName == 'SELECT' )){ 
										obj.value=respText[one][key].value;
										if(obj.tagName == 'SELECT'){
											DWREngine.setAsync(false);
											obj.fireEvent('onchange');
											DWREngine.setAsync(true);
										}
									} else if(obj && obj.type == 'checkbox'){ 
										obj.value=respText[one][key].value;
										if(obj.value == '1') {
											obj.checked=true;
										} else {
											obj.checked=false;
										}
									} else if(obj && obj.tagName == 'TEXTAREA'){ 
										obj.innerText=respText[one][key].value;										
									}
									
	                        	}
                        	}  
						}
						alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005d") %>');//导入完毕！
                    },    
                    failure : function(response) {   
                                myMask.hide(); 
                                Ext.Msg.alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005c") %>");//错误, 无法访问后台    
                    }    
		})   
    }
     function selectAll (obj,formid) {
	     var objname = "check_node_"+formid;
	     var checks = document.getElementsByName(objname);
	     for(var i = 0 ; i < checks.length ; i ++) {
	     	checks[i].checked = obj.checked;
	     }
     } 
function ifAllowUpload(element) {
  //****************************判断文件是否符合上传格式 start***********************************//
    <%
         Properties mapping = new Properties();
         InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("im.properties");
         try {
             mapping.load(inputStream);
         } catch (Exception e) {
             //log.error(e);
         }
         Enumeration keys = mapping.keys();
         String fileUploadType = "";
         while (keys.hasMoreElements()) {
            String col = (String) keys.nextElement();
            if (col.indexOf("fileUploadType") > -1)
            	fileUploadType = mapping.getProperty(col);
         }
    %>
    if (element != null && element.value != "") {
       var suffix = element.value.substring(element.value.lastIndexOf(".")+1);
       if ("<%=fileUploadType%>".indexOf(suffix) != -1) {
           alert("附件上传格式不正确！");
           return false;
       }
    }
   /** var filearr = document.getElementsByTagName("input");
    for (var f=0;f<filearr.length;f++) {
        if(filearr[f].type=="file") {
            if (filearr[f].value != "" && typeof(filearr[f].value) != "undefined") {
                var suffix = filearr[f].value.substring(filearr[f].value.lastIndexOf(".")+1);
            	if ("<%=fileUploadType%>".indexOf(suffix) != -1) {
                    alert("附件上传格式不正确！");
                    return false;
                }
            }
        }
    }**/
    return true;
    //****************************判断文件是否符合上传格式 end***********************************//
}
</script>
<script type="text/javascript" src="/js/bindJSToFormfield.js"></script>
<%}%>