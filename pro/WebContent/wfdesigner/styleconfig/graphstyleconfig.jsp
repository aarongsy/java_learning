<!DOCTYPE HTML>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.workflow.designer.GraphStyleConfigWrap"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
	<title>Graph Style Config</title>
	<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
	<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/modcoder_excolor/jquery.modcoder.excolor.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/form/jquery.form.js"></script>
	<script type="text/javascript">
		var tb;
		$(function(){
			document.getElementById("pagemenubar").style.width = document.body.clientWidth + "px";
			Ext.QuickTips.init();
			tb = new Ext.Toolbar();
			tb.render('pagemenubar');
			//保存
			addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")%>','S','accept',function(){$("#EweaverForm").submit();});
			//恢复默认
			addBtn(tb,'<%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8590001")%>','H','arrow_redo',function(){restoreDefault();});
			
			$("#leftDiv input.colorTextStyle").modcoder_excolor();
			
			beAjaxTheFormSubmit();
		});
		
		function beAjaxTheFormSubmit(){
			$("#EweaverForm").ajaxForm({
				beforeSubmit:function(){
					var colorTexts = $(".colorTextStyle").toArray();
					var numberTexts = $(".numberTextStyle").toArray();
					var allTexts = [];
					$.merge(allTexts, colorTexts);
					$.merge(allTexts, numberTexts);
					for(var i = 0; i < allTexts.length; i++){
						if($.trim(allTexts[i].value) == ""){
							alert("设置的样式数据必须完整,请填写为空的项.");
							allTexts[i].focus();
							return false;
						}
					}
					var colorReg = /^#([a-f\d]{3}){1,2}$/i;
					for(var i = 0; i < colorTexts.length; i++){
						if(!colorReg.test(colorTexts[i].value)){
							alert(colorTexts[i].value + " 不是合法的16进制颜色值,请更正.");
							colorTexts[i].focus();
							return false;
						}
					}
					for(var i = 0; i < numberTexts.length; i++){
						if(isNaN(numberTexts[i].value)){
							alert(numberTexts[i].value + " 不是数字,请更改为数字.");
							numberTexts[i].focus();
							return false;
						}
					}
					
					tb.disable();
					return true;
				},
		        success: function(responseText, statusText, xhr, $form){
		        	if(responseText == "success"){
		        		if(top.pop){
							top.pop("<span>保存成功！<span>");
						}else{
							alert("保存成功！");
						}
		        	}else{
		        		alert("error:\n" + responseText);
		        	}
		        	tb.enable();
		        }
			}); 
		}
		
		function restoreDefault(){
			if(confirm("恢复默认会覆盖掉现有的样式设置，确定要执行此操作吗?")){
				$.ajax({
				 	type: "POST",
				 	url: encodeURI("/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=restoreDefaultGraphStyle"),
				 	beforeSend: function(){
						tb.disable();
						return true;
				 	},
				 	success: function(responseText, textStatus) 
				 	{
				 		tb.enable();
				 		if(responseText == "success"){
			        		if(top.pop){
								top.pop("<span>操作成功！<span>");
							}else{
								alert("操作成功！");
							}
			        		location.reload();
			        	}else{
			        		alert("操作失败！\n" + responseText);
        				}
				 	}
				});
			}	
		}
		
		function changeEnabled(cb){
			$("#graphStyle_isEnabled").val(cb.checked);
			$("#graphStyle_isEnabledTip").css("display", cb.checked ? "none" : "");
		}
	</script>
	<style type="text/css">
		#leftDiv{
			margin: 10px;
			width: 725px;
		}
		#leftDiv legend{
			font-family: Microsoft YaHei;
			font-weight:bold;
			color:#666;
			font-size: 14px;
		}
		#leftDiv .basic{
			font-family: Microsoft YaHei;
			padding-left: 5px;
			margin-bottom: 5px;
		}
		#leftDiv .nodeInfo{
			width: 230px;
			float: left;
			margin: 5px;
		}
		#leftDiv .lineInfo{
			width: 350px;
			float: left;
			margin: 5px;
		}
		#leftDiv .nodeInfo legend, #leftDiv .lineInfo legend{
			color:#878788;
			font-size: 12px;
		}
		#leftDiv table{
			margin: 5px 5px 5px 10px;
		}
		#leftDiv table tr{
			line-height: 25px;
		}
		#leftDiv table tr td{
			font-family: Microsoft YaHei;
		}
		#leftDiv .line{
			margin-top: 10px;
		}
		.textStyle,.numberTextStyle,.colorTextStyle{
			height: 18px;
		}
		.cbox{
			height:13px; 
			vertical-align:text-top; 
			margin-top:1px;
			margin-right: 3px;
		}
	</style>
