<%@ page contentType="text/html; charset=UTF-8"%>
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


<%	int pagesize=40;
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
    workflowparameters = fs.WorkflowView(workflowparameters);
    layoutid = StringHelper.null2String(workflowparameters.get("layoutid"));
	String needcheckfields = StringHelper.null2String(workflowparameters.get("needcheck"));
	String formcontent = StringHelper.null2String(workflowparameters.get("formcontent"));
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
                           replytplth+="<th>"+f.getLabelname()+"</th>";
                           replytpltd+="<td>{"+f.getFieldname()+"}</td>";
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
                //if(!replytplth.equals("")){
				//replytplstr+=",'<tpl if=\"this.hasRefobj("+params+")\">'," ;

                replytplstr+=",'<table cellspacing=\"0\" cellpadding=\"0\" border=\"1\" style=\"background-color:#F5F5F5;width:100%;\" bordercolor=\"#fffff\" ><tr height=25>"+replytplth+"</tr><tr height=25>"+replytpltd+"</tr></table>'";
                //replytplstr+="'</tpl>',";
                replytplstr+=",{hasRefobj:function ("+params+"){return "+functionbody+"}}";
                //}

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
	if(permissiondetailService.checkOpttype(id, 15)){
		pagemenustr += "addBtn(tb,'"+labelService.getLabelName("编辑")+"','M','application_form_edit',function(){onEdit()});";
	}
	pagemenustr += "addBtn(tb,'"+labelService.getLabelName("回复")+"','R','building_edit',function(){replyDialog.show('tbadd')});";
	if(!StringHelper.isEmpty(categoryid)){
		paravaluehm.put("{id}",id);
		paravaluehm.put("{typeid}",categoryid);
		paravaluehm.put("tableName",forminfo.getObjtablename());
		PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
        ArrayList<String> menuList=_pagemenuService2.getPagemenuStrExt(categoryid,paravaluehm);
		pagemenustr += menuList.get(0);
        tabStr += menuList.get(1);
	}
	//tabStr += "addTab(contentPanel,'"+request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.PermissiondetailAction?objtable=formbase&objid="+id+"','"+labelService.getLabelName("权限列表")+"','script_go');";
if(!StringHelper.isEmpty(layoutid)){
		paravaluehm.put("{id}",id);
		paravaluehm.put("{typeid}",layoutid);
		paravaluehm.put("tableName",forminfo.getObjtablename());
		PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
        ArrayList<String> menuList=_pagemenuService2.getPagemenuStrExt(layoutid,paravaluehm);
		pagemenustr += menuList.get(0);
        tabStr += menuList.get(1);
	}
hasTab=true;
if(!notifyonreply)
membersfield="";
String reportid=category.getPReportid();
%>
<html>
  <head>
    <title><%=labelService.getLabelName("协作交流")%></title>
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
         .x-panel-body {
        border-bottom:#99bbe8 0px solid;
         position:  relative;
         border-left:#99bbe8 0px solid;
        border-right:#99bbe8 0px solid
     }
    .x-panel-body-noheader{
        border-top:#99bbe8 0px solid
    }
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
            '<div style="background-color:#E8E8E8;width:100%;height:25;" valign=middle><p><b>{creator}</b> <%=labelService.getLabelNameByKeyId("402883d934c108af0134c108b0050000") %>  {createtime}</p></div>',//发表于
            '<div style="height:40">{reply}</div>'<%=replytplstr%>
        );
        function renderReply(value, p, record) {
            p.attr = 'style="white-space:normal;word-break:break-all;line-height: 1.4"';
            return replytpl.apply(record.data)
            //return record.data.reply;
        }
        var sm = new Ext.grid.RowSelectionModel();
        var cm = new Ext.grid.ColumnModel([{dataIndex:'reply',renderer:renderReply}]);
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
            loadMask: false,
            viewConfig: {
                forceFit:true,
                enableRowBody:true
            },
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
        dialogHeight=replydivHeight?replydivHeight.substring(0,replydivHeight.indexOf('%'))/100:0.7;
        //communicationpanel
        var communicationPanel = new Ext.TabPanel({
            region:'south',
            autoScroll:false,
            collapseMode:'mini',
            collapsible: false,
            height:window.document.body.clientHeight*dialogHeight,
            split:false,
            deferredRender:true,
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
               <%if(hasTab){%>title:'<%=labelService.getLabelName("讨论交流")%>',iconCls:Ext.ux.iconMgr.getIcon('application_form'),<%}else{%>region:'center',<%}%>
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
               <%if(!pagemenustr.equals("")){%>
               items: [{region:'north',items:[tb],height:26},{region:'center',autoScroll:true,contentEl:'divsum'}]
              <%}else{%>
             items: [{region:'center',autoScroll:true,contentEl:'divsum'}]

             <%}%>
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
         var url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin
            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
                url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
            }
    id=window.showModalDialog(url);
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

 <!--
 	function onPopup(url){
		var id=window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
	}
 function checkFileSize(filepath,maxSize){
    var size=getFileSize(filepath);
    if(size>maxSize)
    return false;
    return true;
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
function onEdit(){//共享日程
    var url="<%=request.getContextPath()%>/workflow/request/formbase.jsp?editmode=1&categoryid=<%=categoryid%>&requestid=<%=id%>";
	onUrl(url,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0013") %>','tab1');//修改协作
}
 </script>



