<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.service.*" %>
<%@ page import="com.eweaver.base.selectitem.model.*" %>
<%@page import="com.eweaver.interfaces.workflow.*" %>
<%@page import="com.eweaver.interfaces.form.*" %>
<%@page import="com.eweaver.interfaces.model.*" %>
<%@page import="com.eweaver.base.orgunit.service.*" %>

<%
String org = StringHelper.null2String(request.getParameter("org"));//部门
String status = "2c91a0302c2fe2d1012c349aa31e038f";//只盘点入库状态的设备
String workflowid="2c91a0302c3d90d7012c3e0a8a2200af";// 设 备 盘 点 情 况 确 认 单 

String action = StringHelper.null2String(request.getParameter("action"));
String create = StringHelper.null2String(request.getParameter("create"));
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");

Map state = new HashMap();//状态
List stateList = selectitemService.getSelectitemList("2c91a0302c2fe2d1012c3499c543038d",null);
for(int i=0;i<stateList.size();i++){
	Selectitem s = (Selectitem)stateList.get(i);
	state.put(s.getId(),s.getObjname());
}

Map sspecialty = new HashMap();//专业
List sspecialtyList = selectitemService.getSelectitemList("2c91a0302aa6def0012aa8a11052074d",null);
for(int j=0;j<sspecialtyList.size();j++){
	Selectitem s = (Selectitem)sspecialtyList.get(j);
	sspecialty.put(s.getId(),s.getObjname());
}

List list=null;
if("getDetail".equals(action)){
	DataService dataService = new DataService();
	String sql = "select requestid, reqname,reqorgunit,standardmodel,leavefactoryno,specialtys,equipmentstate,sspecialty,reqorgunit "+
		"from uf_device_equipment where equipmentstate='"+status+"' ";
	
	if(!StringHelper.isEmpty(org)){
		sql+="and reqorgunit = '"+org+"' ";
	}
	list = dataService.getValues(sql);

	//创建流程
	if("true".equals(create)){
		WorkflowServiceImpl ws=new WorkflowServiceImpl ();
		RequestInfo req=new RequestInfo();
		req.setCreator(BaseContext.getRemoteUser().getId());
		req.setTypeid(workflowid);
		req.setIssave("1");//保存
		Dataset data=new Dataset();
		req.setData(data);
		//设置流程主表字段信息
		List<Cell> mainList=new ArrayList<Cell>();
		mainList.add(new Cell("orgid",org));//部门
		mainList.add(new Cell("checkdate",DateHelper.getCurrentDate()));//盘点日期
		data.setMaintable(mainList);
	
		List<Subtable> subList=new ArrayList<Subtable>();
		data.setSubtables(subList);//设置子表对象
		Subtable subtable=new Subtable();//增加一个子表
		subList.add(subtable);
	
		List<Row> rowsList=new ArrayList<Row>();
		subtable.setRows(rowsList);//添加子表行记录对象
		subtable.setName("uf_uf_device_check_sub");//设备盘点情况确认单_子表
	
		for(int i=0;i<list.size();i++){
			Map m = (Map)list.get(i);
		 	Row row=new Row();
			List<Cell> cellList=new ArrayList<Cell>();
			
			cellList.add(new Cell("devicename",m.get("requestid")));//设备名称
			cellList.add(new Cell("model",m.get("standardmodel")));//型号
			cellList.add(new Cell("deviceNO",m.get("leavefactoryno")));//编号
			cellList.add(new Cell("reqorg",m.get("reqorgunit")));//部门
			cellList.add(new Cell("reqdept",m.get("specialtys")));//专业室
			
			row.setCells(cellList);
			rowsList.add(row);
		}
		
		String requestid=ws.createRequest(req);
		String url="/workflow/request/workflow.jsp?viewmode=0&workflowid="+workflowid+"&requestid="+requestid;
		response.sendRedirect(url);
		return;
	}
}
%>
<html>
<head>
<title><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec713003a") %><!-- 设备盘点 --></title>
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/main.js"></script>
<script type="text/javascript" src="/js/weaverUtil.js"></script>
<script type="text/javascript" src="/datapicker/WdatePicker.js"></script>
<script type='text/javascript' src='/js/workflow.js'></script>
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/examples/grid/RowExpander.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/chooser/chooser.js"></script>
</head>
<body>
<div id="pagemenubar"></div>
<center>
<form action="" id="searchForm" name="searchForm" method="post">
<input type="hidden" name="action" value="getDetail">
<input type="hidden" id="create" name="create" value="">
<table border="1">
<colgroup> 
    <col width="20%">
    <col width="80%">
