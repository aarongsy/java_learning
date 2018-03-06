<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@page import="com.eweaver.workflow.form.model.Formfield"%>
<%@page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ include file="/base/init.jsp"%>
<%
String reportid = request.getParameter("reportid");
String categoryid = StringHelper.null2String(request.getParameter("categoryid"));
String formid = StringHelper.null2String(request.getParameter("formid"));
String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
String oneself = StringHelper.null2String(request.getParameter("oneself"));
String share = StringHelper.null2String(request.getParameter("share"));//共享日程
String calformid = StringHelper.null2String(request.getParameter("calformid"));
String contemplateid = StringHelper.null2String(request.getAttribute("contemplateid"));
String isnew = request.getParameter("isnew");
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
List reportfieldList = reportfieldService.getReportfieldListForUser(reportid,contemplateid);
if(reportfieldList.size()==0){
	reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
}
String isresource = StringHelper.null2String(request.getParameter("isresource"));
String action2;
if(StringHelper.isEmpty(isresource))
{
	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&isnew="+isnew+"&reportid=" + reportid;//日程
}else
{
	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?&isnew="+isnew+"&action=search&reportid=" + reportid;//资源
}
int pageSize=20;
int gridWidth=300;
List reportdatalist = new ArrayList();//用于保存转换后的查询数据
String cmstr="";
String fieldstr="";
Iterator it = reportfieldList.iterator();
if(StringHelper.isEmpty(isresource))
{
	fieldstr+="'id'";
}else{
	fieldstr+="'requestid'";
}
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

 	String fieldname=formfields.getFieldname() ;
 	String showname=reportfield.getShowname();
 	int sortable= NumberHelper.getIntegerValue(reportfield.getIsorderfield(),0);
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
<html>
<head>
<script type="text/javascript">
var store;
Ext.onReady(function() {
	store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: '<%=action2+"&isjson=1&pagesize="+pageSize+"&isformbase=0"%>'
        }),
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalCount',
            fields: [<%=fieldstr%>]
        }),
        remoteSort: true
    });
	
	var sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([<%=cmstr%>]);
    cm.defaultSortable = true;
    
    var grid = new Ext.grid.GridPanel({
    	<%if(!StringHelper.isEmpty(calformid)){%>
    	title:'<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80012")%>',//日程共享
		<%}else if(StringHelper.isEmpty(isresource)){%>
		title:'<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd29de0a0018")%>',//我的下属
		<%}else{%>
		title:'<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8001d")%>',//资源列表
		<%}%>
		region: 'west',
		renderTo: 'reportTD',
		store: store,
		cm: cm,
		trackMouseOver:false,
		sm:sm ,
		//loadMask: true,
		split:true,
		width:<%=gridWidth%>,
		height: document.body.clientHeight-1,
		collapsible:true,
		collapseMode:'mini',
		viewConfig: {
			forceFit:true,
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
            store: store,
            displayInfo: false,
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
   
    sm.on('rowselect',function(selMdl,rowIndex,rec ){
    <%if(!StringHelper.isEmpty(calformid)){%>
    	var humresid = rec.get('id');//共享日程
    	var params = {
			"isone": "0",
			"oneself": "<%=oneself%>",
			"humresid": humresid,
			"share": "<%=share%>",
			"calformid": "<%=calformid%>",
			"iscalshare": "1"
		};
		changeFrameUrl(params);
    <%}else if(StringHelper.isEmpty(isresource)){%>
		var humresid = rec.get('id');//日程管理
		var params = {
			"isone": "0",
			"oneself": "<%=oneself%>",
			"humresid": humresid,
			"share": "<%=share%>"
		};
		changeFrameUrl(params);
	<%}else{%>
		resourceid = rec.get('requestid');//资源管理
		var params = {
			"humresid": resourceid
		};
		changeFrameUrl(params);
	<%}%>
    });
    
    <%if(StringHelper.isEmpty(calformid) && StringHelper.isEmpty(isresource)){//日程
        String stations=currentuser.getStation();
        String humresid=StringHelper.null2String(currentuser.getId());
        String humressqlwhere=" (extrefobjfield15='"+ humresid+"') ";
        if(!StringHelper.isEmpty(stations)){
        	stations="'"+stations.replaceAll(",","','")+"'";
      	 	humressqlwhere = " ("+SQLMap.getSQLString("calendar/schedule.jsp",new String[]{humresid,stations})+") ";
        }
    %> 
    	store.baseParams.sqlwhere="<%=StringHelper.getEncodeStr(humressqlwhere)%>";
    <%}%>
    
    store.on("load", function(st, records){
    	if(records && records.length > 0){
    		grid.getSelectionModel().selectFirstRow(); 
    	}
    });
    store.load({params:{start:0, limit:<%=pageSize%>}});
    document.getElementById("mainTable").style.width = document.body.clientWidth + "px";
    document.getElementById("scheduleFrame").style.height = document.body.clientHeight + "px";
    if(isIE10Browser()){
    	/*IE10 panel的div和panelbody的div一般宽，所以边框显示不出来*/
    	Ext.query("#reportTD .x-grid-panel .x-panel-body")[0].style.width = (<%=gridWidth%> - 2) + "px";
    }
});

function changeFrameUrl(params){
	var scheduleFrame = document.getElementById("scheduleFrame");
	var baseUrl = "/calendar/schedule2.jsp?categoryid=<%=categoryid%>&formid=<%=formid%>&workflowid=<%=workflowid%>";
	for(var key in params){
		baseUrl += "&" + key + "=" + params[key];
	}
	scheduleFrame.src = baseUrl;
}
</script>
</head>
<body>
<table id="mainTable">
<colgroup>
<col width="300px"/>
<col width="*"/>
</colgroup>
<tr>
<td id="reportTD" valign="top">

</td>
<td valign="top">
<iframe id="scheduleFrame" name="scheduleFrame" frameborder="0" style="border: none;width: 100%;height: 100%;">

</iframe>
</td>
</tr>
</table>
</body>
</html>
