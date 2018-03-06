<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.sequence.SequenceService" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ include file="/base/init.jsp"%>
<%
String action=request.getContextPath()+"/ServiceAction/com.eweaver.app.sap.orgunit.ClassSyncAction?action=search";
%>
<%
	pagemenustr +=  "addBtn(tb,'快捷搜索','S','zoom',function(){onSearch()});";
	pagemenustr +=  "addBtn(tb,'重置条件','R','erase',function(){reset()});";
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List rolist = baseJdbcDao.executeSqlForList("select * from sysuserrolelink l,sysuser s where s.id=l.userid and l.roleid='8a8ad0a03d76e071013d7b26edf802f5' and s.objid='"+BaseContext.getRemoteUser().getId()+"'");
	//if(rolist.size()>0){
		//pagemenustr +=  "addBtn(tb,'人员信息同步','T','erase',function(){syncHr()});";	
		pagemenustr +=  "addBtn(tb,'人员排班信息同步','C','erase',function(){syncClass()});";	
	//}
	Humres currentHumres = BaseContext.getRemoteUser().getHumres();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
      <style type="text/css">
            .x-toolbar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
      #pagemenubar table {width:0}
  </style>
	
	<script src='/dwr/interface/DataService.js'></script>
	<script src='/dwr/engine.js'></script>
	<script src='/dwr/util.js'></script>
	<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>

   <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
   
         <script language="javascript">
          Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320021")%>';//加载中,请稍后...
             var store;
             var selected=new Array();
             var dlg0;
                   Ext.onReady(function(){
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
                       //fields: ['VBELN_VL','POSNR_VL','VBELN_VA']
                 	fields:['OBJNO',
                 	      	'SAPNO',
                 	      	'OBJNAME',
                 	      	'ORG',
                 	      	'STA',
                 	      	'ZU',
                 	      	'ZIZU']
                 	})

             });
             //store.setDefaultSort('id', 'desc');
             var sm;
			sm=new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
    		 sm=new Ext.grid.CheckboxSelectionModel();
		
			var cm = new Ext.grid.ColumnModel([sm,
			                               {header:'CCP编号',dataIndex:'OBJNO',hidden:false,width:30,sortable:true},
			                               {header:'SAP编号',dataIndex:'SAPNO',hidden:false,width:30,sortable:true},
			                               {header:'姓名',dataIndex:'OBJNAME',hidden:false,width:30,sortable:true},
			                               {header:'所属部门',dataIndex:'ORG',hidden:false,width:90,sortable:true},
			                               {header:'职位',dataIndex:'STA',hidden:false,width:30,sortable:true},
			                               {header:'员工组',dataIndex:'ZU',hidden:false,width:30,sortable:true},
			                               {header:'员工子组',dataIndex:'ZIZU',hidden:false,width:30,sortable:true}
			         ]);       
             cm.defaultSortable = true;
                            var grid = new Ext.grid.GridPanel({
                                region: 'center',
                                store: store,
                                cm: cm,
                                sm:sm ,
                                trackMouseOver:false,
                                  loadMask: true,
                                viewConfig: {
                                    forceFit:true,
                                    enableRowBody:true,
                                    sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                                    sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                                    columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                                    getRowClass : function(record, rowIndex, p, store){
                                        return 'x-grid3-row-collapsed';
                                    }//-------------给报表grid添加左右滚动条start-----------
                                    , scrollOffset: -3 , //去掉右侧空白区域  
          					     layout : function() {
          					      if (!this.mainBody) {
          					       return; // not rendered
          					      }
          					      var g = this.grid;
          					      var c = g.getGridEl();
          					      var csize = c.getSize(true);
          					      var vw = csize.width;
          					      var vh=csize.height;
          					      if (!g.hideHeaders && (vw < 20 || csize.height < 20)) { // display:
          					       // none?
          					       return;
          					      }
          					      if (g.autoHeight) {
          					       this.el.dom.style.width = "100%";
          					       
          					       //计算grid高度
          					       var girdcount=store.getCount();
          					             var gridHeight=0;
          					       for(var i=0;i<girdcount;i++){
          					           gridHeight=gridHeight+grid.getView().getRow(i).clientHeight;
          					        } 
          					       this.el.dom.style.height =gridHeight+75;//75是菜单栏和分页栏高度和
          					       
          					       this.el.dom.style.overflowX = "auto"; //只显示横向滚动条
          					
          					      } else {
          					       this.el.setSize(csize.width, csize.height);
          					       var hdHeight = this.mainHd.getHeight();
          					       var vh = csize.height - (hdHeight);
          					       this.scroller.setSize(vw, vh);
          					       if (this.innerHd) {
          					        this.innerHd.style.width = (vw) + 'px';
          					       }
          					      }
          					      if (this.forceFit) {
          					       if (this.lastViewWidth != vw) {
          					        this.fitColumns(false, false);
          					        this.lastViewWidth = vw;
          					       }
          					      } else {
          					       this.autoExpand();
          					       this.syncHeaderScroll();
          					      }
          					      this.onLayout(vw, vh);
          					     } 
                                     
                                    //-------------给报表grid添加左右滚动条end-----------  
                                },
                                bbar: new Ext.PagingToolbar({
                                    pageSize: 80000,
                     store: store,
                     displayInfo: true,
                     beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
                     afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
                     firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
                     prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
                     nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
                     lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
                     displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示//条记录 
                     emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
                 })

             });

