<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.Page"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="java.util.List"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%
   String id=StringHelper.null2String(request.getParameter("id"));
   ReportdefService reportdefService=(ReportdefService)BaseContext.getBean("reportdefService");
   Reportdef reportdef=new Reportdef();
   if(id!=""){
    reportdef=reportdefService.getReportdef(id);
   }
   String selectItemId = StringHelper.trimToNull(reportdef.getObjtype());
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   List selectitemlist = selectitemService.getSelectitemList("402881e70c907630010c907aea350006",null);
   Selectitem selectitem;
   ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
   Forminfo forminfo;
   
   HumresService humresService = (HumresService)BaseContext.getBean("humresService");
   
   String[] objopts = null;
   /**
   String members = "";
   if(reportdef.getObjopts() != null){
      	objopts = reportdef.getObjopts().split(",");
		StringBuffer opts = new StringBuffer("");
		StringBuffer optids =  new StringBuffer("");
		for(int k=0; k < objopts.length; k++){
			String humrename = humresService.getHrmresNameById(objopts[k]);
			opts.append(humrename).append(",");
		}
		
		if(opts.toString().contains(",")){
			 members = opts.toString().substring(0,opts.toString().lastIndexOf(","));
		}
   }
   */
   
   List reportfieldList = (List)request.getAttribute("reportfieldList");
String reportid = request.getParameter("reportid");
%>
<html>
  <head>
  <Style>
 	UL    { margin-left:22pt; margin-top:0em; margin-bottom: 0 }
   	UL LI {list-style-image: url('<%=request.getContextPath()%>/images/book.gif'); margin-bottom: 4}
</Style>
  </head> 
  <body>
<!--页面菜单开始-->     
<%
paravaluehm.put("{id}",id);
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{B,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.history.go(-1)}";
//pagemenustr += "{Q," +labelService.getLabelName("402881ed0c29ccef010c2a9592ac0019")+ ",javascript:addpermission('/base/security/addpermission.jsp?objid="+ id +"&&objtable=reportdef&&istype=0');}";
pagemenustr += "{K,"+labelService.getLabelName("402881e70c430602010c4374bffd0010")+",javascript:window.open('"+request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.PermissiondetailAction?objtable=reportdef&objid="+id+"')}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->    
      	 <!-- form -->  
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=mmodify" name="EweaverForm" method="post">
<input type="hidden" name="id" value="<%=StringHelper.null2String(reportdef.getId())%>">
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
                     </th>		        	  
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
						<input type="text" class="InputStyle2" style="width=95%" name="objname" value="<%=StringHelper.null2String(reportdef.getObjname()) %>"/>
						<%if((StringHelper.null2String(reportdef.getObjname())).equals("")){%>
						<img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
						<%}%>
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
						  String selected = "";
						  if(selectitem.getId().equals(selectItemId)) selected = "selected";
    
	               	%>
	                   <option value=<%=selectitem.getId()%> <%=selected%>><%=selectitem.getObjname()%></option>	                   
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
					<th colspan=2 nowrap><%=labelService.getLabelName("402881e50d8798a3010d87bbc989000f")%><!--  多表单SQL-->(sql样式备注：{sql1}{sql2}{sql3})</th>		        	  
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>		        	  
		        </tr>		        
				<tr>
					<td class="FieldValue" colspan=2>
					<TEXTAREA STYLE="width=100%" class=InputStyle rows=10 name="objdesc"><%=StringHelper.null2String(reportdef.getObjdesc())%></TEXTAREA>
					</td>
				</tr>
				
				<tr>
					<td class="FieldName" nowrap>
					   <%=labelService.getLabelName("402881e50da512e8010da5a0c9cf0022")%><!-- 模板文件名-->
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width=95%" name="objmodelname" value="<%=StringHelper.null2String(reportdef.getObjmodelname()) %>" />
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
			
			<br>
      	</form>

<script language="javascript"> 


function onSubmit(){
   	checkfields="objname,objdesc";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}    

  function addpermission(url){  
	  openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);

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
