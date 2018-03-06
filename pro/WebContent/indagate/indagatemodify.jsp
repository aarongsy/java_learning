<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
    //是否进行设置网上调查表单设置
	DataService ds = new DataService();
    int indagateset = NumberHelper.string2Int(ds.getValue("SELECT count(*) FROM indagateformset"),0);
	if(indagateset==0){
		out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置网上调查表单设置后再来操作。</h5>");
		return;
	}
    String workflowid = StringHelper.null2String(request.getParameter("workflowid")).trim();
	String id = StringHelper.null2String(request.getParameter("requestid")).trim();
	String isedit="0";
	if(StringHelper.isEmpty(id)){
		isedit="1";
	}
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
String tabStr="";
boolean hasTab=false;

if(bNewworkflow.equals("1")||editmode.equals("1")){
	//提交
	pagemenustr +="addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit(2)});";
	//提交并新建
	if(permissiondetailService.checkOpttype(categoryid, 2)){
       if(category.getIsfastnew()==null?true:category.getIsfastnew().intValue()==0){
        //pagemenustr +="addBtn(tb,'提交并新建','N','application_form_add',function(){onSubmitNew(2)});";
       }
    }
	//返回
}else{
	if(permissiondetailService.checkOpttype(id, 15)){
		pagemenustr += "addBtn(tb,'编辑','M','application_form_edit',function(){onEdit()});";
		pagemenustr += "addBtn(tb,'预览','L','application_form_edit',function(){onLook()});";
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
		tabStr += "addTab(contentPanel,'"+request.getContextPath()+"/base/security/addpermission.jsp?objtable=formbase&istype=0&objid="+id+"','权限定义','script_key');";
	}
	tabStr += "addTab(contentPanel,'"+request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.PermissiondetailAction?objtable=formbase&objid="+id+"','权限列表','script_go');";
	if(permissiondetailService.checkOpttype(id, 105)){
		pagemenustr += "addBtn(tb,'删除','D','delete',function(){onDelete('"+request.getContextPath()+"/workflow/request/formbase.jsp?requestid=del')});";
	}
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
<%
   String contentaction=request.getContextPath()+"/ServiceAction/com.eweaver.indagate.servlet.IndagateAction?action=getcontents&requestid="+id ;  
%>
<html>
  <head>
    <title>表单信息</title>
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
        var dlg0;
        var contentstore;
       Ext.onReady(function() {
        Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
       <%}%>
           contentstore = new Ext.data.Store({
                 proxy: new Ext.data.HttpProxy({
                     url: '<%=contentaction%>'
                 }),
                 reader: new Ext.data.JsonReader({
                     root: 'result',
                     totalProperty: 'totalcount',
                     fields: ['subject','typestr','count','str','id','oinputstr']


                 })

             });
             var contentcm = new Ext.grid.ColumnModel([{header: "主题", sortable: false,width:200, dataIndex: 'subject'},
                 {header: "类型", sortable: false,width:200,  dataIndex: 'typestr'},
                 {header: "项数",  sortable: false,width:200, dataIndex: 'count'},
                 {header: "是否其他输入",  sortable: false, width:200,dataIndex: 'oinputstr'},
                 {header: "操作",  sortable: false,width:200, dataIndex: 'str'}
             ]);
             var contentgrid = new Ext.grid.GridPanel({
                 id:"cgrid",
                 title:'内容',
                 store: contentstore,
                 cm: contentcm,
                 trackMouseOver:false,
                 loadMask: true,
                  viewConfig: {
                                       forceFit:false,
                                          enableRowBody:true,
                                          sortAscText:'升序',
                                          sortDescText:'降序',
                                          columnsText:'列定义',
                                          getRowClass : function(record, rowIndex, p, store){
                                              return 'x-grid3-row-collapsed';
                                          }
                                      },
                                     <% if(!StringHelper.isEmpty(id)){%>
                                     tbar: [Ext.get('divcontentadd').dom.innerHTML],
                                     <%}%>
                                      bbar: new Ext.PagingToolbar({
                                          pageSize: 20,
                           store: contentstore,
                           displayInfo: true,
                           beforePageText:"第",
                           afterPageText:"页/{0}",
                           firstText:"第一页",
                           prevText:"上页",
                           nextText:"下页",
                           lastText:"最后页",
                           displayMsg: '显示 {0} - {1}条记录 / {2}',
                           emptyMsg: "没有结果返回"
                       })

             });
           //Viewport
                  var  communicationPanel =   new Ext.TabPanel({
                      region:'south',
                      autoScroll:true,
                     collapseMode:'mini',
                     collapsible: true,
                      height:200,
                      split:true,
                      deferredRender:false,
                      enableTabScroll:true,
                      activeTab:0,
                            items:[ contentgrid,
                            {
                                    title: '权限定义',
                                    closable:false,
                                    xtype     :'iframepanel',
                                    frameConfig: {
                                        autoCreate:{
                                            frameborder:0
                                        },
                                        eventsFollowFrameLinks : false
                                    },
                                    defaultSrc:' <%=request.getContextPath()%>/indagate/indagateactor.jsp?objtable=<%=objtablea%>&istype=0&objid=<%=id%>&formid=<%=category.getFormid()%>',
                                    autoScroll:true
                                }

                            ]
                        });
             var c = new Ext.Panel({
                          title:'表单信息',iconCls:Ext.ux.iconMgr.getIcon('application_form'),
                           layout: 'border',
                           items: [{region:'center',autoScroll:true,contentEl:'divsum',split:true,collapseMode:'mini'}<%if(!StringHelper.isEmpty(id)){%>,communicationPanel<%}%>]
                       });

                 var contentPanel = new Ext.TabPanel({
                        region:'center',
                        id:'tabPanel',
                        deferredRender:false,
                        enableTabScroll:true,
                        autoScroll:true,
                        activeTab:0,
                        items:[c]
                    });
             var viewport = new Ext.Viewport({
        layout: 'border',
        items: [contentPanel]
	});
           contentstore.load({params:{start:0, limit:20}});

              dlg0 = new Ext.Window({
           layout:'border',
           closeAction:'hide',
           shim: false,
           plain: false,
           modal :true,
           width:viewport.getSize().width * 0.8,
           height:viewport.getSize().height * 0.8,
           buttons: [{text     : '取消',
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');

               }
           },{
               text     : '关闭',
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
                   contentstore.load({params:{start:0, limit:20}});

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
           }],
           listeners: {'show': function() {
	           jQuery(".x-frame-shim-on").hide();
	       }
		}
       });
       dlg0.render(Ext.getBody());
       });
    var tableformatted = false;
   	var inputid;
   	var spanid;
   	var temp;
   	[].indexOf || (Array.prototype.indexOf = function(v)
   	{
   		for(var i = this.length; i-- && this[i] !== v;);
   		return i;
   	});
   	var strSQLs = new Array();
   	var strValues = new Array();
   	<%=triggercalscript%>
   	jQuery(document).ready(function($){
   	<%=ufscript%>
   	<%=directscript%>
   	$.Autocompleter.Selection = function(field, start, end) {
   	if( field.createTextRange ){
   		var selRange = field.createTextRange();
   		selRange.collapse(true);
   		selRange.moveStart("character", start);
   		selRange.moveEnd("character", end);
   		selRange.select();
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
   			}
   			else{
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
       
       
function checkdirect(obj)
{
	inputid=obj.id;
	spanid=obj.name;
	temp=0;
}
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
<input type="hidden" name="isedit"  id="isedit" value="<%=isedit %>"/>
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

<div id="divcontentadd" style="display:none">
    <table>
        <tr>
            <td><a onclick="addcontent()" >添加</a></td>
        </tr>
    </table>
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
      var id;
      if(Ext.isIE){
      try{
        var url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
                url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
            }
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
   //预览投票
   function onLook(){
      var url = "/indagate/indagate.jsp?requestid=<%=id%>&islook=0";
      this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
      this.dlg0.show();
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
       function addcontent(){
       var url='/indagate/indagatecontentadd.jsp?requestid=<%=id%>';
       this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
      this.dlg0.show();
   }
      function onSubmit(){
          document.EweaverForm.submit();
      }
      function onCreate(url){
    this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
      this.dlg0.show();
  }
    function onModify(id){
    var url='/indagate/indagatecontentadd.jsp?requestid=<%=id%>&contentid='+id;
       this.dlg0.getComponent('dlgpanel').setSrc(url);
      this.dlg0.show();
    }
    
    function onUP(id,index_,requestid){
	    var grid_ = Ext.getCmp('cgrid');
		var store_ = grid_.getStore();
		//上移
		if (index_ > 0) {
		  var rdata = store_.getAt(index_); 
		  store_.remove(rdata);
		  store_.insert(index_ - 1, rdata);
		  DWREngine.setAsync(false);
   		  DataService.executeSql("update indagatecontent set ordernum='"+index_+"' where id='"+id+"' and requestid='"+requestid+"'");
   		  DataService.executeSql("update indagatecontent set ordernum=("+index_+"+1) where id !='"+id+"' and ordernum="+index_+" and requestid='"+requestid+"'");
   		  store_.load();
		}
		
       // alert(id);
    }
    
    function onDOWN(id,index_,requestid){
        var grid_ = Ext.getCmp('cgrid');
		var store_ = grid_.getStore();
        //下移
		if (index_ < store_.getCount() - 1) {
		  var rdata = store_.getAt(index_); 
		  store_.remove(rdata);
		  store_.insert(index_ + 1, rdata);
		  DWREngine.setAsync(false);
   		  DataService.executeSql("update indagatecontent set ordernum='"+(index_ + 2)+"' where id='"+id+"' and requestid='"+requestid+"'");
   		  DataService.executeSql("update indagatecontent set ordernum="+(index_+1)+" where id !='"+id+"' and ordernum="+(index_+2)+" and requestid='"+requestid+"'");
   		  store_.load();
		}
        //alert(id);
    }
</script>



