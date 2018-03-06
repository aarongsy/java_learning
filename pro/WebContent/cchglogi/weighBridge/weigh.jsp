<%@ page import="com.eweaver.base.sequence.SequenceService" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ include file="/base/init.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
<style type="text/css">
            .x-toolbar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
      #pagemenubar table {width:0}
</style>

<script src='/dwr/interface/DataService.js'></script>
	
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<link href="/cchglogi/css/global.css" rel="stylesheet" type="text/css"> 
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/hoverIntent/jquery.hoverIntent.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/qtip/jquery.qtip.min.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery/plugins/qtip/jquery.qtip.min.css"/>
  </head> 
  
  
  <body>
  <script type="text/javascript">
  Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320021")%>';//加载中,请稍后...
  var weighType; 
  var store1;
  var store2;
  var sm1;
  var sm2;
  //var store3;
  var selected1=new Array();
  var selected2=new Array();
  //var selected3=new Array();
  var selectedRow1 = new Array();
  var selectedRow2 = new Array();
        Ext.onReady(function(){
            Ext.QuickTips.init();
  //start store1     
  	store1 = new Ext.data.Store({
      proxy: new Ext.data.HttpProxy({
          url: '/ServiceAction/com.eweaver.app.weight.servlet.Uf_lo_pandAction?action=searchMain'
      }),
      reader: new Ext.data.JsonReader({
          root: 'result',
          totalProperty: 'totalcount',
      	fields:['id',
      	        'requestid',
      	        'runningno',
      	        'carno',
      	        'plannum',
      	        'loadno',
      	        'ladno',
      	        'materialno',
      	        'materialdesc',
      	        'soldtoname',
      	        'shiptoname',
      	        'conname',
      	        'servicetype',
      	        'drivername',
      	        'conno',
      	        'trailerno',
      	        'signno'
      	        ]
      })
  	});
  //end
  
  //start store2     
  	store2 = new Ext.data.Store({
      proxy: new Ext.data.HttpProxy({
          url: '/ServiceAction/com.eweaver.app.weight.servlet.Uf_lo_pandAction?action=searchRecord'
      }),
      reader: new Ext.data.JsonReader({
          root: 'result',
          totalProperty: 'totalcount',
      	fields:['id',
      	        'requestid',
      	        'isvirtual',
      	        'pondcode',
      	        'ladingno',
      	        'trailerno',
      	        'carno',
      	        'tare',
      	        'grosswt',
      	        'accessvalue',
      	        'nw',
      	        'nottote',
      	        'isvalid',
      	        'edittime'
      	       ]
      })
  	});
  //end
  /*
  //start store3     
  	store3 = new Ext.data.Store({
      proxy: new Ext.data.HttpProxy({
          url: ''
      }),
      reader: new Ext.data.JsonReader({
          root: 'result',
          totalProperty: 'totalcount',
      	fields:['reqid',
      	        'objno'
      	       ]
      })
  	});
  //end
  */


	sm1=new Ext.grid.CheckboxSelectionModel({disabled:false});
	sm2=new Ext.grid.CheckboxSelectionModel();
	//sm3=new Ext.grid.CheckboxSelectionModel();
	//start cm1
	var cm1 = new Ext.grid.ColumnModel([sm1,
	         {header:'流水号',dataIndex:'runningno',hidden:false,width:64,sortable:false,menuDisabled:true},
	         {header:'车牌号',dataIndex:'carno',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'计划运载量',dataIndex:'plannum',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'装卸计划编号',dataIndex:'loadno',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'产品编号',dataIndex:'materialno',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'产品名称',dataIndex:'materialdesc',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'售达方名称',dataIndex:'soldtoname',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'送达方名称',dataIndex:'shiptoname',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'承运商名称',dataIndex:'conname',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'业务类型',dataIndex:'servicetype',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'司机姓名',dataIndex:'drivername',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'货柜号',dataIndex:'conno',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'挂车号',dataIndex:'trailerno',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'封签号',dataIndex:'signno',hidden:false,width:70,sortable:false,menuDisabled:true},
	         {header:'提入单号',dataIndex:'ladno',hidden:false,width:70,sortable:false,menuDisabled:true,
	        	 renderer:function red(value, cellmeta, record, rowIndex, columnIndex, store){
        		 		if(value == $("#plate").val()){
        		 			selectedRow1.push(rowIndex);
        		 		}
        		 		return value;
    		 }}
	         ]);
	cm1.defaultSortable = true;
	//end cm1

  	//start cm2
	var cm2 = new Ext.grid.ColumnModel([sm2,
	         {header:'过磅编号',dataIndex:'pondcode',hidden:false,width:100,sortable:false,menuDisabled:true},
	         {header:'提单号',dataIndex:'ladingno',hidden:false,width:100,sortable:false,menuDisabled:true},
	         {header:'挂车号',dataIndex:'trailerno',hidden:false,width:80,sortable:false,menuDisabled:true},
	         {header:'车牌号',dataIndex:'carno',hidden:false,width:80,sortable:false,menuDisabled:true},
	         {header:'皮重',dataIndex:'tare',hidden:false,width:80,sortable:false,menuDisabled:true},
	         {header:'毛重',dataIndex:'grosswt',hidden:false,width:80,sortable:false,menuDisabled:true},
	         {header:'出入差值',dataIndex:'accessvalue',hidden:false,width:80,sortable:false,menuDisabled:true,
	        	 renderer:function red(value, cellmeta, record, rowIndex, columnIndex, store){
	        		 return changeTwoDecimal(Math.abs(value));
	        		 }
	         },
	         {header:'净重',dataIndex:'nw',hidden:false,width:80,sortable:false,menuDisabled:true,
	        	 renderer:function red(value, cellmeta, record, rowIndex, columnIndex, store){
	        		 return changeTwoDecimal(Math.abs(value));
	        		 }},
	         {header:'货柜',dataIndex:'nottote',hidden:false,width:60,sortable:false,menuDisabled:true},
	         {header:'计重状态',dataIndex:'isvirtual',hidden:false,width:60,sortable:false,menuDisabled:true},
	         {header:'过磅生效',dataIndex:'isvalid',hidden:false,width:60,sortable:false,menuDisabled:true},
	         {header:'操作时间',dataIndex:'edittime',hidden:false,width:136,sortable:false,menuDisabled:true}
	         ]);
	cm2.defaultSortable = true;
	//end cm2
  
	
	//start cm3
	//var cm3 = new Ext.grid.ColumnModel([sm3,
	        // {header:'编号',dataIndex:'deliveryno',hidden:false,width:50,sortable:false,sortable:false,menuDisabled:true},
	        // {header:'名称',dataIndex:'deliveryitem',hidden:false,width:50,sortable:false,menuDisabled:true}
	        // ]);
	//cm3.defaultSortable = true;
	//end cm3
  
  
  
  
  //start grid1  左边表格
    var grid1 = new Ext.grid.GridPanel({
                    region: 'center',
                    store: store1,
                    renderTo:'mid1',
                    cm: cm1,
                    sm: sm1,
                    trackMouseOver:false,
                    width:998,
                    height:178,
                    loadMask: { 
                    	msg: '正在加载数据，请稍侯……' 
                    },//加载完成前显示信息，设置为true则显示Loading
                    selModel: new Ext.grid.RowSelectionModel({ singleSelect: true }), 
                    viewConfig: {
                         scrollOffset: -3  //去掉右侧空白区域  
                     }
                     
  	});
  //end grid1
  
  //start grid2  上部表格
    var grid2 = new Ext.grid.GridPanel({
                    region: 'center',
                    store: store2,
                    renderTo:'mid2',
                    cm: cm2,
                    sm: sm2,
                    trackMouseOver:false,
                    width:998,
                    height:238,
                    loadMask: { 
                    	msg: '正在加载数据，请稍侯……' 
                    },//加载完成前显示信息，设置为true则显示Loading
                    selModel: new Ext.grid.RowSelectionModel({ singleSelect: true }), 
                    viewConfig: {
                         scrollOffset: -3  //去掉右侧空白区域  
                     }
  	});
  //end grid2
  
  /*
  //start grid3  下部表格
    var grid3 = new Ext.grid.GridPanel({
                    region: 'center',
                    store: store3,
                    renderTo:'',
                    cm: cm3,
                    sm: sm3,
                    trackMouseOver:false,
                    width:999,
                    loadMask: { 
                    	msg: '正在加载数据，请稍侯……' 
                    },//加载完成前显示信息，设置为true则显示Loading
                    selModel: new Ext.grid.RowSelectionModel({ singleSelect: true }), 
                    viewConfig: {
                         scrollOffset: -3  //去掉右侧空白区域  
                     }
  	});
  //end grid3
  */
sm1.on('rowselect',function(selMdl,rowIndex,rec ){
var reqid=rec.get('runningno');
//if (typeof(reqid)=='undefined'){reqid=rec.get('deliveryno')+rec.get('deliveryitem');}
for(var i=0;i<selected1.length;i++){
         if(reqid == selected1[i]){
              return;
          }
      }
selected1.push(reqid);
}
 );
sm1.on('rowdeselect',function(selMdl,rowIndex,rec){
var reqid=rec.get('runningno');
//if (typeof(reqid)=='undefined'){reqid=rec.get ('deliveryno');}
for(var i=0;i<selected1.length;i++){
         if(reqid == selected1[i]){
             selected1.remove(reqid);
              return;
          }
      }
}
 );
});
        
        
        
        Ext.override(Ext.grid.CheckboxSelectionModel, {   
            handleMouseDown : function(g, rowIndex, e){     
              if(e.button !== 0 || this.isLocked()){     
                return;     
              }     
              var view = this.grid.getView();     
              if(e.shiftKey && !this.singleSelect && this.last !== false){     
                var last = this.last;     
                this.selectRange(last, rowIndex, e.ctrlKey);     
                this.last = last; // reset the last     
                view.focusRow(rowIndex);     
              }else{     
                var isSelected = this.isSelected(rowIndex);     
                if(isSelected){     
                  this.deselectRow(rowIndex);     
                }else if(!isSelected || this.getCount() > 1){     
                  this.selectRow(rowIndex, true);     
                  view.focusRow(rowIndex);     
                }     
              }     
            }   
        });          
