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
			top.frames[1].pop('<%=labelService.getLabelNameByKeyId("402883d934c103480134c10348df0000") %>');//categoryid字段未接收参数，请联系系统管理员。
			var tabpanel=top.frames[1].contentPanel;
			tabpanel.remove(tabpanel.getActiveTab());
		</SCRIPT>
		<%
		return;
	}

	if(id.equals("del")){
		%>
		<SCRIPT LANGUAGE="JavaScript">
			//top.frames[1].pop('删除成功！');
		</SCRIPT>
		<br>
		<br>
		<br>
		<br>
		<center>
		<table style="width:60%">
		<tr><td style="color:red;background-color:#D7D7D7;font-size:14;" align=center>
		<%=labelService.getLabelNameByKeyId("402883d934c104cb0134c104cc3e0000") %><!-- 数据删除成功！ -->
		</td>
		</tr>
		</table>
		<%
			
		return;
	}

    FormService fs = (FormService)BaseContext.getBean("formService");
    FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
    FormBaseService fbs = (FormBaseService)BaseContext.getBean("formbaseService");
    CategoryService cs = (CategoryService)BaseContext.getBean("categoryService");
	FormlayoutService fls = (FormlayoutService)BaseContext.getBean("formlayoutService");
    CoworksetService css = (CoworksetService)BaseContext.getBean("coworksetService");
	Category category = cs.getCategoryById(categoryid);

    ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");

    PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");

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
            if (fls.getFormlayoutById((String) layout).getTypeid() == 2){
                layoutid = fls.getFormlayoutById((String) layout).getId();
                break;
            }
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
            if (fls.getFormlayoutById((String) layout).getTypeid() == 2){
                layoutid = fls.getFormlayoutById((String) layout).getId();
                break;
            }
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
            if (fls.getFormlayoutById((String) layout).getTypeid() == 1){
                layoutid = fls.getFormlayoutById((String) layout).getId();
                break;
            }
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
                        List<Coworkset> setlist=css.searchBy("from Coworkset where formid='"+pid+"' and createlayout is null and editlayout is null");
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
    "                            emptyText: '"+labelService.getLabelNameByKeyId("402883d934c106c10134c106c1c90000")+"'\n" +//没有数据显示
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

            LogService logService = (LogService) BaseContext.getBean("logService");
            //log
            if (hasCommunicationZone) {
                Log log = new Log();
                log.setIsdelete(0);
                log.setLogdesc(labelService.getLabelNameByKeyId("402881e70b65e2b3010b65e3435d0002"));//操作日志
                log.setLogtype("402881e40b6093bf010b60a5849c0007");
                log.setMid("");
                log.setObjid(id);
                log.setObjname(forminfo.getObjtablename());
                log.setSubmitdate(DateHelper.getCurrentDate());
                log.setSubmittime(DateHelper.getCurrentTime());
                log.setSubmitor(eweaveruser.getId());
                log.setSubmitip(eweaveruser.getRemoteIpAddress());
                logService.createLog(log);
            }else if("1".equalsIgnoreCase(category.getCol1()) && request.getParameter("requestid")!=null){
            	//卡片的查看日志在这里记录,而编辑保存则放到com.eweaver.workflow.request.servlet.FormAction
            	request.setAttribute("category", category);
//            	request.setAttribute("category", .fo);
            	logService.CreateLog(request);
            }

        %>

<%
//页面菜单
String tabStr="";
boolean hasTab=false;

