<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>

<%
   Page pageObject = (Page) request.getAttribute("pageObject");
   String workflowid  =  StringHelper.null2String(request.getParameter("workflowid"));
   HumresService humresService = (HumresService) BaseContext.getBean("humresService");
   WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
   NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");
   LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
   SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
   Setitem gmode=setitemService.getSetitem("402880311e723ad0011e72782a0d0005");
    String graphmode ="0";
    if(gmode!=null&&!StringHelper.isEmpty(gmode.getItemvalue())){
       graphmode=gmode.getItemvalue();
    }
   Nodeinfo nodeinfo = new Nodeinfo();
   List nodeinfoList = new ArrayList();    
   Map m = new HashMap();
 if (pageObject == null) {
     m.put("workflowid",workflowid);
 pageObject = nodeinfoService.getPagedByQuery(m,1,10000);
	
} 
// Map tempMap = (Map)request.getSession().getAttribute("nodeinfoMap");
// if (tempMap!=null) m = tempMap;   
%>


<html>
  <head>
  </head>
  
  <body>

		<!--页面菜单开始-->
		<%//pagemenustr += "{S," + "新增" + ",javascript:nodeonCreate('/workflow/workflow/nodeinfocreate.jsp')}";%>
		<div id="pagemenubar" style="z-index:100;"></div>
        <%if(graphmode.equals("0")){%>
        <div id="menubar">
			<button type="button" class='btn' accessKey="C" onclick="javascript:nodeonCreate('/workflow/workflow/nodeinfocreate.jsp?workflowid=<%=workflowid%>');">
				<U>C</U>--<%=labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")%>
			</button>
		</div>
        <%}%>
		<%@ include file="/base/pagemenu.jsp"%>
		<!--页面菜单结束--> 
    <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=search" name="EweaverForm" method="post">
    <input type="hidden" id="workflowid" value="<%=workflowid%>">
    <!-- data table-->  
  <table class=noborder>
	<colgroup> 
	    <col width="2%">
	    <col width="18%">
		<col width="10%">
		<col width="7.5%">
		<col width="7.5%">
		<col width="15%">
		<col width="20%">
        <col width="20%">
	</colgroup>	 
	<tr class="Header">
		<th nowrap></th>
		<th nowrap><%=labelService.getLabelName("402881ee0c715de3010c7248aaad0072")%><!-- 节点名称--></th>
		<th nowrap><%=labelService.getLabelName("402881ee0c715de3010c724923d40075")%><!-- 节点类型--></th>	
		<th nowrap colspan=2><%=labelService.getLabelName("402881ee0c715de3010c725ffd4b00ae")%><!-- 节点信息--></th>	
		<th nowrap><%=labelService.getLabelName("402881ea0bf9ae97010bf9b5aeb90007")%><!-- 节点操作者--></th>	
		<th nowrap><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450004") %><!-- 触发对象设置 --></th>
		<th nowrap>关联接口</th>
        <th nowrap><!-- <%=labelService.getLabelName("402880ca17576c1d0117576c36820000")%> --><!-- 节点后操作 --></th>
	</tr>	
	<%  if(pageObject.getTotalSize()!=0){
	     nodeinfoList = (List) pageObject.getResult();
	     if (nodeinfoList.size()!=0) {
	   		boolean isLight=false;
			String trclassname="";
			for (int i=0;i<nodeinfoList.size();i++){
			  nodeinfo = (Nodeinfo) nodeinfoList.get(i);
			  isLight=!isLight;
			  if(isLight) trclassname="DataLight";
			  else trclassname="DataDark";	
	     
	%>	
	<tr class="<%=trclassname%>">	
		<td nowrap>
		  <%=labelCustomService.getLabelPicHtml(nodeinfo.getId(), LabelType.Nodeinfo) %>
		</td>
	   <td nowrap>
	     <%=StringHelper.null2String(nodeinfo.getObjname())%>
	   </td>
	   <td nowrap> 
	     <% 
	       String nodename = StringHelper.null2String(nodeinfo.getNodetype());
	       if ("1".equals(nodename))
                nodename = labelService.getLabelNameByKeyId("402881ee0c765f9b010c76779a340007");//开始节点
	       if ("2".equals(nodename))
                nodename = labelService.getLabelNameByKeyId("402881ee0c765f9b010c7679ec06000a");//活动节点
	       if ("3".equals(nodename))
                nodename = labelService.getLabelNameByKeyId("402881ee0c765f9b010c767a6e22000d");//子过程活动节点
 	       if ("4".equals(nodename))
                nodename = labelService.getLabelNameByKeyId("402881ee0c765f9b010c767adf440010");//结束节点                               	      
	     %>
	     <%=nodename%>
	   </td>
        <%if(graphmode.equals("0")){%>
        <td nowrap>
	       <a href="javascript:nodeonCreate('/workflow/workflow/nodeinfomodify.jsp?id=<%=nodeinfo.getId()%>')"><%=labelService.getLabelName("402881e60aa85b6e010aa85f6f3d0002")%><!-- 修改--></a>
	    </td>
	    <td nowrap>
	       <a href="javascript:nodeonDelete('<%=nodeinfo.getId()%>')"><%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%><!-- 删除--></a>
	    </td>
        <%}else{%>
	    <td nowrap colspan="2">
	       <a href="javascript:nodeonCreate('/workflow/workflow/nodeinfomodify.jsp?id=<%=nodeinfo.getId()%>')"><%=labelService.getLabelName("402881e60aa85b6e010aa85f6f3d0002")%><!-- 修改--></a>
	    </td>
	   <%}%>
	   <td nowrap>
	     <a href="javascript:nodeonCreate('/base/security/addpermission.jsp?objid=<%=nodeinfo.getId()%>&&objtable=requestbase&&istype=1&&formid=<%=workflowinfoService.get(workflowid).getFormid()%>')"><%=labelService.getLabelName("402881ea0bf9ae97010bf9b5aeb90007")%><!-- 节点操作者--></a>
	   </td>
       <td nowrap>
           <a href="javascript:onPopup('<%=request.getContextPath()%>/workflow/workflow/subprocesslist.jsp?nodeid=<%=nodeinfo.getId()%>')"><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450004") %><!-- 触发对象设置--></a>
       </td>
       <td nowrap>
           <a href="javascript:nodeonCreate('<%=request.getContextPath()%>/sysinterface/interfacemanager.jsp?objtype=node&objid=<%=nodeinfo.getId()%>')">关联接口</a>
       </td>
       <td>
       </td>   
	</tr>
	
	<%
	  }// end for
	 }// end if 
	 }
	%>	
  </table>   
   
   </form>
  </body>
</html>
