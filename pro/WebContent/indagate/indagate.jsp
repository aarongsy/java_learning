<%@ page contentType="text/html; charset=UTF-8"%>
<%
String export=StringHelper.null2String(request.getParameter("excelText"));
if(export.equalsIgnoreCase("true")){
	String fname="formbase"+DateHelper.getCurrentDate()+".xls";
	response.setCharacterEncoding("GB2312");
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("content-type","application/vnd.ms-excel");
	response.addHeader("Content-Disposition", "attachment;filename=" + fname);
	request.setAttribute("exportExcel", "true");
}
%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.OptType"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService"%>
<%@ page import="com.eweaver.workflow.request.service.WorkflowService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.dao.FormlinkDao" %>
<%@ page import="com.eweaver.base.log.model.Log" %>
<%@ page import="com.eweaver.base.log.service.LogService" %>
<%@ page import="com.eweaver.workflow.form.model.*" %>
<%@ page import="com.eweaver.cowork.service.CoworksetService" %>
<%@ page import="com.eweaver.cowork.model.Coworkset" %>
<%@ page import="com.eweaver.indagate.service.IndagatecontentService" %>
<%@ page import="com.eweaver.indagate.model.Indagateoption" %>
<%@ page import="com.eweaver.indagate.model.Indagatecontent" %>
<%@ page import="com.eweaver.base.security.util.PermissionUtil2" %>

