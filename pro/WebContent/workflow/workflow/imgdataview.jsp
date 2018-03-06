<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserrolelinkService" %>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService" %>
<%@ page import="com.eweaver.base.security.model.Sysuser" %>
<%@ page import="com.eweaver.base.security.model.Sysuserrolelink" %>


<html>
     <%

          SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
   SysuserrolelinkService sysuserrolelinkService = (SysuserrolelinkService) BaseContext.getBean("sysuserrolelinkService");
   boolean issysadmin = false;
   String humresroleid = "402881e50bf0a737010bf0a96ba70004";//系统管理员角色id
   Sysuser sysuser = new Sysuser();
   Sysuserrolelink sysuserrolelink  = new Sysuserrolelink();
   sysuser = sysuserService.getSysuserByObjid(currentuser.getId());
   issysadmin = sysuserrolelinkService.isRole(humresroleid,sysuser.getId());
         String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.stamp.servlet.StampAction?action=getimags";
         if(issysadmin) {
             pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290049")+"','N','add',function(){onAdd()});";//添加
         }
         String userid=StringHelper.null2String(request.getParameter("userid"));
     %>


  <head>
  <style type="text/css">
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
      .t1 {
              cursor: pointer;   }
  </style>
      <script src='/dwr/interface/DataService.js'></script>
      <script src='/dwr/engine.js'></script>
	  <script src='/dwr/util.js'></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/AutoRefresher.js"></script>
      <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
  <script type="text/javascript">
      var store;
      var dlg0;
      Ext.onReady(function(){
             Ext.QuickTips.init();
       <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
       <%}%>
          var xd = Ext.data;
            store = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=action%>'
           }),
           reader: new Ext.data.JsonReader({
               root: 'images',
               fields: ['name', 'url', {name:'size', type: 'float'}, {name:'lastmod', type:'date', dateFormat:'timestamp'},'id', 'isdefault', 'style']
           })

       });
         store.baseParams.userid='<%=userid%>';
          store.load();

          var tpl = new Ext.XTemplate(
              '<tpl for=".">',
                  '<div class="thumb-wrap" id="{name}">',
                  '<div class="thumb"><img name="isdefault" id="{id}" style="{style}" src="{url}" title="{name}{isdefault}" onclick="setIsdefault(\'{id}\')"></div>',
                  '<span class="x-editable">{shortName}</span>',
                         <%if(issysadmin){%>
                  '<span class="x-editable"><a onclick="del(\'{id}\')" class="t1" imgid="{id}">删除</a></span> ',
                     <%}%>
                          '</div>',
              '</tpl>',
              '<div class="x-clear"></div>'
          );

          var panel = new Ext.Panel({
              id:'images-view',
              frame:true,
              width:1053,
              autoHeight:true,
              collapsible:true,
              layout: 'fit',
              items: new Ext.DataView({
                  store: store,
                 region: 'center',
                  tpl: tpl,
                  autoHeight:true,
                  multiSelect: true,
                  overClass:'x-view-over',
                  itemSelector:'div.thumb-wrap',
                  emptyText: '<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a005d") %>',//没有章印 请与管理员联系！

                 /* plugins: [
                      new Ext.DataView.DragSelector(),
                      new Ext.DataView.LabelEditor({dataIndex: 'name'})
                  ],*/

                  prepareData: function(data){
                    //  data.shortName = Ext.util.Format.ellipsis(data.name, 15);
                      data.imgid=data.id;
                      data.sizeString = Ext.util.Format.fileSize(data.size);
                      data.dateString = data.lastmod.format("m/d/Y g:i a");
                      return data;
                  }
              })
          });
         panel.render(document.body);
          var imgform=Ext.get('imgform');
        dlg0 = new Ext.Window({
          closable:true,
            plain: false,
           collapsible:true,
           width:400,
           height:200,
           closeAction:'hide',
           buttons: [{
               text     : '确定',
               handler  : function() {
                   FCKEditorExt.updateContent();
                     Ext.Ajax.request({
                              url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.stamp.servlet.StampAction',
                            isUpload:true,
                            form:imgform,
                        success: function() {
                                  dlg0.hide();
                                  store.load({params:{start:0, limit:20}});
                              },
                              params: { action:'upload',userid:'<%=userid%>'}
                          });                                                                                                  

               }

           },{text     : '取消',
               handler  : function() {
                   dlg0.hide();
                   
               }
           }],
           items:new Ext.Panel({
                    region:'center',
                    autoScroll:true,
                    html:Ext.get('imgdiv').dom.innerHTML
                })

       });
       dlg0.render(Ext.getBody());
      });
     Ext.DataView.LabelEditor = function(cfg, field){
          Ext.DataView.LabelEditor.superclass.constructor.call(this,
          field || new Ext.form.TextField({
                  allowBlank: true,
                  growMin:90,
                  growMax:240,
                  grow:true,
                  disable:true,
                  selectOnFocus:true
              }), cfg
          );
      };

      Ext.extend(Ext.DataView.LabelEditor, Ext.Editor, {
          alignment: "tl-tl",
          hideEl : false,
          cls: "x-small-editor",
          shim: false,
          completeOnEnter: true,
          cancelOnEsc: true,
          labelSelector: 'span.x-editable',

          init : function(view){
              this.view = view;
              view.on('render', this.initEditor, this);
              this.on('complete', this.onSave, this);
          },

          initEditor : function(){
              this.view.getEl().on('mousedown', this.onMouseDown, this, {delegate: this.labelSelector});
          },

          onMouseDown : function(e, target){
              if(!e.ctrlKey && !e.shiftKey){
                  var item = this.view.findItemFromChild(target);
                  e.stopEvent();
                  var record = this.view.store.getAt(this.view.indexOf(item));
                  this.startEdit(target, record.data[this.dataIndex]);
                  this.activeRecord = record;
              }else{
                  e.preventDefault();
              }
          },

          onSave : function(ed, value){
              this.activeRecord.set(this.dataIndex, value);
          }
      });


      Ext.DataView.DragSelector = function(cfg){
          cfg = cfg || {};
          var view, regions, proxy, tracker;
          var rs, bodyRegion, dragRegion = new Ext.lib.Region(0,0,0,0);
          var dragSafe = cfg.dragSafe === true;

          this.init = function(dataView){
              view = dataView;
              view.on('render', onRender);
          };

          function fillRegions(){
              rs = [];
              view.all.each(function(el){
                  rs[rs.length] = el.getRegion();
              });
              bodyRegion = view.el.getRegion();
          }

          function cancelClick(){
              return false;
          }

          function onBeforeStart(e){
              return !dragSafe || e.target == view.el.dom;
          }

          function onStart(e){
              view.on('containerclick', cancelClick, view, {single:true});
              if(!proxy){
                  proxy = view.el.createChild({cls:'x-view-selector'});
              }else{
                  proxy.setDisplayed('block');
              }
              fillRegions();
              view.clearSelections();
          }

          function onDrag(e){
              var startXY = tracker.startXY;
              var xy = tracker.getXY();

              var x = Math.min(startXY[0], xy[0]);
              var y = Math.min(startXY[1], xy[1]);
              var w = Math.abs(startXY[0] - xy[0]);
              var h = Math.abs(startXY[1] - xy[1]);

              dragRegion.left = x;
              dragRegion.top = y;
              dragRegion.right = x+w;
              dragRegion.bottom = y+h;

              dragRegion.constrainTo(bodyRegion);
              proxy.setRegion(dragRegion);

              for(var i = 0, len = rs.length; i < len; i++){
                  var r = rs[i], sel = dragRegion.intersect(r);
                  if(sel && !r.selected){
                      r.selected = true;
                      view.select(i, true);
                  }else if(!sel && r.selected){
                      r.selected = false;
                      view.deselect(i);
                  }
              }
          }

          function onEnd(e){
              if(proxy){
                  proxy.setDisplayed(false);
              }
          }

          function onRender(view){
              tracker = new Ext.dd.DragTracker({
                  onBeforeStart: onBeforeStart,
                  onStart: onStart,
                  onDrag: onDrag,   
                  onEnd: onEnd
              });
              tracker.initEl(view.el);
          }
      };

  </script>
  </head>
     <%
      if(issysadmin){
     %>
     <div id="pagemenubar" style="width:1053px"></div>
     <%}%>
  <body>

  <div id="imgdiv" style="display:none">
