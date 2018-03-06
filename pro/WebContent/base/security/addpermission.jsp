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
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
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
    WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
    FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");

    ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");    

    BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

	OrgunittypeService orgunittypeService = (OrgunittypeService)BaseContext.getBean("orgunittypeService");

	OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");

	SysroleService sysroleService = (SysroleService)BaseContext.getBean("sysroleService");

    ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");

    CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");

	
	//标示是否新增历史重构按钮
	boolean flag1 = false;//分类权限、流程、流程共享
	boolean flag2 = false;//流程是否为归档节点
	String flowid = "" ;//归档节点历史重构对应流程id

    String objid = StringHelper.null2String(request.getParameter("objid"));
    String formid = StringHelper.null2String(request.getParameter("formid"));
	String objtable = StringHelper.null2String(request.getParameter("objtable")).trim();
	String workflowshare = StringHelper.null2String(request.getParameter("workflowshare"));
	String nodeid = StringHelper.null2String(request.getParameter("nodeid"));
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
        formid=workflowinfoService.get(objid).getFormid();
	}else if(objtable.equalsIgnoreCase("requestbase")){
		refobjtype = 1 ; //工作流相关；
		if(istype==1){
	 		Nodeinfo nodeinfo = nodeinfoService.get(objid);
	 		nodetype = nodeinfo.getNodetype().intValue();
	 		flowid = nodeinfo.getWorkflowid();
            formid=workflowinfoService.get(nodeinfo.getWorkflowid()).getFormid();
            if(nodetype==4){
            	flag1 = true; 
            	flag2 = true; 
            }
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

String objTableStr = "";
if(!StringHelper.isEmpty(categoryid)){
	DataService dataService = new DataService();
	String sql = "select objtablename from forminfo a where id=(select formid from category where id='"+categoryid+"')";
	objTableStr =  dataService.getSQLValue(sql);
}

pagemenustr +=  "addBtn(tb,'"+labelService.getLabelName("保存")+"','S','accept');";
pagemenustr +=  "addBtn(tb,'"+labelService.getLabelName("权限重构")+"','C','accept');";
if(istype==1&&!objtable.equals("workflowinfo")&&!objtable.equals("requestbase")&&!objtable.equals("doctype")){
	pagemenustr +=  "addBtn(tb,'"+labelService.getLabelName("历史数据重构")+"','H','accept');";
	flag1 = true;
}
if(istype==0&&!objtable.equals("doctype")&&hasRestrictionsField){
	pagemenustr +=  "addBtn(tb,'"+labelService.getLabelName("卡片历史数据重构")+"','R','accept');";
}
if(istype==1&&objtable.equals("workflowinfo")){
	pagemenustr +=  "addBtn(tb,'"+labelService.getLabelName("历史数据重构")+"','G','accept');";
	flag1 = true;
}
pagemenustr +=  "addBtn(tb,'"+labelService.getLabelName("刷新")+"','F','accept',function(){doRefurbish()});";
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
    <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery/jquery-1.7.2.min.js"></script>
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
      
      span,select,input,td{
       font-family: Microsoft YaHei;
      }
      .span1{
      	width:75px;display:inline-block;margin-right:4px;
      }
      .span2{
      	width:40px;display:inline-block;
      }
      .span3{
      	font-size:14px;font-weight:bolder;margin-left:2px;
      }
      .span4{
      	width:180px;display:inline-block;padding-right:2px;
      }
      .span5{
      	width:50px;display:inline-block;
      }
      .select1{
      	background: #f7f7f7;border: 1px solid #d6d3d6;width:120px;margin-right: 10px;
      }
      .input1{
      	background: #f7f7f7;border: 1px solid #d6d3d6;width:40px;
      }
      </style>
<script type="text/javascript">
var jq=jQuery.noConflict();
var total=0;
var currentCount=0;
var refresstimer;
var pbar1;

Ext.onReady(function(){
    var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
    var btnS = Ext.getCmp('S');
    var btnC = Ext.getCmp('C');
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
        Ext.getCmp('C').disable();
        Ext.getCmp('G').disable();
        Ext.fly('tr_p1').setDisplayed(true);
        Ext.fly('p1text').update('');
        if (!pbar1.rendered){
            pbar1.render('p1');
        }else{
            pbar1.text = '';
            pbar1.show();
        }
        //doRefactorWorkflowinfo('<%=objid%>');
        doRefactorWorkflowinfoShare('<%=objid%>');
        if(total==-1){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('C').enable();
        Ext.getCmp('G').enable();
        Ext.fly('p1text').update('<%=labelService.getLabelName("请等待先前的任务完成")%>').show();
        return;
        }
        if(total==0){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('C').enable();
        Ext.getCmp('G').enable();
        Ext.fly('p1text').update('<%=labelService.getLabelName("没有历史数据存在")%>'+'!').show();
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('<%=labelService.getLabelName("重构完成")%>'+'!').show();
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
        Ext.getCmp('C').disable();
        Ext.getCmp('H').disable();
        Ext.fly('tr_p1').setDisplayed(true);
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
        Ext.getCmp('C').enable();
        Ext.getCmp('H').enable();
        Ext.fly('p1text').update('<%=labelService.getLabelName("请等待先前的任务完成")%>').show();
        return;
        }
        if(total==0){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('C').enable();
        Ext.getCmp('H').enable();
        Ext.fly('p1text').update('<%=labelService.getLabelName("重构完成")%>').show();
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('<%=labelService.getLabelName("重构完成")%>'+'!').show();
        });
    });
    <%}%>

    btnS.on('click',function(){
        if(btnH)
        Ext.getCmp('H').disable();
        Ext.getCmp('C').disable();
        Ext.getCmp('S').disable();
        doSave();       
    });

    btnC.on('click',function(){
        if(btnH)
        Ext.getCmp('H').disable();
        Ext.getCmp('C').disable();
        Ext.getCmp('S').disable();
        recreate();
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
        Ext.getCmp('C').disable();
        Ext.fly('tr_p1').setDisplayed(true);
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
        Ext.getCmp('C').disable();
        Ext.fly('p1text').update('<%=labelService.getLabelName("请等待先前的任务完成")%>').show();
        return;
        }
        if(total==0){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('C').disable();
        Ext.fly('p1text').update('<%=labelService.getLabelName("重构完成")%>').show();
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('<%=labelService.getLabelName("重构完成")%>'+'!').show();
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
                Ext.getCmp('C').enable();
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

function doRefurbish(){
	var href=window.location.href + "&random="+Math.random();
	reload.href=href;
	reload.click();
}
</script>
<script Language="JavaScript">

	function getformfield(permtypeid){
		<%if(StringHelper.isEmpty(objTableStr)){%>
        DataService.getFormfieldForPermission(createList,permtypeid,'<%=objtable%>','<%=objid%>');
      <%}else{%>
        DataService.getFormfieldForPermission(createList,permtypeid,'<%=objTableStr%>','<%=objid%>');
      <%}%>
    	return true;
    }
    function createList(data)
	{
    	//dwr异步加载FormfieldID的select项，和上次选择同步
    	var formfield = document.getElementById('FormfieldID');
    	var formfieldSelect = formfield.value;
	    DWRUtil.removeAllOptions("FormfieldID");
	    DWRUtil.addOptions("FormfieldID", data,"id","labelname");
	    
	    if(formfieldSelect!=''){
	    	var formfield1 = document.getElementById('FormfieldID');
	    	if(formfield1.innerHTML.indexOf(formfieldSelect)>0){
	    		formfield1.value=formfieldSelect;
	    	}
	    }
	}
	function getformfield2(permtypeid){
		
       	DataService.getFormfieldForPermission(createList2,permtypeid,'<%=objtable%>','<%=objid%>');
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
<a id="reload" href="" style="display:none"></a>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="0">
<col width="">
<col width="0">
<tr id="tr_p1" style="display: none;height: 30px">
    <td ></td>
    <td>
        <div class="status" id="p1text" style="display:none"></div>
        <div id="p1" style="width:300px;"></div>
    </td>
    <td ></td>
</tr>
<tr style="display: none;">
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id=mainform name=mainform action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionAction?action=create" method=post onsubmit='return check_by_ShareType()'>
  <input type="hidden" name="RuleID" value="">
  <input type="hidden" name="objid" value="<%=objid%>">
  <input type="hidden" name="formid" value="<%=formid%>">
  <input type="hidden" name="objtable" value="<%=objtable%>">
  <input type="hidden" name="istype" value="<%=istype%>">
  <input type="hidden" name="workflowshare" value="<%=workflowshare%>">
  <input type="hidden" name="condition" value="">
  <input type="hidden" name="isdefault" value="">

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
        <SELECT class="select1" name=ShareType onchange="onChangeShareType()">
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
       	  <span class="span1">
          <%=labelService.getLabelName("是否受角色作用域控制")%>:
          </span>
          <SELECT  class="select1" name=RoleType onchange="onChangeShareType()">
          <option value="0"><%=labelService.getLabelName("否")%></option>
          <option value="1" selected ><%=labelService.getLabelName("是")%></option>
          </SELECT>
        </span>
        <span id=showOrgObjType name=showOrgObjType style="display:''">
          <span class="span1">
          <%=labelService.getLabelName("组织单元类型")%>:
          </span>
          <SELECT  class="select1" name=OrgObjType onchange="onChangeShareType()">
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
          <span class="span1">
          <%=labelService.getLabelName("人员类型")%>:
          </span>
          <SELECT class="select1" name=UserObjType onchange="onChangeShareType()">
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
          <span class="span1">
          <%=labelService.getLabelName("岗位")%>:
          </span>
          <SELECT class="select1" name=StationObjType onchange="onChangeShareType()">
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
	        <input type="button"  class=Browser style="display:''" onclick="javascript:getBrowser('/humres/base/stationlist.jsp?type=browser','StationIDs','StationIDsSpan','1');"/>
	        <INPUT type=hidden name="StationIDs" id ="StationIDs"  value="">   
	        <SPAN id=StationIDsSpan name=StationIDsSpan><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></SPAN>
        </span>
        <span  name="showUserIDs" id="showUserIDs"> 
	       <input type="button" class=Browser style="display:''" onclick="getrefobj('UserIDs','UserIDsSpan','402881eb0bd30911010bd321d8600015','','/humres/base/humresinfo.jsp?id=','1');" />
	        <INPUT type=hidden name="UserIDs" id ="UserIDs"  value="">   
	        <SPAN id=UserIDsSpan name=UserIDsSpan><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></SPAN>
         </span>
            
        <span  name="showOrgObjID" id="showOrgObjID"> 
	        <input type="button" class=Browser  style="display:''" onClick="onshowOrgObjID('OrgObjIDSpan','OrgObjID')"  />
	        <INPUT type=hidden name="OrgObjID" id ="OrgObjID" value="">       
	         <SPAN id=OrgObjIDSpan name=OrgObjIDSpan><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></SPAN>
         </span>
        <span id=showrelatedsharename name=showrelatedsharename></span>
        
     
        <!--  
        //以下为工作流表单字段
        //文档字段
        -->
        <span id=showWFOperators name=showWFOperators style="display:block;">
          <span class="span1">
          <%=labelService.getLabelName("节点操作者")%>:
          </span>
          <SELECT class="select1" name=WFOperatorNodeID onchange="onChangeShareType()">
         <%
	        String tempnodeid = objid;
	      	if(istype==0&&"requestbase".equals(objtable)){
	      		tempnodeid = nodeid;
	      	}
         	if(refobjtype==1 && isworkflowid ==0 ){
         		Nodeinfo nodeinfo = nodeinfoService.get(tempnodeid);
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
         			list = nodeinfoService.getNodelistByworkflowid(tempnodeid);
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
          <span class="span1">
          <%=labelService.getLabelName("相关字段")%>:
          </span>
          <SELECT class="select1" name=FormfieldID id=FormfieldID >
           
          </SELECT>
        </span>        
      </TD>
      </tr>
      <tr>      
      <TD class=FieldValue colspan=3>
      <span id=showOrgShareType name=showOrgShareType style="display:''">
		  <span class="span1">      
          <%=labelService.getLabelName("作用域")%>:
          </span>
          <SELECT class="select1" name=OrgShareType onchange="onChangeShareType('OrgShareType')">     
             
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
          <span class="span1">
          <%=labelService.getLabelName("组织维度")%>:
          </span>
          		<SELECT class="select1" name=OrgReftype onchange="onChangeShareType()"> 
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
          <span class="span1">
          <%=labelService.getLabelName("角色")%>:
          </span>
          		<SELECT class="select1" name=RoleType2 onchange="onChangeShareType()"> 
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
        <input type="button" class=Browser  style="display:''"  onclick="onshowRoleObjID('showrolename2','RoleObjID')" />
        <INPUT type=hidden name="RoleObjID" id ="RoleObjID" value="">
        <span id=showrolename2 name=showrolename2 style="display:''"><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></span>
        </span>  
        <span id=role_zidu name=role_zidu style="display:'none'"> 
        		<span class="span1">
     			<%=labelService.getLabelName("相关字段")%>
				</span>
          		<SELECT class="select1" name=role_ziduid id="role_ziduid" > 
    
				</SELECT>
		</span>
        
        
        <span id=showUserShareType name=showUserShareType style="display:''">
          <span class="span1">
          <%=labelService.getLabelName("作用域")%>:
          </span>
          <SELECT class="select1" name=UserShareType onchange="onChangeShareType()"> 
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
           <span class="span1">
           <%=labelService.getLabelName("岗位级别")%>
           </span>
           <SELECT class="select1" name="position"> 
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
          <SELECT class="select1" name=OrgUnitType>        
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
          <SELECT class="select1"  name=OrgManager onchange="onChangeShareType()">      
          <option value="0" selected ><%=labelService.getLabelName("安全级别")%></option>
          <option value="1"><%=labelService.getLabelName("部门经理")%></option>
	</SELECT>
        </span>
        	
        <span id=showseclevel name=showseclevel style="display:''">
        <span class="span1">
        <%=labelService.getLabelName("安全级别")%>:
        </span>
        <INPUT type=text class="input1"  id=minseclevel name=minseclevel size=6 value="10">
        <SPAN id=seclevelimage name=seclevelimage><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></SPAN> -&nbsp;<INPUT type=text class="input1"  id=maxseclevel name=maxseclevel size=6 value="">
        </span>
        
	
      </TD>
      </tr>
      <!--系统表单、流程创建节点、归档节点-->
      <% if((refobjtype!=1 || nodetype==1 || nodetype == 4 || isworkflowid ==1)){%>
      <tr>
      <TD class=FieldValue colspan=3>
      <span class="span1">
      <%=labelService.getLabelName("操作类型")%>:
      </span>
      <span style="display: inline-block;">
      <SELECT class="select1"  name=RightType id="RightType" <%if(istype==1&&!"requestbase".equals(objtable)&&!"workflowinfo".equals(objtable)){%> onchange="showMyRestrictions()"<%}%>>
       <%
        	list = selectitemService.getSelectitemList("402880371fb07b8d011fb0889c890002",null);
           
           for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);   
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		//非类型设置不允许给创建权限。
               if (objtable.equalsIgnoreCase("reportdef")) {
               } else {
                   if (_selectitem.getId().equals("4028803520218a250120218c03510002")) {
                       continue;
                   }
               }
               if(optcode.equalsIgnoreCase("13")){
	               if("1".equals(workflowshare)){
	               		%>
	               		<option value="<%=optcode%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
	               		<%	
	               }
	               continue;
               }
        		if(optcode.equalsIgnoreCase("2") && (istype == 0 || nodetype == 4 || isworkflowid ==1))
        			continue;     		
        		if(!optcode.equalsIgnoreCase("2") && (nodetype == 1))
        			continue;
        				
        		if(!optcode.equalsIgnoreCase("3") && (isworkflowid == 1))
        			continue;
                if(optcode.equalsIgnoreCase("9")&&!(istype==1&&!"requestbase".equals(objtable)&&!"workflowinfo".equals(objtable)))
                    continue;
				//if(optcode.equalsIgnoreCase("9") && "docbase".equalsIgnoreCase(objtable))
            //        continue;
               if(optcode.equalsIgnoreCase("13")||optcode.equalsIgnoreCase("17"))
                 continue;

        %>	
        
          <option value="<%=optcode%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%
          }   

		if(nodetype==4){
			out.println("<option value='402880411200d8d8011201198dd50008'>"+labelService.getLabelName("知会")+"</option>");
		}%>
      </SELECT>
      </span>
      <span style="display: inline-block;">
      <select class="select1" id="notifytype" name="notifytype" onchange="changenotifytype()" style="display:none">
          <option value="1"><%=labelService.getLabelName("到期提醒")%></option>
          <option value="2"><%=labelService.getLabelName("即时提醒")%></option>
      </select>
      </span>
      <span style="display: inline-block;">
      <select class="select1" id="notifydefineid" name="notifydefineid" style="display:none">
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
      </span>
      </td>
      </tr>
      <%}%>

      <!--文档附件操作类型-->
      <% if(refobjtype==2){%>
	      <tr id="RightType2" style="display:none;">
	      <TD class=FieldValue colspan=3>
	      <span class="span1">
	        <%=labelService.getLabelName("文档附件操作类型")%>:
	        </span>
	      <SELECT class="select1" name=RightType2>   
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
	      <span class="span1">
	        <%=labelService.getLabelName("流程操作方式")%>:
	        </span>
	      <SELECT class="select1"  name=RightType3 onchange="wfloptchange(this)">   
	       <%
	        	list = selectitemService.getSelectitemList("402881ea0bfa7679010bfa86f3f70016",null);
	        	for(int i=0;i<list.size();i++){
	        		Selectitem _selectitem = (Selectitem)list.get(i);        		
	        %>	
	        
	          <option value="<%=_selectitem.getObjdesc()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
	          <%}%>   
	      </SELECT>
	      <span id="orderspan" style="display: none;">
	      		<SELECT class="select1"  name=orderopt>
	      			<%
			        	list = selectitemService.getSelectitemList("03650E8B39D04B128F06CFF6E11BE594",null);
			        	for(int i=0;i<list.size();i++){
			        		Selectitem _selectitem = (Selectitem)list.get(i);        		
			        %>	
	          			<option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
	          		<%}%>  
	      		</SELECT>
	      </span>
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
      if(istype==1&&!"requestbase".equals(objtable)){
      %>
      <!--限制字段-->
      <tr id="restrictionsFieldtr" <%if(!"workflowinfo".equals(objtable)){%>style="display:none"<%}%>>
      <td class="fieldvalue" colspan="3">
      <span class="span1">
      	限制字段:
      </span>
      <select class="select1" id="restrictionsField" name="restrictionsField" onchange="sAlert()">
      <option value="0">未选择</option>
	       <%   List formfieldList;
	       		//ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
                if("workflowinfo".equals(objtable))
                  formfieldList=formfieldService.getAllFieldByFormId(formid);
               else{
                Category category=categoryService.getCategoryById(objid);
                while(StringHelper.isEmpty(category.getFormid())&&!StringHelper.isEmpty(category.getPid())){
                    category=categoryService.getCategoryById(category.getPid());
                }
                formfieldList=formfieldService.getAllFieldByFormId(category.getFormid());
                }
	        	for(int i=0;i<formfieldList.size();i++){
	        		Formfield formfield = (Formfield)formfieldList.get(i);
                    if(formfield.getHtmltype()==5){
                    	Forminfo forminfo = forminfoService.getForminfoById(formfield.getFormid());
            %>

	          <option value="<%=formfield.getId()%>"><%=forminfo.getObjtablename()+"."+formfield.getFieldname()+":"+StringHelper.null2String(formfield.getLabelname())%></option>
	          <%
                      }
                  }%>
      </select>
          <div style="display:none" id="mychoose">
          <!--<table>-->
          <!--<tr><td align="right"><a href="javascript:closeMyChoose()">【关闭】</a></td></tr>-->
          <!--<tr>-->
          <!--<td>-->
              <table id="mytable">
              <tr>
                  <td>
                      <select class="select1" id="operateObj" multiple="multiple" style="width:180;height:280" ondblclick="dblclick(this)">
                      </select>
                  </td>
                  <td>
                      <a href="javascript:addAll()" style="font-size:12px"><%=labelService.getLabelName("添加全部")%></a><br><br>
                      <a href="javascript:addSome()" style="font-size:12px"><%=labelService.getLabelName("添加选择")%></a><br><br>
                      <a href="javascript:removeSome()" style="font-size:12px"><%=labelService.getLabelName("移除选择")%></a><br><br>
                      <a href="javascript:removeAll()" style="font-size:12px"><%=labelService.getLabelName("移除全部")%></a><br><br><br><br><br><br>
                      <%--<a href="javascript:chooseOk()" style="font-size:12px">&nbsp;&nbsp;确定</a>--%>
                      <input type="button"  class=btn onclick="chooseOk()" style="width:38" value="<%=labelService.getLabelName("确定")%>" />
                  </td>
                  <td>
                      <select class="select1" id="targetObj" multiple="multiple" ondblclick="dblclick(this)">
                      </select>
                  </td>
              </tr>
              </table>
          <!--</td>-->
          <!--</tr>-->
          <!--</table>-->
          </div>
      </td>
      </tr>

      <!--字段相关项-->
      <tr id="fieldOftr" <%if(!"workflowinfo".equals(objtable)){%>style="display:none"<%}%>>
      <td class="fieldvalue" colspan="3">
      <span class="span1">
       <%=labelService.getLabelName("字段相关项")%>
       </span>
      <select class="select1" id="fieldOf" name="fieldOf" multiple="multiple">
      </select>
      <input type="hidden" id="fieldOfHidden" name="fieldOfHidden"/>
      </td>
      </tr>
      <%
          }
      %>
      <!--子表记录-->
      <!--tr>
      <td class="fieldvalue" colspan="3">
      <%--=labelService.getLabelName("子表记录")--%>:
      <select class="inputstyle2" name="detailFilter" >
      <option></option>
      <option value="1"><%--=labelService.getLabelName("非所在行隐藏")--%></option>
      <option value="2"><%--=labelService.getLabelName("非所在行只读")--%></option>
      </select>
      </td>
      </tr-->
      
      <!--对应布局设置-->
      <%
            String strDefHql="from Formlayout where formid='"+formid+"'";
            if(objtable.equals("requestbase")){//流程节点权限
            	Nodeinfo nodeinfo = nodeinfoService.get(objid);
            	String workflowid = nodeinfo.getWorkflowid();
            	List nodelist = nodeinfoService.getNodelistByworkflowid(workflowid);
            	String listids = "";
            	strDefHql += " and ( nodeid is null  ";
            	for (Object node : nodelist) {
                    if (listids.equals(""))
                        listids += "'" + ((Nodeinfo) node).getId() + "'";
                    else
                        listids += ",'" + ((Nodeinfo) node).getId() + "'";
                }
            	if(!listids.equals("")){
            		strDefHql += " or nodeid in("+listids+") ";
            	}
            	strDefHql += " ) ";
            }else if(objtable.equals("workflowinfo")){
            	String workflowid = objid;
            	List nodelist = nodeinfoService.getNodelistByworkflowid(workflowid);
            	String listids = "";
            	strDefHql += " and ( nodeid is null  ";
            	for (Object node : nodelist) {
                    if (listids.equals(""))
                        listids += "'" + ((Nodeinfo) node).getId() + "'";
                    else
                        listids += ",'" + ((Nodeinfo) node).getId() + "'";
                }
            	if(!listids.equals("")){
            		strDefHql += " or nodeid in("+listids+") ";
            	}
            	strDefHql += " ) ";
            }
            FormlayoutService formlayoutService = (FormlayoutService)BaseContext.getBean("formlayoutService");
            List listdef = formlayoutService.findFormlayout(strDefHql);
            List layoutlist = new ArrayList();
            layoutlist.addAll(listdef);
      %>
      <% if((refobjtype!=1 || nodetype == 4 || isworkflowid ==1)){%>
      <tr>
      <TD class=FieldValue colspan=3>
            <span class="span1">
            <%=labelService.getLabelName("页面布局")%>:
            </span>
            <select class="select1" id="layoutid" name="layoutid" >
            <option value=""></option>
            <%
            for(int i=0; i<layoutlist.size(); i++){
                Formlayout formlayout=(Formlayout)layoutlist.get(i);
                String selected = "";
                if(0==formlayout.getSupportedclient() || formlayout.getSupportedclient() == null){
                	%>
                <option value=<%=formlayout.getId()%>><%=formlayout.getLayoutname()%></option>  
                	<%
                }
                %>
            <%}%>
            </select>
			<span class="span1">
            <%=labelService.getLabelName("优先级")%>:
            </span>
            <INPUT type=text class="input1"  id="priority" name="priority" MAXLENGTH =3 value="-1">
      </td>
      </tr>
      <% if(isworkflowid==1){ %>
      <tr>
      <TD class=FieldValue colspan=3>
      		<span class="span1">
            <%=labelService.getLabelName("手机页面布局")%>:
            </span>
            <select class="select1" id="mobilelayoutid" name="mobilelayoutid" >
            <option value=""></option>
            <%
            for(int i=0; i<layoutlist.size(); i++){
                Formlayout formlayout=(Formlayout)layoutlist.get(i);
                String selected = "";
                if(1==formlayout.getSupportedclient()){
                	%>
                <option value=<%=formlayout.getId()%>><%=formlayout.getLayoutname()%></option>  
                	<%
                }
             }
                %>
            </select>
			<span class="span1">
            <%=labelService.getLabelName("优先级")%>:
            </span>
            <INPUT type=text class="input1"  id="mobilepriority" name="mobilepriority" MAXLENGTH =3 value="-1">
      </td>
      </tr>
      <%}
         }%>
      <% if((nodetype==1 || nodetype == 2 )){%>
      <tr>
      <TD class=FieldValue colspan=3>
      		<span class="span1">
            <%=labelService.getLabelName("编辑布局")%>:
            </span>
            <select class="select1" id="layoutid" name="layoutid" >
            <option value=""></option>
            <%
            for(int i=0; i<layoutlist.size(); i++){
                Formlayout formlayout=(Formlayout)layoutlist.get(i);
                if(formlayout.getTypeid().intValue() == 2 && (0==formlayout.getSupportedclient() || formlayout.getSupportedclient() == null)){
                    String selected = ""; 
                		%>
                		<option value=<%=formlayout.getId()%>><%=formlayout.getLayoutname()%></option>  
                		<%
                }
            }%>
            </select>
			<span class="span1">
            <%=labelService.getLabelName("查看布局")%>:
            </span>
            <select class="select1" id="layoutid1" name="layoutid1" >
            <option value=""></option>
            <%
            for(int i=0; i<layoutlist.size(); i++){
                Formlayout formlayout=(Formlayout)layoutlist.get(i);
                if(formlayout.getTypeid().intValue() == 1 && (0==formlayout.getSupportedclient() || formlayout.getSupportedclient() == null)){
                    String selected = "";
	                %>
	                	<option value=<%=formlayout.getId()%>><%=formlayout.getLayoutname()%></option>  
	                <%
                 }
            }%>
            </select>
            <span class="span2">优先级:</span>
            <INPUT type=text class="input1"  id="priority" name="priority" MAXLENGTH =3 value="-1">
      </td>
      </tr>
      <tr>
      <TD class=FieldValue colspan=3>
      		<span class="span1">
            <%=labelService.getLabelName("手机编辑布局")%>:
            </span>
            <select class="select1" id="mobilelayoutid" name="mobilelayoutid" >
            <option value=""></option>
            <%
            for(int i=0; i<layoutlist.size(); i++){
                Formlayout formlayout=(Formlayout)layoutlist.get(i);
                if(formlayout.getTypeid().intValue() == 2 && 1==formlayout.getSupportedclient()){
                    	String selected = "";%>
                    	<option value=<%=formlayout.getId()%>><%=formlayout.getLayoutname()%></option>
               		<%
                }
            }%>
            </select>
			<span class="span1">
            <%=labelService.getLabelName("手机查看布局")%>:
            </span>
            <select class="select1" id="mobilelayoutid1" name="mobilelayoutid1" >
            <option value=""></option>
            <%
            for(int i=0; i<layoutlist.size(); i++){
                Formlayout formlayout=(Formlayout)layoutlist.get(i);
                if(formlayout.getTypeid().intValue() == 1 && 1==formlayout.getSupportedclient()){
                    String selected = "";%>
                    <option value=<%=formlayout.getId()%>><%=formlayout.getLayoutname()%></option>
                <%}
            }%>
            </select>

            <span class="span2">优先级:</span>
            <INPUT type=text class="input1"  id="mobilepriority" name="mobilepriority" MAXLENGTH =3 value="-1">
      </td>
      </tr>
      <%}%>
<TR><TD class=Line colSpan=3></TD></TR>


    </TBODY>
  </TABLE>
  
  <table class=ViewForm>
  <colgroup> 
  <col width="20%">
  <col width="60%">
  <col width="10%">
  <col width="10%">
  <tr class=Title> 
    <th colspan=3>
    <span class="span3">     
        <%=labelService.getLabelName("402881ea0bfa7679010bfa8d96540021")%>
    </span>
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
		String notifytype="1";
		String notifydefineid = StringHelper.trimToNull(permissionrule.getNotifydefineid());

		Integer OrgManager = permissionrule.getOrgmanager();
		Integer minseclevel = permissionrule.getMinseclevel();
		Integer maxseclevel = permissionrule.getMaxseclevel();
		Integer RightType1 = permissionrule.getOpttype();
		Integer RightType2 = permissionrule.getDocattopttype();
		Integer RightType3 = permissionrule.getWfopttype();
               if(objid.equalsIgnoreCase("4028803523cacb540123caff02a50012")){
		             if(RightType1==6&&RightType1==9){
		             continue;
		             }
		  }
		//历史重构标志，是否为查看、编辑、删除、共享 
		boolean flag3 = false;
        String layoutid = permissionrule.getLayoutid();
        String layoutid1 = permissionrule.getLayoutid1();
        String mobilelayoutid = permissionrule.getMobilelayoutid();
        String mobilelayoutid1 = permissionrule.getMobilelayoutid1();
        Integer priority = permissionrule.getPriority();
        Integer mobilepriority = permissionrule.getMobilepriority();
        String detailFilter = permissionrule.getDetailFilter();
        String restrictionsField = permissionrule.getRestrictionsField();
        String orderopt = permissionrule.getOrderopt();
        Formfield restrictionsObj = formfieldService.getFormfieldById(restrictionsField);
        String fieldOf = permissionrule.getFieldOf();
        List listObj = StringHelper.string2ArrayList(fieldOf,",");
        List fieldOfList = new ArrayList();
        String selectitemid;
        Integer rightType = -1;
        for(int i=0;i<listObj.size();i++){
            selectitemid=(String)listObj.get(i);
            Selectitem selectitem=selectitemService.getSelectitemById(selectitemid);
            fieldOfList.add(selectitem.getObjname());
        }
        String UserNames="";
        String OrgObjName="";
        String StationNames="";
        String RoleObjName="";
        
  %>
  	<TR>
      <TD>
      <span class="span4">
      <% 
      if(RightType1!=null){
      		List list1 = selectitemService.getSelectitemList("402881ea0bfa7679010bfa83d68a0007",null);
        	for(int i=0;i<list1.size();i++){
        		Selectitem _selectitem = (Selectitem)list1.get(i);   
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		if(RightType1.intValue() == NumberHelper.string2Int(optcode)){
        			out.print("<B>["+StringHelper.null2String(_selectitem.getObjname())+"]</b>");
        			rightType =  NumberHelper.string2Int(optcode);
                    if(RightType1.intValue()==9){
                        if(notifydefineid!=null){
                            out.print("<B>[即时提醒]</b>");
                            notifytype="2";
                        }
                    }
                }
        	}	
        	if(RightType1.intValue() == 3||RightType1.intValue() == 13||RightType1.intValue() == 15||RightType1.intValue() == 105||RightType1.intValue() == 165){
        		flag3 = true;
        	}
       }
      if(RightType2!=null){
      		List list1  = selectitemService.getSelectitemList("402881ea0bfa7679010bfa854d8a000e",null);
        	for(int i=0;i<list1.size();i++){
        		Selectitem _selectitem = (Selectitem)list1.get(i);   
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		if(RightType2.intValue() == NumberHelper.string2Int(optcode)) {
        			rightType =  NumberHelper.string2Int(optcode);
        			out.print("<B>["+StringHelper.null2String(_selectitem.getObjname())+"]</b>");
        		}
        			
        	}	
       }
      if(RightType3!=null){
      		List list1  = selectitemService.getSelectitemList("402881ea0bfa7679010bfa86f3f70016",null);
        	for(int i=0;i<list1.size();i++){
        		Selectitem _selectitem = (Selectitem)list1.get(i);   
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		if(RightType3.intValue() == NumberHelper.string2Int(optcode)) {
        			String orderoptstr = "";
        			if(RightType3.intValue()==5){
        				Selectitem orderoptitem = selectitemService.getSelectitemById(orderopt);
     					orderoptstr = orderoptitem.getObjname();
        			}
        			rightType =  NumberHelper.string2Int(optcode);
        			out.print("<B>["+StringHelper.null2String(_selectitem.getObjname())+(StringHelper.isEmpty(orderoptstr)?"":"-"+orderoptstr)+"]</b>");
        		}       			
        	}	
       }

       Selectitem _selectitem = selectitemService.getSelectitemById(ShareType);
       out.print("&nbsp;"+StringHelper.null2String(_selectitem.getObjname()));      
      	%>
      </span>	
      </TD>
	  <TD class=FieldValue>
      <table >
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
  					UserNames+=StringHelper.null2String(humres.getObjname())+",";
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
			    StationNames+=StringHelper.null2String(stationinfo.getObjname())+",";
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
  					if(orgunit!=null){
  						outString += StringHelper.null2String(orgunit.getObjname())+"&nbsp;";
  						OrgObjName+=StringHelper.null2String(orgunit.getObjname())+",";
  					}
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
				StationNames+=StringHelper.null2String(stationinfo.getObjname())+",";
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
       		if("4028801511760958011176701f79000c".equals(UserShareType)){
       			outString += "/"+labelService.getLabelName("402881e70b774c35010b774cceb80008")+":";
	        	outString += ""+StringHelper.null2String(minseclevel);
	        	if(maxseclevel != null)
	        		outString +="&nbsp;－&nbsp;"+maxseclevel.intValue();
       		}
      	}else if("402881e60bf4f747010bf4fec8f8000b".equals(ShareType)){ 
      	
      		  		
      		_selectitem = selectitemService.getSelectitemById(StationObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";	  	
	  		if("297e828210f211130110f21d99710009".equals(StationObjType)){
	  			StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
				Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(StationIDs);
				outString += StringHelper.null2String(stationinfo.getObjname())+"&nbsp;";
				StationNames+=StringHelper.null2String(stationinfo.getObjname())+",";
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
      			RoleObjName+=StringHelper.null2String(sysrole.getRolename())+",";
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
	  					OrgObjName+=StringHelper.null2String(orgunit.getObjname())+",";
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
            <tr><td>页面布局:<%=formlayoutService.getFormlayoutById(layoutid).getLayoutname()==null?"":formlayoutService.getFormlayoutById(layoutid).getLayoutname()%></td></tr>
            <tr><td>优先级:<%=priority%></td></tr>
            <%}%>
             <%if(mobilelayoutid!=null && !mobilelayoutid.equals("")){%>
            <tr><td>手机页面布局:<%=formlayoutService.getFormlayoutById(mobilelayoutid).getLayoutname()==null?"":formlayoutService.getFormlayoutById(mobilelayoutid).getLayoutname()%></td></tr>
            <tr><td>优先级:<%=mobilepriority%></td></tr>
            <%}%>
      <%}%>
      <% if((nodetype==1 || nodetype == 2 )){%>
            <%if((layoutid!=null && !layoutid.equals(""))||(layoutid1!=null && !layoutid1.equals(""))){%>
            <tr><td>编辑布局:<%=formlayoutService.getFormlayoutById(layoutid).getLayoutname()==null?"":formlayoutService.getFormlayoutById(layoutid).getLayoutname()%></td></tr>
            <tr><td>查看布局:<%=formlayoutService.getFormlayoutById(layoutid1).getLayoutname()==null?"":formlayoutService.getFormlayoutById(layoutid1).getLayoutname()%></td></tr>
            <tr><td>优先级:<%=priority%></td></tr>
            <%}%>
            <%if((mobilelayoutid!=null && !mobilelayoutid.equals(""))||(mobilelayoutid1!=null && !mobilelayoutid1.equals(""))){%>
            <tr><td>手机编辑布局:<%=formlayoutService.getFormlayoutById(mobilelayoutid).getLayoutname()==null?"":formlayoutService.getFormlayoutById(mobilelayoutid).getLayoutname()%></td></tr>
            <tr><td>手机查看布局:<%=formlayoutService.getFormlayoutById(mobilelayoutid1).getLayoutname()==null?"":formlayoutService.getFormlayoutById(mobilelayoutid1).getLayoutname()%></td></tr>
            <tr><td>手机优先级:<%=mobilepriority%></td></tr>
            <%}%>
      <%}%>
      <%
          if(restrictionsField!=null&&!"".equals(restrictionsField)){
        	  Forminfo forminfo =  forminfoService.getForminfoById(restrictionsObj.getFormid());
      %>
            <tr><td>限制字段:<%=forminfo.getObjtablename()+"."+restrictionsObj.getFieldname()+"→"+restrictionsObj.getLabelname()%>&nbsp;<a href="javascript:void(0)" onmouseover="showFieldOf('<%=RuleID%>','<%=fieldOfList.size()%>')" onmouseout="closeFieldOf('<%=RuleID%>','<%=fieldOfList.size()%>')">查看相关限制项?</a></td></tr>
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
        <% if((nodetype==2) || ("formbase".equals(refactorTable) && rightType != 2)){
        String condition=StringHelper.null2String(permissionrule.getCondition());            
    %>

      <TD class=FieldValue colspan=3>
      <span class="span5">条件:<input type="button"  class=Browser  onclick="javascript:getCondition('/workflow/workflow/exportbrowsernew.jsp?formid=<%=formid%>&ruleid=<%=RuleID%>','conditionspan<%=RuleID%>');" />
	        </span><SPAN id=conditionspan<%=RuleID%> name=conditionspan<%=RuleID%>><%=condition%></SPAN>
      </td>

      <%}else{%>
      <td class=FieldValue colspan=3></td>
      <%} %>  
	<td class=FieldValue  nowrap="nowrap">
	<% 
		int optype = 0;
		if(RightType1!=null){
			optype = RightType1.intValue();
		}
	%>
	<a href="javascript:deleteperrule('<%=RuleID%>','<%=objid%>','<%=objtable%>','<%=istype%>','<%=nodetype%>','<%=optype%>')">
	<%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%></a><!-- 删除 -->
	&nbsp;
	<%
		UserNames=!StringHelper.isEmpty(UserNames)?UserNames.substring(0,UserNames.length()-1):UserNames;
		OrgObjName=!StringHelper.isEmpty(OrgObjName)?OrgObjName.substring(0,OrgObjName.length()-1):OrgObjName;
		StationNames=!StringHelper.isEmpty(StationNames)?StationNames.substring(0,StationNames.length()-1):StationNames;
		RoleObjName=!StringHelper.isEmpty(RoleObjName)?RoleObjName.substring(0,RoleObjName.length()-1):RoleObjName;
		String fieldOfNames=StringHelper.List2String(fieldOfList,",");
	%>
	<a href="javascript:editperrule('<%=StringHelper.null2String(RuleID)%>','<%=StringHelper.null2String(ShareType)%>','<%=StringHelper.null2String(RoleType)%>','<%=StringHelper.null2String(OrgObjType)%>','<%=StringHelper.null2String(UserObjType)%>',
	'<%=StringHelper.null2String(UserIDs)%>','<%=StringHelper.null2String(OrgObjID)%>','<%=StringHelper.null2String(WFOperatorNodeID)%>','<%=StringHelper.null2String(FormfieldID)%>','<%=StringHelper.null2String(OrgShareType)%>',
	'<%=StringHelper.null2String(RoleObjID)%>','<%=StringHelper.null2String(UserShareType)%>','<%=StringHelper.null2String(OrgUnitType)%>','<%=StringHelper.null2String(StationObjType)%>','<%=StringHelper.null2String(StationIDs)%>',
	'<%=StringHelper.null2String(OrgReftype)%>','<%=StringHelper.null2String(notifydefineid)%>','<%=StringHelper.null2String(OrgManager)%>','<%=StringHelper.null2String(minseclevel)%>','<%=StringHelper.null2String(maxseclevel)%>',
	'<%=StringHelper.null2String(RightType1)%>','<%=StringHelper.null2String(RightType2)%>','<%=StringHelper.null2String(RightType3)%>','<%=StringHelper.null2String(layoutid)%>','<%=StringHelper.null2String(layoutid1)%>','<%=StringHelper.null2String(mobilelayoutid)%>',
	'<%=StringHelper.null2String(mobilelayoutid1)%>','<%=StringHelper.null2String(priority)%>','<%=StringHelper.null2String(mobilepriority)%>','<%=StringHelper.null2String(detailFilter)%>','<%=StringHelper.null2String(restrictionsField)%>',
	'<%=StringHelper.null2String(orderopt)%>','<%=StringHelper.null2String(fieldOf)%>','<%=StringHelper.null2String(notifytype)%>','<%=UserNames%>','<%=OrgObjName%>',
	'<%=StationNames%>','<%=RoleObjName%>','<%=StringHelper.getEncodeStr(StringHelper.null2String(permissionrule.getCondition()))%>','<%=fieldOfNames%>','<%=StringHelper.null2String(permissionrule.getIsdefault())%>','<%=StringHelper.null2String(permissionrule.getIstype())%>')">
		<%=labelService.getLabelName("402881e70b774c35010b7750a15b000b")%></a><!-- 编辑 -->
	&nbsp;
	 <% if(flag1&&flag3){
	 		if(flag2){%>
	 		<a href="javascript:dataWorkflowNodeRefactor('<%=RuleID%>')">
				<%=labelService.getLabelName("历史数据重构")%></a> <!-- 流程归档历史数据重构 -->
	 		<% }else{
	 			if(istype==1&&!objtable.equals("workflowinfo")&&!objtable.equals("requestbase")&&!objtable.equals("doctype")){%>
			<a href="javascript:dataRefactor('<%=RuleID%>')">
				<%=labelService.getLabelName("历史数据重构")%></a> <!-- 分类历史数据重构 -->
			<%}else{%> 
			<a href="javascript:dataWorkflowRefactor('<%=RuleID%>')">
				<%=labelService.getLabelName("历史数据重构")%></a> <!-- 流程历史数据重构 -->
	<%}}}%>
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
function wfloptchange(obj){
	var wflopt = obj.value;
	var orderspanObj = document.getElementById("orderspan");
	if(wflopt=="5"){
		if(orderspanObj){
			orderspanObj.style.display="";
		}
	}else{
		if(orderspanObj){
			orderspanObj.style.display="none";
		}
	}
}
onChangeShareType();

function check_by_ShareType() {
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
    }else if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f8000a" && document.mainform.StationObjType.value=="297e828210f211130110f21d99710009") {
        return checkForm(mainform, "StationIDs","必填项不能为空！");
    }else {
        return true;
    }
}



function recreate(){
	document.mainform.action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionAction?action=recreate"+"&workflowshare=<%=workflowshare%>"+"&workflowshare=<%=workflowshare%>";
	document.mainform.submit();
}

function onChangeShareType(from) {
	thisvalue=document.mainform.ShareType.value;
 	document.all("showrolename").style.display='none';
    document.all("role_zidu").style.display='none';
	document.all("showPositionType").style.display = 'none';
	if (thisvalue == "402881e60bf4f747010bf4fec8f80007") {
		//_sharetype = document.all("UserObjType").value;
		_sharetype=jq("select[name='UserObjType']").val();
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
	 	}
    }else if (thisvalue == "402881e510efab3d0110efb21a700005") {
		//_sharetype = document.all("StationObjType").value;
		_sharetype=jq("select[name='StationObjType']").val();
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
			document.all("showrolename").style.display = 'none';	
	}
	else if (thisvalue == "402881e60bf4f747010bf4fec8f80009") {	//组织单元+安全级别+作用域
	    //_sharetype = document.all("OrgObjType").value;
		_sharetype=jq("select[name='OrgObjType']").val();
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
	 		document.all("showOrgShareType").style.display = '';
	 		//_orgSharetype = document.all("OrgShareType").value;
	 		_orgSharetype=jq("select[name='OrgShareType']").val();
	 		if(_orgSharetype == "402881ea0bfa0b45010bfa19f3bb000a" || _orgSharetype == "402881ea0bfa0b45010bfa19f3bb000b")
	 			document.all("showOrgUnitType").style.display = 'none';
	 		else	 			
	 			document.all("showOrgUnitType").style.display = '';
	 			
	 		if(_orgSharetype != "402881ea0bfa0b45010bfa19f3bb000a")
	 			document.all("showOrgReftype").style.display = '';
	 			
	 		document.all("showseclevel").style.display = '';
	 		document.all("showOrgManager").style.display = '';	
		 	//_OrgManage = document.all("OrgManager").value;
		 	_OrgManage=jq("select[name='OrgManager']").val();
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
			document.all("showrolename").style.display = 'none';	
			
	 		document.all("showOrgShareType").style.display = '';
	 		//_orgSharetype = document.all("OrgShareType").value;
	 		_orgSharetype=jq("select[name='OrgShareType']").val();
	 		if(_orgSharetype == "402881ea0bfa0b45010bfa19f3bb000a" || _orgSharetype == "402881ea0bfa0b45010bfa19f3bb000b")
	 			document.all("showOrgUnitType").style.display = 'none';
	 		else	 			
	 			document.all("showOrgUnitType").style.display = '';
	 		if(_orgSharetype != "402881ea0bfa0b45010bfa19f3bb000a")
	 			document.all("showOrgReftype").style.display = '';
	 		document.all("showseclevel").style.display = '';
 			document.all("showOrgManager").style.display = '';	
	 		//_OrgManage = document.all("OrgManager").value;
	 		_OrgManage=jq("select[name='OrgManager']").val();
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
			document.all("showrolename").style.display = 'none';
	 		document.all("showOrgShareType").style.display = '';
	 		//_orgSharetype = document.all("OrgShareType").value;
	 		_orgSharetype=jq("select[name='OrgShareType']").val();
	 		if(_orgSharetype == "402881ea0bfa0b45010bfa19f3bb000a" || _orgSharetype == "402881ea0bfa0b45010bfa19f3bb000b")
	 			document.all("showOrgUnitType").style.display = 'none';
	 		else	 			
	 			document.all("showOrgUnitType").style.display = '';
	 			
	 		if(_orgSharetype != "402881ea0bfa0b45010bfa19f3bb000a")
	 			document.all("showOrgReftype").style.display = '';
	 			
	 		document.all("showseclevel").style.display = '';
			document.all("showOrgManager").style.display = '';	
			//_OrgManage = document.all("OrgManager").value;
			_OrgManage=jq("select[name='OrgManager']").val();
			if(_OrgManage == 0 )
				document.all("showseclevel").style.display = '';
			else	 			
				document.all("showseclevel").style.display = 'none'; 	
		 }	 	
	}
	else if (thisvalue == "402881e60bf4f747010bf4fec8f8000a") {	 //人员+经理
        //_sharetype = document.all("StationObjType").value;
		_sharetype=jq("select[name='StationObjType']").val();
	    //_usersharetype = document.all("UserShareType").value;
	    _usersharetype=jq("select[name='UserShareType']").val();
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
	 		document.all("showUserShareType").style.display = '';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';
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
	 		document.all("showUserShareType").style.display = '';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';
	 	}
		if(_usersharetype == "4028801511760958011176701f79000f")	 			
 			document.all("showOrgUnitType").style.display = '';
 		else
 			document.all("showOrgUnitType").style.display = 'none';	  
 		if(_usersharetype == "4028804112055e810112059ba0c10007")	 			
 			document.all("showPositionType").style.display = '';
 		else
 			document.all("showPositionType").style.display = 'none';
 		if(_usersharetype=="4028801511760958011176701f79000c")
 			document.all("showseclevel").style.display = '';
 		else
 			document.all("showseclevel").style.display = 'none';
	}
	else if (thisvalue == "402881e60bf4f747010bf4fec8f8000b") {	 //人员+经理
        //_sharetype = document.all("StationObjType").value;
		_sharetype=jq("select[name='StationObjType']").val();
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
	 	} 
	}
	else if (thisvalue == "402881e60bf4f747010bf4fec8f8000c") { //组织单元+角色+作用域
		//_roletype = document.all("RoleType").value;
		_roletype=jq("select[name='RoleType']").val();
		//_roletype2 = document.all("RoleType2").value;
		_roletype2=jq("select[name='RoleType2']").val();
		if(_roletype2=="4028819a0f16b8f1010f179d98730010"){
			//_sharetype = document.all("RoleType2").value;
			_sharetype=jq("select[name='RoleType2']").val();
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
		}else{
			//_sharetype = document.all("OrgObjType").value;
			_sharetype=jq("select[name='OrgObjType']").val();
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
			 }
		 }
	}
}

