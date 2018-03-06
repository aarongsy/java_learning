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
<link href="/cchglogi/css/global.css" rel="stylesheet" type="text/css"> 
<link rel="stylesheet" type="text/css" href="/js/jquery/plugins/qtip/jquery.qtip.min.css"/>
  </head> 
  <body>
  
<div style="width: 1160px;height: 540px;">
<table>
				<tr> 
					<td>
					&nbsp;&nbsp;
					<span style="color: red;font-size: 20px;margin-top: 0px;">ID：</span>
					<input style="font-size:17px;width:200px;font-weight: bold;margin-top: 10px;" value="1020T00000042" type="text" id="plate" name="plate" />
					</td>
					<td><input class="button blue" type="button" value="二维码生成" onclick="to()"/></td>
				</tr>
</table>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="" height="200px" width="600px" id="txm"> 
</div>
</body>
<script type="text/javascript">
function to(){
	document.getElementById("txm").setAttribute("src","/barcode?data="+document.getElementById("plate").value+"&type=Code39&width=1&height=20");
}
</script>
</html>
