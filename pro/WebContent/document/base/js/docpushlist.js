Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = "/js/ext/resources/images/default/s.gif";
    Ext.LoadMask.prototype.msg = load;//加载...
	
	var title = [a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12];
	//   标题  分类   摘要  摘要 创建日期  创建时间 创建者 附件数 状态 推送人 推送说明 推送日期 推送时间
    var tb = new Ext.Toolbar({
        renderTo: "pagemenubar",
        items: [{
            text: a13+"(S)",//快捷搜索
            key: "s",
            alt: true,
            handler: function(){
                onSearch();
            }
        }, {
            text: a14+"(R)",//清空条件
            key: "r",
            alt: true,
            handler: function(){
				$("#EweaverForm span").text("");
				$("#EweaverForm input[type=text]").val("");
				$("#EweaverForm textarea").val("");
				$("#EweaverForm input[type=checkbox]").each(function(){
					this.checked = false;
				});
				$("#EweaverForm input[type=hidden]").each(function(){
						this.value = "";
				});
				$("#EweaverForm select").val("");
            }
        }]
    });
	
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: "/ServiceAction/com.eweaver.document.base.servlet.DocPushAction?action=getDocbase"
        }),
        reader: new Ext.data.JsonReader({
            totalProperty: "totalProperty",
            root: "root"
        }, [{
            name: "subject"
        }, {
            name: "categoryname"
        }, {
            name: "content"
        }, {
            name: "createdate"
        }, {
            name: "createtime"
        }, {
            name: "humresname"
        }, {
            name: "attachnum"
        }, {
            name: "status"
        }, {
            name: "pusher"
        }, {
            name: "reason"
        }, {
            name: "pushdate"
        }, {
            name: "pushtime"
        }]),
        remoteSort: true
    });
	
	ds.setDefaultSort("pushdate","desc");
	
    var sm = new Ext.grid.RowSelectionModel({
        selectRow: Ext.emptyFn
    });
	
    var cm = new Ext.grid.ColumnModel([{
        header: title[0],
        dataIndex: "subject",
        sortable: true
    }, {
        header: title[1],
        dataIndex: "categoryname",
        sortable: true
    }, {
        header: title[2],
        dataIndex: "content",
        sortable: true
    }, {
        header: title[3],
        dataIndex: "createdate",
        sortable: true
    }, {
        header: title[4],
        dataIndex: "createtime",
        sortable: true
    }, {
        header: title[5],
        dataIndex: "humresname",
        sortable: true
    }, {
        header: title[6],
        dataIndex: "attachnum",
        sortable: true
    }, {
        header: title[7],
        dataIndex: "status",
        sortable: true
    }, {
        header: title[8],
        dataIndex: "pusher",
        sortable: true
    }, {
        header: title[9],
        dataIndex: "reason",
        sortable: true
    }, {
        header: title[10],
        dataIndex: "pushdate",
        sortable: true
    }, {
        header: title[11],
        dataIndex: "pushtime",
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
            sortAscText: up,//升序
            sortDescText: down,//降序
            columnsText: colsdy,//列定义
            getRowClass: function(record, rowIndex, p, store){
                return "x-grid3-row-collapsed";
            }
        },
        bbar: new Ext.PagingToolbar({
            pageSize: 20,
            store: ds,
            displayInfo: true,
            beforePageText: b2,//第
            afterPageText: b3+"/{0}",//页
            firstText: b4,//第一页
            prevText: b5,//上页
            nextText: b6,//下页
            lastText: b7,//最后页
            displayMsg: b8+" {0} - {1}"+b9+" / {2}",//显示   条记录
            emptyMsg: b10
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
	
    function onSearch(){
        var o = $("#EweaverForm").serializeArray();
        var data = {};
        for (var i = 0; i < o.length; i++) {
            if (o[i].value != null && o[i].value != "") {
                data[o[i].name] = o[i].value;
            }
        }
        ds.baseParams = data;
        ds.load({
            params: {
                start: 0,
                limit: 20
            }
        });
        event.srcElement.disabled = false;
    }
    
    $(document).keydown(function(event){
        if (event.keyCode == 13) {
            onSearch();
        }
    });
	
});