<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript">
	Ext.onReady(function(){
		Ext.QuickTips.init();
		var tb = new Ext.Toolbar();
	 	tb.render('pagemenubar');
	 	addBtn(tb,'提交','S','accept',function(){onSubmit();});
	 	addBtn(tb,'关闭','C','exclamation',function(){if(parent.closeStyleDialog){parent.closeStyleDialog();}});
	});
</script>
</head>
<body style="overflow: hidden;">
  <div id="pagemenubar"></div>
  <form action="/ServiceAction/com.eweaver.portal.servlet.PortletStyleAction?action=createPortletStyle" method="post" id="EweaverForm">
	  <table style="margin-top: 10px;">
	  	<tr>
			<td class="FieldName" nowrap>样式名称：</td>
			<td nowrap>
				<input type="text" id="objname" name="objname" class="inputstyle" onchange="checkInput('objname','objnamespan')"/>
				<span id="objnamespan" name="objnamespan" style="color: red"/>
					<img src="/images/base/checkinput.gif"/>
				</span>
			</td>
		</tr>
		<tr>
			<td class="FieldName" nowrap width="65px;">描述：</td>
			<td nowrap>
				<textarea id="description" name="description" style="width: 85%" rows="8"></textarea>
			</td>
		</tr>
	  </table>
  </form>
</body>
<script type="text/javascript">
	function onSubmit(){
		var objname = document.getElementById("objname");
		if(objname.value == ""){
			document.getElementById("objnamespan").innerHTML = "请输入样式名称";
		}else{
			var form = document.getElementById("EweaverForm");
			form.submit();
		}
	}
</script>
</html>
