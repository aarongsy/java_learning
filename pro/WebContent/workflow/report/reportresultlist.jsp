<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.workflow.version.service.WorkflowVersionService"%>
<%@page import="com.eweaver.workflow.version.model.WorkflowVersion"%>
<%@page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
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
<%@page import="com.eweaver.workflow.request.service.FormService"%>
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
<%@ page import="com.eweaver.workflow.report.model.*" %>
<%@ page import="com.eweaver.workflow.report.service.*" %>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%
int pageSize=20;
if(StringHelper.null2String(request.getParameter("pageSize")).trim().length()>0)
	pageSize=Integer.parseInt(StringHelper.null2String(request.getParameter("pageSize")));

int gridWidth=700;
int gridHeight=330;
String reportid = request.getParameter("reportid");
String isformbase = StringHelper.null2String(request.getParameter("isformbase"));
String sqlwhere= StringHelper.null2String(request.getParameter("sqlwhere"));
String showCheckbox= StringHelper.null2String(request.getParameter("showCheckbox"));
String isshow=StringHelper.null2String(request.getParameter("isshow")) ; //isshow=0表示默认不加载出数据
String docCategoryid = StringHelper.null2String(request.getParameter("docCategoryid"));
String contemplateid = StringHelper.null2String(request.getAttribute("contemplateid"));
Page pageObject = (Page) request.getAttribute("pageObject");
Map summap = (Map)request.getAttribute("sum");
String isnew=request.getParameter("isnew");
paravaluehm = (HashMap)request.getAttribute("paravaluehm");
if(paravaluehm==null){
	paravaluehm = new HashMap();
}
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
FormService formService = (FormService) BaseContext.getBean("formService");
ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
ReportSearchfieldService reportsearchfieldService=(ReportSearchfieldService)BaseContext.getBean("reportSearchfieldService");
List reportGradeSearchfieldList = reportsearchfieldService.getReportsearchfieldByReportid(reportid);
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
CombinefieldService combinefieldService = (CombinefieldService)BaseContext.getBean("combinefieldService");
ContemplateService contemplateService = (ContemplateService)BaseContext.getBean("contemplateService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
DataService dataService = new DataService();
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
 Reportdef reportdef=reportdefService.getReportdef(reportid);
 String datastatus=StringHelper.null2String(request.getParameter("datastatus"));
 String isdatastatus=StringHelper.null2String(request.getParameter("isdatastatus"));
 String isindagate=StringHelper.null2String(request.getParameter("isindagate"));
if(reportfieldList.size()==0){
	reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
}
 String sysmodel = request.getParameter("sysmodel");
String formid=reportdefService.getReportdef(reportid).getFormid();
Forminfo forminfo=forminfoService.getForminfoById(formid);
int rows=0;
int cols=0;
List reportdatalist = new ArrayList();//用于保存转换后的查询数据

String jsonStr=null;
Map fieldsearchMap = (Map)request.getAttribute("fieldsearchMap");
if(fieldsearchMap != null){
        JSONObject jsonObject=new JSONObject();
        Set keySet=fieldsearchMap.keySet();
        for(Object key:keySet){
            String value=(String)fieldsearchMap.get(key);
            if(!StringHelper.isEmpty(value)){
            	value = value.replace("$2B$","+");
	            jsonObject.put(key,value);
            }
        }
        if(!"".equals(sqlwhere.trim())){
        jsonObject.put("sqlwhere",sqlwhere);
        }
        jsonStr=jsonObject.toString();
    }
    boolean isauth = (forminfo.getObjtype()==4)?false:permissiondetailService.checkOpttype(reportid,6);
%>
<%@ include file="/humres/base/openhrm.jsp"%>
<html>
<head>
<style type="text/css">
    .x-toolbar table {width:0}
      a { color:blue; cursor:pointer; }
    #pagemenubar table {width:0}
    /*TD{*/
        /*width:16%;*/
    /*}*/
     .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
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
<script src='<%=request.getContextPath()%>/dwr/interface/FormbaseService.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
<style type="text/css">
	a:visited{ color:blue} 
</style>
<script type="text/javascript">

//多选Checkbox函数
function onClickMutiBox(box, fieldid) {
	var field = document.getElementById('con' + fieldid+'_value');
	if (box.checked) {
		if (field.value) {
			field.value = field.value + ',' + box.value;
		} else {
			field.value = box.value;
		}
	} else {
		var tempValue = field.value + ',';
		tempValue = tempValue.replace(box.value + ',','');
		field.value = tempValue.substring(0,tempValue.length-1);
	}
}

    Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
     var sm;
    var store;
    var selected=new Array();
    var selectedid=new Array();
    var dlg0;
   var viewport=null;
    <%

String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&from=list&isnew="+isnew+"&reportid=" + reportid;
String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?&isnew="+isnew+"&action=search&reportid=" + reportid;
String tmpaction = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=searchtemplate&reportid="+reportid;
if(!StringHelper.isEmpty(sysmodel)){
	action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&isnew="+isnew+"&from=list&reportid=" + reportid;
	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&isnew="+isnew+"&reportid=" + reportid +"&docCategoryid=" +docCategoryid;
    tmpaction = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=searchtemplate&reportid="+reportid;
}else{
	//pagemenustr += "{C,"+ "生成EXCEL文件" +",javascript:createexcel()}";
}

if(isformbase!=null && !isformbase.equals("")){
    tmpaction +="&isformbase="+isformbase;
}
        String cmstr="";
        String fieldstr="";
        Iterator it = reportfieldList.iterator();
        cols = reportfieldList.size();
        if(forminfo.getObjtype()!=4)fieldstr+="'requestid','id'";//非虚拟表单才添加requestid字段
        Map reporttitleMap = new HashMap();
       int k=0;
		while(it.hasNext()){
			Reportfield reportfield = (Reportfield) it.next();
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
         	String showname = labelCustomService.getLabelNameByReportfieldForCurrentLanguage(reportfield);
         	if(showname.indexOf("'")>-1){
         		showname = showname.replaceAll("'","\\\\'");
         	}
         	int sortable=NumberHelper.getIntegerValue(reportfield.getIsorderfield(),0);
         	if(!StringHelper.isEmpty(reportfield.getCol2())){
         	  fieldname=StringHelper.trim(reportfield.getShowname());
         	}
         	String secformid = StringHelper.null2String(reportdef.getSecformid());
         	if(forminfo.getObjtype() == 1 && secformid.equals(formfields.getFormid())){	//是抽象表的子表字段
         		Forminfo forminfosec = forminfoService.getForminfoById(secformid);
         		fieldname = forminfosec.getObjtablename() + "_" + fieldname;
         	}
         	String renderer="";
         	if(StringHelper.null2String(reportfield.getCol3()).equals("1"))
         	{
         		renderer=",renderer:labelTip";
         	}
         	if(cmstr.equals(""))
         	{
         	 if(sortable==0)
            cmstr+="{header:'"+showname+"',dataIndex:'"+fieldname+"'"+renderer+",width:"+showwidth*gridWidth/100+",sortable:false}";
            else
            cmstr+="{header:'"+showname+"',dataIndex:'"+fieldname+"'"+renderer+",width:"+showwidth*gridWidth/100+",sortable:true}";
            }
            else
            {
            if(sortable==0)
            cmstr+=",{header:'"+showname+"',dataIndex:'"+fieldname+"'"+renderer+",width:"+showwidth*gridWidth/100+",sortable:false}";
            else
            cmstr+=",{header:'"+showname+"',dataIndex:'"+fieldname+"'"+renderer+",width:"+showwidth*gridWidth/100+",sortable:true}";
            }
            if(fieldstr.equals(""))
            fieldstr+="'"+fieldname+"'";
            else
            fieldstr+=",'"+fieldname+"'";
      	k++;
      }
      	reportdatalist.add(reporttitleMap);//生成excel报表时用到

      %>
      	
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

    <!--页面菜单开始-->
<%
paravaluehm.put("{id}",reportid);
//pagemenustr +="addBtn(tb,'"+labelService.getLabelName("快捷搜索")+"','S','zoom',function(){onSearch2()});";
pagemenustr+=" tb.add(querybtn);";
pagemenustr +="addBtn(tb,'"+labelService.getLabelName("清空条件2")+"','R','erase',function(){reset()});";
if(reportGradeSearchfieldList.size()>0)
	pagemenustr +="addBtn(tb,'"+labelService.getLabelName("高级搜索")+"','G','zoom',function(){onSearch3()});";
if(reportdef.getIsexpexcel().intValue()==1){
pagemenustr +="addBtn(tb,'"+labelService.getLabelName("导出excel")+"','E','page_excel',function(){exportExcel()});";

}
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
//pagemenustr += "addBtn(tb,'"+labelService.getLabelName("查看模板")+"','M','page_copy',function(){showtemplate()});";
if(isSysAdmin)
{
	pagemenustr +="tb.add('->');";
	pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220035")+"','T','page_white_gear',function(){toSet('"+reportid+"','report')});";//报表设置
	%>
	function toSet(soureid,souretype)
	{
		var url='/base/toSet.jsp?soureid='+soureid+'&souretype='+souretype
		onUrl(url,'<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001b")%>',soureid);//设置
	}
	<%
}
%>
var grid;
    window.onload=function(){
    <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
        tb.add('->');
        tb.add(pagemenutable);
        <%if(isauth&&StringHelper.isEmpty(sysmodel)){%>
        tb.add(datatable);
        <%}%>
       <%}%>
    store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: '<%=action2+"&isjson=1&pagesize="+pageSize+"&isformbase="+isformbase%>'
        }),
        reader: new Ext.data.JsonReader({
            sql1:'sql1',
            sql2:'sql2',
            root: 'result',
            totalProperty: 'totalCount',
            <% if((StringHelper.isEmpty(isdatastatus)||"0".equals(isdatastatus))&&isauth&&StringHelper.isEmpty(sysmodel)){%>
            fields: [<%=fieldstr%>,'del']
            <%}else{%>
             fields: [<%=fieldstr%>]
            <%}%>
        }),
        remoteSort: true
    });
    //store.setDefaultSort('id', 'desc');
    <%if(showCheckbox.equals("true")){%>
      sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([sm,<%=cmstr%>]);
    <%}else{%>
    sm=new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
     sm=new Ext.grid.CheckboxSelectionModel();
           <% if((StringHelper.isEmpty(isdatastatus)||"0".equals(isdatastatus))&&isauth&&StringHelper.isEmpty(sysmodel)){
             showCheckbox="true";
           %>

        
       var cm = new Ext.grid.ColumnModel([sm,<%=cmstr%>,{header: "<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e")%>",sortable: false,  dataIndex: 'del'}]);
        <%}else if((StringHelper.isEmpty(isdatastatus)||"1".equals(isdatastatus))&&isauth&&StringHelper.isEmpty(sysmodel)){
            showCheckbox="true";
           %>
         
       var cm = new Ext.grid.ColumnModel([sm,<%=cmstr%>]);
      <%}else if(reportdef.getIsbatchupdate().intValue()==1){    //出现checkbox
             showCheckbox="true";
      %>
      
    var cm = new Ext.grid.ColumnModel([sm,<%=cmstr%>]);
     <%}else {%>
          var cm = new Ext.grid.ColumnModel([<%=cmstr%>]);
        <%}%>
    <%}%>
    
    resizeExtGridColumnWidth(cm);
   
    // cm.defaultSortable = true;
                    var autorefresh=new Ext.ux.grid.AutoRefresher({ interval:'<%=reportdef.getDefaulttime()%>'})
                   grid = new Ext.grid.GridPanel({
                	   <%if(currentSysModeIsWebsite){	//网站模式%>
                			//autoHeight: true,
                	   <%}%>
                	   autoScroll:true,
                       region: 'center',
                       store: store,
                       cm: cm,
                       trackMouseOver:false,
                       sm:sm ,
                       loadMask: true,
                       viewConfig: {
                           <%if(reportfieldList.size()>10){%>
                           forceFit:false,
                           <%}else{%>
                             forceFit: isResizeExtGridColumn() ? false : true,
                           <%}%>
                           enableRowBody:true,
                           sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                           sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                           columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                           getRowClass : function(record, rowIndex, p, store){
                               return 'x-grid3-row-collapsed';
                           }
                           <%if(currentSysModeIsWebsite){	//网站模式%>
                           ,onLayout : function(vw, vh){
                        	   resizeMainPageBodyHeight();
                           }
                           <%}%>
                            //-------------给报表grid添加左右滚动条start-----------
                           ,scrollOffset: -3 //去掉右侧空白区域  
						   /*,layout : function() {
							  var obj = this; 	
							  //此处延迟执行是因为在grid layout的时候会出现一次列宽极大值的现象，导致计算列宽总和不准确，给根据列宽动态增加滚动条带来了影响。
							  //延迟执行可避免这种情况发生
							  setTimeout(function(){	
                        	 	if (!obj.mainBody) {
					       			return; // not rendered
								}
								var g = obj.grid;
								var c = g.getGridEl();
								var csize = c.getSize(true);
								var vw = csize.width;
								var vh=csize.height;
								if (!g.hideHeaders && (vw < 20 || csize.height < 20)) { // display:
								 return;
								}
								//计算列的宽度总和
								var colTotalWidth = 0;
								var clModel = g.getColumnModel();
								for(var i = 0; i < clModel.getColumnCount(); i++){
								 colTotalWidth = colTotalWidth + clModel.getColumnWidth(i);
								}
								if(colTotalWidth > 0){
									colTotalWidth = colTotalWidth - 5;
								}
								obj.el.dom.style.width = "100%";
								if(colTotalWidth > obj.el.dom.clientWidth){	//当列的宽度总和大于表格可视宽度时，才添加横向滚动条
					      			if (g.autoHeight) {
										//计算grid高度
										var girdcount = store.getCount();
										var gridHeight=0;
										for(var i=0;i<girdcount;i++){
										    gridHeight=gridHeight+grid.getView().getRow(i).clientHeight;
										}
										obj.el.dom.style.height =gridHeight+50;//75是菜单栏和分页栏高度和
										obj.el.dom.style.overflowX = "auto"; //只显示横向滚动条
									}else{
										obj.el.dom.style.height = g.getInnerHeight();
										obj.el.dom.style.overflowX = "auto"; //只显示横向滚动条
									}
								}
								if (obj.forceFit) {
									if (obj.lastViewWidth != vw) {
										obj.fitColumns(false, false);
										obj.lastViewWidth = vw;
									}
								} else {
									obj.autoExpand();
									obj.syncHeaderScroll();
								}
                             }, 1000);
					      
					       }*/
                           
                          //-------------给报表grid添加左右滚动条end-----------
                       },
                       bbar: new Ext.PagingToolbar({
                           pageSize: <%=pageSize%>,
                           <%if(reportdef.getIsrefresh().intValue()==1){%>
                            plugins: autorefresh,
                           <%}%>
            store: store,
            displayInfo: true,
            beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
            afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
            firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
            prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
            nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
            lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示    条记录
            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
        })
    });
        <%if(reportdef.getIsrefresh().intValue()==1){%>
    store.on('beforeload',function(){
        autorefresh.start();
    });
        <%}%>
    store.baseParams=<%=(jsonStr==null?"{}":jsonStr)%>
     store.baseParams.datastatus='<%=datastatus%>';
   store.baseParams.isindagate='<%=isindagate%>'
    <%if(showCheckbox.equals("true")){%>
    store.on('load',function(st,recs){
        Ext.getDom('sqlstr1').value=st.reader.jsonData.sql1;
        Ext.getDom('sqlstr2').value=st.reader.jsonData.sql2;
        for(var i=0;i<recs.length;i++){
            var reqid=recs[i].get('requestid');
			if (typeof(reqid)=='undefined'){reqid=recs[i].get('ID');}
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
        var selid=rec.get('id');
        selectedid.push(selid);
        if (typeof(reqid)=='undefined'){reqid=rec.get('ID');}
        for(var i=0;i<selected.length;i++){
                    if(reqid ==selected[i]){
                         return;
                     }
                 }
        selected.push(reqid);
    }
            );
    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        var reqid=rec.get('requestid');
        var selid=rec.get('id');
        selectedid.remove(selid);
        if (typeof(reqid)=='undefined'){reqid=rec.get('ID');}
        for(var i=0;i<selected.length;i++){
                    if(reqid ==selected[i]){
                        selected.remove(reqid);
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
	//-------------给报表grid添加左右滚动条start-----------
	grid.getView().mainBody.dom.style.width = grid.getView().getTotalWidth();
	//-------------给报表grid添加左右滚动条end-------------
	<%
	String allSql=" and exists (select   rb.id from requestbase rb  where rb.isdelete=0)";
	if(StringHelper.isEmpty(isshow)||!isshow.equals("0")){ 
		if(StringHelper.null2String(reportdef.getIsformbase()).trim().equals("0")||StringHelper.null2String(reportdef.getIsformbase()).trim().equals("2")){
		%>
		  //out.println("store.baseParams.tabwhere = ' "+allSql+"'");
		  store.baseParams.tabwhere = "<%=allSql%>";
		  <%
		}
		out.println("store.load({params:{start:0, limit:"+pageSize+"}})");
	}%>
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
};

</script>
</head>
<body style="margin:10px,10px,10px,0px;padding:0px">


<div id="divSearch" style="display:none;">
 <div id="pagemenubar"></div>
  <!--页面菜单结束-->
  <%String language=StringHelper.isEmpty(eweaveruser.getSysuser().getLanguage())?"zh_CN":StringHelper.null2String(eweaveruser.getSysuser().getLanguage());
  %>
<table <%if(language.equals("zh_CN")){ %> style="width:300px" <%}else{ %> style="width:360px" <%} %> id="pagemenutable" border="0">
         <tr>
             <td align="right">
                 <%-- <a href="javascript:showtemplate();"><fmt:message key="wf.report.setTemplate"/></a>&nbsp;
                 <select id="contemplate" onchange="onSearch4('<%=reportid%>')" style="width:90">
                     <option value="0"><fmt:message key="wf.report.setTemplate.noTemplate"/></option>
                     <%
                         List contemplateList= (List) request.getAttribute("contemplateList");
                         if(contemplateList!=null){
                         Iterator itObj=contemplateList.iterator();
                         while(itObj.hasNext()){
                            Contemplate contemplate= (Contemplate) itObj.next();
                     %>
                         <option value="<%=contemplate.getId()%>" <%if(contemplate.getId().equals(contemplateid)){%>selected="selected"<%}%>><%=contemplate.getObjname()%>(<%if("False".equals(contemplate.getIspublic())){%><fmt:message key="wf.report.private"/><%}else{%><fmt:message key="wf.report.public"/><%}%>)</option>
                     <%
                         }
                         }
                     %>
                 </select>--%>
                 	<% if(StringHelper.null2String(reportdef.getIsformbase()).trim().equals("0")||StringHelper.null2String(reportdef.getIsformbase()).trim().equals("2")){
		
						String daishenSql = " and exists (select   rb.id from requestbase rb, requestoperators wo,requeststatus wi where rb.id = wo.requestid and wi.curstepid=wo.stepid "+
							"and (wi.isreceived=0 or wi.issubmited=0) and  wo.userid='"+eweaveruser.getId()+"' and (wi.ispaused=0 and wo.operatetype!=1 and rb.isfinished=0 or wo.operatetype>1 "+
							"and wo.issubmit!=1) and rb.isdelete=0 and rb.id="+forminfo.getObjtablename()+".requestid)";
						String yishenSql = " and exists (select rb.id  from requestbase rb where  rb.isdelete<>1   and rb.id  in (select wl.requestid from requestlog wl where "+
							"wl.logtype in('402881e50c5b4646010c5b5afd17000b','402881e50c5b4646010c5b5afd17000a') and  wl.operator = '"+eweaveruser.getId()+"') "+
							"and rb.isfinished = 0 and rb.isdelete = 0  and rb.id="+forminfo.getObjtablename()+".requestid)";
						String banjieSql = " and exists (select rb.id from requestbase rb where  rb.isdelete<>1   and rb.id  in (select wl.requestid from requestlog wl where "+
							"  wl.operator = '"+eweaveruser.getId()+"') and "+
							"rb.isfinished = 1 and rb.isdelete = 0  and rb.id="+forminfo.getObjtablename()+".requestid)";
						
						%>
						<div class="titleSignQuery" style="height:auto;">
						<table style="width:100%">
							<tr><td>
							<ul class="tab" target="#tabC_QB">
							<li class="now"  tabwhere="<%=allSql %> "><a href="javascript:void(0)"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72432b110066")%></a></li><!-- 全部 -->
							<li tabwhere="<%=daishenSql %>"><a href="javascript:void(0)"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220036")%></a></li><!-- 待审 -->
							<li tabwhere="<%=yishenSql %>"><a href="javascript:void(0)"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220037")%></a></li><!-- 已审 -->
							<li tabwhere=" and exists(select id from requestbase where id=<%=forminfo.getObjtablename()%>.requestid and isdelete=0 and creater = '<%=currentuser.getId()%>' )"><a href="javascript:void(0)"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220038")%></a></li><!-- 我发起的 -->
							<li tabwhere="<%=banjieSql %>"><a href="javascript:void(0)"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f006b")%></a></li><!-- 办结 -->
							</ul>
							</td></tr>
						</table>
						</div>
						<%} %>
						<input type=hidden name="tabwhere" id="tabwhere" value="">
						<input type=hidden name="currentuserid" id="currentuserid" value="<%=currentuser.getId()%>">
             </td>
         </tr>
     </table>
 <%if(isauth&&StringHelper.isEmpty(sysmodel)){%>
 <table  id="datatable" style="display:none">
         <tr>
         <td  >
             <%=labelService.getLabelName("数据状态")%>&nbsp;&nbsp;<select class="inputstyle" id="datastatus" name="datastatus" onchange="datasearch(this.options[this.options.selectedIndex].value)">
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
                     <option value="2"<%=selected3%>><%=labelService.getLabelName("不监控")%></option>
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
       String value=(String)hiddenMap.get(o);
 %>
       <input type='hidden' name="<%=o.toString() %>" id="initquerystr" value="<%=value %>">
 <%
   }
 }%>
	<table id="myTable" class=viewform>
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
  if("402881e80c33c761010c33c8594e0005".equals(forminfo.getId()) || "402881e50bff706e010bff7fd5640006".equals(forminfo.getId())){
 	 Formfield _field = formfieldService.getFormfieldByName(formid, _fieldcheck);
 	 if(_field!=null){
 	 	_fieldcheck = _field.getId();
 	 }
  }
  String id = formfield.getId();
     if(fieldsearchMap != null){
         fieldopt = (String)fieldsearchMap.get("con"+ id + "_opt");
         fieldopt1 = (String)fieldsearchMap.get("con"+ id + "_opt1");
         fieldvalue = (String)fieldsearchMap.get("con"+ id + "_value");
         fieldvalue1 = (String)fieldsearchMap.get("con"+ id + "_value1");

     }
  if(!_fieldcheck.equals("")&&fieldvalue!=null&&!fieldvalue.equals("")){
     _fieldcheckMap.put(_fieldcheck,fieldvalue); 
  }
}
 Iterator fieldit1 = formfieldlist.iterator();
 
 
 while(fieldit1.hasNext()){
       String msg="";
     Formfield formfield = (Formfield)fieldit1.next();

     String id = formfield.getId();
     if(fieldsearchMap != null){
         fieldopt = (String)fieldsearchMap.get("con"+ id + "_opt");
         fieldopt1 = (String)fieldsearchMap.get("con"+ id + "_opt1");
         fieldvalue = (String)fieldsearchMap.get("con"+ id + "_value");
         fieldvalue1 = (String)fieldsearchMap.get("con"+ id + "_value1");

     }
     if(formfield.getFillin().equals("1"))
         {
             if(StringHelper.isEmpty(fieldvalue))
               msg="<img src=\""+request.getContextPath()+"/images/base/checkinput.gif\" align=absMiddle>";
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
 String htmlobjname = _fieldid;
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
     <%}%>
     
 	</td>
     <%
 if(htmltype.equals("1")){
	 if(!StringHelper.isEmpty(fieldvalue)){
		 fieldvalue=fieldvalue.replace("$2B$","+");
	 }
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
       <input type=text class=inputstyle style="width:90%" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"<%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>/><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%>  id="con<%=id%>_valuespan"><%=msg%></span>
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
       <input type=text class=inputstyle style="width:40%" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkInt_KeyPress()' <%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%>  id="con<%=id%>_valuespan"><%=msg%></span>--<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050009")%>--<!-- 到 -->
       <input type=text class=inputstyle style="width:40%" name="con<%=id%>_value1"   value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkInt_KeyPress()'<%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value1','con<%=id%>_valuespan')"<%}%> ><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%>  id="con<%=id%>_valuespan"><%=msg%></span>
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
       <input type=text class=inputstyle style="width:40%" name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkFloat_KeyPress()'<%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%>  id="con<%=id%>_valuespan"><%=msg%></span>--<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050009")%>--<!-- 到 -->
       <input type=text class=inputstyle style="width:40%" name="con<%=id%>_value1" value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkFloat_KeyPress()'<%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value1','con<%=id%>_valuespan')"<%}%> ><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%>  id="con<%=id%>_valuespan"><%=msg%></span>
     </td>
     <%

    }
    else if(type.equals("4")||type.equals("6")){//日期
    	String fieldcheck = "";
    	//if(type.equals("6")){
    		fieldcheck = formfield.getFieldcheck();
    	//}
    		if(StringHelper.null2String(fieldcheck).indexOf("minDate")>0||StringHelper.null2String(fieldcheck).indexOf("maxDate")>0){
        		fieldcheck = "";
        	}
     if(formfield.getFillin().equals("1")){
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ id + "_value"+",con"+ id + "_value1";
       else
       checkfieldList+=",con"+ id + "_value"+",con"+ id + "_value1";
      }
    %>
             <td  class="FieldValue" width=15% nowrap>
                    <input type=text class=inputstyle style="width:40%" name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onclick="WdatePicker(<%=fieldcheck %>)" <%if(formfield.getFillin().equals("1")){%>onchange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>>
                    <span id="con<%=id%>_valuespan" <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%>  ><%=msg%></span>-
                    <input type=text class=inputstyle style="width:40%" name="con<%=id%>_value1"  value="<%=StringHelper.null2String(fieldvalue1)%>" onclick="WdatePicker(<%=fieldcheck %>)" <%if(formfield.getFillin().equals("1")){%>onchange="checkInput('con<%=id%>_value1','con<%=id%>_value1span')"<%}%>>
                    <span id="con<%=id%>_value1span" <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%> >
                        <%=msg%>
                    </span>

                 </td>

     <%
    }
    else if(type.equals("5")){//时间
    	String fieldcheck = "";
    	fieldcheck = formfield.getFieldcheck();
    	if(StringHelper.isEmpty(fieldcheck)){
    		fieldcheck ="{startDate:'%H:00:00',dateFmt:'H:mm:ss'}";
    	}
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
         <TEXTAREA style="width:90%" ROWS="" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"<%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>  ><%=StringHelper.null2String(fieldvalue)%></TEXTAREA><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%> id="con<%=id%>_valuespan"><%=msg%></span>
     </td>
  <%}else{%>
     <td colspan=3  class="FieldValue" width=15% nowrap>
       <TEXTAREA style="width:90%"  ROWS="" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"<%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%> ><%=StringHelper.null2String(fieldvalue)%></TEXTAREA><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%> id="con<%=id%>_valuespan"><%=msg%></span>
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
             <INPUT TYPE="checkbox" NAME="con<%=id%>_value"  <%if(StringHelper.null2String(fieldvalue).equals("1")){%> checked  value="1" <%}%> <%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>  flag=0  onclick="gray(this)" ><span <%if(formfield.getFillin().equals("1")){%>fillin="1"<%}%> id="con<%=id%>_valuespan"><%=msg%></span>
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
             list = selectitemService.getSelectitemList(type,(String)_fieldcheckMap.get(_fieldid));
             }
             else
             list = selectitemService.getSelectitemList(type,null);
             StringBuffer sb = new StringBuffer("");
             
             //系统表Humres,Docbase下拉框联动字段验证保存的是字段名称，需要转换为ID。
             if("402881e80c33c761010c33c8594e0005".equals(forminfo.getId()) || "402881e50bff706e010bff7fd5640006".equals(forminfo.getId())){
            	 Formfield _field = formfieldService.getFormfieldByName(formid, _fieldcheck);
            	 if(_field!=null){
            	 	_fieldcheck = _field.getId();
            	 }
             }
             
             sb.append("<input type=\"hidden\" name=\"field_"
                             + _fieldid + "_fieldcheck\" value=\"" + _fieldcheck + "\" >");
              if(formfield.getFillin().equals("1"))
              {
             sb.append("<td width=15% class='FieldValue'>\n\r <select class=\"inputstyle2\" style=\"width:90%\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+" onchange=\"fillotherselect(this,'" + _fieldid
							+ "',"+ "-1" +"),checkInput('con"+_fieldid+"_value','con"+_fieldid+"_valuespan')\">");
				}else{
				  sb.append("<td width=15% class='FieldValue'>\n\r <select class=\"inputstyle2\" style=\"width:90%\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+" onchange=\"fillotherselect(this,'" + _fieldid
							+ "',"+ "-1" +")\">");
				}
             String _isempty = "";
             if(StringHelper.isEmpty(fieldvalue))
                 _isempty = " selected ";
             sb.append("\n\r<option value=\"\" "+_isempty +" ></option>");
             for(int i=0;i<list.size();i++){
                 Selectitem _selectitem = (Selectitem)list.get(i);
                 String _selectvalue = StringHelper.null2String(_selectitem.getId());
                 String _selectname = labelCustomService.getLabelNameBySelectitemForCurrentLanguage(_selectitem);
                 String selected = "";
                 if(_selectvalue.equalsIgnoreCase(StringHelper.null2String(fieldvalue)))
                     selected = " selected ";
                 sb.append("\n\r<option value=\""+_selectvalue+"\" "+selected +" >"+_selectname+"</option>");
             }
             	sb.append("</select> ");
             	if(formfield.getFillin().equals("1"))
        sb.append("<span id='con"+_fieldid+"_valuespan' fillin=1>");
        else
          sb.append("<span id='con"+_fieldid+"_valuespan'>");
					if (formfield.getFillin().equals("1"))
					{
					  if(StringHelper.isEmpty(fieldvalue))
						sb.append("<img src=\""+request.getContextPath()+"/images/base/checkinput.gif\" align=absMiddle>");
						else
						;
				    }
					sb.append("</span>");
             sb.append("</td>");
             out.print(sb.toString());

 }
 else if(htmltype.equals("6")){ // 关联选择
 	 String sapflag = "";
	 if(!StringHelper.isEmpty(formfield.getSapconfig())){
		 sapflag = "sapflag=1";
	 }
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
                 String showname = "";
                 String shortshowname = "";
                 int valCount = 0;
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
                    if(!StringHelper.isEmpty(sysmodel)&&sysmodel.equals("1")&&formfield.getFieldname().equalsIgnoreCase("orgids"))
                    ;
                    else{
                     String checked = "";
                     if(fieldsearchMap!=null&&StringHelper.null2String(fieldsearchMap.get("con" + id + "_checkbox")).equals("1")){
                         checked = "checked";
                     }
					if(StringHelper.null2String(fieldvalue1).equals("1")){
						checked = "checked";
					}
                     checkboxstr = "<input  type=\"checkbox\" name=\"con" + _fieldid+ "_checkbox\" value=\"1\" "+ checked +">";
                     }
                 }
                 StringBuffer sb = new StringBuffer("");
                 sb.append("<td width=15% class='FieldValue'> ");
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

String fieldCheck = formService.parserRefParam(new HashMap(), formfield.getFieldcheck());
fieldCheck = StringHelper.replaceString(fieldCheck, "'", "%27");

                 sb.append("\n\r<button  "+sapflag+"  class=Browser type=button onclick=\"getrefobj('con"+_fieldid+"_value','con"+_fieldid+"span','"+_refid+"','"+fieldCheck+"','"+_viewurl+"','0');\"></button>");
                  if(isdirect==1)
                 sb.append("\n\r<input type=\"hidden\" id=\"con"+_fieldid+"_value\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
                 else
                  sb.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
                 if(formfield.getFillin().equals("1"))
                 sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" fillin=1 >");
                 else
                 sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" >");
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
                 sb.append("\n\r<a href=\""+request.getContextPath()+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+_value+"\">"+attachname+"</a>");
             }
           sb.append("\n\r<input type=\"file\" class=\"inputstyle2\" name=\"con"+_fieldid+"file\" "+_style+" onchange=checkInput('con"+_fieldid+"file','con"+_fieldid+"span')>");
            if(formfield.getFillin().equals("1"))
           sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" fillin=1>");
           else
            sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\">");
            if(formfield.getFillin().equals("1"))
            {

             sb.append(msg);

             }
             sb.append("</span>\n\r");
                    sb.append("\n\r</td> ");
             out.print(sb.toString());

 }
 else if(htmltype.equals("8")){//checkbox（多选）
	 if(formfield.getFillin().equals("1"))
     {
      if(checkfieldList.equals(""))
      checkfieldList+="con"+ _fieldid + "_value";
      else
      checkfieldList+=",con"+ _fieldid + "_value";
     }
	 StringBuffer sb = new StringBuffer("");
	 sb.append("<td class=\"FieldValue\" width=15% nowrap> \n\r<input type=\"hidden\" id=\"con"+_fieldid+"_value\" name=\"con"+_fieldid+"_value\" value=\"");
	 if(fieldvalue!=null){
		 sb.append(fieldvalue);
	 }
	 sb.append("\" >");
	 String sql = "select id,objname from selectitem where isdelete=0 and typeid=(select fieldtype from formfield where id='"+_fieldid+"')";
	 List list = dataService.getValues(sql);
	 Iterator boxit= list.iterator();
	 while(boxit.hasNext()){
		 Map map = (Map)boxit.next();
		 String boxid = (String)map.get("id");
		 String boxname = (String)map.get("objname");
		 sb.append("<input type='checkbox' ");
		 if(fieldvalue!=null&&fieldvalue.indexOf(boxid)!=-1){
			 sb.append(" checked=\"checked\" ");
		 }
		 sb.append(" name='"+boxid+"' id='"+boxid+"' value='"+boxid+"' onclick=javascript:onClickMutiBox(this,'"+_fieldid+"') ><label style='padding:0 10 0 2;'>"+boxname+"</label>");
	 }
	 sb.append("</td>");
	 out.print(sb.toString()); 
 } 

  if(linecolor==0) linecolor=1;
           else linecolor=0;

     tmpcount += 1;
 }%>
   </table>
        <div id="divObj" style="display:none">
            <table id="displayTable">
                <tr style="background-color:#f7f7f7;height:22">
                    <th align="left" width="160">
                         <b><span style="color:green"><%=labelService.getLabelName("请选择")%>:</span></b><!--  -->
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
   function onSearch(pageno){
          document.EweaverForm.pageno.value=pageno;
       document.EweaverForm.submit();
   }
   function createexcel(){
          document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=createexcel&reportid=<%=reportid%>&exportflag=";
       document.EweaverForm.submit();
   }

   function onSearch2(){
   		selected=[];
        var o=$('#EweaverForm').serializeArray();
       var data={};
       for(var i=0;i<o.length;i++) {
           if(o[i].value!=null&&o[i].value!=""){
           data[o[i].name]=o[i].value;
           }
       }
     checkfields='<%=checkfieldList%>';//填写必须输入的input name，逗号分隔
    checkmessage="<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220039")%>";//必输项不能为空
    if(checkForm(EweaverForm,checkfields,checkmessage)){
		var tabwhere='';
    	if(document.getElementById('tabwhere')){
    		tabwhere=document.getElementById('tabwhere').value;
    	}
	   	store.baseParams=data;
        store.baseParams.datastatus='<%=datastatus%>';
        store.baseParams.isindagate='<%=isindagate%>'
        store.load({params:{start:0, limit:<%=pageSize%>,tabwhere:tabwhere}});
	  }
       event.srcElement.disabled = false;
   }
   $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch2(); 
       }
   });

   function onSearch3(){
          document.all('EweaverForm').action="<%=request.getContextPath()%>/workflow/report/reportsearch.jsp?reportid=<%=reportid%>&sysmodel=<%=sysmodel%>&docCategoryid=<%=docCategoryid%>";
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
         resetSelect();
   }

   function resetSelect(){//重置select项，报表清空条件时，前一级select未选择，后一级select的options为空
	   var selectArray = document.EweaverForm.getElementsByTagName('select');
       DWREngine.setAsync(false);
       for(var i=0;i<selectArray.length;i++){
           var selectObj = selectArray[i];
           var reg = /^con.{32}_value$/;
			if(reg.test(selectObj.id)){
				var fieldId = selectObj.id.substring(3,35);
				var sql = "select fieldtype from formfield where id='"+fieldId+"'";
				DataService.getValue(sql,{                                               
						callback: function(data){ 
			              if(data){
				              //该select为根select
			              } else{
			            	  removeAllOptions(selectObj);
			            	  selectObj.options.add(new Option("","" ));
			              }
			        }                 
			     });
			}
       }
       DWREngine.setAsync(true);
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

	//var sql ="<%=SQLMap.getSQLString("workflow/report/reportresultlist.jsp")%>";
	var sql = "select * from (select '' id,' ' objname,0 dsporder from selectitem union select s.id,s.objname,s.dsporder from selectitem s where pid = '"+elementvalue+"') t order by dsporder";
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
  
   function delone(requestid)
   {
       var requestid=requestid

        Ext.Msg.buttonText={yes:'<%=labelService.getLabelName("是")%>',no:'<%=labelService.getLabelName("否")%>'};
     Ext.MessageBox.confirm('', '<%=labelService.getLabelName("您确定要彻底删除吗")%>?', function (btn, text) {
             if (btn == 'yes') {
                 Ext.Ajax.request({
                     url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=delete',
                     params:{ids:requestid,reportid:'<%=reportid%>',datastatus:'<%=isdatastatus%>'},
                     success: function(res) {
                        if(res.responseText == 'noright')
                         {
                              Ext.Msg.buttonText={ok:'<%=labelService.getLabelName("确定")%>'};
                           Ext.MessageBox.alert('', '<%=labelService.getLabelName("没有删除权限")%>！',function(){

                            }) ;
                         }else{
                         selected = [];
                         selectedid=[];
                          store.baseParams=<%=(jsonStr==null?"{}":jsonStr)%>
                          store.baseParams.isindagate='<%=isindagate%>'
                         store.baseParams.datastatus='<%=isdatastatus%>';
                         store.load({params:{start:0, limit:<%=pageSize%>}});
                         }
                     }
                 });
             } 
         });
   }
   
     function onDelete(){
         if (selectedid.length == 0) {
             Ext.Msg.buttonText={ok:'<%=labelService.getLabelName("确定")%>'};
             Ext.MessageBox.alert('', '<%=labelService.getLabelName("请选择要删除的记录")%>！');
             return;
         }
        
         Ext.Msg.buttonText={yes:'<%=labelService.getLabelName("是")%>',no:'<%=labelService.getLabelName("否")%>'};
         Ext.MessageBox.confirm('', '<%=labelService.getLabelName("您确定要删除吗")%>?', function (btn, text) {
	     	if (btn =='yes') {
		         Ext.Ajax.request({
		             url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=delete',
		             params:{ids:selectedid.toString(),reportid:'<%=reportid%>',datastatus:'<%=isdatastatus%>'},
		             success: function(res) {
		                 if(res.responseText == 'noright'){
		                 	Ext.Msg.buttonText={ok:'<%=labelService.getLabelName("确定")%>'};
		                 	Ext.MessageBox.alert('', '<%=labelService.getLabelName("没有删除权限！请选择要删除的记录")%>',function(){}) ;
		                 }else{
		                 	selected = [];
		                 	selectedid=[];
		                  	store.baseParams=<%=(jsonStr==null?"{}":jsonStr)%>
		                 	store.baseParams.datastatus='<%=isdatastatus%>';
		                	store.baseParams.isindagate='<%=isindagate%>'
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
   //***********************模板切换后的页面动作(start)*************************//
   function onSearch4(reportid){
       var contemplateid=document.getElementById("contemplate").value;
          location.href="<%=action2%>&isformbase=<%=isformbase%>&contemplateid="+contemplateid;
   }
   function onSearchByTemplate(contemplateid){
        location.href="<%=action2%>&isformbase=<%=isformbase%>&contemplateid="+contemplateid;
   }
   //***********************模板切换后的页面动作(end)*************************//
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
 title.innerHTML="<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d")%>";//关闭
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
{    var img = $(Ext.getDom(obj));
	var b = false;
	 if(Ext.getDom(obj).tagName=='IMG'){
		obj = $(Ext.getDom(obj)).next().get(0);
		b = true;
	 }
	var  box = $(Ext.getDom(obj));
	var flag =box.attr("flag");
	if(!Ext.isSafari){
		switch(flag){
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
	}else{//safari不支持三态checkbox、indeterminate属性不能改变外观 
		if(!box.data("hasImg")){//jQuery数据缓存
			box.data("hasImg",1);
			box.before("<img src='/images/base/checkbox_0.jpg' onclick='gray(this)'   />");
		}
		switch(flag){
			//当flag为0时,为未选中状态
			case '0':obj.checked=true;obj.indeterminate=true;obj.flag='2';
			      obj.value='2';
			      $(box.parent().get(0).children[0]).show();
			      box.hide();
			    break;
			//当flag未1时,为白色选中状态
			case '2':obj.checked=true;obj.indeterminate=false;obj.flag='1';
			        obj.value='1';
			        box.show();
			        if(b){
				        img.hide();
			        }
			    break;
			//当flag为2时,为灰色选中状态  (找出所有的数据)
			case '1':obj.checked=false;obj.indeterminate=false;obj.flag='0';
			    obj.value='0';
			    break;
		}

	}
}
  function showtemplate(){
     openchild('<%=tmpaction%>','<%=labelService.getLabelName("模板管理")%>');
	//document.EweaverForm.action="<%=tmpaction %>";
      //document.EweaverForm.target="";
   //document.EweaverForm.submit();
}
  function doAction(customid){
        if(selectedid.length==0){
            Ext.MessageBox.alert('','<%=labelService.getLabelName("请选择勾选CheckBox，如果列表前面没有CheckBox请在报表定义中设置")%>') ;
            return;
        }
        Ext.Ajax.request({
                     url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormbaseAction?action=doaction',
                     params:{requestid:selectedid.toString(),customid:customid},
                     success: function(res) {
                         if(res.responseText == 'noright')
                         {
                              Ext.Msg.buttonText={ok:'<%=labelService.getLabelName("确定")%>'};
                           Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0056")%>') ;//编辑权限的人才可以变更卡片数据！
                         }else{
                              Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934c11ccb0134c11ccbb80000")%>',function(){//变更卡片数据成功！
                                   document.location.reload();
                             });

                         }
                     }
                 });

    }
      $(function(){
		$('.tab').each(function(i){
			$(this).children('li:not([class="div"])').each(function(j){
				$(this).data('index',j);		
			});
		});
		$('.tab li:not([class="div"])').click(function(){
			//alert($(this).data('index'));
			if($(this).is('.now')) return false;
			
			var t = $(this).parent().attr('target');
			if(t){
				var tabC = 	$(t).children('.cont');
			}
			else {
				var tabC = 	$(this).parent().next('.tabC').children('.cont');
			}
			var i = $(this).data('index');
			$(this).addClass('now').siblings().removeClass('now');
			tabC.hide().eq(i).show();
			var tabwhere = this.getAttribute('tabwhere');
			document.getElementById('tabwhere').value=tabwhere;
			store.baseParams.tabwhere=tabwhere;
			
			store.reload();		
		});

		$('a,input:radio').focus(function(){
			this.blur();						 
		});
	});	
function reloadGrid(){
	store.reload();
}
function labelTip(val)
{
	if (val.indexOf("title")<0) {
        return "<label title='" + val + "'>" + val + "</label>";
	} else {
		return val;
	}
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