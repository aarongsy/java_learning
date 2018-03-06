<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>


<html>
 <%
     String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.stamp.servlet.StampAction?action=getimags";
 %>

  <head>
  <style type="text/css">
      #img-chooser-dlg .details{
          padding: 10px;
          text-align: center;
      }
      #img-chooser-dlg .details-info{
          border-top: 1px solid #cccccc;
          font: 11px Arial, Helvetica, sans-serif;
          margin-top: 5px;
          padding-top: 5px;
          text-align: left;
      }
      #img-chooser-dlg .details-info b{
          color: #555555;
          display: block;
          margin-bottom: 4px;
      }
      #img-chooser-dlg .details-info span{
          display: block;
          margin-bottom: 5px;
          margin-left: 5px;
      }

      #img-chooser-view{
          background: white;
          font: 11px Arial, Helvetica, sans-serif;
      }
      #img-chooser-view .thumb{
          background: #dddddd;
          padding: 3px;
      }
      #img-chooser-view .thumb img{
          height: 60px;
          width: 80px;
      }
      #img-chooser-view .thumb-wrap{
          float: left;
          margin: 4px;
          margin-right: 0;
          padding: 5px;
      }
      #img-chooser-view .thumb-wrap span{
          display: block;
          overflow: hidden;
          text-align: center;
      }
      #img-chooser-view .x-view-over{
          border:1px solid #dddddd;
          //background: #efefef url(../../resources/images/default/grid/row-over.gif) repeat-x left top;
          padding: 4px;
      }
      #img-chooser-view .x-view-selected{
          background: #DFEDFF;
          border: 1px solid #6593cf;
          padding: 4px;
      }
      #img-chooser-view .x-view-selected .thumb{
          background:transparent;
      }
      #img-chooser-view .x-view-selected span{
          color:#1A4D8F;
      }
      #img-chooser-view .loading-indicator {
          font-size:11px;
       //   background-image:url('../../resources/images/grid/loading.gif');
          background-repeat: no-repeat;
          background-position: left;
          padding-left:20px;
          margin:10px;
      }
      
  </style>
    
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/AutoRefresher.js"></script>
      <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
  <script type="text/javascript">
      var ImageChooser = function(config){
    this.config = config;
}