</script>
<!--页面菜单开始-->   
<p>
<OBJECT CLASSID="clsid:648A5600-2C6E-101B-82B6-000000000014" id="MSComm1" codebase="MSCOMM32.OCX" type="application/x-oleobject" style="LEFT: 54px; TOP: 14px" >    
<PARAM NAME="CommPort" VALUE="1">    
<PARAM NAME="DTREnable" VALUE="1">    
<PARAM NAME="Handshaking" VALUE="0">    
<PARAM NAME="InBufferSize" VALUE="256">    
<PARAM NAME="InputLen" VALUE="0">    
<PARAM NAME="NullDiscard" VALUE="0">    
<PARAM NAME="OutBufferSize" VALUE="512">    
<PARAM NAME="ParityReplace" VALUE="?">    
<PARAM NAME="RThreshold" VALUE="1">    
<PARAM NAME="RTSEnable" VALUE="1">    
<PARAM NAME="SThreshold" VALUE="2">    
<PARAM NAME="EOFEnable" VALUE="0">    
<PARAM NAME="InputMode" VALUE="0">    

<PARAM NAME="DataBits" VALUE="8">    
<PARAM NAME="StopBits" VALUE="1">    
<PARAM NAME="BaudRate" VALUE="9600">    
<PARAM NAME="Settings" VALUE="9600,N,8,1">    
</OBJECT>  
</p>
<div style="width: 1160px;height: 540px;">
<div style="width: 1160px;height: 490px;">
	<div id="header">
		<div id="header1" class="header1"><h1>METTLER TOLEDO</h1></div>
		<div id="headerzl" class="headerzl"><span id="weight" name="weight" >0</span></div>
		<div id="headerdw" class="headerdw"><span>kg</span><input type="text" onchange="cg(this)" /></div>
	</div>
	<div style="height: 430px;width: 1000px;float: left">
		<div id="mid1"></div>
		<div id="mid2"></div>
	</div>
	<div id="right">
		<div class="right_bb">
			<table>
				<tr>
					<td><input id="weighwg" type="checkbox" onclick="checkweigh(this)"/><span>无货柜</span></td>
				</tr>
				<tr>
					<td><input class="button blue" id="inweigh" type="button" value="计重" onclick="inweigh();onSearch2();"/></td>
				</tr>
				<tr>
					<td><input class="button blue" id="outweigh" type="button" value="过磅" onclick="outweigh();onSearch2();"/></td>
				</tr>
				<tr>
					<td><input class="button blue" onclick="getWeight()" type="button" value="取磅值" /></td>
				</tr>
				<tr>
					<td><input id="weighkc" type="checkbox" onclick="checkweigh(this)"/><span>空车计重</span></td>
				</tr>
				<tr>
					<td><input id="weighkg" type="checkbox" onclick="checkweigh(this)"/><span>空罐计重</span></td>
				</tr>
				<tr>
					<td><span style="color: red;font-size: 22px;" id="endweight" >0</span></td>
				</tr>
				<tr>
					<td><input class="button blue" type="button" value="虚拟删除" onclick="deleteWeigh()"/></td>
				</tr>
				<tr>
					<td><input class="button blue" type="button" value="模拟过磅" onclick="virweigh()"/></td>
				</tr>
				<!-- 
				<tr>
					<td><input class="button blue" onclick="getrefobj('plate','','40285a9048f924a70148fd0914770519','','','0');" type="button" value="提暂存单" />
						<input id="zcval" name="zcval" type="hidden" />
					</td>
				</tr>
				-->
				
			</table>
		</div>
	</div>
