<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@page import="com.eweaver.workflow.version.service.WorkflowVersionService"%>
<%@page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@page import="com.eweaver.workflow.version.model.WorkflowVersion"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.log.service.LogService" %>
<%@ page import="com.eweaver.workflow.report.model.*" %>
<%@ page import="com.eweaver.workflow.report.service.*" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ include file="/humres/base/openhrm.jsp"%>
<%
int pageSize=20;
int gridWidth=700;
int gridHeight=330;
String isshow=StringHelper.null2String(request.getParameter("isshow")) ; //isshow=0表示默认不加载出数据
String isindagate=StringHelper.null2String(request.getParameter("isindagate"));
 String reportid = request.getParameter("reportid");
Formfield treeField = (Formfield) request.getAttribute("treeField");
String isformbase = StringHelper.null2String(request.getParameter("isformbase"));
String sqlwhere= StringHelper.null2String(request.getParameter("sqlwhere"));
String showCheckbox= StringHelper.null2String(request.getParameter("showCheckbox"));
String contemplateid = StringHelper.null2String(request.getAttribute("contemplateid"));
Page pageObject = (Page) request.getAttribute("pageObject");
Map summap = (Map)request.getAttribute("sum");
paravaluehm = (HashMap)request.getAttribute("paravaluehm");
if(paravaluehm==null){
	paravaluehm = new HashMap();
}
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
 String isnew=StringHelper.null2String(request.getParameter("isnew"));
//**********************得到树关联列的报表设置属性(start)************************//
int treeFieldWidth=15;
Reportfield reportfieldObj = reportfieldService.getReportfieldByFormFieldId(reportid,treeField.getId());
treeFieldWidth = reportfieldObj.getShowwidth();   
//**********************得到树关联列的报表设置属性(end)************************//
 SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
