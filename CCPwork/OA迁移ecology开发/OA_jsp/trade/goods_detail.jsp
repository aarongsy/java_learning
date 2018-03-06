<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%
String requestid = request.getParameter("requestid");

 %>
<html>
<head>
<title>采购订单明细</title>
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
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = "/js/ext/resources/images/default/s.gif";
    Ext.LoadMask.prototype.msg = "加载...";
    
	var title = ["订单项次","物料号", "订单短文本", "采购数量", "采购单位", "预定交货日", "采购单价", "币种", "金额", "请购数量", "请购单位", "内部订单" ,"资产编号", "科目分配", "流水号" ,"订单编号", "订单类型" ,"订单类型描述" ,"公司名称", "公司代码", "付款条款代码", "付款条款文本", "国贸条件1", "国贸条件2" ,"供应商简码" ,"供应商名称" ,"采购申请凭证类型", "采购申请编号", "采购申请项次" ,"厂区别", "所属公司", "状态标记" ];

    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: "/app/trade/reportAction.jsp?action=getList&requestid=<%=requestid%>"
        }),
		timeout: 900000,
        reader: new Ext.data.JsonReader({
            totalProperty: "totalProperty",
            root: "root"
        }, [{
            name: "orderitem"
        }, {
            name: "materialno"
        }, {
            name: "ordershort"
        }, {
            name: "unit"
        }, {
            name: "delidate"
        },  {
            name: "unitprice"
        }, {
            name: "currency"
        }, {
            name: "total"
        }, {
            name: "buynum"
        }, {
            name: "buyunit"
        }, {
            name: "innerorder"
        }, {
            name: "assetsno"
        }, {
            name: "kmfp"
        }, {
            name: "runningno"
        }, {
            name: "orderno"
        }, {
            name: "ordertype"
        }, {
            name: "ordertypedes"
        }, {
            name: "companyname"
        },{
            name: "company"
        },{
            name: "paymentcode"
        },{
            name: "paymentnode"
        },{  
            name: "condition1"
        },{
            name: "condition2"
        },{
            name: "suppliercode"
        },{
            name: "suppliername"
        },{
            name: "applytype"
        },{
            name: "applyno"
        },{
            name: "applyitem"
        },{
            name: "comtype"
        },{
            name: "reqcom"
        },{
            name: "stateflag"
        }]),
        remoteSort: true
    });
    ds.setDefaultSort("sno", "asc");
	
    var sm = new Ext.grid.RowSelectionModel({
        selectRow: Ext.emptyFn
    });
	
    var cm = new Ext.grid.ColumnModel([{
        header: title[0],
        dataIndex: "orderitem",
        width:100,
        sortable: true
    }, {
        header: title[1],
        dataIndex: "materialno",
        width:100,
        sortable: true
    }, {
        header: title[2],
        dataIndex: "ordershort",
        width:100,
        sortable: true
    },{
        header: title[3],
        dataIndex: "quantity",
        width:100,
        sortable: true
    },{
        header: title[4],
        dataIndex: "unit",
        width:100,
        sortable: true
    },{
        header: title[5],
        dataIndex: "delidate",
        width:100,
        sortable: true
    },{
        header: title[6],
        dataIndex: "unitprice",
        width:100,
        sortable: true
    },{
        header: title[7],
        dataIndex: "currency",
        width:100,
        sortable: true
    },{
        header: title[8],
        dataIndex: "total",
        width:100,
        sortable: true
    },{
        header: title[9],
        dataIndex: "buynum",
        width:100,
        sortable: true
    },{
        header: title[1],
        dataIndex: "buyunit",
        width:100,
        sortable: true
    },{
        header: title[11],
        dataIndex: "innerorder",
        width:100,
        sortable: true
    },{
        header: title[12],
        dataIndex: "assetsno",
        width:100,
        sortable: true
    },{
        header: title[13],
        dataIndex: "kmfp",
        width:100,
        sortable: true
    },{
        header: title[14],
        dataIndex: "runningno",
        width:100,
        sortable: true
    },{
        header: title[15],
        dataIndex: "orderno",
        width:100,
        sortable: true
    },{
        header: title[16],
        dataIndex: "ordertype",
        width:100,
        sortable: true
    },{
        header: title[17],
        dataIndex: "ordertypedes",
        width:100,
        sortable: true
    },{
        header: title[18],
        dataIndex: "companyname",
        width:100,
        sortable: true
    },{
        header: title[19],
        dataIndex: "company",
        width:100,
        sortable: true
    },{
        header: title[20],
        dataIndex: "paymentcode",
        width:100,
        sortable: true
    },{
        header: title[21],
        dataIndex: "paymentnode",
        width:100,
        sortable: true
    },{
        header: title[22],
        dataIndex: "condition1",
        width:100,
        sortable: true
    },{
        header: title[23],
        dataIndex: "condition2",
        width:100,
        sortable: true
    },{
        header: title[24],
        dataIndex: "suppliercode",
        width:100,
        sortable: true
    },{
        header: title[25],
        dataIndex: "suppliername",
        width:100,
        sortable: true
    },{
        header: title[26],
        dataIndex: "applytype",
        width:100,
        sortable: true
    },{
        header: title[27],
        dataIndex: "applyno",
        width:100,
        sortable: true
    },{
        header: title[28],
        dataIndex: "applyitem",
        width:100,
        sortable: true
    },{
        header: title[29],
        dataIndex: "comtype",
        width:100,
        sortable: true
    },{
        header: title[30],
        dataIndex: "reqcom",
        width:100,
        sortable: true
    }, {
        header: title[31],
        dataIndex: "stateflag",
        sortable: true,
        width:300,
		align: "right"		
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