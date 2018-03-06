<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
  <head>
    <title>EXCEL的前操作页面</title>
	  <!--
      <OBJECT classid=CLSID:CBD79B8A-7975-4DD7-AF00-7E5ED70F7485
        codebase="/activex/WeaverOcx.CAB#version=2,0,0,0" id="filecheck" style="display:none">
      </OBJECT>
	  -->
        <script src='/dwr/interface/DataService.js'></script>
      <script src='/dwr/engine.js'></script>
      <script src='/dwr/util.js'></script>
    <script type="text/javascript" src="/js/dojo.js"></script>
	<script language="JScript.Encode" src="/js/rtxint.js"></script>
	<script language="JScript.Encode" src="/js/browinfo.js"></script>
      <script  type='text/javascript' src='/js/workflow.js'></script>
    <link href="/css/eweaver.css" type="text/css" rel="STYLESHEET">
    <link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
      
    <link rel="stylesheet" type="text/css" href="/js/ext/resources/css/xtheme-purple.css"/>

      <script  type='text/javascript' src='/js/main.js'></script>
	<script type="text/javascript" language="javascript" src="/fck/fckeditor.js"></script>
	<script type="text/javascript" language="javascript" src="/fck/FCKEditorExt.js"></script>
	<script type="text/javascript" language="javascript" src="/js/weaverUtil.js"></script>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
</style>
      
    <script type="text/javascript">

      function getBrowser(viewurl,inputname,inputspan,isneed){
          var id;
          try{
          id=openDialog('/base/popupmain.jsp?url='+viewurl);
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

        function showNext(){
            var type=document.getElementById("type").value;

            document.getElementById("div").style.display="none";
            if(type==0){
                document.getElementById("categorydiv").style.display="block";
            }else if(type==1){
                document.getElementById("workflowdiv").style.display="block";
            }else{
                document.getElementById("humresdiv").style.display="block";
            }
        }

        function showPrevious(){
            document.getElementById("div").style.display="block";
            if(document.getElementById("categorydiv").style.display=="block"){
                document.getElementById("categorydiv").style.display="none";
            }else if(document.getElementById("workflowdiv").style.display=="block"){
                document.getElementById("workflowdiv").style.display="none";
            }else{
                document.getElementById("humresdiv").style.display="none";
            }
        }

        function exeCategory(){
            var category=document.getElementById("category").value;
            if(category==""){
                alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f006f") %>");//请选择具体的分类体系
            }else{
                document.forms[0].action="/workflow/form/getrecordbyexcel.jsp?categoryid="+category;
                document.forms[0].submit();
            }
        }

        function exeWorkflow(){
            var workflow=document.getElementById("workflow").value;
            if(workflow==""){
                alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0070") %>");//请选择具体的工作流程
            }else{
                document.forms[0].action="/workflow/workflow/getrecordbyexcel2.jsp?workflowid="+workflow;
                document.forms[0].submit();
            }
        }

        function myChange(){
            var type=document.getElementById("type").value;
            if(type==2){
                document.getElementById("forminfospan").innerText="<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f004c") %>";//系统人事表
            }else{
                document.getElementById("forminfospan").innerText="";
            }
        }
    </script>
  </head>
  <body>

<div id="divsum">
<form action="/workflow/form/exportrecordbyexcel.jsp" target="_self" enctype="multipart/form-data"  name="EweaverForm"  id="EweaverForm"  method="post" >

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
<FIELDSET style="WIDTH: 98%"><STRONG><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0071") %><!-- 请选择您需要导入导出的表单 --></STRONG>
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
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f004e") %><!-- 类型选择 --></TD>
<TD class=FieldValue >
    <select id="type" name="type" onchange="myChange()">
    <option value="0"><%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008") %><!-- 分类 --></option>
    <option value="1"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044") %><!-- 流程 --></option>
    <option value="2"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f004f") %><!-- 系统人事 --></option>
    </select>
</TD>
</TR>
<TR>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0072") %><!-- 选择表单 --></TD>
<TD class=FieldValue ><button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/workflow/form/forminfobrowser.jsp','forminfo','forminfospan','1')"></button><input type="hidden" name="forminfo" value=""  style='width: 288px; height: 17px'  ><span id="forminfospan" name="forminfospan" ></span></TD></TR>
<TR>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
</TR>
<TR>
<TD align="center" colspan="2"><a href="javascript:showNext()" style="font-size:12"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0073") %><!-- 下一步 --></a></TD>
</TR>
</TBODY>
</TABLE>
</FIELDSET>
</DIV>


<DIV id=categorydiv align=center style="display:none">
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
<TD class=FieldValue ><button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/base/category/categorybrowser.jsp','category','categoryspan','1')"></button><input type="hidden" name="category" value=""  style='width: 288px; height: 17px'  ><span id="categoryspan" name="categoryspan" ></span></TD></TR>
<TR>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
</TR>
<TR>
<TD align="center" colspan="2"><a href="javascript:showPrevious()" style="font-size:12"><%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f") %><!-- 返回 --></a>&nbsp;&nbsp;&nbsp;<a href="javascript:exeCategory()" style="font-size:12"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0074") %><!-- 处理 --></a></TD>
</TR>
</TBODY>
</TABLE>
</FIELDSET>
</DIV>


<DIV id=workflowdiv align=center style="display:none;">
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
<TD class=FieldValue ><button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/workflow/workflow/workflowinfobrowser.jsp','workflow','workflowspan','1')"></button><input type="hidden" name="workflow" value=""  style='width: 288px; height: 17px'  ><span id="workflowspan" name="workflowspan" ></span></TD></TR>
<TR>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
</TR>
<TR>
<TD align="center" colspan="2"><a href="javascript:showPrevious()" style="font-size:12"><%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f") %><!-- 返回 --></a>&nbsp;&nbsp;&nbsp;<a href="javascript:exeWorkflow()" style="font-size:12"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0074") %><!-- 处理 --></a></TD>
</TR>
</TBODY>
</TABLE>
</FIELDSET>
</DIV>

<DIV id=humresdiv align=center style="display:none;">
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
<TR>
<TD align="center" colspan="2"><a href="javascript:showPrevious()" style="font-size:12"><%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f") %><!-- 返回 --></a>&nbsp;&nbsp;&nbsp;<a href="javascript:document.forms[0].submit();" style="font-size:12"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0074") %><!-- 处理 --></a></TD>
</TR>
</TBODY>
</TABLE>
</FIELDSET>
</DIV>

  </form>
  </div>
  </body>
</html>