</div>
<div id="footer">
<form id="wForm1" name = "wForm1">
			<div class="footer_left">
			<table>
				<tr>
					<td>
					&nbsp;&nbsp;
					<span style="color: red;font-size: 20px;margin-top: 0px;">提单号：</span>
					<input style="font-size:17px;width:200px;font-weight: bold;margin-top: 10px;" type="text" id="plate" name="plate" />
					</td>
				</tr>
			</table>
			</div>
			<div class="footer_right">                                                                                                                                     
			<table>
				<tr>
					<td>
						<span>车牌号</span><br/>
						<input class="input_footer" type="text" value="" id="carno" readonly/>
					</td>
					<td>
						<span>毛重</span><br/>
						<input class="input_footer" type="text" value="0" id="grosswt" readonly/>
					</td>
					<td>
						<span>皮重</span><br/>
						<input class="input_footer" type="text" value="0" id="tare" readonly/>
					</td>
					<td>
						<span>净重</span><br/>
						<input class="input_footer" type="text" value="0" id="nw" readonly/>
					</td>
				</tr>
			</table>
			</div>
</form>
</div>
</div>
</body>
</html>
<script type="text/javascript">
function cg(obj){
	$("#weight").html(obj.value);
}

document.onkeydown=function(event){
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if(e && e.keyCode==27){ // 按 Esc 
        //要做的事情
    }
    if(e && e.keyCode==113){ // 按 F2 
         //要做的事情
    }            
     if(e && e.keyCode==13){ // enter 键
    	 //var weight = $("#plate").val();
    	 selectedRow1 = new Array();
		 selectedRow2 = new Array();
    	 onSearch1();
    	 onSearch2();
    }
}; 

