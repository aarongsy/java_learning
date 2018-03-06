<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   List<Selectitem> selectitemlist = selectitemService.getSelectitemList("402881ea0b8bf8e3010b8bfc850b0009",null);//角色类型 
   
   String listroletypestr="";
   for (Selectitem selectitem : selectitemlist) {
		if (listroletypestr.equals(""))
			listroletypestr += "['" + selectitem.getId() + "'," + "'"
					+ selectitem.getObjname() + "']";
		else
			listroletypestr += ",['" + selectitem.getId() + "'," + "'"
					+ selectitem.getObjname() + "']";
	}
   
   String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=getsysrolelist";
   String action2=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=getuserrolelinklist";
   String action3=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=getrolepermslink";
%>
<html>
  <head>
  <style type="text/css">
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
     .x-panel-btns-ct {
          padding: 0px;
      }
     .x-panel-btns-ct table {width:0}
  </style>
  <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/ux/css/columnLock.css"/>
	<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
	<script language="javascript">
	Ext.SSL_SECURE_URL='about:blank';
    Ext.LoadMask.prototype.msg='加载...';
	
    var viewPort;
	var roleId;
	var dlg0;
	
	var roleTypeStore = new Ext.data.SimpleStore({
        id:0,
        fields: ['value', 'text'],
        data : [<%=listroletypestr%>]
    });
	
	var grid;
	var store;
	var selected=new Array();
	
	var grid2;
	var store2;
	var selected2=new Array();
	
	var grid3;
	var store3;
	var selected3=new Array();
	
    var tb=new Ext.Toolbar();
    
	Ext.onReady(function(){
		Ext.QuickTips.init();
        
		initRole();
		initRoleUser();
		initRolePermslink();
		
		var panel = new Ext.Panel({
			region: 'center',
			layout: 'border',
			border: false,
			items: [grid2,grid3]
	    });
		
		viewPort=new Ext.Viewport({
			renderTo:Ext.getBody(),
			layout: 'border',
			items: [grid,panel]
		});
		
        Ext.getCmp('roleTypeId').setValue('402881ea0b8bf8e3010b8bfd2885000a');
        
		loadRole();
        loadRoleUser();
        loadRolePermslink();
        
        dlg0 = new Ext.Window({
               layout:'border',
               closeAction:'hide',
               plain: true,
               modal :true,
               width:viewPort.getSize().width*0.8,
               height:viewPort.getSize().height*0.8,
               buttons: [
               {text     : '取消',
	               handler  : function() {
	                   dlg0.hide();
	                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
	               }
	           },{
	             text     : '关闭',
	             handler  : function(){
	                 dlg0.hide();  
	                 dlg0.getComponent('dlgpanel').setSrc('about:blank');
	                 store.load({params:{start:0, limit:20}});
	           }}],
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
		  grid3.render(grid2);
	})
	
	function initRole(){
		store = new Ext.data.Store({
	        proxy: new Ext.data.HttpProxy({
	            url: '<%=action%>'
	        }),
	        remoteSort:true,
	        reader: new Ext.data.JsonReader({
	            root: 'result',
	            totalProperty: 'totalcount',
	            fields: ['rolename','member','permission','id']
	        })
	    });
		var sm=new Ext.grid.CheckboxSelectionModel({
			renderer:function(v,c,r){
				/* 因为编辑要依赖checkbox选中，故注释此代码，改为在删除操作中做判断
				if(r.data.id=='402881e50bf0a737010bf0a96ba70004' ||
			          r.data.id=='402881e50bf0a737010bf0b021bb0006' ||
			          r.data.id=='402881e50bf0a737010bf0b7db070008'){
			       	  return "<div><input type='checkbox' disabled style='margin-left:-2px;'/></div>";
			    }else{
			    	  return "<div class=\"x-grid3-row-checker\"></div>";   
			    }*/
			    return "<div class=\"x-grid3-row-checker\"></div>";   
			}
			});
			sm.on('beforerowselect',function( SelectionModel, rowIndex, keepExisting,record ) {
				/*
			       if(record.data.id=='402881e50bf0a737010bf0a96ba70004' ||
			          record.data.id=='402881e50bf0a737010bf0b021bb0006' ||
			          record.data.id=='402881e50bf0a737010bf0b7db070008'){
			       	  return false;
			       }
				*/
			}
	    )
	    
	    var cm = new Ext.grid.ColumnModel([sm,{header: "角色名称",remoteSort:true,   dataIndex: 'rolename'}]);
	    cm.defaultSortable = true;
	    var bb=
	    grid = new Ext.grid.GridPanel({
	        region: 'west',
	        store: store,
	        cm: cm,
	        width:400,
	        trackMouseOver:false,
	        collapsible: true,
            collapseMode:'mini',
            split:true,
            layout:'accordion',
	        sm:sm ,
	        loadMask: true,
	        viewConfig: {
	            forceFit:true,
	            enableRowBody:true,
	            sortAscText:'升序',
	            sortDescText:'降序',
	            columnsText:'列定义',
	            getRowClass : function(record, rowIndex, p, store){
	                return 'x-grid3-row-collapsed';
	            }
	        },
	        tbar:[
	        {
			    text:'<%=labelService.getLabelName("402881eb0bcbfd19010bcc7bf4cc0028")%>(C)',
		        alt:true,
		        iconCls:Ext.ux.iconMgr.getIcon('accept'),
		        handler:onCreate2
		    },
		    {
			    text:'<%=labelService.getLabelName("402881e70b774c35010b7750a15b000b")%>(E)',
		        alt:true,
		        iconCls:Ext.ux.iconMgr.getIcon('application_form_edit'),
		        handler:onModifyRole
		    },
		    {
			    text:'删除(D)',
		        alt:true,
		        iconCls:Ext.ux.iconMgr.getIcon('delete'),
		        handler:onDelete
		    },
			new Ext.form.ComboBox({
				id:'roleTypeId',
		        typeAhead: true,
		        triggerAction: 'all',
		        store:roleTypeStore,
		        mode: 'local',
		        valueField:'value',
		        displayField:'text',
		        lazyRender:true,
		        listClass: 'x-combo-list-small',
		        hiddenName:'roleType',
		        width:80,
		        listeners:{
				'select':onSearch
		        }}),
	        new Ext.form.Label({
	        	text:'名称:'
	        }),
	        {
	        	xtype:'textfield',
	        	fieldLabel:'<%=labelService.getLabelName("402881eb0bcbfd19010bcca8f4b90035")%>',
	        	width:80,
	        	name:'inputText'
	        },
	        {
			    text:'<%=labelService.getLabelName("40288035249ddfdb01249e0985720006")%>(S)',
		        alt:true,
		        iconCls:Ext.ux.iconMgr.getIcon('zoom'),
		        handler:onSearch
		    }],
	        bbar: new Ext.PagingToolbar({
	           pageSize: 20,
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
	       }),
	       listeners:{
	        	'rowclick':function(obj,rowIndex,e){
		        	var record=obj.getStore().getAt(rowIndex);
		       		roleId=record.get('id');
		       		loadRoleUser();
		       		loadRolePermslink();
		        }
	       }
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
	}
	
	function initRoleUser(){
		store2 = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=action2%>'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
                 fields: ['humresname','orgunitname','id']
           })
       });
		
		var sm=new Ext.grid.CheckboxSelectionModel();
        sm.on('beforerowselect',function( SelectionModel, rowIndex, keepExisting,record ) {
            if(record.data.humresname=='sysadmin'
            	&&(roleId=="402881e50bf0a737010bf0a96ba70004"||roleId=="402881e50bf0a737010bf0b021bb0006"||roleId=="402881e50bf0a737010bf0b7db070008"))
       		return false;
        })
        var cm = new Ext.grid.ColumnModel([sm, {header: "对象名称",  sortable: true,  dataIndex: 'humresname'},
                    {header: "角色级别", sortable: true,   dataIndex: 'orgunitname'}
        ]);
        cm.defaultSortable = true;
        grid2 = new Ext.grid.GridPanel({
        	region:'center',
            store: store2,
            cm: cm,
            trackMouseOver:false,
            sm:sm ,
            loadMask: true,
            viewConfig: {
                forceFit:true,
                enableRowBody:true,
                sortAscText:'升序',
                sortDescText:'降序',
                columnsText:'列定义',
                getRowClass : function(record, rowIndex, p, store){
                    return 'x-grid3-row-collapsed';
                }
            },
            bbar: new Ext.PagingToolbar({
                 pageSize: 20,
		      store: store2,
		      displayInfo: true,
		      beforePageText:"第",
		      afterPageText:"页/{0}",
		      firstText:"第一页",
		      prevText:"上页",
		      nextText:"下页",
		      lastText:"最后页",
		      displayMsg: '显示 {0} - {1}条记录 / {2}',
		      emptyMsg: "没有结果返回"
		  }),
		  tbar:[{
			    text:'<%=labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")%>人员(S)',
		        alt:true,
		        iconCls:Ext.ux.iconMgr.getIcon('accept'),
		        handler:onModifyUser
		  },{
			    text:'<%=labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")%>岗位(S)',
		        alt:true,
		        iconCls:Ext.ux.iconMgr.getIcon('accept'),
		        handler:onModifyStation
		  },{
			    text:'删除(D)',
		        alt:true,
		        iconCls:Ext.ux.iconMgr.getIcon('delete'),
		        handler:onDeleteRoleUser
		  }]
		});
        store2.on('load',function(st,recs){
            for(var i=0;i<recs.length;i++){
                var reqid=recs[i].get('id');
            	for(var j=0;j<selected2.length;j++){
                        if(reqid ==selected2[j]){
                             sm.selectRecords([recs[i]],true);
                         }
                     }
        		}
          	}
         );
        
		sm.on('rowselect',function(selMdl,rowIndex,rec ){
		    var reqid=rec.get('id');
		    for(var i=0;i<selected2.length;i++){
                if(reqid ==selected2[i]){
                     return;
                 }
             }
		    selected2.push(reqid)
		});
		
        sm.on('rowdeselect',function(selMdl,rowIndex,rec){
            var reqid=rec.get('id');
            for(var i=0;i<selected2.length;i++){
               if(reqid ==selected2[i]){
                   selected2.remove(reqid)
                   return;
                }
            }
		});
	}
	
	function initRolePermslink(){
		store3 = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=action3%>'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
               fields: ['operation','permdesc','id']
           })
       });
		
		var sm=new Ext.grid.CheckboxSelectionModel();
        sm.on('beforerowselect',function( SelectionModel, rowIndex, keepExisting,record ) {
                   if(record.data.humresname=='sysadmin')
       		return false;
        })
        var cm = new Ext.grid.ColumnModel([sm, {header: "权限名称",  sortable: true,  dataIndex: 'operation'},
                    {header: "权限描述", sortable: true,   dataIndex: 'permdesc'}
        ]);
        cm.defaultSortable = true;
        grid3 = new Ext.grid.GridPanel({
        	region:'south',
            store: store3,
            cm: cm,
            height:300,
            trackMouseOver:false,
            sm:sm ,
            loadMask: true,
            collapsible: true,
            collapseMode:'mini',
            split:true,
            layout:'accordion',
            viewConfig: {
                forceFit:true,
                enableRowBody:true,
                sortAscText:'升序',
                sortDescText:'降序',
                columnsText:'列定义',
                getRowClass : function(record, rowIndex, p, store){
                    return 'x-grid3-row-collapsed';
                }
            },
            bbar: new Ext.PagingToolbar({
              pageSize: 20,
		      store: store3,
		      displayInfo: true,
		      beforePageText:"第",
		      afterPageText:"页/{0}",
		      firstText:"第一页",
		      prevText:"上页",
		      nextText:"下页",
		      lastText:"最后页",
		      displayMsg: '显示 {0} - {1}条记录 / {2}',
		      emptyMsg: "没有结果返回"
		  }),
		  tbar:[{
			    text:'<%=labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")%>(N)',
		        alt:true,
		        iconCls:Ext.ux.iconMgr.getIcon('add'),
		        handler:addRolePermslink
		  },{
			    text:'<%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%>(D)',
		        alt:true,
		        iconCls:Ext.ux.iconMgr.getIcon('delete'),
		        handler:deleteRolePermslink
		  }]
		});
        store3.on('load',function(st,recs){
            for(var i=0;i<recs.length;i++){
                var reqid=recs[i].get('id');
            	for(var j=0;j<selected3.length;j++){
                        if(reqid ==selected3[j]){
                             sm.selectRecords([recs[i]],true);
                         }
                     }
        		}
          	}
         );
        
		sm.on('rowselect',function(selMdl,rowIndex,rec ){
		    var reqid=rec.get('id');
		    for(var i=0;i<selected3.length;i++){
                if(reqid ==selected3[i]){
                     return;
                 }
             }
		    selected3.push(reqid)
		});
		
        sm.on('rowdeselect',function(selMdl,rowIndex,rec){
            var reqid=rec.get('id');
            for(var i=0;i<selected3.length;i++){
               if(reqid ==selected3[i]){
                   selected3.remove(reqid)
                   return;
                }
            }
		});
	}
	
	function loadRole(){
		store.baseParams.selectItemId='402881ea0b8bf8e3010b8bfd2885000a';
        store.baseParams.objname='';
        store.load({params:{start:0, limit:20}});
	}
	
	function loadRoleUser(){
    	store2.baseParams.roleId=roleId;
  		store2.load({params:{start:0, limit:20}});
	}
	
	function loadRolePermslink(){
    	store3.baseParams.roleId=roleId;
  		store3.load({params:{start:0, limit:20}});
	}
	
	function onCreate2(){
		var roleType=Ext.get('roleType').getValue();
		var url='/base/security/sysrole/sysrolecreate.jsp?objtype='+roleType;
		dlg0.getComponent('dlgpanel').setSrc("<%=request.getContextPath()%>"+url);
		dlg0.show();
	}
	
	function onCreate(url,flag){
		if (flag == "1")
			url += "?objtype=" + document.all("selectItemId").value;
		dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
		dlg0.show();
	}
	
	function onSearch(){
    	var roleType=Ext.get('roleType').getValue();
		var objname = document.all("inputText").value;
    	store.baseParams.selectItemId=roleType;
    	store.baseParams.objname = objname;
    	store.load({params:{start:0, limit:20}});
    	selected = [];
	}
	
	function getRoleNameById(id){
		var roleName = "";
		if(store){
			store.each(function(rec){
				if(rec.get("id") == id){
					roleName = rec.get("rolename");
					return false;
				}
			});
		}
		return roleName;
	}
	
	function onDelete(){
          if (selected.length == 0) {
              Ext.Msg.buttonText={ok:'确定'};
              Ext.MessageBox.alert('', '请选择要删除的内容！');
              return;
          }
          var isContainSysRole = false;
          for(var i = 0; i < selected.length; i++){
        	  if(selected[i] == "402881e50bf0a737010bf0a96ba70004" ||
			         selected[i] == "402881e50bf0a737010bf0b021bb0006" ||
			          selected[i] == "402881e50bf0a737010bf0b7db070008" ||
			          selected[i] == "402881e43b7023de013b7023e39d0000"){
        		  Ext.Msg.buttonText={ok:'确定'};
	              Ext.MessageBox.alert('', getRoleNameById(selected[i]) + ' 不能被删除！');
	              return;
			  }
          }
          Ext.Msg.buttonText={yes:'是',no:'否'};                   
          Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
              if (btn == 'yes') {
                  Ext.Ajax.request({
                      url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=deleteext',
                      params:{ids:selected.toString()},
                      success: function() {
                          selected = [];
                          onSearch();
                      }
                  });
              } else {
                  selected = [];
                  onSearch();
              }
          });
      }
	
	function onModifyRole(){
		if (selected.length == 0) {
			Ext.Msg.buttonText={ok:'确定'};
			Ext.MessageBox.alert('', '请选择角色！');
			return;
        }
		onCreate('/base/security/sysrole/sysrolemodify.jsp?id=' + selected[0] , '0');
	}
	
	function onModifyUser(){
		if(typeof(roleId)=="undefined"){
			Ext.MessageBox.alert('','请选择角色！');
			return;
		}else{
			var url='/base/security/sysrole/userrolelinkcreate.jsp?roleId='+roleId;
	    	openDialog("<%= request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+url,window);
    		loadRoleUser();
		}
    }
	
	function onModifyStation(){
		if(typeof(roleId)=="undefined"){
			Ext.MessageBox.alert('','请选择角色！');
			return;
		}else{
			var url='/base/security/sysrole/stationrolelinkcreate.jsp?roleId='+roleId;
	    	openDialog("<%= request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+url,window);
    		loadRoleUser();
		}
	}
	
	function onDeleteRoleUser(){
		if(selected2.length==0){
              Ext.Msg.buttonText={ok:'确定'};                                                                       
              Ext.MessageBox.alert('', '请选择要删除的内容！');
              return;
        }
        Ext.Msg.buttonText={yes:'是',no:'否'};
        Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
            if (btn == 'yes') {
                Ext.Ajax.request({
                    url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.UserroleAction?action=delete',
                    params:{ids:selected2.toString()},
                    success: function() {
                         loadRoleUser();
                    }
                });
            } else {
                  loadRoleUser();
            }
        });
	}
	
	function addRolePermslink(){
		if(typeof(roleId)=="undefined"){
			Ext.MessageBox.alert('','请选择角色！');
			return;
		}else{
			var url="/base/security/sysperms/syspermsbrowserm.jsp";
			var ids;
	        try{
	        	ids=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+url);
	        }catch(e){}
	        if (ids!=null) {
	           if(ids[0]!='0'){
	               Ext.Ajax.request({
                      url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=addrolepermslink',
                      params:{ids:ids[0],roleid:roleId},
                      success: function() {
                           loadRolePermslink();
                      }
                  });
	           }
	        }
	    }
	}
	
	function deleteRolePermslink(){
		if(selected3.length==0){
              Ext.Msg.buttonText={ok:'确定'};                                                                       
              Ext.MessageBox.alert('', '请选择要删除的内容！');
              return;
        }
        Ext.Msg.buttonText={yes:'是',no:'否'};
        Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
            if (btn == 'yes') {
                Ext.Ajax.request({
                    url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=deleterolepermslink',
                    params:{ids:selected3.toString(),roleid:roleId},
                    success: function() {
                         loadRolePermslink();
                    }
                });
            } else {
                  loadRolePermslink();
            }
        });
	}
	
	$(document).keydown(function(event) {
		if (event.keyCode == 13) {
		   onSearch();
		}
	});
	</script>
  </head>
  <body>
  </body>
</html>
