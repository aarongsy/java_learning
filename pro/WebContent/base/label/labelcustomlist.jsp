<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ include file="/base/init.jsp"%>
<%
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
List<Selectitem> selectitemList = selectitemService.getSelectitemList("4028803522c5ca070122c5d78b8f0002", null);
ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
List<Reportdef> reportdefList = reportdefService.getReportdefList();
%>
<html>
<head>
<title></title>
<style type="text/css">
	.x-toolbar table {width:0}
	#pagemenubar table {width:0}
	.x-panel-btns-ct {
		padding: 0px;
	}
	.x-panel-btns-ct table {width:0}
</style>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<script type="text/javascript">
var ds;
Ext.onReady(function(){
   Ext.QuickTips.init();
   Ext.SSL_SECURE_URL = 'about:blank';
   Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';
   Ext.LoadMask.prototype.msg = "加载中,请稍候...";
    
   var tb = new Ext.Toolbar();
   tb.render('pagemenubar');
   addBtn(tb,'查询','O','zoom',function(){onSearch();});
   
	ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: "/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelList2"
        }),
        reader: new Ext.data.JsonReader({
        	root: 'result',
            totalProperty: 'totalcount',
            fields: 
            	[
            		<% for(Selectitem selectitem : selectitemList){%>
            			'<%=selectitem.getObjname()%>',
            		<% } %>
            		'labeltype',
            		'modify'
            	]
        })
    });
	
	var sm = new Ext.grid.CheckboxSelectionModel();
	
	var docWidth = document.body.clientWidth - 250;
	var colWidth = docWidth / <%=selectitemList.size()%>;
    var cm = new Ext.grid.ColumnModel([sm,
    <% for(Selectitem selectitem : selectitemList){%>
    	{
	        header: "<%=selectitem.getObjdesc()%>",
	        dataIndex: "<%=selectitem.getObjname()%>",
	        width: colWidth,
	        sortable: true
    	},
    <%}%>
     {
        header: "标签类型",
        dataIndex: "labeltype",
        width: 100,
        sortable: true
     },
     {
        header: "",
        dataIndex: "modify",
        width: 80,
        sortable: true
     }
    ]);
	cm.defaultSortable = true;
	
    var grid = new Ext.grid.GridPanel({
        region: "center",
        cm: cm,
        ds: ds,
        sm: sm,
        loadMask: true,
        trackMouseOver: false,
        viewConfig: {
            forceFit: true,
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
    
	//Viewport
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
	    var labeltype = document.getElementById("labeltype");
	    var keyword = document.getElementById("keyword");
	    var labelname = document.getElementById("labelname");
	    var formid = document.getElementById("formid");
	    var reportdefid = document.getElementById("reportdefid");
	    var data = {
	    		labeltype : labeltype.value,	
	    		keyword : keyword.value,
	    		labelname : labelname.value,
	    		formid : formid.value,
	    		reportdefid : reportdefid.value
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

function labelClosedCall(){
	if(ds){
		ds.reload();
	}
}

function changeLabelType(){
	var labeltype = document.getElementById("labeltype");
	for(var i = 0; i < labeltype.options.length; i++){
		var opt = labeltype.options[i];
		if(opt.value != ''){
			var s = opt.value == labeltype.value ? "block" : "none";
			for(var j = 1; j <= 2; j++){
				var tdEle = document.getElementById(opt.value + "Td" + j);
				if(tdEle){
					tdEle.style.display = s;
				}
			}
		}
	}
}
</script>
</head>
<body style="margin:0px;padding:0px">
<div id="labelPanel">
<div id="pagemenubar"></div>
	<form id="EweaverForm" name="EweaverForm" action="" method="post">
		<table>
			<tbody>
				<tr class="title">
					<td class="FieldName" nowrap width="65px;">标签类型：</td>
					<td class="FieldValue" nowrap>
						<select name="labeltype" id="labeltype" onchange="changeLabelType()">
							<option value=""></option>
							<%
								LabelType[] labelTypes = LabelType.values();
								for(LabelType l : labelTypes){%>
									<option value="<%=l.toString() %>"><%=l.getDisplayName() %></option>	
								<%}
							%>
						</select>
					</td>
					<td class="FieldName" nowrap width="60px;" id="<%=LabelType.FormField.toString() %>Td1" style="display: none;">表单：</td>
					<td class="FieldValue" nowrap  width="120px;" id="<%=LabelType.FormField.toString() %>Td2" style="display: none;">
						<button type=button class=Browser name="button_fromid" onclick="javascript:getrefobj('formid','formidspan','402880a51daeee72011daf01434a0002','','0');"></button>
						<input type="hidden" id="formid" name="formid" value=""/>
						<span id="formidspan" name="formidspan"></span>
					</td>
					<td class="FieldName" nowrap width="60px;" id="<%=LabelType.ReportField.toString() %>Td1" style="display: none;">报表：</td>
					<td class="FieldValue" nowrap  width="120px;" id="<%=LabelType.ReportField.toString() %>Td2" style="display: none;">
						<select id="reportdefid" name="reportdefid">
							<option value=""></option>
							<% for(Reportdef reportdef : reportdefList){ %>
								<option value="<%=reportdef.getId() %>"><%=reportdef.getObjname() %></option>
							<% } %>
						</select>
					</td>
					<td class="FieldName" nowrap width="65px;">标签名称：</td>
					<td class="FieldValue" nowrap>
						<input type="text" id="labelname" name="labelname" value="" style="width: 120px;"/>
					</td>
					<td class="FieldName" nowrap width="60px;">keyword：</td>
					<td class="FieldValue" nowrap>
						<input type="text" id="keyword" name="keyword" value="" style="width: 120px;"/>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</div>
</body>
</html>
<script type="text/javascript">
function getrefobj(inputid,inputspanid,refid,viewurl,isneed){
	  var idsin = document.getElementById(inputid).value;
	  var id;
	  if(Ext.isIE){
		  try{
		       var url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
		          if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
		              url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid;
		          }
		  id=openDialog(url);
		  }catch(e){return;}
		  if (id!=null) {
			  if (id[0] != '0') {
					document.getElementById(inputspanid).innerHTML = id[1];
					document.getElementById(inputid).value = id[0];
		
			  }else{
					document.getElementById(inputid).value = '';
					if (isneed=='0')
						document.getElementById(inputspanid).innerHTML = '';
					else
						document.getElementById(inputspanid).innerHTML = '<img src=/images/base/checkinput.gif>';
		
			  }
		   }
	  }else{
	  url='/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
	  var callback = function() {
	          try {
	              id = dialog.getFrameWindow().dialogValue;
	          } catch(e) {
	          }
	          if (id != null) {
	              if (id[0] != '0') {
	                  document.getElementById(inputspanid).innerHTML = id[1];
	                  document.getElementById(inputid).value = id[0];
	              } else {
	                  document.getElementById(inputid).value = '';
	                  if (isneed == '0')
	                      document.getElementById(inputspanid).innerHTML = '';
	                  else
	                      document.getElementById(inputspanid).innerHTML = '<img src=/images/base/checkinput.gif>';

	              }
	          }
	  };
      if (!win) {
           win = new Ext.Window({
              layout:'border',
              width:Ext.getBody().getWidth()*0.8,
              height:Ext.getBody().getHeight()*0.8,
              plain: true,
              modal:true,
              items: {
                  id:'dialog',
                  region:'center',
                  iconCls:'portalIcon',
                  xtype     :'iframepanel',
                  frameConfig: {
                      autoCreate:{ id:'portal', name:'portal', frameborder:0 },
                      eventsFollowFrameLinks : false
                  },
                  defaultSrc:url,
                  closable:false,
                  autoScroll:true
              }
          });
      }
      win.close=function(){
                  this.hide();
                  win.getComponent('dialog').setSrc('about:blank');
                  callback();
              } ;
      win.render(Ext.getBody());
      var dialog = win.getComponent('dialog');
      dialog.setSrc(url);
      win.show();
  }
}
</script>