<%	int pagesize=20;
	//工作流的所有参数列表
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	Map workflowparameters = new HashMap();

    String workflowid = StringHelper.null2String(request.getParameter("workflowid")).trim();
	String id = StringHelper.null2String(request.getParameter("requestid")).trim();
	String nodeid = StringHelper.null2String(request.getParameter("nodeid")).trim();
	String categoryid = StringHelper.null2String(request.getParameter("categoryid")).trim();
    String isapprove = StringHelper.null2String(request.getParameter("isapprove"));

    if(StringHelper.isEmpty(id) && StringHelper.isEmpty(categoryid)){
		%>
		<SCRIPT LANGUAGE="JavaScript">
			top.frames[1].pop('categoryid字段未接收参数，请联系系统管理员。');
			var tabpanel=top.frames[1].contentPanel;
			tabpanel.remove(tabpanel.getActiveTab());
		</SCRIPT>
		<%
		return;
	}

	if(id.equals("del")){
		%>
		<SCRIPT LANGUAGE="JavaScript">
			top.frames[1].pop('删除成功！');
			var tabpanel=top.frames[1].contentPanel;
			tabpanel.remove(tabpanel.getActiveTab());
		</SCRIPT>
		<%
		return;
	}
	BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	//非预览下才判断是否已经投票了
	if(!"0".equals(StringHelper.null2String(request.getParameter("islook")))){
		String sql_check="select distinct requestid from indagatecontent icontent where requestid='"+id+"' and requestid in( select id from formbase fb where fb.isdelete<>1 )";
		String sqlsel_=PermissionUtil2.getPermissionSql2(sql_check,"indagatecontent","6");
		String sqlselrequestid=sqlsel_+" and  icontent.requestid not in(select requestid from indagateremark where creator='"+eweaveruser.getId()+"')";
	    List list_check=baseJdbcDao.getJdbcTemplate().queryForList(sqlselrequestid);
	    if(list_check.size()<=0){
		    String sqlselcreator=sqlsel_+" and '"+currentuser.getId()+"' not in (select creator from indagateremark where requestid=icontent.requestid)";
		    list_check=baseJdbcDao.getJdbcTemplate().queryForList(sqlselcreator);
	    }
	    if(!(list_check!=null && list_check.size()>0)){
	    	%>
	    	<font color="red" size="20">不能重复投票，或投票已过期！</font>
	    	<%
	    	return;
	    }
	}
    FormService fs = (FormService)BaseContext.getBean("formService");
    FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
    FormBaseService fbs = (FormBaseService)BaseContext.getBean("formbaseService");
    CategoryService cs = (CategoryService)BaseContext.getBean("categoryService");
	FormlayoutService fls = (FormlayoutService)BaseContext.getBean("formlayoutService");
    CoworksetService css = (CoworksetService)BaseContext.getBean("coworksetService");
	Category category = cs.getCategoryById(categoryid);
    ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
    String objtablea=forminfoService.getForminfoById(category.getFormid()).getObjtablename();
    PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
     IndagatecontentService indagatecontentService = (IndagatecontentService) BaseContext.getBean("indagatecontentService");
	String msg = StringHelper.null2String(request.getParameter("msg")).trim();

	if(StringHelper.isEmpty(id) && category!=null){//唯一性校验
		Forminfo forminfo = forminfoService.getForminfoById(category.getPFormid());
		String uniquefliter=category.getPUniquefliter();

		if(!StringHelper.isEmpty(uniquefliter)){
			String [] fliterobj=new String[1];
			String [] valueobj=new String[1];
			String uniquevalue="";

			fliterobj = StringHelper.string2Array(uniquefliter,",");
			for(int i=0; i<fliterobj.length; i++){
				uniquevalue += ","+StringHelper.null2String(request.getParameter(fliterobj[i])).trim();
			}
			valueobj = StringHelper.string2Array(uniquevalue,",");

			id = cs.getUniqueRequestId(forminfo.getObjtablename(),fliterobj,valueobj);
		}
	}

	workflowparameters.put("workflowid",workflowid);
	workflowparameters.put("requestid",id);
	workflowparameters.put("nodeid",nodeid);

	String bNewworkflow = "1"; //是否新建表单
	if(!StringHelper.isEmpty(id)){
		bNewworkflow = "0";
        if(StringHelper.isEmpty(categoryid)){
        categoryid=fbs.getFormBaseById(id).getCategoryid();
        category=cs.getCategoryById(categoryid);
        }
    }
	workflowparameters.put("bNewworkflow",bNewworkflow);
	Forminfo forminfo = forminfoService.getForminfoById(category.getPFormid());
    String initparameterstr=null;
    JSONObject jsonObject=new JSONObject();
    Map initparameters = new HashMap();
	for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
		String pName = e.nextElement().toString().trim();
		String pValue = StringHelper.trimToNull(request.getParameter(pName));
		if(!StringHelper.isEmpty(pName)){
			initparameters.put(pName,pValue);
            if(!StringHelper.isEmpty(pValue))
            jsonObject.put(pName,pValue);

        }
    }
    initparameterstr=jsonObject.toString();
	workflowparameters.put("initparameters",initparameters);
	//处理输入参数完成

	workflowparameters.put("bviewmode","1");

	String bView = "0";
	String editmode = StringHelper.null2String(request.getParameter("editmode"));
	if(StringHelper.isEmpty(editmode))
		editmode = "0";

	if(bNewworkflow.equals("1")){
		boolean isauth = permissiondetailService.checkOpttype(categoryid, 2);
		if(!isauth){
			response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
			return;
		}
        workflowparameters.put("bviewmode","2");
    }


	//新建文档的ｔａｒｇｅｔｕｒｌ
	String targeturlfordoc = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=addrefdoc&docid=";



	int righttype = 0;
	String objid = id;
	String objtable = forminfo.getObjtablename();

	if (!StringHelper.isEmpty(objid)) {
        boolean opttype = permissiondetailService.checkOpttype(id, OptType.VIEW);
        if (!opttype) {
            response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
            return;
        }
        righttype = permissiondetailService.getOpttype(objid);
	}



	int canedit = 0;
    if(righttype%15 == 0){
		canedit = 1;
	}
	if(editmode.equals("1")&&canedit!=1){
			response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
			return;
	}



	if(editmode.equals("1")&&canedit==1){
        workflowparameters.put("bviewmode","2");
        bView = "0";
    }




    workflowparameters.put("bView",bView);
	workflowparameters.put("bWorkflowform","2");
    String formid="";
    if( category.getPFormid()!=null && !"".equals(category.getPFormid())){
        formid=category.getPFormid();
        workflowparameters.put("formid",formid);
    }
	String layoutid="";
    int notifyclose=0;
    if(bNewworkflow.equals("1")){
        List layoutlist = fls.getOptLayoutList(category.getId(), OptType.CREATE);
        for (Object layout : layoutlist) {
            if(layout==null)
            continue;
            if (fls.getFormlayoutById((String) layout).getTypeid() == 2)
                layoutid = fls.getFormlayoutById((String) layout).getId();
            break;
        }
        if (StringHelper.isEmpty(layoutid))
            layoutid = category.getPCreatelayoutid();
        workflowparameters.put("layoutid",layoutid);
         notifyclose=1;
    }else if(editmode.equals("1")){
		List layoutlist = fls.getOptLayoutList(id,OptType.MODIFY);
		for (Object layout : layoutlist) {
            if(layout==null)
            continue;
            if (fls.getFormlayoutById((String) layout).getTypeid() == 2)
                layoutid = fls.getFormlayoutById((String) layout).getId();
            break;
        }
        if (StringHelper.isEmpty(layoutid))
            layoutid = category.getPEditlayoutid();
        workflowparameters.put("layoutid",layoutid);
        notifyclose=1;
	}else{
		List layoutlist = fls.getOptLayoutList(id,OptType.VIEW);
		for (Object layout : layoutlist) {
            if(layout==null)
            continue;
            if (fls.getFormlayoutById((String) layout).getTypeid() == 1)
                layoutid = fls.getFormlayoutById((String) layout).getId();
            break;
        }
        if (StringHelper.isEmpty(layoutid))
            layoutid = category.getPViewlayoutid();
        workflowparameters.put("layoutid",layoutid);
    }
    workflowparameters = fs.WorkflowView(workflowparameters);
    layoutid = StringHelper.null2String(workflowparameters.get("layoutid"));
	String needcheckfields = StringHelper.null2String(workflowparameters.get("needcheck"));
	String formcontent = StringHelper.null2String(workflowparameters.get("formcontent"));
	if(export.equalsIgnoreCase("true")){//截断之后的数据.
		formcontent=formcontent.replaceAll("<script.*>(\\n|\\r|.)*</script>","");
		formcontent=formcontent.replaceAll("<TABLE","<TABLE border=\"1\" ");
		//int pos1=formcontent.indexOf("<TABLE");
		//int pos2=formcontent.lastIndexOf("</FIELDSET>");
		//formcontent=formcontent.substring(pos1,pos2);
		formcontent=formcontent.substring("<LINK href=\"/css/eweaver.css\" type=text/css rel=STYLESHEET>".length());
		out.println("<style type=\"text/css\">.FieldName{text-align:right;}");
		out.println(".FieldValue{text-align:left;}</style>");
		out.println(formcontent);
		//System.out.println("excelTexdddt:"+formcontent);
		return;
	}

	String fieldcalscript = StringHelper.null2String(workflowparameters.get("fieldcalscript"));
    String onaddrowscript = StringHelper.null2String(workflowparameters.get("onaddrowscript"));
    String triggercalscript=StringHelper.null2String(workflowparameters.get("triggercalscript"));
    String resetdetailformtablescript = StringHelper.null2String(workflowparameters.get("resetdetailformtablescript"));
    String ufscript=StringHelper.null2String(workflowparameters.get("ufscript"));
    String directscript=StringHelper.null2String(workflowparameters.get("directscript"));
    FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
    String categoryfield="";
            if (!StringHelper.isEmpty(formid)) {
                List<Formfield> fields = formfieldService.getAllFieldByFormId(formid);
                for(Formfield field:fields){
                    if(field.getFieldname().equalsIgnoreCase("categoryid")){
                       categoryfield="field_"+field.getId();
                        break;
                    }
                }
            }
    //交流区
            boolean hasCommunicationZone=false;
            boolean notifyonreply=false;
            boolean showunread=false;
            String enddatefield="";
            String membersfield="";
            String subjectfield="";
            String communicationFormid="";
            String storefields= null;
            String tabs= null;
            if (!bNewworkflow.equals("1")&&!editmode.equals("1")) {
                int formtype = forminfo.getObjtype().intValue();
                FormlinkDao formlinkDao = (FormlinkDao) BaseContext.getBean("formlinkDao");
                if (formtype == 1) {
                    String strHql = "from Formlink where oid='" + formid + "' order by pid";
                    List list = formlinkDao.findFormlink(strHql);
                    for (int i = 0; i < list.size(); i++) {
                        Formlink formlink = (Formlink) list.get(i);
                        String pid=formlink.getPid();
                        Forminfo pform=forminfoService.getForminfoById(pid);
                        if(pform!=null&&pform.getId()!=null){
                            if(StringHelper.null2String(pform.getCol1()).equals("1")){
                               Formlayout formlayout = formlayoutService.getLayoutInfo(layoutid, formid, null,null,null,null);
                               if(formlayout.getLayoutformatted().indexOf("div"+pform.getId())>0){
                               hasCommunicationZone=true;
                               communicationFormid=pform.getId();
                               }
                            }
                        }
                        List<Coworkset> setlist=css.searchBy("from Coworkset where formid='"+pid+"'");
                        if (setlist.size() > 0) {
                            Coworkset coworkset = setlist.get(0);
                            enddatefield = StringHelper.null2String(coworkset.getEnddate());
                            membersfield = StringHelper.null2String(coworkset.getMembers());
                            subjectfield=StringHelper.null2String(coworkset.getSubject());
                            if (!membersfield.equals("")) {
                                if (coworkset.getShowunread() != null && coworkset.getShowunread().intValue()==1) {
                                    showunread=true;
                                }
                                if (coworkset.getReplynotify() != null && coworkset.getReplynotify().intValue() == 1) {
                                    notifyonreply = true;
                                }
                            }
                        }
                    }
                }
                 }
                //communication data prepare
                storefields = "";
                String replytplstr="";
                String replytplth="";
                String replytpltd="";
                String params="";
                String functionbody="";
                tabs = "";
                if(hasCommunicationZone){
               List<Formfield> communicationFields=formfieldService.getAllFieldByFormId(communicationFormid);
                   for(Formfield f:communicationFields){
                       storefields+=",'"+f.getFieldname()+"'";
                       if(f.getHtmltype()==6||f.getHtmltype()==7){
                           replytplth+="<th>"+f.getLabelname()+"<th>";
                           replytpltd+="<td>{"+f.getFieldname()+"}<th>";
                           if(!params.equals("")){
                               params+=","+f.getFieldname();
                               functionbody+="||!Ext.isEmpty("+f.getFieldname()+")";
                           }
                           else{
                               params+=f.getFieldname();
                               functionbody+="!Ext.isEmpty("+f.getFieldname()+")";
                           }

                           //add tab
                          tabs+=",\n" +
    "                new Ext.Panel({\n" +
    "                    title:'"+f.getLabelname()+"',\n" +
    "                    autoScroll:true,\n" +
    "                    listeners:{'activate':function(){\n" +
    "                        refobjstore.baseParams={action:'getrefobj',field:'"+f.getFieldname()+"',requestid:'"+id+"',formid:'"+communicationFormid+"'};\n" +
    "                        refobjstore.load();\n" +
    "                    }\n" +
    "                    },\n" +
    "                    items: new Ext.DataView({\n" +
    "                            store: refobjstore,\n" +
    "                            tpl: new Ext.XTemplate(\n" +
    "                '<tpl for=\".\">',\n" +
    "                '<p>{"+f.getFieldname()+"}</p>',\n" +
    "                '</tpl>'\n" +
    "                ),\n" +
    "                            autoHeight:true,\n" +
    "                            multiSelect: true,\n" +
    "                            overClass:'x-view-over',\n" +
    "                            itemSelector:'div.thumb-wrap',\n" +
    "                            emptyText: '没有数据显示'\n" +
    "                        })\n" +
    "                })";
                       }


                   }
                }
                if(!replytplth.equals("")){
            replytplstr+=",'<tpl if=\"this.hasRefobj("+params+")\">'," ;
                replytplstr+="'<table><tr>"+replytplth+"</tr><tr>"+replytpltd+"</tr></table>',";
                replytplstr+="'</tpl>',";
                replytplstr+="{hasRefobj:function ("+params+"){return "+functionbody+"}}";
                }

            //log
            if (hasCommunicationZone) {
                LogService logService = (LogService) BaseContext.getBean("logService");
                Log log = new Log();
                log.setIsdelete(0);
                log.setLogdesc("操作日志");
                log.setLogtype("402881e40b6093bf010b60a5849c0007");
                log.setMid("");
                log.setObjid(id);
                log.setObjname(forminfo.getObjtablename());
                log.setSubmitdate(DateHelper.getCurrentDate());
                log.setSubmittime(DateHelper.getCurrentTime());
                log.setSubmitor(eweaveruser.getId());
                log.setSubmitip(eweaveruser.getRemoteIpAddress());
                logService.createLog(log);
            }

        %>

