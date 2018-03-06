var selected = new Array();
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
            iconCls: Ext.ux.iconMgr.getIcon('zoom'),   
            handler: function(){
                onSearch();
            }
        }, {
            text: "清空条件(R)",
            key: "r",
            alt: true,
            iconCls: Ext.ux.iconMgr.getIcon('erase'),
            handler: function(){
        	reset();
            }
        }, {
            text: "导出Excel(E)",
            key: "e",
            alt: true,
            iconCls: Ext.ux.iconMgr.getIcon('page_excel'),
            handler: function(){
        		window.location.href="";
            }
        }]
    });
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: tagerUrl
        }),
        reader: new Ext.data.JsonReader({
            totalProperty: "totalProperty",
            root: "root"
        }, [
        {
            name: "rownum"
        }, {
        	name: "creator"
        }, {
        	name: "workday"
        }, {
        	name: "cntschedule"
        },
        {
            name: "cntblog"
        }, {
            name: "cntdp"
        }, {
            name: "cnthf"
        }, {
            name: "cntscheduleless"
        }, {
            name: "cntblogless"
        }
        ]),
        remoteSort: false
    });
    ds.setDefaultSort("rownum");

    ds.load({
        params: {
            start: 0,
            limit: 30
        }
    });
    
    ds.on('load',function(st,recs) {
    	//alert("ds 数据库加载!");
    });
    
    var fm = Ext.form;
    var sm = new Ext.grid.RowSelectionModel({selectRow: Ext.emptyFn});
	    sm=new Ext.grid.CheckboxSelectionModel();

    var cm = new Ext.grid.ColumnModel([sm,
    {
         header: "序号",
        sortable: true,
        dataIndex: "rownum"
    },{
        header: "姓名",
        dataIndex: "creator",
        sortable: true
    },{
        header: "工作日数",
        sortable: false,
        dataIndex: "workday"
    },{
        header: "日程数",
        sortable: true,
        dataIndex: "cntschedule"
    },{
        header: "微博数",
        sortable: true,
        dataIndex: "cntblog"
    },{
        header: "点评数",
        sortable: true,
        dataIndex: "cntdp"
    },{
        header: "回复数",
        sortable: true,
        dataIndex: "cnthf"
    },{
        header: "缺日程",
        sortable: true,
        dataIndex: "cntscheduleless"
    },{
        header: "缺微博",
        sortable: true,
        dataIndex: "cntblogless"
    }
    ]);
	cm.defaultSortable = true;
    var autorefresh=new Ext.ux.grid.AutoRefresher({ interval:'5'}) //自动刷新
    var grid = new Ext.grid.EditorGridPanel({
        region: "center",
        autoScroll : true,
        cm: cm,
        ds: ds,
        sm:sm,
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
            emptyMsg: "没有结果返回"/*,
            plugins: autorefresh*/
        })
    });
    
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
                 selected.remove(reqid)
                 return;
           }
         }
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
        selected = new Array();//重置
        var o = $("#TWForm").serializeArray();
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
        
    }

/*删除*/
function deleteData(grid){
	if(selected.length>=1){
		Ext.MessageBox.confirm('提示','确定删除吗？',function rollback(btn){
        		if(btn=='yes'){
					Ext.getBody().mask('loading', 'loading...');
					var len = selected.length;
					var i=0;
					var requestid ='';
					for(;i<len;i++){
						    var reid=new String(selected[i]);;
						    var x = top.contentPanel.getItem('tab_'+reid);
						    if(x){
				                    top.contentPanel.remove(x);
				                 }
							requestid += reid+',';
					}
					requestid = requestid.substring(0,requestid.length-1);
					Ext.Ajax.request({    
						        url:'/ServiceAction/com.tongwei.tw.action.DocbaseAction?action=delete', 
						        params:{ 
						           id:requestid 
						        }, 
						        success: function(resp,opts) { 
							        selected = new Array();//重置
							        var o = $("#TWForm").serializeArray();
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
								     Ext.getBody().unmask();
				                     Ext.Msg.alert('提示','删除成功！'); 
						        }, 
						        failure: function(resp,opts) { 
						        	 Ext.getBody().unmask();
						             Ext.Msg.alert('提示', '删除失败！'); 
						        }   
						    });
				}
        	   });
	}else{
	  Ext.Msg.alert('提示',"请选择删除的记录!");
	}
}
    
   function reset(){
         $('#TWForm span').text('');
         $('#TWForm input[type=text]').val('');
         $('#TWForm textarea').val('');
         $('#TWForm input[type=checkbox]').each(function(){
             this.checked=false;
         });
         $('#TWForm input[type=hidden]').each(function(){
             if(this.name.indexOf('con')==0)
             this.value='';
         });
         $('#TWForm select').val('');
   }
    document.onkeydown = function(e){
	   if(!e) e = window.event;//火狐中是 window.event
	   if((e.keyCode || e.which) == 13){
	      onSearch();
	   }
    }
    
    onSearch();
});