if(bNewworkflow.equals("1")||editmode.equals("1")){
	//提交
	pagemenustr +="addBtn(tb,'"+labelService.getLabelName("提交")+"','S','accept',function(){onSubmit(2)});";
	//提交并新建
	if(permissiondetailService.checkOpttype(categoryid, 2)){
       if(category.getIsfastnew()==null?true:category.getIsfastnew().intValue()==0){
        pagemenustr +="addBtn(tb,'"+labelService.getLabelName("提交并新建")+"','N','application_form_add',function(){onSubmitNew(2)});";
       }
    }
	//返回
  //  pagemenustr += "addBtn(tb,'"+labelService.getLabelName("返回")+"','B','arrow_redo',function(){history.back()});";
}else{
	if(permissiondetailService.checkOpttype(id, 15)){
		pagemenustr += "addBtn(tb,'"+labelService.getLabelName("编辑")+"','M','application_form_edit',function(){onEdit()});";
	}
	if(!StringHelper.isEmpty(categoryid)){
		paravaluehm.put("{id}",id);
		paravaluehm.put("{typeid}",categoryid);
		paravaluehm.put("tableName",forminfo.getObjtablename());
		PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
        ArrayList<String> menuList=_pagemenuService2.getPagemenuStrExt(categoryid,paravaluehm);
		pagemenustr += menuList.get(0);
        tabStr += menuList.get(1);
	}
	if(permissiondetailService.checkOpttype(id, 165)){
		tabStr += "addTab(contentPanel,'"+request.getContextPath()+"/base/security/addpermission.jsp?objtable=formbase&istype=0&objid="+id+"','"+labelService.getLabelName("权限定义")+"','script_key');";
	}
	tabStr += "addTab(contentPanel,'"+request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.PermissiondetailAction?objtable=formbase&objid="+id+"','"+labelService.getLabelName("权限列表")+"','script_go');";

    if(permissiondetailService.checkOpttype(id, 105)){
		pagemenustr += "addBtn(tb,'"+labelService.getLabelName("删除")+"','D','delete',function(){onDelete('"+request.getContextPath()+"/workflow/request/formbase.jsp?requestid=del')});";
	}
}
if(category.getImportDetail()==1&&editmode.equals("1")){
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("导入明细")+"','E','application_xp',function(){importDetail('"+id+"','"+categoryid+"','"+layoutid+"')});";
}
if(!StringHelper.isEmpty(layoutid)){
		paravaluehm.put("{id}",id);
		paravaluehm.put("{typeid}",layoutid);
		paravaluehm.put("tableName",forminfo.getObjtablename());
		PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
        ArrayList<String> menuList=_pagemenuService2.getPagemenuStrExt(layoutid,paravaluehm);
		pagemenustr += menuList.get(0);
        tabStr += menuList.get(1);
	}
if(!tabStr.equals(""))
hasTab=true;
if(!notifyonreply)
membersfield="";
String reportid=category.getPReportid();
%>
<html>
  <head>
    <title><%=labelService.getLabelName("表单信息")%></title>
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
    .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
</style>
<script type="text/javascript">
var needformatted = true;
var caldelay=200;
    var daliog1;
