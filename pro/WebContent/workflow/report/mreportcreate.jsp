<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.Page"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%

   String id=StringHelper.null2String(request.getParameter("id"));
   String reportid = request.getParameter("reportid");
    List reportfieldList = (List)request.getAttribute("reportfieldList");
   String selectItemId = StringHelper.trimToNull(request.getParameter("selectitemid"));
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   List selectitemlist = selectitemService.getSelectitemList("402881e70c907630010c907aea350006",null);
   Selectitem selectitem;
    HumresService humresService = (HumresService) BaseContext.getBean("humresService");
%>

<html>
  <head>
  <Style>
 	UL    { margin-left:22pt; margin-top:0em; margin-bottom: 0 }
   	UL LI {list-style-image: url('<%=request.getContextPath()%>/images/book.gif'); margin-bottom: 4}
</Style>
  </head> 

	
  <body>
       <%titlename=labelService.getLabelName("402881f00c9078ba010c907b291a0006");%>
		<div id="menubar">
		    <button type="button" class='btn' accessKey="S" onclick="javascript:onSubmit2();">
				<U>S</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")%><!--提交 -->
		    </button>
		    <button type="button" class='btn' accessKey="B" onclick="javascript:window.history.go(-1);">
				<U>B</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabe32990000f")%><!--返回 -->
		    </button>
		</div>	  
      	 <!-- form -->  
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=create" name="EweaverForm" method="post">
 <input type="hidden"  name="objtype2" value="sql"/>
<table>
	<colgroup> 
		<col width="50%">
		<col width="50%">
	</colgroup>	
  <tr>
	<td valign=top>
		       <table class=noborder>
				<colgroup> 
					<col width="20%">
					<col width="80%">
				</colgroup>	
		        <tr class=Title>
					<th colspan=2 nowrap><%=labelService.getLabelName("402881e80ca5d67a010ca5e168090006")%><!--报表信息--></th>		        	  
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>		        	  
		        </tr>		        	
				<tr>
					<td class="FieldName" nowrap>
					   <%=labelService.getLabelName("402881e80ca5d67a010ca5e245050009")%><!-- 报表名称-->
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width=95%" name="objname"  onChange="checkInput('objname','objnamespan')"/>
						<span id="objnamespan"/><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
					</td>
				</tr>	
				<tr>
					<td class="FieldName" nowrap>
						 <%=labelService.getLabelName("402881540c9f83d6010c9f9c69800006")%><!-- 报表类型 -->
					</td>
					<td class="FieldValue">
						<select class="inputstyle" id="selectitemid" name="selectitemid">
	                  	<%
		                   Iterator it= selectitemlist.iterator();
		                   while (it.hasNext()){
		                      selectitem =  (Selectitem)it.next();
							          
		               	%>
		                   <option value=<%=selectitem.getId()%>><%=selectitem.getObjname()%></option>	                   
		               	<%
		                  } // end while
		               	%>
			      		</select>
					</td>
				</tr>
				
		        <tr>
					<td class="Line" colspan=100% nowrap>
					</td>		        	  
		        </tr>
		        
		        <tr class=Title>
					<th colspan=2 nowrap><%=labelService.getLabelName("402881e50d8798a3010d87bbc989000f")%><!--  多表单SQL-->(<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1446000c")%>：{sql1}{sql2}{sql3})	</th><!-- sql样式备注 -->	        	  
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>		        	  
		        </tr>		        
				<tr>
					<td class="FieldValue" colspan=2>
					<TEXTAREA STYLE="width=100%" class=InputStyle rows=10 name="objdesc" onChange="checkInput('objdesc','objdescspan')"></TEXTAREA>
                     <span id="objdescspan"/><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
					</td>
				</tr>
				
				<tr>
					<td class="FieldName" nowrap>
					   <%=labelService.getLabelName("402881e50da512e8010da5a0c9cf0022")%><!-- 模板文件名-->
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width=95%" name="objmodelname" />
						<span id="objmodelnamespan"/></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					   <%=labelService.getLabelName("402881e50d80e9be010d81fe98ed00a4")%><!-- 报表保存路径-->
					</td>
					<td class="FieldValue">
						<%=labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a")%>：</br><!-- 备注 -->
                         <%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1446000d")%></br><!-- 1、在“模板文件名”填写本报表对应的模板文件名称(*.xls)，不填写路径； -->
                         <%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1446000e")%></br><!--  2、模板文件保存在服务器“根目录\eweaver.war\srtemplate\”目录下； -->
						<span id="objsavepathspan"/></span>
					</td>
				</tr>
</table>
</form>



<script language="javascript"> 
function onSubmit(){
   	checkfields="objname,objdesc";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}
    function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
</script> 

  </body>
</html>