ImageChooser.prototype = {
    // cache data by image name for easy lookup
    lookup : {},

    show : function(el, callback){
        if(!this.win){
            this.initTemplates();

            this.store = new Ext.data.JsonStore({
                url: this.config.url,
                root: 'images',
                fields: [
                    'name', 'url',
                    {name:'size', type: 'float'},
                    {name:'lastmod', type:'date', dateFormat:'timestamp'}
                ],
                listeners: {
                    'load': {fn:function(){ this.view.select(0); }, scope:this, single:true}
                }
            });
            this.store.load();

            var formatSize = function(data){
                if(data.size < 1024) {
                    return data.size + " bytes";
                } else {
                    return (Math.round(((data.size*10) / 1024))/10) + " KB";
                }
            };

            var formatData = function(data){
                data.shortName = data.name.ellipse(15);
                data.sizeString = formatSize(data);
                data.dateString = new Date(data.lastmod).format("m/d/Y g:i a");
                this.lookup[data.name] = data;
                return data;
            };

            this.view = new Ext.DataView({
                tpl: this.thumbTemplate,
                singleSelect: true,
                overClass:'x-view-over',
                itemSelector: 'div.thumb-wrap',
                emptyText : '<div style="padding:10px;">No images match the specified filter</div>',
                store: this.store,
                listeners: {
                    'selectionchange': {fn:this.showDetails, scope:this, buffer:100},
                    'dblclick'       : {fn:this.doCallback, scope:this},
                    'loadexception'  : {fn:this.onLoadException, scope:this},
                    'beforeselect'   : {fn:function(view){
                        return view.store.getRange().length > 0;
                    }}
                },
                prepareData: formatData.createDelegate(this)
            });

            var cfg = {
                title: 'Choose an Image',
                id: 'img-chooser-dlg',
                layout: 'border',
                minWidth: 500,
                minHeight: 300,
                modal: true,
                closeAction: 'hide',
                border: false,
                items:[{
                    id: 'img-chooser-view',
                    region: 'center',
                    autoScroll: true,
                    items: this.view,
                    tbar:[{
                        text: 'Filter:'
                    },{
                        xtype: 'textfield',
                        id: 'filter',
                        selectOnFocus: true,
                        width: 100,
                        listeners: {
                            'render': {fn:function(){
                                Ext.getCmp('filter').getEl().on('keyup', function(){
                                    this.filter();
                                }, this, {buffer:500});
                            }, scope:this}
                        }
                    }, ' ', '-', {
                        text: 'Sort By:'
                    }, {
                        id: 'sortSelect',
                        xtype: 'combo',
                        typeAhead: true,
                        triggerAction: 'all',
                        width: 100,
                        editable: false,
                        mode: 'local',
                        displayField: 'desc',
                        valueField: 'name',
                        lazyInit: false,
                        value: 'name',
                        store: new Ext.data.SimpleStore({
                            fields: ['name', 'desc'],
                            data : [['name', 'Name'],['size', 'File Size'],['lastmod', 'Last Modified']]
                        }),
                        listeners: {
                            'select': {fn:this.sortImages, scope:this}
                        }
                    }]
                },{
                    id: 'img-detail-panel',
                    region: 'east',
                    split: true,
                    width: 150,
                    minWidth: 150,
                    maxWidth: 250
                }],
                buttons: [{
                    id: 'ok-btn',
                    text: 'OK',
                    handler: this.doCallback,
                    scope: this
                },{
                    text: 'Cancel',
                    handler: function(){ this.win.hide(); },
                    scope: this
                }],
                keys: {
                    key: 27, // Esc key
                    handler: function(){ this.win.hide(); },
                    scope: this
                }
            };
            Ext.apply(cfg, this.config);
            this.win = new Ext.Window(cfg);
        }

        this.reset();
        this.win.show(el);
        this.callback = callback;
        this.animateTarget = el;
    },

    initTemplates : function(){
        this.thumbTemplate = new Ext.XTemplate(
            '<tpl for=".">',
                '<div class="thumb-wrap" id="{name}">',
                '<div class="thumb"><img src="{url}" title="{name}"></div>',
                '<span>{shortName}</span></div>',
            '</tpl>'
        );
        this.thumbTemplate.compile();

        this.detailsTemplate = new Ext.XTemplate(
            '<div class="details">',
                '<tpl for=".">',
                    '<img src="{url}"><div class="details-info">',
                    '<b>Image Name:</b>',
                    '<span>{name}</span>',
                    '<b>Size:</b>',
                    '<span>{sizeString}</span>',
                    '<b>Last Modified:</b>',
                    '<span>{dateString}</span></div>',
                '</tpl>',
            '</div>'
        );
        this.detailsTemplate.compile();
    },

    showDetails : function(){
        var selNode = this.view.getSelectedNodes();
        var detailEl = Ext.getCmp('img-detail-panel').body;
        if(selNode && selNode.length > 0){
            selNode = selNode[0];
            Ext.getCmp('ok-btn').enable();
            var data = this.lookup[selNode.id];
            detailEl.hide();
            this.detailsTemplate.overwrite(detailEl, data);
            detailEl.slideIn('l', {stopFx:true,duration:.2});
        }else{
            Ext.getCmp('ok-btn').disable();
            detailEl.update('');
        }
    },

    filter : function(){
        var filter = Ext.getCmp('filter');
        this.view.store.filter('name', filter.getValue());
        this.view.select(0);
    },

    sortImages : function(){
        var v = Ext.getCmp('sortSelect').getValue();
        this.view.store.sort(v, v == 'name' ? 'asc' : 'desc');
        this.view.select(0);
    },

    reset : function(){
        if(this.win.rendered){
            Ext.getCmp('filter').reset();
            this.view.getEl().dom.scrollTop = 0;
        }
        this.view.store.clearFilter();
        this.view.select(0);
    },

    doCallback : function(){
        var selNode = this.view.getSelectedNodes()[0];
        var callback = this.callback;
        var lookup = this.lookup;
        this.win.hide(this.animateTarget, function(){
            if(selNode && callback){
                var data = lookup[selNode.id];
                callback(data);
            }
        });
    },

    onLoadException : function(v,o){
        this.view.getEl().update('<div style="padding:10px;">Error loading images.</div>');
    }
};

String.prototype.ellipse = function(maxLength){
    if(this.length > maxLength){
        return this.substr(0, maxLength-3) + '...';
    }
    return this;
    };
      Ext.onReady(function(){
          var chooser, btn;

          function insertImage(data){
              Ext.DomHelper.append('images', {
                  tag: 'img', src: data.url, style:'margin:10px;visibility:hidden;'
              }, true).show(true).frame();
              btn.focus();
          };

          function choose(btn){
              if(!chooser){
                  chooser = new ImageChooser({
                      url:'<%=action%>',
                      width:515,
                      height:350
                  });
              }
              chooser.show(btn.getEl(), insertImage);
          };

          btn = new Ext.Button({
              text: "Insert Image",
              handler: choose,
              renderTo: 'buttons'
          });
      });

  </script>
  </head>

  <body>
    <div id="buttons" style="margin:20px;"></div>
    <div id="images" style="margin:20px;width:600px;"></div>
  </body>
</html>