</script>
<script type="text/javascript">
    function doSave() {
    if (check_by_ShareType()) {
<%
       if(istype==1&&!"requestbase".equals(objtable)){
%>       
        var fieldOf=document.getElementById("fieldOf");
        var str="";
        for(var i=0;i<fieldOf.options.length;i++){
            str+=fieldOf.options[i].value+",";
        }
        var fieldOfHidden=document.getElementById("fieldOfHidden");
        fieldOfHidden.value=str;
<%
        }
%>
		jq("select[name='ShareType']").removeAttr("disabled");
        document.mainform.submit();
	}else{
        <%if(istype==1&&!objtable.equals("workflowinfo")&&!objtable.equals("requestbase")&&!objtable.equals("doctype")){%>
         Ext.getCmp('S').enable();
         Ext.getCmp('C').enable();
          Ext.getCmp('H').enable();
       <%}else{%> 
        Ext.getCmp('S').enable();
        Ext.getCmp('C').enable();

       <%}%>
    }
   }
    function deleteperrule(ruleid,objid,objtable,istype,nodetype,opttype){   	
  		if(confirm("是否确认删除?")){
  			if(istype!='0'&&opttype!='2'){
  				if(nodetype=='4'||nodetype=='0'){					
  					if(confirm("是否需要删除数据权限?")){
  						location.href="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionAction?action=delete&RuleID="+ ruleid +"&objid=" + objid + "&objtable=" + objtable + "&istype="+istype+"&workflowshare=<%=workflowshare%>&formid=<%=formid %>"+"&deltype=1";
  					}else{
  						location.href="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionAction?action=delete&RuleID="+ ruleid +"&objid=" + objid + "&objtable=" + objtable + "&istype="+istype+"&workflowshare=<%=workflowshare%>&formid=<%=formid %>"+"&deltype=0";
  					} 
  				}else{
  					location.href="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionAction?action=delete&RuleID="+ ruleid +"&objid=" + objid + "&objtable=" + objtable + "&istype="+istype+"&workflowshare=<%=workflowshare%>&formid=<%=formid %>"+"&deltype=0";
  				}				
  			}else{
  				location.href="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionAction?action=delete&RuleID="+ ruleid +"&objid=" + objid + "&objtable=" + objtable + "&istype="+istype+"&workflowshare=<%=workflowshare%>&formid=<%=formid %>"+"&deltype=0";
  			}  					 	
  		}
  }
  
  function editperrule(RuleID,ShareType,RoleType,OrgObjType,UserObjType,
                       UserIDs,OrgObjID,WFOperatorNodeID,FormfieldID,OrgShareType,
                       RoleObjID,UserShareType,OrgUnitType,StationObjType,StationIDs,
                       OrgReftype,notifydefineid,OrgManager,minseclevel,maxseclevel,
                       RightType1,RightType2,RightType3,layoutid,layoutid1,
                       mobilelayoutid,mobilelayoutid1,priority,mobilepriority,detailFilter,
                       restrictionsField,orderopt,fieldOf,notifytype,UserNames,
                       OrgObjName,StationNames,RoleObjName,condition,fieldOfNames,isdefault,istype){
	  jq("input[name='RuleID']").val(RuleID);
	  jq("select[name='ShareType']").val(ShareType);
	  jq("select[name='RoleType']").val(RoleType);
	  jq("select[name='OrgObjType']").val(OrgObjType);
	  jq("select[name='UserObjType']").val(UserObjType);
	  jq("select[name='StationObjType']").val(StationObjType);
	  jq("#StationIDs").val(StationIDs);
	  jq("#StationIDsSpan").html(StationNames);
	  jq("#UserIDs").val(UserIDs);
	  jq("#UserIDsSpan").html(UserNames);
	  jq("#OrgObjID").val(OrgObjID);
	  jq("#OrgObjIDSpan").html(OrgObjName);
	  jq("select[name='WFOperatorNodeID']").val(WFOperatorNodeID);
	  jq("select[name='OrgShareType']").val(OrgShareType);
	  jq("select[name='OrgReftype']").val(OrgReftype);
	  if(ShareType=='402881e60bf4f747010bf4fec8f8000c'){
	  	jq("select[name='RoleType2']").val(UserShareType);
	  }
	  jq("#RoleObjID").val(RoleObjID);
	  jq("#showrolename2").html(RoleObjName);
	  if(UserShareType!='402881d90f2cbe0d010f2d048cdc000d'&&ShareType=='402881e60bf4f747010bf4fec8f8000c'){
	  	jq("#role_ziduid").val(RoleObjID);
	  }
	  if(ShareType=='402881e60bf4f747010bf4fec8f8000a'&&UserShareType=='4028804112055e810112059ba0c10007'){
		  jq("select[name='position']").val(OrgUnitType);
	  }
	  jq("select[name='UserShareType']").val(UserShareType);
	  if(ShareType=='402881e60bf4f747010bf4fec8f8000b'){
	  	jq("select[name='position']").val(UserShareType);
	  }
	  jq("select[name='OrgUnitType']").val(OrgUnitType);
	  jq("select[name='OrgManager']").val(OrgManager);
	  jq("#minseclevel").val(minseclevel);
	  jq("#maxseclevel").val(maxseclevel);
	  jq("#RightType").val(RightType1).change();
	  jq("#notifytype").val(notifytype).change();
	  jq("#notifydefineid").val(notifydefineid);
	  jq("select[name='RightType2']").val(RightType2);
	  jq("select[name='RightType3']").val(RightType3).change();
	  
	  jq("select[name='orderopt']").val(orderopt);
	  jq("input[name='RightType3']").val(RightType3);
	  jq("#restrictionsField").val(restrictionsField);
	
	  jq("select[name='fieldOf']").empty();
	  var fieldOfArr=fieldOf.split(",");
	  var fieldOfNamesArr=fieldOfNames.split(",");
	  for(var i=0;i<fieldOfArr.length;i++){
		  if(fieldOfArr[i]!=''){
			  jq("select[name='fieldOf']").append("<option value='"+fieldOfArr[i]+"'>"+fieldOfNamesArr[i]+"</option>");
		  }
	  }

	  jq("#layoutid").val(layoutid);
	  jq("#layoutid1").val(layoutid1);
	  jq("#priority").val(priority);
	  jq("#mobilelayoutid").val(mobilelayoutid);
	  jq("#mobilelayoutid1").val(mobilelayoutid1);
	  jq("#mobilepriority").val(mobilepriority);
	  jq("input[name='condition']").val(condition);
	  jq("input[name='isdefault']").val(isdefault);
	  jq("input[name='istype']").val(istype);
	  DWREngine.setAsync(false);
	  onChangeShareType();
	  DWREngine.setAsync(true);
	   
	  jq("select[name='ShareType']").attr("disabled","disabled");
	  jq("select[name='FormfieldID']").val(FormfieldID);
  }
  
  //单条规则分类历史数据重构
  function dataRefactor(ruleid){
 	if(!confirm("是否需要对此规则进行历史数据重构?")){
  		return; 	
  	}
 	total=0;
        currentCount=0;
        Ext.getCmp('S').disable();
        Ext.getCmp('C').disable();
        Ext.getCmp('H').disable();
        Ext.fly('tr_p1').setDisplayed(true);
        Ext.fly('p1text').update('');
        if (!pbar1.rendered){
            pbar1.render('p1');
        }else{
            pbar1.text = '';
            pbar1.show();
        }
        doRefactor1('<%=objid%>','<%=refactorTable%>',ruleid);
        if(total==-1){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('C').enable();
        Ext.getCmp('H').enable();
        Ext.fly('p1text').update('<%=labelService.getLabelName("请等待先前的任务完成")%>').show();
        return;
        }
        if(total==0){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('C').enable();
        Ext.getCmp('H').enable();
        Ext.fly('p1text').update('<%=labelService.getLabelName("重构完成")%>').show();
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('<%=labelService.getLabelName("重构完成")%>'+'!').show();
        });
  }
  
  //单条规则流程历史数据重构
  function dataWorkflowRefactor(ruleid){
 	if(!confirm("是否需要对此规则进行历史数据重构?")){
  		return; 	
  	}
 	
 	total=0;
        currentCount=0;
        Ext.getCmp('S').disable();
        Ext.getCmp('C').disable();
        Ext.getCmp('G').disable();
        Ext.fly('tr_p1').setDisplayed(true);
        Ext.fly('p1text').update('');
        if (!pbar1.rendered){
            pbar1.render('p1');
        }else{
            pbar1.text = '';
            pbar1.show();
        }
        doRefactorWorkflowinfo1('<%=objid%>',ruleid);
        if(total==-1){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('C').enable();
        Ext.getCmp('G').enable();
        Ext.fly('p1text').update('<%=labelService.getLabelName("请等待先前的任务完成")%>').show();
        return;
        }
        if(total==0){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('C').enable();
        Ext.getCmp('G').enable();
        Ext.fly('p1text').update('<%=labelService.getLabelName("没有历史数据存在")%>'+'!').show();
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('<%=labelService.getLabelName("重构完成")%>'+'!').show();
        });
  }
   
   //单条规则流程归档节点历史数据重构
  function dataWorkflowNodeRefactor(ruleid){
 	if(!confirm("是否需要对此规则进行历史数据重构?")){
  		return; 	
  	}
 	pbar1 = new Ext.ProgressBar({
       text:''
    });
 	total=0;
        currentCount=0;
        Ext.getCmp('S').disable();
        Ext.getCmp('C').disable();
        //Ext.getCmp('G').disable();
        Ext.fly('tr_p1').setDisplayed(true);
        Ext.fly('p1text').update('');
        if (!pbar1.rendered){
            pbar1.render('p1');
        }else{
            pbar1.text = '';
            pbar1.show();
        }
        doRefactorWorkflowNodeinfo('<%=flowid%>',ruleid);
        if(total==-1){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('C').enable();
       // Ext.getCmp('G').enable();
        Ext.fly('p1text').update('<%=labelService.getLabelName("请等待先前的任务完成")%>').show();
        return;
        }
        if(total==0){
        pbar1.reset(true);
        Ext.getCmp('S').enable();
        Ext.getCmp('C').enable();
        //Ext.getCmp('G').enable();
        Ext.fly('p1text').update('<%=labelService.getLabelName("没有历史数据存在")%>'+'!').show();
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('<%=labelService.getLabelName("重构完成")%>'+'!').show();
        });
  }
  
  