<%
//页面菜单
		pagemenustr += "addBtn(tb,'提交','S','accept',function(){onSubmit(1)});";
    String formidstr1 = StringHelper.null2String(category.getFormid());
    Forminfo forminfostr1 = forminfoService.getForminfoById(formidstr1);
    String objtablestr1 = forminfostr1.getObjtablename();
    String sql1 = "select anonymityfield  from indagateformset where formid='" + formidstr1 + "'";
    List listfield1 = baseJdbcDao.getJdbcTemplate().queryForList(sql1);
    String objnamefield1 = ((Map) listfield1.get(0)).get("anonymityfield") == null ? "" : ((Map) listfield1.get(0)).get("anonymityfield").toString();
    String fieldname1 = formfieldService.getFormfieldById(objnamefield1).getFieldname();
    String sqlse11 = "select " + fieldname1 + " from " + objtablestr1 + " where requestid='" + id + "'";
    List listsel1 = baseJdbcDao.getJdbcTemplate().queryForList(sqlse11);
    String isanonymity=((Map) listsel1.get(0)).get(fieldname1) == null ? "" : ((Map) listsel1.get(0)).get(fieldname1).toString();
    if(!StringHelper.isEmpty(isanonymity)&&isanonymity.equals("1")){
        pagemenustr += "addBtn(tb,'匿名提交','T','accept',function(){onSubmit(2)});";

    }
    //投票预览
    if("0".equals(StringHelper.null2String(request.getParameter("islook")))){
    	pagemenustr="";
    }
      String formidstrview = StringHelper.null2String(category.getFormid());
    Forminfo forminfostrview = forminfoService.getForminfoById(formidstrview);
    String objtablestrview = forminfostrview.getObjtablename();
    String sqlview = "select viewresultfield  from indagateformset where formid='" + formidstrview + "'";
    List listfieldview= baseJdbcDao.getJdbcTemplate().queryForList(sqlview);
    String objnamefieldview = ((Map) listfieldview.get(0)).get("viewresultfield") == null ? "" : ((Map) listfieldview.get(0)).get("viewresultfield").toString();
    String fieldnameview = formfieldService.getFormfieldById(objnamefieldview).getFieldname();
    String sqlse1view = "select " + fieldnameview + " from " + objtablestrview + " where requestid='" + id + "'";
    List listselview = baseJdbcDao.getJdbcTemplate().queryForList(sqlse1view);
    String isviewresultfield=((Map) listselview.get(0)).get(fieldnameview) == null ? "" : ((Map) listselview.get(0)).get(fieldnameview).toString();
