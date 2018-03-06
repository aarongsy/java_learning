<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%> 
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%> 
<%@ page import="com.eweaver.base.security.service.logic.SysuserrolelinkService"%>
<%@ page import="com.eweaver.base.security.model.Sysuserrolelink"%>
<%@ page import="com.eweaver.humres.base.service.*" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@page import="com.sun.xml.internal.ws.api.streaming.XMLStreamReaderFactory.Default"%>
<%
  response.setHeader("cache-control", "no-cache");
  response.setHeader("pragma", "no-cache");
  response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");    
  String objid = request.getParameter("objid");
  String mtype = "1";
  LabelService labelService = (LabelService)BaseContext.getBean("labelService");
  SetitemService setitemService0=(SetitemService)BaseContext.getBean("setitemService");
  SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
  BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
  String sql ="select setitemid,passrule as passrule ,passcount as passcount,ispassmodel as ispassmodel from dynamicpassrule where setitemid='297e930d347445a101347445ca4e0000'";
  DataService dateservice = new DataService();
  List<Map<String,Object>> list1 = dateservice.getValues(sql);
  boolean temp1=false;
  boolean temp2=false;
  boolean temp3=false;
  boolean temp4=false;
  String passrule = list1.get(0).get("passrule").toString().trim();
  int t = Integer.parseInt(passrule);
  String passcount = list1.get(0).get("passcount").toString();
  boolean ispassmodel = list1.get(0).get("ispassmodel").toString().equals("1")?true:false;
  String texttype ="password";
  if(ispassmodel)texttype="text";
  switch (t){
   case 5:
	   temp1 = true; //小写
	   break;
   case 6:
	   temp2=true;//数字
	   break;
   case 2:
	   temp3 = true;//xiaoshuzi
	   break;
   case 3:
	   temp4 = true;//hum
	   break;
  }
  String id = "";
  String logonname =""; 
  String isclosed ="0";
  String isclosedshow = labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd751b7610004");//正常
  String keyvalue="";
  Sysuser sysuser = sysuserService.getSysuserByObjid(objid);
  String ismaster="1";
  String  dynamicpass="0";
  String isusbkey="0";
  String belongto="";
  Humres masterUser=null;
  if (sysuser!=null) {
     id = sysuser.getId();
     logonname = StringHelper.null2String(sysuser.getLongonname());
     mtype =  ""+sysuser.getMtype();
     isclosed = ""+sysuser.getIsclosed();
     ismaster=""+NumberHelper.string2Int(sysuser.getIsmaster(),1);
      dynamicpass=""+NumberHelper.string2Int(sysuser.getDynamicpass(),0);
     isusbkey=""+NumberHelper.string2Int(sysuser.getIsusbkey(),0);
     belongto=StringHelper.null2String(sysuser.getBelongto());
     if(!belongto.equals("")){
      HumresService humresService = (HumresService) BaseContext.getBean("humresService");
      masterUser=humresService.getHumresById(belongto);
     }
     if (NumberHelper.string2Int(sysuser.getIsclosed(), -1) == 1){
        isclosedshow = labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d");//关闭
      }
   }
 %>
<html>
    <link rel="stylesheet" type="text/css" href="/css/global.css">
    <link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
    <script type="text/javascript">
        var iconBase = '/images';
        var fckBasePath= '/fck/';
        var contextPath='';
    </script>
    <script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
	<script type='text/javascript' language="javascript" src='/js/main.js'></script>
	<script type="text/javascript" language="javascript" src="/fck/FCKEditorExt.js"></script>
	<script type="text/javascript" language="javascript" src="/fck/fckeditor.js"></script>
	<script type="text/javascript" language="javascript" src="/js/weaverUtil.js?v=1504"></script>
	<script type="text/javascript" language="javascript" src="/app/js/pubUtil.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/complexify/jquery.complexify.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/complexify/jquery.complexify.wrap.js"></script>
	<link type="text/css" rel="stylesheet" href="/js/jquery/plugins/complexify/jquery.complexify.css"/> 
	<script>
		$(function(){
			disabledSpacebarForPassword();
			$("#logonpass").complexifyWrap();
		});
		
		//输入密码时禁用掉空格键
		function disabledSpacebarForPassword(){
			var logonpass = document.getElementById("logonpass");
			if(logonpass.attachEvent){
				logonpass.attachEvent("onkeydown", disabledSpacebarHandler);
			}else if(logonpass.addEventListener){
				logonpass.addEventListener("keydown", disabledSpacebarHandler, false);
			}
			
			function disabledSpacebarHandler(e){
				if(e.keyCode == 32){	//空格键
					e.returnValue = false;
				}
			}
		}
	</script>
  <body>
