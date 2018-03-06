<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.homepage.model.WebMenu" %>
<%@ page import="com.eweaver.homepage.dao.WebMenuDao" %>
<%@ page import="com.eweaver.homepage.dao.WebMenuRefDao" %>
<%@ page import="org.json.simple.*" %>
<%
WebMenuDao menuDao=(WebMenuDao)BaseContext.getBean("webMenuDao");
WebMenuRefDao menuRefDao=(WebMenuRefDao)BaseContext.getBean("webMenuRefDao");
String action=StringHelper.null2String(request.getParameter("action"));
if(action.equalsIgnoreCase("json")){
	int nStart=NumberHelper.string2Int(request.getParameter("start"),0);
	int nPage=NumberHelper.string2Int(request.getParameter("limit"),0);
	Page pList=menuDao.getListByPage("from WebMenu",nStart,nPage);
	JSONObject json=new JSONObject();
	JSONArray jarray=new JSONArray();
	json.put("totalcount",pList.getTotalSize());
	List list=(List)pList.getResult();
	for(int i=0;i<list.size();i++){
		WebMenu menu=(WebMenu)list.get(i);
		JSONObject obj=new JSONObject();
		obj.put("id",menu.getId());
		obj.put("name",menu.getName());
		obj.put("url",menu.getUrl());
		jarray.add(obj);
	}
	json.put("result",jarray);
	out.println(json.toString());
	return;
}else if(action.equalsIgnoreCase("delete")){
	String id=StringHelper.null2String(request.getParameter("id"));
	String hql="from WebMenuRef where menuid='"+id+"'";
	List list1=menuRefDao.getList(hql);
	if(list1!=null && !list1.isEmpty()){
		out.println("<script>alert('该链接在菜单管理中正使用,请先去除再删除!');location.replace('"+request.getRequestURI()+"');</script>");
		return;
	}
	if(!StringHelper.isEmpty(id)){
		menuDao.removeObject(id);
		response.sendRedirect(request.getRequestURI());
	}
}
 %>
<%@ include file="/base/init.jsp"%>
<html>
  <head>
  <title>网页菜单管理</title>
   <script src="<%=request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
      <style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
      .x-panel-btns-ct {
        padding: 0px;
    }
    .x-panel-btns-ct table {width:0}
  </style>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
    <script type="text/javascript">
    function onToolbar(item){
    	if(item.id=='N'){
    		openWin('<%=request.getContextPath()%>/homepage/webmenuEdit.jsp', '新建网页菜单',null,400,300);
    	}else if(item.id=='E'){
    		var id=getSelectedId();
    		if(id!=null) openWin('<%=request.getContextPath()%>/homepage/webmenuEdit.jsp?id='+id, '新建网页菜单',null,400,300);
    	}else if(item.id=='D'){
			var id=getSelectedId();
    		if(id!=null){
				Ext.Msg.confirm('删除确认', '确认删除该记录吗(Y/N)?', function(btn){
					if (btn == 'yes') location.replace('<%=request.getContextPath()%>/homepage/webmenu.jsp?action=delete&id='+id);
				}).setIcon(Ext.MessageBox.WARNING); 			
    		}//end.if!=null
    	}else if(item.id=='O'){
			var id=getSelectedId();
			if(id!=null){
				var name=sm.getSelected().get('name');
				window.returnValue=[id,name];
				window.close();
			}
    	}else if(item.id=='B'){
    		window.returnValue=null;
			window.close();
    	}
    }
function getSelectedId(){
	var rec=sm.getSelected();
	if(rec==null){
		alert('请选择一行操作！');
		return null;
	}
	return rec.get('id');
}
      Ext.onReady(function() {
          Ext.QuickTips.init();
          var tb = new Ext.Toolbar({region:'north'});
          tb.render('pagemenubar');
        <%if(action.equalsIgnoreCase("browser")){%>
        addBtn(tb,'确定','O','accept',onToolbar);
        addBtn(tb,'返回','B','arrow_redo',onToolbar);
        <%}else{%>
		addBtn(tb,'新增','N','add',onToolbar);
		addBtn(tb,'编辑','E','application_form_edit',onToolbar);
		addBtn(tb,'删除','D','delete',onToolbar);
		<%}%>
		var viewport = new Ext.Viewport({
            layout: 'border',
            items: [tb,initGrid()]
        });
		store.load({params:{start:0, limit:20}});	
      });
      // 标题 数据表单 树形 级联子树条件
var sm = new Ext.grid.CheckboxSelectionModel();
var store=null;
function initGrid(){
	store = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=request.getContextPath()%>/homepage/webmenu.jsp?action=json'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
               fields: ['name','url','id']
           })
       });
    var grid2 = new Ext.grid.GridPanel({
        store:store,
        cm: new Ext.grid.ColumnModel([
            sm,
            {header: "名称", sortable: true, dataIndex: 'name'},
            {header: "URL",sortable: true, dataIndex: 'url'}
        ]),
        sm: sm,
        //width:document.documentElement.clientWidth,
        //height:document.documentElement.clientHeight,
        region: 'center',
        autoWidth:true,
        header:false,
        frame:false,
        //title:'查看页面菜单',
        iconCls:'icon-grid' ,
        viewConfig: {
                                    forceFit:true,
                                    enableRowBody:true,
                                    sortAscText:'升序',
                                    sortDescText:'降序',
                                    columnsText:'列定义'
                                },
         bbar: new Ext.PagingToolbar({
                     store: store,
                     pageSize: 20,
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
    return grid2;
}
  </script>
  </head>
  <body>
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/homepage/webmenu.jsp" name="EweaverForm"  id="EweaverForm" method="post">
<input type="hidden" name="action" value="save"/>
<table>
    <colgroup>
        <col width="50%">
        <col width="50%">
    </colgroup>
    <tr>
        <td valign=top></td>
        </tr>
</table>
</form>
  </body>
</html>