Ext.SSL_SECURE_URL='about:blank';
if (<%=hasCommunicationZone%>) {
    publish('refreshtab','tab402880351e44500a011e4465e0cf0023');
    Ext.ux.PagingRowNumberer = Ext.extend(Ext.grid.RowNumberer, {
        renderer : function(v, p, record, rowIndex, colIndex, store) {
            if (this.rowspan) {
                p.cellAttr = 'rowspan="' + this.rowspan + '"';
            }

            var so = store.lastOptions;
            var sop = so ? so.params : null;
            return store.getTotalCount()-(((sop && sop.start) ? sop.start : 0) + rowIndex );
        }
    });
    var replyDialog;
    var daliog0;
    Ext.LoadMask.prototype.msg='加载...';
    var tb =null;
    var viewport=null;
    Ext.onReady(function() {
        var replyavailable=true;
        if(document.getElementsByName('field_<%=enddatefield%>').length>0&&document.getElementsByName('field_<%=enddatefield%>')[0].value!=''){
            enddate=document.getElementsByName('field_<%=enddatefield%>')[0].value;
            if(enddate<'<%=DateHelper.getCurrentDate()%>')
            replyavailable=false;
        }
        var members='';
        if(document.getElementsByName('field_<%=membersfield%>').length>0&&document.getElementsByName('field_<%=membersfield%>')[0].value!=''){
            members=document.getElementsByName('field_<%=membersfield%>')[0].value;
        }
        var subject='';
        if(document.getElementsByName('field_<%=subjectfield%>').length>0&&document.getElementsByName('field_<%=subjectfield%>')[0].value!=''){
            subject=document.getElementsByName('field_<%=subjectfield%>')[0].value;
        }
        Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
       tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
       <%}%>
        var replytpl = new Ext.XTemplate(
            '<p><b>{creator}</b> <%=labelService.getLabelNameByKeyId("402883d934c108af0134c108b0050000") %>  {createtime}</p>',//发表于
            '{reply}'<%=replytplstr%>
        );
        function renderReply(value, p, record) {
            p.attr = 'style="white-space:normal;word-break:break-all;line-height: 1.4"';
            return replytpl.apply(record.data)
            //return record.data.reply;
        }
        var sm = new Ext.grid.RowSelectionModel();
        var cm = new Ext.grid.ColumnModel([new Ext.ux.PagingRowNumberer(),{header:'<%=labelService.getLabelName("回复列表")%>',dataIndex:'reply',renderer:renderReply}]);
        // create the Data Store
        var store = new Ext.data.JsonStore({
            url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.cowork.servlet.CoworkAction',
            root: 'result',
            totalProperty: 'totalCount',
            baseParams:{action:'getreply',requestid:'<%=id%>',formid:'<%=communicationFormid%>'},
            fields: ['id','creator','createtime'<%=storefields%>]

        });
        var refobjstore = new Ext.data.JsonStore({
            url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.cowork.servlet.CoworkAction',
            root: 'result',
            fields: ['id',<%=storefields%>]
        });
        // create the editor grid
        var replygrid = new Ext.grid.GridPanel({
            title:'<%=labelService.getLabelName("相关交流")%>',
            store: store,
            cm: cm,
            trackMouseOver:false,
            sm:sm ,
            loadMask: true,
            viewConfig: {
                forceFit:true,
                enableRowBody:true,
                sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>',//升序
                sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>',//降序
                columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>',//列定义
                getRowClass : function(record, rowIndex, p, store) {
                    return 'x-grid3-row-expanded';
                }
            },

            tbar: replyavailable?[{
                id:'tbadd',
                text: '<%=labelService.getLabelName("回复")%>',
                iconCls:Ext.ux.iconMgr.getIcon('building_edit'),
                handler : function() {
                    try {
                        replyDialog.show('tbadd');
                    } catch(e) {
                    }

                }
            }]:null,
            bbar: new Ext.PagingToolbar({
                pageSize: <%=pagesize%>,
                store: store,
                displayInfo: true,
                beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000") %>",//第
            afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000") %>/{0}",//页
            firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003") %>",//第一页
            prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000") %>",//上页
            nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000") %>",//下页
            lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006") %>",//最后页
            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %> / {2}',//显示     条记录
            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000") %>" 
            })
        });
        //reply dialog
        var replydiv=Ext.get('div<%=communicationFormid%>');
        replydiv.setDisplayed('');
        var replydivHeight=replydiv.dom.getAttribute('height');
        dialogHeight=replydivHeight?replydivHeight.substring(0,replydivHeight.indexOf('%'))/100:0.3;
        //communicationpanel
        var communicationPanel = new Ext.TabPanel({
            region:'south',
            autoScroll:true,
            collapseMode:'mini',
            collapsible: true,
            height:window.document.body.clientHeight*dialogHeight,
            split:true,
            deferredRender:false,
            enableTabScroll:true,
            activeTab:0,
            items:[replygrid
                <%=tabs%>
            ]
        });
        var wrap=Ext.DomHelper.append(document.body,{tag:'div',id:'div<%=communicationFormid%>_wrap'});
        var replyform=Ext.DomHelper.append(wrap,{tag:'form',id:'form<%=communicationFormid%>',name:'form<%=communicationFormid%>'});
        replydiv.appendTo(replyform);
        if (!replyDialog) {
          replyDialog = new Ext.Window({
              closable:true,
              plain: false,
              collapsible:true,
              autoScroll:true,
              width:Ext.lib.Dom.getViewportWidth() * 0.8,
              height:Ext.lib.Dom.getViewportHeight() * 0.7,
              closeAction:'hide',
              buttons: [{
                  text     : '<%=labelService.getLabelName("提交")%>',
                  handler  : function() {
                          FCKEditorExt.updateContent();
                          Ext.Ajax.request({
                              url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.cowork.servlet.CoworkAction',
                              form:replyform,
                              isUpload:true,
                              success: function() {

                                  FCKEditorExt.setHtml('');
                                  document.getElementById('form<%=communicationFormid%>').reset();
                                  store.load({params:{start:0, limit:<%=pagesize%>}});
                              },
                              params: { action:'reply',requestid: '<%=id%>',formid:'<%=communicationFormid%>',maintable:'<%=objtable%>',members:members,subject:subject }
                          });
                         <%
                          List listformfield=formfieldService.getFieldByForm(communicationFormid,6,"");  //browser框
                          for(int i=0;i<listformfield.size();i++){
                          Formfield formfield=(Formfield)listformfield.get(i);
                          %>
                        document.all('field_<%=formfield.getId()%>span').innerHTML = '';
                       <%}%>
                        <%
                          List listformfieldattach=formfieldService.getFieldByForm(communicationFormid,7,"");  //附件
                          for(int i=0;i<listformfieldattach.size();i++){
                          Formfield formfield=(Formfield)listformfieldattach.get(i);
                          %>
                      document.all('filelist_<%=formfield.getId() %>').innerHTML = '';
                       <%}%>
                          replyDialog.hide('tbadd');
                  }
              }],
              contentEl:wrap
          });
      }
        var c = new Ext.Panel({
               <%if(hasTab){%>title:'<%=labelService.getLabelName("表单信息")%>',iconCls:Ext.ux.iconMgr.getIcon('application_form'),<%}else{%>region:'center',<%}%>
               layout: 'border',
               items: [{region:'center',autoScroll:true,contentEl:'divsum',split:true,collapseMode:'mini'},communicationPanel]
           });
     <%if(hasTab){%>
     var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            activeTab:0,
            items:[c]
        });
       <%=tabStr%>
       <%}%>
       if(<%=showunread%>){
           var unreadstore = new Ext.data.JsonStore({
               url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.cowork.servlet.CoworkAction',
               root: 'result',
               fields: ['id','name']
           });
           unreadstore.baseParams={action:'getunread',requestid:'<%=id%>',members:members};
           var unreadtpl = new Ext.XTemplate(
               '<tpl for=".">',
                   '<p>{name}',
               '</tpl>'
           );
           var unreadpanel = new Ext.Panel({
               id:'unreadpanel',
               title:'<%=labelService.getLabelNameByKeyId("402883d934c113ac0134c113aca30000") %>',//未读人员
               autoScroll:true,
               iconCls:Ext.ux.iconMgr.getIcon('group_error'),
               items: new Ext.DataView({
                   store: unreadstore,
                   tpl: unreadtpl,
                   multiSelect: true,
                   autoHeight:true,
                   overClass:'x-view-over',
                   itemSelector:'div.thumb-wrap',
                   emptyText: '<%=labelService.getLabelNameByKeyId("402883d934c106c10134c106c1c90000") %>'//没有数据显示
               })
           });
           contentPanel.add(unreadpanel);
           unreadpanel.on('activate',function(){
               unreadstore.load();
              })
        }
     //ie6 bug

             <%--daliog1 = new Ext.Window({--%>
                         <%--layout:'border',--%>
                         <%--closeAction:'hide',--%>
                         <%--plain: true,--%>
                         <%--modal :true,--%>
                         <%--width:viewport.getSize().width*0.75,--%>
                         <%--height:viewport.getSize().height*0.8,--%>
                         <%--buttons: [{--%>
                             <%--text     : '<%=labelService.getLabelName("关闭&刷新表单")%>',--%>
                             <%--handler  : function(){--%>
                                 <%--document.location.reload();--%>
                                 <%--daliog1.hide();--%>
                             <%--}--%>

                         <%--}],--%>
                         <%--items:[{--%>
                         <%--id:'dlgpanel',--%>
                         <%--region:'center',--%>
                         <%--xtype     :'iframepanel',--%>
                         <%--frameConfig: {--%>
                             <%--autoCreate:{id:'dlgframe1', name:'dlgframe1', frameborder:0} ,--%>
                             <%--eventsFollowFrameLinks : false--%>
                         <%--},--%>
                         <%--autoScroll:true--%>
                     <%--}]--%>
                     <%--});--%>

      //Viewport
	viewport = new Ext.Viewport({
        layout: 'border',
        items: [<%if(hasTab){%>contentPanel<%}else{%>c<%}%>]
	});

        try {
            replyDialog.render(Ext.getBody());
        } catch(e) {
        }
        ;
        store.load({params:{start:0, limit:<%=pagesize%>}});
        Ext.get('divsum').setVisible(true);
        formatTables();
    });
}else{
    Ext.onReady(function() {
        Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
       tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
       <%}%>

         var c = new Ext.Panel({
               <%if(hasTab){%>title:'<%=labelService.getLabelName("表单信息")%>',iconCls:Ext.ux.iconMgr.getIcon('application'),<%}else{%>region:'center',<%}%>
               layout: 'border',
               items: [{region:'center',autoScroll:true,contentEl:'divsum'}]
           });
     <%if(hasTab){%>
     var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            activeTab:0,
            items:[c]
        });
       <%=tabStr%>
       <%}%>
     //ie6 bug

      //Viewport
	viewport = new Ext.Viewport({
        layout: 'border',
        items: [<%if(hasTab){%>contentPanel<%}else{%>c<%}%>]
	});
    Ext.get('divsum').setVisible(true);
             daliog0 = new Ext.Window({
                         layout:'border',
                         closeAction:'hide',
                         plain: true,
                         modal :true,
                         width:viewport.getSize().width*0.5,
                         height:viewport.getSize().height*0.42,
                         buttons: [{
                             text     : '<%=labelService.getLabelName("关闭")%>',
                             handler  : function(){
                                 daliog0.hide();
                             }

                         }],
                         items:[{
                         id:'dlgpanel',
                         region:'center',
                         xtype     :'iframepanel',
                         frameConfig: {
                             autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
                             eventsFollowFrameLinks : false
                         },
                         autoScroll:true
                     }]
                     });

             daliog1 = new Ext.Window({
                         layout:'border',
                         closeAction:'hide',
                         plain: true,
                         modal :true,
                         width:viewport.getSize().width*0.75,
                         height:viewport.getSize().height*0.8,
                         buttons: [{
                             text     : '<%=labelService.getLabelName("关闭&刷新表单")%>',
                             handler  : function(){
                                 document.location.reload();
                                 daliog1.hide();
                             }

                         }],
                         items:[{
                         id:'dlgpanel',
                         region:'center',
                         xtype     :'iframepanel',
                         frameConfig: {
                             autoCreate:{id:'dlgframe1', name:'dlgframe1', frameborder:0} ,
                             eventsFollowFrameLinks : false
                         },
                         autoScroll:true
                     }]
                     });
      formatTables();  
    })
}

