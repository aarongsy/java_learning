<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunittype"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunittypeService"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@ page import="com.eweaver.base.security.model.Permissionrule"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.security.service.logic.SysroleService"%>
<%@ page import="com.eweaver.base.security.model.Sysrole"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem"%>
<%@ page import="com.eweaver.workflow.form.model.Formlayout"%>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.security.dao.PermissionruleDaoHB" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.base.notify.model.NotifyDefine" %>

<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

    SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");

    PermissionruleService permissionruleService = (PermissionruleService) BaseContext.getBean("permissionruleService");

    NotifyDefineService notifyDefineService = (NotifyDefineService) BaseContext.getBean("notifyDefineService");

 	PermissiondetailService permissiondetailService = (PermissiondetailService)BaseContext.getBean("permissiondetailService");

 	HumresService humresService = (HumresService) BaseContext.getBean("humresService");

    NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");

    FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");

    ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");

    BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

	OrgunittypeService orgunittypeService = (OrgunittypeService)BaseContext.getBean("orgunittypeService");

	OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");

	SysroleService sysroleService = (SysroleService)BaseContext.getBean("sysroleService");

    ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");

    CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");

    String objid = StringHelper.null2String(request.getParameter("objid"));
    String formid = StringHelper.null2String(request.getParameter("formid"));
	String objtable = StringHelper.null2String(request.getParameter("objtable")).trim();
    String refactorTable="";
    if(objtable.equals("docbase")){
        refactorTable="docbase";
    }else{
        refactorTable="formbase";
    }

    String objtable1=objtable;
    if(objtable1.equals("formbase")) objtable1="requestbase";

    int istype = NumberHelper.string2Int(request.getParameter("istype"),0);

	if(!(istype==1)){
		boolean opttype = permissiondetailService.checkOpttype(objid,165);
		if(!opttype){
			response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
			return;
		}
	}


	int nodetype = 0;
	int refobjtype = 0;
	int isworkflowid = 0;
	if(objtable.equalsIgnoreCase("workflowinfo")){
		refobjtype = 1 ; //工作流相关；
		isworkflowid = 1;
	}else if(objtable.equalsIgnoreCase("requestbase")){
		refobjtype = 1 ; //工作流相关；
		if(istype==1){
	 		Nodeinfo nodeinfo = nodeinfoService.get(objid);
	 		nodetype = nodeinfo.getNodetype().intValue();
	 	}else
	 		nodetype = 4;

	}else if(objtable.equalsIgnoreCase("docbase")||objtable.equalsIgnoreCase("doctype")){
		refobjtype = 2 ; //文档相关；


	}
    Boolean hasRestrictionsField = false;
    String categoryid = "";
    if(istype==0&&("formbase".equals(refactorTable)||"docbase".equals(refactorTable))){
        String sql = "";
        List list = new ArrayList();
        if (refactorTable.equals("docbase")){
            sql = "select categoryids from " + refactorTable + " t1 where  id=?";
            list = baseJdbcDao.getJdbcTemplate().queryForList(sql,new Object[]{objid});
            if(list.size()!=0){
                Map map = (Map) list.get(0);
                categoryid = map.get("categoryids").toString();
            }
        }else{
            sql = "select categoryid from " + refactorTable + " t1 where  id=?";
            list = baseJdbcDao.getJdbcTemplate().queryForList(sql,new Object[]{objid});
            if(list.size()!=0){
                Map map = (Map) list.get(0);
                categoryid = map.get("categoryid").toString();
            }
        }

        permissionruleService.reCreatePermissiondetail(categoryid);
        List<Permissionrule> originrules = ((PermissionruleDaoHB) permissionruleService.getPermissionruleDao()).find("from Permissionrule t1 where istype='1' and t1.objid=?", new Object[]{categoryid});
        //当前分类权限为空时，取上级分类权限
        if (originrules.size() == 0) {
            Category category = categoryService.getCategoryById(categoryid);
            while (originrules.size() == 0 && category.getPid() != null) {
                category = categoryService.getCategoryById(category.getPid());
                originrules = ((PermissionruleDaoHB) permissionruleService.getPermissionruleDao()).find("from Permissionrule t1 where istype='1' and t1.objid=?", new Object[]{category.getId()});
            }
        }

        if(originrules.size()!=0){
            for (Permissionrule rule : originrules) {
                if (rule.getOpttype()!=2){
                    Permissionrule permissionrule2 = new Permissionrule();
                    if(rule.getRestrictionsField()!=null&&!"".equals(rule.getRestrictionsField())){
                        hasRestrictionsField = true;
                        break;
                    }
                }
            }
        }
    }

pagemenustr +=  "addBtn(tb,'保存','S','accept');";
//pagemenustr +=  "addBtn(tb,'权限重构','C','accept');";
if(istype==1&&!objtable.equals("workflowinfo")&&!objtable.equals("requestbase")&&!objtable.equals("doctype"))
pagemenustr +=  "addBtn(tb,'历史数据重构','H','accept');";
if(istype==0&&!objtable.equals("doctype")&&hasRestrictionsField)
pagemenustr +=  "addBtn(tb,'卡片历史数据重构','R','accept');";
if(istype==1&&objtable.equals("workflowinfo"))
pagemenustr +=  "addBtn(tb,'历史数据重构','G','accept');";
%>
<html>
  <head>
  	<script src='<%= request.getContextPath()%>/dwr/interface/DataService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/interface/SelectitemService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/util.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/interface/RightTransferService.js'></script>
 
    <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <style type="text/css">
      #pagemenubar table {
              width: 0
          }
      #mychoose{
          color:#000000;
          text-decoration:none;
          padding-top:4px;
          width:430px;
          height:320px;
          text-align:center;
          background-color: #f7f7f7;
          position:absolute;
      }
      #mychoosediv{
          color:#000000;
          text-decoration:none;
          padding-top:4px;
          width:430px;
          height:320px;
          text-align:center;
          background-color: #f7f7f7;
          position:absolute;
      }
      a:hover{
          text-decoration: none;
      }
      </style>
<script type="text/javascript">

var total=0;
var currentCount=0;
var refresstimer;
var pbar1;

Ext.onReady(function(){
    var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
    var btnS = Ext.getCmp('S');
    var btnH = Ext.getCmp('H');
    var btnG = Ext.getCmp('G');
    var btnR = Ext.getCmp('R');

    <%if(istype==1&&objtable.equals("workflowinfo")){%>
    pbar1 = new Ext.ProgressBar({
       text:''
    });

    btnG.on('click',function(){
        total=0;
        currentCount=0;
        Ext.getCmp('S').disable();
        Ext.getCmp('G').disable();
        Ext.fly('p1').setDisplayed(true);
        Ext.fly('p1text').update('');
        if (!pbar1.rendered){
            pbar1.render('p1');
        }else{
            pbar1.text = '';
            pbar1.show();
        }
        doRefactorWorkflowinfo('<%=objid%>');
        if(total==-1){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('G').enable();
        Ext.fly('p1text').update('请等待先前的任务完成').show();
        return;
        }
        if(total==0){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('G').enable();
        Ext.fly('p1text').update('没有历史数据存在!').show();
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('重构完成!').show();
        });
    });
    <%}%>
    <%if(istype==1&&!objtable.equals("workflowinfo")&&!objtable.equals("requestbase")&&!objtable.equals("doctype")){%>
    //==== Progress bar1  ====
    pbar1 = new Ext.ProgressBar({
       text:''
    });

    btnH.on('click',function(){
        total=0;
        currentCount=0;
        Ext.getCmp('S').disable();
        Ext.getCmp('H').disable();
        Ext.fly('p1').setDisplayed(true);
        Ext.fly('p1text').update('');
        if (!pbar1.rendered){
            pbar1.render('p1');
        }else{
            pbar1.text = '';
            pbar1.show();
        }
        doRefactor('<%=objid%>','<%=refactorTable%>');
        if(total==-1){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('H').enable();
        Ext.fly('p1text').update('请等待先前的任务完成').show();
        return;
        }
        if(total==0){
        pbar1.reset(true);
        Ext.getCmp('S').enable();

        Ext.getCmp('H').enable();
        Ext.fly('p1text').update('重构完成').show();
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('重构完成!').show();
        });
    });
    <%}%>

    btnS.on('click',function(){
        if(btnH)
        Ext.getCmp('H').disable();

        Ext.getCmp('S').disable();
        doSave();
    });


    <%if(istype==0&&!objtable.equals("doctype")&&hasRestrictionsField){%>
    //==== Progress bar1  ====
    pbar1 = new Ext.ProgressBar({
       text:''
    });

    btnR.on('click',function(){
        total=0;
        currentCount=0;
        Ext.getCmp('S').disable();

        Ext.fly('p1').setDisplayed(true);
        Ext.fly('p1text').update('');
        if (!pbar1.rendered){
            pbar1.render('p1');
        }else{
            pbar1.text = '';
            pbar1.show();
        }
        doRequestRefactor('<%=objid%>','<%=refactorTable%>');
        if(total==-1){
        pbar1.reset(true);
        Ext.getCmp('S').enable();

        Ext.fly('p1text').update('请等待先前的任务完成').show();
        return;
        }
        if(total==0){
        pbar1.reset(true);
        Ext.getCmp('S').enable();

        Ext.fly('p1text').update('重构完成').show();
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('重构完成!').show();
        });
    });
    <%}%>
});

