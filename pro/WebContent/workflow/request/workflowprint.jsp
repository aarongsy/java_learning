<%@ page contentType="text/html; charset=UTF-8"%>
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
	WorkflowService ws = (WorkflowService)BaseContext.getBean("workflowService");
	FormService fs = (FormService)BaseContext.getBean("formService");
    NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");
    ExportService exportService = (ExportService)BaseContext.getBean("exportService");
    StampinfoService stampinfoService = (StampinfoService) BaseContext.getBean("stampinfoService");
    ImginfoService imginfoService = (ImginfoService) BaseContext.getBean("imginfoService");
	
    String printType = StringHelper.null2String(request.getParameter("printType"));//字段名打印类型：中文，英文，中英文
    String pstyle = StringHelper.null2String(request.getParameter("style"));
    String printLayout = StringHelper.null2String(request.getParameter("printLayout"));
	String workflowid = StringHelper.null2String(request.getParameter("workflowid")).trim();
	String requestid = StringHelper.null2String(request.getParameter("requestid")).trim();
	String nodeid = StringHelper.null2String(request.getParameter("nodeid")).trim();
	String checkbox2 = StringHelper.null2String(request.getParameter("checkbox2"));
	String checkbox1 = StringHelper.null2String(request.getParameter("checkbox1"));
	
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
	workflowparameters.put("workflowid",workflowid);
	workflowparameters.put("requestid",requestid);
    workflowparameters.put("printLayout",printLayout);
    workflowparameters.put("nodeid",nodeid);
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
	workflowparameters = ws.WorkflowView(workflowparameters);	

	
	
	//处理创建权限
	
	nodeid = StringHelper.null2String(workflowparameters.get("nodeid"));
	workflowid = StringHelper.null2String(workflowparameters.get("workflowid"));
	
	workflowparameters.put("bviewmode","1");
	workflowparameters.put("bWorkflowform","1");
	workflowparameters.put("bView","1");
    workflowparameters.put("printType",printType);
	
	workflowparameters = fs.WorkflowView(workflowparameters);

	String formcontent = StringHelper.null2String(workflowparameters.get("formcontent"));
	String resetdetailformtablescript = StringHelper.null2String(workflowparameters.get("resetdetailformtablescript"));
	
	RequestlogService requestlogService = (RequestlogService)BaseContext.getBean("requestlogService");

	
	StringBuffer hql = new StringBuffer("select wl.operatedate,wl.operatortime, wl.remark, ni.objname ,h.objname,s.objname, rb.requestname,wl.operator");
	hql.append(" from Requestlog wl, Requeststep ws ,Nodeinfo ni,Humres h ,Selectitem s ,Requestbase rb ")
		.append(" where wl.stepid=ws.id and ws.nodeid = ni.id and h.id=wl.operator and s.id = wl.logtype and rb.id=wl.requestid and wl.logtype<>'402881e50c5b4646010c5b5afd170009'")
		.append(" and wl.requestid='").append(requestid).append("' order by wl.operatedate desc,wl.operatortime desc");
	//不打印接收节点logtype=s'402881e50c5b4646010c5b5afd170009'
	List requestlogList = (List) request.getAttribute("requestlogList");
	if (requestlogList == null) {
		requestlogList = requestlogService.getAllRequestlog(hql.toString());
	}
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
	<body onload="resetheight();getstamp()">
	<input type="hidden" value="<%=requestid %>" name="requestid" id="requestid"/>
	<div id="layoutFrame" align="left" style="width:100%">
	
         <%
         	 out.print(formcontent);
             Nodeinfo nodeinfo = nodeinfoService.get(nodeid);
             Stampinfo stampinfo = new Stampinfo();
             if (!StringHelper.isEmpty(requestid) && !StringHelper.isEmpty(nodeid)) {
                 String sql="";
                 if(nodeinfo.getNodetype().equals(1)){
                     sql = " from Stampinfo where 1=2";
                 }else if(nodeinfo.getNodetype().equals(4)){
                     sql = " from Stampinfo where requestid='" + requestid + "'";
                 }else{
                     //******************************得到流向当前节点的所有节点id(start)******************************//
                     String nodeIdStr=ws.getInNodelist(nodeid,"");
                     //******************************得到流向当前节点的所有节点id(end)******************************//
                     List nodeIdList = StringHelper.string2ArrayList(nodeIdStr,",");
                     Iterator it = nodeIdList.iterator();
                     nodeIdStr = "";
                     while(it.hasNext()){
                        String nid = (String)it.next();
                        nodeIdStr += "'"+nid+"',";
                     }
                     nodeIdStr = nodeIdStr+"'"+nodeid+"'";
                     sql = " from Stampinfo where requestid='" + requestid + "' and nodeid in("+nodeIdStr+")";
                 }
                 List list = stampinfoService.getStampinfos(sql);

                 for (int i = 0; i < list.size(); i++) {
                     stampinfo = (Stampinfo) list.get(i);
                          if(nodeid.equals(stampinfo.getNodeid())) {
                              //isstamp=false;
                               stampinfoid=stampinfo.getId();
                          }

                       Imginfo imginfo=new Imginfo();
          if(!StringHelper.isEmpty(stampinfo.getImginfoid())) {
            imginfo=imginfoService.getImginfoDao().getImginfo(stampinfo.getImginfoid());
              Nodeinfo info=nodeinfoService.get(stampinfo.getNodeid());
                     %>
                     <div id="stamp_<%=stampinfo.getNodeid()%>" style='position:absolute;width:200;height:200 ;left:<%=stampinfo.getStampx()%>;top:<%=stampinfo.getStampy()%>; <%if(!StringHelper.isEmpty(info.getStampfield())&&info.getIsstamp()==1){%>display:none<%}%>'>
         <%    if(!StringHelper.isEmpty(imginfo.getAttachid()))%>

        <img src=<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=imginfo.getAttachid()%>&amp;download=1 >
      <%}%>
        </div>
               <%  }}  %>
      <%if(isstamp){
       if(listmove.size()>0){
           ;
     }else{%>
         <div id="stamp_<%=nodeid%>" style='position:absolute;width:200;height:200' onmousedown="MouseDown(this)" onmousemove="MouseMove()" onmouseup="MouseUp()">

        </div>
     <%}}%>

