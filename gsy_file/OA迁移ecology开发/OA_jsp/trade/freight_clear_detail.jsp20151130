<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%
String requestid = request.getParameter("requestid");

 %>
<html>
<head>
<title>运费清帐暂估记帐明细</title>
<%@ include file="/base/init.jsp"%>
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
var ds;
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = "/js/ext/resources/images/default/s.gif";
    Ext.LoadMask.prototype.msg = "加载...";
    
	var title = ["记帐代码","科目", "含税金额", "未税金额", "销售税代码", "成本中心", "采购订单", "销售订单号","订单行项目","项目文本","暂估填入销售单号"];

    ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: "/app/trade/reportAction.jsp?action=getFreigthList&requestid=<%=requestid%>"
        }),
		timeout: 900000,
        reader: new Ext.data.JsonReader({
            totalProperty: "totalProperty",
            root: "root"
        }, [{
            name: "chargecode"
        }, {
            name: "subject"
        }, {
            name: "amount"
        }, {
            name: "notaxamount"
        }, {
            name: "saletax"
        },  {
            name: "costcentre"
        }, {
            name: "purchorder"
        }, {
            name: "saleorder"
        }, {
            name: "itemno"
        }, {
            name: "projecttext"
        }, {
            name: "isflag"
        }]),
        remoteSort: true
    });
   // ds.setDefaultSort("sno", "asc");
	
    var sm = new Ext.grid.RowSelectionModel({
        selectRow: Ext.emptyFn
    });
	
    var cm = new Ext.grid.ColumnModel([{
        header: title[0],
        dataIndex: "chargecode",
        width:100,
        sortable: true
    }, {
        header: title[1],
        dataIndex: "subject",
        width:150,
        sortable: true
    }, {
        header: title[2],
        dataIndex: "amount",
        width:100,
        sortable: true
    },{
        header: title[3],
        dataIndex: "notaxamount",
        width:100,
        sortable: true
    },{
        header: title[4],
        dataIndex: "saletax",
        width:100,
        sortable: true
    },{
        header: title[5],
        dataIndex: "costcentre",
        width:150,
        sortable: true
    },{
        header: title[6],
        dataIndex: "purchorder",
        width:150,
        sortable: true
    },{
        header: title[7],
        dataIndex: "saleorder",
        width:150,
        sortable: true
    },{
        header: title[8],
        dataIndex: "itemno",
        width:100,
        sortable: true
    },{
        header: title[9],
        dataIndex: "projecttext",
        width:100,
        sortable: true
    },{
        header: title[10],
        dataIndex: "isflag",
        width:120,
        sortable: true,
        renderer: function(value){
          if(value=='40288098276fc2120127704884290211'){
           value='否';
          }else{
          	value='是';
          }
          return value;
        }
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
    
	
});


</script>
</html>