</script>
<script type="text/javascript">
    
    function getBrowser(url,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
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
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
 function onshowOrgObjID(tdname,inputname){
	var idsin = document.all(inputname).value;
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/orgunit/orgunitbrowser.jsp?idsin="+idsin);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(tdname).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		document.all(tdname).innerHTML = '';
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
		document.all(tdname).innerHTML = '';
            }
         }
 }

 function getCondition(url,inputspan){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
    }catch(e){}
	if (id!=null) {
		document.all(inputspan).innerHTML = id;
        rule=url.substring(url.lastIndexOf('=')+1);
        Ext.Ajax.request({
                        url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=updaterule',
                    params:{ruleid:rule,condition:id},    
                        success: function(res) {

                            }
          });
         }
 }   
</script>

<script src='<%= request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%= request.getContextPath()%>/dwr/util.js'></script>
<script Language="JavaScript">

	function getformfield(permtypeid){
		var amongobj = '<%=objid%>';
		 <%if(istype==0&&("formbase".equals(refactorTable)||"docbase".equals(refactorTable))){
			 if(!StringHelper.isEmpty(categoryid)){
		 %>
				amongobj = '<%=categoryid%>';
		 <%}}%>
		 <%if(istype==0&&"requestbase".equals(objtable)){
		 	 if(!StringHelper.isEmpty(nodeid)){
		 %>
				amongobj = '<%=nodeid%>';
		 <%}}%>
		<%if(StringHelper.isEmpty(objTableStr)){%>
           DataService.getFormfieldForPermission(createList,permtypeid,'<%=objtable%>',amongobj);
         <%}else{%>
           DataService.getFormfieldForPermission(createList,permtypeid,'<%=objTableStr%>',amongobj);
         <%}%>
       	return true;
    }

	function getformfield2(permtypeid){
       	DataService.getFormfieldForPermission(createList2,permtypeid,'<%=objtable%>','<%=objid%>');
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

function doRefactor1(categoryid,refactortable,ruleid){
    if(refactortable){
    DWREngine.setAsync(false);
    RightTransferService.refactor1(categoryid,refactortable,ruleid,returnTotal);
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

function doRefactorWorkflowinfoShare(workflowid){
    DWREngine.setAsync(false);
    RightTransferService.refactorWorkflowinfoShare(workflowid,returnTotal);
    DWREngine.setAsync(true);
}

function doRefactorWorkflowinfo1(workflowid,ruleid){
    DWREngine.setAsync(false);
    RightTransferService.refactorWorkflowinfoSingel(workflowid,ruleid,returnTotal);
    DWREngine.setAsync(true);
}

function doRefactorWorkflowNodeinfo(workflowid,ruleid){
    DWREngine.setAsync(false);
    RightTransferService.refactorNodeinfoSingel(workflowid,ruleid,returnTotal);
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
        var rightType2=document.getElementById("RightType2");
        if(rightType.value=="2"){
            document.getElementById("restrictionsFieldtr").style.display="none";
            document.getElementById("fieldOftr").style.display="none";
            if(rightType2!=null){
            	rightType2.style.display="none";
            }
        }
        else{
            document.getElementById("restrictionsFieldtr").style.display="block";
            document.getElementById("fieldOftr").style.display="block";
            if(rightType2!=null){
            	rightType2.style.display="block";
            }
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