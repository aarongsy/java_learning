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
<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<SCRIPT>
function getdata()
{
	
	var startdate=document.getElementById('field_sdate').value;
	var enddate=document.getElementById('field_edate').value;
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
             params:{startdate:startdate,enddate:enddate},                                      
             success: function(res) {                                      
                var str=res.responseText;                   
                document.getElementById('detailHtml').innerHTML=str;         
                //document.getElementById('batchupdate').style.display = '';        
                myMask.hide();             
             }                                     
        });             
                    
}  
</SCRIPT>

<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp" >

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<tr>
  <th>开始日期:</th>
  <td><input class="field" type="text"  id="field_sdate" value="" onclick="WdatePicker()"  onfocus="select();" /></td>
</tr>
<tr>
  <th>结束日期:</th>
  <td><input class="field" type="text"  id="field_edate" value="" onclick="WdatePicker()"  /></td>
</tr>
<tr>
  <th> </th>
  <td align="center"><input class="btn" type="button " value="确  定"  id="getdate" onclick="getdata()"/></td>
</tr>
<TR>
<TD colSpan=4>客人订餐明细 </TD></TR>
<TR>
<TD colSpan=4>
<DIV id=detailHtml></DIV></TD></TR>
<TR>



</table>
</div>