<%
	if("1".equals(isshowlog)){
%>
			
<!----------显示模式1：时间 操作者 操作类型 流转意见--------->

			<center>
			
			       
			<div id="message1"></div>
<%
}
%>
<%
	if(!"1".equals(isshowlog)){
%>
			<div id="message1" style="display: none;"></div>
<%
}
%>
<%
if("1".equals(iswfgrf)){
%>
<div style="WIDTH: 90%;border:0px" align=center><div align=left><%=labelService.getLabelNameByKeyId("402881e50c3b7110010c3b9778e10039") %><!-- 流程图 --></div>
<iframe FRAMEBORDER=0  height="130%" width="100%" scrolling="no" src="/workflow/request/workflowchart.jsp?workflowid=<%=workflowid%>&requestid=<%=requestid%>"></iframe>
</div>
<%	
	}
%>	<br>
  </div>
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

function loadView(vid,cid,_params,_callback){ 
    if(Ext.isEmpty(_params)){
    	_params='';
    }
    var ofg={ url: '/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerAction?action=partview',
	    method:'post',                                   
	    success:function(resp,opt) {
	       document.getElementById(cid).innerHTML=resp.responseText;  
	       if(typeof(_callback)=='function')_callback();
	    },
	    failure:function(resp,opt){ alert('视图模板{'+vid+'}加载错误:'+resp); },
	    params:{where:_params,id:vid}
    };                                   
    Ext.Ajax.request(ofg);
}                                   
//end fun.                                   

Ext.onReady(function(){
	var requestid="<%=requestid %>";
    var arg={mvalue:requestid};
    arg=Ext.encode(arg);
    loadView('402883af3cfa76ed013cfacd1aeb0006','message1',arg);
});

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
		<%=resetdetailformtablescript%>	
} 
  function getstamp(){
                <%
             Stampinfo stampinfo2= new Stampinfo();
             if (!StringHelper.isEmpty(requestid) && !StringHelper.isEmpty(nodeid)) {
                 String sql = " from Stampinfo where requestid='" + requestid + "'";
                 List list23 = stampinfoService.getStampinfos(sql);
                 for (int i = 0; i < list23.size(); i++) {
                     stampinfo2 = (Stampinfo) list23.get(i);
                          if(nodeid.equals(stampinfo2.getNodeid())) {
                               stampinfoid=stampinfo2.getId();
                          }
                        Imginfo imginfo=new Imginfo();
          if(!StringHelper.isEmpty(stampinfo2.getImginfoid())) {
            imginfo=imginfoService.getImginfoDao().getImginfo(stampinfo2.getImginfoid());
       if(!StringHelper.isEmpty(imginfo.getAttachid())){
               Nodeinfo noinfo=nodeinfoService.get(stampinfo2.getNodeid());
       %>
              var obj = document.getElementById('field_<%=noinfo.getStampfield()%>') ;
          if(obj==null){
                  obj=document.getElementById('field_<%=noinfo.getStampfield()%>span') ; //显示布局的多行文本框
             }
               if(typeof(obj)!='undefined'&&obj!=null&&obj!=''){
              obj.parentNode.innerHTML='<div id="stamp_<%=stampinfo2.getNodeid()%>"><img src=<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=imginfo.getAttachid()%>&amp;download=1 ></div>'
                  }
               <%}}  }}  %>

      }
</SCRIPT>
</html> 


			