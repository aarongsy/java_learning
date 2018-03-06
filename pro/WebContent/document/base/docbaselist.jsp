<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.base.service.DocbaseService"%>
<%@ page import="com.eweaver.document.base.model.Docbase"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.model.Categorylink"%>
<%@ page import="com.eweaver.base.log.service.LogService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.setitem.service.*"%>
<%@ page import="com.eweaver.base.setitem.model.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportfield" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService" %>
<%
int gridWidth=700;
int Swidth=10;
int pageSize=20;
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
String categoryid = StringHelper.null2String(request.getParameter("categoryid"));
boolean isauth = permissiondetailService.checkOpttype(categoryid,2);
String isnew=request.getParameter("isnew");
String subject=request.getParameter("subject");
boolean useRTX=false;
int isshow = NumberHelper.string2Int(request.getParameter("isreply"),1);
String isnextdir=StringHelper.null2String(request.getParameter("isnextdir"));
 String action="";
  if(isshow==1)
  {
      action=request.getContextPath()+"/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=getdocbaseall&from=list&isnew="+isnew;
  }
  else
  {
     action=request.getContextPath()+"/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=getdoc&from=list&isnew="+isnew;
  }
SetitemService setitemService=(SetitemService)BaseContext.getBean("setitemService");
Setitem rtxSet=setitemService.getSetitem("4028819d0e52bb04010e5342dd5a0048");
if(rtxSet!=null&&"1".equals(rtxSet.getItemvalue())){
	useRTX=true;
}
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
String orderby = StringHelper.trimToNull(request.getParameter("orderby")) == null? "modifydate desc , modifytime desc":request.getParameter("orderby");
int isreply = NumberHelper.string2Int(request.getParameter("isreply"),1);
int showreply = NumberHelper.string2Int(request.getParameter("showreply"),1);
String titleper = StringHelper.null2String(request.getParameter("titleper"));
String jsonStr=null;
Category category=null;
if(!categoryid.equals("")){
	category = categoryService.getCategoryById(categoryid);
}
Map queryFilterMap = (Map)request.getAttribute("queryFilter");
if(queryFilterMap != null){
        JSONObject jsonObject=new JSONObject();
        Set keySet=queryFilterMap.keySet();
        for(Object key:keySet){
            Object value=queryFilterMap.get(key);
            if(value!=null)
            jsonObject.put(key,value);
        }
        
        jsonStr=jsonObject.toString();
    }
%>
<html>
  <head>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/TreeGrid.css" />
<script type='text/javascript' src='<%=request.getContextPath()%>/js/ext/examples/grid/RowExpander.js'></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/ext/ux/TreeGrid.js'></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
<script  type='text/javascript' src='/js/ext/examples/grid/RowExpander.js'></script>
<script type='text/javascript' src='/js/ext/ux/TreeGrid.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
 <style type="text/css">
    TABLE {
	    width:0;
    }
    /*TD{*/
        /*width:16%;*/
    /*}*/
     .ux-maximgb-treegrid-breadcrumbs{
         display:none;
     }
</style>
 <script type="text/javascript">
      var store;
    <%
        FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
        ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
		String docRptid="402880321ce00d9c011ce019ae0e0002";
		if(category!=null && !StringHelper.isEmpty(category.getReportid())){
			docRptid=category.getReportid();
		}
        List reportfieldList = reportfieldService.getReportfieldListByReportID(docRptid);
        String cmstr="";
        String fieldstr="";
        Iterator it = reportfieldList.iterator();
        fieldstr+="'requestid'";
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
			if("subject".equals(formfields.getFieldname())){
			    Swidth=showwidth*gridWidth/100;
                continue;
			}
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

         	String fieldname=formfields.getFieldname() ;
         	String showname=reportfield.getShowname();
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
      	//reportdatalist.add(reporttitleMap);//生成excel报表时用到

      %>
  Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890004")%>';//正在加载,请稍候...
  var grid;
  var sm=new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});

  Ext.onReady( function()
{
    Ext.QuickTips.init();
    // create the data store

     store = new Ext.ux.maximgb.treegrid.AdjacencyListStore({
    	autoLoad : true,
    	url: '<%=action%>',
			reader: new Ext.data.JsonReader(
				{
					id: '_id',
					root: 'result',
					totalProperty: 'totalCount',
                    fields: ['_id','_parent','_is_leaf','subject',<%=fieldstr%>]
                }),
        remoteSort: true

    });
    // create the Grid
    grid = new Ext.ux.maximgb.treegrid.GridPanel({
	  <%if(currentSysModeIsWebsite){	//网站模式%>
   			autoHeight: true,
	  <%}%>
      store: store,
      sm:sm,
      master_column_id : 'subject',
      columns: [
                         {id:'subject',header: "<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009")%>", width: <%=Swidth%>,  dataIndex: 'subject'},//标题
                            <%=cmstr%>],
      stripeRows: true,
      autoExpandColumn: 'subject',
      loadMask: true,
      viewConfig: {
                           forceFit:true,
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
                       },
      //tbar: [Ext.get('divSearch').dom.innerHTML],
        tbar: new Ext.Toolbar({id: 'topbar',items:[
   			{id: 'tbar1',text: '<%=labelService.getLabelName("下载")%>',iconCls: Ext.ux.iconMgr.getIcon('package_down'),handler: DownloadAttachs},
			<% if(isauth){%>
   			{id: 'tbar2',text: '<%=labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")%>',iconCls:Ext.ux.iconMgr.getIcon('page_white_add'),handler: newDoc},
			<% }%>
   			{id: 'tbar3',text: '<%=labelService.getLabelName("刷新")%>',iconCls:Ext.ux.iconMgr.getIcon('refresh'),handler: refresh},
   			Ext.get('divSearch').dom.innerHTML
   		]}),
   		bbar: new Ext.ux.maximgb.treegrid.PagingToolbar({
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
            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>",//没有结果返回
            //paramNames:{start:"start",limit:"limit",paged:"paged"},
            pageSize: <%=pageSize%>
        })
    });
    store.baseParams=<%=(jsonStr==null?"{}":jsonStr)%>
    store.baseParams.isnextdir='<%=isnextdir%>';
    store.load({params:{start:0, limit:<%=pageSize%>},paged:""});
    var vp = new Ext.Viewport({
    	layout : 'fit',
    	items : grid
    });
    grid.getSelectionModel().selectFirstRow();

});
</script>
</head> 
  <body>

