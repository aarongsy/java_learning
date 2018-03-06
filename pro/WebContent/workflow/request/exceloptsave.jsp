<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.excel.model.Excelopt" %>
<%@ page import="com.eweaver.excel.service.ExceloptService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page import="com.eweaver.excel.model.Excelopt" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
  <head>
    <title><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a004b") %><!-- EXCEL的前操作页面 --></title>
	  <!--
      <OBJECT classid=CLSID:CBD79B8A-7975-4DD7-AF00-7E5ED70F7485
        codebase="<%=request.getContextPath()%>/activex/WeaverOcx.CAB#version=2,0,0,0" id="filecheck" style="display:none">
      </OBJECT>
	  -->
<script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%=request.getContextPath()%>/dwr/util.js'></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>

      
<%
    String exceloptid = StringHelper.null2String(request.getParameter("id"));
    ExceloptService exceloptService = (ExceloptService) BaseContext.getBean("exceloptService");
    CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
    WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
    Excelopt excelopt = new Excelopt();
    Integer objtype = 0;
    String categoryid="";
    String workflowid="";
    String categoryName="";
    String workflowName="";
    if(!"".equals(exceloptid)){
        excelopt = exceloptService.getExcelopt(exceloptid);
        objtype = excelopt.getObjtype();
        if(objtype.equals(0)){
            categoryid = excelopt.getObjid();
            categoryName = categoryService.getCategoryById(categoryid).getObjname();
        }else if(objtype.equals(1)){
            workflowid = excelopt.getObjid();
            workflowName = workflowinfoService.get(workflowid).getObjname();
        }
    }

%>
<%
    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")+"','S','accept',function(){tosave()});";//保存

%>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
</style>

    <script type="text/javascript">
          Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320021") %>';//加载中,请稍后...
                   Ext.onReady(function(){
                       <%if(!pagemenustr.equals("")){%>
                           var tb = new Ext.Toolbar();
                           tb.render('pagemenubar');
                       <%=pagemenustr%>
                       <%}%>
                   });
    </script>
<script type="text/javascript">
      function getBrowser(viewurl,inputname,inputspan,isneed){
          var id;
          try{
          id=openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
              document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

                  }
               }
       }

        function tosave(){
            document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExceloptAction?action=save";
            document.forms[0].submit();
        }

        function myChange(){
            var type=document.getElementById("type").value;

            if(type==0){
                document.getElementById("categorydiv").style.display="block";
                document.getElementById("workflowdiv").style.display="none";
                document.getElementById("humresdiv").style.display="none";

                //document.getElementById("forminfospan").innerText="";
            }else if(type==1){
                document.getElementById("workflowdiv").style.display="block";
                document.getElementById("categorydiv").style.display="none";
                document.getElementById("humresdiv").style.display="none";

                //document.getElementById("forminfospan").innerText="";
            }else{
                document.getElementById("humresdiv").style.display="block";
                document.getElementById("categorydiv").style.display="none";
                document.getElementById("workflowdiv").style.display="none";

                //document.getElementById("forminfospan").innerText="<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f004c") %>";//系统人事表
            }
        }
    </script>
  </head>
  <body>
<div id="divSearch">
 <div id="pagemenubar"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExceloptAction?action=save" target="_self"  name="EweaverForm"  id="EweaverForm"  method="post" >
    <input type="hidden" name="exceloptid" value="<%=excelopt.getId()%>"/>
    <table class=noborder>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>



	</table>

    <table class=noborder>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>



	</table>

<DIV id=div align=center>
<FIELDSET style="WIDTH: 98%"><STRONG><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f004d") %><!-- EXCEL操作任务保存 --></STRONG>
<TABLE width="100%">
<COLGROUP>
<COL width="50%">
<COL width="50%"></COLGROUP>
<TBODY>
<TR>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
</TR>
<TR>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fce4cc10006") %><!-- 任务名称 --></TD>
<TD class=FieldValue >
    <input type=text class=inputstyle name="objname" value="<%=StringHelper.null2String(excelopt.getObjname())%>"/>
</TD>
</TR>
<TR>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f004e") %><!-- 类型选择 --></TD>
<TD class=FieldValue >
    <select id="type" name="type" onchange="myChange()">
    <option value="0" <%if(objtype.equals(0)){%> selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008") %><!-- 分类 --></option>
    <option value="1" <%if(objtype.equals(1)){%> selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044") %><!-- 流程 --></option>
    <option value="2" <%if(objtype.equals(2)){%> selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f004f") %><!-- 系统人事 --></option>
    </select>
</TD>
</TR>
<TR>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
</TR>
</TBODY>
</TABLE>
</FIELDSET>
</DIV>
<p/><br><br>
<p/>
<DIV id=categorydiv align=center <%if(objtype.equals(0)){%> style="display:block"<%}else{%>style="display:none"<%}%>>
<FIELDSET style="WIDTH: 98%"><STRONG><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0050") %><!-- 请选择具体的分类 --></STRONG>
<TABLE width="100%">
<COLGROUP>
<COL width="50%">
<COL width="50%"></COLGROUP>
<TBODY>
<TR>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
</TR>

<TR>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008") %><!-- 分类 --></TD>
<TD class=FieldValue ><button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/base/category/categorybrowser.jsp','category','categoryspan','1')"></button><input type="hidden" name="category" value="<%=categoryid%>"  style='width: 288px; height: 17px'  ><span id="categoryspan" name="categoryspan" ><%=categoryName%></span></TD></TR>
<TR>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
</TR>
</TBODY>
</TABLE>
</FIELDSET>
</DIV>


<DIV id=workflowdiv align=center <%if(objtype.equals(1)){%> style="display:block"<%}else{%>style="display:none"<%}%>>
<FIELDSET style="WIDTH: 98%"><STRONG><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0051") %><!-- 请选择具体的流程 --></STRONG>
<TABLE width="100%">
<COLGROUP>
<COL width="50%">
<COL width="50%"></COLGROUP>
<TBODY>
<TR>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
</TR>

<TR>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044") %><!-- 流程 --></TD>
<TD class=FieldValue ><button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/workflow/workflow/workflowinfobrowser.jsp','workflow','workflowspan','1')"></button><input type="hidden" name="workflow" value="<%=workflowid%>"  style='width: 288px; height: 17px'  ><span id="workflowspan" name="workflowspan" ><%=workflowName%></span></TD></TR>
<TR>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
</TR>
</TBODY>
</TABLE>
</FIELDSET>
</DIV>

<DIV id=humresdiv align=center <%if(objtype.equals(2)){%> style="display:block"<%}else{%>style="display:none"<%}%>>
<FIELDSET style="WIDTH: 98%"><STRONG><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0052") %><!-- 人事表单 --></STRONG>
<TABLE width="100%">
<COLGROUP>
<COL width="50%">
<COL width="50%"></COLGROUP>
<TBODY>
<TR>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
</TR>

<TR>
<TD class=FieldName noWrap align="center" colspan="2"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0053") %><!-- 您选择的是系统人事表单,确认要对该表单进行EXCEL操作吗? --></TD>
</TR>
<TR>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
</TR>
</TBODY>
</TABLE>
</FIELDSET>
</DIV>

  </form>
    </div>
  </body>
</html>




