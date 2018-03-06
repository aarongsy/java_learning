var contentPanel;
var ds;
Ext.onReady(function(){
   Ext.QuickTips.init();
   Ext.SSL_SECURE_URL = 'about:blank';
   Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';
   Ext.LoadMask.prototype.msg = "加载中,请稍候...";
    
   var tb = new Ext.Toolbar();
   tb.render('pagemenubar');
   addBtn(tb,'查询','O','zoom',function(){onSearch();});
   addBtn(tb,'关闭','C','delete',function(){window.parent.close();});
   
	ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: "/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelList"
        }),
        reader: new Ext.data.JsonReader({
        	root: 'result',
            totalProperty: 'totalcount',
            fields: ['id','labelname','labeltype','keyword']
        })
    });
	
	var docWidth = document.body.clientWidth - 15;
    var cm = new Ext.grid.ColumnModel([{
        header: "标签名称",
        dataIndex: "labelname",
        width: docWidth * 0.5,
        sortable: true
    }, {
        header: "标签类型",
        dataIndex: "labeltype",
        width: docWidth * 0.5,
        sortable: true
    }]);
	cm.defaultSortable = true;
	
	var sm = new Ext.grid.CheckboxSelectionModel();
	
    var grid = new Ext.grid.GridPanel({
        region: "center",
        cm: cm,
        ds: ds,
        sm: sm,
        loadMask: true,
        trackMouseOver: false,
        viewConfig: {
            forceFit: false,
            enableRowBody: true,
            sortAscText: "升序",
            sortDescText: "降序",
            columnsText: "列定义",
            getRowClass: function(record, rowIndex, p, store){
                return "x-grid3-row-collapsed";
            }
        },
        bbar: new Ext.PagingToolbar({
            pageSize: 20,
            store: ds,
            displayInfo: true,
            beforePageText: "第",
            afterPageText: "页/{0}",
            firstText: "第一页",
            prevText: "上页",
            nextText: "下页",
            lastText: "最后页",
            displayMsg: "显示 {0} - {1}条记录 / {2}",
            emptyMsg: "没有结果返回"
        })
    });
    
    grid.on("rowdblclick", function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        var keyword = _record.get('keyword');
      	var labelname = _record.get('labelname');
      	window.parent.returnValue = [keyword, labelname];
        window.parent.close();
    });
           
	var labelPanel = new Ext.Panel({
	    title:'用户自定义标签',iconCls:Ext.ux.iconMgr.getIcon('tag_green'),
	    layout: 'border',
	    items: [{region:'north',autoScroll:true,contentEl:'labelPanel',split: true,collapseMode: "mini"},grid]
	});
	
	contentPanel = new Ext.TabPanel({
        region:'center',
        id:'tabPanel',
        deferredRender:false,
        enableTabScroll:true,
        autoScroll:false,
        activeTab:0,
        items:[labelPanel]
    });
	
	addTab(contentPanel,'/base/label/labelchoose_system.jsp','系统标签','tag_orange');
	//Viewport
	var viewport = new Ext.Viewport({
	    layout: 'border',
	    items: [contentPanel]
	});
	
	changeLabelType();
	
	onSearch();
});

function onSearch(){
	if(ds){
	    var labeltype = document.getElementById("labeltype");
	    var formid = document.getElementById("formid");
	    var labelname = document.getElementById("labelname");
	    var data = {
	    		labeltype : labeltype.value,	
	    		formid : formid.value,
	    		labelname : labelname.value
	    };
	    ds.baseParams = data;
	    ds.load({
	        params: {
	            start: 0,
	            limit: 20
	        }
	    });
	}
}

function changeLabelType(){
	var labeltype = document.getElementById("labeltype");
	for(var i = 0; i < labeltype.options.length; i++){
		var opt = labeltype.options[i];
		if(opt.value != ''){
			var s = opt.value == labeltype.value ? "block" : "none";
			for(var j = 1; j <= 2; j++){
				var tdEle = document.getElementById(opt.value + "Td" + j);
				if(tdEle){
					tdEle.style.display = s;
				}
			}
		}
	}
}

function getrefobj(inputid,inputspanid,refid,viewurl,isneed){
	  var idsin = document.getElementById(inputid).value;
	  var id;
	  if(Ext.isIE){
		  try{
		       var url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
		          if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
		              url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid;
		          }
		  id=openDialog(url);
		  }catch(e){return;}
		  if (id!=null) {
			  if (id[0] != '0') {
					document.getElementById(inputspanid).innerHTML = id[1];
					document.getElementById(inputid).value = id[0];
		
			  }else{
					document.getElementById(inputid).value = '';
					if (isneed=='0')
						document.getElementById(inputspanid).innerHTML = '';
					else
						document.getElementById(inputspanid).innerHTML = '<img src=/images/base/checkinput.gif>';
		
			  }
		   }
	  }else{
	  url='/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
	  var callback = function() {
	          try {
	              id = dialog.getFrameWindow().dialogValue;
	          } catch(e) {
	          }
	          if (id != null) {
	              if (id[0] != '0') {
	                  document.getElementById(inputspanid).innerHTML = id[1];
	                  document.getElementById(inputid).value = id[0];
	              } else {
	                  document.getElementById(inputid).value = '';
	                  if (isneed == '0')
	                      document.getElementById(inputspanid).innerHTML = '';
	                  else
	                      document.getElementById(inputspanid).innerHTML = '<img src=/images/base/checkinput.gif>';

	              }
	          }
	  };
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