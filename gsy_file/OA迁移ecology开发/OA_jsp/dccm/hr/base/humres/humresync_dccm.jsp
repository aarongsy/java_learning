<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.sequence.SequenceService" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ include file="/base/init.jsp"%>
<%
String action=request.getContextPath()+"/ServiceAction/com.eweaver.app.dccm.dmhr.base.humres.DMHR_HumreSyncAction?action=search";
%>
<%
	pagemenustr +=  "addBtn(tb,'Quick Search','S','zoom',function(){onSearch()});";
	pagemenustr +=  "addBtn(tb,'Reset Condition','R','erase',function(){reset()});";
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List rolist = baseJdbcDao.executeSqlForList("select * from sysuserrolelink l,sysuser s where s.id=l.userid and l.roleid='40285a8d587f8d6b01587f9332620005' and s.objid='"+BaseContext.getRemoteUser().getId()+"'");	//新马角色-人事组织管理
	//if(rolist.size()>0){
		pagemenustr +=  "addBtn(tb,'EmpInfoSync','T','application_start',function(){syncHr()});";	//Synchronize employee infomation
		pagemenustr +=  "addBtn(tb,'EmpSchePlanSync','C','application_start',function(){syncClass()});";	 //Synchronize employee class infomation
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
                 	fields:['pernr',
                 	      	'usrid1',
                 	      	'ename',
							'rufnm',
                 	      	'persg',
                 	      	'persk',
                 	      	'orgeh',
                 	      	'plans',
							'trfar',
							'trfgb',
							'trfgr',
							'trfst',
                 	      	'stext',
							'sachz',
                 	      	'zzck2',
                 	      	'aufnr',
                 	      	'ltext',
                 	      	'gesch',
                 	      	'gbdat',
                 	      	'famst',
                 	      	'slart',
                 	      	'stext1',
                 	      	'usrid',
                 	      	'cmdata',
                 	      	'wkdata',
                 	      	'icnum',
                 	      	'ltext1',
							'zzsel',
							'cttyp',
							'ctstart',
							'ctend']
                 	})

             });
             //store.setDefaultSort('id', 'desc');
             var sm;
			sm=new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
    		 sm=new Ext.grid.CheckboxSelectionModel();
		
			var cm = new Ext.grid.ColumnModel([sm,
			                               {header:'SAPEmpId',dataIndex:'pernr',hidden:false,width:30,sortable:true},
			                               {header:'Employee No.',dataIndex:'usrid1',hidden:false,width:30,sortable:true},
			                               {header:'Employee Name',dataIndex:'ename',hidden:false,width:70,sortable:true},
			                               {header:'Nickname',dataIndex:'rufnm',hidden:false,width:30,sortable:true},
										   {header:'Emp Group',dataIndex:'persg',hidden:false,width:20,sortable:true},
			                               {header:'Emp Sub-Group',dataIndex:'persk',hidden:false,width:20,sortable:true},
			                               {header:'OrgSAPId',dataIndex:'orgeh',hidden:false,width:30,sortable:true},
			                               {header:'PositionSAPId',dataIndex:'plans',hidden:false,width:30,sortable:true}, //职位编码
			                               {header:'Pay Scale Area',dataIndex:'trfar',hidden:true,width:30,sortable:true}, //区域
										   {header:'Pay Scale Group',dataIndex:'trfgb',hidden:true,width:30,sortable:true}, //职称分类
			                               {header:'BasicPayStructure',dataIndex:'trfgr',hidden:true,width:30,sortable:true}, //职称			                               
										   {header:'Pay Scale Level',dataIndex:'trfst',hidden:true,width:30,sortable:true}, //职级			                               
										   {header:'Job Title',dataIndex:'stext',hidden:false,width:70,sortable:true}, //职位描述
										   {header:'Time Administrator',dataIndex:'sachz',hidden:true,width:30,sortable:true},			                               
										   //{header:'顶岗学生标记',dataIndex:'zzck2',hidden:true,width:30,sortable:true},
			                               {header:'Emp SAP Inner Order',dataIndex:'zzauf',hidden:true,width:30,sortable:true}, //内部订单号
			                               {header:'CostCenterbName',dataIndex:'ltext',hidden:true,width:30,sortable:true}, //成本中心文本
			                               {header:'Gentle	',dataIndex:'gesch',hidden:false,width:20,sortable:true},
			                               {header:'Date of Birth',dataIndex:'gbdat',hidden:false,width:30,sortable:true},			                               
										   {header:'Marital Status',dataIndex:'famst',hidden:true,width:30,sortable:true}, //婚姻状况			                               
										   {header:'State/Provice of Birth',dataIndex:'gbort',hidden:true,width:30,sortable:true},//籍贯			                               
										   {header:'EE Code',dataIndex:'slart',hidden:true,width:30,sortable:true}, //学历编码 教育机构代码
			                               {header:'Educ Est Text',dataIndex:'stext1',hidden:false,width:30,sortable:true}, //学历描述 教育机构名称			                               
										   {header:'Phone No',dataIndex:'usrid',hidden:true,width:30,sortable:true}, //手机号码			                               
										   {header:'Date of Join Company',dataIndex:'cmdata',hidden:false,width:30,sortable:true},			                               
										   //{header:'计算工龄日期',dataIndex:'wkdata',hidden:false,width:30,sortable:true},			                               
										   {header:'I/C No	',dataIndex:'icnum',hidden:true,width:30,sortable:true}, //身份证			                               
										   {header:'Race	',dataIndex:'ltext1',hidden:false,width:30,sortable:true}, //民族
										   {header:'Safe Level',dataIndex:'zzsel',hidden:false,width:30,sortable:true},
										   {header:'Contract Type',dataIndex:'cttyp',hidden:true,width:30,sortable:true},
										   {header:'Contract Start at',dataIndex:'ctstart',hidden:true,width:30,sortable:true},
										   {header:'Contract End at',dataIndex:'ctend',hidden:true,width:30,sortable:true}
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
        var reqid=rec.get('usrid1');
        for(var i=0;i<selected.length;i++){
                    if(reqid == selected[i]){
                         return;
                     }
                 }
        selected.push(reqid);
    }
            );
    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        var reqid=rec.get('usrid1');
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
         title: "plese select 'Start At' and 'End At'",   //导入时间区间选择
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
                     {fieldLabel: "Start At", 
                    	id: "ks",
                    	listeners : {
                         "focus" : function() {
                        	 WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'js\')}'});
             }}},      
                     {fieldLabel: "End At",
            	 		id:"js",
            	 		listeners : {
                         "focus" : function() {
                        	 WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'ks\')}',maxDate:'#F{$dp.$D(\'ks\',{d:90})}'});
							 //WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'ks\')}',maxDate:'#F{$dp.$D(\'ks\',{d:30})}'});
             }}}
     		] 
             }
           ]              
        }], 
         buttons:[  
             {text:"Sync",handler:function(){   
                var ks = Ext.getCmp("ks").getValue();
            	var js = Ext.getCmp("js").getValue();
            	if(ks==""){
            		$("#msg").html("Please select \'Start At\'!");
            	}else if(js==""){
            		$("#msg").html("Please select \'End At\'!");
            	}else if(ks>js){
            		$("#msg").html("\'End At\' must be later than \'Start At\'");
            	}else{
            		$("#kssj").val(ks);
            		$("#jssj").val(js);
            		win.hide();
        	   		myMask1.show();
        	   		//setTimeout(syncDo('<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.sap.orgunit.ClassSyncAction',false),1000);
					syncClassDo('<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.dccm.dmhr.base.humres.DMHR_ClassSyncAction',false);
            	}
             }},
			 {text:"Sync Force",handler:function(){   
                var ks = Ext.getCmp("ks").getValue();
            	var js = Ext.getCmp("js").getValue();
            	if(ks==""){
            		$("#msg").html("Please select \'Start At\'!");
            	}else if(js==""){
            		$("#msg").html("Please select \'End At\'!");
            	}else if(ks>js){
            		$("#msg").html("\'End At\' must be later than \'Start At\'");
            	}else{
            		$("#kssj").val(ks);
            		$("#jssj").val(js);
            		win.hide();
        	   		myMask1.show();
        	   		//setTimeout(syncDo('<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.sap.orgunit.ClassSyncAction',true),1000);
					syncClassDo('<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.dccm.dmhr.base.humres.DMHR_ClassSyncAction',true);
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
 		<col width="24%">
 		<col width="8%">
 		<col width="24%">
 		<col width="8%">
 		<col width="24%">
 	</colgroup>
   <tr>
 	<td  class="FieldName" nowrap>Employee No</td>
    <td  class="FieldValue"  nowrap>
           <input type=text class=inputstyle style="width:40%" name="usrid_low" id="usrid_low" value="" > - 
           <input type=text class=inputstyle style="width:40%" name="usrid_high" id="usrid_high" value="" >
           <input type="hidden" name="kssj" id="kssj" value="" > 
           <input type="hidden" name="jssj" id="jssj" value="" >
    </td>
    <td  class="FieldName" nowrap>Date of Join</td>
    <td  class="FieldValue"  nowrap>
           <input type=text class=inputstyle style="width:40%" name="date_low" id="date_low" value="" onfocus="WdatePicker({dateFmt:'yyyyMMdd'})"> - 
           <input type=text class=inputstyle style="width:40%" name="date_high" id="date_high" value="" onfocus="WdatePicker({dateFmt:'yyyyMMdd'})">
    </td>
    <td class="FieldName" colspan=2 nowrap></td>
	</tr>
 </table>
<input type="hidden" id="tmprequestid" value="">
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
	  var tmpflag = false;
      for(var i=0;i<o.length;i++) {
          if(o[i].value!=null&&o[i].value!=""){
          	data[o[i].name]=o[i].value;
			tmpflag = true;
          }
      }
	  if(!tmpflag){
		alert('please input condition \'Employee No\' or \'Date of join\' at first!')
	  }else{
	   store.baseParams=data;
       store.baseParams.datastatus='';
       store.baseParams.isindagate='';
       store.load({params:{start:0, limit:20}});
       selected = [];
	  }
  }
   var myMask1 = new Ext.LoadMask(document.body, {msg:'<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320021")%>',removeMask:true});//请稍等,数据加载中...
   function syncHr(){
		if(<%=rolist.size() %>==0) {
			alert('You do not have permission!');   
		}else if(selected.length<1){
		 	alert('Please select the employee at first!');
	   	}else{
	   		myMask1.show();
	   		//setTimeout(syncDo('<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.dccm.dmhr.base.humres.DMHR_HumreSyncAction'),1000);
			syncDo('<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.dccm.dmhr.base.humres.DMHR_HumreSyncAction');
   	   	}
   }
   function syncClass(){
		if(<%=rolist.size() %>==0) {
			alert('You do not have permission!');   
		}else if(selected.length<1){
		 	alert('Please select the employee at first!'); //未选中行数据
	   	}else{
	        win.show(); 
	   	}
   }
   function syncDo(surl){
	   try{
			DWREngine.setAsync(false);//设置为同步获取数据
			var myMask = new Ext.LoadMask(Ext.getBody(), {  
				msg: "synchronizing, please wait...",  //正在同步
				removeMask: true   
			});  
			myMask.show();
			Ext.Ajax.request({
				async:true,
				url: surl,
				params: {
				 jsonstr : selected+"" ,
				 action : "synchronous",
				 kssj	: jQuery("#kssj").val(),
				 jssj	: jQuery("#jssj").val()	    	     
				 //配置传到后台的参数
				},
				success: function(response){
					//myMask.hide();  
					alert(response.responseText);					
				},
				failure: function(){
				 Ext.Msg.show({
				  title: 'Error Message', //错误提示
				  msg: 'error, unable access to database!', //访问数据库时发生错误!
				  buttons: Ext.Msg.OK,
				  icon: Ext.Msg.ERROR
				 });
				}
			   }); 
			myMask.hide();  
			DWREngine.setAsync(true);//设置为同步获取数据
	   }catch(e){
		   alert(e);
	   }
   }
   
   function syncClassDo(surl,force){
	   try{
		   var myMask = new Ext.LoadMask(Ext.getBody(), {  
		        msg: "synchronizing, please wait...",  //正在同步
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
	    	     jssj	: $("#jssj").val(),
				 force	: force+"" 
	    	     //配置传到后台的参数
	    	    },
				dataType:'json', 
	    	    success: function(response){
	    	    	myMask.hide(); 
					
					var info = "";
					var passpsn = "";
					var failpsn = "";
					for(var ccpno in response){
						var msg = response[ccpno];
						//var success = msg.success;
						var success = msg['success'];
						if(success=='1'){
							//info += ccpno+':同步成功!\n';
							passpsn += ccpno+',';
						}else{
							//info += ccpno+':同步失败!'+msg.info+'\n';
							//info += ccpno+':同步失败!'+msg['info']+'\n';
							failpsn +=ccpno+':'+msg['info']+',';
						}
					}
					//if(passpsn!=''){
						//info = "同步班表成功人员："+passpsn+'\n';
					//}
					if(failpsn!=''){
						info = info+"Fail Employees:"+failpsn+'\n';
					}	
					if(failpsn!=''){
						alert('Result:'+$("#kssj").val()+'-'+$("#jssj").val()+' Force='+force+':\n'+info);	
					}else{
						alert('Result:'+$("#kssj").val()+'-'+$("#jssj").val()+' Force='+force+' successfully!' );
					}
	    	    	//alert("同步成功！"); 
	    	    	//alert(response.responseText);
	    	    },
	    	    failure: function(){
	    	     myMask.hide();  
				 alert("Sync fail, please retry!");
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

   
 </script>  
  </body>
</html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  