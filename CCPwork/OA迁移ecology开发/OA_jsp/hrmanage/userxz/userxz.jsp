<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.base.sequence.SequenceService" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%
	Humres currentHumres = BaseContext.getRemoteUser().getHumres();
	String humreid=BaseContext.getRemoteUser().getId();
	String humreno=currentHumres.getObjno();
	String extrefobjfield5=currentHumres.getExtrefobjfield5();
%>

<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css" />
<link rel="stylesheet" type="text/css" id="global_css" href="/css/skins/skin1/global.css?1422582615223"/> 
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/xtheme-gray.css"/>
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
<style type="text/css"> 


tr.tr1{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.title{ 
	font-size:12px; 
	font-weight:bold;
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.hj{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#e46d0a; 
} 
td.td1{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td2{ 
	height: 22px;
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none; 
    color:#000; 

} 


</style>
<style type="text/css"> 
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
    .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
         .x-panel-body {
        border-bottom:#99bbe8 0px solid;
         position:  relative;
         border-left:#99bbe8 0px solid;
        border-right:#99bbe8 0px solid
     }
.x-panel-body-noheader{
   border-top:#99bbe8 0px solid
}
td.FieldValue ol{
    list-style:decimal;
}
td.FieldValue ul{
	list-style:disc;
}
td.FieldValue li{
	margin-left:35px;
}
td.FieldValue strong{
    font-weight:bold;
}
td.FieldValue em{
    font-style:italic;
}
/*仪表盘元素的样式*/
.gaugeChart{
	display: inline-block;
}
.x-panel .x-toolbar{
	overflow: auto; 
}
.x-panel .x-toolbar-ieCompatibilityViewOverflow{	/*兼容性视图总toolbar超出时对应的样式*/
	+height: 40px;
}
</style>
<style> 
    .x-panel-btns-ct {
          padding: 0px;
      }
</style>


<!--<script type="text/javascript" src="/js/bindJSToFormfield.js"></script>
<script type="text/javascript" src="/js/browserHackOfForm.js"></script>
<script type="text/javascript" src="/js/ext/ux/ajax.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>-->
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/interface/FormbaseService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script type="text/javascript" src="/js/rtxint.js"></script>
<script type="text/javascript" src="/js/browinfo.js"></script>
<script  type='text/javascript' src='/js/workflow.js'></script>

<script language="JavaScript" src="/chart/fusionchart/FusionCharts.js"></script>
<script type="text/javascript" src="/js/table.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script> <!-- 之前的jquery不支持属性*= -->
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/aop.pack.js"></script>    
<script type="text/javascript" src="/js/jquery/plugins/uploadify/jquery.uploadify-3.1.min.js"></script>

<script type="text/javascript" language="javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/CKEditorExt.js"></script>
<script type="text/javascript" src="/js/justgage/justgage.1.0.1.min.js"></script>
<script type="text/javascript" src="/js/justgage/raphael.2.1.0.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/resize/jquery.ba-resize.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type="text/javascript" language="javascript" src="/fck/FCKEditorExt.js"></script>
<script type="text/javascript" language="javascript" src="/fck/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/js/weaverUtil.js?v=1504"></script>
<script type="text/javascript" language="javascript" src="/app/js/pubUtil.js"></script>

<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>


    <script type="text/javascript">
        var iconBase = '/images';
        var fckBasePath= '/fck/';
        var contextPath='';
        var style='gray';
        
        /**禁止按Backspace键使网页后退**/
        function disabledBackspaceForBackPage(docElement){
			if(docElement.attachEvent){
				document.attachEvent("onkeydown", disabledBackspaceHandler);
			}else if(docElement.addEventListener){
				document.addEventListener("keydown", disabledBackspaceHandler, false);
			}
			
			function disabledBackspaceHandler(e){
				if(e.keyCode == 8){	//enter backspace
					var srcElementType = e.srcElement.type;
					if(srcElementType != "text" && srcElementType != "textarea" && srcElementType != "password"){
						e.returnValue = false;
					}
				}
			}
		}
        if(document){disabledBackspaceForBackPage(document);}
    </script>

<SCRIPT> 
function submm(humid)
{
	DWREngine.setAsync(false); 
	var pass=document.getElementById('text_pass').value;
	if(pass=='')
	{
		//alert('请输入原始密码！');
		document.getElementById('td1').innerHTML='<FONT color=#ff0000>请输入密码！</FONT>';
		return;
	}
	
	syncdomm(humid,pass);
	DWREngine.setAsync(true); 

}
   function syncdomm(userid,pass){
	   try{
        	Ext.Ajax.request({                            
					//async:true,                            
					url:'/app/hrmanage/userxz/checkHumPass.jsp?fresh=' + Math.random(),                            
					params:{                          
							userid:userid,
							 pass : pass        
					},                                                
					success: function(response){
					result = eval('('+response.responseText+')'); 
					var msg=result.msg;
					if(msg=='')
					{
						//alert('修改成功！');
						document.getElementById('td1').innerHTML='<FONT color=#ff0000>查询失败,请检查！</FONT>';
						//document.getElementById('splitIframe1').src='/blank.htm';       
					}
					else
					{
						//alert(msg);
						document.getElementById('td1').innerHTML='<FONT color=#ff0000>'+msg+'!</FONT>';
						if(msg=='查询成功')
						{
							if(document.getElementById('field_extrefobjfield5').value=='40285a90488ba9d101488bbd09100007')//盘锦厂
							{
							document.getElementById('splitIframe1').src='/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=0&reportid=40285a905783d6170157a3502bf11036'; 
							document.getElementById('splitIframe2').src='/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=0&reportid=40285a8d4dec1c6f014df60ad3ae0b27'; 
							}
							else
							{
							document.getElementById('splitIframe1').src='/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=0&reportid=40285a8d4dec1c6f014df60ad3ae0b27'; 
							
							}
						}

					}

	    	    	
	    	    },
	    	    failure: function(){
 
				 //alert("修改密码失败！");
				 document.getElementById('td1').innerHTML='<FONT color=#ff0000>查询失败！</FONT>';

	    	    }
	    	   }); 	       	       
	   }catch(e){
		   alert(e);
	   }
   }
</SCRIPT>

<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<CENTER>
<DIV id=layoutDiv>
<TABLE class=layouttable border=1>
<CAPTION>薪资查询</CAPTION>
<COLGROUP>
<COL width="30%">
<COL width="70%">

</COLGROUP>
<TBODY>


<tr>
  <td class=FieldName noWrap style="text-align:right">用户名</td>
  <td class=FieldValue><input type="hidden"  id="field_user" value="<%=humreno%>" /><input type="hidden"  id="field_extrefobjfield5" value="<%=extrefobjfield5%>" /><%=humreno%> <FONT color=#ff0000>*</FONT><input type="hidden" value="<%=humreid%>" id="text_userid"></td>
</tr>

<tr>
  <td class=FieldName noWrap style="text-align:right">密码</td>
  <td class=FieldValue><input class=InputStyle2 type="password" id="text_pass" value="" /> <FONT color=#ff0000>*</FONT><input type="button" value="查询" onclick="javascript:submm('<%=humreid%>')"/><span id=td1><span></td>
</tr>
<TR>
<TD colSpan=2>
<DIV id=yearHldDiv><IFRAME id=splitIframe1 height=200 src="/blank.htm" frameBorder=0 width="100%" name=splitIframe1 scrolling=no></IFRAME></DIV></TD></TR>
<TR>
<TD colSpan=2>
<DIV id=yearHldDiv1><IFRAME id=splitIframe2 height=200 src="/blank.htm" frameBorder=0 width="100%" name=splitIframe2 scrolling=no></IFRAME></DIV></TD></TR>

</TBODY>

</table>
</div>
<CENTER>