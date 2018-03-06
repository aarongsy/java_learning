<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ include file="/base/init.jsp"%>
<%
String categoryid = StringHelper.null2String(request.getParameter("categoryid"));
//是否进行设置网上调查表单设置
DataService ds = new DataService();
int indagateset = NumberHelper.string2Int(ds.getValue("SELECT count(*) FROM indagateformset"),0);
if(indagateset==0){
	out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置网上调查表单设置后再来操作。</h5>");
	return;
}
%>
<html>
<head>
<title>网上投票</title>
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
<script type="text/javascript" >
var tb;
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = "/js/ext/resources/images/default/s.gif";
    Ext.LoadMask.prototype.msg = "加载...";
    
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
            text: "清空条件(R)",
            key: "r",
            alt: true,
            handler: function(){
                $("#EweaverForm input[type=text]").val("");
            }
        }
        ]
    });
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: "/ServiceAction/com.eweaver.indagate.servlet.IndagateAction?action=getindagatelist&categoryid=<%=categoryid%>"
        }),
        reader: new Ext.data.JsonReader({
            totalProperty: "totalProperty",
            root: "totalProperty"
        }, ['requestid','title','startdatefield','starttimefield','enddatefield','endtimefield','opater']),
        remoteSort: false
    });
    ds.setDefaultSort("requestid");
	
    ds.load({
        params: {
            start: 0,
            limit: 30
        }
    });
    ds.on('load',function(st,recs) {}
    );
     var fm = Ext.form;
     var cm = new Ext.grid.ColumnModel([
     {header:'主题',dataIndex:'title',width:0,sortable:false},
     {header:'发布日期',dataIndex:'startdatefield',width:0,sortable:false},
     {header:'发布时间',dataIndex:'starttimefield',width:0,sortable:false},
     {header:'结束日期',dataIndex:'enddatefield',width:0,sortable:false},
     {header:'结束时间',dataIndex:'endtimefield',width:0,sortable:false},
     {header:'操作',dataIndex:'opater',width:0,sortable:false}
     ]);
	   cm.defaultSortable = true;
	
    var grid = new Ext.grid.EditorGridPanel({
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
            pageSize: 30,
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
        },grid]
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
                limit: 30
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
</script>
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
</head>
<body>
<div id="divSearch">
<div id="pagemenubar"></div>
<form action="" id="EweaverForm" name="EweaverForm" method="post">
<table class="viewform">
	<tr class="title">
		<td class="FieldName" nowrap>主题</td>
		<td class="FieldValue" nowrap>
			<input type="text" name="title">
		</td>
	</tr>
</table>
</form>
</div>
</body>
</html>