sm.on('rowselect',function(selMdl,rowIndex,rec ){
        var reqid=rec.get('OBJNO');
        for(var i=0;i<selected.length;i++){
                    if(reqid == selected[i]){
                         return;
                     }
                 }
        selected.push(reqid);
    }
            );
    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        var reqid=rec.get('OBJNO');
        for(var i=0;i<selected.length;i++){
                    if(reqid == selected[i]){
                        selected.remove(reqid);
                         return;
                     }
                 }

    }
            );



             //Viewport
         var viewport = new Ext.Viewport({
                   layout: 'border',
                 items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
             });
               //store.load({params:{start:0, limit:20}});
             dlg0 = new Ext.Window({
                         layout:'border',
                         closeAction:'hide',
                         plain: true,
                         modal :true,
                         width:viewport.getSize().width*0.8,
                         height:viewport.getSize().height*0.8,
                         buttons: [{
                             text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d")%>',//关闭
                             handler  : function(){
                                 dlg0.hide();
                                 store.load({params:{start:0, limit:20}});
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

         //onSearch();  //页面展开即首次查询
         
     Ext.override(Ext.grid.CheckboxSelectionModel, {   
            handleMouseDown : function(g, rowIndex, e){     
              if(e.button !== 0 || this.isLocked()){     
                return;     
              }     
              var view = this.grid.getView();     
              if(e.shiftKey && !this.singleSelect && this.last !== false){     
                var last = this.last;     
                this.selectRange(last, rowIndex, e.ctrlKey);     
                this.last = last; // reset the last     
                view.focusRow(rowIndex);     
              }else{     
                var isSelected = this.isSelected(rowIndex);     
                if(isSelected){     
                  this.deselectRow(rowIndex);     
                }else if(!isSelected || this.getCount() > 1){     
                  this.selectRow(rowIndex, true);     
                  view.focusRow(rowIndex);     
                }     
              }     
            }   
        });  
         
     var win = new Ext.Window({  
         title: "导入时间区间选择",  
         width:300,  
         height:160,   
         plain:true,  
         closeAction:'hide', 
         layout:"form",      
         defaultType:"textfield",      
         labelWidth:60,      
         bodyStyle:"padding-top: 10px; padding-left:10px;",
         modal:true ,
         //defaults:{anchor:"100%"},      
         items:[{ 
             xtype: "panel" ,   
             baseCls: "x-plain" , 
             layout: "column" , 
             html: "<div style='color:red;' id='msg'></div>",
             items:[{ 
                 columnWidth:1, 
                 layout: "form", 
                 defaults:{xtype: "textfield" , width:170}, 
                 labelWidth:60, 
                 baseCls: "x-plain" ,     
                 //bodyStyle:"padding-top: 15px; padding-left:10px;",     
                 items:[ 
                     {fieldLabel: "开始时间", 
                    	id: "ks",
                    	listeners : {
                         "focus" : function() {
                        	 WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'js\')}'});
             }}},      
                     {fieldLabel: "结束时间",
            	 		id:"js",
            	 		listeners : {
                         "focus" : function() {
                        	 WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'ks\')}',maxDate:'#F{$dp.$D(\'ks\',{d:30})}'});
             }}}
     		] 
             }
           ]              
        }], 
         buttons:[  
             {text:"确认",handler:function(){   
                var ks = Ext.getCmp("ks").getValue();
            	var js = Ext.getCmp("js").getValue();
            	if(ks==""){
            		$("#msg").html("开始时间不能为空！");
            	}else if(js==""){
            		$("#msg").html("结束时间不能为空！");
            	}else if(ks>js){
            		$("#msg").html("开始时间不能大于结束时间！");
            	}else{
            		$("#kssj").val(ks);
            		$("#jssj").val(js);
            		win.hide();
        	   		myMask1.show();
        	   		setTimeout(syncDo('<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.sap.orgunit.ClassSyncAction'),1000);
            	}
             }}
        ]  
     });  
          </script>
  </head> 
  <body>

		
<!--页面菜单开始-->     

<div id="divSearch">
 <div id="pagemenubar"></div>
 <form id="EweaverForm" name="EweaverForm" action="<%=action%>">
 <table>
 	<colgroup>
 		<col width="8%">
 		<col width="16%">
 		<col width="8%">
 		<col width="16%">
 		<col width="8%">
 		<col width="36%">
 	</colgroup>
   <tr>
 	<td  class="FieldName" nowrap>CCP编号</td>
    <td  class="FieldValue"  nowrap>
           <input type=text class=inputstyle style="width:88%" name="ccpno" id="ccpno" value="" >
    </td>
    <td  class="FieldName" nowrap>SAP编号</td>
    <td  class="FieldValue"  nowrap>
           <input type=text class=inputstyle style="width:88%" name="sapno" id="sapno" value="" >
    </td>
    <td  class="FieldName" nowrap>所属部门</td>
    <td  class="FieldValue"  nowrap>
<button class=Browser type=button onclick="getrefobj('orgid','orgspan','402881e60bfee880010bff17101a000c','','/base/orgunit/orgunitview.jsp?id=','0');"></button>
<input type="hidden" id="orgid" name="orgid" value="">
<span id="orgspan"></span>
<input type="checkbox" name="isroot" value="0"  onclick="checkroot(this)" >
    </td>
	</tr>
 </table>
<input type="hidden" id="tmprequestid" value="">
<input type="hidden" id="kssj" value="">
<input type="hidden" id="jssj" value="">
</form>
</div>
<script language="javascript">
		   
   function onDetail(id){
     var url="<%= request.getContextPath()%>/app/attendance/attendanceDetail.jsp?id=8a8adbb73a632823013a635214e10008";
	 onUrl(url,'考勤详细列表','tab_8a8adbb73a632823013a635214e10008');                                                                                 
   }
   function onSearch(){

	  var $ = jQuery;
      var o=$('#EweaverForm').serializeArray();
      var data={};
      for(var i=0;i<o.length;i++) {
          if(o[i].value!=null&&o[i].value!=""){
          	data[o[i].name]=o[i].value;
          }
      }
	   store.baseParams=data;
       store.baseParams.datastatus='';
       store.baseParams.isindagate='';
       store.load({params:{start:0, limit:20}});
       selected = [];
  }
   var myMask1 = new Ext.LoadMask(document.body, {msg:'系统加载中，请稍后......',removeMask:true});//请稍等,数据加载中...
   function syncHr(){
	   	if(selected.length<1){
		 	alert("未选中行数据!");
	   	}else{
	   		myMask1.show();
	   		setTimeout(syncDo('<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.sap.orgunit.HumreSyncAction'),1000);
   	   	}
   }
   function syncClass(){
		if(selected.length<1){
		 	alert("未选中行数据!");
	   	}else{
	        win.show(); 
	   	}
   }
   function syncDo(surl){
	   try{
		   var myMask = new Ext.LoadMask(Ext.getBody(), {  
		        msg: "正在同步,请稍后...",  
		        removeMask: true   
	        });  
        	myMask.show();
        	jQuery.ajax({
        		async:true,
	    	    url: surl,
	    	    data: {
	    	     jsonstr : selected+"" ,
	    	     action : "synchronous",
	    	     kssj	: $("#kssj").val(),
	    	     jssj	: $("#jssj").val()
	    	     //配置传到后台的参数
	    	    },
	    	    success: function(response){
	    	    	myMask.hide(); 
	    	    	alert("同步成功！"); 
	    	    	//alert(response.responseText);
	    	    },
	    	    failure: function(){
	    	     myMask.hide();  
				 alert("同步失败，请重新同步！");
	    	    }
	    	   }); 	       	       
	   }catch(e){
		   alert(e);
	   }
   }
   
   
   

   function reset(){
       $('#EweaverForm span').text('');
       $('#EweaverForm input[type=hidden]').val('');
       $('#EweaverForm input[type=text]').val('');
       $("#scope").get(0).options[0].selected = true ; 
  }

   
  jQuery(document).keydown(function(event) {
      if (event.keyCode == 13) {
         onSearch(); 
      }
  });

  var win;
	function getrefobj(inputname, inputspan, refid, viewurl, isneed) {
		if (inputname.substring(3, (inputname.length - 6))) {
			if (document.getElementById(inputname.substring(3,
					(inputname.length - 6))))
				document.getElementById(inputname.substring(3,
						(inputname.length - 6))).value = "";
		}
		if (document.getElementById(inputname.replace("field", "input")) != null)
			document.getElementById(inputname.replace("field", "input")).value = "";

		var idsin = document.getElementsByName(inputname)[0].value;
		var id;
		if (Ext.isIE) {
			try {
				var url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='
						+ refid + '&idsin=' + idsin;
				if (idsin.length > 900) { //当idsin过长时，ie的url不支持过长的地址
					url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='
							+ refid;
				}
				id = window.showModalDialog(url);
			} catch (e) {
				return
			}
			if (id != null) {

				if (id[0] != '0') {
					document.all(inputname).value = id[0];
					document.all(inputspan).innerHTML = id[1];

				} else {
					document.all(inputname).value = '';
					if (isneed == '0')
						document.all(inputspan).innerHTML = '';
					else
						document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

				}
			}
		} else {
			url = '/base/refobj/baseobjbrowser.jsp?id=' + refid + '&idsin='
					+ idsin;
			var callback = function() {
				try {
					id = dialog.getFrameWindow().dialogValue;
				} catch (e) {
				}
				if (id != null) {
					if (id[0] != '0') {
						document.all(inputname).value = id[0];
						document.all(inputspan).innerHTML = id[1];
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
					layout : 'border',
					width : Ext.getBody().getWidth() * 0.8,
					height : Ext.getBody().getHeight() * 0.8,
					plain : true,
					modal : true,
					items : {
						id : 'dialog',
						region : 'center',
						iconCls : 'portalIcon',
						xtype : 'iframepanel',
						frameConfig : {
							autoCreate : {
								id : 'portal',
								name : 'portal',
								frameborder : 0
							},
							eventsFollowFrameLinks : false
						},
						defaultSrc : url,
						closable : false,
						autoScroll : true
					}
				});
			}
			win.close = function() {
				this.hide();
				win.getComponent('dialog').setSrc('about:blank');
				callback();
			};
			win.render(Ext.getBody());
			var dialog = win.getComponent('dialog');
			dialog.setSrc(url);
			win.show();
		}
	}
	
	function checkroot(obj){
		if(obj.value == "1"){
			obj.value = "0";
		}else{
			obj.value = "1";
		}
	}
 </script>  
  </body>
</html>