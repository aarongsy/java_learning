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
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportSearchfieldService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit" %>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="com.eweaver.workflow.report.service.CombinefieldService" %>
<%@ page import="com.eweaver.workflow.report.model.Combinefield" %>

<%
int pageSize=20;
int gridWidth=700;
int gridHeight=330;
String reportid = request.getParameter("reportid");
 String isshow=StringHelper.null2String(request.getParameter("isshow"));
 String showfield = StringHelper.null2String(request.getParameter("showfield"),"objname");
 if(StringHelper.isEmpty(showfield)){
 	showfield = "objname";
 }
String isformbase = StringHelper.null2String(request.getParameter("isformbase"));
String sqlwhere= StringHelper.null2String(request.getParameter("sqlwhere"));
String showCheckbox= StringHelper.null2String(request.getParameter("showCheckbox"));
String activeTab= StringHelper.null2String(request.getParameter("activeTab"));
if(activeTab.length()<1){
	activeTab="0";
}
Page pageObject = (Page) request.getAttribute("pageObject");
Map summap = (Map)request.getAttribute("sum");
paravaluehm = (HashMap)request.getAttribute("paravaluehm");
if(paravaluehm==null){
	paravaluehm = new HashMap();
}
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
    CombinefieldService combinefieldService = (CombinefieldService)BaseContext.getBean("combinefieldService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
List reportfieldList = reportfieldService.getReportfieldListForUser(reportid,eweaveruser.getId());
if(reportfieldList.size()==0){
	reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
}
int rows=0;
int cols=0;
List reportdatalist = new ArrayList();//用于保存转换后的查询数据

String jsonStr=null;
Map fieldsearchMap = (Map)request.getAttribute("fieldsearchMap");
if(fieldsearchMap != null){
        JSONObject jsonObject=new JSONObject();
        String orgInputName="con402881821197b641011197b644690015_value";
        if(sqlwhere.indexOf("h.col1 like")<=0 && 
        	(!fieldsearchMap.containsKey(orgInputName) || 
        		StringHelper.isEmpty(StringHelper.null2String(fieldsearchMap.get(orgInputName)))
        	)){
	        fieldsearchMap.put(orgInputName,eweaveruser.getOrgid());
        }
        
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
%>

<%
String orgunitid=StringHelper.null2String(request.getParameter("orgunitid"));
String suborg = StringHelper.null2String(request.getParameter("suborg"));
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
String from = (String)request.getAttribute("from");
List results = (List)request.getAttribute("list");
String reftype = StringHelper.trimToNull(request.getParameter("reftype"));
if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";
List<Orgunit> ous=orgunitService.find("from Orgunit where isRoot=1");
String rootid="";
String roots="";
JSONArray ja=new JSONArray();
for(Orgunit ou:ous){
    JSONObject jo=new JSONObject();
    jo.put("id",ou.getId());
    jo.put("reftype",ou.getReftype());
    jo.put("name",ou.getObjname());
    if(ou.getReftype().equals(reftype))
        rootid=ou.getId();
    ja.add(jo);
}
roots=ja.toString();


if(StringHelper.isEmpty(rootid)){
	rootid = "402881e70ad1d990010ad1e5ec930008";
}
Orgunit orgunit = orgunitService.getOrgunit(rootid);
%>

<!--页面菜单开始-->
<%

paravaluehm.put("{reportid}",reportid);
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch2()});";

PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
pagemenustr += _pagemenuService2.getPagemenuStrExt(reportid,paravaluehm).get(0);
if(pagemenuorder.equals("0")) {
	pagemenustr =_pagemenuService2.getPagemenuStrExt(theuri,paravaluehm).get(0) + pagemenustr;
}else{
	pagemenustr = pagemenustr + _pagemenuService2.getPagemenuStrExt(theuri,paravaluehm).get(0);
}
String returnmenustr =  "addBtn(tb1,'"+labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")+"','C','erase',function(){onClear()});";//清除
returnmenustr += "addBtn(tb1,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";
%>
<html>
<head>
<style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
</style>

  <script language="javascript">
