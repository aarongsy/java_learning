<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%
DataService ds = new DataService();
int pageSize=50;

String devno="";
String devname="";
String devspec="";

%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
    .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
         .x-panel-body {
        border-bottom:#99bbe8 0px solid;
         position:  relative;
         border-left:#99bbe8 0px solid;
        border-right:#99bbe8 0px solid
     }
    .x-panel-body-noheader{
        border-top:#99bbe8 0px solid
    }
	input{ border-left:0px;border-top:0px;border-right:0px;border-bottom:1px solid #0D0000 } span{ vertical-align:top; }
</style>
<script type="text/javascript">
var store=null;
  var sm = new Ext.grid.CheckboxSelectionModel();
  Ext.onReady(function(){
	  var cm = new Ext.grid.ColumnModel([sm,{header:'<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b003a")%>',dataIndex:'assetsnumber',width:100,sortable:true},{header:'<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec715004c")%>',dataIndex:'reqname',width:100,sortable:true},{header:'型号',dataIndex:'standardmodel',width:60,sortable:true},{header:'出厂编号',dataIndex:'leavefactoryno',width:80,sortable:false},{header:'设备条码',dataIndex:'equipmenttm',width:80,sortable:true},{header:'设备类别',dataIndex:'devicetype',width:60,sortable:true},{header:'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e003b")%>',dataIndex:'operate',width:80,sortable:false}]);//设备编号//设备名称//详情
    // create the Data Store
	 store = new Ext.data.JsonStore({
        url:'/app/ft/barcodeAction.jsp?action=getData',
        root: 'result',
        totalProperty: 'totalCount',
        fields: ['id','assetsnumber','reqname','standardmodel','leavefactoryno','equipmenttm','devicetype','operate'],
        baseParams:{sort:'reqname',dir:'asc'},
        remoteSort: true
    });
 //Viewport
        store.on('load',function(st,recs){
               for(var i=0;i<recs.length;i++){
                   var reqid=recs[i].get('id');
               for(var j=0;j<selected.length;j++){
                           if(reqid ==selected[j]){
							   
                                sm.selectRecords([recs[i]],true);
                            }
                        }
           }
           }
                   );
           sm.on('rowselect',function(selMdl,rowIndex,rec ){
               var reqid=rec.get('id');
			   loadDetail(reqid,rec.get('assetsnumber'),rec.get('reqname'),rec.get('standardmodel'),rec.get('leavefactoryno'),rec.get('equipmenttm'))
               for(var i=0;i<selected.length;i++){
                           if(reqid ==selected[i]){
							   
                                return;
                            }
                        }
               selected.push(reqid)
           }
                   );
           sm.on('rowdeselect',function(selMdl,rowIndex,rec){
               var reqid=rec.get('id');
               for(var i=0;i<selected.length;i++){
                           if(reqid ==selected[i]){
							   
                               selected.remove(reqid)
                                return;
                            }
                        }

           }
                   );
 var grid = new Ext.grid.GridPanel({
        region: 'center',
        store: store,
        cm: cm,
        trackMouseOver:false,
        sm:sm ,
        loadMask: true,
        split:true,
        collapsible:true,
        collapseMode:'mini',
        width:300,
        viewConfig: {
            forceFit:true,
            enableRowBody:true,
            sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
            sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
            columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
            getRowClass : function(record, rowIndex, p, store) {
                return 'unread';//'x-grid3-row-collapsed';
            }
        },
        bbar: new Ext.PagingToolbar({
            pageSize: <%=pageSize%>,
            store: store,
            displayInfo: true,
            beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
            afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
            firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
            prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
            nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
            lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示//条记录
            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
        })
    });
  var rightPanel = new Ext.Panel({
		title:'',
		split:true,
        region:'center',
        autoScroll:true,
        layout:'border',
		tbar: [{
                id:'find',
                text: '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b003b")%>',//查询(S)
				key:'S',
                iconCls:Ext.ux.iconMgr.getIcon('zoom'),
                handler : function() {
                    try {
						onSearch();
                        //replyDialog.show('tbadd');
                    } catch(e) {
                    }

                }
            }
			],
		items: [{region:'north',autoScroll:true,contentEl:'listDiv',split:true,height:55},grid]
    })
	loadGrid();
	var viewport = new Ext.Viewport({
	layout: 'border',
	items: [rightPanel,{region:'east',autoScroll:true,contentEl:'barcodeframe',split:true,width:455}]
  });




var div=document.getElementById("pagemenubar2");
	topBar2 = new Ext.Toolbar();
	topBar2.render('pagemenubar2');
	topBar2.addSeparator();
	addBtn(topBar2,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028")%>','P','printer',function(){printPrv()});//打印
	topBar2.addSpacer();
	topBar2.addSpacer();
	var mainPanel2 = new Ext.Panel({
		renderTo:'layout-cardLayout-up',
		title:'<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0035")%>',//条码信息
		id:'wizard',
		layout:'card',//在此设置为card布局
		activeItem: 0,//让向导页处于第一个位置
		width:400,
		height:250,
		bbar: ['->',{
			id: 'getbarcode',
			text: '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0036")%>',//刷新打印
			handler: getBarcodeData,
			disabled: false
		}],
		items: [{
				id: 'card-0',
				html: '<div id="repContainerb"><TABLE style="WIDTH: 315;height=180;margin:10" cellSpacing=0 cellPadding=0 border=0><COLGROUP><COL width="20%"><COL width="80%"></COLGROUP><TR height=35><TD class=FieldName noWrap>编号: </TD><TD class=FieldValue><INPUT type="text" class=InputStyle2 value="" name="devno" size=30></TD></tr><TR height=35><TD class=FieldName noWrap>名称: </TD><TD class=FieldValue><INPUT type="text" class=InputStyle2 value="" name="devname" size=30></TD></tr><TR height=35><TD class=FieldName noWrap>型号: </TD><TD class=FieldValue><INPUT type="text" class=InputStyle2 value="" name="devspec" size=30></TD></TR><TR height=35><TD class=FieldName noWrap>条码: </TD><TD class=FieldValue><INPUT type="text" class=InputStyle2 value="" name="barcode" size=30></TD></tr></tr></table></div>'
			}],
		//-----------------模块销毁函数---------------------------
		destroy:function(){
			
		}
	});
	var mainPanel = new Ext.Panel({
		renderTo:'layout-cardLayout-main',
		title:'<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0037")%>',//条码打印区
		id:'wizard',
		layout:'card',//在此设置为card布局
		activeItem: 0,//让向导页处于第一个位置
		width:400,
		height:300,
		bbar: ['->',{
			id: 'move-next',
			text: ' <%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0038")%>',//打印条码
			handler: printPrv,
			disabled: false
		}],
		items: [{
				id: 'card-0',
				html: '<div id="repContainer" align="left"><TABLE style="WIDTH: 240;font-color:#00000;font-weight:bold;table-layout:fixed;word-break:break-all;" cellSpacing=0 cellPadding=0 border=0><TBODY><TR height=20><TD><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b772f75e3000a")%>: <span id="devnospan"></span></TD></tr><TR><TD><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc16ecb1000b")%>: <span id="devnamespan" style="table-layout:fixed;word-break:break-all;"></span></TD></tr><TR height=20><TD><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b003c")%>: <span id="devspecspan"></span></TD></TR><TR ><TD noWrap style="height:80px" valign=top><span id="barcodeimage"></span></tr><tr><td></td></tr></table></div>'//编号//名称//型号
			}],
		//-----------------模块销毁函数---------------------------
		destroy:function(){
			
		}
	});






  });

  function btnAction(btn){
 if(btn.id=='search'){
   onSearch();
 }
 else if(btn.id=='reset'){
	reset();
 }
}
function onSearch(){
	loadGrid();
}
function reset(){
   document.all('EweaverForm').reset();
}
function checkIsNull()
{
	return true;
}
 var selected = new Array();
function loadGrid()
{
	var cnd_assetsnumber=document.getElementById('cnd_assetsnumber');
	var cnd_reqname=document.getElementById('cnd_reqname');
	var cnd_standardmodel=document.getElementById('cnd_standardmodel');
	var cnd_leavefactoryno=document.getElementById('cnd_leavefactoryno');
	var cnd_equipmenttm=document.getElementById('cnd_equipmenttm');
	var cnd_devicetype=document.getElementById('cnd_devicetype');
	
	store.load({params:{start:0, limit:<%=pageSize%>,cnd_assetsnumber:''+cnd_assetsnumber.value+'',cnd_reqname:''+cnd_reqname.value+'',cnd_standardmodel:''+cnd_standardmodel.value+'',cnd_leavefactoryno:''+cnd_leavefactoryno.value+'',cnd_leavefactoryno:''+cnd_leavefactoryno.value+'',cnd_devicetype:''+cnd_devicetype.value+''}});
}
function loadDetail(id,assetsnumber,reqname,standardmodel,leavefactoryno,equipmenttm)
{
	
	document.getElementById('devno').value=leavefactoryno;
	
	document.getElementById('devname').value=reqname;
	
	document.getElementById('devspec').value=standardmodel;
	document.getElementById('barcode').value=equipmenttm;
	document.getElementById('getbarcode').click();
}
</script>
<body>
<form id="EweaverForm" name="EweaverForm" action="" target="" method="post">
 <input type="hidden" name="exportType" id="exportType" value=""/>
 <div id="barcodeframe">
<div id="pagemenubar2"></div> 
<input type="hidden" name="opType" value="print">
<TABLE style="WIDTH: 315px" cellSpacing=0 cellPadding=0 border=1>
<TBODY>
<tr>
<td colspan=2>
<div id="layout-cardLayout-up" style="margin:10px"></div>
</td>
</tr>
<tr>
<td colspan=2>
<div id="layout-cardLayout-main" style="margin:10px"></div>
</td>
</tr>
</TBODY></TABLE>
</div>
<div id="searchDiv" >
<div id="pagemenubar"></div> 
</div>
<div id="listDiv">
 <table cellspacing="1" border="0" align="center" style="width: 99%;" class="Econtent">
<colgroup>
<col width="13%"/>
<col width="20%"/>
<col width="13%"/>
<col width="20%"/>
<col width="13%"/>
<col width="20%"/>
</colgroup>
<tr class="repCnd">
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b003a")%>：</td><!-- 设备编号 -->
	<td class="FieldValue" nowrap="true">
		<span><input type=text class=inputstyle style="width:90%" name="cnd_assetsnumber" value=""/></span>
		</td>
		<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec715004c")%>：</td><!-- 设备名称 -->
	<td class="FieldValue" nowrap="true">
		<span><input type=text class=inputstyle style="width:90%" name="cnd_reqname" value=""/></span>
		</td>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b003d")%>：</td><!-- 设备型号 -->
	<td class="FieldValue" nowrap="true">
		<span><input type=text class=inputstyle style="width:90%" name="cnd_standardmodel" value=""/></span>
		</td>
	</tr><tr>
		<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7120032")%>：</td><!-- 出厂编号 -->
	<td class="FieldValue" nowrap="true">
		<span><input type=text class=inputstyle style="width:90%" name="cnd_leavefactoryno" value=""/></span>
		</td>
		<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b003e")%>：</td><!-- 设备条码 -->
	<td class="FieldValue" nowrap="true">
		<span><input type=text class=inputstyle style="width:90%" name="cnd_equipmenttm" value=""/></span>
		</td>
		<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b003f")%>：</td><!-- 设备类别 -->
		<td class="FieldValue" nowrap="true">
		<span>
		  <select name="cnd_devicetype" id="cnd_devicetype">
				<option value="" ></option>
	<%
	List templs = ds.getValues("select id,objname from selectitem where typeid='2c91a0302c14a583012c2e212f420dbc' and pid is null and nvl(col1,'0')='0' order by dsporder");
	for(int i=0;i<templs.size();i++)
	{
		Map m = (Map)templs.get(i);
		out.println("<option value=\""+m.get("id").toString()+"\" >"+m.get("objname").toString()+"</option>");
	}
	%>
		 </select>
		 </span>
		</td>
	 </tr>
 </div>


</form>
</body>
</html> 
<SCRIPT> 
function printPrv ()
{  
  var location="/app/base/printBarcode.jsp?opType=print&portrait=true";
	var width=630;
	var height=540;
	var winName='previewRep';
	var winOpt='scrollbars=1';
	 if(width==null || width=='')
    width=400;
  if(height==null || height=='')
    height=200;
  if(winOpt==null)
    winOpt="";
  winOpt="width="+width+",height="+height+(winOpt==""?"":",")+winOpt+", status=1";
  var popWindow=window.open(location,winName,winOpt);
  if(popWindow==null)
  {
    alert('<%=labelService.getLabelNameByKeyId("402883d934c1392c0134c1392c930000")%>');//您的浏览器可能禁止弹出窗口，无法正常运行程序!
    return;
  }  
  popWindow.focus();  
  popWindow.moveTo(0,0);
  
}
function getBarcodeData()
{
	var devnospan = document.getElementById("devnospan");    
	var devnamespan = document.getElementById("devnamespan");    
	var devspecspan = document.getElementById("devspecspan");
	var devno = document.getElementById("devno");  
	var devname = document.getElementById("devname");  
	var devspec = document.getElementById("devspec");  
	var barcode = document.getElementById("barcode"); 
	devnospan.innerHTML=devno.value;
	devnamespan.innerHTML=devname.value;
	devspecspan.innerHTML=devspec.value;
	getBarcode();

}
function getBarcode()
{
   var p = document.getElementById("barcode");          
   if(p&&p.value){           
      var a = p.value;//alert(a.length);           
      h = '<img src=\'/ServiceAction/com.eweaver.customaction.barcode.BarCodeAction?code='+a+'&barType=CODE39&textFont=<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0040")%>|bold|13&checkCharacter=n&checkCharacterInText=n\'>'; 
      document.getElementById('barcodeimage').innerHTML = h;           
   }           
}    
</SCRIPT>
</body>
</html>