var Runner = function(){
    var f = function(pbar,count, cb){

        return function(){
            doRefresh();
            if(currentCount >= count){
                Ext.getCmp('S').enable();

                if(Ext.getCmp('H')!=null){
                    Ext.getCmp('H').enable();
                }
                if(Ext.getCmp('G')!=null){
                    Ext.getCmp('G').enable();
                }
                clearInterval(refresstimer);
                cb();
            }else{
					var i = currentCount/count;
                    //pbar.updateProgress(i, Math.round(100*i)+'%');
                    pbar.updateProgress(i, currentCount+'/'+count);
            }
       };
    };
    return {
        run : function(pbar, count, cb){
            var ms = 5000/count;
              try{
              refresstimer=setInterval(f(pbar, count, cb),1000);
              }catch(e){}

        }
    }
}();
</script> 
<script Language="JavaScript">

	function getformfield(permtypeid){

       	DataService.getFormfieldForPermission(createList,permtypeid,'<%=objtable%>','<%=categoryid%>');
       	return true;
    }
    function createList(data)
	{
	    DWRUtil.removeAllOptions("FormfieldID");
	    DWRUtil.addOptions("FormfieldID", data,"id","labelname");
	}
	function getformfield2(permtypeid){

       	DataService.getFormfieldForPermission(createList2,permtypeid,'<%=objtable%>','<%=categoryid%>');
       	return true;
    }
    function createList2(data)
	{
	    DWRUtil.removeAllOptions("role_ziduid");
	    DWRUtil.addOptions("role_ziduid", data,"id","labelname");
	}
</script>
  </head>

  <body>

<!--页面菜单开始-->
<div id="pagemenubar">
</div>
<!--页面菜单结束-->

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="0">
<col width="">
<col width="0">
<tr>
    <td ></td>
    <td>
        <div class="status" id="p1text" style="display:none"></div>
        <div id="p1" style="width:300px;display:none"></div>
    </td>
    <td ></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id=mainform name=mainform action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionAction?action=create&isdagate=1" method=post onsubmit='return check_by_ShareType()'>
  <input type="hidden" name="objid" value="<%=objid%>">
  <input type="hidden" name="formid" value="<%=formid%>">
  <input type="hidden" name="objtable" value="<%=objtable%>">
  <input type="hidden" name="istype" value="<%=istype%>">

  <TABLE class=ViewForm>
    <COLGROUP>
		<COL width="30%">
        <COL width="15%">
  		<COL width="55%">
    </COLGROUP>
    <TBODY>
      <TR class=Title><TH colSpan=3>
      </TH></TR>
      <TR class=Spacing><TD class=Line1 colSpan=3>
      </TD></TR>
      <TR><TD class=FieldValue colSpan=3>
        <SELECT class=InputStyle name=ShareType onchange="onChangeShareType()">
        <%
        	List list = selectitemService.getSelectitemList("402881e60bf4f747010bf4fcad5b0005",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);
        %>

          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>
        </SELECT>
      </TD></TR>
      <TR><TD class=FieldValue colspan=3>
       <span id=showRoleType name=showRoleType style="display:''">
          <%=labelService.getLabelName("402881ea0bf63f28010bf6428add0005")%>:
          <SELECT  class=InputStyle name=RoleType onchange="onChangeShareType()">
          <option value="0"><%=labelService.getLabelName("402881eb0bd66c95010bd6d19cf5000d")%></option>
          <option value="1" selected ><%=labelService.getLabelName("402881eb0bd66c95010bd6d13003000c")%></option>
          </SELECT>
        </span>
        <span id=showOrgObjType name=showOrgObjType style="display:''">
          <%=labelService.getLabelName("402881ea0bf63f28010bf64328a40007")%>:
          <SELECT  class=InputStyle name=OrgObjType onchange="onChangeShareType()">
           <%
        	list = selectitemService.getSelectitemList("402881ea0bf559c7010bf55e479f0013",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);
        		String optionvalue = StringHelper.null2String(_selectitem.getId());
        		//非工作流相关不显示工作流节点
        		if(refobjtype !=1 && optionvalue.equalsIgnoreCase("402881ea0bf559c7010bf5608b560015"))
        			continue;

        		//文档相关的只显示文档字段
        		String optdesc = StringHelper.null2String(_selectitem.getObjdesc());
//        		if(refobjtype==2 && !optionvalue.equalsIgnoreCase("402881ea0bf559c7010bf5608b560014") && optdesc.indexOf("{402881e70bc70ed1010bc710b74b000d}")==-1)
//        			continue;
        		//todo...项目相关的只显示项目，客户，产品。。。。


        %>

          <option value="<%=optionvalue%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>
          </SELECT>
        </span>

         <span id=showUserObjType name=showUserObjType style="display:''">
          <%=labelService.getLabelName("402881ea0bf9ae97010bf9b148fd0005")%>:
          <SELECT class=InputStyle name=UserObjType onchange="onChangeShareType()">
            <%
        	list = selectitemService.getSelectitemList("402881ea0bf559c7010bf55b290a0005",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);
        		String optionvalue = StringHelper.null2String(_selectitem.getId());
        		//非工作流相关不显示工作流节点
        		if(refobjtype !=1 && optionvalue.equalsIgnoreCase("402881ea0bf559c7010bf55ddf210007"))
        			continue;

        		//文档相关的只显示文档字段
        		String optdesc = StringHelper.null2String(_selectitem.getObjdesc());