function changestype(val,cond){
if(eval(cond)){
document.all(val).style.background="red";
}
}
</script>
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>


<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/pPageSize.js"></script>
<script type="text/javascript">
	var showfield = '<%=showfield%>';
    Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';
    var store;
    var reftype='<%=reftype%>';
    var selected=new Array();
    <%
        String sysmodel = request.getParameter("sysmodel");
String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&from=list&reportid=" + reportid+"&isbrowser=1"; //其中isbrowser参数表示在browser框中没有（显示用户是否在线、最后一次登陆系统时间）功能
String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=" + reportid+"&isbrowser=1";
if(!StringHelper.isEmpty(sysmodel)){
	action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&from=list&reportid=" + reportid+"&isbrowser=1";
	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&reportid=" + reportid+"&isbrowser=1";
}else{
	//pagemenustr += "{C,"+ "生成EXCEL文件" +",javascript:createexcel()}";
}
        String cmstr="";
        String fieldstr="";
        Iterator it = reportfieldList.iterator();
        cols = reportfieldList.size();
        fieldstr+="'id'";
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
         	String showname=labelService.getLabelName(reportfield.getShowname());
         	int sortable=NumberHelper.getIntegerValue(reportfield.getIsorderfield(),0);
         	if(cmstr.equals(""))
            cmstr+="{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            else
            cmstr+=",{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            if(fieldstr.equals(""))
            fieldstr+="'"+fieldname+"'";
            else
            fieldstr+=",'"+fieldname+"'";
      	k++;
      }
      	reportdatalist.add(reporttitleMap);//生成excel报表时用到

      %>
    var rootsArray=<%=roots%>;
    var orgTree ;
    Ext.onReady(function(){
    <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>
		tb.add('-');
        <%=returnmenustr.replaceAll("tb1","tb")%>
        <%}%>    
	orgtb=new Ext.Toolbar();
    orgTree = new Ext.tree.TreePanel({
            animate:true,
            title: '<%=labelService.getLabelNameByKeyId("402881e70ad1d990010ad1da10900004")%>',//组织单元
            useArrows :true,
            //containerScroll: true,
            autoScroll:true,
            tbar:orgtb, 
            //lines:true,
            collapsed : false,
            rootVisible:false,
            root:new Ext.tree.AsyncTreeNode({
                text: 'org',
                id:'r00t',
                expanded:true,
                allowDrag:false,
                allowDrop:false,
                children:[new Ext.tree.AsyncTreeNode({
                text: '<a onclick=onSearch2(true)><%=orgunit.getObjname()%></a>',
                expanded:true,
                id: 'Orgunit_<%=rootid%>',
                allowDrag:false,
                allowDrop:false
            })]
            }),
            loader:new Ext.tree.TreeLoader({
                dataUrl: "/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunitTreeAction?action=getChildrenExt&type=browser",
                preloadChildren:false,
                listeners:{"beforeload":function(treeLoader, node) {
                    orgTree.getLoader().baseParams.reftype = reftype;
                },"load":function(treeLoader, node) {
                   var o = Ext.getDom(orgTree.body);
				   //o.style.height = screen.height * 0.7 * 0.3 - 55;
                }}
            }
            ),
            listeners:{
                'expand':function(p){ p.getRootNode().expand();
                }
            }

        });
		grouptb=new Ext.Toolbar();
    var groupTree = new Ext.tree.TreePanel({
            animate:true,
            title: '<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050001")%>',//组
            useArrows :true,
            autoScroll:true,
            containerScroll: true,
            collapsed : false,
            rootVisible:false,
			tbar:grouptb,
            root:new Ext.tree.AsyncTreeNode({
                text: 'group',
                allowDrag:false,
                allowDrop:false,
                expanded:true,//公共组/私有组
                children:[{text:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050002")%>',id:'1',expanded:true},{text:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050003")%>',id:'2',expanded:true}]
            }),
            loader:new Ext.tree.TreeLoader({
                dataUrl: '/ServiceAction/com.eweaver.base.security.servlet.SysGroupAction?action=getChildrenExt',
                preloadChildren:true
            }),
            listeners:{
                'expand':function(p){ p.getRootNode().expand();
                }
            }
        });
    
    var tabPanel = new Ext.TabPanel({
            region:'north',
            deferredRender:false,
            enableTabScroll:false,
            autoScroll:false,
            height:screen.height*0.7*0.3,
            activeTab:<%=activeTab%>,
            split:true,
            items:[orgTree,groupTree,
                new Ext.Panel(
                {
                  title:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da140077")%>',//自定义
                  autoScroll:true,
                  contentEl:divSearch
                }
                )
            ]
        });

    store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: '<%=action2+"&isjson=1&pagesize="+pageSize+"&isformbase="+isformbase%>'
        }),
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalCount',
            fields: [<%=fieldstr%>]
        }),
        remoteSort: true
    });
    //store.setDefaultSort('id', 'desc');

    var sm=new Ext.grid.RowSelectionModel();
    var cm = new Ext.grid.ColumnModel([<%=cmstr%>]);

    cm.defaultSortable = true;

                   var grid = new Ext.grid.GridPanel({
                       region: 'center',
                       store: store,
                       cm: cm,
                       trackMouseOver:false,
                       sm:sm ,
                       loadMask: true,
                       enableColumnMove:false,
                       viewConfig: {
                           forceFit:false,
                           enableRowBody:true,
                           sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                           sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                           columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                           getRowClass : function(record, rowIndex, p, store){
                               return 'x-grid3-row-collapsed';
                           }
                       },
                       bbar: new Ext.PagingToolbar({
                           pageSize: <%=pageSize%>,
                           plugins:[new Ext.ux.Andrie.pPageSize({beforeText:'PageSize',afterText:'',variations:[20,100,200,250]})],
            store: store,
            displayInfo: true,
            beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
            afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
            firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
            prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
            nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
            lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
            refreshText:"<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc8893c0027")%>",//刷新
            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示/条记录 
            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
        })
    });

    /*store.on('beforeload',function(){
        alert(selected.length);
    });*/
    store.baseParams=<%=(jsonStr==null?"{}":jsonStr)%>
