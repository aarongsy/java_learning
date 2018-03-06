Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = "/js/ext/resources/images/default/s.gif";
    Ext.LoadMask.prototype.msg = load;//加载...
	
	var title = [doc, dic, pushdate, pushtime, puser, pstat, porg, minlevel, maxlevel, pushdes];
	//			文档		目录	 推送日期  推送时间  指定用户 指定岗位 指定部门 最小安全级别 最大安全级别 推送说明
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: "/ServiceAction/com.eweaver.document.base.servlet.DocPushAction?action=get"
        }),
        reader: new Ext.data.JsonReader({
            totalProperty: "totalProperty",
            root: "root"
        }, [{
            name: "id"
        }, {
            name: "subject"
        }, {
            name: "category"
        }, {
            name: "pushdate"
        }, {
            name: "pushtime"
        }, {
            name: "userids"
        }, {
            name: "stationids"
        }, {
            name: "orgids"
        }, {
            name: "minseclevel"
        }, {
            name: "maxseclevel"
        }, {
            name: "reason"
        }]),
        remoteSort: true
    });
	
	ds.setDefaultSort("pushdate", "desc");
	
	var sm = new Ext.grid.CheckboxSelectionModel();
	sm.handleMouseDown = Ext.emptyFn;
	
    var cm = new Ext.grid.ColumnModel([sm, {
        header: title[0],
        dataIndex: "subject",
        sortable: true
    }, {
        header: title[1],
        dataIndex: "category",
        sortable: true
    }, {
        header: title[2],
        dataIndex: "pushdate",
        sortable: true
    }, {
        header: title[3],
        dataIndex: "pushtime",
        sortable: true
    }, {
        header: title[4],
        dataIndex: "userids",
        sortable: true
    }, {
        header: title[5],
        dataIndex: "stationids",
        sortable: true
    }, {
        header: title[6],
        dataIndex: "orgids",
        sortable: true
    }, {
        header: title[7],
        dataIndex: "minseclevel",
        sortable: true
    }, {
        header: title[8],
        dataIndex: "maxseclevel",
        sortable: true
    }, {
        header: title[9],
        dataIndex: "reason",
        sortable: true
    }]);
	cm.defaultSortable = true;
	
    var grid = new Ext.grid.GridPanel({
        region: "center",
		sm: sm,
        cm: cm,
        ds: ds,
        loadMask: true,
        trackMouseOver: false,
		columnLines: true,
		singleSelect: true,
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
		tbar: [{
			text: del+"(D)",//删除
            key: "d",
            alt: true,
            handler: function(){
            	var records = sm.getSelections();
            	
            	if(records.length == 0){
            		return;
            	}
            	if(!confirm(suredel)){//您确定要删除吗？
            		return;
            	}
				
			    var s = "";
		        for(var i = 0; i < records.length; i++){
			        var record = records[i];
					
					ds.remove(record);
					
			        var data = record.get("id");
			        s += data + ",";
		        }
				
				if (s != "") {
					s = s.substring(0, s.length - 1);
					
					Ext.Ajax.request({
				        url: "/ServiceAction/com.eweaver.document.base.servlet.DocPushAction",
				        params: {
				            action: "delete",
				            ids: s
				        },
				        success: function(response){
							
				        },
				        failure: function(response){
				            Ext.Msg.alert(a1);//错误, 无法访问后台
				        }
				    });
				}
			}
		}],
        bbar: new Ext.PagingToolbar({
            pageSize: 20,
            store: ds,
            displayInfo: true,
            beforePageText: a2,//第
            afterPageText: a3+"/{0}",//页
            firstText: a4,//第一页
            prevText: a5,//上页
            nextText: a6,//下页
            lastText: a7,//最后页
            displayMsg: a8+" {0} - {1}"+a9+" / {2}",//显示   条记录
            emptyMsg: a10
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
	
});