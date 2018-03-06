<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.workflow.report.model.Contemplate" %>
<%@ page import="com.eweaver.workflow.report.service.ContemplateService" %>
<%
    String contemplateid = StringHelper.null2String(request.getParameter("contemplateid"));
    String reportid = StringHelper.null2String(request.getParameter("reportid"));
	String sql = "select id,objname from contemplate where reportid='" + reportid + "'";
	DataService dataService = new DataService();
    ContemplateService contemplateService = (ContemplateService) BaseContext.getBean("contemplateService");
    List list = dataService.getValues(sql);
    Contemplate contemplate=new Contemplate();
    if(contemplateid!=null&&!"".equals(contemplateid)){
        contemplate = contemplateService.getContemplate(contemplateid);
    }
    String contemplateName = StringHelper.null2String(contemplate.getObjname());
    String contemplateDesc = StringHelper.null2String(contemplate.getObjdesc());
    String userid = StringHelper.null2String(request.getParameter("userid"));
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1446000a")%></title><!-- 模板 -->
    <script src='<%=request.getContextPath()%>/dwr/interface/ContemplateService.js'></script>
    <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
</head>
<body style="font-size:x-small" scroll="auto">
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=savecontemplate&reportid=<%=reportid%>&userid=<%=userid%>" id="EweaverForm" name="EweaverForm" method="post">
<input type="hidden" name="contemplateid" value="<%=contemplateid%>"/>
<table align="center" width="100">
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>    
<tr>
	<td align="center"><%=labelService.getLabelNameByKeyId("40288035248fd7a801248ff9588e0272") %><!-- 模板名称 --></td>
	<td align="center"><input type="text" size="30" maxlength="60" name="objname" style="width:180px" value="<%=contemplateName%>"></td>
</tr>
<tr>
	<td align="center"><%=labelService.getLabelNameByKeyId("402881eb0ca0bb62010ca0e4f8f40006") %><!-- 模板类型 --></td>
	<td align="center">
		<select name="ispublic" style="width:180px">
			<option value="False" <%if("False".equals(contemplate.getIspublic())){%>selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("40288035248fd7a80124902ca3a90414") %><!-- 私人模板 --></option>
            <option value="True" <%if("True".equals(contemplate.getIspublic())){%>selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("40288035248fd7a80124902e1f2d0416") %><!-- 公共模板 --></option>
        </select>
	</td>
</tr>
<tr>
	<td align="center"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6cd1b580008") %><!-- 排序 --></td>
	<td align="center"><input type="text" size="30" maxlength="60" name="objdesc" style="width:180px" value="<%=contemplateDesc%>"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>    
<tr>
    <td colspan="2" align="center">
                <button  type="button" accessKey="S" onclick="toSubmit()">
                    <U>S</U>--<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %><!-- 确定 -->
                </button>
                &nbsp;&nbsp;&nbsp;
                <button  type="button" accessKey="C" onclick="Cancel_onclick();">
                    <U>C</U>--<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %><!-- 取消 -->
                </button>
    </td>
</tr>
</table>
<script language="VBS">
Sub Cancel_onclick
	window.close
End Sub
</script>
<script type="text/javascript">
    function toSubmit(){
        if(document.forms[0].objname.value==null||document.forms[0].objname.value==""){
            alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003c") %>,");//请输入模板名称
            return;
        }
        ContemplateService.saveContemplate("<%=reportid%>","<%=userid%>",document.forms[0].objname.value,document.forms[0].ispublic.value,document.forms[0].objdesc.value,document.forms[0].contemplateid.value,callback);
    }

    function callback(data){
        if(data=="ok"){
            alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003d") %>");//操作成功!
        }else{
            alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003e") %>");//操作失败!
        }
        window.close();
    }
</script>
</form>
</body>
</html>