function inweigh(){
	var weight = $("#endweight").html();
	if(weight == "0"){
		alert("磅值为0，无法计重！");
	}else{
		 try{
			   DWREngine.setAsync(false);//设置为同步获取数据
		       Ext.Ajax.request({
		    	    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.weight.servlet.Uf_lo_pandAction',
		    	    params: {
		    	     action : "inweigh",
		    	     plate : $("#plate").val(),
		    	     weight : weight,
		    	     weighType : weighType
		    	     //配置传到后台的参数
		    	    },
		    	    success: function(response){  //success中用response接受后台的数据
		    	    	if("unable" == response.responseText){
		    	    		alert("计重失败，请检提入单是否已真实计重或其他原因！");
		    	    	}else if("unprint" == response.responseText){
		    	    		alert("计重失败，请检提入单是否存在且已打印！");
		    	    	}
		    	    	reset();
		    	    },
		    	    failure: function(){
		    	     Ext.Msg.show({
		    	      title: '错误提示',
		    	      msg: '访问数据库时发生错误!',
		    	      buttons: Ext.Msg.OK,
		    	      icon: Ext.Msg.ERROR
		    	     });
		    	    }
		    	   }); 
			   DWREngine.setAsync(true);//设置为同步获取数据
		   }catch(e){
			   alert("系统错误，请尽快联系管理员处理！");
		   }
	}
	onSearch2();
}
function outweigh(){
	var weight = $("#endweight").html();
	if(weight == "0"){
		alert("磅值为0，无法过磅！");
	}else{
		 try{
			   DWREngine.setAsync(false);//设置为同步获取数据
		       Ext.Ajax.request({
		    	    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.weight.servlet.Uf_lo_pandAction',
		    	    params: {
		    	     action : "outweigh",
		    	     plate : $("#plate").val(),
		    	     weight : weight,
		    	     weighType : weighType
		    	     //配置传到后台的参数
		    	    },
		    	    success: function(response){  //success中用response接受后台的数据
		    	    	if("unable" == response.responseText){
		    	    		alert("过磅失败，请检提入单是否已真实计重或其他原因！");
		    	    	}else{
		    	    		var arr = response.responseText.split(";;");
		    	    		if(arr.length=4){
		    	    			$("#carno").val(arr[0]);
		    	    			$("#grosswt").val(arr[1]);
		    	    			$("#tare").val(changeTwoDecimal(arr[2]));
		    	    			$("#nw").val(changeTwoDecimal(Math.abs(arr[3])));
		    	    			reset();
		    	    		}
		    	    		if(arr[3]<0&&weighType!="weighwg"){
		    	    			alert("过磅失败，请根据单据类型检查出入重差值！");
		    	    		}
		    	    	}
		    	    },
		    	    failure: function(){
		    	     Ext.Msg.show({
		    	      title: '错误提示',
		    	      msg: '访问数据库时发生错误!',
		    	      buttons: Ext.Msg.OK,
		    	      icon: Ext.Msg.ERROR
		    	     });
		    	    }
		    	   }); 
			   DWREngine.setAsync(true);//设置为同步获取数据
		   }catch(e){
			   alert("系统错误，请尽快联系管理员处理！");
		   }
	}
	onSearch2();
}