//        		if(refobjtype==2 && !optionvalue.equalsIgnoreCase("402881ea0bf559c7010bf55ddf210006") && optdesc.indexOf("{402881e70bc70ed1010bc710b74b000d}")==-1)
//        			continue;
        		//todo...项目相关的只显示项目，客户，产品。。。。



        %>

          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>
          </SELECT>
        </span>

         <span id=showStationObjType name=showStationObjType style="display:''">
          <%=labelService.getLabelName("402881e510e569090110e56e72330003")%>:
          <SELECT class=InputStyle name=StationObjType onchange="onChangeShareType()">
            <%
        	list = selectitemService.getSelectitemList("297e828210f211130110f21a5ae00006",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);
        		String optionvalue = StringHelper.null2String(_selectitem.getId());
        %>

          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>
          </SELECT>
        </span>

        <span  name="showStationIDs" id="showStationIDs">
	        <BUTTON type="button" class=Browser style="display:''" onclick="javascript:getBrowser('/humres/base/stationlist.jsp?type=browser','StationIDs','StationIDsSpan','1');"></BUTTON>
	        <INPUT type=hidden name="StationIDs" id ="StationIDs"  value="">
	        <SPAN id=StationIDsSpan name=StationIDsSpan><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></SPAN>
        </span>
        <span  name="showUserIDs" id="showUserIDs">
	        <BUTTON type="button" class=Browser style="display:''" onclick="onShowMutiResource('UserIDsSpan','UserIDs')" ></BUTTON>
	        <INPUT type=hidden name="UserIDs" id ="UserIDs"  value="">
	        <SPAN id=UserIDsSpan name=UserIDsSpan><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></SPAN>
         </span>

        <span  name="showOrgObjID" id="showOrgObjID">
	        <BUTTON type="button" class=Browser style="display:''" onClick="onshowOrgObjID('OrgObjIDSpan','OrgObjID')"  ></BUTTON>
	        <INPUT type=hidden name="OrgObjID" id ="OrgObjID" value="">
	         <SPAN id=OrgObjIDSpan name=OrgObjIDSpan><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></SPAN>
         </span>
        <span id=showrelatedsharename name=showrelatedsharename></span>


        <!--
        //以下为工作流表单字段
        //文档字段
        -->
        <span id=showWFOperators name=showWFOperators style="display:block;">
          <%=labelService.getLabelName("402881ea0bf9ae97010bf9b5aeb90007")%>:
          <SELECT class=InputStyle name=WFOperatorNodeID onchange="onChangeShareType()">
         <%
         	if(refobjtype==1 && isworkflowid ==0 ){
         		Nodeinfo nodeinfo = nodeinfoService.get(objid);
         		if(nodeinfo != null){
         			list = nodeinfoService.getNodelistByworkflowid(nodeinfo.getWorkflowid());
         			for(int i=0;i < list.size();i++){
         				Nodeinfo _nodeinfo =(Nodeinfo)list.get(i);
         %>
         				<option value="<%=_nodeinfo.getId()%>"><%=StringHelper.null2String(_nodeinfo.getObjname())%></option>
         <%
         			}
         		}
         	}else if(refobjtype==1 && isworkflowid ==1 ){
         			list = nodeinfoService.getNodelistByworkflowid(objid);
         			for(int i=0;i < list.size();i++){
         				Nodeinfo _nodeinfo =(Nodeinfo)list.get(i);
         %>
         				<option value="<%=_nodeinfo.getId()%>"><%=StringHelper.null2String(_nodeinfo.getObjname())%></option>
         <%
         			}
         	}
         	%>
          </SELECT>
        </span>
        <!--  相关字段  -->
         <span id=showFormfileds name=showFormfileds style="display:''">
          <%=labelService.getLabelName("402881ea0bfa0b45010bfa12dfb80005")%>:
          <SELECT class=InputStyle name=FormfieldID>

          </SELECT>
        </span>
      </TD>
      </tr>
      <tr>
      <TD class=FieldValue colspan=3>
      <span id=showOrgShareType name=showOrgShareType style="display:''">
          <%=labelService.getLabelName("402881ea0bfa0b45010bfa16884d0007")%>:
          <SELECT class=InputStyle name=OrgShareType onchange="onChangeShareType('OrgShareType')">

            <%
        	list = selectitemService.getSelectitemList("402881ea0bfa0b45010bfa18ccee0009",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);
        %>

          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>
		</SELECT>
        </span>

        <span id=showOrgReftype name=showOrgReftype style="display:''">
          <%=labelService.getLabelName("297e828210f211130110f23717df000a")%>:
          		<SELECT class=InputStyle name=OrgReftype onchange="onChangeShareType()">
						<%
				        	list = selectitemService.getSelectitemList("402881e510e8223c0110e83c36010016",null);
				        	for(int i=0;i<list.size();i++){
				        		Selectitem _selectitem = (Selectitem)list.get(i);
				        %>
				          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
				          <%}%>
				</SELECT>
        </span>

        <span id=showRoleObjID name=showRoleObjID style="display:''">
          <%=labelService.getLabelName("402881ea0bfa67d7010bfa68fe0b0005")%>:
          		<SELECT class=InputStyle name=RoleType2 onchange="onChangeShareType()">
						<%
				        	list = selectitemService.getSelectitemList("4028819a0f16b8f1010f179d1c2c000e",null);
				        	for(int i=0;i<list.size();i++){
				        		Selectitem _selectitem = (Selectitem)list.get(i);
				        %>
				          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
				          <%}%>
				</SELECT>
        </span>
        <span id=showrolename name=showrolename style="display:''">
        <BUTTON type="button" class=Browser style="display:''"  onclick="onshowRoleObjID('showrolename2','RoleObjID')" ></BUTTON>
        <INPUT type=hidden name="RoleObjID" id ="RoleObjID" value="">
        <span id=showrolename2 name=showrolename2 style="display:''"><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></span>
        </span>
        <span id=role_zidu name=role_zidu style="display:'none'">
     			相关字段：

          		<SELECT class=InputStyle name=role_ziduid >

				</SELECT>
		</span>


        <span id=showUserShareType name=showUserShareType style="display:''">
          <%=labelService.getLabelName("402881ea0bfa0b45010bfa16884d0007")%>:
          <SELECT class=InputStyle name=UserShareType onchange="onChangeShareType()">
          <%
        	list = selectitemService.getSelectitemList("402880151176095801117665f7c30009",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);
        %>

          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>
	</SELECT>
        </span>

        <span id=showPositionType name=showPositionType style="display:''">
          岗位级别:
           <SELECT class=InputStyle name="position">
          <%
        	list = selectitemService.getSelectitemList("40288019120556350112058e3b92000c",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);
        %>

          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>
          </SELECT>
        </span>
        <span id=showOrgUnitType name=showOrgUnitType style="display:''">
          <SELECT class=InputStyle name=OrgUnitType>
	       <%

        	list = orgunittypeService.getOrgunittypeList();
        	for(int i=0;i<list.size();i++){
        		Orgunittype _orgunittype = (Orgunittype)list.get(i);
        %>

          <option value="<%=_orgunittype.getId()%>"><%=StringHelper.null2String(_orgunittype.getObjname())%></option>
          <%}%>
	</SELECT>
        </span>

        <span id=showOrgManager name=showOrgManager style="display:''">
          <SELECT class="InputStyle2"  name=OrgManager onchange="onChangeShareType()">
          <option value="0" selected ><%=labelService.getLabelName("402881e70b774c35010b774cceb80008")%></option>
          <option value="1"><%=labelService.getLabelName("402881ea0bfa7679010bfa7948b20005")%></option>
	</SELECT>
        </span>

        <span id=showseclevel name=showseclevel style="display:''">
        <%=labelService.getLabelName("402881e70b774c35010b774cceb80008")%>:
        <INPUT type=text class="InputStyle2"  id=minseclevel name=minseclevel size=6 value="10">
        <SPAN id=seclevelimage name=seclevelimage><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></SPAN> -&nbsp;<INPUT type=text class="InputStyle2"  id=maxseclevel name=maxseclevel size=6 value="">

        </span>


      </TD>
      </tr>
      <!--系统表单、流程创建节点、归档节点-->
      <% if((refobjtype!=1 || nodetype==1 || nodetype == 4 || isworkflowid ==1)){%>
      <tr>
      <TD class=FieldValue>
        <%=labelService.getLabelName("402881ea0bfa7679010bfa8999a3001b")%>:
      <SELECT class="InputStyle2"  name=RightType id="RightType" <%if(istype==1&&!"requestbase".equals(objtable)&&!"workflowinfo".equals(objtable)){%> onchange="showMyRestrictions()"<%}%>>
       <%
        	list = selectitemService.getSelectitemList("402880371fb07b8d011fb0889c890002",null);

           for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
               if(optcode.equalsIgnoreCase("6")||optcode.equalsIgnoreCase("9")){
        	   String objnamestr="";
                   if(optcode.equalsIgnoreCase("6"))
                   objnamestr="参与人投票";
                   if(optcode.equalsIgnoreCase("9"))
                       objnamestr="查看投票结果";


        %>

          <option value="<%=optcode%>"><%=StringHelper.null2String(objnamestr)%></option>
          <%
          }}%>
      </SELECT>
          </TD>
          <TD class=FieldValue></TD>
              <TD class=FieldValue>
      <select id="notifydefineid" name="notifydefineid" style="display:none">
          <%
              List<NotifyDefine> notifydefinelist = notifyDefineService.getNotifyDefineListByHql("from NotifyDefine where remindtype=4 and categoryid='"+objid+"'");
              if(notifydefinelist==null){
                  notifydefinelist = new ArrayList();
              }
              for(NotifyDefine notifyDefine:notifydefinelist){
          %>
          <option value="<%=notifyDefine.getId()%>"><%=notifyDefine.getNotifyName()%></option>
          <%}%>
      </select>
      </td>
      </tr>
      <%}%>

      <!--文档附件操作类型-->
      <% if(refobjtype==2){%>
	      <tr>
	      <TD class=FieldValue colspan=3>
	        <%=labelService.getLabelName("402881ea0bfa7679010bfa8c18dc001d")%>:
	      <SELECT class="InputStyle2" name=RightType2>
	       <%
	        	list = selectitemService.getSelectitemList("402881ea0bfa7679010bfa854d8a000e",null);
	        	for(int i=0;i<list.size();i++){
	        		Selectitem _selectitem = (Selectitem)list.get(i);
	        %>

	          <option value="<%=_selectitem.getObjdesc()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
	          <%}%>
	      </SELECT>
	      </td>
	      </tr>
      <%}%>

      <!--流程活动节点操作方式-->
      <% if(refobjtype==1 && nodetype!= 1 && nodetype != 4 && isworkflowid == 0){%>
	      <tr>
	      <TD class=FieldValue colspan=3>
	        <%=labelService.getLabelName("402881ea0bfa7679010bfa8c8765001f")%>:
	      <SELECT class="InputStyle2"  name=RightType3>
	       <%
	        	list = selectitemService.getSelectitemList("402881ea0bfa7679010bfa86f3f70016",null);
	        	for(int i=0;i<list.size();i++){
	        		Selectitem _selectitem = (Selectitem)list.get(i);
	        %>

	          <option value="<%=_selectitem.getObjdesc()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
	          <%}%>
	      </SELECT>
	      </td>
	      </tr>
      <%}
      if(refobjtype==1 && nodetype == 4){
      %>
      <input type="hidden" name="RightType3" value="3">
      <%}%>


      </TD>
      </tr>
      <%
      if(istype==1&&!"requestbase".equals(objtable)&&!"workflowinfo".equals(objtable)){
      %>
      <!--限制字段-->
      <tr id="restrictionsFieldtr" style="display:none"></tr>

      <!--字段相关项-->
      <tr id="fieldOftr" style="display:none"></tr>
      <%
          }
      %>
      <!--子表记录-->
      <tr>
      <td class="fieldvalue" colspan="3">
      子表记录:
      <select class="inputstyle2" name="detailFilter" >
      <option></option>
      <option value="1">非所在行隐藏</option>
      <option value="2">非所在行只读</option>
      </select>
      </td>
      </tr>

      <!--对应布局设置-->
      <%
            String strDefHql="from Formlayout where formid='"+formid+"'";
            FormlayoutService formlayoutService = (FormlayoutService)BaseContext.getBean("formlayoutService");
            List listdef = formlayoutService.findFormlayout(strDefHql);
            List layoutlist = new ArrayList();
            layoutlist.addAll(listdef);
      %>
      <% if((refobjtype!=1 || nodetype == 4 || isworkflowid ==1)){%>
      <tr>
      <TD class=FieldValue colspan=3>
            页面布局;
            <select class="inputstyle" style="width:180px" id="layoutid" name="layoutid" >
            <option value=""></option>
            <%
            for(int i=0; i<layoutlist.size(); i++){
                Formlayout formlayout=(Formlayout)layoutlist.get(i);
                String selected = "";%>
                <option value=<%=formlayout.getId()%>><%=formlayout.getLayoutname()%></option>
            <%}%>
            </select>

            优先级;
            <INPUT type=text class="InputStyle2"  id="priority" name="priority" MAXLENGTH =3 value="">
      </td>
      </tr>
      <%}%>
      <% if((nodetype==1 || nodetype == 2 )){%>
      <tr>
      <TD class=FieldValue colspan=3>
            编辑布局;
            <select class="inputstyle" style="width:180px" id="layoutid" name="layoutid" >
            <option value=""></option>
            <%
            for(int i=0; i<layoutlist.size(); i++){
                Formlayout formlayout=(Formlayout)layoutlist.get(i);
                if(formlayout.getTypeid().intValue() == 2){
                    String selected = "";%>
                    <option value=<%=formlayout.getId()%>><%=formlayout.getLayoutname()%></option>
                <%}
            }%>
            </select>

            查看布局;
            <select class="inputstyle" style="width:180px" id="layoutid1" name="layoutid1" >
            <option value=""></option>
            <%
            for(int i=0; i<layoutlist.size(); i++){
                Formlayout formlayout=(Formlayout)layoutlist.get(i);
                if(formlayout.getTypeid().intValue() == 1){
                    String selected = "";%>
                    <option value=<%=formlayout.getId()%>><%=formlayout.getLayoutname()%></option>
                <%}
            }%>
            </select>

            优先级;
            <INPUT type=text class="InputStyle2"  id="priority" name="priority" MAXLENGTH =3 value="">
      </td>
      </tr>
      <%}%>