<!--页面菜单开始-->
<div id="pagemenubar" style="z-index:100;"><input type="button" value="<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009") %>" id="subbutton" onclick="onSubmit();" />
<font color="red"><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4002b") %><!-- 请重新修改密码!重新修改完成后重新登录系统！ --></font>
</div>
<!--页面菜单结束-->

 	 <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysuserAction?action=loginmodify" name="EweaverForm" id="EweaverForm"  method="post">
		<input type="hidden" name="objid"  value="<%=objid%>"/>
	    <input type="hidden" name="id"  value="<%=id%>"/>
	    <input type="hidden" name="mtype"  value="<%=mtype%>"/>
		<table> 
            <colgroup> 
				<col width="20%">
				<col width="80%">
			</colgroup>	
	
				<tr>
					<td class="FieldName" nowrap>
					    <%=labelService.getLabelName("402881eb0bcbfd19010bccd7006a0041")%>
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width=50%" name="logonname" id="logonname" value="<%=logonname%>"  readOnly/>
						<span id="logonnamespan"/></span>
						<%=StringHelper.null2String(request.getAttribute("msg"))%>					
					</td>
				</tr>
 				<tr>
				    <td class="FieldName" nowrap>
					    <%=labelService.getLabelName("402881eb0bcbfd19010bccd7f1bd0042")%>
					</td>
					<td class="FieldValue">
						<input type="<%=texttype %>" class="InputStyle2" style="width=50%" name="logonpass" id ="logonpass" value="" onChange="checkInputPASS('logonpass');checkInput('logonpass','logonpassspan')"/>
						<span id="logonpassspan"/><img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
						<span id="logonpassspan1"/></span>
					</td>
				</tr>    
 				<tr>
				    <td class="FieldName" nowrap>
					    <%=labelService.getLabelName("402881eb0bcbfd19010bccd8728e0043")%>
					</td>
					<td class="FieldValue">
						<input type="<%=texttype %>" class="InputStyle2" style="width=50%" name="logonpass2"  id ="logonpass2" value="" onChange="checkInputPASS('logonpass2');checkInput('logonpass2','logonpass2span')"/>
						<span id="logonpass2span"/><img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
						<span id="logonpass2span1"/></span>
					</td>
				</tr> 
				<!-- -隐藏不修改信息 -->
				<tr style="display: none"> 
					<td class="FieldValue" colspan="2">
						<input type="text" class="InputStyle2" style="width=50%" name="usbkeyvalue" value="<%=keyvalue%>" />
					</td>
				</tr> 
				<tr style="display: none">
                    <td class="FieldValue" colspan="2">
                        <input type="hidden" class="InputStyle2" style="width=50%" name="ismaster" value="<%=ismaster%>">
					</td>
				</tr>
				<tr id="multiAccount" style='display:none'>
					<td class="FieldValue" colspan="2">
						<input type="hidden" name="belongto" value="<%=belongto%>"   />
                    </td>
				</tr>		
 				<tr style='display:none'>
					<td class="FieldValue" colspan="2">
						<input type="hidden" class="InputStyle2" style="width=50%" name="isclosed" value="<%=isclosed%>">
					</td>
				</tr>
            <tr style="display: none">
                    <td class="FieldValue" colspan="2">
                        <input type="hidden" class="InputStyle2" style="width=50%" name="dynamicpass" value="<%=dynamicpass%>">
					</td>
				</tr>
            <tr style="display: none">
                    <td class="FieldValue" colspan="2">
                        <input type="hidden" class="InputStyle2" style="width=50%" name="isusbkey" value="<%=isusbkey%>">
					</td>
				</tr>
        </table>
        
     </form>
 <script language="javascript">
 //1 验证字符长度8 2 验证包含数字  3 验证包含字母  4 验证包含字符 
