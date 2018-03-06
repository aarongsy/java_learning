var ds;
var selected = new Array();
Ext.onReady(function(){
   Ext.QuickTips.init();
   Ext.SSL_SECURE_URL = 'about:blank';
   Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';
   Ext.LoadMask.prototype.msg = "加载中,请稍候...";
    
   var tb = new Ext.Toolbar();
   tb.render('pagemenubar');
   addBtn(tb,'查询','S','zoom',function(){onSearch();});
   addBtn(tb,'新增样式','A','add',function(){openStyleDialog('/portal/style/portletstylecreate.jsp','新增样式',400,265);});
   addBtn(tb,'删除','D','delete',function(){onDelete();});
   
	ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: "/ServiceAction/com.eweaver.portal.servlet.PortletStyleAction?action=getPortletStyleList"
        }),
        reader: new Ext.data.JsonReader({
        	root: 'result',
            totalProperty: 'totalcount',
            fields: 
            	[
            		'id',
            		'objname',
            		'description',
            		'modify'
            	]
        })
    });
	
	var sm = new Ext.grid.CheckboxSelectionModel();
	
	sm.on('rowselect',function(selMdl,rowIndex,rec ){
	    var reqid=rec.get('id');
	    for(var i=0;i<selected.length;i++){
            if(reqid ==selected[i]){
                 return;
             }
        }
    	selected.push(reqid);
	});
	
	sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        var reqid=rec.get('id');
        for(var i=0;i<selected.length;i++){
           if(reqid ==selected[i]){
                selected.remove(reqid);
                return;
            }
        }
    });
	
	var docWidth = document.body.clientWidth - 250;
    var cm = new Ext.grid.ColumnModel([sm,
     {
        header: "样式名称",
        dataIndex: "objname",
        width: docWidth * 0.3,
        sortable: true
     },
     {
        header: "描述",
        dataIndex: "description",
        width: docWidth * 0.4,
        sortable: true
     },
     {
        header: "",
        dataIndex: "modify",
        width: docWidth * 0.3,
        sortable: true
     }
    ]);
	cm.defaultSortable = true;
	
    var grid = new Ext.grid.GridPanel({
        region: "center",
        cm: cm,
        ds: ds,
        sm: sm,
        loadMask: true,
        trackMouseOver: false,
        viewConfig: {
            forceFit: true,
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
    
	//Viewport
	var viewport = new Ext.Viewport({
	    layout: "border",
        items: [{
            region: "north",
            autoScroll: true,
            contentEl: "stylePanel",
            split: true,
            collapseMode: "mini"
        }, grid]
	});
	
	onSearch();
});

function onSearch(){
	if(ds){
	    var objname = document.getElementById("objname");
	    var data = {
	    		objname : objname.value
	    };
	    ds.baseParams = data;
	    ds.load({
	        params: {
	            start: 0,
	            limit: 20
	        }
	    });
	    selected = [];
	}
}
var styleDialog;
function openStyleDialog(url,title,width,height){
   styleDialog = new Ext.Window({
        layout:'border',
        closeAction:'hide',
        plain: true,
        modal :true,
        items:[{
	        id:'commondlg',
	        region:'center',
	        xtype     :'iframepanel',
	        frameConfig: {
	            autoCreate:{id:'commondlgframe', name:'commondlgframe', frameborder:0} ,
	            eventsFollowFrameLinks : false
	        },
	        autoScroll:true
	    }]
    });
    styleDialog.render(Ext.getBody());
    styleDialog.setTitle(title);
    styleDialog.setIconClass(Ext.ux.iconMgr.getIcon('border_none'));
    styleDialog.setWidth(width);
    styleDialog.setHeight(height);
    styleDialog.getComponent('commondlg').setSrc(url);
    styleDialog.show();
}

function closeStyleDialog(){
	if(styleDialog){
		styleDialog.hide();
	}
	if(ds){
		ds.reload();
	}
}

function onDelete(){
	if(selected.toString() == ""){
		alert("未选择数据！");
		return;
	}
	if(confirm("确认要删除这些数据吗？")){
		Ext.Ajax.request({   
			url: "/ServiceAction/com.eweaver.portal.servlet.PortletStyleAction?action=deletePortletStyles",   
			method : 'post',
			params:{   
				ids : selected.toString()
			}, 
			success: function (response)    
	        {   
	        	if(response.responseText=="success"){
					if(ds){
						ds.reload();
					}
				}
	        },
		 	failure: function(response,opts) {    
			 	alert('onDelete error');   
			}  
		}); 
	}
}