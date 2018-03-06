Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = "/js/ext/resources/images/default/s.gif";
    Ext.LoadMask.prototype.msg = "加载...";
	
	var title = ["源子目录", "目标子目录", "文档", "操作类型", "操作人", "操作日期", "操作时间"];
	
	var tb = new Ext.Toolbar({
	    renderTo: "pagemenubar",
	    items: [{
	    	text: "剪切(X)",
	        key: "x",
	        alt: true,
	        handler: function() {
	        	if(chekcedDataInput()){
			    	document.EweaverForm.action = "/ServiceAction/com.eweaver.document.base.servlet.DoctransferAction?action=cut";
			    	document.EweaverForm.submit();
		    	}
	        }
	    }, {
	    	text: "复制(C)",
	        key: "c",
	        alt: true,
	        handler: function() {
	        	if(chekcedDataInput()){
			    	document.EweaverForm.action = "/ServiceAction/com.eweaver.document.base.servlet.DoctransferAction?action=copy";
			    	document.EweaverForm.submit();
		    	}
	        }
	    }]
	});
	
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: "/ServiceAction/com.eweaver.document.base.servlet.DoctransferAction?action=log"
        }),
        reader: new Ext.data.JsonReader({
            totalProperty: "totalProperty",
            root: "root"
        }, [{
            name: "source"
        }, {
            name: "target"
        }, {
            name: "docids"
        }, {
            name: "opttype"
        }, {
            name: "submitor"
        }, {
            name: "submitdate"
        }, {
            name: "submittime"
        }]),
        remoteSort: true
    });
	
	ds.setDefaultSort("pushdate", "desc");
	
    var sm = new Ext.grid.RowSelectionModel({
        selectRow: Ext.emptyFn
    });
	
	var colWidth = document.body.clientWidth / 7 - 2;
    var cm = new Ext.grid.ColumnModel([{
        header: title[0],
        dataIndex: "source",
        width: colWidth,
        sortable: true
    }, {
        header: title[1],
        dataIndex: "target",
        width: colWidth,
        sortable: true
    }, {
        header: title[2],
        dataIndex: "docids",
        width: colWidth,
        sortable: true
    }, {
        header: title[3],
        dataIndex: "opttype",
        width: colWidth,
        sortable: true
    }, {
        header: title[4],
        dataIndex: "submitor",
        width: colWidth,
        sortable: true
    }, {
        header: title[5],
        dataIndex: "submitdate",
        width: colWidth,
        sortable: true
    }, {
        header: title[6],
        dataIndex: "submittime",
        width: colWidth,
        sortable: true
    }]);
	cm.defaultSortable = true;
	
    var grid = new Ext.grid.GridPanel({
        region: "center",
        cm: cm,
        ds: ds,
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
	
	var viewport = new Ext.Viewport({
        layout: "border",
        items: [{
            region: "north",
            autoScroll: true,
            contentEl: "divSearch",
            split: true,
            collapseMode: "mini"
        }, grid]
    });
	
	ds.load({
        params: {
            start: 0,
            limit: 20
        }
    });
	
	var flag = document.getElementById("flag").value;
	if(flag == "0"){
		Ext.MessageBox.alert('','源子目录中无文档,未进行相应操作.');
	}
});

function chekcedDataInput(){
	var source = document.getElementById("source");
	var target = document.getElementById("target");
	if(source.value == ""){
		Ext.MessageBox.alert('','请选择源子目录');
		return false;
	}
	if(target.value == ""){
		Ext.MessageBox.alert('','请选择目标子目录');
		return false;
	}
	return true;
}