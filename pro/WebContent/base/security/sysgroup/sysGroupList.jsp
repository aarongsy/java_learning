<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@page import="java.sql.SQLException"%>
<%@page import="org.hibernate.HibernateException"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.springframework.orm.hibernate3.HibernateTemplate"%>
<%@page import="org.springframework.orm.hibernate3.HibernateCallback"%>

<%
   String selectItemId = StringHelper.null2String(request.getParameter("selectItemId"));
   String objname = StringHelper.null2String(request.getParameter("objname"));
   if(selectItemId.equals("")) selectItemId = "2";//系统角色
   SysGroupService sysGroupService = (SysGroupService) BaseContext.getBean("sysGroupService");
   FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
   //List sysGroupList = sysGroupService.searchSysGroup(selectItemId,objname);
   SysGroup sysGroup=new SysGroup();
   
   HibernateTemplate hibernateTemplate = (HibernateTemplate) BaseContext.getBean("hibernateTemplate");
   List<?> userList = hibernateTemplate.find("select objid from Sysuser where id in (select userid from Sysuserrolelink where roleid = ?)", new Object[]{"402881e50bf0a737010bf0a96ba70004"});
   boolean isAdmin = userList.contains(eweaveruser.getHumres().getId());
%>
<html>
  <head>
  <STYLE>
.infoinput {
	font-size: 9pt;
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 1px;
	border-left-width: 0px;
	border-bottom-style: solid;
	border-bottom-color: #cccccc;
}
</STYLE>
</head>
  
  <body>