</head>
  
<body>
	<div id="pagemenubar"></div>
	<form action="/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=configGraphStyle" method="post" id="EweaverForm">
	<div id="leftDiv">
		<div class="basic">
			<input type="checkbox" class="cbox" onclick="javascript:changeEnabled(this);" <%if("true".equals(GraphStyleConfigWrap.get("graphStyle.isEnabled"))){%>checked="checked"<%}%>><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8590003")%><!-- 启用该设置中的这些样式 -->
			<font id="graphStyle_isEnabledTip" color="red" style="margin-left: 3px;<%if("true".equals(GraphStyleConfigWrap.get("graphStyle.isEnabled"))){%>display:none;<%}%>"><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8590005")%><!-- (注意：该选项默认是不启用的，如不启用，这些设置的样式是不会应用到流程图中的。) --></font>
			<input type="hidden" id="graphStyle_isEnabled" name="graphStyle.isEnabled" value="<%=GraphStyleConfigWrap.get("graphStyle.isEnabled") %>"/>
		</div>
		<div class="node">
			<fieldset style="padding-bottom: 5px;">
				<legend><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8590007")%><!-- 节点样式设置 --></legend>
				<div class="nodeInfo">
					<fieldset>
						<legend><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8590009")%><!-- 已流转的节点 --></legend>
						<table style="border: 0px solid red;">
							<colgroup>
								<% if("en_US".equals(suser.getLanguage())){ %>
									<col width="100px"/>
								<% }else{ %>
									<col width="70px"/>
								<% } %>
								<col width="*"/>
							</colgroup>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690013")%><!-- 边框颜色 -->：</td>
								<td><input type="text" name="beCirculatedNode.strokeColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("beCirculatedNode.strokeColor") %>"/></td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690015")%><!-- 背景颜色 -->：</td>
								<td><input type="text" name="beCirculatedNode.fillColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("beCirculatedNode.fillColor") %>"/></td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690017")%><!-- 背景渐变 -->：</td>
								<td><input type="text" name="beCirculatedNode.gradientColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("beCirculatedNode.gradientColor") %>"/></td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("32123de43f654e028c611d68c785d218")%><!-- 字体大小 -->：</td>
								<td><input type="text" name="beCirculatedNode.fontSize" size="8" class="numberTextStyle" value="<%=GraphStyleConfigWrap.get("beCirculatedNode.fontSize") %>"/>px</td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690019")%><!-- 字体颜色 -->：</td>
								<td><input type="text" name="beCirculatedNode.fontColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("beCirculatedNode.fontColor") %>"/></td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d869001b")%><!-- 是否圆角 -->：</td>
								<td>
									<input type="radio" name="beCirculatedNode.rounded" value="1" <%if("1".equals(GraphStyleConfigWrap.get("beCirculatedNode.rounded"))){%> checked="checked" <%}%>/><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是  -->
									<input type="radio" name="beCirculatedNode.rounded" value="0" <%if("0".equals(GraphStyleConfigWrap.get("beCirculatedNode.rounded"))){%> checked="checked" <%}%>/><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否  -->
								</td>
							</tr>
						</table>
					</fieldset>	
				</div>
				<div class="nodeInfo">
					<fieldset>
						<legend><%=labelService.getLabelNameByKeyId("402883f6358493fe01358493fea00002")%><!-- 当前节点 --></legend>
						<table style="border: 0px solid red;">
							<colgroup>
								<% if("en_US".equals(suser.getLanguage())){ %>
									<col width="100px"/>
								<% }else{ %>
									<col width="70px"/>
								<% } %>
								<col width="*"/>
							</colgroup>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690013")%><!-- 边框颜色 -->：</td>
								<td><input type="text" name="currNode.strokeColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("currNode.strokeColor") %>"/></td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690015")%><!-- 背景颜色 -->：</td>
								<td><input type="text" name="currNode.fillColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("currNode.fillColor") %>"/></td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690017")%><!-- 背景渐变 -->：</td>
								<td><input type="text" name="currNode.gradientColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("currNode.gradientColor") %>"/></td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("32123de43f654e028c611d68c785d218")%><!-- 字体大小 -->：</td>
								<td><input type="text" name="currNode.fontSize" size="8" class="numberTextStyle" value="<%=GraphStyleConfigWrap.get("currNode.fontSize") %>"/>px</td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690019")%><!-- 字体颜色 -->：</td>
								<td><input type="text" name="currNode.fontColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("currNode.fontColor") %>"/></td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d869001b")%><!-- 是否圆角 -->：</td>
								<td>
									<input type="radio" name="currNode.rounded" value="1" <%if("1".equals(GraphStyleConfigWrap.get("currNode.rounded"))){%> checked="checked" <%}%>/><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是 -->
									<input type="radio" name="currNode.rounded" value="0" <%if("0".equals(GraphStyleConfigWrap.get("currNode.rounded"))){%> checked="checked" <%}%>/><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 -->
								</td>
							</tr>
						</table>
					</fieldset>	
				</div>
				<div class="nodeInfo">
					<fieldset>
						<legend><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d859000b")%><!-- 未流转的节点 --></legend>
						<table style="border: 0px solid red;">
							<colgroup>
								<% if("en_US".equals(suser.getLanguage())){ %>
									<col width="100px"/>
								<% }else{ %>
									<col width="70px"/>
								<% } %>
								<col width="*"/>
							</colgroup>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690013")%><!-- 边框颜色 -->：</td>
								<td><input type="text" name="unCirculatedNode.strokeColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("unCirculatedNode.strokeColor") %>"/></td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690015")%><!-- 背景颜色 -->：</td>
								<td><input type="text" name="unCirculatedNode.fillColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("unCirculatedNode.fillColor") %>"/></td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690017")%><!-- 背景渐变 -->：</td>
								<td><input type="text" name="unCirculatedNode.gradientColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("unCirculatedNode.gradientColor") %>"/></td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("32123de43f654e028c611d68c785d218")%><!-- 字体大小 -->：</td>
								<td><input type="text" name="unCirculatedNode.fontSize" size="8" class="numberTextStyle" value="<%=GraphStyleConfigWrap.get("unCirculatedNode.fontSize") %>"/>px</td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690019")%><!-- 字体颜色 -->：</td>
								<td><input type="text" name="unCirculatedNode.fontColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("unCirculatedNode.fontColor") %>"/></td>
							</tr>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d869001b")%><!-- 是否圆角 -->：</td>
								<td>
									<input type="radio" name="unCirculatedNode.rounded" value="1" <%if("1".equals(GraphStyleConfigWrap.get("unCirculatedNode.rounded"))){%> checked="checked" <%}%>/><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是 -->
									<input type="radio" name="unCirculatedNode.rounded" value="0" <%if("0".equals(GraphStyleConfigWrap.get("unCirculatedNode.rounded"))){%> checked="checked" <%}%>/><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 -->
								</td>
							</tr>
						</table>
					</fieldset>	
				</div>
			</fieldset>
		</div>
		<div class="line">
			<fieldset style="padding-bottom: 5px;">
				<legend><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d859000d")%><!-- 连接线样式设置 --></legend>
				<div class="lineInfo">
					<fieldset>
						<legend><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d859000f")%><!-- 已流转的连接线 --></legend>
						<table style="border: 0px solid red;">
							<colgroup>
								<col width="36px"/>
								<col width="*"/>
							</colgroup>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f207000f")%><!-- 颜色 -->：</td>
								<td><input type="text" name="beCirculatedLine.strokeColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("beCirculatedLine.strokeColor") %>"/></td>
							</tr>
						</table>
					</fieldset>	
				</div>
				
				<div class="lineInfo">
					<fieldset>
						<legend><%=labelService.getLabelNameByKeyId("402883ac3d1504d6013d1504d8690011")%><!-- 未流转的连接线 --></legend>
						<table style="border: 0px solid red;">
							<colgroup>
								<col width="40px"/>
								<col width="*"/>
							</colgroup>
							<tr>
								<td><%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f207000f")%><!-- 颜色 -->：</td>
								<td><input type="text" name="unCirculatedLine.strokeColor" size="8" class="colorTextStyle" value="<%=GraphStyleConfigWrap.get("unCirculatedLine.strokeColor") %>"/></td>
							</tr>
						</table>
					</fieldset>	
				</div>
			</fieldset>
		</div>
	</div>
	</form>
</body>
</html>
