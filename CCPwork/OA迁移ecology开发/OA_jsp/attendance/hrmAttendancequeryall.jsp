<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="/base/init.jsp"%>
<%
String currentdate =DateHelper.getCurrentDate();
String firstDate =getFirstDayOfMonth(currentdate);
String lastDate =getLastDayOfMonth(currentdate);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />

<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<link rel="stylesheet" type="text/css" href="/css/eweaver.css" />
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<script type="text/javascript" language="javascript"  src="/js/weaverUtil.js"></script>
   <style type="text/css">
       .x-toolbar table {width:0}
       #pagemenubar table {width:0}
         .x-panel-btns-ct {
           padding: 0px;
       }
       .x-panel-btns-ct table {width:0}
   </style>
<script type="text/javascript">
WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/TreeViewer.js']);
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';
var topBar=null;
function btnAction(btn){
 var frameWin=Ext.getDom('contentFrame').contentWindow;
 if(btn.id=='search'){
   onSearch();
 }
 else if(btn.id=='reset'){
	reset();
 }
}
Ext.onReady(function(){


	var viewport = new Ext.Viewport({
	layout: 'border',
	items: [{
	contentEl:'searchDiv',
	split:true,
	region:'north',
	tbar:[{id:'search',text:'<%=labelService.getLabelNameByKeyId("40288035249ddfdb01249e0985720006") %>(S)',key:'S',alt:true,//搜索
	iconCls:Ext.ux.iconMgr.getIcon('accept'),handler:btnAction},
	{id:'reset',text:'<%=labelService.getLabelNameByKeyId("40288035248eb3e801248f6fb6da0042") %>',key:'C',alt:true,//清空条件
	iconCls:Ext.ux.iconMgr.getIcon('erase'),handler:btnAction}
 ],               
		autoScroll:true,
		height:80,
		collapseMode:'mini'
	},{
		contentEl:'contentDiv',
		autoScroll:true,
		region:'center'
	}]
  });
  });


function checkIsNull()
{
	var startdate=document.getElementsByName('startdate');
	if(startdate[0].value==null||startdate[0].value=='')
	{
		alert("<%=labelService.getLabelNameByKeyId("402883d934c0338a0134c0338ad60000") %>");//必须填入考勤时间段！
		return false;
	}
	return true;
}
</script>
<body>
<div id="searchDiv" >
<form id="EweaverForm" name="EweaverForm" action="" target="contentFrame" method="post">
<fieldset style="margin-top:4;margin-bottom:4;margin-left:10;margin-right:10;"><legend><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71f4d7580053") %><!-- 查询条件 --></legend>
<table cellspacing="1" border="0" align="center" style="width: 99%;" class="Econtent">
<colgroup>
<col width="10%"/>
<col width="30%"/>
<col width="10%"/>
<col width="20%"/>
<col width="10%"/>
<col width="20%"/>
</colgroup>
<tr class="repCnd">
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdb7aa540020") %></td><!-- 日期 -->
	<td class="FieldValue" nowrap="true">
		<span><input type="text" class=inputstyle  id="startdate" value="<%=firstDate%>"  onClick="WdatePicker()" /></span>-<span><input type="text" class=inputstyle  id="enddate" value="<%=currentdate%>"  onClick="WdatePicker()" /></span>
		</td>

	<td  class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c037f60134c037f7250000") %>: </td><!-- 员工 -->
    <td class="FieldValue" nowrap="true">
     <button  class=Browser type=button onclick="getrefobj('yg','ygspan','402881e70bc70ed1010bc75e0361000f','/humres/base/humresview.jsp?id=','1');"></button>
     <input type="hidden" name="yg" value="" >
     <span id="ygspan" name="ygspan" ></span>
     </td> 
    <td  class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d") %>: </td><!-- 部门 -->
    <td class="FieldValue" nowrap="true">
     <button  class=Browser type=button onclick="getrefobj('bm','bmspan','402881e60bfee880010bff17101a000c','/base/orgunit/orgunitview.jsp?id=','0');"></button>
	  <input type="hidden" name="bm" value="" />
     <span id="bmspan" name="bmspan" ></span>
     </td> 
</tr>
</table>
</fieldset>
</form>
</div>
<div id="contentDiv">
<iframe id="contentFrame" name="contentFrame" src="about:blank" width="100%" height="100%" frameborder="0"></iframe>
</div>
</body>
</html>
<script type="text/javascript" language="javascript">

	function onSearch(){
		if(checkIsNull()){
		var startdate=document.getElementsByName('startdate');
		var sd=startdate[0].value;
		var enddate=document.getElementsByName('enddate');
		var ed=enddate[0].value;
	var url="<%=request.getContextPath()%>/app/attendance/hrmAttendanceTotalAll.jsp?bd="+sd+"&ed="+ed+" 23:59:59";
		document.all('EweaverForm').action=url;

		document.all('EweaverForm').submit();
		}
	}

   function reset(){
      var startdate=document.getElementsByName('startdate');
      var enddate=document.getElementsByName('enddate');
	    if(startdate[0].value!=null&&startdate[0].value!=''){
	    	startdate[0].value='';
	    }
	    if(enddate[0].value!=null&&enddate[0].value!=''){
	    	enddate[0].value='';
	    }
    }
</script>
<%!
   /** 
   *取得每月的第一天 
   * @return 
   */ 
   public static String getFirstDayOfMonth(String  date) 
   { 
	   SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
       Calendar cal = Calendar.getInstance(); 
       try {
    	   cal.setTime(f.parse(date));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
       cal.set(Calendar.HOUR_OF_DAY, 0); 
       cal.set(Calendar.MINUTE, 0); 
       cal.set(Calendar.SECOND, 0); 
       cal.add(Calendar.DATE,-cal.get(Calendar.DAY_OF_MONTH)+1); 
       String start = f.format(cal.getTime()); 
       return start; 
           
   } 
   /** 
   *取得每月的最后一天  
   * @return 
   */ 
   public static String getLastDayOfMonth(String  date) 
   { 
	   SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
	   Calendar cal = Calendar.getInstance(); 
	   try {
		   cal.setTime(f.parse(date));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	   cal.add(Calendar.DATE,-cal.get(Calendar.DAY_OF_MONTH)+1); 
	   cal.add(Calendar.MONTH, 1); 
	   cal.add(Calendar.DATE,-1); 
	   cal.set(Calendar.HOUR_OF_DAY, 23); 
	   cal.set(Calendar.MINUTE, 59); 
	   cal.set(Calendar.SECOND, 59); 
	   String end = f.format(cal.getTime()); 
	   return end; 
   } 


%>
 <script type="text/javascript">
  var win;
  function getrefobj(inputname,inputspan,refid,viewurl,isneed){
	var idsin = document.getElementsByName(inputname)[0].value;
	var id;
    if(Ext.isIE){
    try{
         var url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
                url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid;
            }
    id=window.showModalDialog(url);
    }catch(e){return}
    if (id!=null) {

    if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];

    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '';

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
                    document.all(inputname).value = id[0];
                    document.all(inputspan).innerHTML = id[1];
                } else {
                    document.all(inputname).value = '';
                    if (isneed == '0')
                        document.all(inputspan).innerHTML = '';
                    else
                        document.all(inputspan).innerHTML = '';

                }
            }
        }
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
