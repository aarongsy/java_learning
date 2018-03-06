<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.category.model.Category"%>
<%@page import="com.eweaver.base.category.service.CategoryService"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestlogService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%@ page import="com.eweaver.workflow.layout.ShowFlow" %>
<%@ page import="com.eweaver.workflow.stamp.model.Stampinfo" %>
<%@ page import="com.eweaver.workflow.stamp.model.Imginfo" %>
<%@ page import="com.eweaver.workflow.stamp.service.StampinfoService" %>
<%@ page import="com.eweaver.workflow.stamp.service.ImginfoService" %>
<%
	FormService fs = (FormService)BaseContext.getBean("formService");
    StampinfoService stampinfoService = (StampinfoService) BaseContext.getBean("stampinfoService");
    CategoryService cs = (CategoryService)BaseContext.getBean("categoryService");
    ImginfoService imginfoService = (ImginfoService) BaseContext.getBean("imginfoService");
	
    String printType = StringHelper.null2String(request.getParameter("printType"));//字段名打印类型：中文，英文，中英文
    String pstyle = StringHelper.null2String(request.getParameter("style"));
    String printLayout = StringHelper.null2String(request.getParameter("printLayout"));
	String layoutid = StringHelper.null2String(request.getParameter("layoutid")).trim();
	String requestid = StringHelper.null2String(request.getParameter("requestid")).trim();
	String categoryid = StringHelper.null2String(request.getParameter("categoryid")).trim();
	String checkbox2 = StringHelper.null2String(request.getParameter("checkbox2"));
	String checkbox1 = StringHelper.null2String(request.getParameter("checkbox1"));
	Category category = cs.getCategoryById(categoryid);
	
	//String[] show = StringHelper.null2String(request.getParameter("show")).trim().split(",");
	
	String isshowlog="0";
	if(checkbox2.equals("2"))
		isshowlog="1";
	String iswfgrf="0";
	if(checkbox1.equals("1"))
		iswfgrf="1";
	String stampinfoid="";
    boolean isstamp=false;
    List listmove=new ArrayList();

	Map workflowparameters = new HashMap();
	workflowparameters.put("bNewworkflow","0");
	workflowparameters.put("requestid",requestid);
	workflowparameters.put("workflowid","");
	workflowparameters.put("nodeid","");
	workflowparameters.put("layoutid",category.getPrintlayoutid());
	workflowparameters.put("categoryid",categoryid);
	workflowparameters.put("formid",category.getPFormid());
    workflowparameters.put("printLayout",printLayout);
    workflowparameters.put("requesthost", " http://" + StringHelper.getRequestHost(request));
    workflowparameters.put("contextpath", request.getContextPath());
	//处理输入参数
	Map initparameters = new HashMap();
	for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
		String pName = e.nextElement().toString().trim();
		String pValue = StringHelper.trimToNull(request.getParameter(pName));
		if(!StringHelper.isEmpty(pName))
			initparameters.put(pName,pValue);
	}
	//处理输入参数完成
			
	
	workflowparameters.put("initparameters",initparameters);

	
	
	//处理创建权限
	
	
	workflowparameters.put("bviewmode","1");
	workflowparameters.put("bView","1");
	workflowparameters.put("bWorkflowform","2");
    workflowparameters.put("printType",printType);
	
	workflowparameters = fs.WorkflowView(workflowparameters);

	String formcontent = StringHelper.null2String(workflowparameters.get("formcontent"));
	String resetdetailformtablescript = StringHelper.null2String(workflowparameters.get("resetdetailformtablescript"));
	

%>
<html>
<head>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/aop.pack.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
    <script type="text/javascript">
       var needformatted=true;
    </script>
    <title><%=labelService.getLabelName("402881ec0bdc2afd010bdd32351a0021")%></title>
    </head>
	<body onload="resetheight();">
	<input type="hidden" value="<%=requestid %>" name="requestid" id="requestid"/>
	<div id="layoutFrame" align="left" style="width:100%">
         <%
         	 out.print(formcontent);
         %>
</body>


<SCRIPT language=JScript>
var tableformatted = false;
      function formatTables() {
          if (needformatted) {
              Ext.each(Ext.query("table[id*='oTable']"), function() {
                  tableformatted = true;
                  formatTable(this);
              });
             
          }
      }
formatTables();
function formatTable(t) {
          if (t.innerHTML.indexOf('oTable') < 0)
              return;
          var datarow ;
          for (i = 0; i < t.rows.length; i++) {
              tablerow = t.rows[i];
              if (tablerow.cells[0] && tablerow.cells[0].firstChild && tablerow.cells[0].firstChild.id && tablerow.cells[0].firstChild.id.indexOf('oTable') == 0) {
                  datarow = t.rows[i];
              }
          }
          if (datarow == null)
              return;
          var rowheight = new Array();
          tablecount = datarow.cells.length;
          rowcount = datarow.cells[0].firstChild.rows.length;
          equalrowcount=0;
          if (rowcount > 10)
              caldelay = 10000;
          for (i = 0; i < rowcount; i++) {
              equalcount = 0;
              for (j = 0; j < tablecount; j++) {
                  otable = datarow.cells[j].firstChild;
                  orows = otable.rows;
                  if (j > 0 && orows[i].clientHeight == datarow.cells[j - 1].firstChild.rows[i].clientHeight)
                      equalcount++
                  if (!rowheight[i])
                      rowheight[i] = orows[i].clientHeight;
                  else if (rowheight[i] < orows[i].clientHeight)
                      rowheight[i] = orows[i].clientHeight;
              }
              if (equalcount == tablecount - 1){
                  equalrowcount++;
              }
          }
          if(equalrowcount==rowcount)
            return;
          for (i = 0; i < datarow.cells.length; i++) {
              otable = datarow.cells[i].firstChild;
              orows = otable.rows;
              for (j = 0; j < orows.length; j++) {
                  orows[j].cells[0].style.height = rowheight[j];
              }
          }
      }
      function resetheight(){ 
		
	  }
</SCRIPT>
</html> 


			