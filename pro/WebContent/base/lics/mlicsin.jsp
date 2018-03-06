<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.lics.service.LicsService" %>
<%
String rvalue=StringHelper.null2String(request.getAttribute("rvalue"));
LicsService licsService = (LicsService)BaseContext.getBean("licsService"); 
String _titlename=labelService.getLabelName("402881e50c7d5585010c7d69d5a0000a");
String _titleimage=request.getContextPath()+"/images/main/titlebar_bg.jpg";
boolean lics=false;
%>
<html>
  <head>
  </head>
  <body>

<table height=100%>
                     
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.lics.servlet.LicsAction?action=mlicsin" name="EweaverForm"  method="post">
	<tr height=10>
		<td class="FieldName" nowrap>
				<%=_titlename%>
		</td>
	</tr>								
	<tr>
		<td class="FieldValue" valign=top>
			<br>
			<%=labelService.getLabelName("402881e70c8099d8010c80bb08b50008")%>&nbsp
			<button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/document/file/fileuploadbrowser.jsp?mode=1','licsfile','licsfilespan','0');"></button>
			<input type="hidden"  name="licsfile" value=""/>
			<span id="licsfilespan"/></span>
			<br>
			<br>
			<%=labelService.getLabelName("402881e70c8099d8010c80bbee52000a")%>
			<br>
			<br>
			<%=labelService.getLabelName("402881e70c8099d8010c80bc353f000c")%>  
			<font color=red><%=licsService.getLicscode()%></font>			
			<br>
			对应的MAC地址:<font color=red><%=licsService.getLicmac()%></font>
			<br>
			<a href="javascript:showall('allmac')">显示所有MAC地址</a>
			<br>
			<span id="allmac" style="display:none">			
			<% 
			String allMacs[] = licsService.getAllMacs();
			int i = 0;
			if(allMacs != null) {
				for(String mac : allMacs) {
					i++;
					out.println("["+i+"]&nbsp;&nbsp;" + mac + "<br> ");
				}			
			} else {
			    out.println("无法获取MAC");
			}%>
			</span>
			<br>
			<%if(!rvalue.equals("0")){%>			
				<font color=red><%=labelService.getLabelName("402881e70c8099d8010c8113d0ac0011")%>(errorCode:<%=rvalue%>)</fonts>
			<%}%>
			
			
		</td>
	</tr>																								        

 </form> 
</table>

<script language="javascript"> 
function showall(id) {
	var allmac = document.getElementById(id);
	if(allmac) {
		allmac.style.display="";
	}
}
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url='+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
        onSubmit()
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }


function onSubmit(){
   	checkfields="licsfile";
   	checkmessage="<%=labelService.getLabelName("402881ec0c7beff9010c7d2f6ca0002f")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}else{
		getBrowser('/document/file/fileuploadbrowser.jsp?mode=1','licsfile','licsfilespan','0');
   	}
} 
function checkForm(thisform,items,message)
{
	thisform = thisform;
	items = items + ",";

	for(i=1;i<=thisform.length;i++)
	{
	tmpname = thisform.elements[i-1].name;
	tmpvalue = thisform.elements[i-1].value;
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);

	if(tmpname!="" &&items.indexOf(tmpname+",")!=-1 && tmpvalue == ""){
		 alert(message);
		 return false;
		}

	}
	return true;
}   
</script>     
  </body>
</html>