function virweigh(){
	var weight = $("#endweight").html();
	if(weight == "0"){
		alert("磅值为0，无法过磅！");
	}else{
		 try{
			   DWREngine.setAsync(false);//设置为同步获取数据
		       Ext.Ajax.request({
		    	    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.weight.servlet.Uf_lo_pandAction',
		    	    params: {
		    	     action : "viroutweigh",
		    	     plate : $("#plate").val(),
		    	     weight : weight,
		    	     weighType : weighType
		    	     //配置传到后台的参数
		    	    },
		    	    success: function(response){  //success中用response接受后台的数据
		    	    	if("unable" == response.responseText){
		    	    		alert("过磅失败，请检提入单是否已真实计重或其他原因！");
		    	    	}else{
		    	    		var arr = response.responseText.split(";;");
		    	    		//alert(arr.length);
		    	    		if(arr.length=4){
		    	    			$("#carno").val(arr[0]);
		    	    			$("#grosswt").val(arr[1]);
		    	    			$("#tare").val(changeTwoDecimal(arr[2]));
		    	    			$("#nw").val(changeTwoDecimal(Math.abs(arr[3])));
		    	    			reset();
		    	    		}
		    	    		if(arr[3]<0&&weighType!="weighwg"){
		    	    			alert("过磅失败，请根据单据类型检查出入重差值！");
		    	    		}
		    	    	}
		    	    },
		    	    failure: function(){
		    	     Ext.Msg.show({
		    	      title: '错误提示',
		    	      msg: '访问数据库时发生错误!',
		    	      buttons: Ext.Msg.OK,
		    	      icon: Ext.Msg.ERROR
		    	     });
		    	    }
		    	   }); 
			   DWREngine.setAsync(true);//设置为同步获取数据
		   }catch(e){
			   alert("系统错误，请尽快联系管理员处理！");
		   }
	}
}