</colgroup>	
	<TR>
		<TD>部 门</TD>
		<TD>
			<button type=button class=Browser id="orgButton" name="orgButton"
				onclick="javascript:getrefobj('org','orgspan','2c91a0302ac122a2012ac27a18720654','','/base/orgunit/orgunitview.jsp?id=','1');"></button>
			<input type="hidden" name="org" value="<%=org%>" style='width: 80%'>
			<span id="orgspan" name="orgspan"><%=orgunitService.getOrgunitName(org)%></span>
		</TD>
	</TR>
</table>
</form>
</center>
<%if(list!=null){%>
<table border="1" cellpadding="3">
	<tr class="header">
		<td><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7110030") %><!-- 计量器具名称 --></td>
		<td><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec713003b") %><!-- 型　号 --></td>
		<td><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7120032") %><!-- 出厂编号 --></td>
		<td><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019") %></td><!-- 状　态 -->
		<td><%=labelService.getLabelNameByKeyId("402881e50de7d974010de7f72658013a") %></td><!-- 所属部门 -->
		<td><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec713003c") %><!-- 专业室 --></td>
	</tr>
	<%for(int i=0;i<list.size();i++){
		Map map  = (Map)list.get(i);
	%>
	<tr height="25px">
		<td><%=StringHelper.null2String(map.get("reqname"))%></td>
		<td><%=StringHelper.null2String(map.get("standardmodel"))%></td>
		<td><%=StringHelper.null2String(map.get("leavefactoryno"))%></td>
		<td><%=state.get(map.get("equipmentstate"))%></td>
		<td><%=orgunitService.getOrgunitName((String)map.get("reqorgunit"))%></td>
		<td><%=orgunitService.getOrgunitName((String)map.get("specialtys"))%></td>
	</tr>
	<%}%>
</table>
<%}%>
<script type="text/javascript">
Ext.onReady(function() {
    Ext.QuickTips.init();
    var tb = new Ext.Toolbar();
    tb.render('pagemenubar');
    //addBtn(tb,'清空条件','R','erase',function(){reset();});
    //addBtn(tb,'查询','S','page',function(){javascript:loadData();});
    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec713003a") %>','S','page',function(){javascript:createPlan();});//设备盘点
});
function loadData(){
	document.getElementById("create").value="false";
	searchForm.submit();
}
function createPlan(){
	document.getElementById("create").value="true";
	searchForm.submit();
}
function reset(){
	document.getElementById("org").value="";
}
function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
    if(document.getElementById(inputname.replace("field","input"))!=null)
 document.getElementById(inputname.replace("field","input")).value="";

var fck=param.indexOf("function:");
    if(fck>-1){}else{
        var param = parserRefParam(inputname,param);
    }
var idsin = document.getElementsByName(inputname)[0].value;
    var url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
    if(idsin.length>900){   //当idsin过长时，ie的url不支持过长的地址
       url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
    }
var id;
if(Ext.isIE){
try{

id=openDialog(url,idsin);
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
	document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
      }
      }
}else{
	document.all(inputname).value = '';
	if (isneed=='0')
	document.all(inputspan).innerHTML = '';
	else
	document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

        }
     }
}else{
url='/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
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
                            document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                    }
                }
            } else {
                document.all(inputname).value = '';
                if (isneed == '0')
                    document.all(inputspan).innerHTML = '';
                else
                    document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

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
            }
    win.render(Ext.getBody());
    var dialog = win.getComponent('dialog');
    dialog.setSrc(url);
    win.show();
}
}

</script>
</body>
</html>
