<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<%@ include file="/common/taglibs.jsp"%>
<table>
    <tr>
        <td align='center'>
            <div id="chartdiv_<%=request.getAttribute("responseId")%>" align="center"></div>
        </td>
    </tr>
</table>
<script>
    var chart_<%=request.getAttribute("responseId")%> = new FusionCharts("<%=request.getContextPath()%>/chart/fusionchart/FCF_<%=request.getAttribute("swf")%>.swf", "ChartId", "<%=request.getAttribute("chartw")%>", "<%=request.getAttribute("charth")%>");
    Ext.Ajax.request({
            url:"<%=request.getContextPath()%>/ServiceAction/com.eweaver.chart.servlet.ChartAction?action=getChart&id=<%=request.getAttribute("portletId")%>",
            params:{sql:"<%=StringHelper.null2String(request.getParameter("sql")).replaceAll("\n", " ").replaceAll("\r", " ")%>"},
            success: function(res) {
			   chart_<%=request.getAttribute("responseId")%>.setTransparent(true);
               chart_<%=request.getAttribute("responseId")%>.setDataXML(res.responseText);
               chart_<%=request.getAttribute("responseId")%>.render("chartdiv_<%=request.getAttribute("responseId")%>");
				if(MailPortlet)MailPortlet.rePosition('<%=request.getAttribute("responseId")%>');
				else alert('MailPortlet is null');
				
				resizeMainPageBodyHeight();/*调整主页面的body高度*/
            }
        });
</script>