%>
<html>
  <head>
    <title>调查信息</title>
	  <!--
      <OBJECT classid=CLSID:CBD79B8A-7975-4DD7-AF00-7E5ED70F7485
        codebase="<%=request.getContextPath()%>/activex/WeaverOcx.CAB#version=2,0,0,0" id="filecheck" style="display:none">
      </OBJECT>
	  -->
        <script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
    <script src='<%=request.getContextPath()%>/dwr/interface/FormbaseService.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
	<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
	<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
      <script  type='text/javascript' src='<%=request.getContextPath()%>/js/workflow.js'></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajax.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/chart/fusionchart/FusionCharts.js"></script>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
</style>
<script type="text/javascript"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/aop.pack.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css" />
<script type="text/javascript" language="javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/CKEditorExt.js"></script>
<style>
        .x-toolbar table {width:0}
     #pagemenubar table {width:0}
       .x-panel-btns-ct {
         padding: 0px;
     }
     .x-panel-btns-ct table {width:0}
    a { color:blue; cursor:pointer; }

</style>
<script type="text/javascript">
      Ext.onReady(function() {
       Ext.QuickTips.init();
   <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
   <%=pagemenustr%>
   <%}%>
      });
</script>
  </head>
  <body>
<div id="divsum" >
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.FormAction" target="_self" enctype="multipart/form-data"  name="EweaverForm"  id="EweaverForm"  method="post" >

    <div id="pagemenubar"></div>
