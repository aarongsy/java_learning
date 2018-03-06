<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ include file="/base/init.jsp" %>
<%
SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
String fileRootPath = setitemService.getSetitem("402881e80b7544bb010b754c7cd8000a").getItemvalue();
fileRootPath=StringHelper.replaceString(fileRootPath, "\\", "/");
String devid=StringHelper.null2String(request.getParameter("devid"));
String contextpath="";
DataService ds =new  DataService();
String devno=ds.getValue("select leavefactoryno from uf_device_equipment where requestid='"+devid+"'");
%>
<html>
<head>
<link rel="Stylesheet" type="text/css" href="Ext2.2/data-view.css" />
		<link rel="stylesheet" type="text/css" href="Ext2.2/resources/css/ext-all.css" />
		<link rel="stylesheet" href="Ext.ux.UploadDialog/UploadDialog/css/Ext.ux.UploadDialog.css" />
		<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/xtheme-stategrid.css" />
		<link rel="stylesheet" type="text/css" href="/js/highslide/highslide.css" />
		<script src="Ext2.2/ext-base.js"></script>
		<script src="Ext2.2/ext-all.js"></script>
		

		<script src="Ext2.2/ext-lang-zh_CN.js"></script>
		<script src="Ext2.2/data-view-plugins.js"></script>
		<script type="text/javascript" src="Ext.ux.UploadDialog/Ext.ux.UploadDialog.packed.js"></script>
		
		<script type="text/javascript">
		Ext.onReady(function(){
		   Ext.QuickTips.init();
		   var store = new Ext.data.JsonStore({
		       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.customaction.ft.devImageAction?action=dataViewImages&devno=<%=devno%>',
		       root: 'images',
		       fields: ['name', 'url', {name:'size', type: 'float'}]
		   });
		   store.load();
		
	       var tpl = new Ext.XTemplate(
		    '<tpl for=".">',
	               '<div class="thumb-wrap" id="{name}">',
		        '<div class="thumb"><a href="{url}" target="_blank"><img src="{url}" title="{name}"></a></div>',
		        '<span class="">{shortName}</span>',
		        '<span>{sizeString}</span>',
		        '</div>', 
	           '</tpl>',
	           '<div class="x-clear"></div>'
		    );
		    
		       var customEl;
		       var ResizableExample = {
		           init: function(){
		               var custom = new Ext.Resizable('custom', {
		                   wrap:true,
		                   pinned:true,
		                   minWidth:150,
		                   minHeight: 150,
		                   preserveRatio: true,
		                   handles: 'all',
		                   draggable:true,
		                   dynamic:true
		               });
		               customEl = custom.getEl();
		               document.body.insertBefore(customEl.dom, document.body.firstChild);
		               
		               /*customEl.on('dblclick', function(){
		                   customEl.hide(true);
		               });
		               customEl.hide();*/
		               
		           }
		       };
		
		      // Ext.EventManager.onDocumentReady(ResizableExample.init, ResizableExample, true);
		    1111111111111
		    var dataview = new Ext.DataView({
		           store: store,
		           id: "dv",
		           tpl: tpl,
		           autoHeight:true,
		           multiSelect: true,
		           overClass:'x-view-over',
		           itemSelector:'div.thumb-wrap',
		           emptyText: 'No images to display',
		
		           plugins: [
		               new Ext.DataView.DragSelector()
		           ],
		
		           prepareData: function(data){
		               data.shortName = Ext.util.Format.ellipsis(data.name, 15);
		               data.sizeString = Ext.util.Format.fileSize(data.size);
		               return data;
		           },
		           
		           listeners: {
		       	    selectionchange: {
		       		    fn: function(dv,nodes){
		       			    var l = nodes.length;
		       			    var s = '';
		       			    panel.setTitle('<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec713003d") %> ('+l+' <%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec713003e") %>'+s+' <%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec713003f") %>)');//图片列表  项  被选中
		       		    }
		       	    },
		       	    'dblclick': function(){
		       	        var selNode = dataview.getSelectedNodes()[0];
		       	        var i = document.getElementById("resourceimg");
		       	        i.src = "/ServiceAction/com.eweaver.customaction.ft.devImageAction?action=showimage&src=<%=fileRootPath%>/device/<%=devno%>/"+selNode.id;
						getImageResult(i);
		       	        
		       	        //customEl.center();
		                   //customEl.show(true);
		       	    }
		           }
		       });
		
		       var panel = new Ext.Panel({
		           id:'images-view',
		           frame:false,
		           width:535,
		           autoHeight:false,
		           collapsible:true,
		           layout:'fit',
		           title:'<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec713003d") %>(0 <%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec713003e") %> <%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec713003f") %>)<font color=red><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7130040") %></font>',//设备图片请控制在200KB以内（JPG格式）！
		           tbar:[
		               {text: "<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7130041") %>", handler: insertImages}, "-",//添加图片
		               {text: "<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7130042") %>", handler: deleteImages}//删除图片
		           ],
		           butttonAlign: "left",
		           tools: [{
		               id:"refresh",
		               qtip:"<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7130043") %>",//刷新图片列表
		               on:{click:function(){
		   	                panel.body.mask("<%=labelService.getLabelNameByKeyId("402883d934c1f9d80134c1f9d9620000") %>...", 'x-mask-loading');//加载中
		   	                 store.reload();
							 panel.body.unmask();
		   	                /*setTimeout(function(){
		   	                   
		       	                
		   	                }, 1000);*/
		                }
		               }
		           }],
		           items: dataview
		       });
		       panel.render(Ext.getBody());
		       
		       function insertImages()
		       {
		           dialog = new Ext.ux.UploadDialog.Dialog({
		                 url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.customaction.ft.upImageAction?devno=<%=devno%>',
			          width : 450,
			          height : 300,
			          minWidth : 450,
			          minHeight : 300,
			          draggable : true,
			          resizable : true,
			          modal: true,
		                 reset_on_hide: false,
		                 allow_close_on_upload: false,  
		                 upload_autostart: false 
		               });
		               
		           dialog.show('show-button');
		       }
		       
		       function deleteImages()
		       {
		           var count = dataview.getSelectionCount();
		           var nodes = "";
		           
		           if(count == 0)
		           {
		               Ext.Msg.show({
		                   title:"<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7140044") %>",//提示框
		                   msg:"<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7140045") %>",//请选择要删除的图片
		                   buttons:Ext.MessageBox.OK , 
		                   icon:Ext.MessageBox.INFO
		               });
		               
		               return false;
		           }
		           
		           for(var i = 0; i < count; i++)
		           {
		               nodes += dataview.getSelectedNodes()[i].id;
		               if(i < count -1){
		               	nodes += ",";
		               }
		           }
		           Ext.Msg.confirm("<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7140044") %>","<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7140046") %>",function(button){ //提示框       你确认删除所选图片吗
		               if (button == "yes")
		               {
		                   Ext.MessageBox.show({
		                       msg:"<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7140047") %>",//删除中,请等待...
		                       progress:true,
		                       progressText: '<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7140048") %>',//删除中...
		                       width:300,
		                       wait:true,
		                       waitConfig:{
		                             interval:100,
		                             duration:1000,
		                             fn:function(){
		                                 Ext.Ajax.request({
		                                     url: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.customaction.ft.devImageAction?action=deleteImages&devno=<%=devno%>",
		                                     params: {
		                                         "Nodes": nodes
		                                     },
		                                     callback: function(options, success, response)
		                                     {
		                                         if(success)
		                                         {
		                                              /*Ext.Msg.show({
		                                                  title:"提示框",
		                                                  msg:"删除图片成功",
		                                                  buttons:Ext.MessageBox.OK , 
		                                                  icon:Ext.MessageBox.INFO,
		                                                  fn:function(){
		                                                      
		                                                  }
		                                              });*/
													  store.reload();
		                                         }
		                                         else
		                                         {
		                                              Ext.Msg.show({
		                                                  title:"<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7140044") %>",//提示框
		                                                  msg:"<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7140049") %>",//删除图片失败, 请重试
		                                                  buttons:Ext.MessageBox.OK , 
		                                                  icon:Ext.MessageBox.WARNING
		                                              });   
		                                         }
		                                     }
		                                 });
		                                 
		                                 Ext.MessageBox.hide();
		                       }},
		                       closable:true
		                   });
		               }
		           });
		       }
		   });
		</script>
	</head>
	<body>
	<!-- 	<div id="div1" style="text-align:center; vertical-align:middle">
			<img id="custom"  style="width:500px" />
		</div> -->
		      <a style="display:none" id='resourceimghref' href="javascript:void(0);"
                               onclick="return getImageResult(this);" onFocus="this.blur()"> <img
                                    id='resourceimg' src="/images/base/main.gif" border=0>
                            </a>
	</body>
</html>
<script>
	function getImageResult(o)
	{
		 hs.graphicsDir = '/js/highslide/graphics/';
         hs.wrapperClassName = 'wide-border';
		hs.fadeInOut = true;
		hs.headingEval = 'this.a.title';
		var hrefimg = document.getElementById("resourceimghref").href;
		return hs.expand(o);
	}
</script>
<script type="text/javascript" src="/js/highslide/highslide.js"></script>