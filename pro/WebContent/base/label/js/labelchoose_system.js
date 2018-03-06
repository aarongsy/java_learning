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
            url: "/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelDictoryList"
        }),
        reader: new Ext.data.JsonReader({
        	root: 'result',
            totalProperty: 'totalcount',
            fields: ['id','keyword','labeldesc']
        })
    });
	
	var docWidth = document.body.clientWidth - 15;
    var cm = new Ext.grid.ColumnModel([{
        header: "标签关键字",
        dataIndex: "keyword",
        width: docWidth * 0.5,
        sortable: true
    }, {
        header: "描述",
        dataIndex: "labeldesc",
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
        var id = _record.get('id');
        var keyword = _record.get('keyword');
      	window.parent.returnValue = [id, keyword];
        window.parent.close();
    });
    
	var viewport = new Ext.Viewport({
        layout: "border",
        items: [{
            region: "north",
            autoScroll: true,
            contentEl: "labelPanel",
            split: true,
            collapseMode: "mini"
        }, grid]
    });
    
	onSearch();
});

function onSearch(){
	if(ds){
	    var keyword = document.getElementById("keyword");
	    var data = {
	    		keyword : keyword.value
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