<!--页面菜单结束-->
<%
	if(!StringHelper.isEmpty(msg)){
%>
<DIV><font color=red><%=StringHelper.getDecodeStr(msg)%></font></div>
<%}%>

<input type="hidden" name="action" value="createformbase">
<input type="hidden" name="targetUrl">
<input type="hidden" name="workflowid" value="<%=workflowid%>">
<input type="hidden" name="formid" value="<%=category.getPFormid()%>">
<input type="hidden" name="categoryid" value="<%=categoryid%>">
<input type="hidden" name="layoutid" value="<%=layoutid%>">
<input type="hidden" name="creator" value="<%=currentuser.getId()%>">
<input type="hidden" name="requestid" value="<%=id%>">
<input type="hidden" name="nodeid" value="<%=nodeid%>">
<input type="hidden" name="subnew"  id="subnew" value=""/>

<input type="hidden" name="editmode" value="<%=editmode%>">
<input type="hidden" name="canedit" value="<%=canedit%>">
<input type="hidden" name="currentuserid" value="<%=currentuser.getId()%>">
<input type="hidden" name="bNewworkflow" value="<%=bNewworkflow%>">
<input type="hidden" name="initparameterstr" value='<%=initparameterstr%>'>
  <input type="hidden" name="notifyclose" id="notifyclose" value='<%=notifyclose%>'>
    <table class=noborder>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
	</table>