<% if(StringHelper.isEmpty(isshow)||!isshow.equals("0")){ %>
    store.load({params:{start:0, limit:<%=pageSize%>}});
        <%}%>

    sm.on('rowselect',function(selMdl,rowIndex,rec ){
        if(!Ext.isSafari)
       getArray(rec.get('id'),rec.get('<%=showfield%>'));
        else{
       		dialogValue=[rec.get('id'),rec.get('<%=showfield%>')];
            parent.win.close();
        }
       //getArray(rec.get('id'),rec.get(cm.getDataIndex(0)));
    }
            );

    //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [tabPanel,grid]
	});

		 orgtb.add(Ext.get('divReftype').dom.innerHTML);
    orgtb.add('-');
    <%=returnmenustr.replaceAll("tb1","orgtb")%>
    <%=returnmenustr.replaceAll("tb1","grouptb")%> 
    //d&d

	<%if(activeTab.equals("2"))out.println("onSearch2();");%>
   
});
function onClear(){
    if(!Ext.isSafari)
       getArray("0","");
        else{
       dialogValue=["0",""];
            parent.win.close();
        }
}
function onReturn(){
	if(!Ext.isSafari)
        window.parent.close();
        else{
            parent.win.close();
        }
}
</script>
</head>
<body style="margin:10px,10px,10px,0px;padding:0px" >
<script>Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';</script>