<TR><TD class=Line colSpan=3></TD></TR>


    </TBODY>
  </TABLE>

  <table class=ViewForm>
  <colgroup>
  <col width="30%">
  <col width="60%">
  <col width="10%">
  <tr class=Title>
    <th colspan=3>
        <%=labelService.getLabelName("402881ea0bfa7679010bfa8d96540021")%>
</th>
    </tr>
  <tr class=Spacing>
    <td class=Line1 colspan=3></td>
  </tr>

  <%
  	String hsql = "from Permissionrule where objid ='"+objid+"' and istype='"+istype+"'  order by opttype,docattopttype,wfopttype,priority";
	list = permissionruleService.find(hsql);
	for(int index=0;index<list.size();index++){
		Permissionrule permissionrule = (Permissionrule)list.get(index);
		String RuleID = StringHelper.trimToNull(permissionrule.getId());
  		String ShareType = StringHelper.trimToNull(permissionrule.getSharetype());
		String RoleType = StringHelper.trimToNull(permissionrule.getRoletype());
		String OrgObjType = StringHelper.trimToNull(permissionrule.getOrgobjtype());
		String UserObjType = StringHelper.trimToNull(permissionrule.getUserobjtype());
		String UserIDs = StringHelper.trimToNull(permissionrule.getUserids());
		String OrgObjID = StringHelper.trimToNull(permissionrule.getOrgobjid());
		String WFOperatorNodeID = StringHelper.trimToNull(permissionrule.getWfoperatornodeid());
		String FormfieldID = StringHelper.trimToNull(permissionrule.getFormfieldid());
		String OrgShareType = StringHelper.trimToNull(permissionrule.getOrgsharetype());
		String RoleObjID = StringHelper.trimToNull(permissionrule.getRoleobjid());
		String UserShareType = StringHelper.trimToNull(permissionrule.getUsersharetype());
		String OrgUnitType = StringHelper.trimToNull(permissionrule.getOrgunittype());

		String StationObjType = StringHelper.trimToNull(permissionrule.getStationobjtype());
		String StationIDs = StringHelper.trimToNull(permissionrule.getStationid());
		String OrgReftype = StringHelper.trimToNull(permissionrule.getOrgreftype());
		String notifydefineid = StringHelper.trimToNull(permissionrule.getNotifydefineid());

		Integer OrgManager = permissionrule.getOrgmanager();
		Integer minseclevel = permissionrule.getMinseclevel();
		Integer maxseclevel = permissionrule.getMaxseclevel();
		Integer RightType1 = permissionrule.getOpttype();
		if(RightType1!=6&&RightType1!=9){
		 continue;
		}
		Integer RightType2 = permissionrule.getDocattopttype();
		Integer RightType3 = permissionrule.getWfopttype();

        String layoutid = permissionrule.getLayoutid();
        String layoutid1 = permissionrule.getLayoutid1();
        Integer priority = permissionrule.getPriority();
        String detailFilter = permissionrule.getDetailFilter();
        String restrictionsField = permissionrule.getRestrictionsField();
        Formfield restrictionsObj = formfieldService.getFormfieldById(restrictionsField);
        String fieldOf = permissionrule.getFieldOf();
        List listObj = StringHelper.string2ArrayList(fieldOf,",");
        List fieldOfList = new ArrayList();
        String selectitemid;
        for(int i=0;i<listObj.size();i++){
            selectitemid=(String)listObj.get(i);
            Selectitem selectitem=selectitemService.getSelectitemById(selectitemid);
            fieldOfList.add(selectitem.getObjname());
        }
  %>
  	<TR>
      <TD>
      <%
      if(RightType1!=null){
      		List list1 = selectitemService.getSelectitemList("402880371fb07b8d011fb0889c890002",null);
        	for(int i=0;i<list1.size();i++){
        		Selectitem _selectitem = (Selectitem)list1.get(i);
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		if(RightType1.intValue() == NumberHelper.string2Int(optcode)){
                    String objnamestr="";
                    if(RightType1.intValue()==6){
                        objnamestr="参与人投票";
                    }
                    if(RightType1.intValue()==9){
                      objnamestr="查看投票结果";
                    }
        			out.print("<B>["+StringHelper.null2String(objnamestr)+"]</b>");
                }
        	}
       }
      if(RightType2!=null){
      		List list1  = selectitemService.getSelectitemList("402881ea0bfa7679010bfa854d8a000e",null);
        	for(int i=0;i<list1.size();i++){
        		Selectitem _selectitem = (Selectitem)list1.get(i);
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		if(RightType2.intValue() == NumberHelper.string2Int(optcode))
        			out.print("<B>["+StringHelper.null2String(_selectitem.getObjname())+"]</b>");
        	}
       }
      if(RightType3!=null){
      		List list1  = selectitemService.getSelectitemList("402881ea0bfa7679010bfa86f3f70016",null);
        	for(int i=0;i<list1.size();i++){
        		Selectitem _selectitem = (Selectitem)list1.get(i);
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		if(RightType3.intValue() == NumberHelper.string2Int(optcode))
        			out.print("<B>["+StringHelper.null2String(_selectitem.getObjname())+"]</b>");
        	}
       }

       Selectitem _selectitem = selectitemService.getSelectitemById(ShareType);
       out.print("&nbsp;"+StringHelper.null2String(_selectitem.getObjname()));
      	%>
      </TD>
	  <TD class=FieldValue>
      <table>
      <tr><td>
	  <%
	  	String outString = "";
	  	if("402881e60bf4f747010bf4fec8f80007".equals(ShareType)){
	  		_selectitem = selectitemService.getSelectitemById(UserObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";
	  		if("402881ea0bf559c7010bf55ddf210006".equals(UserObjType)){
       		 	ArrayList arrUserids = StringHelper.string2ArrayList(UserIDs,",");
  				for(int i=0;i<arrUserids.size();i++){
  					String _userid = ""+arrUserids.get(i);
  					Humres humres = (Humres)humresService.getHumresById(_userid);
  					outString += StringHelper.null2String(humres.getObjname())+"&nbsp;";
  				}
      		}else if("402881ea0bf559c7010bf55ddf210007".equals(UserObjType)){
      			Nodeinfo nodeinfo = nodeinfoService.get(WFOperatorNodeID);
  				outString += StringHelper.null2String(nodeinfo.getObjname())+"&nbsp;";
      		}else{
      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);
  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
      		}
      	}else 	if("402881e510efab3d0110efb21a700005".equals(ShareType)){
	  		_selectitem = selectitemService.getSelectitemById(StationObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";
	  		if("297e828210f211130110f21d99710009".equals(StationObjType)){
	  			StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
					Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(StationIDs);
				   outString += StringHelper.null2String(stationinfo.getObjname())+"&nbsp;";
      		}else if("40288015117609580111763947b80007".equals(StationObjType)){
      			Nodeinfo nodeinfo = nodeinfoService.get(WFOperatorNodeID);
  				outString += StringHelper.null2String(nodeinfo.getObjname())+"&nbsp;";
      		}else{
      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);
  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
      		}
      	}else if("402881e60bf4f747010bf4fec8f80008".equals(ShareType)){
        	outString += labelService.getLabelName("402881e70b774c35010b774cceb80008")+":";
        	if(minseclevel != null)
        		outString += ""+minseclevel.intValue();
        	if(maxseclevel != null)
        		outString +="&nbsp;－&nbsp;"+maxseclevel.intValue();
      	}else if("402881e60bf4f747010bf4fec8f80009".equals(ShareType)){
	  		_selectitem = selectitemService.getSelectitemById(OrgObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";
	  		if("402881ea0bf559c7010bf5608b560014".equals(OrgObjType)){
       		 	ArrayList arrUserids = StringHelper.string2ArrayList(OrgObjID,",");
  				for(int i=0;i<arrUserids.size();i++){
  					String _userid = ""+arrUserids.get(i);
  					Orgunit orgunit = (Orgunit)orgunitService.getOrgunit(_userid);
  					outString += StringHelper.null2String(orgunit.getObjname())+"&nbsp;";
  				}
      		}else if("402881ea0bf559c7010bf5608b560015".equals(OrgObjType)){
      			Nodeinfo nodeinfo = nodeinfoService.get(WFOperatorNodeID);
  				outString += StringHelper.null2String(nodeinfo.getObjname())+"&nbsp;";
      		}else{
      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);
  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
      		}

        	outString += "/"+labelService.getLabelName("402881ea0bfa0b45010bfa16884d0007")+":";
	  		_selectitem = selectitemService.getSelectitemById(OrgShareType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+"&nbsp;";

       		if(!"402881ea0bfa0b45010bfa19f3bb000a".equals(OrgShareType)){
		  		_selectitem = selectitemService.getSelectitemById(OrgReftype);
	       		outString += "("+StringHelper.null2String(_selectitem.getObjname())+")&nbsp;";
			}
       	if(!"402881ea0bfa0b45010bfa19f3bb000a".equals(OrgShareType) && !"402881ea0bfa0b45010bfa19f3bb000b".equals(OrgShareType)){
       	 		Orgunittype orgunittype = (Orgunittype)orgunittypeService.getOrgunittype(OrgUnitType);
  				outString += StringHelper.null2String(orgunittype.getObjname())+"&nbsp;";
			}
			if(OrgManager.equals(new Integer(0))){
				outString += "/"+labelService.getLabelName("402881e70b774c35010b774cceb80008")+":";
	        	outString += ""+minseclevel.intValue();
	        	if(maxseclevel != null)
	        		outString +="&nbsp;－&nbsp;"+maxseclevel.intValue();
			}else
				outString += "/"+labelService.getLabelName("402881ea0bfa7679010bfa7948b20005");
      	}else if("402881e60bf4f747010bf4fec8f8000a".equals(ShareType)){


      		_selectitem = selectitemService.getSelectitemById(StationObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";
	  		if("297e828210f211130110f21d99710009".equals(StationObjType)){
	  			StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
					Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(StationIDs);
				   outString += StringHelper.null2String(stationinfo.getObjname())+"&nbsp;";
      		}else if("40288015117609580111763947b80007".equals(StationObjType)){
      			Nodeinfo nodeinfo = nodeinfoService.get(WFOperatorNodeID);
  				outString += StringHelper.null2String(nodeinfo.getObjname())+"&nbsp;";
      		}else{
      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);
  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
      		}

		  		_selectitem = selectitemService.getSelectitemById(OrgReftype);
	       		outString += "/"+StringHelper.null2String(_selectitem.getObjname())+"&nbsp;";

	  		_selectitem = selectitemService.getSelectitemById(UserShareType);
       		outString += "("+StringHelper.null2String(_selectitem.getObjname())+")&nbsp;";

       		if("4028801511760958011176701f79000f".equals(UserShareType)){
       			Orgunittype orgunittype = (Orgunittype)orgunittypeService.getOrgunittype(OrgUnitType);
  				outString += "&nbsp;"+StringHelper.null2String(orgunittype.getObjname());
       		}
       		if("4028804112055e810112059ba0c10007".equals(UserShareType)){
	  			_selectitem = selectitemService.getSelectitemById(OrgUnitType);
  				outString += "&nbsp;"+StringHelper.null2String(_selectitem.getObjname());
       		}
      	}else if("402881e60bf4f747010bf4fec8f8000b".equals(ShareType)){


      		_selectitem = selectitemService.getSelectitemById(StationObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";
	  		if("297e828210f211130110f21d99710009".equals(StationObjType)){
	  			StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
					Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(StationIDs);
				   outString += StringHelper.null2String(stationinfo.getObjname())+"&nbsp;";
      		}else if("40288015117609580111763947b80007".equals(StationObjType)){
      			Nodeinfo nodeinfo = nodeinfoService.get(WFOperatorNodeID);
  				outString += StringHelper.null2String(nodeinfo.getObjname())+"&nbsp;";
      		}else{
      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);
  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
      		}

		  		_selectitem = selectitemService.getSelectitemById(OrgReftype);
	       		outString += "/"+StringHelper.null2String(_selectitem.getObjname())+"&nbsp;";

	  		_selectitem = selectitemService.getSelectitemById(UserShareType);
       		outString += "("+StringHelper.null2String(_selectitem.getObjname())+")&nbsp;";
      	}else if("402881e60bf4f747010bf4fec8f8000c".equals(ShareType)){
      		if("-1".equals(UserShareType)){
      			UserShareType = "402881d90f2cbe0d010f2d048cdc000d";
      		}

      		_selectitem = selectitemService.getSelectitemById(UserShareType);
      		outString += StringHelper.null2String(_selectitem.getObjname())+":";
      		if("402881d90f2cbe0d010f2d048cdc000d".equals(UserShareType)||"-1".equals(UserShareType)){
      			Sysrole sysrole = (Sysrole)sysroleService.get(RoleObjID);
      			outString += StringHelper.null2String(sysrole.getRolename())+"&nbsp;";
      		}else{
      			Formfield formfield = formfieldService.getFormfieldById(RoleObjID);
  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
      		}
      		if("1".equals(RoleType)){
      			_selectitem = selectitemService.getSelectitemById(OrgObjType);
	       		outString += "/"+StringHelper.null2String(_selectitem.getObjname())+":";
		  		if("402881ea0bf559c7010bf5608b560014".equals(OrgObjType)){
	       		 	ArrayList arrUserids = StringHelper.string2ArrayList(OrgObjID,",");
	  				for(int i=0;i<arrUserids.size();i++){
	  					String _userid = ""+arrUserids.get(i);
	  					Orgunit orgunit = (Orgunit)orgunitService.getOrgunit(_userid);
	  					outString += StringHelper.null2String(orgunit.getObjname())+"&nbsp;";
	  				}
	      		}else if("402881ea0bf559c7010bf5608b560015".equals(OrgObjType)){
	      			Nodeinfo nodeinfo = nodeinfoService.get(WFOperatorNodeID);
	  				outString += StringHelper.null2String(nodeinfo.getObjname())+"&nbsp;";
	      		}else{
	      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);
	  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
	      		}

      		}

      	}
      	%>
	  <%=outString%>
      </td></tr>

      <%if("1".equals(detailFilter)){ %>
      		<tr><td>子表记录:非所在行隐藏</td></tr>
      <%}else if("2".equals(detailFilter)){ %>
      		<tr><td>子表记录:非所在行只读</td></tr>
      <%} %>

      <% if((refobjtype!=1 || nodetype == 4 || isworkflowid ==1)){%>
            <%if(layoutid!=null && !layoutid.equals("")){%>
            <tr><td>页面布局:<%=formlayoutService.getFormlayoutById(layoutid).getLayoutname()%></td></tr>
            <tr><td>优先级:<%=priority%></td></tr>
            <%}%>
      <%}%>
      <% if((nodetype==1 || nodetype == 2 )){%>
            <%if((layoutid!=null && !layoutid.equals(""))||(layoutid1!=null && !layoutid1.equals(""))){%>
            <tr><td>编辑布局:<%=formlayoutService.getFormlayoutById(layoutid).getLayoutname()%></td></tr>
            <tr><td>查看布局:<%=formlayoutService.getFormlayoutById(layoutid1).getLayoutname()%></td></tr>
            <tr><td>优先级:<%=priority%></td></tr>
            <%}%>
      <%}%>
      <%
          if(restrictionsField!=null&&!"".equals(restrictionsField)){
      %>
            <tr><td>限制字段:<%=restrictionsObj.getFieldname()+"→"+restrictionsObj.getLabelname()%>&nbsp;<a href="javascript:void(0)" onmouseover="showFieldOf('<%=RuleID%>','<%=fieldOfList.size()%>')" onmouseout="closeFieldOf('<%=RuleID%>','<%=fieldOfList.size()%>')">查看相关限制项?</a></td></tr>
      <%
            for(int i=0;i<fieldOfList.size();i++){
            %>
            <tr id="<%=RuleID+","+i%>" style="display:none"><td><%=fieldOfList.get(i).toString()%></td></tr>
            <%
            }
          }
      %>
    </table>
    </td>
	<td class=FieldValue>
	<a href="javascript:deleteperrule('<%=RuleID%>','<%=objid%>','<%=objtable%>','<%=istype%>')">
		<%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%></a>
	</td>
  </tr>
  <%}%>





		</TABLE>
        <div id="mychoosediv">
        <table id="showFieldOf">
        </table>
        </div>
        </FORM>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>

