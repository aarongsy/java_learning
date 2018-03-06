<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.calendar.base.model.CalendarSetting"  %>
<%@ page import="com.eweaver.calendar.base.service.SchedulesetService" %>
<%@ page import="com.eweaver.calendar.base.model.Scheduleset" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%
 String action = request.getContextPath()+"/ServiceAction/com.eweaver.calendar.base.servlet.CalendarAction?action=getsharesetting";
 String formid = request.getParameter("formid");
  pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','C','add',function(){onPopup('"+request.getContextPath()+"/calendar/modifysetting.jsp?formid="+formid+"')});";
    	  pagemenustr +="addBtn(tb,'删除','D','delete',function(){onDelete()});";
 %>
	<head>
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
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
		<title>共享日程设置</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<script type="text/javascript">
		var store;
   		var dlg0;
   		var selected = new Array();
		Ext.onReady(function() {
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
               fields: ['objname','shareLevelName','shareObj','shareObjnames','securitylevel','view','id']
           })
       });
       var sm = new Ext.grid.CheckboxSelectionModel();

       var cm = new Ext.grid.ColumnModel([sm, {header: "共享类型", sortable: false,  dataIndex: 'objname'},
           {header: "共享级别", sortable: false,   dataIndex: 'shareLevelName'},
           {header: "共享对象类型",  sortable: false, dataIndex: 'shareObj'},
           {header: "共享对象",  sortable: false, dataIndex: 'shareObjnames'},
           {header: "安全级别",  sortable: false, dataIndex: 'securitylevel'},
           {header: "操作",  sortable: false, dataIndex: 'view'}
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
                                    sortAscText:'升序',
                                    sortDescText:'降序',
                                    columnsText:'列定义',
                                    getRowClass : function(record, rowIndex, p, store){
                                        return 'x-grid3-row-collapsed';
                                    }
                                },
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
                 })

       });
         //Viewport
       store.on('load',function(st,recs){
              for(var i=0;i<recs.length;i++){
                  var reqid=recs[i].get('id');
              for(var j=0;j<selected.length;j++){
                          if(reqid ==selected[j]){
                               sm.selectRecords([recs[i]],true);
                           }
                       }
          }
          }
                  );
          sm.on('rowselect',function(selMdl,rowIndex,rec ){
              var reqid=rec.get('id');
              for(var i=0;i<selected.length;i++){
                          if(reqid ==selected[i]){
                               return;
                           }
                       }
              selected.push(reqid)
          }
                  );
          sm.on('rowdeselect',function(selMdl,rowIndex,rec){
              var reqid=rec.get('id');
              for(var i=0;i<selected.length;i++){
                          if(reqid ==selected[i]){
                              selected.remove(reqid)
                               return;
                           }
                       }

          }
                  );


       var viewport = new Ext.Viewport({
           layout: 'border',
           items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
       });
       store.load({params:{start:0, limit:20}});
       dlg0 = new Ext.Window({
           layout:'border',
           closeAction:'hide',
           plain: true,
           modal :true,
           width:viewport.getSize().width * 0.8,
           height:viewport.getSize().height * 0.8,
           buttons: [{text     : '取消',
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
               }
           },{
               text     : '关闭',
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
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
       dlg0.render(Ext.getBody());
       
		})		
		</script>
	</head>
	<%
	 
	 %>
	<body>
	<div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>
  </div>
	</body>
	<script type="text/javascript">  
	 function onPopup(url){
         //document.EweaverForm.submit();
          this.dlg0.getComponent('dlgpanel').setSrc(url);
          this.dlg0.show()
     }
	
	  function onModify(url){
        this.dlg0.getComponent('dlgpanel').setSrc(url+'&formid=<%=formid%>');
        this.dlg0.show()   
      }
          function onDelete()
               {
                   if (selected.length == 0) {
                       Ext.Msg.buttonText={ok:'确定'};
                       Ext.MessageBox.alert('', '请选择要删除的内容！');
                       return;
                   }
                   Ext.Msg.buttonText={yes:'是',no:'否'};
                   Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
                       if (btn == 'yes') {
                           Ext.Ajax.request({
                               url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.calendar.base.servlet.CalendarAction?action=delete',
                               params:{ids:selected.toString()},
                               success: function() {

                                   selected = [];
                                   store.load({params:{start:0, limit:20}});

                               }
                           });
                       }
                   });

               }	
	function onSubmit() {
		EweaverForm.submit();
	}
	function changebtn(value) {
		var btn1 = document.getElementById('shareobjbtn1');
		var btn2 = document.getElementById('shareobjbtn2');
		var btn3 = document.getElementById('shareobjbtn3');
		var shareobjid = document.getElementById('shareobjid');
		var shareobjidspan = document.getElementById('shareobjidspan');
		if(value == 1) {
			btn1.style.display='';
			btn2.style.display='none';
			btn3.style.display='none';
		}
		if(value == 2) {
			btn1.style.display='none';
			btn2.style.display='';
			btn3.style.display='none';
		}
		if(value == 3) {
			btn1.style.display='none';
			btn2.style.display='none';
			btn3.style.display='';
		}
		if(value == 4) {
			btn1.style.display='none';
			btn2.style.display='none';
			btn3.style.display='none';
		}
		shareobjid.value='';
		shareobjidspan.innerHTML='';
	}
	  function getrefobj(inputname,inputspan,refid,viewurl,isneed){
     /* if(inputname.substring(3,(inputname.length-6))){
            if(document.getElementById(inputname.substring(3,(inputname.length-6))))
     document.getElementById(inputname.substring(3,(inputname.length-6))).value="";
        }
        if(document.getElementById(inputname.replace("field","input"))!=null)
     document.getElementById(inputname.replace("field","input")).value="";*/
        // 先暂时把这段代码   给注释掉 因为此代码影响了 EWTS-000790 bug  by肖肖
	var idsin = document.getElementsByName(inputname)[0].value;
	var id;
    if(Ext.isIE){
    try{
         var url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
                url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid;
            }
    id=openDialog(url);
    }catch(e){return}
    if (id!=null) {

    if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];

    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
    }else{
    url='<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
    var callback = function() {
            try {
                id = dialog.getFrameWindow().dialogValue;
            } catch(e) {
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
                        document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

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
                    defaultSrc:url,
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
</script>
</html>
