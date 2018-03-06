<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.BaseContext"%>

<%
	LabelService labelService = (LabelService)BaseContext.getBean("labelService");
%>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=<%=request.getContextPath()%>/css/eweaver.css>
</HEAD>
</HTML>

<BODY>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
    <td height="10" colspan="3"></td>
</tr>
<tr>
    <td ></td>
    <td valign="top">
        <TABLE class=Shadow>
        <tr>
        <td valign="top">
        <TABLE class=ViewForm>
        <COLGROUP>
        <COL width="30px">
        <COL>
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8001f") %><!-- 操作说明 -->
            </TH>
        </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD>
        </TR>
        <TR>
          <TD height="5" colSpan=2></TD>
        </TR>
        <TR>
          <TD align="right" valign="top" height="20"><li></TD>
          <TD><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be40039") %><!-- 本页面用于显示提醒消息的具体内容。 --></TD>
        </TR>
        <TR>
          <TD>&nbsp</TD>
        </TR>
        <TR>
          <TD align="right" valign="top" height="20"><li></TD>
          <TD><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4003a") %><!-- 点击左侧提醒消息名称，右侧会显示点击的提醒消息的具体内容，顶级节点除外。 --></TD>
        </TR>
        <TR>
          <TD>&nbsp</TD>
        </TR>       
        <TR>
          <TD align="right" valign="top" height="20"><li></TD>
          <TD><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4003b") %><!-- 提醒消息名称旁边的数量是代表这个提醒消息底下有多少提醒消息。 --></TD>
        </TR>
        </table>
        </td>
        </tr>
        </TABLE>
    </td>
    <td></td>
</tr>
<tr>
    <td height="10" colspan="3"></td>
</tr>
</table>
</BODY>
</HTML>