<div id="divSearch">
 <div id="pagemenubar">
 </div>
 <!--页面菜单结束-->
     <form action="<%=action%>" id="EweaverForm" name="EweaverForm" method="post" onsubmit="onSearch2();return false;">
     <input type="hidden" name="sqlwhere" value="<%=sqlwhere%>"/>
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
 while(it.hasNext()){

     Reportsearchfield reportsearchfield = (Reportsearchfield) it.next();
     String formfieldid = reportsearchfield.getFormfieldid();
     Formfield formfield = formfieldService.getFormfieldById(formfieldid);
     formfieldlist.add(formfield);
 }


 DataService	dataService = new DataService();
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
 int linecolor=0;

 int tmpcount = 0;
 boolean showsep = true;

 Iterator fieldit = formfieldlist.iterator();
Map _fieldcheckMap=new HashMap();
while(fieldit.hasNext()){
  Formfield formfield = (Formfield)fieldit.next();
  String _htmltype = StringHelper.null2String(formfield.getHtmltype());
  String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
  String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
  
//系统表Humres,Docbase下拉框联动字段验证保存的是字段名称，需要转换为ID。
 	 Formfield _field = formfieldService.getFormfieldByName("402881e80c33c761010c33c8594e0005", _fieldcheck);
 	 if(_field!=null){
 	 	_fieldcheck = _field.getId();
 	 }

  String id = formfield.getId();
     if(fieldsearchMap != null){
         fieldopt = (String)fieldsearchMap.get("con"+ id + "_opt");
         fieldopt1 = (String)fieldsearchMap.get("con"+ id + "_opt1");
         fieldvalue = (String)fieldsearchMap.get("con"+ id + "_value");
         fieldvalue1 = (String)fieldsearchMap.get("con"+ id + "_value1");

     }
  if(!_fieldcheck.equals("")&&!fieldvalue.equals("")){
     _fieldcheckMap.put(_fieldcheck,fieldvalue);
  }
}
 Iterator fieldit1 = formfieldlist.iterator();
 while(fieldit1.hasNext()){
     Formfield formfield = (Formfield)fieldit1.next();
     String id = formfield.getId();
     if(fieldsearchMap != null){
         fieldopt = (String)fieldsearchMap.get("con"+ id + "_opt");
         fieldopt1 = (String)fieldsearchMap.get("con"+ id + "_opt1");
         fieldvalue = (String)fieldsearchMap.get("con"+ id + "_value");
         fieldvalue1 = (String)fieldsearchMap.get("con"+ id + "_value1");

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
 String label = formfield.getLabelname();
 %>

         <% if(combinefieldflag){%>
     <%=StringHelper.null2String(combineobjname)%>
         <%}else{ %>
         <%=labelService.getLabelName(StringHelper.null2String(label))%>
     <%}%>     <%
 if(htmltype.equals("1")){
     if(type.equals("1")){//文本
 %>
     <td  class="FieldValue" width=15% nowrap>
       <input type=text class=inputstyle style="width:90%" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"/>
     </td>
    <%
    }else if(type.equals("2")){//整数
 %>
     <td  class="FieldValue" width=15% nowrap>
       <input type=text class=inputstyle style="width:90%" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkInt_KeyPress()' >--<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050009")%>--
       <input type=text class=inputstyle style="width:90%" name="con<%=id%>_value1"   value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkInt_KeyPress()' >
     </td>
     <%
    }
    else if(type.equals("3")){//浮点数



    %>
     <td  class="FieldValue" width=15% nowrap>
       <input type=text class=inputstyle style="width:90%" name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkFloat_KeyPress()'>--<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050009")%>--
       <input type=text class=inputstyle style="width:90%" name="con<%=id%>_value1" value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkFloat_KeyPress()'>
     </td>
     <%

    }
    else if(type.equals("4")){//日期

    %>
             <td  class="FieldValue" width=15% nowrap>
                    <button type="button" class="Calendar" id=SelectDate2 onclick="javascript:getdate('con<%=id%>_value','con<%=id%>_valuespan','0')"></button>&nbsp;
                    <span id="con<%=id%>_valuespan" ><%=StringHelper.null2String(fieldvalue)%></span>-&nbsp;&nbsp;
                    <input type=hidden name="con<%=id%>_value" value="" value="<%=StringHelper.null2String(fieldvalue)%>">
                    <button type="button" class="Calendar" id=SelectDate  onclick="javascript:getdate('con<%=id%>_value1','con<%=id%>_value1span','0')"></button>&nbsp;
                    <span id="con<%=id%>_value1span" ><%=StringHelper.null2String(fieldvalue1)%></span>
                    <input type=hidden name="con<%=id%>_value1" value="" value="<%=StringHelper.null2String(fieldvalue1)%>">
                 </td>

     <%
    }
    else if(type.equals("5")){//时间
            StringBuffer sb = new StringBuffer("");
         sb.append("<td class='FieldValue' width=15% nowrap>\n\r <button  type=button class=Calendar onclick=\"javascript:gettime('con"+_fieldid+"_value','con"+_fieldid+"_valuespan','0');\"></button>");
         sb.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
         sb.append("\n\r<span id=\"con"+_fieldid+"_valuespan\" name=\"con"+_fieldid+"_valuespan\" >");
         sb.append(StringHelper.null2String(fieldvalue));
         sb.append("</span>\n\r</td>");
            out.print(sb.toString());
    }
      %>
 <%}
 else if(htmltype.equals("2")){//多行文本

 if(tmpcount%3==2){
 %>
     <td colspan=3  class="FieldValue" width=15% nowrap>
         <TEXTAREA style="width:90%" ROWS="" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"><%=StringHelper.null2String(fieldvalue)%></TEXTAREA>
     </td>
  <%}else{%>
     <td colspan=3  class="FieldValue" width=15% nowrap>
       <TEXTAREA style="width:90%"  ROWS="" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"><%=StringHelper.null2String(fieldvalue)%></TEXTAREA>
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


 %>

     <td  class="FieldValue" width=15% nowrap>
             <INPUT TYPE="checkbox" NAME="con<%=id%>_value" value="1" <%if(StringHelper.null2String(fieldopt).equals("1")){%> checked <%}%> flag=0 onclick="gray(this)" >
     </td>

     <%}

 else if(htmltype.equals("5")){//选择项

             List list ;
             if(_fieldcheckMap.get(_fieldid)!=null){
             list = selectitemService.getSelectitemList(type,(String)_fieldcheckMap.get(_fieldid));
             }
             else
             list = selectitemService.getSelectitemList(type,null);
             StringBuffer sb = new StringBuffer("");
           //系统表Humres,Docbase下拉框联动字段验证保存的是字段名称，需要转换为ID。
            	 Formfield _field = formfieldService.getFormfieldByName("402881e80c33c761010c33c8594e0005", _fieldcheck);
            	 if(_field!=null){
            	 	_fieldcheck = _field.getId();
            	 }

             sb.append("<input type=\"hidden\" name=\"field_"
                             + _fieldid + "_fieldcheck\" value=\"" + _fieldcheck + "\" >");
             sb.append("<td width=15% class='FieldValue'>\n\r <select class=\"inputstyle2\" style=\"width:90%\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+" onchange=\"fillotherselect(this,'" + _fieldid
							+ "',"+ "-1" +")\"  >");
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
             sb.append("</select>\n\r</td> ");
             out.print(sb.toString());

 }
 else if(htmltype.equals("6")){ // 关联选择

             Refobj refobj = refobjService.getRefobj(type);
             if(refobj != null){
                 String _refid = StringHelper.null2String(refobj.getId());
                 String _refurl = StringHelper.null2String(refobj.getRefurl());
                 String _viewurl = StringHelper.null2String(refobj.getViewurl());
                 String _reftable = StringHelper.null2String(refobj.getReftable());
                 String _keyfield = StringHelper.null2String(refobj.getKeyfield());
                 String _viewfield = StringHelper.null2String(refobj.getViewfield());

                 String showname = "";
                 if(!StringHelper.isEmpty(fieldvalue)){
                     String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(StringHelper.null2String(fieldvalue)) + ")";
                     List valuelist = dataService.getValues(sql);

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

                         }else{
                             if(i==valuelist.size()-1){
                                 showname += tmpobjname;
                             }else{
                                 showname += tmpobjname + ", ";
                             }
                         }
                     }
                 }
				if("GET".equalsIgnoreCase(request.getMethod()) && "402881821197b641011197b644690015".equalsIgnoreCase(_fieldid)){
					showname="";
					fieldvalue="";
				}

                 String checkboxstr = "";
                 if("orgunit".equals(_reftable)){
                     if(formfield.getFieldname().equalsIgnoreCase("orgids"))
                    ;
                    else{
                     String checked = "";
                     if(fieldsearchMap!=null&&StringHelper.null2String(fieldsearchMap.get("con" + id + "_checkbox")).equals("1")){
                         checked = "checked";
                     }
                     checkboxstr = "<input  type=\"checkbox\" name=\"con" + _fieldid+ "_checkbox\" value=\"1\" "+ checked +">";
                     }
                 }
                 StringBuffer sb = new StringBuffer("");
                 sb.append("<td width=15% class='FieldValue'> \n\r<button type=\"button\"  class=Browser onclick=\"javascript:getrefobj('con"+_fieldid+"_value','con"+_fieldid+"span','"+_refid+"','"+_viewurl+"','0');\"></button>");
                 sb.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
                 sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" >");
                 sb.append(showname);

                 sb.append("</span>\n\r").append(checkboxstr).append("</td> ");
                 out.print(sb.toString());

             }
 }
 else if(htmltype.equals("7")){ //附件
             StringBuffer sb = new StringBuffer("");
             sb.append("<td> \n\r<input type=\"hidden\" name=\"field_"+_fieldid+"\" value=\""+_value+"\" >");
             if(!StringHelper.isEmpty(_value)){
                 Attach attach = attachService.getAttach(_value);
                 String attachname = StringHelper.null2String(attach.getObjname());
                 sb.append("\n\r<a href=\""+request.getContextPath()+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+_value+"\">"+attachname+"</a>");
             }
             sb.append("\n\r<input type=\"file\" class=\"inputstyle2\" name=\"con"+_fieldid+"file\" "+_style+" >\n\r</td> ");
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
 </form>
 </div>
<!-- 条件结束-->

<div id="divReftype" style="display:none">
    <%

        List selectlist = selectitemService.getSelectitemList("402881e510e8223c0110e83c36010016", null);
        if (selectlist.size() > 0) {%>
    <SELECT onChange="changeReftype(this.value)">
        <% it = selectlist.iterator();
            while (it.hasNext()) {
                Selectitem selectitem = (Selectitem) it.next();
                String selected = selectitem.getId().equals(reftype) ? "selected" : "";
        %>
        <OPTION value="<%=selectitem.getId()%>" <%=selected%>><%=selectitem.getObjname()%>
        </OPTION>
        <% }%>
    </SELECT>
    <% }%>
</div>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
  <script language="javascript" type="text/javascript">
   function onSearch(pageno){
          document.EweaverForm.pageno.value=pageno;
       document.EweaverForm.submit();
   }
   function createexcel(){
          document.EweaverForm.action="/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=createexcel&reportid=<%=reportid%>&exportflag=";
       document.EweaverForm.submit();
   }

   function onSearch2(flag){
       var o=$('#EweaverForm').serializeArray();
       var data={};
       for(var i=0;i<o.length;i++) {
           if(o[i].value!=null&&o[i].value!=""){
        	   if(flag&&o[i].name.indexOf("con")==0){
        		   continue;
        	   }
           	   data[o[i].name]=o[i].value;
           }
       }
       store.baseParams=data;
	   if(flag){
	       store.baseParams.reftype=reftype;
       }
       store.load({params:{start:0, limit:<%=pageSize%>}});
   }
      $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch2();
       }
   });
   function onSearch3(){
          document.all('EweaverForm').action="/workflow/report/reportsearch.jsp?reportid=<%=reportid%>";
       document.all('EweaverForm').submit();
   }
   function doOrg(nodeid){
       nodeid=nodeid.replace(',','');       
       var sqlwhere="<%=sqlwhere.equals("")?"":sqlwhere%>";// orgids like '%"+nodeid+"%' ";
       store.baseParams={'sqlwhere':sqlwhere};
       store.baseParams.con402881821197b641011197b644690015_value=nodeid;
       store.load({params:{start:0, limit:<%=pageSize%>}});
   }
   function doGroup(nodeid,orderstr){
       var sqlwhere="<%=sqlwhere.equals("")?"":sqlwhere+" AND "%> id in (select humresid from sysgrouphumres where groupid='"+nodeid+"') ";
       store.baseParams={'sqlwhere':sqlwhere};
       store.baseParams.orderstr=orderstr;
       store.load({params:{start:0, limit:<%=pageSize%>}});
   }
   function changeReftype(rt){
       reftype=rt
       orgTree.root.eachChild(function(c){c.remove()}) ;
       newRootName="";
       newRootId="";
       Ext.each(rootsArray,function(o){
           if(o.reftype==rt){
               newRootId=o.id;
               newRootName=o.name;
           }
       })
       orgTree.root.appendChild(new Ext.tree.AsyncTreeNode({
                text: '<a onclick=onSearch2(true)>'+newRootName+'</a>',
                id: 'Orgunit_'+newRootId,
                expanded:true,
                allowDrag:false,
                allowDrop:false
            }));
       orgTree.getLoader().on("beforeload", function(treeLoader, node) {
           orgTree.getLoader().baseParams.reftype = reftype;
       });
       orgTree.root.expand();
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

	var sql = "select * from (select '' id,' ' objname,0 dsporder from selectitem union select s.id,s.objname,s.dsporder from selectitem s where pid = '"+elementvalue+"') t order by dsporder";
	//var sql ="<%=SQLMap.getSQLString("humres/base/humresBrowserResult.jsp")%>";
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

           if(data[i].ID==null){
             data[i].ID="";
           }
           obj.options.add(new Option(data[i].objname,data[i].id ));
       }
   }
  
  var win;
   function getrefobj(inputname,inputspan,refid,viewurl,isneed){

    if(inputname.substring(3,(inputname.length-6))){
        if(document.getElementById(inputname.substring(3,(inputname.length-6))))
     document.getElementById(inputname.substring(3,(inputname.length-6))).value="";
    }
       var id;
       var url="/base/refobj/baseobjbrowser.jsp?id="+refid;
   	if(!Ext.isSafari){
    try{
	    id=openDialog('/base/popupmain.jsp?url='+url);
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
			document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	
	            }
	         }
   	}else{
   	 var callback = function() {
         try {
             id = dialog.getFrameWindow().dialogValue;
         } catch(e) {
         }
        	if (id!=null) {
			if (id[0] != '0') {
				document.all(inputname).value = id[0];
				document.all(inputspan).innerHTML = id[1];
		    }else{
				document.all(inputname).value = '';
				if (isneed=='0')
				document.all(inputspan).innerHTML = '';
				else
				document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
		
		            }
		         }
     }
	    var winHeight = Ext.getBody().getHeight() * 0.95;
	    var winWidth = Ext.getBody().getWidth() * 0.95;
	    if(winHeight>500){//最大高度500
	    	winHeight = 500;
	    }
	    if(winWidth>880){//最大宽度800
	    	winWidth = 880;
	    }
     if (!win) {
          win = new Ext.Window({
             layout:'border',
             width:winWidth,
             height:winHeight,
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
function getArray(id,value){
    window.parent.returnValue = [id,value];
    window.parent.close();
}
</script>
</body>
<script type="text/javascript">
Ext.onReady(function(){
<%
if(!"".equals(StringHelper.null2String(session.getAttribute("checksqlwhere")))){
%>
onSearch2();
<%
}
session.removeAttribute("checksqlwhere");
%>
});
</script>
</html>