function checksm1(){
	sm1.selectRows(selectedRow1);
}
function onDetail(id){
var url="<%= request.getContextPath()%>/app/attendance/attendanceDetail.jsp?id=8a8adbb73a632823013a635214e10008";
onUrl(url,'考勤详细列表','tab_8a8adbb73a632823013a635214e10008');                                                                                 
}

function onSearch1(){
	var $ = jQuery;
	var o=$('#wForm1').serializeArray();
	var data={};
	for(var i=0;i<o.length;i++) {
		if(o[i].value!=null&&o[i].value!=""){
			data[o[i].name]=o[i].value;
		}
	}
	store1.baseParams=data;
	store1.baseParams.datastatus='';
	store1.baseParams.isindagate='';
	store1.load({params:{plate:$("#plate").val()}});
	selected1 = [];
	setTimeout(checksm1,1000);
}

function onSearch2(){
	var $ = jQuery;
	var o=$('#wForm1').serializeArray();
	var data={};
	for(var i=0;i<o.length;i++) {
		if(o[i].value!=null&&o[i].value!=""){
			data[o[i].name]=o[i].value;
		}
	}
	store2.baseParams=data;
	store2.baseParams.datastatus='';
	store2.baseParams.isindagate='';
	store2.load({params:{plate:$("#plate").val()}});
	selected2 = [];
}
	
function reset(){
	$("#endweight").html("0");
	$("#plate").val("");
	//$("#carno").val("");
	//$("#grosswt").val("");;
	//$("#tare").val("");
	//$("#nw").val("");
}
function checkweigh(obj){
	if(weighType == obj.id){
		obj.checked = false;
		weighType = "";
	}else{
		$("#weighwg").attr("checked",false);
		$("#weighkc").attr("checked",false);
		$("#weighkg").attr("checked",false);
		obj.checked = true;
		weighType = obj.id;
	}
	if(weighType=="weighkc"||weighType=="weighkg"){
		$("#inweigh").attr("disabled",false);
		$("#inweigh").attr("class","button blue");
		$("#outweigh").attr("disabled",true);
		$("#outweigh").attr("class","button gray");
	}else if(weighType=="weighwg"){
		$("#inweigh").attr("disabled",true);
		$("#inweigh").attr("class","button gray");
		$("#outweigh").attr("disabled",false);
		$("#outweigh").attr("class","button blue");
	}else{
		$("#inweigh").attr("disabled",false);
		$("#inweigh").attr("class","button blue");
		$("#outweigh").attr("disabled",false);
		$("#outweigh").attr("class","button blue");
	}
}
//取磅值
function getWeight(){
	$("#endweight").html($("#weight").html());
}


//删除原因

var win = new Ext.Window({  
         title: "原因",  
         width:300,  
         height:160, 
         closeAction:'hide', 
         plain:true,  
         layout:"form",      
         defaultType:"textfield",      
         labelWidth:60,      
         bodyStyle:"padding-top: 10px; padding-left:10px;",
         modal:true ,
         //defaults:{anchor:"100%"},      
         items:[{ 
             xtype: "panel" ,   
             baseCls: "x-plain" , 
             layout: "column" , 
             html: "<div><textarea style='width:262px;height:75px;' id='reason'></textarea></div>"             
         }], 
         buttons:[  
             {text:"确认",handler:function(){   
            		win.hide();
            		try{
            		       Ext.Ajax.request({
            		    	    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.weight.servlet.Uf_lo_pandAction',
            		    	    params: {
            		    	     action : "deleteweigh",
            		    	     plate : $("#plate").val(),
            		    	     reason : $("#reason").val()
            		    	    },
            		    	    success: function(response){  //success中用response接受后台的数据
            		    	    	//var we = response.responseText;
            		    	    	if("unable" == response.responseText){
            		    	    		alert("删除失败，已过磅或提单不存在！");
            		    	    	}else{
            		    				onSearch2();
            		    			}
            		    	    },
            		    	    failure: function(){
            		    	     Ext.Msg.show({
            		    	      title: '错误提示',
            		    	      msg: '访问接口时发生错误!请联系管理员!', 
            		    	      buttons: Ext.Msg.OK,
            		    	      icon: Ext.Msg.ERROR
            		    	     });
            		    	    }
            		    	   }); 
            		   }catch(e){         
            			   alert(e);
            		   }
             }}
        ]  
     });  