<form action="" id="imgform" name="imgform" method="post" >
  <table>
          <tr>
              <td><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a005e") %><!-- 选择图片 -->：</td>
                <td><input type="file" name="imgfile" id="imgfile" value="" ></td>
          </tr>

      </table>
      <br>
     <b><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e") %><!-- 说明 -->：</b><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a005f") %><!-- 此图片为管理员添加的盖章章印，请妥善添加！！！ -->
</form>

  </div>
  </body>
<script type="text/javascript">
    function onAdd(){
      this.dlg0.show();
    }
    function del(objId){
        Ext.Ajax.request({
            url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.stamp.servlet.StampAction',
            success: function() {
                store.load({params:{start:0, limit:20}});
            },
            params: { action:'del',imgid:objId}
        });

    }
    
    function setIsdefault(id){
    	//document.getElementById(id).style.border="solid 3px white";
    	var imgs=document.getElementsByName("isdefault");
    	for(var v=0;v<imgs.length;v++){
    	   //  alert(imgs[0].id);
    		if(imgs[v].id==id){
    			imgs[v].style.border="solid 5px white";
    		}
    		else{
    			imgs[v].style.border="";
    		}
    	}
    	var sql1="update imginfo set isdefault=1 where id='"+id+"'";
    	DataService.executeSql(sql1,function(data){
    		if(data && data>-1){
    			return true;
    		}
    	});
    	var sql2="update imginfo set isdefault=0 where userid='<%=userid %>' and id<>'"+id+"'";
    	DataService.executeSql(sql2,function(data){
    		if(data && data>-1){
    			alert("该图片设置默认成功！");
    			return true;
    		}
    	});
    }
</script>
</html>