<%=formcontent%>
    <br>
    <TABLE width=100% height=100% border="1" cellspacing="0">
        <colgroup>
            <col width="10">
            <col width="">
            <col width="10">
        <tr>
            <td height="10" colspan="3"></td>
        </tr>
        <tr>
            <td></td>
            <td valign="top">
                <TABLE class=Shadow>
                    <tr>
                        <td valign="top">
                            <table class=form>
                                <col width=15%>
                                <col width=35%>
                                <col width=15%>
                                <col width=35%>
                                <TR class=separator>
                                    <TD class=Sep1 colSpan=4></TD>
                                </TR>
                                <tr>
                                    <td colspan=4 align=center>
                                        <font size=5 color=blue>
                                        <%
                                        String formidstr=StringHelper.null2String(category.getFormid());
                                         Forminfo forminfostr=forminfoService.getForminfoById(formidstr);
                                            String objtablestr=forminfostr.getObjtablename();
                                         String sql="select objnamefield from indagateformset where formid='"+formidstr+"'";
                                           List listfield= baseJdbcDao.getJdbcTemplate().queryForList(sql);
                                            String objnamefield = ((Map) listfield.get(0)).get("objnamefield") == null ? "" : ((Map) listfield.get(0)).get("objnamefield").toString();
                                             String fieldname=formfieldService.getFormfieldById(objnamefield).getFieldname();
                                            String sqlsel="select "+fieldname+" from "+objtablestr+" where requestid='"+id+"'";
                                            List listsel=baseJdbcDao.getJdbcTemplate().queryForList(sqlsel);
                                        %>
                                            <%=((Map) listsel.get(0)).get(fieldname) == null ? "" : ((Map) listsel.get(0)).get(fieldname).toString()%>
                                        </font>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan=4>
                                      
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan=2></td>
                                </tr>
                            </table>

                            <table class=ListShort>
                                <col width=25%>
                                <col width=55%>
                                <col width=10%>
                                <col width=10%>
                                <TR class=separator>
                                    <TD class=Sep1 colSpan=4></TD>
                                </TR>
                            </table>

                            <table class=ListShort>
                                <%
                                List<Map<String,Object>> liststr=baseJdbcDao.executeSqlForList("select * from Indagatecontent where requestid='"+id+"' and isdelete !=1 order by ordernum asc");
                                    for(int i=0;i<liststr.size();i++){
                                    	Map<String,Object> imap=liststr.get(i);
                                            String typestr="";
                                           if(NumberHelper.string2Int(imap.get("optiontype"),0)==1){
                                                typestr="radio";
                                           }else{
                                              typestr="checkbox";
                                           }
                                %>
                                <tr class=datalight>
                                    <td>
                                        <b><%=StringHelper.null2String(imap.get("objsubject"))%></b>

                                    </td>
                                </tr>
                                      <%
                                        int count=0;
                                        // 进行排序处理
                                        DataService ds = new DataService(); 
                                        List<Map<String,Object>> optionlist=ds.getValues("select * from indagateoption where contentid='"+StringHelper.null2String(imap.get("id"))+"' order by dsorder asc");
                                        for(Map<String,Object> option:optionlist){
                                        if(!StringHelper.isEmpty(StringHelper.null2String(option.get("objvalue")))){
                                        	count++;
                                      %>
                                <tr class=datadark>
                                    <td>
                                    <%=count%>,<input type="<%=typestr%>" name="<%=StringHelper.null2String(imap.get("id"))%>" id="<%=StringHelper.null2String(imap.get("id"))%>" value="<%=StringHelper.null2String(option.get("id"))%>" onclick="typeclick(this)"><%=StringHelper.null2String(option.get("objvalue"))%>
                                    </td>
                                </tr>
                                 <%}}%>
                                <%if(NumberHelper.string2Int(imap.get("isotherinput"), 0)==0){%>
                                 <tr style="display:none">
                                     <%}else{%>
                                     <tr class=datadark>
                                   <%}%>
                                    <td >
                                      <%=count+1%>,<input type="<%=typestr%>" name="<%=StringHelper.null2String(imap.get("id"))%>" value="<%=StringHelper.null2String(imap.get("id"))%>othervalue" onclick="otherclick(this)">其他：<input type="text" class="InputStyle2" style="width:20%;visibility:hidden" id="<%=StringHelper.null2String(imap.get("id"))%>othervalue" name="<%=StringHelper.null2String(imap.get("id"))%>othervalue">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <%}%>
                            </table>

                            <br>
                            <table class=form width="100%">
                                <tr>
                                    <td width=10% valign=top>意见</td>
                                        <td width=90% class=field>
                                            <textarea name="iremark" id="iremark" class="inputStyle"
                                                style="width: 90%" rows=5></textarea>
                                        </td>
                                    </tr>
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

<input type="hidden" name="tmpvalue" id="tmpvalue" value="">
  </form>
  </div>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
  </body>