CombinefieldService combinefieldService = (CombinefieldService)BaseContext.getBean("combinefieldService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
DataService dataService=new DataService();
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
    Reportdef reportdef=reportdefService.getReportdef(reportid);
 String datastatus=StringHelper.null2String(request.getParameter("datastatus"));
 String isdatastatus=StringHelper.null2String(request.getParameter("isdatastatus"));
Setitem setitemlist=setitemService.getSetitem("4028818411b2334e0185ed352670175");
ContemplateService contemplateService = (ContemplateService)BaseContext.getBean("contemplateService");
if(StringHelper.isEmpty(contemplateid)){
    List contemplateList = dataService.getValues("select cp.* from contemplate cp,contemplatestate cs" +
							" where cp.id=cs.contemplateid and cp.reportid='"+reportid+"' and cp.userid='"+currentuser.getId()+"'" +
							" and cp.ispublic='False' and cs.isdefault=1 order by objdesc ");
    if(contemplateList.size()!=0){
        contemplateid = StringHelper.null2String(((Map)contemplateList.get(0)).get("id"));
        contemplateList = dataService.getValues("select cp.* from contemplate cp,contemplatestate cs " +
				    			" where cp.id=cs.contemplateid and cp.reportid='"+reportid+"' and cp.ispublic='True' " +
				    			" and cs.isdefault=1 and cs.userid='"+currentuser.getId()+"' order by objdesc  ");
        if(contemplateList.size()!=0){
        	 contemplateid = StringHelper.null2String(((Map)contemplateList.get(0)).get("id"));
        }
    }
}
List reportfieldList = reportfieldService.getReportfieldListForUser(reportid,contemplateid);
if(reportfieldList.size()==0){
	reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
}
    String sysmodel = request.getParameter("sysmodel");
String formid=reportdefService.getReportdef(reportid).getFormid();
int rows=0;
int cols=0;
List reportdatalist = new ArrayList();//用于保存转换后的查询数据

String jsonStr=null;
Map fieldsearchMap = (Map)request.getAttribute("fieldsearchMap");
if(fieldsearchMap != null){
        JSONObject jsonObject=new JSONObject();
        Set keySet=fieldsearchMap.keySet();
        for(Object key:keySet){
            String value=StringHelper.null2String(fieldsearchMap.get(key));
            if(!StringHelper.isEmpty(value))
            jsonObject.put(key,value);
        }
        if(!"".equals(sqlwhere.trim())){
        jsonObject.put("sqlwhere",sqlwhere);
        }
        jsonStr=jsonObject.toString();
    }
    boolean isauth = permissiondetailService.checkOpttype(reportid,6);
%>

<!--页面菜单开始-->
<%

paravaluehm.put("{id}",reportid);
//pagemenustr +="addBtn(tb,'"+labelService.getLabelName("快捷搜索")+"','S','zoom',function(){onSearch2()});";
pagemenustr+=" tb.add(querybtn);";
pagemenustr +="addBtn(tb,'"+labelService.getLabelName("清空条件")+"','R','erase',function(){reset()});";
pagemenustr +="addBtn(tb,'"+labelService.getLabelName("高级搜索")+"','G','zoom',function(){onSearch3()});";
PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
pagemenustr += _pagemenuService2.getPagemenuStrExt(reportid,paravaluehm).get(0);



if(pagemenuorder.equals("0")) {
	pagemenustr =_pagemenuService2.getPagemenuStrExt(theuri,paravaluehm).get(0) + pagemenustr;
}else{
	pagemenustr = pagemenustr + _pagemenuService2.getPagemenuStrExt(theuri,paravaluehm).get(0);
}
 if(isauth&&StringHelper.isEmpty(sysmodel)&&!isdatastatus.equals("2"))
{
   pagemenustr +="addBtn(tb,'"+labelService.getLabelName("删除")+"','D','delete',function(){onDelete()});";
  }
    //pagemenustr += "addBtn(tb,'"+labelService.getLabelName("模板管理")+"','M','page_copy',function(){showtemplate()});"; 
%>
<html>
<head>
<style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
    /*TD{*/
        /*width:16%;*/
    /*}*/
    .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
       .ux-maximgb-treegrid-breadcrumbs{
         display:none;
     }
     .noPlusSum .ux-maximgb-treegrid-elbow-end-plus{background:none !important;}
      a { color:blue; cursor:pointer; }
     /*解决IE10下报表上下级显示时错行的问题*/
     .x-grid3-cell-first .x-grid3-cell-inner{
     	width: auto;
     }
</style>
  <script language="javascript">
function changestype(val,cond){
if(eval(cond)){
document.all(val).style.background="red";
}
}
</script>
<script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%=request.getContextPath()%>/dwr/util.js'></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
<script src='<%=request.getContextPath()%>/dwr/interface/FormbaseService.js'></script> 
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/TreeGrid.css" />
<script type='text/javascript' src='<%=request.getContextPath()%>/js/ext/examples/grid/RowExpander.js'></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/ext/ux/TreeGrid.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
<script type="text/javascript">
var queryMenu = new Ext.menu.Menu({
				shadow :false,
				items :[
					<%
                         List contemplateList= (List) request.getAttribute("contemplateList");
                         if(contemplateList!=null){
                         for(int i=0;i<contemplateList.size();i++){
                            Contemplate contemplate= (Contemplate) contemplateList.get(i);
                     %>
                     {
						id:'<%=contemplate.getId()%>',
				       	text:'<%=contemplate.getObjname()%>', 	
						icon:<%if("True".equals(contemplate.getIspublic()))out.print("'/images/silk/zoom.gif'");else out.print("'/images/silk/zoom_in.gif'");%>,
						handler:function(){onSearchByTemplate('<%=contemplate.getId()%>');}
					},
                     <%
                         }
                         }
                     %>
                     new Ext.menu.Separator(),//分隔线 
                     {
						id:'macontemplate',
				       	text:'<%=labelService.getLabelName("模板管理")%>',
				       	key:'M',
				       	alt:true,
						icon:'/images/silk/page_copy.gif',
						handler:function(){showtemplate();}
					},
					{
						id:'savecontemplate',
				       	text:'<%=labelService.getLabelName("保存查询条件至模板")%>',
				       	key:'S',
				       	alt:true,
						icon:'/images/silk/disk.gif',
						handler:function(){sAlert();}
					}
				]}
			
			);	
var querybtn = new Ext.Toolbar.SplitButton({
					   	id:'querybtn',
					   	text:'<%=labelService.getLabelName("快捷搜索")%>(S)',
					   	key:'S',
					   	alt:true,
						iconCls:Ext.ux.iconMgr.getIcon('zoom'),
						handler:function(){onSearch2()},
						menu :queryMenu
					});
    Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
    var store;
    var selected=new Array();
    var dlg0;
     var grid;
    <%

String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&from=list&isnew="+isnew+"&reportid=" + reportid;
String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isnew="+isnew+"&reportid=" + reportid;
String tmpaction = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=searchtemplate&reportid="+reportid;
if(!StringHelper.isEmpty(sysmodel)){
	action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&from=list&isnew="+isnew+"&reportid=" + reportid;
	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&isnew="+isnew+"&reportid=" + reportid;
    tmpaction = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=searchtemplate&reportid="+reportid;
}else{
	//pagemenustr += "{C,"+ "生成EXCEL文件" +",javascript:createexcel()}";
}

if(isformbase!=null && !isformbase.equals("")){
    tmpaction +="&isformbase="+isformbase;
}
        String cmstr="";
        String fieldstr="";
        cols = reportfieldList.size();
        fieldstr+="'requestid'";
        Map reporttitleMap = new HashMap();
       int k=0;

        Iterator it = reportfieldList.iterator();
        Iterator it2 = reportfieldList.iterator();
        while (it2.hasNext()) {
            Reportfield reportfield = (Reportfield) it2.next();
            if(reportfield.getFormfieldid().equals(treeField.getId())){
                fieldstr+=",'"+labelService.getLabelName(treeField.getFieldname())+"'";
                cmstr+="{id:'"+labelService.getLabelName(treeField.getFieldname())+"',header:'"+labelService.getLabelName(reportfield.getShowname())+"',dataIndex:'"+labelService.getLabelName(treeField.getFieldname())+"',width:"+reportfield.getShowwidth()*gridWidth/100+",sortable:true}";
                reportfieldList.remove(reportfield);
                break;
            }
        }
        it2= reportfieldList.iterator();

		while(it2.hasNext()){
			Reportfield reportfield = (Reportfield) it2.next();
			reporttitleMap.put(reportfield.getShowname(),reportfield.getShowname());
			Integer showwidth = reportfield.getShowwidth();
			String widths = "";
			if(showwidth!=null && showwidth.intValue()!=-1){
				widths = "width=" + showwidth + "%";
			}
			Formfield formfields = formfieldService.getFormfieldById(reportfield.getFormfieldid());
			String thtmptype = "";
			if(formfields.getHtmltype() != null){
				thtmptype = formfields.getHtmltype().toString();
			}
			String tfieldtype = "";
			if(formfields.getFieldtype()!=null){
				tfieldtype = formfields.getFieldtype().toString();
			}

			String styler = "";
			if("1".equals(thtmptype) && ("2".equals(tfieldtype) || "3".equals(tfieldtype))){
				styler = "style='text-align :right'";
			}
         	String fieldname=labelService.getLabelName(formfields.getFieldname()) ;
         	if(StringHelper.isEmpty(fieldname)){
				fieldname=reportfield.getId();
			}
         	String showname=labelService.getLabelName(reportfield.getShowname());
         	int sortable=NumberHelper.getIntegerValue(reportfield.getIsorderfield(),0);
         	if(cmstr.equals("")){
         	   if(sortable==0)
                cmstr+="{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:false}";
                else
                 cmstr+="{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            }
            else{
                if(sortable==0)
                cmstr+=",{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:false}";
                else
                cmstr+=",{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            }
            if(fieldstr.equals(""))
            fieldstr+="'"+fieldname+"'";
            else
            fieldstr+=",'"+fieldname+"'";
      	k++;
      }
      	reportdatalist.add(reporttitleMap);//生成excel报表时用到

      %>
    <%
    	if(isSysAdmin){
    		pagemenustr +="tb.add('->');";
    		pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220035")+"','T','page_white_gear',function(){toSet('"+reportid+"','report')});";//报表设置
    %>
    		function toSet(soureid,souretype){
				var url='/base/toSet.jsp?soureid='+soureid+'&souretype='+souretype
				onUrl(url,'<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001b")%>',soureid);//设置
			}
    <%}%>
    Ext.override(Ext.Button,{
            toggle : function(state){
                state = state === undefined ? !this.pressed : state;
                if(state != this.pressed){
                    if(state){
                        //this.el.addClass("x-btn-pressed");
                        this.pressed = true;
                        this.fireEvent("toggle", this, true);
                    }else{
                        this.el.removeClass("x-btn-pressed");
                        this.pressed = false;
                        this.fireEvent("toggle", this, false);
                    }
                    if(this.toggleHandler){
                        this.toggleHandler.call(this.scope || this, this, state);
                    }
                }
            }

        })
    var viewport = null;
   //Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow-end-plus', true).style.background='url(<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif)';
    <%if("0".equals(setitemlist.getItemvalue())){ %>//     0表示默认显示是树形
    Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow', true).style.background = 'url(<%=request.getContextPath()%>/js/ext/resources/images/default/tree/elbow.gif)';
    Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow-end', true).style.background = 'url(<%=request.getContextPath()%>/js/ext/resources/images/default/tree/elbow-end.gif)';
    <%}else{%>   //1表示默认显示列表显示
    Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow', true).style.background = 'url(<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif)';
    Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow-end', true).style.background = 'url(<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif)';
    <% }%>

    Ext.onReady(function(){

    Ext.QuickTips.init();
    <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
       tb.add('->');
       tb.add(pagemenutable);
        <%if(isauth&&StringHelper.isEmpty(sysmodel)){%>
        tb.add('->');
        tb.add(datatable);
        <%}%>
       <%}%>
    store = new Ext.ux.maximgb.treegrid.AdjacencyListStore({
        proxy: new Ext.data.HttpProxy({
            url: '<%=action2+"&isjson=1&pagesize="+pageSize+"&isformbase="+isformbase%>'
        }),
			reader: new Ext.data.JsonReader(
				{
                    sql1:'sql1',
                    sql2:'sql2',
                    id: 'requestid',
					root: 'result',
					totalProperty: 'totalCount',
                     <% if((StringHelper.isEmpty(isdatastatus)||"0".equals(isdatastatus))&&isauth&&StringHelper.isEmpty(sysmodel)){%>
             fields: ['requestid','_parent','_is_leaf',<%=fieldstr%>,'del']
            <%}else{%>
             fields: ['requestid','_parent','_is_leaf',<%=fieldstr%>]
            <%}%>

                }),
        remoteSort: true
    });
    //store.setDefaultSort('id', 'desc');
    <%if(showCheckbox.equals("true")){%>
    var sm=new Ext.grid.CheckboxSelectionModel();                             
    var cm = new Ext.grid.ColumnModel([sm,<%=cmstr%>]);
    <%}else{%>
    var sm=new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
          <% if((StringHelper.isEmpty(isdatastatus)||"0".equals(isdatastatus))&&isauth&&StringHelper.isEmpty(sysmodel)){
           showCheckbox="true";
           %>
         var sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([sm,<%=cmstr%>,{header: "<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e")%>",sortable: false,  dataIndex: 'del'}]);//操作
      <%}else if((StringHelper.isEmpty(isdatastatus)||"1".equals(isdatastatus))&&isauth&&StringHelper.isEmpty(sysmodel)){
            showCheckbox="true";
           %>
          var sm=new Ext.grid.CheckboxSelectionModel();
       var cm = new Ext.grid.ColumnModel([sm,<%=cmstr%>]);

    <%}else if(reportdef.getIsbatchupdate().intValue()==1){
          showCheckbox="true";    %>
        var sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([sm,<%=cmstr%>]);
    <%}else{%>
          var cm = new Ext.grid.ColumnModel([<%=cmstr%>]);
        <%}%>

    <%}%>

    //cm.defaultSortable = true;

                    grid = new Ext.ux.maximgb.treegrid.GridPanel({
                       region: 'center',
                       store: store,
                       cm: cm,
                       trackMouseOver:false,
                       sm:sm ,
                       master_column_id : '<%=labelService.getLabelName(treeField.getFieldname())%>',
                       autoExpandColumn: '<%=labelService.getLabelName(treeField.getFieldname())%>',
                       loadMask: true,
                       viewConfig: {
                           <%if((StringHelper.isEmpty(isdatastatus)||"0".equals(isdatastatus))&&isauth&&StringHelper.isEmpty(sysmodel)){%>
                           forceFit:false,
                           <%}else{%>
                             forceFit:true,
                           <%}%>
                           enableRowBody:true,
                           sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                           sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                           columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                           getRowClass : function(record, rowIndex, p, store){
                               return 'x-grid3-row-collapsed';
                           }
                       },
                        tbar:[{
                                               id:'switchView',
                                               iconCls:Ext.ux.iconMgr.getIcon('application_view_list'),
                                                <%
                                                 if(setitemlist.getItemvalue().equals("1")){
                                                %>
                                               text:'<%=labelService.getLabelName("切换到树形显示")%>',
                                                <%}else{%>
                                                text:'<%=labelService.getLabelName("切换到列表显示")%>',
                                                   <%}%>
                                               enableToggle: true,
                                              toggleHandler: function(item,pressed) {
                                                  if (pressed)
                                                  {
                                                       <%if(setitemlist.getItemvalue().equals("0")){%>
                                                          Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow', true).style.background='url(<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif)';
                                                     Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow-end', true).style.background='url(<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif)';
                                                    this.setText('<%=labelService.getLabelName("切换到树形显示")%>');
                                                      Ext.query('#switchView')[0].title='<%=labelService.getLabelName("切换到上下级视图")%>';
                                                      this.setIconClass(Ext.ux.iconMgr.getIcon('shape_align_left'));
                                                      store.baseParams.isthread = 0;
                                                      store.baseParams.isindagate='<%=isindagate%>';
                                                      store.load();

                                                      <%}else{%>
                                                               Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow', true).style.background='url(<%=request.getContextPath()%>/js/ext/resources/images/default/tree/elbow.gif)';
                                                        Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow-end', true).style.background='url(<%=request.getContextPath()%>/js/ext/resources/images/default/tree/elbow-end.gif)';
                                                        this.setText('<%=labelService.getLabelName("切换到列表显示")%>');
                                                      Ext.query('#switchView')[0].title='<%=labelService.getLabelName("切换到列表视图")%>';
                                                      this.setIconClass(Ext.ux.iconMgr.getIcon('application_view_list'));
                                                      store.baseParams.isthread = 1;
                                                       store.baseParams.isindagate='<%=isindagate%>';
                                                      store.load();
                                                      <%}%>

                                                  } else {
                                                       <%if(setitemlist.getItemvalue().equals("0")){%>
                                                       Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow', true).style.background='url(<%=request.getContextPath()%>/js/ext/resources/images/default/tree/elbow.gif)';
                                                        Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow-end', true).style.background='url(<%=request.getContextPath()%>/js/ext/resources/images/default/tree/elbow-end.gif)';
                                                        this.setText('<%=labelService.getLabelName("切换到列表显示")%>');
                                                      Ext.query('#switchView')[0].title='<%=labelService.getLabelName("切换到列表视图")%>';
                                                      this.setIconClass(Ext.ux.iconMgr.getIcon('application_view_list'));
                                                      store.baseParams.isthread = 1;
                                                       store.baseParams.isindagate='<%=isindagate%>';
                                                      store.load();
                                                       <%}else{%>
                                                            Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow', true).style.background='url(<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif)';
                                                     Ext.util.CSS.getRule('.ux-maximgb-treegrid-elbow-end', true).style.background='url(<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif)';
                                                    this.setText('<%=labelService.getLabelName("切换到树形显示")%>');
                                                      Ext.query('#switchView')[0].title='<%=labelService.getLabelName("切换到上下级视图")%>';
                                                      this.setIconClass(Ext.ux.iconMgr.getIcon('shape_align_left'));
                                                      store.baseParams.isthread = 0;
                                                      store.baseParams.isindagate='<%=isindagate%>';
                                                      store.load();
                                                       <%}%>
                                                  }
                                              }
                                     }] ,

         bbar: new Ext.ux.maximgb.treegrid.PagingToolbar({
                           pageSize: <%=pageSize%>,
            store: store,
            displayInfo: true,
            beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
            afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
            firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
            prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
            nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
            lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
            refreshText:"<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc8893c0027")%>",//刷新
            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示     条记录
            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
        })
    });

    /*store.on('beforeload',function(){
        alert(selected.length);
    });*/
    store.baseParams=<%=(jsonStr==null?"{}":jsonStr)%>
      store.baseParams.datastatus='<%=datastatus%>';
    <%
     if(setitemlist.getItemvalue().equals("0")){
    %>
        store.baseParams.isthread=1;
    <%}else{%>
        store.baseParams.isthread = 0;
    <%}%>
    <%if(showCheckbox.equals("true")){%>
    store.on('load',function(st,recs){
        Ext.getDom('sqlstr1').value=st.reader.jsonData.sql1;
        Ext.getDom('sqlstr2').value=st.reader.jsonData.sql2;
        for(var i=0;i<recs.length;i++){
            var reqid=recs[i].get('requestid');
        for(var j=0;j<selected.length;j++){
                    if(reqid ==selected[j]){
                         sm.selectRecords([recs[i]],true);
                     }
                 }
    }
    }
            );
    sm.on('rowselect',function(selMdl,rowIndex,rec ){
        var reqid=rec.get('requestid');      
        for(var i=0;i<selected.length;i++){
                    if(reqid ==selected[i]){
                         return;
                     }
                 }
        selected.push(reqid)
    }
            );
    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        var reqid=rec.get('requestid');
        for(var i=0;i<selected.length;i++){
                    if(reqid ==selected[i]){
                        selected.remove(reqid)
                         return;
                     }
                 }

    }
            );
     <%}else{%>
        store.on('load', function(st, recs) {
            Ext.getDom('sqlstr1').value=st.reader.jsonData.sql1;
            Ext.getDom('sqlstr2').value=st.reader.jsonData.sql2;
        });
     <%}%>
    //Viewport
    //ie6 bug
    Ext.get('divSearch').setVisible(true);
	 viewport = new Ext.Viewport({
        layout: 'border',
        items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
	});
         <%
     if(setitemlist.getItemvalue().equals("0")){
    %>
        Ext.query('#switchView')[0].title='<%=labelService.getLabelName("切换到列表视图")%>';
        <%}else{%>
        Ext.query('#switchView')[0].title='<%=labelService.getLabelName("切换到上下级视图")%>';

        <%}%>
         <%
          if(StringHelper.isEmpty(isshow)||!isshow.equals("0")){
        %>
    store.on("load",function(_store,record){
        if(_store.getCount()<=0) return;
      var rowEl=grid.view.getRow(_store.getCount()-1);
      var span=Ext.DomQuery.selectNode("span[class=sumXXXX]",rowEl);
     if(typeof(span)=='object' && span.tagName=='SPAN') rowEl.className+=' noPlusSum ';
     	store.each(function(record) {//树型默认展表
	      if(!store.isLeafNode(record)){
	       		 store.expandNode(record);
	    	}
	   });
    });
    store.load({params:{start:0, limit:<%=pageSize%>}});
    
        <%}%>

        
         dlg0 = new Ext.Window({
                layout:'border',
                closeAction:'hide',
                plain: true,
                modal :true,
                width:viewport.getSize().width*0.8,
                height:viewport.getSize().height*0.8,
                buttons: [{
                    text     : '<%=labelService.getLabelName("关闭")%>',
                    handler  : function(){
                        dlg0.hide();
						store.reload();
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

});

</script>
</head>
<body style="margin:10px,10px,10px,0px;padding:0px" >


<div id="divSearch" style="display:none;">
 <div id="pagemenubar"></div>
 <%
 	String language=StringHelper.isEmpty(eweaveruser.getSysuser().getLanguage())?"zh_CN":StringHelper.null2String(eweaveruser.getSysuser().getLanguage());
 %>
 <table <%if(language.equals("zh_CN")){ %> style="width:300px" <%}else{ %> style="width:360px" <%} %> id="pagemenutable">
         <tr>
             <td align="right">
                 <%--<a href="javascript:sAlert();"><%=labelService.getLabelName("保存该查询条件至模板")%></a>&nbsp;
                 <select id="contemplate" onchange="onSearch4('<%=reportid%>')" style="width:150">
                     <option value="0"><%=labelService.getLabelName("请选择查询模板")%></option>
                     <%
                         List contemplateList= (List) request.getAttribute("contemplateList");
                         if(contemplateList!=null){
                         Iterator itObj=contemplateList.iterator();
                         while(itObj.hasNext()){
                            Contemplate contemplate= (Contemplate) itObj.next();
                     %>
                         <option value="<%=contemplate.getId()%>" <%if(contemplate.getId().equals(contemplateid)){%>selected="selected"<%}%>><%=contemplate.getObjname()%>(<%if("False".equals(contemplate.getIspublic())){%><%=labelService.getLabelName("私人")%><%}else{%><%=labelService.getLabelName("公共")%><%}%>)</option>
                     <%
                         }
                         }
                     %>
                 </select> --%>
             </td>
         </tr>
     </table>
  <%if(isauth&&StringHelper.isEmpty(sysmodel)){%>
 <table id="datatable">
         <tr >
         <td  >
            <%=labelService.getLabelName("数据状态")%> &nbsp;&nbsp;<select class="inputstyle" id="datastatus" name="datastatus" onchange="datasearch(this.options[this.options.selectedIndex].value)">
                 <%
                     String selected1="";
                     String selected2="";
                     String selected3="";
                 if(StringHelper.isEmpty(datastatus)||(datastatus!=null&&datastatus.equals("0"))){
                    selected1="selected";
                 }else if(datastatus!=null&&datastatus.equals("1"))
                 {
                  selected2="selected";
                 }else{
                     selected3="selected";
                 }
                 %>
                     <option value="0"<%=selected1%>><%=labelService.getLabelName("监控(正常)")%></option>
                    <option value="1"<%=selected2%>><%=labelService.getLabelName("监控(已删除)")%></option>
                    <option value="2"<%=selected3%>><%=labelService.getLabelName("监控(已删除)")%></option>

                 </select>
         </td>
         </tr>
     </table>
 <%}%>
 <!--页面菜单结束-->
     <form action="<%=action%>" id="EweaverForm" name="EweaverForm" method="post">
     <input type="hidden" name="sqlwhere" value="<%=sqlwhere%>"/>
     <input type="hidden" id="sqlstr1" name="sqlstr1"/>
     <input type="hidden" id="sqlstr2" name="sqlstr2"/>
 <!--条件>
 <%
 //隐藏初使查询条件
 String initsqlwhere = StringHelper.null2String(request.getAttribute("initsqlwhere"));
 String initquerystr = StringHelper.null2String(request.getAttribute("initquerystr"));
 String[] convalue = initquerystr.split("&");
 for(int i=0; i < convalue.length; i++){
     String tempcon = convalue[i];
     if(!StringHelper.isEmpty(tempcon)){
         String[] conv = tempcon.split("=");
         String con = conv[0];
         String vle = "";
         if(conv.length==2){
             vle = conv[1];
         }
         %>
         <input type='hidden' name="<%=con %>" value="<%=vle %>">
         <%
     }
 }
 %>
 <input type='hidden' name="sqlwhere" id="sqlwhere" value="<%=initsqlwhere %>">
 <input type='hidden' name="initquerystr" id="initquerystr" value="<%=initquerystr %>">

 <!--  ***************************************************************************************************************************-->
 <%
 //得到初使查询条件：

 Map hiddenMap = (Map)request.getAttribute("hiddenMap");
 String descorasc = StringHelper.null2String(request.getParameter("descorasc"));//表明前一次是升序还是降序？？
 if(descorasc.equals("desc")){
     descorasc = "asc";
 }else{
     descorasc = "desc";
 }
 String fieldopt = "";
 String fieldopt1 = "";
 String fieldvalue = "";
 String fieldvalue1 = "";

 ReportSearchfieldService reportsearchfieldService=(ReportSearchfieldService)BaseContext.getBean("reportSearchfieldService");

 List reportSearchfieldList = reportsearchfieldService.getReportsearchfieldByReportid2(reportid);
 List formfieldlist = new ArrayList();
 it = reportSearchfieldList.iterator();
      String checkfieldList="";
    StringBuffer directscript=new StringBuffer();
 while(it.hasNext()){

     Reportsearchfield reportsearchfield = (Reportsearchfield) it.next();
     String isfill=reportsearchfield.getIsfillin();
     String formfieldid = reportsearchfield.getFormfieldid();
     Formfield formfield = formfieldService.getFormfieldById(formfieldid);
     if(StringHelper.isEmpty(isfill)||isfill.equals("0"))
                 {
                    formfield.setFillin("0");
                 }
                 else
                 {
                    formfield.setFillin("1");
                 }
     formfieldlist.add(formfield);
 }

 String[] checkcons = request.getParameterValues("check_con");


  %>
 <%if(hiddenMap != null){
   for(Object o:hiddenMap.keySet()){
       String value=StringHelper.null2String(hiddenMap.get(o));
 %>
       <input type='hidden' name="<%=o.toString() %>" id="initquerystr" value="<%=value %>">
 <%
   }
 }%>
   <table id="myTable" style="width:100%" class=viewform>
     <%
	int tmpcount= 0;
	
	String isformbase2=StringHelper.null2String(reportdef.getIsformbase());
	String isshowversionquery=StringHelper.null2String(reportdef.getIsshowversionquery());
 	WorkflowVersionService workflowVersionService=(WorkflowVersionService)BaseContext.getBean("workflowVersionService");
	boolean isWorkflowVersionEnable=workflowVersionService.isWorkflowVersionEnable();
	
	if("2".equals(isformbase2)&&"1".equals(isshowversionquery)&&isWorkflowVersionEnable){
		tmpcount=1;
	%>
		<tr class=title >
			<td class="FieldName" width=10% nowrap>流程版本</td>
			<td class='FieldValue' width=15% >
			<select class="inputstyle2" style="width:90%" id="workflowversionid"  name="workflowversionid">
			    <option value=""  selected  ></option>
			    <%
			    WorkflowinfoService workflowinfoService=(WorkflowinfoService)BaseContext.getBean("workflowinfoService");
			    String hql="select a from Workflowinfo a,WorkflowVersion b where a.formid='"+formid+"' and a.isdelete=0 and a.id=b.workflowid order by b.groupid,b.version";
			    List<Workflowinfo> workflowinfos=workflowinfoService.getWorkflowinfos(hql);
			    if(workflowinfos!=null&&workflowinfos.size()>0){
			    	for(Workflowinfo workflowinfo:workflowinfos){
			    		WorkflowVersion workflowVersion=workflowVersionService.getWorkflowVersionByWorkflowid(workflowinfo.getId());
			    		if(workflowVersion!=null){
			    		%>
			    		<option value="<%=workflowVersion.getId()%>"  ><%=workflowinfo.getObjname()%></option>
			    		<%
			    		}
			    	}
			    }
			 	%>
			</select>
			</td>
	<%}
 int linecolor=0;

 boolean showsep = true;

 Iterator fieldit = formfieldlist.iterator();
Map _fieldcheckMap=new HashMap();
while(fieldit.hasNext()){
  Formfield formfield = (Formfield)fieldit.next();
  String _htmltype = StringHelper.null2String(formfield.getHtmltype());
  String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
  String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
  
//系统表Humres,Docbase下拉框联动字段验证保存的是字段名称，需要转换为ID。
  if("402881e80c33c761010c33c8594e0005".equals(formid) || "402881e50bff706e010bff7fd5640006".equals(formid)){
 	 Formfield _field = formfieldService.getFormfieldByName(formid, _fieldcheck);
 	 if(_field!=null){
 	 	_fieldcheck = _field.getId();
 	 }
  }

  String id = formfield.getId();
     if(fieldsearchMap != null){
         fieldopt = StringHelper.null2String(fieldsearchMap.get("con"+ id + "_opt"));
         fieldopt1 = StringHelper.null2String(fieldsearchMap.get("con"+ id + "_opt1"));
         fieldvalue = StringHelper.null2String(fieldsearchMap.get("con"+ id + "_value"));
         fieldvalue1 = StringHelper.null2String(fieldsearchMap.get("con"+ id + "_value1"));

     }
  if(!_fieldcheck.equals("")&&!fieldvalue.equals("")){
     _fieldcheckMap.put(_fieldcheck,fieldvalue);
  }
}
 Iterator fieldit1 = formfieldlist.iterator();
 while(fieldit1.hasNext()){
     String msg="";
     Formfield formfield = (Formfield)fieldit1.next();
     String id = formfield.getId();

     if(fieldsearchMap != null){
         fieldopt = StringHelper.null2String(fieldsearchMap.get("con"+ id + "_opt"));
         fieldopt1 = StringHelper.null2String(fieldsearchMap.get("con"+ id + "_opt1"));
         fieldvalue = StringHelper.null2String(fieldsearchMap.get("con"+ id + "_value"));
         fieldvalue1 = StringHelper.null2String(fieldsearchMap.get("con"+ id + "_value1"));

     }
         if(formfield.getFillin().equals("1"))
          {
              if(StringHelper.isEmpty(fieldvalue))
           msg="<img src=\"/images/base/checkinput.gif\" align=absMiddle>";
              else
              msg="";
          }

     if(tmpcount%3==0){
 %>
 <tr class=title >
     <%
     }
 String htmltype = String.valueOf(formfield.getHtmltype());
 String type = formfield.getFieldtype();

 String _fieldid = StringHelper.null2String(formfield.getId());
 String _formid = StringHelper.null2String(formfield.getFormid());
 String _fieldname = StringHelper.null2String(formfield.getFieldname());
 String _htmltype = StringHelper.null2String(formfield.getHtmltype());
 String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
 String _fieldattr = StringHelper.null2String(formfield.getFieldattr());
 String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
 String _style ="";
 String _value="";
     boolean combinefieldflag=false;
 String combineobjname="";
  if(id.equals("40288035249e012493f200077c7d3901")){
   List list=combinefieldService.getCombinefieldByReportid(reportid);
   if(list.size()>0){
    Combinefield combinefield=(Combinefield)list.get(0);
    if(!StringHelper.isEmpty(combinefield.getObjname())){
    combineobjname=combinefield.getObjname();
      combinefieldflag=true;
    }
   }
  }
 String htmlobjname = _fieldid;
 %>
     <td  class="FieldName" width=10% nowrap>
 <%
 String name = formfield.getFieldname();
 name = "d."+name;
 %>
 	 <% if(combinefieldflag){%>
     	<%=StringHelper.null2String(combineobjname)%>
     <% }else{ 
    	 Reportfield reportfield = reportfieldService.getReportfieldByFormFieldId(reportid, formfield.getId());
    	 String label;
    	 if(reportfield != null && reportfield.getId() != null){
    		 label = labelCustomService.getLabelNameByReportfieldForCurrentLanguage(reportfield);
    	 }else{
    		 label = labelCustomService.getLabelNameByFormFieldForCurrentLanguage(formfield);
    	 }
     %>
         <%=label%>
     <%}%>     <%
if(htmltype.equals("1")){
     if(type.equals("1")){//文本
     if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ id + "_value";
       else
       checkfieldList+=",con"+ id + "_value";
      }
 %>
     <td  class="FieldValue" width=15% nowrap>
       <input type=text class=inputstyle size=30 name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"<%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>/><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%> id="con<%=id%>_valuespan"><%=msg%></span>
     </td>
    <%
    }else if(type.equals("2")){//整数
      if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ id + "_value"+",con"+ id + "_value1";
       else
       checkfieldList+=",con"+ id + "_value"+",con"+ id + "_value1";
      }
 %>
     <td  class="FieldValue" width=15% nowrap>
       <input type=text class=inputstyle size=5 name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkInt_KeyPress()' <%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%> id="con<%=id%>_valuespan"><%=msg%></span>--<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050009")%>--<!-- 到 -->
       <input type=text class=inputstyle size=5 name="con<%=id%>_value1"   value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkInt_KeyPress()'<%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value1','con<%=id%>_valuespan')"<%}%> ><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%> id="con<%=id%>_valuespan"><%=msg%></span>
     </td>
     <%
    }
    else if(type.equals("3")){//浮点数

      if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ id + "_value"+",con"+ id + "_value1";
       else
       checkfieldList+=",con"+ id + "_value"+",con"+ id + "_value1";
      }

    %>
     <td  class="FieldValue" width=15% nowrap>
       <input type=text class=inputstyle size=5 name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkFloat_KeyPress()'<%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%> id="con<%=id%>_valuespan"><%=msg%></span>--<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050009")%>--<!-- 到 -->
       <input type=text class=inputstyle size=5 name="con<%=id%>_value1" value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkFloat_KeyPress()'<%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value1','con<%=id%>_valuespan')"<%}%> ><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%> id="con<%=id%>_valuespan"><%=msg%></span>
     </td>
     <%

    }
    else if(type.equals("4")||type.equals("6")){//日期
    	String fieldcheck = "";
    	fieldcheck = formfield.getFieldcheck();
        if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ id + "_value"+",con"+ id + "_value1";
       else
       checkfieldList+=",con"+ id + "_value"+",con"+ id + "_value1";
      }
    %>
             <td  class="FieldValue" width=15% nowrap>
                    <input type=text class=inputstyle size=10 name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onclick="WdatePicker(<%=fieldcheck %>)" <%if(formfield.getFillin().equals("1")){%>onchange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>>
                    <span id="con<%=id%>_valuespan" <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%>  ><%=msg%></span>-
                    <input type=text class=inputstyle size=10 name="con<%=id%>_value1"  value="<%=StringHelper.null2String(fieldvalue1)%>" onclick="WdatePicker(<%=fieldcheck %>)" <%if(formfield.getFillin().equals("1")){%>onchange="checkInput('con<%=id%>_value1','con<%=id%>_value1span')"<%}%>>
                    <span id="con<%=id%>_value1span" <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%> >
                        <%=msg%>
                    </span>
                 </td>

     <%
    }
    else if(type.equals("5")){//时间
    	String fieldcheck = "";
    	fieldcheck = formfield.getFieldcheck();
     if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ _fieldid + "_value";
       else
       checkfieldList+=",con"+ _fieldid + "_value";
      }
            StringBuffer sb = new StringBuffer("");
         sb.append("<td width=15% class='FieldValue' nowrap>");
         sb.append("<input type=\"text\" class=inputstyle size=10 name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\" onclick=\"WdatePicker("+fieldcheck+")\" ");

          if(formfield.getFillin().equals("1")){
         sb.append(" onchange=\"checkInput('con"+_fieldid+"_value','con"+_fieldid+"_valuespan')\"><span id=\"con"+_fieldid+"_valuespan\" name=\"con"+_fieldid+"_valuespan\" fillin=1 >");
         }else{
         sb.append("><span id=\"con"+_fieldid+"_valuespan\" name=\"con"+_fieldid+"_valuespan\"  >");
         }
         sb.append(msg);
         sb.append("</span></td>");
            out.print(sb.toString());
    }
      %>
 <%}
 else if(htmltype.equals("2")){//多行文本

 if(tmpcount%3==2){
 %>
     <td colspan=3  class="FieldValue" width=15% nowrap>
         <TEXTAREA style="width:200" ROWS="" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"<%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>  ><%=StringHelper.null2String(fieldvalue)%></TEXTAREA><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%>  id="con<%=id%>_valuespan"><%=msg%></span>
     </td>
  <%}else{%>
     <td colspan=3  class="FieldValue" width=15% nowrap>
       <TEXTAREA style="width:100%"  ROWS="" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"<%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%> ><%=StringHelper.null2String(fieldvalue)%></TEXTAREA><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%>  id="con<%=id%>_valuespan"><%=msg%></span>
     </td>
     <%}
 }
 else if(htmltype.equals("3")){//带格式文本


         //StringBuffer sb = new StringBuffer("");
         //sb.append("<td class='FieldValue'><input type=\"hidden\" name=\"field_"+_fieldid+"\"  value=\""+_value.replaceAll("\"","'")+"\" >");
         //sb.append("<IFRAME ID=\"eWebEditor"+_fieldid+"\" src=\"/plugin/ewe/ewebeditor.htm?id=field_"+_fieldid+"&style=eweaver\" frameborder=\"0\" scrolling=\"no\" "+_style+"></IFRAME></td>");
         //out.print(sb.toString());
 }

 else if(htmltype.equals("4")){//check框

   if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ id + "_value";
       else
       checkfieldList+=",con"+ id + "_value";
      }
 %>

     <td  class="FieldValue" width=15% nowrap>
             <INPUT TYPE="checkbox" NAME="con<%=id%>_value" value="1" <%if(StringHelper.null2String(fieldvalue).equals("1")){%> checked <%}%> <%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%> flag=0 onclick="gray(this)" ><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%>  id="con<%=id%>_valuespan"><%=msg%></span>
     </td>

     <%}

 else if(htmltype.equals("5")){//选择项
       if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ _fieldid + "_value";
       else
       checkfieldList+=",con"+ _fieldid + "_value";
      }
             List list ;
             if(_fieldcheckMap.get(_fieldid)!=null){
             list = selectitemService.getSelectitemList(type,StringHelper.null2String(_fieldcheckMap.get(_fieldid)));
             }
             else
             list = selectitemService.getSelectitemList(type,null);
             StringBuffer sb = new StringBuffer("");
             
           //系统表Humres,Docbase下拉框联动字段验证保存的是字段名称，需要转换为ID。
             if("402881e80c33c761010c33c8594e0005".equals(formid) || "402881e50bff706e010bff7fd5640006".equals(formid)){
            	 Formfield _field = formfieldService.getFormfieldByName(formid, _fieldcheck);
            	 if(_field!=null){
            	 	_fieldcheck = _field.getId();
            	 }
             }
           
             sb.append("<input type=\"hidden\" name=\"field_"
                             + _fieldid + "_fieldcheck\" value=\"" + _fieldcheck + "\" >");
               if(formfield.getFillin().equals("1"))
               {
             sb.append("<td width=15% class='FieldValue'>\n\r <select class=\"inputstyle2\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+" onchange=\"fillotherselect(this,'" + _fieldid
							+ "',"+ "-1" +"),checkInput('con"+_fieldid+"_value','con"+_fieldid+"_valuespan')\">");
			  }else{
			       sb.append("<td width=15% class='FieldValue'>\n\r <select class=\"inputstyle2\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+" onchange=\"fillotherselect(this,'" + _fieldid
							+ "',"+ "-1" +")\">");
			  }
             String _isempty = "";
             if(StringHelper.isEmpty(fieldvalue))
                 _isempty = " selected ";
             sb.append("\n\r<option value=\"\" "+_isempty +" ></option>");
             for(int i=0;i<list.size();i++){
                 Selectitem _selectitem = (Selectitem)list.get(i);
                 String _selectvalue = StringHelper.null2String(_selectitem.getId());
                 String _selectname = StringHelper.null2String(_selectitem.getObjname());
                 String selected = "";
                 if(_selectvalue.equalsIgnoreCase(StringHelper.null2String(fieldvalue)))
                     selected = " selected ";
                 sb.append("\n\r<option value=\""+_selectvalue+"\" "+selected +" >"+_selectname+"</option>");
             }
             	sb.append("</select> ");
             	if(formfield.getFillin().equals("1"))
        sb.append("<span id='con"+_fieldid+"_valuespan'fillin=1 >");
        else
           sb.append("<span id='con"+_fieldid+"_valuespan'>");
					if (formfield.getFillin().equals("1"))
					{
					      if(StringHelper.isEmpty(fieldvalue))
						sb.append("<img src=\"/images/base/checkinput.gif\" align=absMiddle>");
						else
						;

					}
					sb.append("</span>");
             sb.append("</td>");
             out.print(sb.toString());

 }
 else if(htmltype.equals("6")){ // 关联选择
       if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ _fieldid + "_value";
       else
       checkfieldList+=",con"+ _fieldid + "_value";
      }
             Refobj refobj = refobjService.getRefobj(type);
             if(refobj != null){
                 String _refid = StringHelper.null2String(refobj.getId());
                 String _refurl = StringHelper.null2String(refobj.getRefurl());
                 String _viewurl = StringHelper.null2String(refobj.getViewurl());
                 String _reftable = StringHelper.null2String(refobj.getReftable());
                 String _keyfield = StringHelper.null2String(refobj.getKeyfield());
                 String _viewfield = StringHelper.null2String(refobj.getViewfield());
                 int isdirect=NumberHelper.getIntegerValue(refobj.getIsdirectinput(),0).intValue();
                 String _selfield=StringHelper.null2String(refobj.getSelfield());
                 _selfield=StringHelper.getEncodeStr(_selfield);
                 int valCount = 0;
                 String showname = "";
                 String shortshowname = "";
                 if(!StringHelper.isEmpty(fieldvalue)){
                     String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(StringHelper.null2String(fieldvalue)) + ")";
                     List valuelist = dataService.getValues(sql);
                     valCount = valuelist.size();
                     Map tmprefmap = null;
                     String tmpobjname = "";
                     String tmpobjid = "";

                     for(int i=0;i<valuelist.size();i++){
                         tmprefmap = (Map)valuelist.get(i);
                         tmpobjid = StringHelper.null2String((String) tmprefmap.get("objid"));
                         try{
                             tmpobjname = StringHelper.null2String((String) tmprefmap.get("objname"));
                         }catch(Exception e){
                             tmpobjname= ((java.math.BigDecimal)tmprefmap.get("objname")).toString();
                         }

                         if(!StringHelper.isEmpty(_viewurl)){//以里面定义为主

                             showname += "&nbsp;&nbsp;<a href=\""+ _viewurl + tmpobjid +"\" target=\"_blank\" >";
                             showname += tmpobjname;
                             showname += "</a>";
                             if(valCount>10){
                            	 if(i<10){
                           			 shortshowname += "&nbsp;&nbsp;<a href=\""+ _viewurl + tmpobjid +"\" target=\"_blank\" >";
                           			 shortshowname += tmpobjname;
                           			 shortshowname += "</a>";
                            	 }
                             }

                         }else{
                             if(i==valuelist.size()-1){
                                 showname += tmpobjname;
                                 if(valCount>10){
                                	 if(i<10){
                               			 shortshowname += tmpobjname;
                                	 }
                                 }
                             }else{
                                 showname += tmpobjname + ", ";
                                 if(valCount>10){
                                	 if(i<10){
                               			 shortshowname  += tmpobjname + ", ";
                                	 }
                                 }
                             }
                         }
                     }
                 }


                 String checkboxstr = "";
                 if("orgunit".equals(_reftable)){

                     String checked = "";
                     if(fieldsearchMap!=null&&StringHelper.null2String(fieldsearchMap.get("con" + id + "_checkbox")).equals("1")){
                         checked = "checked";
                     }
					if(StringHelper.null2String(fieldvalue1).equals("1")){
						checked = "checked";
					}
                     checkboxstr = "<input  type=\"checkbox\" name=\"con" + _fieldid+ "_checkbox\" value=\"1\" "+ checked +">";
                 }
                 StringBuffer sb = new StringBuffer("");
                 sb.append("<td width=15% class='FieldValue'>");
                    if(isdirect==1)
                {
                  //加一个用于提示的文本框
                    if (!StringHelper.isEmpty(_selfield)) {
                	    _selfield = _selfield.replaceAll("\r\n"," ");
					}
                    sb.append("<input type=text class=\"InputStyle2\" name="+_fieldid+" id="+_fieldid+" onfocus=\"checkdirect(this)\">");
                    directscript.append(" $(\"#"+_fieldid+"\").autocomplete(\""+request.getContextPath()+"/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=getdemo&reftable="+_reftable+"&viewfield="+_viewfield+"&selfield="+_selfield+"&keyfield="+_keyfield+"\", {\n" +
                                         "\t\twidth: 260,\n" +
                                                    "        max:15,\n" +
                                                    "        matchCase:true,\n" +
                                                    "        scroll: true,\n" +
                                                    "        scrollHeight: 300,          \n" +
                                                    "        selectFirst: false});");


                                 directscript.append("\n" +
                                     "                             $(\"#"+_fieldid+"\").result(function(event, data, formatted) {\n" +
                                     "                                     if (data)\n" +
                                     "                                         document.getElementById('con"+_fieldid+"_value').value=data[1];\n" +
                                     "                                 });");

                }
                  sb.append("\n\r<button  class=Browser type=button onclick=\"javascript:getrefobj('con"+_fieldid+"_value','con"+_fieldid+"span','"+_refid+"','"+_viewurl+"','0');\"></button>");
                  if(isdirect==1)
                  {
                      sb.append("\n\r<input type=\"hidden\" id=\"con"+_fieldid+"_value\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
                  }
                  else
                  {
                 sb.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
                  }
                 if(formfield.getFillin().equals("1"))
                 sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" fillin=1>");
                 else
                 sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\">");
                 if(!StringHelper.isEmpty(showname)&&valCount>10){
	                 sb.append("<span style='display:none'  id='"+_fieldid+"_allspan'>"+showname+"<a style='color:#72B7F7' title='收缩' onclick=\"closeSpan('"+_fieldid+"')\">  【收缩】</a></span>");
	                 sb.append("<span id='"+_fieldid+"_simplespan'>"+shortshowname+"<a style='color:#72B7F7' title='更多' onclick=\"expandSpan('"+_fieldid+"')\">...更多("+valCount+")</a></span>");
                 }else{
                 	sb.append(showname);
                 }
                 sb.append(msg);
                 sb.append("</span>\n\r").append(checkboxstr).append("</td> ");

                 out.print(sb.toString());

             }
 }
 else if(htmltype.equals("7")){ //附件
    if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ _fieldid + "_value";
       else
       checkfieldList+=",con"+ _fieldid + "_value";
      }
             StringBuffer sb = new StringBuffer("");
             sb.append("<td> \n\r<input type=\"hidden\" name=\"field_"+_fieldid+"\" value=\""+_value+"\" >");
             if(!StringHelper.isEmpty(_value)){
                 Attach attach = attachService.getAttach(_value);
                 String attachname = StringHelper.null2String(attach.getObjname());
                 sb.append("\n\r<a href=\"javascript:if(top.frames[1])onUrl('" 
							+ request.getContextPath()+ "/ServiceAction/com.eweaver.document.file.FileDownload?attachid=" 
							+attach.getId()+"&download=1"+"','"
							+ StringHelper.null2String(attach.getObjname())
							+ "','tab" + attach.getId() + "')\" >).append("+attachname+"</a>");
             }
           sb.append("\n\r<input type=\"file\" class=\"inputstyle2\" name=\"con"+_fieldid+"file\" "+_style+" onchange=checkInput('con"+_fieldid+"file','con"+_fieldid+"span')>");
            if(formfield.getFillin().equals("1"))
           sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" fillin=1 >");
           else
             sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" >");
            if(formfield.getFillin().equals("1")&&!StringHelper.isEmpty(_value))
             sb.append(msg);
                  sb.append("</span>\n\r");
                    sb.append("\n\r</td> ");
             out.print(sb.toString());

 }

  if(linecolor==0) linecolor=1;
           else linecolor=0;

   if(htmltype.equals("2")){
     tmpcount += 2 ;
   }
   else{
     tmpcount += 1;
   }
 }%>
   </table>
        <div id="divObj" style="display:none">
            <table id="displayTable">
                <tr style="background-color:#f7f7f7;height:22">
                    <th align="left" width="160">
                         <b><span style="color:green"><%=labelService.getLabelName("请选择")%>:</span></b>
                         <select name="searchOperate" id="searchOperate" onchange="searchOperate()">
                             <option value="0"><%=labelService.getLabelName("新建模板")%></option>
                             <option value="1"><%=labelService.getLabelName("原有模板")%></option>
                         </select>
                    </th>
                    <th align="left" width="300">
                         <select name="mycontemplate" id="mycontemplate" style="width:150;display:none">
                             <option value="0"><%=labelService.getLabelName("请选择报表模板")%></option>
                             <%
                                 if(contemplateList!=null){
                                 Iterator iteratorObj=contemplateList.iterator();
                                 while(iteratorObj.hasNext()){
                                    Contemplate contemplate= (Contemplate) iteratorObj.next();
                                    if(contemplate.getUserid().trim().equals(eweaveruser.getId().trim())){
                             %>
                                 <option value="<%=contemplate.getId()%>" <%if(contemplate.getId().equals(contemplateid)){%>selected="selected"<%}%>><%=contemplate.getObjname()%>(<%if("False".equals(contemplate.getIspublic())){%><%=labelService.getLabelName("私人")%><%}else{%><%=labelService.getLabelName("公共")%><%}%>)</option>
                             <%
                                    }
                                 }
                                 }
                             %>
                         </select>
                    </th>
                </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr id="objnametr">
                        <td align="right"><%=labelService.getLabelName("模板名称")%></td>
                        <td align="center"><input type="text" size="30" maxlength="60" name="objname" id="objname" style="width:180px"></td>
                    </tr>
                    <tr id="publictr">
                        <td align="right"><%=labelService.getLabelName("模板类型")%></td>
                        <td align="center">
                            <select name="myPublic" id="myPublic" style="width:180px">
                                <option value="False"><%=labelService.getLabelName("私人模板")%></option>
                                 <%
                            		if("402881e70be6d209010be75668750014".equals(eweaveruser.getId())){
                            	 %>
                                <option value="True"><%=labelService.getLabelName("公共模板")%></option>
                                 <%}%>
                            </select>
                        </td>
                    </tr>
                    <tr id="objdesctr">
                        <td align="right"><%=labelService.getLabelName("排序")%></td>
                        <td align="center"><input type="text" size="30" maxlength="60" name="objdesc" id="objdesc" style="width:180px"></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                                    <button  type="button" accessKey="S" onclick="tosubmit()">
                                        <U>S</U>--<%=labelService.getLabelName("确定")%>
                                    </button>
                                    &nbsp;&nbsp;&nbsp;
                                    <button  type="button" accessKey="C" onclick="Cancel_onclick()">
                                        <U>C</U>--<%=labelService.getLabelName("取消")%>
                                    </button>
                        </td>
                    </tr>
            </table>
        </div>     
 </form>
 </div>
