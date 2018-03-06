<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.homepage.model.*" %>
<%@ page import="com.eweaver.homepage.dao.*" %>
<%@ page import="org.json.simple.*" %>
<%
WebMenuRefDao menuRefDao=(WebMenuRefDao)BaseContext.getBean("webMenuRefDao");
WebMenuDao menuDao=(WebMenuDao)BaseContext.getBean("webMenuDao");
String action=StringHelper.null2String(request.getParameter("action"));
if(action.equalsIgnoreCase("json")){
	String node=StringHelper.null2String(request.getParameter("node"));
	String where=" and (pid is null or pid='') ";
	if(!node.equalsIgnoreCase("rootmenu"))where=" and pid='"+node.substring(4)+"'";
	List<WebMenuRef> list=menuRefDao.getList("from WebMenuRef where 1=1 "+where+" order by dsporder");
	JSONArray jarray=new JSONArray();
	for(int i=0;i<list.size();i++){
		WebMenuRef menu=list.get(i);
		JSONObject obj=new JSONObject();
		WebMenu m=menuDao.getObjectById(menu.getMenuid());
		obj.put("text",m.getName());
		obj.put("id","node"+menu.getId());
		obj.put("pid",menu.getPid());
		boolean isLeaf=false;
		String hql="from WebMenuRef where pid='"+menu.getId()+"'";
		List list2=menuRefDao.getList(hql);
		if(list2==null || list2.isEmpty())isLeaf=true;
		obj.put("leaf",isLeaf);
		jarray.add(obj);
	}
	out.println(jarray.toString());
	return;
}else if(action.equalsIgnoreCase("delete")){
	String id=StringHelper.null2String(request.getParameter("id"));
	if(!StringHelper.isEmpty(id)){
		menuRefDao.removeObject(id);
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
Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';

Ext.onReady(function() {
		Ext.QuickTips.init();
        /*var tb = new Ext.Toolbar({region:'north'});
        tb.render('pagemenubar');
		addBtn(tb,'新增','N','add',onToolbar);
		addBtn(tb,'编辑','E','application_form_edit',onToolbar);
		addBtn(tb,'删除','D','delete',onToolbar);
		*/
		var viewport = new Ext.Viewport({
            layout: 'border',
            items: [getTree(),{
            	contentEl:'contentDiv',
            	region:'center'
            }]
        });
});
var menuTree=null;

function contextMenuClick(menu,item){
	var node=menu.contextNode;
	if(item.id=='addNode'){
		var pid=(node.id=='rootmenu')?'':node.id.substring(4);
		Ext.getDom('frameDiv').src='<%=request.getContextPath()%>/homepage/webmenuRefEdit.jsp?pid='+pid+'&_dt='+new Date().toString();
	}else{
		if(node.isLeaf()){
			Ext.Msg.confirm('删除确认', '确认删除该结点吗(Y/N)?', function(btn){
				if (btn == 'yes') location.replace('<%=request.getContextPath()%>/homepage/webmenuReflist.jsp?action=delete&id='+node.id.substring(4));
			}).setIcon(Ext.MessageBox.WARNING);
		}else{
			Ext.Msg.alert('提示信息', '非叶子结点不能删除,请先删除子结点!');
		}//end.if
	}
}
function getTree(){
	menuTree = new Ext.tree.TreePanel({
            animate:true,
            containerScroll: true,
            autoScroll:true,
            enableDD:true,
            ddAppendOnly:true,
            //lines:true,
            region:'west',
            width:200,
            minWidth:200,
            maxWidth:400,
            split:true,
            collapsible: true,
            collapsed : false,
            rootVisible:true,
            root:new Ext.tree.AsyncTreeNode({
                text: '菜单管理',
                id:'rootmenu',
                expanded:true,
                allowDrag:false,
                allowDrop:false
            }),
        loader:new Ext.tree.TreeLoader({dataUrl: "<%=request.getContextPath()%>/homepage/webmenuReflist.jsp?action=json"}),
        contextMenu: new Ext.menu.Menu({
            items: [{id: 'addNode',text: '新建'},
            	{id: 'delNode',text: '删除'}],
            listeners:{click:contextMenuClick}
            }),
        listeners:{
            contextmenu:function(node, e) {
                node.select();
                var c = node.getOwnerTree().contextMenu;
                c.contextNode = node;
	            c.items.item(1). setDisabled(!node.isLeaf());
                c.showAt(e.getXY());
            },
            click:function(node){
            	if(node.id!='rootmenu')
            		Ext.getDom('frameDiv').src='<%=request.getContextPath()%>/homepage/webmenuRefEdit.jsp?id='+node.id.substring(4)+'&_t='+new Date().toString();
            }
        }
    });
    return menuTree;
}//end.function.
</script>
</head>
<body>
<div id="pagemenubar" style="z-index:100;"></div>
<div id="contentDiv"><iframe name="frameDiv" id="frameDiv" frameborder="0" style="width:100%;height:100%" src="about:blank"></iframe></div>
</body>
</html>