<div id="divSearch" style="display: none;">
     <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=search&from=list&isnew=<%=isnew%>&categoryid=<%=categoryid%>&subject=<%=subject%>" name="EweaverForm" method="post">
	      <input name="categoryid" value="<%=categoryid%>" type="hidden">
          <input name="subject" value="<%=subject%>" type="hidden">
		  <div style="padding: 0 0 2 10">
		     &nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890005")%>：<select name=isreply size=1 class=InputStyle onchange="selvalue()"><!-- 是否包括回复 -->
		     <option value="1" <%if(isreply==1){%> selected <%}%>><%=labelService.getLabelName("402881eb0bd66c95010bd6d13003000c")%></option>
		     <option value="0" <%if(isreply==0){%> selected <%}%>><%=labelService.getLabelName("402881eb0bd66c95010bd6d19cf5000d")%></option>
		     </select><!-- 是否包括子目录 -->
        	  &nbsp;&nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890006")%>:   <input type="checkbox" name="isnextdir" id="isnextdir" value="1" <%if(!StringHelper.isEmpty(isnextdir)&&isnextdir.equals("1")){%> checked="true" <%}%>  onclick="Checkdir(this)">
  			</div>
        </form>
</div>
</body>
</html>
<script type='text/javascript'>
	Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';

	function openchild(inputvalue){
	 	var returnvalue = openDialog("<%=request.getContextPath()%>/document/base/basechild.jsp?objid=" + inputvalue,"Width=110,Height=100");
	}
   	function selvalue()
   	{
      	document.EweaverForm[0].submit()
    }
    function adddocbase(url){
		window.location.href="<%=request.getContextPath()%>"+url;
	}
 	var categoryid="<%=categoryid%>";
	function DownloadAttachs(){
	 	var isnextdir=document.getElementById('isnextdir').checked ? "1" : "0";
	 	var isreply = document.getElementById('isreply').value;
		Ext.Ajax.request({
			 url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=checkAttachNumber',
             params:{categoryid:categoryid,isnextdir:isnextdir,isreply:isreply} ,
             success: function(res) {
            	if(res.responseText>0){
					var url=location.href;
					if(url.indexOf('action=')>0){
						url=url.replace(/action=\w+/gi,'action=downloadAttach');
					}else url+='&action=downloadAttach';
					url=url.replace(/&from=search/gi,'');
					url+="&isnextdir="+isnextdir+"&isreply="+isreply;
					location.href=url;
				}else{
					alert('没有附件可以下载！');
					return;
				}
             }
		});
	}
	function openchild(inputvalue){
	 var returnvalue = openDialog("/document/base/basechild.jsp?objid=" + inputvalue,"Width=110,Height=100");
	}
	function selvalue(){
	   document.EweaverForm[0].submit()
	}
	function newDoc(){
		window.location.href='/document/base/docbasecreate.jsp?categoryid='+categoryid;
	}
	function refresh(){
		window.location.reload();
	} 
    function Checkdir(obj){
        if(obj.checked==true){
            document.all('isnextdir').value=1;
        }else{
            document.all('isnextdir').value=0;
        }
          store.baseParams.isnextdir=document.all('isnextdir').value;
       store.load({params:{start:0, limit:<%=pageSize%>},paged:""});
    }
</script>

