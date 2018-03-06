<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>

<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css" />
<link rel="stylesheet" type="text/css" id="global_css" href="/css/skins/skin1/global.css?1422582615223"/> 
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/xtheme-gray.css"/>
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
<style type="text/css"> 


tr.tr1{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.title{ 
	font-size:12px; 
	font-weight:bold;
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.hj{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#e46d0a; 
} 
td.td1{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td2{ 
	height: 22px;
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none; 
    color:#000; 

} 


</style>
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
td.FieldValue ol{
    list-style:decimal;
}
td.FieldValue ul{
	list-style:disc;
}
td.FieldValue li{
	margin-left:35px;
}
td.FieldValue strong{
    font-weight:bold;
}
td.FieldValue em{
    font-style:italic;
}
/*仪表盘元素的样式*/
.gaugeChart{
	display: inline-block;
}
.x-panel .x-toolbar{
	overflow: auto; 
}
.x-panel .x-toolbar-ieCompatibilityViewOverflow{	/*兼容性视图总toolbar超出时对应的样式*/
	+height: 40px;
}
</style>
<style> 
    .x-panel-btns-ct {
          padding: 0px;
      }
</style>


<!--<script type="text/javascript" src="/js/bindJSToFormfield.js"></script>
<script type="text/javascript" src="/js/browserHackOfForm.js"></script>
<script type="text/javascript" src="/js/ext/ux/ajax.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>-->
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/interface/FormbaseService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script type="text/javascript" src="/js/rtxint.js"></script>
<script type="text/javascript" src="/js/browinfo.js"></script>
<script  type='text/javascript' src='/js/workflow.js'></script>

<script language="JavaScript" src="/chart/fusionchart/FusionCharts.js"></script>
<script type="text/javascript" src="/js/table.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script> <!-- 之前的jquery不支持属性*= -->
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/aop.pack.js"></script>    
<script type="text/javascript" src="/js/jquery/plugins/uploadify/jquery.uploadify-3.1.min.js"></script>

<script type="text/javascript" language="javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/CKEditorExt.js"></script>
<script type="text/javascript" src="/js/justgage/justgage.1.0.1.min.js"></script>
<script type="text/javascript" src="/js/justgage/raphael.2.1.0.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/resize/jquery.ba-resize.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type="text/javascript" language="javascript" src="/fck/FCKEditorExt.js"></script>
<script type="text/javascript" language="javascript" src="/fck/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/js/weaverUtil.js?v=1504"></script>
<script type="text/javascript" language="javascript" src="/app/js/pubUtil.js"></script>

<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>


    <script type="text/javascript">
        var iconBase = '/images';
        var fckBasePath= '/fck/';
        var contextPath='';
        var style='gray';
        
        /**禁止按Backspace键使网页后退**/
        function disabledBackspaceForBackPage(docElement){
			if(docElement.attachEvent){
				document.attachEvent("onkeydown", disabledBackspaceHandler);
			}else if(docElement.addEventListener){
				document.addEventListener("keydown", disabledBackspaceHandler, false);
			}
			
			function disabledBackspaceHandler(e){
				if(e.keyCode == 8){	//enter backspace
					var srcElementType = e.srcElement.type;
					if(srcElementType != "text" && srcElementType != "textarea" && srcElementType != "password"){
						e.returnValue = false;
					}
				}
			}
		}
        if(document){disabledBackspaceForBackPage(document);}
    </script>

<SCRIPT>
function getdata()
{
	
	var startdate=document.getElementById('field_sdate').value;
	var enddate=document.getElementById('field_edate').value;
	var comptype=document.getElementById('comptype').value;
	if(comptype.value=='')
	{
		alert('请选择厂区别');
	}
	//alert(window.location.href);
	if(startdate=='')
	{
	startdate='2014-01-01';
	}
	if(enddate=='')
	{
	enddate='9999-12-31';
	}
	

	// document.getElementById('field_sdate').value='';
	// document.getElementById('field_edate').value='';
	//刷新
   
      
        var myMask = new Ext.LoadMask(Ext.getBody(), {             
            msg: '加载中,请稍后...',             
            removeMask: true              
        });             
        myMask.show();          
        Ext.Ajax.request({                                      
             url: '/app/hrmanage/unitfood/ordershow.jsp',                                     
             params:{startdate:startdate,enddate:enddate,comptype:comptype},                                      
             success: function(res) {                                      
                var str=res.responseText;                   
                document.getElementById('detailHtml').innerHTML=str;         
                //document.getElementById('batchupdate').style.display = '';        
                myMask.hide();             
             }                                     
        });             
                    
}  
     function exportExcel1(){
          window.frames('splitIframe').document.forms[0].action="/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?reportid=40285a90495b4eb0014974ab9470536f&action=reportExport&contemplateid=";
           window.frames('splitIframe').document.forms[0].submit();
      }

</SCRIPT>

<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<CENTER>
<DIV id=layoutDiv>
<TABLE class=layouttable border=1>
<CAPTION>客人订餐查询</CAPTION>
<COLGROUP>
<COL width="12%">
<COL width="38%">
<COL width="12%">
<COL width="38%"></COLGROUP>
<TBODY>


<tr>
  <td class=FieldName noWrap>开始日期:</td>
  <td class=FieldValue><input   class=InputStyle2  id="field_sdate" value="" onclick="WdatePicker()"  /></td>
    <td class=FieldName noWrap>结束日期:</td>
  <td class=FieldValue><input   class=InputStyle2  id="field_edate" value="" onclick="WdatePicker()"  /></td>
</tr>

<TR>
    <td class=FieldName noWrap>厂区别:</td>
  <td class=FieldValue>
  <select class="InputStyle6"    id="comptype"  >
  <option value=""  selected  ></option>
  <option value="4028804d2083a7ed012083ebb988005b"  >常熟厂</option>
  <option value="40285a90488ba9d101488bbd09100007"  >盘锦厂</option>
  <option value="40285a90488ba9d101488bbdeeb30008"  >厂沙厂</option>
  </select>
  </td>
<TD colSpan=2>客人订餐明细<input type="button"  value="查 询"  id="getdate" onclick="getdata()"/>
<input type="button" value="导 出" onclick="exportExcel1()"/></td>
</TR>


</TBODY>

</table>
<DIV style="BORDER-BOTTOM: #000000 0px solid; BORDER-LEFT: #000000 0px solid; WIDTH: 100%; OVERFLOW: scroll; BORDER-TOP: #000000 0px solid; BORDER-RIGHT: #000000 0px solid">
<TABLE class=layouttable border=1>
<TR>
<TD colSpan=4>
<DIV id=detailHtml></DIV></TD></TR>
</tbody>
</table>
</div>
</div>
<CENTER>