var needchecklists = "<%=needcheckfields%>";
var id = "<%=StringHelper.null2String(id)%>";
var workflowid = "<%=StringHelper.null2String(workflowid)%>";
var nodeid = "<%=StringHelper.null2String(nodeid)%>";

</script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/aop.pack.js"></script>    
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css" />
<script type="text/javascript" language="javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/CKEditorExt.js"></script>
<style>
    .x-panel-btns-ct {
          padding: 0px;
      }
</style>
<script type="text/javascript">
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
	var id;
    if(Ext.isIE){
    try{

    id=window.showModalDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin);
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
            id = window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/document/base/docbasecreate.jsp?categoryid="+docdir+"&doctypeid="+doctype+params+"&targetUrl="+targeturl,"dialogHeight:"+screen.availHeight+"px;dialogWidth:"+screen.availWidth+"px; center: Yes; help: No; resizable: yes; status: No");

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
</script>

 
  </head>
  <body>

<div id="divsum" style="display:none;" >
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




<input type="hidden" name="tmpvalue" id="tmpvalue" value="">


  </form>
  </div>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
  </body>
</html>
  <script language="javascript">
      var tableformatted = false;
      function formatTables() {
          if (needformatted) {
              Ext.each(Ext.query("table[id*='oTable']"), function() {
                  tableformatted = true;
                  formatTable(this);
              });
              Ext.each(Ext.query("table[id*='oTable']"), function() {
                  this.onresize=function(){formatTable(this)};
              });
          }
      }
  var inputid;
  var spanid;
  var temp;
  [].indexOf || (Array.prototype.indexOf = function(v)
{
	for(var i = this.length; i-- && this[i] !== v;);
	return i;
}
);

jq(document).ready(function($){
    <%=ufscript%>
    <%=directscript%>
   $.Autocompleter.Selection = function(field, start, end) {
         var flag;
       if(Ext.isIE){
         flag= field.createTextRange; //在firefox下span不显示 原因是因为  firefox不支持createTextRange 
       }else{
         flag=true;
       }
       if(flag){
           if (Ext.isIE) { 
               var selRange = field.createTextRange();
               selRange.collapse(true);
               selRange.moveStart("character", start);
               selRange.moveEnd("character", end);
               selRange.select();
           }
        if(inputid==undefined||spanid==undefined)
           return;
         var len=field.value.indexOf("  ");
           var lenspance=field.value.indexOf(" ");
             if(temp==0&&len>0){
             temp=1;
         var  length=field.value.length;
           var data=field.value;
        document.getElementById(inputid).value=field.value.substring(0,field.value.indexOf("  "));
       document.getElementById('field'+spanid+'span').innerHTML= data.substring(len,length);
         }else if(temp==0&&lenspance>0){

           var data=field.value;
        document.getElementById(inputid).value=data;
       document.getElementById('field'+spanid+'span').innerHTML= data;
             }else
             {
               document.getElementById(inputid).value="";

             }
 } else if( field.setSelectionRange ){
        field.setSelectionRange(start, end);
	} else {
           if( field.selectionStart ){
			field.selectionStart = start;
			field.selectionEnd = end;
		}
	}
	field.focus();
};

 });

	var strSQLs = new Array();
	var strValues = new Array();
   <%=triggercalscript%>
 function checkUnique(obj,param,isonly,fieldname,tablename){
    if(obj.value.trim()=='')
    return;
     if(isonly==1||param=="")
     {
        param="select "+fieldname+" from "+tablename+" where "+fieldname+" = ?";
     }
    param=param.replace("?","'"+obj.value.ReplaceAll("'","''")+"'");
   if(SQL(param)!=''){
      alert('<%=labelService.getLabelNameByKeyId("402883d934c119410134c11941a20000") %>') ;//数据已存在,请重新输入！
      obj.value='';
      obj.focus();
   }

  }
  function checkdirect(obj)
  {
      inputid=obj.id;
      spanid=obj.name;
      temp=0;
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
  function onAddRow(){
		try{
            <%=onaddrowscript%>
		}catch(e){}
}

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
onAddRow();
inputs = document.EweaverForm.getElementsByTagName("input");
     for (i = 0; i < inputs.length; i++) {
         inputel = inputs[i];
         if(inputel.value&&inputel.value!='')
           inputel.fireEvent('onpropertychange');
     }
var task=new Ext.util.DelayedTask(onCal);
</script>

<SCRIPT FOR = document EVENT = onselectionchange>
task.delay(caldelay,null,this);
</SCRIPT>
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

 <!--
 	function onPopup(url){
		var id=window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
	}
function onEdit(){
    window.location="<%=request.getContextPath()%>/workflow/request/formbase.jsp?editmode=1&categoryid=<%=categoryid%>&requestid=<%=id%>";
}
function onDelete(link){
	delmessage="<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>";
	if(confirm(delmessage)){
		document.all("action").value="deleteformbase";
		document.all("targetUrl").value=link;
		document.EweaverForm.submit();
	}
}
function onSubmit(issave){
	//needchecklists = "<%=needcheckfields%>";
  checkfields="requestname,"+needchecklists;//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空


	onCal();

  var needcheck = 0;
  if(issave == 0){

  }else
   		needcheck = 1;

  if(needcheck == 1){
	  if(checkForm(EweaverForm,checkfields,checkmessage)){
	  		/*if(issave == 1)
  				document.all("issave").value = "1";
	  		if(issave == 3)
  				document.all("isundo").value = "1";
	  		*/
            <%if(!StringHelper.isEmpty(categoryfield)){%>
          if(document.getElementById('<%=categoryfield%>'))
            document.getElementById('categoryid').value=document.getElementById('<%=categoryfield%>').value;
            <%}%>

 //*************************提交之前将用户没有修改的当前时间字段标识一下,交给后台更新(start)**************************//
    for(var num=0;num<objectKey.length;num++){
        if(objectKey[num]!=""&&objectKey[num]!=null){
            getMapValue(objectKey[num]);
            if(timevalue==document.all(objectKey[num]).value){
                document.all(objectKey[num]).value="$currenttime$";
            }
        }
    }
    //*************************提交之前将用户没有修改的当前时间字段标识一下,交给后台更新(end)**************************//
               document.EweaverForm.submit();
               <%if(!StringHelper.null2String(reportid).equals("")){%>
               publish('refreshstore','<%=reportid%>') ;
              <%}%>
	  }
  }
  //document.all("isreject").value = "0";
}
 function onSubmitNew(issave)
 {

	//needchecklists = "<%=needcheckfields%>";
  checkfields="requestname,"+needchecklists;//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空
  document.all('subnew').value='createnew';

	onCal();

  var needcheck = 0;
  if(issave == 0){

  }else
   		needcheck = 1;

  if(needcheck == 1){
	  if(checkForm(EweaverForm,checkfields,checkmessage)){
	  		/*if(issave == 1)
  				document.all("issave").value = "1";
	  		if(issave == 3)
  				document.all("isundo").value = "1";
	  		*/
            <%if(!StringHelper.isEmpty(categoryfield)){%>
          if(document.getElementById('<%=categoryfield%>'))
            document.getElementById('categoryid').value=document.getElementById('<%=categoryfield%>').value;
            <%}%>
	   		document.EweaverForm.submit();
            <%if(!StringHelper.null2String(reportid).equals("")){%>
               publish('refreshstore','<%=reportid%>') ;
              <%}%>
	  }
  }
 }
 function checkFileSize(filepath,maxSize){
    var size=getFileSize(filepath);
    if(size>maxSize)
    return false;
    return true;
}
    function doAction(requestid,customid){
         Ext.Ajax.request({
                     url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormbaseAction?action=doaction',
                     params:{requestid:requestid,customid:customid},
                     success: function(res) {
                         if(res.responseText == 'noright')
                         {
                              Ext.Msg.buttonText={ok:'<%=labelService.getLabelName("确定")%>'};
                           Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934c11be50134c11be5c00000") %>') ;//编辑权限的人才可以变更卡片数据！
                         }else{
                              Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934c11ccb0134c11ccbb80000") %>',function(){//变更卡片数据成功!
                                window.location.href='<%=request.getContextPath()%>/workflow/request/formbase.jsp?requestid='+requestid;
                             });

                         }
                     }
                 });
    }
function getFileSize(filepath){
 if(filepath=='')
 {
 return null;
 }
 try
 {
 filecheck.FilePath=filepath;
 var size=filecheck.getFileSize()/(1024*1024);
     return size;
 }
 catch(e)
 {
 alert(e);
 return null;
 }
 return null;
 }
    function sendMsg(msg,humres,type){
          this.daliog0.getComponent('dlgpanel').setSrc('<%= request.getContextPath()%>/msg/createmsg.jsp?catcher='+humres+'&objid=<%=id%>&msg='+encodeURIComponent(msg));
          this.daliog0.show();
    }
    function importDetail(requestid,categoryid,layoutid){
          this.daliog1.getComponent('dlgpanel').setSrc('<%= request.getContextPath()%>/workflow/form/exportdrecordbyexcel.jsp?requestid='+requestid+'&categoryid='+categoryid+'&layoutid='+layoutid);
          this.daliog1.show();
    }
 </script>



                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   