<%@ page contentType="text/html; charset=UTF-8"%>
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
<%@ page import="com.eweaver.workflow.report.model.*" %>
<%@ page import="com.eweaver.workflow.report.service.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%
String pageSizeStr= StringHelper.null2String(request.getParameter("pageSize"));
int pageSize=20;
if(pageSizeStr.length()>0)pageSize=Integer.valueOf(pageSizeStr);
int gridWidth=700;
int gridHeight=330;
String projectid= StringHelper.null2String(request.getParameter("projectid"));


String ishiddenC = request.getParameter("ishiddenC");//是否隐藏创建按钮
String ishiddenD = request.getParameter("ishiddenD");//是否隐藏删除按钮

if(ishiddenC == null)
ishiddenC="0";
if(ishiddenD == null)
ishiddenD="0";

String userid=currentuser.getId();//当前用户

String reportid = request.getParameter("reportid");
String isformbase = StringHelper.null2String(request.getParameter("isformbase"));
String sqlwhere= StringHelper.null2String(request.getParameter("sqlwhere"));
String showCheckbox= StringHelper.null2String(request.getParameter("showCheckbox"));
String isshow=StringHelper.null2String(request.getParameter("isshow")) ; //isshow=0表示默认不加载出数据
String contemplateid = StringHelper.null2String(request.getAttribute("contemplateid"));
Page pageObject = (Page) request.getAttribute("pageObject");
Map summap = (Map)request.getAttribute("sum");
String isnew=request.getParameter("isnew");
paravaluehm = (HashMap)request.getAttribute("paravaluehm");
if(paravaluehm==null){
	paravaluehm = new HashMap();
}
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
CombinefieldService combinefieldService = (CombinefieldService)BaseContext.getBean("combinefieldService");
ContemplateService contemplateService = (ContemplateService)BaseContext.getBean("contemplateService");
if(StringHelper.isEmpty(contemplateid)){
    List<Contemplate> contemplateList = contemplateService.getContemplateLists("from Contemplate where reportid='"+reportid+"' and userid='"+currentuser.getId()+"' and ispublic='False' and isdefault=1 order by objdesc");
    if(contemplateList.size()!=0){
        contemplateid = contemplateList.get(0).getId();
        contemplateList = contemplateService.getContemplateLists("from Contemplate where reportid='"+reportid+"' and ispublic='True' and isdefault=1 order by objdesc");
        if(contemplateList.size()!=0){
            contemplateid = contemplateList.get(0).getId();
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
            if(!StringHelper.isEmpty(value))
            jsonObject.put(key,value);
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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
<script type="text/javascript">
    Ext.LoadMask.prototype.msg='加载...';
     var sm;
    var store;
	var projectid='<%=projectid%>';
    var selected=new Array();
    var dlg0;
   var viewport=null;
    <%

String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&from=list&isnew="+isnew+"&reportid=" + reportid;
String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?&isnew="+isnew+"&action=search&reportid=" + reportid;
String tmpaction = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=searchtemplate&reportid="+reportid;
if(!StringHelper.isEmpty(sysmodel)){
	action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&isnew="+isnew+"&from=list&reportid=" + reportid;
	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&isnew="+isnew+"&reportid=" + reportid;
    tmpaction = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=searchtemplate&reportid="+reportid;
}else{
	//pagemenustr += "{C,"+ "生成EXCEL文件" +",javascript:createexcel()}";
}

if(isformbase!=null && !isformbase.equals("")){
    tmpaction +="&isformbase="+isformbase;
}
		String secformid = StringHelper.null2String(reportdef.getSecformid());	//子表表单id
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

            String fieldname="";
			if(!StringHelper.isEmpty(secformid)&&secformid.equals(formfields.getFormid())){	//是抽象表单,并且当前字段是子表字段
				Forminfo forminfosec = forminfoService.getForminfoById(secformid);
				fieldname = forminfosec.getObjtablename() + "_" + formfields.getFieldname();
			}else{
				fieldname = formfields.getFieldname();
			}
			if(StringHelper.isEmpty(fieldname)){
				fieldname=reportfield.getId();
			}
			//fieldname=labelService.getLabelName(fieldname);
         	String showname=labelService.getLabelName(reportfield.getShowname());
         	int sortable=NumberHelper.getIntegerValue(reportfield.getIsorderfield(),0);
         	if(!StringHelper.isEmpty(reportfield.getCol2())){
         	  fieldname=StringHelper.trim(reportfield.getShowname());
         	}
         	if(cmstr.equals(""))
         	{
         	 if(sortable==0)
            cmstr+="{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:false}";
            else
            cmstr+="{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            }
            else
            {
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

	var grid;
    Ext.onReady(function(){
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
    <%if(false&&showCheckbox.equals("true")){%>
      sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([sm,<%=cmstr%>]);
    <%}else{%>
    sm=new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
     sm=new Ext.grid.CheckboxSelectionModel();
           <% if((StringHelper.isEmpty(isdatastatus)||"0".equals(isdatastatus))&&isauth&&StringHelper.isEmpty(sysmodel)){
             showCheckbox="true";
           %>

        
       var cm = new Ext.grid.ColumnModel([sm,<%=cmstr%>,{header: "操作",sortable: false,  dataIndex: 'del'}]);
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
   // cm.defaultSortable = true;

                    var autorefresh=new Ext.ux.grid.AutoRefresher({ interval:'<%=reportdef.getDefaulttime()%>'})
                   grid = new Ext.grid.GridPanel({
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
                             forceFit:true,
                           <%}%>
                           enableRowBody:true,
                           sortAscText:'升序',
                           sortDescText:'降序',
                           columnsText:'列定义',
                           getRowClass : function(record, rowIndex, p, store){
                               return 'x-grid3-row-collapsed';
                           }
                       },
                       bbar: new Ext.PagingToolbar({
                           pageSize: <%=pageSize%>,
                           <%if(reportdef.getIsrefresh().intValue()==1){%>
                            plugins: autorefresh,
                           <%}%>
            store: store,
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
    store.baseParams=<%=(jsonStr==null?"{}":jsonStr)%>
    store.baseParams.datastatus='<%=datastatus%>';
	store.baseParams.isindagate='<%=isindagate%>'
    sm.on('rowselect',function(selMdl,rowIndex,rec ){
        var reqid=rec.get('requestid');
		searchLogs(reqid);
		if (typeof(reqid)=='undefined'||reqid.length<1){reqid=rec.get('id');}
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
		searchLogs('');
		if (typeof(reqid)=='undefined'||reqid.length<1){reqid=rec.get('id');}

        for(var i=0;i<selected.length;i++){
                    if(reqid ==selected[i]){
                        selected.remove(reqid)
						
                         return;
                     }
                 }

    });
     
    //Viewport
    //ie6 bug
	viewport = new Ext.Viewport({
        
        layout: 'border',
        items: [grid]
	});
        <%
        String allSql="";
        if(StringHelper.isEmpty(isshow)||!isshow.equals("0")){
        	if(StringHelper.null2String(reportdef.getIsformbase()).trim().equals("0")||StringHelper.null2String(reportdef.getIsformbase()).trim().equals("2")){
		  		out.println("store.baseParams.tabwhere = \""+allSql+"\"");
			}
			out.println("store.baseParams.sqlwhere=\""+sqlwhere+"\";");
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
});
function searchLogs(reqid){
	var pwin=self.parent;
	var doc=pwin.splitIframe1.document;
	var obj=doc.getElementById('ctman');
	if(obj){
		obj.value=reqid;
		PubUtil.fireEvent(obj,'onchange');
	}
}
</script>
</head>
<body style="margin:10px,10px,10px,0px;padding:0px">

 <!--页面菜单结束-->
     <form action="<%=action%>" id="EweaverForm" name="EweaverForm" method="post">
     <input type="hidden" name="sqlwhere" value="<%=sqlwhere%>"/>
     <input type="hidden" id="sqlstr1" name="sqlstr1"/>
     <input type="hidden" id="sqlstr2" name="sqlstr2"/>
 <!--  ***************************************************************************************************************************-->
 </div>
<!-- 条件结束-->


  

    <%=StringHelper.null2String(reportdef.getJscontent())%> 

<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
  </body>
</html>