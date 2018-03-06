<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/app/base/init.jsp"%>
<%@ include file="/base/init.jsp"%>
<%
	String throwstr = StringHelper.null2String(request.getParameter("throwstr"));
%>
<html>
  <head><title>Simple jsp page</title>
  <style type="text/css">
      .x-panel-btns-ct {
          padding: 0px;
      }
  </style>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js" ></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  </head>
  <body>
  <div id="mydiv">
<!--页面菜单开始-->
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=create" name="EweaverForm" id="EweaverForm" method="post" enctype="multipart/form-data">
<center>
<br><br><br>
	    <input type="hidden" name="workflowids" id="workflowids">
		<fieldset style="width:600">
        <table style="border:0">
				<colgroup>
					<col width="1%">
					<col width="20%">
					<col width="79%">
				</colgroup>

            <TR height="30"><TD class=Spacing colspan=3 align="center">			
			<span style="color:red">
			<%
			String type=request.getParameter("type");

			%>
			</span>
			<input  type="hidden" name="type" value="<%=type%>">
				<%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0001") %><!-- 年度 -->:&nbsp;&nbsp;<select name="yearCnd" style="height:10;width:100;font-size:11"  >
				<%
				Calendar today = Calendar.getInstance();
				Calendar temptoday1 = Calendar.getInstance();
				Calendar temptoday2 = Calendar.getInstance();
				int currentyear=today.get(Calendar.YEAR);
				int currentmonth=today.get(Calendar.MONTH)+1;  
				int currentday=today.get(Calendar.DATE);  
				int yearcnd=currentyear;
				for(int i=currentyear-2;i<currentyear+5;i++)
				{
					if(i==yearcnd)
						out.println("<option value='"+i+"' selected>"+i+"</option>");
					else 
						out.println("<option value='"+i+"'>"+i+"</option>");
				}
				%>
				</select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7190073") %><!-- 导入并修正数据 --> <input type="checkbox" name="isUpdate" value="0" checked></TD><TR>
				
            <TR><TD class=Line colspan=3 style="	height: 1px;	background-color: #C2D5FC;"></TD><TR>
            <TR height="30"><TD class=Spacing colspan=3 align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7190070") %><!-- 请在下面选择需要导入的excel文档 --></TD><TR>
	
            <TR height="30"><TD colspan=3 align="center"><input type="file" name="path" style="width:400"/></TD><TR>
					<tr><td colspan=3 align="center" ><button type="button" onclick="importRecords()" class="btn" ><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7190071") %><!-- 导入 --></button>&nbsp;&nbsp;&nbsp;<button type="button" onclick="document.forms[0].reset();" class="btn"><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %><!-- 取消 --></button></td></tr>
            <tr><td colspan=3 align="center">
                <br/>
								 <div id="finishmessage" <%if(throwstr.length()<1)out.println("style=\"display:none;\"");%>>
                    <span href="javascript:void(0)"><%=throwstr%></span>
<%
if(request.getAttribute("errorMsg")!=null){
	out.println("<span style='color:red;font-weight:bold;'>ERROR:</span><br/>");
	out.println(request.getAttribute("errorMsg"));
}
%>
						</div>
                <div id="progressBarhome" style="display:block;">
                <div id="progressBar" style="display:block;">
                <div class="status" id="p1text" style="display:inline;"></div>
                <div id="p1" style="width:300px;display:inline"></div>
 
                </div>
                </div>
              
                <br/>
				
        </td></tr>
	    </table>
		</fieldset>
        </form>
      <iframe id="upload_faceico" name="upload_faceico" src="<%=request.getContextPath()%>/base/module/upload_faceico.jsp" width="0" height="0" style="top:-100px;">
      </iframe>
      </div>
    <div id="messagePage">
        <table style="border:0">
            <TR><TD><span id="message" name="message" style="font-size:12"></span></TD></TR>
            </table>
      </div>
  </body>
<script language="javascript">
      var path="";

    function importRecords(){
				isfinish="0";
				document.getElementById("finishmessage").style.display="none";
				if(document.forms[0].path.value==""||document.forms[0].path.value==null){
					alert("<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7190072") %>");//你还没有选择需要导入的excel文档
					return;
				}
		document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.customaction.ft.ImportPcPlanAction?action=xmlupload";
			document.forms[0].submit();

    }

    </script>
</html>
