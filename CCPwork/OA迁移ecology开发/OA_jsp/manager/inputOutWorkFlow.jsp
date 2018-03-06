<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:directive.page import="javax.sql.DataSource"/>
<%@ include file="/base/init.jsp"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String throwstr = StringHelper.null2String(request.getParameter("throwstr"));
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>数据同步</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
      
    <link rel="stylesheet" type="text/css" href="/js/ext/resources/css/xtheme-gray.css"/>
      
    <script type="text/javascript">
        var iconBase = '/images';
        var fckBasePath= '/fck/';
        var contextPath='';
        var style='gray';
    </script>
    <script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
    <script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
    <script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
    
	<script type="text/javascript">
		function getBrowser(viewurl,inputname,inputspan,isneed){
          var id;
          try{
          id=window.showModalDialog('/base/popupmain.jsp?url='+viewurl);
          }catch(e){}
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
       
       function inputWorkFlow(){
       		var workflow = document.getElementById("workflow").value;
       		var vdatasource = document.getElementById("vdatasource").value;
       		if(vdatasource==""){
       			alert("请先选择导入到那个数据源");
       			return;
       		}
       		var frm = document.getElementById("frm");
       		frm.submit();
       }
	</script>
  </head>
  
  <body>
    <form action="/app/manager/chageSource.jsp" id="frm">
	<table cellspacing="0" border="1" cellpadding=0 align="center"  style="width:100%;height:350" bordercolor=#808080>
	<colgroup>
	<col width="20%"/>
	<col width="80%"/>
	</colgroup>
	<tr height="50">
	<td align=center colspan=2>
		<span style="font-size:16;font-weight:bold">资 源 同 步 操 作</span>
	
	</td>
	<tr>
	<td class="FieldName">
		导入正式系统:
	
	</td>
	<td class="FieldValue">
		<%String[] names=BaseContext.getBeanNames(DataSource.class); %>
		<select id="vdatasource" name="vdatasource" style="width:300" value="otherDataDSgm">
		<option value="">&nbsp;</option>
		<%for(String n:names)
		{
		
			out.println("<option value=\""+n+"\" "+(n.equals("weaverv4")?"selected":"")+">"+n+"</option>");
		} %>
		</select>
		&nbsp;&nbsp;&nbsp;
	</td>
	</tr>
		<tr style="display:none">
	<td class="FieldName">
		导入其他数据源：
	
	</td>
	<td class="FieldValue">
		<%names=BaseContext.getBeanNames(DataSource.class); %>
		<select id="vdatasource2" name="vdatasource2" style="width:300" value="otherDataDSgmgj">
		<option value="">&nbsp;</option>
		<%for(String n:names)out.println("<option value=\""+n+"\" "+(n.equals("otherDataDSgmgj")?"selected":"")+" >"+n+"</option>"); %>
		</select>
		&nbsp;&nbsp;&nbsp;
	</td>
	</tr>
	<tr>
	<td colspan=2>
		<table cellspacing="0" border="1" cellpadding=0 align="center"  style="width:100%;height:350" bordercolor=#808080>
		<colgroup>
		<col width="20%"/>
		<col width="80%"/>
		</colgroup>
		<tbody>
		<tr bgcolor="#dddddd">
			<td class=FieldName  align="center"><b>同步资源类型</b></td>
			<td class=FieldName  align="center"><b>同步资源名称</b></td>
		</tr>
		<tr height=25 bgcolor="#e3e3e3">
		<td align=center>流程</td>
		<td align=left>	
			<button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/workflow/workflow/workflowinfobrowser.jsp','workflow','workflowspan','1')"></button>
			<input type="hidden" name="workflow" value=""  style='width: 288px; height: 17px'  >
			<span id="workflowspan" name="workflowspan" ></span>(请选择流程流程)</td>
		</tr>
		<tr height=25 bgcolor="#e3e3e3">
		<td align=center>报表</td>
		<td align=left>	
			           <button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/report/reportbrowser.jsp','report','reportspan','0');"></button>
                            <input type="hidden"  name="report" id="report" value=""/>
                            <span id=reportspan>

                            </span>(请选择报表)</td>
		</tr>
		<tr height=25 bgcolor="#e3e3e3">
		<td align=center>表单</td>
		<td align=left>	
	<button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/form/forminfobrowser.jsp','formid','formidspan','0');"></button>
			<input type="hidden"  name="formid" value=""/>
			<span id="formidspan"></span>(请选择表单)</td>
		</tr>
		<tr height=25 bgcolor="#e3e3e3">
		<td align=center>Broswer框</td>
		<td align=left>	
			<button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/base/refobj/refobjbrowser.jsp','browser','browserspan','1')"></button>
			<input type="hidden" name="browser" value=""  style='width: 288px; height: 17px'  >
			<span id="browserspan" name="browserspan" ></span>(请选择Broswer框)</td>
		</tr>
		<tr height=25 bgcolor="#e3e3e3">
		<td align=center>select字段</td>
		<td align=left>	
			<button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/base/selectitem/selectitemtypebrowser.jsp','selectitem','selectitemspan','1')"></button>
			<input type="hidden" name="selectitem" value=""  style='width: 288px; height: 17px'  >
			<span id="selectitemspan" name="selectitemspan" ></span>(请选择select字段)</td>
		</tr>
		<tr height=25 bgcolor="#e3e3e3">
		<td align=center>树型</td>
		<td align=left>	
			   <button  type="button" class=Browser onclick="javascript:getBrowser('/base/refobj/treeviewerBrowser1.jsp','treeviewer','treeviewerspan','0');"></button>
                            <input type="hidden"  name="treeviewer" id="treeviewer" value="" onpropertychange="opertypchange()" />
                            <span id=treeviewerspan>

                            </span>(请选择树型)</td>
		</tr>
		<tr height=25 bgcolor="#e3e3e3">
		<td align=center>分类</td>
		<td align=left>	
			<button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/base/category/categorybrowser.jsp', 'category','categoryspan', '1');"></button>
			<input type="hidden" name="category" value=""  style='width: 288px; height: 17px'  >
			<span id="categoryspan" name="categoryspan" ></span>(请选择分类)</td>
		</tr>
		<tr height=25 bgcolor="#e3e3e3">
		<td align=center>角色</td>
		<td align=left>	
			<button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/base/security/sysrole/sysrolebrowser.jsp','role','rolespan','1')"></button>
			<input type="hidden" name="role" value=""  style='width: 288px; height: 17px'  >
			<span id="rolespan" name="rolespan" ></span>(请选择角色)</td>
		</tr>
		<tr height=25 bgcolor="#e3e3e3">
		<td align=center>TEMP模板</td>
		<td align=left>	
			<button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/base/refobj/treeviewerBrowser.jsp?id=40288032223082690122308364550002','temp','tempspan','1')"></button>
			<input type="hidden" name="temp" value=""  style='width: 288px; height: 17px'  >
			<span id="tempspan" name="tempspan" ></span>(请选择模板)</td>
		</tr>
		<tr height=25 bgcolor="#e3e3e3">
		<td align=center>word模板</td>
		<td align=left>	
			<button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/document/base/wordmodulebrowser.jsp','wordmodule','wordmodulespan','1')"></button>
			<input type="hidden" name="wordmodule" value=""  style='width: 288px; height: 17px'  >
			<span id="wordmodulespan" name="wordmodulespan" ></span>(请选择word模板)</td>
		</tr>
		</table>
	</td>
	</tr>
	<tr>
	<td colspan=2 align=center>
    		<input type="button" value="导出" onclick="inputWorkFlow()">  &nbsp;&nbsp;&nbsp; <input type="reset" value="取消"> 
	</td></tr>
	<tr>
	<td colspan=2 align=center>
		 <div id="finishmessage" <%if(throwstr.length()<1)out.println("style=\"display:none;\"");%>>
                    <span href="javascript:void(0)" style="color:red"><%=throwstr%></span>
		 </div>
	</td></tr>
	</table>
    </form>
  </body>
</html>
