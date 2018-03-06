<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.util.FileHelper" %>
<%@ page import="com.eweaver.sysinterface.base.*" %>
<%@ page import="com.eweaver.base.IDGernerator" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<html>
  <head>
    <title>代码编辑器窗口</title>   
    
    <link rel="stylesheet" href="/js/codeedit/css/default.css">
    <link rel="stylesheet" href="/js/codeedit/css/docs.css">
    <link rel="stylesheet" href="/js/codeedit/css/codemirror.css">
    <link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css?<%=System.currentTimeMillis() %>" />
    <script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
    <script src="/js/jquery/1.6.2/jquery.min.js"/></script>
  	<script src="/js/jquery/1.6.2/jq.eweaver.js"/></script>
    <script src="/js/codeedit/codemirror.js"></script>
    <script src="/js/codeedit/clike.js"></script>
    <style>
    body{
    	margin-top:0.5em;
    }
    .CodeMirror {border: 1px solid #eee;} 
    .CodeMirror-scroll { height: 100% }
    </style>
    
  </head>
  <body>
  <%
  response.setHeader("cache-control", "no-cache");
  response.setHeader("pragma", "no-cache");
  response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    LabelService labelService = (LabelService)BaseContext.getBean("labelService");
    PagemenuService _pagemenuService =(PagemenuService)BaseContext.getBean("pagemenuService");
    String fileName = StringHelper.null2String(request.getParameter("filename"));//文件名
    String filetype = StringHelper.null2String(request.getParameter("filetype"));//文件类型
    String orginalfile = fileName;
    String fileid = "Ewv";
    String readonly = "";
    boolean isCreate = false;
    if(StringHelper.isEmpty(fileName)) {
    	Date ndate = new Date();
    	SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");
    	String datetime = sf.format(ndate);
    	fileid = fileid + datetime;
    	fileName= fileid + "." + filetype;
    	isCreate = true;
    } else {
        int pointIndex = fileName.indexOf(".");
        if(pointIndex > -1) {
            fileid = fileName.substring(0,pointIndex);
        }
        
    }
    if(!isCreate) {
    	readonly = "readonly";
    }
    String filepath = BaseContext.getRootPath() + "sysinterface/extpage/";
    filepath = filepath + fileName;
    File file = new File(filepath);
    String content = "";
    if(file.exists()) {
    	content = FileHelper.loadFile(filepath);
    } else {
        if(filetype != null && filetype.toLowerCase().endsWith("java")) {
        	content = InterfaceConstants.JAVA_CODE_BASE.replace("{Demo}",fileid);
        } else if(filetype != null && filetype.toLowerCase().endsWith("jsp")) {
        	content = InterfaceConstants.JSP_CODE_BASE.replace("{Demo}",fileid);
        }
    }
    String pagemenustr="";
  %>
  <!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881ea0bfa7679010bfa963f300023")+",javascript:onSave()}";
pagemenustr += "{D,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:onDelete()}";
pagemenustr += "{B,"+labelService.getLabelName("402881eb0bcbfd19010bcc6e71870022")+",javascript:onBack()}";
String pagemenubarstr = _pagemenuService.getPagemenuBarstr(pagemenustr);
//pagemenubarstr += "<font color=red size=1>(请先保存,再确定)</font>";
%>
<div id="pagemenubar" style="z-index:100;">
</div> 
<form name="EweaverForm" method="post" action="" id="EweaverForm">
<span style="font-family:verdana;font-size:12px;color:#333;font-weight:700;" >
文件名:<input type="text" value="<%=fileName%>" name="ew_fileName" id="ew_filename" length="80" <%=readonly %> 
style="font-family:verdana;font-size:10px;color:#333;font-weight:700;height:20px;">
<span id="message"></span>
</span>
<br/>
<input type="hidden"  name="ew_action" id="ew_action">
<input type="hidden"  name="ew_code" id="ew_code">
<input type="hidden"  name="ew_isCreate" id="ew_isCreate" value="<%=isCreate%>">
<textarea id="code" name="code">
<%=content %>
</textarea>
</form> 
    <script>
    var editor ;
    window.onload = function(){
    	editor = CodeMirror.fromTextArea(document.getElementById("code"), {     	
        lineNumbers: true,       
        mode: "text/x-java"
      });  
    }            
    </script>
    <script language="JavaScript">
	window.document.getElementById("pagemenubar").innerHTML = "<%=pagemenubarstr%>";
</script>
<script language="javascript">
var filename = '<%=orginalfile%>';
function onSave(){
		var myMask = new Ext.LoadMask(Ext.getBody(), {
			msg: '正在验证,请稍后...',//正在导入,请稍后...
			removeMask: true //完成后移除
		});
	myMask.show();
	var url = '/ServiceAction/com.eweaver.sysinterface.base.servlet.CodeAction?action=save';
	$('#ew_code').val(editor.getValue());
	//alert($('#ew_code').val());
	saveToUrl('#EweaverForm',url,function(data){		
	    alert(data);	
	    myMask.hide();
	    filename = $("#ew_filename").val();
	});		
}
var isdelete = 0;
function onDelete(){
    if(confirm('确认删除?')){
        isdelete = 1;
    	$("#ew_filename").val('');
    	window.returnValue='-1';
		window.close();
    }
}

function onBack(){
    if(isdelete == 0) {
    	if(filename != '') {
        	window.returnValue=$("#ew_filename").val();	
    	} else {
       		window.returnValue='';	
    	}
		window.close();
    }  
}
//$(window).bind('unload',onBack);
</script>
  </body>
</html>