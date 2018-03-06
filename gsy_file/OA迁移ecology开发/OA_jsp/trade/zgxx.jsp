<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String param1 = StringHelper.null2String(request.getParameter("param1"));//运入运出
String param2 = StringHelper.null2String(request.getParameter("param2"));//单据类型
String param3 = StringHelper.null2String(request.getParameter("param3"));//制单类型
%>
<html>
<head>
<title>装柜信息</title>
<%@ include file="/base/init.jsp"%>
<script src='/dwr/interface/DataService.js'></script>
<SCRIPT type=text/javascript src="/dwr/engine.js"></SCRIPT>
<style type="text/css">
	.x-toolbar table {
		width: 0
	}
	a {
		color: blue;
		cursor: pointer;
	}
	#pagemenubar table {
		width: 0
	}
	.x-panel-btns-ct {
		padding: 0px;
	}
	.x-panel-btns-ct table {
		width: 0
	}
</style>
</head>
<body>
<div id="divSearch">
<div id="pagemenubar"></div>
<form action="" id="EweaverForm" name="EweaverForm" method="post">
</form>
</div>
</body>
<script type="text/javascript">
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = "/js/ext/resources/images/default/s.gif";
    Ext.LoadMask.prototype.msg = "加载...";
	var title = ["柜型","危普区分", "虚拟柜号", "进出口单号", "装箱明细id","原始订单号","原始订单项次","物料号","物料描述","订单数量","已排数量"];
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: "/app/trade/loadIOdata.jsp?action=zgxx&requestid=<%=requestid%>"
        }),
		timeout: 30000,
        reader: new Ext.data.JsonReader({
            totalProperty: "totalProperty",
            root: "root"
        }, [{
            name: "col1"
        }, {
            name: "col2"
        }, {
            name: "col3"
        }, {
            name: "col4"
        }, {
            name: "col5"
        }, {
            name: "col6"
        }, {
            name: "col7"
        }, {
            name: "col10"
        }, {
            name: "col11"
        }, {
            name: "col8"
        }, {
            name: "col9"
        }]),
        remoteSort: true
    });
	
    var sm = new Ext.grid.CheckboxSelectionModel({
    	singleSelect:true,
    	listeners:{
	    	'selectionchange':function(smdata){
	    		var selectDatas = smdata.getSelections();
	    		var detailid = "";
	    		if(selectDatas.length>0){
	    			detailid = selectDatas[0].data["col5"];
	    		}
	    		reloadzxmx(detailid);
	    	}
    	}
    });
	
    var cm = new Ext.grid.ColumnModel([sm,{
        header: title[0],
        dataIndex: "col1",
        width:60,
        sortable: true
    }, {
        header: title[1],
        dataIndex: "col2",
        width:60,
        sortable: true
    }, {
        header: title[2],
        dataIndex: "col3",
        width:110,
        sortable: true
    },{
        header: title[3],
        dataIndex: "col4",
        width:130,
        sortable: true
    },{
        header: title[4],
        dataIndex: "col5",
        width:60,
        sortable: true,
        hidden:true
    }, {
        header: title[5],
        dataIndex: "col6",
        width:100,
        sortable: true
    }, {
        header: title[6],
        dataIndex: "col7",
        width:90,
        sortable: true
    },{
        header: title[9],
        dataIndex: "col10",
        width:80,
        sortable: true
    },{
        header: title[10],
        dataIndex: "col11",
        width:80,
        sortable: true
    },{
        header: title[7],
        dataIndex: "col8",
        width:80,
        sortable: true
    },{
        header: title[8],
        dataIndex: "col9",
        width:120,
        sortable: true
    }]);
	cm.defaultSortable = true;
	
    var grid = new Ext.grid.GridPanel({
        region: "center",
        cm: cm,
        sm: sm ,
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
            //collapseMode: "mini",
            title:"装柜信息"
        }, grid]
    });
	
    ds.load({
        params: {
            start: 0,
            limit: 20
        }
    });
    
});

function reloadzxmx(detailid){
	var zxmxds = parent.document.frames["zxmx"].ds;
	zxmxds.load({
        params: {
            start: 0,
            limit: 20,
            detailid: detailid,
            param1:'<%=param1%>',
            param2:'<%=param2%>',
            param3:'<%=param3%>'
        }
    });
}
</script>
</html>