</table>
</td>
<td ></td>
</tr>
</table>
<script language="javascript">
onChangeShareType();

function check_by_ShareType() {
    //alert(document.mainform.ShareType.value);
    if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f80007" && document.mainform.UserObjType.value=="402881ea0bf559c7010bf55ddf210006") {
        return checkForm(mainform, "UserIDs","必填项不能为空！");
    }else if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f80009" && document.all("showOrgObjID").style.display!="none"){

       return checkForm(mainform, "OrgObjID","必填项不能为空！");
    } else if (document.mainform.ShareType.value == "402881e510efab3d0110efb21a700005" && document.mainform.StationObjType.value=="297e828210f211130110f21d99710009"){

       return checkForm(mainform, "StationIDs","必填项不能为空！");
    } else if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f80008" || document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f80009") {
        return checkForm(mainform, "minseclevel","必填项不能为空！");
    } else if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f80009" && document.mainform.OrgObjType.value=="402881ea0bf559c7010bf5608b560014") {
        return checkForm(mainform, "OrgObjID","必填项不能为空！");
    } else if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f8000c" && document.mainform.OrgObjType.value=="402881ea0bf559c7010bf5608b560014" && document.mainform.RoleType.value==1) {
        return checkForm(mainform, "RoleObjID","必填项不能为空！");
    } else if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f8000c" && document.all("RoleType2").value=="1") {
        return checkForm(mainform, "RoleObjID","必填项不能为空！");
    } else {

        return true;
    }

}