<!-- 条件结束-->

  <script type="text/javascript">
      var inputid;
      var spanid;
      var temp;
     function checkdirect(obj)
  {
      inputid=obj.id;
      spanid=obj.name;
      temp=0;
  }
      var $j = jQuery.noConflict();
      $j(document).ready(function($){
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
             document.getElementById('con'+spanid+'span').innerHTML= data.substring(len,length);
                   }else if(temp==0&&lenspance>0){

                 var data=field.value;

              document.getElementById(inputid).value=data;
             document.getElementById('con'+spanid+'span').innerHTML= data;

                   }else{
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
  <script language="javascript" type="text/javascript">
  function onSearchByTemplate(contemplateid){
        location.href="<%=action2%>&isformbase=<%=isformbase%>&contemplateid="+contemplateid;
   }
   function onSearch(pageno){
          document.EweaverForm.pageno.value=pageno;
       document.EweaverForm.submit();
   }
   function createexcel(){
          document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=createexcel&reportid=<%=reportid%>&exportflag=";
       document.EweaverForm.submit();
   }

   function onSearch2(){
       
      var o=$('#EweaverForm').serializeArray();
       var data={};
       for(var i=0;i<o.length;i++) {
           if(o[i].value!=null&&o[i].value!=""){
           data[o[i].name]=o[i].value;
           }
       }
       checkfields='<%=checkfieldList%>';//填写必须输入的input name，逗号分隔
    checkmessage="<%=labelService.getLabelName("必输项不能为空")%>";
    if(checkForm(EweaverForm,checkfields,checkmessage)){
       var temp=store.baseParams.isthread;
       store.baseParams=data;
       store.baseParams.isthread=temp;
       store.baseParams.datastatus='<%=datastatus%>';
         store.baseParams.isindagate='<%=isindagate%>';
       store.load({params:{start:0, limit:<%=pageSize%>}});
    }
       event.srcElement.disabled = false;
   }
       $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch2();
       }
   });
   function onSearch3(){
          document.all('EweaverForm').action="<%=request.getContextPath()%>/workflow/report/reportsearch.jsp?reportid=<%=reportid%>&sysmodel=<%=sysmodel%>";
       document.all('EweaverForm').submit();
   }
   function reset(){
         $('#EweaverForm span').text('');
         $('#EweaverForm input[type=text]').val('');
         $('#EweaverForm textarea').val('');
         $('#EweaverForm input[type=checkbox]').each(function(){
             this.checked=false;
         });
         $('#EweaverForm input[type=hidden]').each(function(){
             if(this.name.indexOf('con')==0)
             this.value='';
         });
         $('#EweaverForm select').val('');
         $('#EweaverForm span[fillin=1]').each(function(){
             this.innerHTML='<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
         });
   }
   //***********************模板切换后的页面动作(start)*************************//
   function onSearch4(reportid){
       var contemplateid=document.getElementById("contemplate").value;
       location.href="<%=action2%>&isformbase=1&contemplateid="+contemplateid;
   }
   //***********************模板切换后的页面动作(end)*************************//
     function delone(requestid)
     {
         var requestid = requestid;
         Ext.Msg.buttonText = {yes:'<%=labelService.getLabelName("是")%>',no:'<%=labelService.getLabelName("否")%>'};
         Ext.MessageBox.confirm('', '<%=labelService.getLabelName("您确定要彻底删除吗")%>?', function (btn, text) {
             if (btn == 'yes') {
                 Ext.Ajax.request({
                     url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=delone',
                     params:{requestid:requestid,reportid:'<%=reportid%>'},
                     success: function(res) {
                        if (res.responseText == 'noright')
                         {
                             Ext.Msg.buttonText = {ok:'<%=labelService.getLabelName("确定")%>'};
                             Ext.MessageBox.alert('', '<%=labelService.getLabelName("没有删除权限！,请选择操作项为X的内容")%>', function() {

                             });
                         } else {
                             var temp = store.baseParams.isthread;

                             store.baseParams = <%=(jsonStr==null?"{}":jsonStr)%>
                             store.baseParams.isthread = temp;
                             store.baseParams.anode = '';
                             store.baseParams.datastatus ='<%=isdatastatus%>';
                             store.baseParams.isindagate='<%=isindagate%>';
                             store.load({params:{start:0, limit:<%=pageSize%>}});

                         }


                     }
                 });
             } 
         });
     }
     function onDelete()
     {
         if (selected.length == 0) {
             Ext.Msg.buttonText = {ok:'<%=labelService.getLabelName("确定")%>'};
             Ext.MessageBox.alert('', '<%=labelService.getLabelName("请选择操作项为X的内容")%>！');
             return;
         }
         Ext.Msg.buttonText = {yes:'<%=labelService.getLabelName("是")%>',no:'<%=labelService.getLabelName("否")%>'};
         Ext.MessageBox.confirm('', '<%=labelService.getLabelName("您确定要删除吗")%>?', function (btn, text) {
             if (btn == 'yes') {
                 Ext.Ajax.request({
                     url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=delete',
                     params:{ids:selected.toString(),reportid:'<%=reportid%>',datastatus:'<%=isdatastatus%>'},
                     success: function(res) {
                         if (res.responseText == 'noright')
                         {
                             Ext.Msg.buttonText = {ok:'<%=labelService.getLabelName("确定")%>'};
                             Ext.MessageBox.alert('', '<%=labelService.getLabelName("没有删除权限！,请选择操作项为X的内容")%>', function() {

                             });
                         } else {
                             var temp = store.baseParams.isthread;

                             store.baseParams = <%=(jsonStr==null?"{}":jsonStr)%>
                             store.baseParams.isthread = temp;
                             store.baseParams.anode = '';
                             store.baseParams.datastatus ='<%=isdatastatus%>';
                              store.baseParams.isindagate='<%=isindagate%>';
                             store.load({params:{start:0, limit:<%=pageSize%>}});

                         }
                     }
                 });
             }
         });

     }
   function datasearch(value){
       var isdatastatus=value;
     location.href="<%=action2%>&isformbase=<%=reportdef.getIsformbase()%>&isdatastatus="+isdatastatus+"&datastatus="+value;
   }
   //点击按列排序
   function listorder(input){
          document.EweaverForm.action="<%=action2%>&orderfield=" + input + "&descorasc=<%=descorasc%>";
       document.EweaverForm.submit();
   }
   function fillotherselect(elementobj,fieldid,rowindex){
	var elementvalue = Trim(getValidStr(elementobj.value));//选择项的值


	var objname = "field_"+fieldid+"_fieldcheck";

	var fieldcheck = Trim(getValidStr(document.all(objname).value));//用于保存选择项子项的值(formfieldid)

	if(fieldcheck=="")
		return;

//	DataService.getValues(createList(fieldcheck,rowindex),"select id,objname from selectitem where pid = '"+elementvalue+"'");
	var sql ="<%=SQLMap.getSQLString("workflow/report/reportresultlistTree.jsp")%>";
	DataService.getValues(sql,{
      callback:function(dataFromServer) {
        createList(dataFromServer, fieldcheck,rowindex);
      }
   }
	);

}
    function createList(data,fieldcheck,rowindex)
	{
		var select_array =fieldcheck.split(",");
		for(loop=0;loop<select_array.length;loop++){
			var objname = "con"+select_array[loop]+"_value";
			if(rowindex != -1)
				objname += "_"+rowindex;

			if(document.all(objname) == null){
				return;
			}
            removeAllOptions(document.all(objname));
            addOptions(document.all(objname), data);
		    fillotherselect(document.all(objname),select_array[loop],rowindex);
		}
	}
   function removeAllOptions(obj) {
       var len = obj.options.length;
       for (var i = len; i >= 0; i--) {
           obj.options[i] = null
       }
   }

   function addOptions(obj, data) {

       var len = data.length;
       for (var i=0; i<len; i++) {

           if(data[i].id==null){
             data[i].id="";
           }
           obj.options.add(new Option(data[i].objname,data[i].id ));
       }
   }
   var win;
  function getrefobj(inputname,inputspan,refid,viewurl,isneed){
     /* if(inputname.substring(3,(inputname.length-6))){
            if(document.getElementById(inputname.substring(3,(inputname.length-6))))
     document.getElementById(inputname.substring(3,(inputname.length-6))).value="";
        }
        if(document.getElementById(inputname.replace("field","input"))!=null)
     document.getElementById(inputname.replace("field","input")).value="";*/
     // 先暂时把这段代码   给注释掉 因为此代码影响了 EWTS-000790 bug  by肖肖
	var idsin = document.getElementsByName(inputname)[0].value;
	var id;
    if(Ext.isIE){
    try{
         var url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
                url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid;
            }
    id=openDialog(url);
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
    }else{
    url='<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
    var callback = function() {
            try {
                id = dialog.getFrameWindow().dialogValue;
            } catch(e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    document.all(inputname).value = id[0];
                    document.all(inputspan).innerHTML = id[1];
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
                    defaultSrc:url,
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

    function searchOperate(){
        var searchOperate=document.getElementById("searchOperate");
        if(searchOperate.value=="0"){
            document.getElementById("objnametr").style.display="block";
            document.getElementById("publictr").style.display="block";
            document.getElementById("objdesctr").style.display="block";
            document.getElementById("mycontemplate").style.display="none";
        }else{
            document.getElementById("objnametr").style.display="none";
            document.getElementById("publictr").style.display="none";
            document.getElementById("objdesctr").style.display="none";
            document.getElementById("mycontemplate").style.display="block";
        }
    }
   function openchild(url)
  {
    this.dlg0.getComponent('dlgpanel').setSrc("<%=request.getContextPath()%>"+url);
    this.dlg0.show();
  }

    function tosubmit(){
	   if(document.getElementById('searchOperate').value ==1 && document.getElementById("mycontemplate").value == 0){
		   alert("请选择原有的报表模版！");
		   return;
	   }
       var str="&saveSearchToC=true&searchOperate="+document.getElementById("searchOperate").value
               +"&mycontemplate="+document.getElementById("mycontemplate").value
               +"&objname="+encodeURIComponent(document.getElementById("objname").value)
               +"&myPublic="+document.getElementById("myPublic").value
               +"&objdesc="+document.getElementById("objdesc").value;
       document.EweaverForm.action="<%=action2%>&pagesize=<%=pageSize%>&isformbase=<%=isformbase%>"+str; 
       document.EweaverForm.submit();
    }

    function Cancel_onclick(){
        var mychoose=document.getElementById("divObj");
        var mytable=document.getElementById("displayTable");
        var bgObj=document.getElementById("bgDiv");
        var msgObj=document.getElementById("msgDiv");
        var title=document.getElementById("msgTitle");
        mychoose.appendChild(mytable);
        document.body.removeChild(bgObj);
        document.getElementById("msgDiv").removeChild(title);
        document.body.removeChild(msgObj);
    }
   //*********************************模式对话框特效(start)*********************************//
    function sAlert(){
    var msgw,msgh,bordercolor;
    msgw=460;//提示窗口的宽度
    msgh=280;//提示窗口的高度
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
    var mychoose=document.getElementById("divObj");
    var mytable=document.getElementById("displayTable");
    mychoose.appendChild(mytable);
    document.body.removeChild(bgObj);
    document.getElementById("msgDiv").removeChild(title);
    document.body.removeChild(msgObj);
  }
  document.body.appendChild(msgObj);
  document.getElementById("msgDiv").appendChild(title);
  var mytable=document.getElementById("displayTable");
  document.getElementById("msgDiv").appendChild(mytable);
  }
//*********************************模式对话框特效(end)*********************************//
      function exportExcel(){

          document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?reportid=<%=reportid%>&action=reportExport&contemplateid=<%=contemplateid%>";
          document.forms[0].submit();
      }
     function gray(obj)
{
switch(obj.flag)
{
//当flag为0时,为未选中状态
case '0':obj.checked=true;obj.indeterminate=true;obj.flag='2';
      obj.value='2';
    break;
//当flag未1时,为白色选中状态
case '2':obj.checked=true;obj.indeterminate=false;obj.flag='1';
        obj.value='1';
    break;
//当flag为2时,为灰色选中状态  (找出所有的数据)
case '1':obj.checked=false;obj.indeterminate=false;obj.flag='0';
    obj.value='0';
    break;
}
}
    function showtemplate(){
      openchild('<%=tmpaction%>','<%=labelService.getLabelName("模板管理")%>');
	//document.EweaverForm.action="<%=tmpaction %>";
      //document.EweaverForm.target="";
   //document.EweaverForm.submit();
}
    function doAction(customid){
        if(selected.length==0){
            Ext.MessageBox.alert('','<%=labelService.getLabelName("请选择勾选CheckBox，如果列表前面没有CheckBox请在报表定义中设置")%>') ;
            return;
        }
        Ext.Ajax.request({
            url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormbaseAction?action=doaction',
            params:{
                requestid:selected.toString(),
                customid:customid
            },
            success: function(res) {
                if (res.responseText == 'noright')
                {
                    Ext.Msg.buttonText = {
                        ok:'<%=labelService.getLabelName("确定")%>'
                    };
                    Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0056")%>');//编辑权限的人才可以变更卡片数据！
                } else {
                    Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934c11ccb0134c11ccbb80000")%>', function() {//变更卡片数据成功！
                        document.location.reload();
                    });

                }
            }
        });
        
     /*   var temp = store.baseParams.isthread;
        selected=[];
        store.baseParams = <%=(jsonStr==null?"{}":jsonStr)%>
        store.baseParams.isthread = temp;
        store.baseParams.anode = '';
        store.baseParams.datastatus = '<%=isdatastatus%>';
        store.load({ params:{start:0,limit:<%=pageSize%>}});*/
    }
    
    //展开搜索条件中的span  
function expandSpan(id){
	var $ = jQuery;
	var span1 = $('#'+id+'_simplespan');
	var span2 = $('#'+id+'_allspan');
	span1.hide();
	span2.show();
}

//收缩搜索条件中的span
function closeSpan(id){
	var $ = jQuery;
	var span1 = $('#'+id+'_simplespan');
	var span2 = $('#'+id+'_allspan');
	span2.hide();
	span1.show();
}
   </script>
    <%=StringHelper.null2String(reportdef.getJscontent())%>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
  </body>
</html>