</html>
  <script language="javascript">

      var jq = jQuery.noConflict();
      var win;
      function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
          if(document.getElementById(inputname.replace("field","input"))!=null)
       document.getElementById(inputname.replace("field","input")).value="";
      var fck=param.indexOf("function:");
          if(fck>-1){}else{
              var param = parserRefParam(inputname,param);
          }
      var idsin = document.getElementsByName(inputname)[0].value;
           var url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
                url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
            }
      var id;
      if(Ext.isIE){
      try{

      id=openDialog(url);
      }catch(e){return}
      if (id!=null) {
      if (id[0] != '0') {
          document.all(inputname).value = id[0];
          document.all(inputspan).innerHTML = id[1];
            if(fck>-1){
            funcname=param.substring(9);
        scripts="valid="+funcname+"('"+id[0]+"');";
          eval(scripts) ;
          if(!valid){  //valid默认的返回true;
           document.all(inputname).value = '';
          if (isneed=='0')
          document.all(inputspan).innerHTML = '';
          else
          document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
            }
            }
      }else{
          document.all(inputname).value = '';
          if (isneed=='0')
          document.all(inputspan).innerHTML = '';
          else
          document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

              }
           }
      }else{
      url='<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;

      var callback = function() {
              try {
                  id = dialog.getFrameWindow().dialogValue;
              } catch(e) {
              }
              if (id != null) {
                  if (id[0] != '0') {
                      document.all(inputname).value = id[0];
                      document.all(inputspan).innerHTML = id[1];
                      if (fck > -1) {
                          funcname = param.substring(9);
                          scripts = "valid=" + funcname + "('" + id[0] + "');";
                          eval(scripts);
                          if (!valid) {  //valid默认的返回true;
                              document.all(inputname).value = '';
                              if (isneed == '0')
                                  document.all(inputspan).innerHTML = '';
                              else
                                  document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
                          }
                      }
                  } else {
                      document.all(inputname).value = '';
                      if (isneed == '0')
                          document.all(inputspan).innerHTML = '';
                      else
                          document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

                  }
              }
          }
          if (!win) {
               win = new Ext.Window({
                  layout:'border',
                  width:Ext.getBody().getWidth()*0.8,
                  height:Ext.getBody().getHeight()*0.8,
                  plain: true,
                  modal:true,
                  items: {
                      id:'dialog',
                      region:'center',
                      iconCls:'portalIcon',
                      xtype     :'iframepanel',
                      frameConfig: {
                          autoCreate:{ id:'portal', name:'portal', frameborder:0 },
                          eventsFollowFrameLinks : false
                      },
                      closable:false,
                      autoScroll:true
                  }
              });
          }
          win.close=function(){
                      this.hide();
                      win.getComponent('dialog').setSrc('about:blank');
                      callback();
                  } ;
          win.render(Ext.getBody());
          var dialog = win.getComponent('dialog');
          dialog.setSrc(url);
          win.show();
      }
      }
      function  newrefobj(inputname,inputspan,doctype,viewurl,isneed,docdir){
          params = ""
          targeturl = "<%=URLEncoder.encode(targeturlfordoc, "UTF-8")%>"
         //params = getRefobjParams(inputname,doctype) ;
          var id;
          try{
              id = openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/document/base/docbasecreate.jsp?categoryid="+docdir+"&doctypeid="+doctype+params+"&targetUrl="+targeturl,"dialogHeight:"+screen.availHeight+"px;dialogWidth:"+screen.availWidth+"px; center: Yes; help: No; resizable: yes; status: No");

          }catch(e){return}
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
      var needchecklists = "<%=needcheckfields%>";
      var id = "<%=StringHelper.null2String(id)%>";
      var workflowid = "<%=StringHelper.null2String(workflowid)%>";
      var nodeid = "<%=StringHelper.null2String(nodeid)%>";

  </script>
<script language="javascript">
        //*************************简易Javascript Map(start)*************************//
    var objectKey = new Array(100);
    var objectValue = new Array(100);
    var timevalue = "";
    function getMapValue(key){
        for(var i=0;i<objectKey.length;i++){
            if(objectKey[i]==key){
                timevalue = objectValue[i];
            }
        }
    }
    //*************************简易Javascript Map(end)*************************//

    //*************************页面加载后将$currenttime$字段的值放置在MAP中保存起来(start)*************************//
	<%
	List list = formlayoutService.findFormlayoutfieldByLayoutid(layoutid);
	Map map = new HashMap();
	for (int i = 0; i < list.size(); i++) {
		Formlayoutfield formlayoutfield = (Formlayoutfield) list.get(i);
		if("$currenttime$".equals(formlayoutfield.getFormula()==null?"":formlayoutfield.getFormula().trim())){
    %>
        if(document.all("field_<%=formlayoutfield.getFieldname()%>")!=null){
            objectKey[<%=i%>]="field_<%=formlayoutfield.getFieldname()%>";
            objectValue[<%=i%>]=document.all("field_<%=formlayoutfield.getFieldname()%>").value;
        }else{
            var i=0;
            while(document.all("field_<%=formlayoutfield.getFieldname()%>_"+i)!=null){
                objectKey[<%=i++%>]="field_<%=formlayoutfield.getFieldname()%>_"+i;
                objectValue[<%=i++%>]=document.all("field_<%=formlayoutfield.getFieldname()%>_"+i).value;
                i++;
            }
        }
    <%
        }
	}%>
    //*************************页面加载后将$currenttime$字段的值放置在MAP中保存起来(end)*************************//

    function onEdit(){
    window.location="<%=request.getContextPath()%>/indagate/indagatemodify.jsp?editmode=1&categoryid=<%=categoryid%>&requestid=<%=id%>";
}
function onDelete(link){
	delmessage="<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>";
	if(confirm(delmessage)){
		document.all("action").value="deleteformbase";
		document.all("targetUrl").value=link;
		document.EweaverForm.submit();
	}
}
function onSubmit(isanonymity){
    var selected = new Array();
    <%
    List listlen= indagatecontentService.getAllIndagatecontent(id);
    if(listlen==null){
    	listlen = new ArrayList();
    }
    for(int i=0;i<listlen.size();i++){
    %>
    var selcontentid<%=i%>=new Array();
    var selectedother<%=i%>=new Array();
    <%}%>
    <%
    for(int i=0;i<listlen.size();i++){
        Indagatecontent content=(Indagatecontent)listlen.get(i);
    %>
    var length=document.all('<%=content.getId()%>').length;
    for(var j=0;j<length;j++){
        var content=document.all('<%=content.getId()%>');
        if(content[j].checked){
            selcontentid<%=i%>.push('<%=content.getId()%>');
            selected.push(content[j].value);
        }
    }
  <%}%>
    <%
    for(int i=0;i<listlen.size();i++){
    	Indagatecontent content=(Indagatecontent)listlen.get(i);
    %>
    if(selcontentid<%=i%>.length<=0){
        alert('请填写信息完整！！');
        return;
    }
    <%
    if(NumberHelper.string2Int(content.getOptiontype(),0)==2){//复选框
    	if(NumberHelper.string2Int(content.getMinoption(),0)>0){
    		%>
    		if(selcontentid<%=i%>.length<<%=NumberHelper.string2Int(content.getMinoption(),0)%>){
		        alert('<%=content.getObjsubject()%>多选选择范围不能小于设置最小范围<%=content.getMinoption()%>项！');
		        return;
		    }
    		<%
    	}
    
        if(NumberHelper.string2Int(content.getMaxoption(),0)>0){
    		%>
    		if(selcontentid<%=i%>.length><%=NumberHelper.string2Int(content.getMaxoption(),0)%>){
		        alert('<%=content.getObjsubject()%>多选选择范围不能大于设置最大范围<%=content.getMaxoption()%>项！');
		        return;
		    }
    		<%
    	}
    }
    }%>
    if(Ext.getCmp('S')){
    	Ext.getCmp('S').disable();
    }
    if(Ext.getCmp('T')){
    	Ext.getCmp('T').disable();
    }
    var str;
    for(var i=0;i<selected.length;i++){
        if(selected[i].indexOf('othervalue')>-1){
           if(str==null){
               str =selected[i]+':'+document.all(selected[i]).value;
           }else{
                 str +=','+selected[i]+':'+document.all(selected[i]).value;
           }
        }
    }
   var iremark=document.all('iremark').value;
    Ext.Ajax.request({
        url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.indagate.servlet.IndagateAction?action=vote',
        params:{
            ids:selected.toString(),iremark:iremark,requestid:'<%=id%>',str:str,isanonymity:isanonymity
        },
        success: function() {
            <%
           if(StringHelper.isEmpty(isviewresultfield)){
            %>
               alert("投票成功！");
               //没有权限查看结果
               window.close();
            <%}else{%>
            alert("投票成功！");
            //有权限查看结果
            window.location.href='<%=request.getContextPath()%>/indagate/indagateview.jsp?requestid=<%=id%>&categoryid=4028803523cacb540123caff02a50012';
            <%}%>
        }
    });

}

     function SQL(param){
				param = encode(param);

				if(strSQLs.indexOf(param)!=-1){
					var retval = getValidStr(strValues[strSQLs.indexOf(param)]);
					return retval;

				}else{
                    var _url= "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.DataAction?sql="+param;
                    var retval;
                    Ext.Ajax.request({
                        url:_url,
                        sync:true,
                        success: function(res) {
                                  var doc=res.responseXML;
                                  var root = doc.documentElement;
                            retval = getValidStr(root.text);
                            strSQLs.push(param);
                            strValues.push(retval);
                        }
                    });
					return retval;
				}
			}
  function onCal(){
		try{

			var rowindex = 0;
		<%=fieldcalscript%>


			function SUM(param){
				var result = 0;
				for(index=0;index<rowindex;index++){
					tmpval = 0;
					try{
					tmpval = eval(param)*1;
					}catch(e){
					tmpval = 0;
					}
					//alert(tmpval);
					result += tmpval;
				}
				rowindex = 0;
				return result;
			}

			function RMB(param){
				var tmpval = eval(param)*1;
				var result =  convertCurrency(tmpval);
				return result;
			}
			function COUNT(param){
				var result = 0;
				for(index=0;index<rowindex;index++){
					tmpval = 0;
					try{
					tmpval = eval(param)*1;
					}catch(e){
					tmpval = 0;
					}
					if(tmpval != 0)
						result ++;
				}
				rowindex = 0;
				return result;
			}
			function PROD(param){
				var result = 1;
				for(index=0;index<rowindex;index++){
					tmpval = 1;
					try{
					tmpval = eval(param)*1;
					}catch(e){
					tmpval = 1;
					}
					//alert(tmpval);
					result = result * tmpval;
				}
				rowindex = 0;
				return result;
			}
			function MAX(param){
				var result = 0;
				for(index=0;index<rowindex;index++){
					tmpval = 0;
					try{
					tmpval = eval(param)*1;
					}catch(e){
					tmpval = 0;
					}
					if(tmpval > result)
						result = tmpval;
				}
				rowindex = 0;
				return result;
			}



		}catch(e){}
}
    function otherclick(obj){
        if(obj.checked){
            document.all(obj.name+'othervalue').style.visibility = "visible";         
        }else{
            document.all(obj.name+'othervalue').style.visibility = "hidden";

        }

    }
    function typeclick(obj){
        if(obj.type=='radio'){
        if(obj.checked){
            document.all(obj.name+'othervalue').value="";
             document.all(obj.name+'othervalue').style.visibility = "hidden";
        } }
    }
    
</script>