function recreate(){
	document.mainform.action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionAction?action=recreate";
	document.mainform.submit();
}

function onChangeShareType(from) {

	thisvalue=document.mainform.ShareType.value;
//	if (typeof(from)=='undefined'){
//	  document.mainform.OrgObjID.value="";
//	}


//	document.mainform.UserIDs.value="";
//	document.mainform.StationIDs.value="";
//	document.mainform.RoleObjID.value="";

//	document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>";

 	document.all("showrolename").style.display='none';
    document.all("role_zidu").style.display='none';

	document.all("showPositionType").style.display = 'none';

	if (thisvalue == "402881e60bf4f747010bf4fec8f80007") {
		_sharetype = document.all("UserObjType").value;
		if(_sharetype == "402881ea0bf559c7010bf55ddf210006"){	//指定人员

	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = '';
			document.all("showUserIDs").style.display = '';
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
		//	document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>"
			document.all("showrolename").style.display = 'none';

	 	}else if(_sharetype == "402881ea0bf559c7010bf55ddf210007"){	//流程操作者相关


		 	//需要将当前工作流的节点信息读取到下拉框中。。。。




	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = '';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = '';
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
		//	document.all("showrelatedsharename").innerHTML = ""


	 	}else {	//其他
	 		//需要读取不同的字段到选择框中。。。


			getformfield(_sharetype);
	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = '';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';
	 		document.all("showFormfileds").style.display = '';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
	//		document.all("showrelatedsharename").innerHTML = ""
	 	}
    }else if (thisvalue == "402881e510efab3d0110efb21a700005") {
		_sharetype = document.all("StationObjType").value;
		if(_sharetype == "297e828210f211130110f21d99710009"){	//指定岗位

	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = '';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
	//		document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>"
			document.all("showrolename").style.display = 'none';

	 	}else if(_sharetype == "40288015117609580111763947b80007"){	//指定岗位

	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = '';
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
		//	document.all("showrelatedsharename").innerHTML = ""
			document.all("showrolename").style.display = 'none';

	 	}else {	//其他
	 		//需要读取不同的字段到选择框中。。。


			getformfield(_sharetype);
	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';
	 		document.all("showFormfileds").style.display = '';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
	//		document.all("showrelatedsharename").innerHTML = ""
	 	}
    }
	else if (thisvalue == "402881e60bf4f747010bf4fec8f80008") {	//所有人+安全级别


	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = '';
		//	document.all("showrelatedsharename").innerHTML = ""
			document.all("showrolename").style.display = 'none';
	}
	else if (thisvalue == "402881e60bf4f747010bf4fec8f80009") {	//组织单元+安全级别+作用域


	    _sharetype = document.all("OrgObjType").value;
		if(_sharetype == "402881ea0bf559c7010bf5608b560014"){	//指定组织单元

	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = '';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = '';
	 		document.all("showWFOperators").style.display = 'none';
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = '';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	 		document.all("showrolename").style.display = 'none';
			//document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>"

	 		document.all("showOrgShareType").style.display = '';
	 		_orgSharetype = document.all("OrgShareType").value;
	 		if(_orgSharetype == "402881ea0bfa0b45010bfa19f3bb000a" || _orgSharetype == "402881ea0bfa0b45010bfa19f3bb000b")
	 			document.all("showOrgUnitType").style.display = 'none';
	 		else
	 			document.all("showOrgUnitType").style.display = '';

	 		if(_orgSharetype != "402881ea0bfa0b45010bfa19f3bb000a")
	 			document.all("showOrgReftype").style.display = '';

	 		document.all("showseclevel").style.display = '';

	 			document.all("showOrgManager").style.display = '';
		 		_OrgManage = document.all("OrgManager").value;
		 		if(_OrgManage == 0 )
		 			document.all("showseclevel").style.display = '';
		 		else
		 			document.all("showseclevel").style.display = 'none';


	 	}else if(_sharetype == "402881ea0bf559c7010bf5608b560015"){	//流程节点操作者相关组织单元



		 	//需要将当前工作流的节点信息读取到下拉框中。。。。


	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = '';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = '';
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = '';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	//		document.all("showrelatedsharename").innerHTML = ""
			document.all("showrolename").style.display = 'none';

	 		document.all("showOrgShareType").style.display = '';
	 		_orgSharetype = document.all("OrgShareType").value;
	 		if(_orgSharetype == "402881ea0bfa0b45010bfa19f3bb000a" || _orgSharetype == "402881ea0bfa0b45010bfa19f3bb000b")
	 			document.all("showOrgUnitType").style.display = 'none';
	 		else
	 			document.all("showOrgUnitType").style.display = '';

	 		if(_orgSharetype != "402881ea0bfa0b45010bfa19f3bb000a")
	 			document.all("showOrgReftype").style.display = '';

	 		document.all("showseclevel").style.display = '';

	 			document.all("showOrgManager").style.display = '';
		 		_OrgManage = document.all("OrgManager").value;
		 		if(_OrgManage == 0 )
		 			document.all("showseclevel").style.display = '';
		 		else
		 			document.all("showseclevel").style.display = 'none';



	 	}else {	//其他
	 		//需要读取不同的字段到选择框中。。。



			getformfield(_sharetype);
	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = '';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';
	 		document.all("showFormfileds").style.display = '';
	 		document.all("showOrgShareType").style.display = '';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	//		document.all("showrelatedsharename").innerHTML = ""
			document.all("showrolename").style.display = 'none';

	 		document.all("showOrgShareType").style.display = '';
	 		_orgSharetype = document.all("OrgShareType").value;
	 		if(_orgSharetype == "402881ea0bfa0b45010bfa19f3bb000a" || _orgSharetype == "402881ea0bfa0b45010bfa19f3bb000b")
	 			document.all("showOrgUnitType").style.display = 'none';
	 		else
	 			document.all("showOrgUnitType").style.display = '';


	 		if(_orgSharetype != "402881ea0bfa0b45010bfa19f3bb000a")
	 			document.all("showOrgReftype").style.display = '';

	 		document.all("showseclevel").style.display = '';

	 			document.all("showOrgManager").style.display = '';
		 		_OrgManage = document.all("OrgManager").value;
		 		if(_OrgManage == 0 )
		 			document.all("showseclevel").style.display = '';
		 		else
		 			document.all("showseclevel").style.display = 'none';
		 }
	}
	else if (thisvalue == "402881e60bf4f747010bf4fec8f8000a") {	 //人员+经理

        _sharetype = document.all("StationObjType").value;
	    _usersharetype = document.all("UserShareType").value;
        if(_sharetype == "297e828210f211130110f21d99710009"){	//指定岗位

	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = '';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = '';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = '';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
	//		document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>"
			document.all("showrolename").style.display = 'none';
			if(_usersharetype == "4028801511760958011176701f79000f")
	 			document.all("showOrgUnitType").style.display = '';
	 		else
	 			document.all("showOrgUnitType").style.display = 'none';

	 		if(_usersharetype == "4028804112055e810112059ba0c10007")
	 			document.all("showPositionType").style.display = '';
	 		else
	 			document.all("showPositionType").style.display = 'none';

	 	}else if(_sharetype == "40288015117609580111763947b80007"){	//指定岗位

	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = '';
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = '';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = '';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
	//		document.all("showrelatedsharename").innerHTML = ""
			document.all("showrolename").style.display = 'none';
	 		if(_usersharetype == "4028801511760958011176701f79000f")
	 			document.all("showOrgUnitType").style.display = '';
	 		else
	 			document.all("showOrgUnitType").style.display = 'none';

	 		if(_usersharetype == "4028804112055e810112059ba0c10007")
	 			document.all("showPositionType").style.display = '';
	 		else
	 			document.all("showPositionType").style.display = 'none';
	 	}else {	//其他
	 		//需要读取不同的字段到选择框中。。。

			getformfield(_sharetype);
	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';
	 		document.all("showFormfileds").style.display = '';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = '';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = '';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
	//		document.all("showrelatedsharename").innerHTML = ""
	 		if(_usersharetype == "4028801511760958011176701f79000f")
	 			document.all("showOrgUnitType").style.display = '';
	 		else
	 			document.all("showOrgUnitType").style.display = 'none';

	 		if(_usersharetype == "4028804112055e810112059ba0c10007")
	 			document.all("showPositionType").style.display = '';
	 		else
	 			document.all("showPositionType").style.display = 'none';
	 	}
	}
	else if (thisvalue == "402881e60bf4f747010bf4fec8f8000b") {	 //人员+经理
        _sharetype = document.all("StationObjType").value;
		if(_sharetype == "297e828210f211130110f21d99710009"){	//指定岗位

	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = '';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = '';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	 		document.all("showPositionType").style.display = '';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
	//		document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>"
			document.all("showrolename").style.display = 'none';

	 	}else if(_sharetype == "40288015117609580111763947b80007"){	//指定岗位

	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = '';
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = '';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	 		document.all("showPositionType").style.display = '';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
	//		document.all("showrelatedsharename").innerHTML = ""
			document.all("showrolename").style.display = 'none';
	 	}else {	//其他
	 		//需要读取不同的字段到选择框中。。。


			getformfield(_sharetype);
	 		document.all("showRoleType").style.display = 'none';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';
	 		document.all("showFormfileds").style.display = '';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = '';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';
	 		document.all("showPositionType").style.display = '';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
	//		document.all("showrelatedsharename").innerHTML = ""
	 	}
	}
	else if (thisvalue == "402881e60bf4f747010bf4fec8f8000c") { //组织单元+角色+作用域

			_roletype = document.all("RoleType").value;
			_roletype2 = document.all("RoleType2").value;
		if(_roletype2=="4028819a0f16b8f1010f179d98730010"){
				_sharetype = document.all("RoleType2").value;
				getformfield2(_sharetype);
			 	document.all("showrolename").style.display='none';
	 	       document.all("role_zidu").style.display='';
	 	 }else{
	 	       document.all("showrolename").style.display='';
	 	       document.all("role_zidu").style.display='none';
	 	 }
		if(_roletype == 0){

	 		document.all("showRoleType").style.display = '';
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = '';
	 		document.all("showUserShareType").style.display = 'none';
	 		document.all("showOrgUnitType").style.display = 'none';
	 		document.all("showOrgManager").style.display = 'none';
	 		document.all("showseclevel").style.display = 'none';
		//	document.all("showrelatedsharename").innerHTML = ""

		}else{
			_sharetype = document.all("OrgObjType").value;
			if(_sharetype == "402881ea0bf559c7010bf5608b560014"){	//指定组织单元

		 		document.all("showRoleType").style.display = '';
		 		document.all("showOrgObjType").style.display = '';
		 		document.all("showUserObjType").style.display = 'none';
				document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';
		 		document.all("showOrgObjID").style.display = '';
		 		document.all("showWFOperators").style.display = 'none';
		 		document.all("showFormfileds").style.display = 'none';
		 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
		 		document.all("showRoleObjID").style.display = '';
		 		document.all("showUserShareType").style.display = 'none';
		 		document.all("showOrgUnitType").style.display = 'none';
		 		document.all("showOrgManager").style.display = 'none';
		 		document.all("showseclevel").style.display = 'none';
		//		document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>"

		 	}else if(_sharetype == "402881ea0bf559c7010bf5608b560015"){	//流程节点操作者相关组织单元



			 	//需要将当前工作流的节点信息读取到下拉框中。。。。


		 		document.all("showRoleType").style.display = '';
		 		document.all("showOrgObjType").style.display = '';
		 		document.all("showUserObjType").style.display = 'none';
				document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';
		 		document.all("showOrgObjID").style.display = 'none';
		 		document.all("showWFOperators").style.display = '';
		 		document.all("showFormfileds").style.display = 'none';
		 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
		 		document.all("showRoleObjID").style.display = '';
		 		document.all("showUserShareType").style.display = 'none';
		 		document.all("showOrgUnitType").style.display = 'none';
		 		document.all("showOrgManager").style.display = 'none';
		 		document.all("showseclevel").style.display = 'none';
			//	document.all("showrelatedsharename").innerHTML = "";

		 	}else {	//其他
		 		//需要读取不同的字段到选择框中。。。

				getformfield(_sharetype);
		 		document.all("showRoleType").style.display = '';
		 		document.all("showOrgObjType").style.display = '';
		 		document.all("showUserObjType").style.display = 'none';
				document.all("showUserIDs").style.display = 'none';
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';
		 		document.all("showOrgObjID").style.display = 'none';
		 		document.all("showWFOperators").style.display = 'none';
		 		document.all("showFormfileds").style.display = '';
		 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
		 		document.all("showRoleObjID").style.display = '';
		 		document.all("showUserShareType").style.display = 'none';
		 		document.all("showOrgUnitType").style.display = 'none';
		 		document.all("showOrgManager").style.display = 'none';
		 		document.all("showseclevel").style.display = 'none';
			//	document.all("showrelatedsharename").innerHTML = "";
			 }

		 }
	}

}