//if(str.length!=8||!/[0-9]+/.test(str)||!/[a-zA-Z]+/.test(str)||!/[^0-9a-zA-Z]/.test(str))alert('111');
  function onSubmit(){
   	checkfields="logonname,logonpass";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		if (checkPwd(document.getElementById("logonpass").value,document.getElementById("logonpass2").value)){
   			if(!checkInputPASS('logonpass')){
   				return;
   			}
   			if(!checkInputPASS('logonpass2')){
   				return;
   			}
   			document.EweaverForm.submit();
   		}else{
   			document.getElementById("logonpass2span1").innerHTML="<font color='red'>两次密码不同</font>";
   		}
   	}
        event.srcElement.disabled = false;
   }
  
   function checkPwd(pwd1,pwd2){
       if (pwd1 == pwd2) {
          return true;
        }else{
        return false;
        }
   }

   /**
 * 验证长度处理函数
 * @param {Object} elementname
 * @param {Object} min
 * @param {Object} max
 * @return {TypeName} 
 */
function checkInputLenthnew(elementname){
	var tmpvalue = document.getElementById(elementname).value;
	var tmpvalue = Trim(tmpvalue);
	if(tmpvalue.length >= <%=passcount%>){
		document.getElementById(elementname+"span1").innerHTML="";
		 return true;
	}
	else{
	 	msg="<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4002c") %>"+<%=passcount%>+"<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4002d") %>";//请输入不小于  位字符
	 	document.getElementById(elementname+"span1").innerHTML="<font color='red'>"+msg+"</font>";
	 	return false;
	}
}
 /*
  * 验证包含数字  
  * @param {Object} elementname
  * @param {Object} min
  * @param {Object} max
  * @return {TypeName} 
  */
 function checkInputPASS(elementname){
	var tmpvalue = document.all(elementname).value;
	var tmpvalue = Trim(tmpvalue);
	<%if(temp1){%>
	if(checkInputLenthnew(elementname)){
	if(!/[a-z]+/.test(tmpvalue)){
		msg="<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4002e") %>";//输入密码不符合小写字母!
	 	document.getElementById(elementname+"span1").innerHTML="<font color='red'>"+msg+"</font>";
	 	return false;
	}else{
		
	 	document.getElementById(elementname+"span1").innerHTML="";
	 	return true;
	 	}
	}
	<%}%>
	<%if(temp4){%>
	if(checkInputLenthnew(elementname)){
	if(!/[0-9]+/.test(tmpvalue)||!/[A-Z]+/.test(tmpvalue)||!/[a-z]+/.test(tmpvalue)){
		msg="<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4002f") %>";//输入密码不符合数字加大小写字母!
	 	document.getElementById(elementname+"span1").innerHTML="<font color='red'>"+msg+"</font>";
	 	return false;
	}else{
	 	document.getElementById(elementname+"span1").innerHTML="";
	 	return true;
	 	}
	}
	<%}%>
	<%if(temp2){%>
	if(checkInputLenthnew(elementname)){
	if(!/[0-9]+/.test(tmpvalue)){
		msg="<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be40030") %>";//输入密码不符合数字!
	 	document.getElementById(elementname+"span1").innerHTML="<font color='red'>"+msg+"</font>";
	 	return false;
	}else{
	 	document.getElementById(elementname+"span1").innerHTML="";
	 	return true;
	 	}
	}
	<%}%>
	<%if(temp3){%>
	if(checkInputLenthnew(elementname)){
	if(!/[0-9]+/.test(tmpvalue)||!/[a-z]+/.test(tmpvalue)){
		msg="<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be40031") %>";//输入密码不符合数字加小字母!
	 	document.getElementById(elementname+"span1").innerHTML="<font color='red'>"+msg+"</font>";
	 	return false;
	}else{
	 	document.getElementById(elementname+"span1").innerHTML="";
	 	return true;
	 	}
	}
	<%}%>
}
 
</script>

  </body>
</html>
