<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%
	LabelService labelService = (LabelService)BaseContext.getBean("labelService");
%>
<html>
  <head>
  <LINK REL=stylesheet type=text/css HREF=<%=request.getContextPath()%>/css/eweaver.css>
    <SCRIPT language=javascript>
        function mnToggleleft()
        {
            var o = window.parent.sysRemindInfoFrameSet;
            if(o.cols=="180,*")
            {
                o.cols = "10,*"; LeftHideShow.src = "<%=request.getContextPath()%>/images/hide.gif"; LeftHideShow.title = '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %>';//显示
            }
            else
            {
                o.cols = "180,*"; LeftHideShow.src = "<%=request.getContextPath()%>/images/show.gif"; LeftHideShow.title = '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003") %>';//隐藏
            }
        }
    </SCRIPT>   
  </head>
  
  <BODY>
    <table width=100% height="100%" cellspacing="0" cellpadding="0">
      <tr>
        <td width="100%">
          <TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <COLGROUP>
              <COL width="5">
              <COL width="">
            </COLGROUP>
            <TR bgcolor="#DFDFDF">
              <TD height="5" colspan="2"></TD>
            </TR>
            <TR>              
              <TD bgcolor="#DFDFDF"></TD>
              <TD>              
                <IFRAME name=treeFrame id=treeFrame src="SysRemindInfoTreeDetail.jsp" width="100%" height="100%" frameborder=no>
                     <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4003d") %><!-- 浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。 -->
                </IFRAME>
              </TD>
            </TR>
          </TABLE>
        </td>
        <td style="background-color:#DFDFDF" align=left valign=center >
          <IMG id=LeftHideShow name=LeftHideShow title='' style="CURSOR: hand"  src="<%=request.getContextPath()%>/images/show.gif" onclick="mnToggleleft()"/>
        </td>
      </tr>
    </table>
  </BODY>

</html>