</script>
<script type="text/javascript">
    function doSave() {
    if (check_by_ShareType()) {
        document.mainform.submit();
	}else{
        <%if(istype==1&&!objtable.equals("workflowinfo")&&!objtable.equals("requestbase")&&!objtable.equals("doctype")){%>
         Ext.getCmp('S').enable();

          Ext.getCmp('H').enable();
       <%}else{%>
        Ext.getCmp('S').enable();


       <%}%>
    }
   }
    function deleteperrule(ruleid,objid,objtable,istype){
  		if(confirm("是否确认删除?")){
  		 	location.href="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionAction?action=delete&RuleID="+ ruleid +"&objid=" + objid + "&objtable=" + objtable + "&istype="+istype+"&isdagate=1";
  		}
  }
    function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
 function onshowOrgObjID(tdname,inputname){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/orgunit/orgunitbrowser.jsp");
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(tdname).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(tdname).innerHTML = '';
		else
		document.all(tdname).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
 function onshowRoleObjID(tdname,inputname){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/security/sysrole/sysrolebrowser.jsp");
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(tdname).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(tdname).innerHTML = '';
		else
		document.all(tdname).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
 function onShowMutiResource(tdname,inputname){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/humres/base/humresbrowserm.jsp?sqlwhere=hrstatus%3D'4028804c16acfbc00116ccba13802935'&humresidsin="+document.all(inputname).value);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(tdname).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(tdname).innerHTML = '';
		else
		document.all(tdname).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
</script>


<script src='<%= request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%= request.getContextPath()%>/dwr/util.js'></script>
<script Language="JavaScript">

	function getformfield(permtypeid){
           DataService.getFormfieldForPermission(createList,permtypeid,'<%=objtable%>','<%=categoryid%>');
       	return true;
    }
    function createList(data)
	{
  	    DWRUtil.removeAllOptions("FormfieldID");
	    DWRUtil.addOptions("FormfieldID", data,"id","labelname");
	}
	function getformfield2(permtypeid){
       	DataService.getFormfieldForPermission(createList2,permtypeid,'<%=objtable%>','<%=categoryid%>');
       	return true;
    }
    function createList2(data)
	{
	    DWRUtil.removeAllOptions("role_ziduid");
	    DWRUtil.addOptions("role_ziduid", data,"id","labelname");
	}

function doRefactor(categoryid,refactortable){
    if(refactortable){
    DWREngine.setAsync(false);
    RightTransferService.refactor(categoryid,refactortable,returnTotal);
    DWREngine.setAsync(true);
    }
}
function doRequestRefactor(requestid,refactortable){
    if(refactortable){
    DWREngine.setAsync(false);
    RightTransferService.requestRefactor(requestid,refactortable,returnTotal);
    DWREngine.setAsync(true);
    }
}
function doRefactorWorkflowinfo(workflowid){
    DWREngine.setAsync(false);
    RightTransferService.refactorWorkflowinfo(workflowid,returnTotal);
    DWREngine.setAsync(true);
}
function returnTotal(o){
    total=o;
}

function returnCurrentCount(o){
    currentCount=o
}
function doRefresh(){
    RightTransferService.getCurrentCount(returnCurrentCount);
}

    function showMyRestrictions(){
        var rightType=document.getElementById("RightType");
        if(rightType.value=="2"){
            document.getElementById("restrictionsFieldtr").style.display="none";
            document.getElementById("fieldOftr").style.display="none";
        }
        else{
            document.getElementById("restrictionsFieldtr").style.display="block";
            document.getElementById("fieldOftr").style.display="block";
        }
        if(rightType.value=="9"){
            document.getElementById("notifytype").style.display="block";
            var notifytype = document.getElementById("notifytype");
            if(notifytype.value==2){
                document.getElementById("notifydefineid").style.display="block";
            }else{
                document.getElementById("notifydefineid").style.display="none";
            }
        }else{
            document.getElementById("notifytype").style.display="none";
            document.getElementById("notifydefineid").style.display="none";
        }
    }
    function changenotifytype(){
        var notifytype = document.getElementById("notifytype");
        if(notifytype.value==2){
            document.getElementById("notifydefineid").style.display="block";
        }else{
            document.getElementById("notifydefineid").style.display="none";
        }
    }
    function showFieldOf(id,size){
        for(var i=0;i<size;i++){
            document.getElementById(id+","+i).style.display="block";
        }
    }
    function closeFieldOf(id,size){
        for(var i=0;i<size;i++){
            document.getElementById(id+","+i).style.display="none";
        }
    }
    function fieldChange(){
        var fieldOf=document.getElementById("fieldOf");
        for(var i=0;i<fieldOf.options.length;){
            var option=document.createElement("option");
            option.value=fieldOf.options[i].value;
            option.text=fieldOf.options[i].text;
            fieldOf.options.remove(i);
        }
        closeMyChoose();
        var id=document.getElementById("restrictionsField").value;
        SelectitemService.getSelectitemListByfromfieldid(id,callback);
    }
    function callback(data){
        DWRUtil.removeAllOptions("operateObj");
        DWRUtil.addOptions("operateObj",data,"id","objname");
    }
    function closeMyChoose(){
        var targetObj=document.getElementById("targetObj");
        for(var i=0;i<targetObj.options.length;){
            var option=document.createElement ("option");
            option.value=targetObj.options[i].value;
            option.text=targetObj.options[i].text;
            targetObj.options.remove(i);
        }
    }
    function addAll(){
        var operateObj=document.getElementById("operateObj");
        var targetObj=document.getElementById("targetObj");
        for(var i=0;i<operateObj.options.length;){
            var option=document.createElement ("option");
            option.value=operateObj.options[i].value;
            option.text=operateObj.options[i].text;
            targetObj.options.add(option);
            operateObj.options.remove(i);
        }
    }
    function removeAll(){
        var operateObj=document.getElementById("operateObj");
        var targetObj=document.getElementById("targetObj");
        for(var i=0;i<targetObj.options.length;){
            var option=document.createElement ("option");
            option.value=targetObj.options[i].value;
            option.text=targetObj.options[i].text;
            operateObj.options.add(option);
            targetObj.options.remove(i);
        }
    }
    function addSome(){
        var operateObj=document.getElementById("operateObj");
        var targetObj=document.getElementById("targetObj");
        for(var i=0;i<operateObj.options.length;){
            if(operateObj.options[i].selected==true){
                var option=document.createElement ("option");
                option.value=operateObj.options[i].value;
                option.text=operateObj.options[i].text;
                targetObj.options.add(option);
                operateObj.options.remove(i);
            }else{
                i++;
            }
        }
    }
    function removeSome(){
        var operateObj=document.getElementById("operateObj");
        var targetObj=document.getElementById("targetObj");
        for(var i=0;i<targetObj.options.length;){
            if(targetObj.options[i].selected==true){
                var option=document.createElement ("option");
                option.value=targetObj.options[i].value;
                option.text=targetObj.options[i].text;
                operateObj.options.add(option);
                targetObj.options.remove(i);
            }else{
                i++;
            }
        }
    }
    function chooseOk(){
        var targetObj=document.getElementById("targetObj");
        var fieldOf=document.getElementById("fieldOf");
        for(var i=0;i<targetObj.options.length;i++){
            var option=document.createElement ("option");
            option.value=targetObj.options[i].value;
            option.text=targetObj.options[i].text;
            fieldOf.options.add(option);
        }
        closeMyChoose();
        var mychoose=document.getElementById("mychoose");
        var mytable=document.getElementById("mytable");
        mychoose.appendChild(mytable);
        var bgObj=document.getElementById("bgDiv");
        document.body.removeChild(bgObj);
        var msgObj=document.getElementById("msgDiv");
        document.body.removeChild(msgObj);
    }
    function dblclick(object){
        var targetObj=document.getElementById("targetObj");
        var operateObj=document.getElementById("operateObj");
        for(var i=0;i<object.options.length;){
            if(object.options[i].selected==true){
                var option=document.createElement ("option");
                option.value=object.options[i].value;
                option.text=object.options[i].text;
                if(object.id==operateObj.id){
                    targetObj.options.add(option);
                    object.options.remove(i);
                }
                else{
                    operateObj.options.add(option);
                    object.options.remove(i);
                }
            }else{
                i++;
            }
        }
    }

//Author:Daviv
//Blog:<a href="<a href="" target="_blank">http</a>" target="_blank"><a href="" target="_blank">http://</a></a>
//Date:2006-10-28
//*********************************模式对话框特效(start)*********************************//
            function sAlert(){
            var msgw,msgh,bordercolor;
            msgw=420;//提示窗口的宽度
            msgh=320;//提示窗口的高度
            bordercolor="#336699";//提示窗口的边框颜色

            var sWidth,sHeight;
            sWidth=document.body.offsetWidth;
            sHeight=document.body.offsetHeight;

            var bgObj=document.createElement("div");
            bgObj.setAttribute('id','bgDiv');
            bgObj.style.position="absolute";
            bgObj.style.top="0";
            bgObj.style.background="#777";
            bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";
            bgObj.style.opacity="0.6";
            bgObj.style.left="0";
            bgObj.style.width=sWidth + "px";
            bgObj.style.height=sHeight + "px";
            document.body.appendChild(bgObj);
            var msgObj=document.createElement("div")
            msgObj.setAttribute("id","msgDiv");
            msgObj.setAttribute("align","center");
            msgObj.style.position="absolute";
            msgObj.style.background="white";
            msgObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
            msgObj.style.border="1px solid " + bordercolor;
            msgObj.style.width=msgw + "px";
            msgObj.style.height=msgh + "px";
          msgObj.style.top=(document.documentElement.scrollTop + (sHeight-msgh)/2) + "px";
          msgObj.style.left=(sWidth-msgw)/2 + "px";

          var title=document.createElement("h4");
          title.setAttribute("id","msgTitle");
          title.setAttribute("align","right");
          title.style.margin="0";
          title.style.padding="3px";
          title.style.background=bordercolor;
          title.style.filter="progid:DXImageTransform.Microsoft.Alpha(startX=20, startY=20, finishX=100, finishY=100,style=1,opacity=75,finishOpacity=100);";
          title.style.opacity="0.75";
          title.style.border="1px solid " + bordercolor;
          title.style.height="18px";
          title.style.font="12px Verdana, Geneva, Arial, Helvetica, sans-serif";
          title.style.color="white";
          title.style.cursor="pointer";
          title.innerHTML="关闭";
          title.onclick=function(){
            var mychoose=document.getElementById("mychoose");
            var mytable=document.getElementById("mytable");
            mychoose.appendChild(mytable);
            document.body.removeChild(bgObj);
            document.getElementById("msgDiv").removeChild(title);
            document.body.removeChild(msgObj);
        }
          document.body.appendChild(msgObj);
          document.getElementById("msgDiv").appendChild(title);
		  var mytable=document.getElementById("mytable");
		  mytable.style.display="block";
	      document.getElementById("msgDiv").appendChild(mytable);
          fieldChange();
      }
//*********************************模式对话框特效(end)*********************************//
        </SCRIPT>
</BODY>
</HTML>