function deleteWeigh(){
	if($("#plate").val().length<1){
	 	alert("未输入提单号!");
   	}else{
   		$("#reason").val("");
        win.show(); 
   	}
}





function syncWeigh(){
	   try{
	       Ext.Ajax.request({
	    	    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.sap.iface.WeighSyncAction',
	    	    params: {
	    	     action : "syncWeigh"
	    	    },
	    	    success: function(response){  //success中用response接受后台的数据
	    	    	var we = response.responseText;
	    			if(isnum.test(we)){
	    				$("#weight").html(we);
	    			}
	    	    },
	    	    failure: function(){
	    	     Ext.Msg.show({
	    	      title: '错误提示',
	    	      msg: '访问接口时发生错误!请联系管理员!', 
	    	      buttons: Ext.Msg.OK,
	    	      icon: Ext.Msg.ERROR
	    	     });
	    	    }
	    	   }); 
	   }catch(e){         
		   alert(e);
	   }
}

//setInterval(syncWeigh,1000);




</script>

<SCRIPT ID=clientEventHandlersJS LANGUAGE=javascript>    
//重写 mscomm 控件的唯一事件处理代码    
var we1 = "";
var we2 ="";
function MSComm1_OnComm(){    
	if(MSComm1.CommEvent==1){//如果是发送事件    
	    //window.alert("请读条码");//这句正常，说明发送成功了    
	}else if(MSComm1.CommEvent==2){//如果是接收事件    
		var we = MSComm1.Input;
		we1 = we2.trim();
		we2 = we.trim();
		//if(we2.substring())
		//var wea;
		//$("#weight").html($("#weight").html()+"|"+we);
		if(we2.trim().substr(we2.trim().length-2) == " 0"){
			we = we1+we2;
			if(we.length>3){
				we = we.substring(3).trim();
				wenum = we.indexOf(" ");
				if(wenum>0){
					we = we.substring(0,wenum);
				}
				$("#weight").html(we);
				//$("#weight").html($("#weight").html()+"|"+we);
			}
		}
	}
}    


function changeTwoDecimal(floatvar){
var f_x = parseFloat(floatvar);
if (isNaN(f_x)){
	//alert('function:changeTwoDecimal->parameter error');
	return "0.00";
}
var f_x = Math.round(floatvar*100)/100;
var s_x = f_x.toString();
var pos_decimal = s_x.indexOf('.');
if (pos_decimal < 0){
	pos_decimal = s_x.length;
	s_x += '.';
}
while (s_x.length <= pos_decimal + 2){
	s_x += '0';
}
return s_x;
}

</SCRIPT>    

<SCRIPT LANGUAGE=javascript FOR=MSComm1 EVENT=OnComm>    
// MSComm1控件每遇到 OnComm 事件就调用 MSComm1_OnComm()函数    
MSComm1_OnComm();    
</SCRIPT>    
<script language="JavaScript" type="text/JavaScript">    
var isnum =new RegExp("^[0-9]*$");
//打开端口并发送命令程序    
function OpenPort(){
	if(MSComm1.PortOpen==false){  
		MSComm1.PortOpen=true;    
		//MSComm1.Output="R";//发送命令    
	}else{    
	    window.alert ("已经开始接收数据!");    
	}    
}   
function ClosePort(){
	if(MSComm1.PortOpen==true){  
		MSComm1.PortOpen=false;    
	}  
}
OpenPort();
</script> 