<!--页面菜单开始-->     
<%
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch()});";
pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881eb0bcbfd19010bcc7bf4cc0028") + "','C','add',function(){onCreate('/base/security/sysgroup/sysGroupCreate.jsp');});";
pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881e60aa85b6e010aa8624c070003") + "','D','delete',function(){onDelete()});";
%>
	<style type="text/css">
	  .x-toolbar table {
		  width: 0
	  }

	  #pagemenubar table {
		  width: 0
	  }

	  .x-panel-btns-ct {
		  padding: 0px;
	  }

	  .x-panel-btns-ct table {
		  width: 0
	  }
      </style>
  	  <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  	  <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  	  <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   	  <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script type="text/javascript">
        var store;
        var selected=new Array();
        var dlg0;
		Ext.onReady(function() {
		     Ext.SSL_SECURE_URL='about:blank';
          	 Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...

            <%
            String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.SysGroupAction?action=getsysgrouplist";
            %>
			Ext.QuickTips.init();
			<%if(!pagemenustr.equals("")){%>
			var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
			<%=pagemenustr%>
			<%}%>
		    store = new Ext.data.Store({
                 proxy: new Ext.data.HttpProxy({
                     url: '<%=action%>'
                 }),
                 reader: new Ext.data.JsonReader({
                     root: 'result',
                     totalProperty: 'totalcount',
                       fields: ['groupname','dsporder','groupdesc','ordercontent','creator','creatorname','humreslist','id']
                 })
             });
            store.setDefaultSort('dsporder', 'asc');
			var sm=new Ext.grid.CheckboxSelectionModel();
	        sm.on('beforerowselect',function( SelectionModel, rowIndex, keepExisting,record ) {
	                   if(!(record.data.creator=='<%=BaseContext.getRemoteUser().getId()%>'))
	                   return false;
	        });
	        //402881eb0bd712c6010bd7215e7b000a
			var cm = new Ext.grid.ColumnModel([sm,
			    {header: "<%=labelService.getLabelNameByKeyId("402881e50ad58ade010ad58f1aef0001") %>",  sortable: true,  dataIndex: 'dsporder',width:30},
				{header: "<%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd7215e7b000a") %>", sortable: false, dataIndex: 'creatorname',width:50},
				{header: "<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460003") %>",  sortable: false,  dataIndex: 'groupname',width:100},
				{header: "<%=labelService.getLabelNameByKeyId("402883d934c15c570134c15c57f50000") %>", sortable: false,   dataIndex: 'groupdesc',width:220},
				{header: "<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20c0031") %>",  sortable: false, dataIndex: 'ordercontent',width:80},
				{header: "<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bccbcd445003a") %>",  sortable: false, dataIndex: 'humreslist',width:270}
			]);
            cm.defaultSortable = true;
			var grid = new Ext.grid.GridPanel({
				region: 'center',
				store: store,
				cm: cm,
				trackMouseOver:false,
				sm:sm ,
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
				},
				bbar: new Ext.PagingToolbar({
				pageSize: 20,
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
			store.on('load',function(st,recs){
				for(var i=0;i<recs.length;i++){
					var reqid=recs[i].get('id');
					for(var j=0;j<selected.length;j++){
						if(reqid ==selected[j]){
							 sm.selectRecords([recs[i]],true);
						}
					}
				}
			});
			sm.on('rowselect',function(selMdl,rowIndex,rec ){
				var reqid=rec.get('id');
				for(var i=0;i<selected.length;i++){
					if(reqid ==selected[i]){
						 return;
					 }
				 }
				selected.push(reqid)
			});
			sm.on('rowdeselect',function(selMdl,rowIndex,rec){
				var reqid=rec.get('id');
				for(var i=0;i<selected.length;i++){
					if(reqid ==selected[i]){
						selected.remove(reqid)
						 return;
					 }
				 }
			});
             //Viewport
			var viewport = new Ext.Viewport({
                 layout: 'border',
                 items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
             });
             store.baseParams.selectItemId='<%=selectItemId%>';
             store.baseParams.objname='<%=objname%>';
             store.load({params:{start:0, limit:20}});
             dlg0 = new Ext.Window({
				 layout:'border',
				 closeAction:'hide',
				 plain: true,
				 modal :true,
				 width:viewport.getSize().width*0.8,
				 height:viewport.getSize().height*0.8,
				 buttons: [{text     : '<%=labelService.getLabelName("取消")%>',
				 handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
               }
			 },{
			 text     : '<%=labelService.getLabelName("关闭")%>',
			 handler  : function(){
				 dlg0.hide();  
				 dlg0.getComponent('dlgpanel').setSrc('about:blank');
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
		dlg0.render(Ext.getBody());                 
     });
</script>
<div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
<!--页面菜单结束-->   
<form action="<%= request.getContextPath()%>/base/security/sysgroup/sysGroupList.jsp" name="EweaverForm"  method="post">
   <input type="hidden" name="searchName" value="">
   <table id=searchTable>
       <tr>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20c002e") %><!-- 组类型 -->:
		 </td>                  
         <td class="FieldValue"width="15%">
		     <select class="inputstyle" id="selectItemId" name="selectItemId" onChange="javascript:onSearch();">
                  <option value="1" <%if(selectItemId.equals("1")){%>selected<%}%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050002") %><!-- 公共组 --></option>
                  <option value="2" <%if(selectItemId.equals("2")){%>selected<%}%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050003") %><!-- 私有组 --></option>
           </select>
         </td>
         <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460003") %><!-- 组名 -->:
		 </td>
    	<td width="80%" class="FieldValue" >&nbsp;<input class="infoinput" id="inputText" name = "inputText" type="text" size="30" value="<%=objname%>">
    	</td><!-- 搜索 -->
     </tr>            
   </table>
   </div>
</form>    
<SCRIPT language="javascript"> 
function onCreate(url){
  openchild("<%= request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+url);
} 
function onSearch(){ 
    var selectItemId = document.getElementById("selectItemId").value;
	var createCmp = Ext.getCmp('C');
	var deleteCmp = Ext.getCmp('D');
	if (parseInt(selectItemId) == 1) {
		if (!<%=isAdmin%>) {
			createCmp.setVisible(false);
			deleteCmp.setVisible(false);
		}
	} else {
		createCmp.setVisible(true);
		deleteCmp.setVisible(true);
	}
    var objname = document.getElementById("inputText").value;
    store.baseParams.objname = objname;
    store.baseParams.selectItemId = selectItemId;
    store.load({params:{start:0, limit:20}}); 
}
 function openchild(url)
 {
   this.dlg0.getComponent('dlgpanel').setSrc("<%=request.getContextPath()%>"+url);
   this.dlg0.show();
 }
 function onDelete()
 {
     if (selected.length == 0) {
         Ext.Msg.buttonText={ok:'<%=labelService.getLabelName("确定")%>'};
         Ext.MessageBox.alert('', '<%=labelService.getLabelName("请选择操作项为X的内容")%>！');
         return;
     }
     Ext.Msg.buttonText={yes:'<%=labelService.getLabelName("是")%>',no:'<%=labelService.getLabelName("否")%>'};
     Ext.MessageBox.confirm('', '<%=labelService.getLabelName("您确定要删除吗")%>?', function (btn, text) {
         if (btn =='yes') {
             Ext.Ajax.request({
                 url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysGroupAction?action=delete',
                 params:{ids:selected.toString()},
                 success: function(res) {
                       selected = [];
                	   store.reload();

                 }
             });
         }
     });

 }
</SCRIPT>     
  </body>
</html>
