<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<title>协作区报表</title>
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
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src='/dwr/interface/DataService.js'></script>
<script type="text/javascript" src='/dwr/engine.js'></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<script type="text/javascript" language="javascript">
var tb;
var ds;
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = "/js/ext/resources/images/default/s.gif";
    Ext.LoadMask.prototype.msg = "loading...";
    Ext.Ajax.timeout = 1800000; /**15分钟（单位毫秒）这句话很重要的 设置查询等待时间的长短 防止请求超时界面展现不出结果信息*/ 
    tb = new Ext.Toolbar({
        renderTo: "pagemenubar",
        items: [{
            text: "快捷搜索(S)",
            key: "s",
            alt: true,
            handler: function(){
                onSearch();
            }
        }, {
            text: "清空条件(C)",
            key: "c",
            alt: true,
            handler: function(){
                $("#EweaverForm input[type=text]").val("");
            }
        }
        ]
    });
    ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: "/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=getcoworkreport"
        }),
        reader: new Ext.data.JsonReader({
            totalProperty: "totalProperty",
            root: "root"
        }, [
        //-- begin 不作显示
        {
            name: "id"
        }, 
        //-- end 
        {
            name: "objname"
        }, {
            name: "createdate"
        }, {
            name: "createtime"
        }, {
            name: "status"
        }, {
            name: "lastcol"
        }
        ]),
        remoteSort: false
    });
    // ds.setDefaultSort("id");
    ds.load({
        params: {
            start: 0,
            limit: 25
        }
    });
    ds.on('load',function(st,recs) {
        if(recs[0]!=null){
			// var sysDate =recs[0].get("sysDate"); //日期
        }else{
        
        }
     }
    );
	 
    var cm = new Ext.grid.ColumnModel([
    {
        header: "协作名称",
        sortable: false,
        dataIndex: "objname"
    },{
        header: "创建日期",
        width:30,
        dataIndex: "createdate",
        sortable: true
    }, {
        header: "创建时间",
        width:30,
        dataIndex: "createtime",
        sortable: true
    }, {
        header: "状态",
        width:20,
        dataIndex:"status",
        sortable: true
    }, {
        header: "操作",
        width:30,
        dataIndex: "lastcol",
        sortable: true
    }
    ]);
	cm.defaultSortable = true;
	
    var grid = new Ext.grid.GridPanel({
        region: "center",
        cm: cm,
        ds: ds,
        loadMask: true,
        trackMouseOver: false,
        viewConfig: {
   	        forceFit: true,
            enableRowBody: true,
            scrollOffset: 0,//不加这个的话，会在grid的最右边有个空白，留作滚动条的位置
            sortAscText: "<%=labelService.getLabelName("402883d934c0f44b0134c0f44c780000")%>",
            sortDescText: "<%=labelService.getLabelName("402883d934c0f59f0134c0f5a0140000")%>",
            columnsText: "<%=labelService.getLabelName("4028831534ee5d830134ee5d8522003e")%>",
            getRowClass: function(record, rowIndex, p, store){
                return "x-grid3-row-collapsed";
            }
        },
        bbar: new Ext.PagingToolbar({
            pageSize: 25,
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
                limit: 25
            }
        });
        if(event &&  event.srcElement)
           event.srcElement.disabled = false;
    }
    
    $(document).keydown(function(event){
        if (event.keyCode == 13) {
            onSearch();
        }
    });
	 onSearch();
});

function checkType(id){
   Ext.Msg.buttonText={yes:'是',no:'否'};
   Ext.MessageBox.confirm('', '您确定要改变状态吗?', function (btn, text) {
   if (btn == 'yes') {
   Ext.Ajax.timeout = 900000;
   Ext.Ajax.request({
       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=changestatus',
       params:{requestid:id},
       sync:true,
       success: function() {
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
                limit: 25
            }
        });
       }
   });
   }
   });
}

function delCowork(id){
   Ext.Msg.buttonText={yes:'是',no:'否'};
   Ext.MessageBox.confirm('', '您确定要彻底删除吗?', function (btn, text) {
   if (btn == 'yes') {
   Ext.Ajax.timeout = 900000;
   Ext.Ajax.request({
       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=delcowork',
       params:{requestid:id},
       sync:true,
       success: function() {
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
                limit: 25
            }
        });
       }
   });
   }
   });
}
document.onkeydown = function(e){
    if(!e) e = window.event;//火狐中是 window.event
    if((e.keyCode || e.which) == 13){
    	onSearch();
    }
 }
</script>
</head>
<body>
<div id="divSearch">
<div id="pagemenubar"></div>
<form action="" id="EweaverForm" name="EweaverForm" method="post">
<table class="viewform">
    <colgroup>
			<col width="80">
			<col width="">
	</colgroup>
	<tr class="title">
		<td class="FieldName" nowrap>协作名称</td>
		<td class="FieldValue" nowrap>
			<input type="text" name="coworkname" id="coworkname" size="50">
		</td>
	</tr>
</table>
</form>
</div>
</body>
</html>