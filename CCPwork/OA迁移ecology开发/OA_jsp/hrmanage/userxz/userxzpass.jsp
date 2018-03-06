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
%>

<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css" />
<link rel="stylesheet" type="text/css" id="global_css" href="/css/skins/skin1/global.css?1422582615223"/> 
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/xtheme-gray.css"/>
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
<meta http-equiv="pragma" content="no-cache"> 

     <meta http-equiv="cache-control" content="no-cache"> 

     <meta http-equiv="expires" content="0">   


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
 
function zxsetueserpass(humid)
{
	DWREngine.setAsync(false); 
	var xzoldpass=document.getElementById('field_oldpass').value;
	var xznewpass=document.getElementById('field_newpass').value;
	var xznewpasscheck=document.getElementById('field_newpasscheck').value;
	var userid=document.getElementById('field_userid').value;
	if(xzoldpass=='')
	{
		//alert('请输入原始密码！');
		document.getElementById('td1').innerHTML='<FONT color=#ff0000>请输入原始密码！</FONT>';
		return;
	}
	if(xznewpass=='')
	{
		//alert('请输入新密码！');
		document.getElementById('td1').innerHTML='<FONT color=#ff0000>请输入新密码！</FONT>';
		return;
	}
	if(xznewpasscheck=='')
	{
		//alert('请输入确认新密码！');
		document.getElementById('td1').innerHTML='<FONT color=#ff0000>请输入确认新密码！</FONT>';
		return;
	}
	if(xznewpasscheck!=xznewpass)
	{
		//alert('两次密码不一致！');
		document.getElementById('td1').innerHTML='<FONT color=#ff0000>两次密码不一致！</FONT>';
		return;
	}
	
	xzsetp(xzoldpass,xznewpass);
	DWREngine.setAsync(true); 

}
   function xzsetp(xzoldpass,xznewpass){
	   DWREngine.setAsync(false); 
	var userid=document.getElementById('field_userid').value;

	   try{
		        Ext.Ajax.request({                            
					//async:true,                            
					url:'/app/hrmanage/userxz/setHumXzpass.jsp?fresh=' + Math.random(),                            
					params:{                          
							userid:userid,
							 xzoldpass : xzoldpass,
							 xznewpass : xznewpass          
					},                                                
					success: function(response){
					result = eval('('+response.responseText+')'); 
					var msg=result.msg;
					if(msg=='')
					{
						//alert('修改成功！');
						document.getElementById('td1').innerHTML='<FONT color=#ff0000>修改失败！</FONT>';
					}
					else
					{
						//alert(msg);
						document.getElementById('td1').innerHTML='<FONT color=#ff0000>'+msg+'!</FONT>';
					}
					//alert();
					//onSearch();
					//location.reload();
	    	    	
	    	    },
	    	    failure: function(){
 
				 //alert("修改密码失败！");
				 document.getElementById('td1').innerHTML='<FONT color=#ff0000>修改密码失败！</FONT>';
	    	    }
	    	   }); 	       	       
	   }catch(e){
		   alert(e);
	   }
	   DWREngine.setAsync(true); 
   }
  function updateuserpass()
  {
	  var humreno=document.getElementById('field_user').value;
	     DWREngine.setAsync(false); 
        alert(humreno);
		        Ext.Ajax.request({                            
					//async:true,                            
					url:'/app/hrmanage/userxz/updateHumXzpass.jsp?fresh=' + Math.random(),                            
					params:{                          
							action:'up',
							 jobno : humreno       
					},                                                
					success: function(response){
						document.getElementById('td1').innerHTML='<FONT color=#ff0000>重置成功！</FONT>';
	    	    },
	    	    failure: function(){
 
				 //alert("修改密码失败！");
				 document.getElementById('td1').innerHTML='<FONT color=#ff0000>重置失败！</FONT>';
	    	    }
	    	   }); 	       	       
	   DWREngine.setAsync(true); 
  }
</SCRIPT>

<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<CENTER>
<DIV id=layoutDiv>
<TABLE class=layouttable border=1>
<CAPTION>薪资查询密码修改</CAPTION>
<COLGROUP>
<COL width="50%">
<COL width="50%">

</COLGROUP>
<TBODY>


<tr>
  <td class=FieldName noWrap style="text-align:right">用户名</td>
  <td class=FieldValue>
  <%
  if(humreid.equals("402881e70be6d209010be75668750014")||humreid.equals("40285a9049ade1710149ade86f060561")||humreid.equals("40285a9049ade1710149ade9664a089f")||humreid.equals("40285a904a1d4bfd014a2e7ad94f002d"))
  {
  %>
  <input class=InputStyle2  id="field_user" value="<%=humreno%>" />
  <%
  }else{
	%>
	<input TYPE="hidden"  id="field_user" value="<%=humreno%>" /><SPAN><%=humreno%></SPAN>
	<%}%> 
	<FONT color=#ff0000>*</FONT><input type="hidden" value="<%=humreid%>" id="field_userid"></td>
</tr>

<tr>
  <td class=FieldName noWrap style="text-align:right">原密码</td>
  <td class=FieldValue><input class=InputStyle2 type="password" id="field_oldpass" value="" /> <FONT color=#ff0000>*</FONT></td>
</tr>

<tr>
  <td class=FieldName noWrap style="text-align:right">新密码</td>
  <td class=FieldValue><input class=InputStyle2 type="password" id="field_newpass" value="" /> <FONT color=#ff0000>*</FONT></td>
</tr>

<tr>
  <td class=FieldName noWrap style="text-align:right">确认新密码</td>
  <td class=FieldValue><input class=InputStyle2 type="password" id="field_newpasscheck" value="" /> <FONT color=#ff0000>*</FONT></td>
</tr>

<tr>
  <td class=FieldName noWrap id=td1 style="text-align:right"></td>
  <td class=FieldValue>
  <%
	if(humreid.equals("402881e70be6d209010be75668750014")||humreid.equals("40285a9049ade1710149ade86f060561")||humreid.equals("40285a9049ade1710149ade9664a089f")||humreid.equals("40285a904a1d4bfd014a2e7ad94f002d"))
	{
		%>
		<input type="button" value="密码重置" onclick="javascript:updateuserpass()"/>
		<%
	}
  %>
  <input type="button" value="确认修改" onclick="javascript:zxsetueserpass('<%=humreid%>')"/></td>
</tr>


</TBODY>

</table>
</div>
<CENTER>