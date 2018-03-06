<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
	String moduleid = StringHelper.null2String(request.getParameter("moduleid"));
	String formid = StringHelper.null2String(request.getParameter("formid"));
%>
<html>
<head>
<style type="text/css">
.x-toolbar table {width:0}
#pagemenubar table {width:0}
.x-panel-btns-ct table {width:0}
</style>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/light/scripts/portletsFun.js"></script>
<script type="text/javascript" src="/js/ext/ux/ajax.js"></script>
<script type="text/javascript">
	$(function(){
		Ext.QuickTips.init();
		var tb = new Ext.Toolbar();
		tb.render('pagemenubar');
		addBtn(tb,'保存','S','accept',function(){saveAndCreateAgain()});
		
		createOptionsByStore("htmltype", parent.bstore);
		$("#htmltype").bind("change", onHtmltypeChange);
		
		onHtmltypeChange();	//页面加载的时候手动调用一下
	});
	
	function saveAndClose(){
		if(doSubmit()){
			//关闭本页
			onClose();
		}
	}
	
	function saveAndCreateAgain(){
		if(doSubmit()){
			//刷新本页
			location.reload();
		}
	}
	
	function doSubmit(){
		//验证
		var $fieldnamePrefix = $("#fieldnamePrefix");
		var $fieldnameInitNo = $("#fieldnameInitNo");
		var $count = $("#count");
		
		if($fieldnamePrefix.val() == ""){
			alert("请填写字段名称前缀");
			$fieldnamePrefix[0].focus();
			return false;
		}else{
			
			//对字段名称进行校验(只能是字母和数字,并且不能是数字开头，不能是数据库关键字)
			var validPass = true;
			for(var i = 0; i < $fieldnamePrefix.val().length; i++){
				var c = $fieldnamePrefix.val().charAt(i);
				if(i == 0){
					if(c.toLowerCase() < 'a' || c.toLowerCase() > 'z'){
						validPass = false;
						break;
					}
				}else{
					if((c.toLowerCase() < 'a' || c.toLowerCase() > 'z') && (c.toLowerCase() < '0' || c.toLowerCase() > '9')){
						validPass = false;
						break;
					}					
				}
			}
			
			if(!validPass){
				alert("字段名称前缀必须由字母和数字组成,并且以字母开头");
				$fieldnamePrefix[0].focus();
				return false;
			}
		}
		
		var numberReg = new RegExp("^[1-9]\\d*$");
		if($fieldnameInitNo.val() == ""){
			alert("请填写字段名称初始编号");
			$fieldnameInitNo[0].focus();
			return false;
		}else{
			if(!numberReg.test($fieldnameInitNo.val())){
				alert("字段名称初始编号必须是正整数");
				$fieldnameInitNo[0].focus();
				return false;
			}
		}
		
		if($count.val() == ""){
			alert("请填写数量");
			$count[0].focus();
			return false;
		}else{
			if(!numberReg.test($count.val())){
				alert("数量必须是正整数");
				$count[0].focus();
				return false;
			}
		}
		
		var $htmltype = $("#htmltype");
		var $fieldtype = $("#fieldtype");
		var $fieldattr = $("#fieldattr");
		var $fieldcheck = $("#fieldcheck");
		var htmltypeVal = $htmltype.val();
		var fieldtypeVal = $fieldtype.length > 0 ? $fieldtype.val() : "";
		var fieldattrVal = $fieldattr.length > 0 ? $fieldattr.val() : "";
		var fieldcheckVal = $fieldcheck.val();
		
		var fieldnameInitNoVal = parseInt($fieldnameInitNo.val());
		var countVal = parseInt($count.val());
		var tag = 0;
		while(tag < countVal){
			var fieldnameInitNoValForShow = getFieldnameInitNoForShow(fieldnameInitNoVal);
			var f_fieldname = $fieldnamePrefix.val() + fieldnameInitNoValForShow;
			var f_formlabelname = $fieldnamePrefix.val() + fieldnameInitNoValForShow;
			fieldnameInitNoVal++;
			if(theFieldnameIsExistInForm(f_fieldname)){
				continue;
			}
			//插入到父页面的表格中
			parent.insertOneRowInGrid(f_formlabelname, f_fieldname, htmltypeVal, fieldtypeVal, fieldattrVal, fieldcheckVal);
			tag++;
		}
		
		return true;
	}
	
	function onClose(){
		if(parent && typeof(parent.closeBatchCreateFieldWin) == "function"){
			parent.closeBatchCreateFieldWin();
		}
	}
	
	function createOptionsByStore(selId, store){
		var sel = document.getElementById(selId);
		
		for(var i = (sel.options.length - 1); i >= 0; i--){
			sel.remove(i);
		}
		
		store.each(function(record){
			var p = new Option(record.get("text"), record.get("value"));
			sel.add(p, undefined);
		});
	}
	
	function onHtmltypeChange(){
		var $fieldtypeTD = $("#fieldtypeTD");
		$fieldtypeTD.empty();
		var $fieldattrTD = $("#fieldattrTD");
		$fieldattrTD.empty();
		$("#fieldcheck").val("");	//清空字段验证中的内容
		var $htmltype = $("#htmltype");
		var htmltypeVal = $htmltype.val();
		if(htmltypeVal == "1"){
			var $fieldtype = $("<select id='fieldtype' name='fieldtype'></select>"); 
			$fieldtypeTD.append($fieldtype);
			createOptionsByStore("fieldtype", parent.fieldtypestore);
			$("#fieldtype").bind("change", onFieldtypeChange);
			onFieldtypeChange();
			return;	// don't call the end line menthod toChangeFieldnamePrefix()
		}else if(htmltypeVal == "5" || htmltypeVal == "8"){	//选择项或者checkbox多选
			$fieldtypeTD.append("<button class=\"Browser\" onclick=\"Portlet.getBrowser('/base/selectitem/selectitemtypebrowser.jsp?moduleid=<%=moduleid%>','fieldtype','fieldtypeSpan','0');\"></button><input type=\"hidden\" name=\"fieldtype\" id=\"fieldtype\"/><span id=\"fieldtypeSpan\"></span>");
		}else if(htmltypeVal == "6"){	//关联选择
			$fieldtypeTD.append("<button class=\"Browser\" onclick=\"Portlet.getBrowser('/base/refobj/refobjbrowser.jsp?moduleid=<%=moduleid%>','fieldtype','fieldtypeSpan','0');\"></button><input type=\"hidden\" name=\"fieldtype\" id=\"fieldtype\"/><span id=\"fieldtypeSpan\"></span>");
		}else{
			//nothing to do
		}
		toChangeFieldnamePrefix();
	}
	
	function onFieldtypeChange(){
		var $fieldattrTD = $("#fieldattrTD");
		$fieldattrTD.empty();
		$("#fieldcheck").val("");	//清空字段验证中的内容
		var $fieldtype = $("#fieldtype");
		var fieldtypeVal = $("#fieldtype").val();
		if(fieldtypeVal == "1"){	//文本
			var $fieldattr = $("<input type='text' id='fieldattr' name='fieldattr' value='256' style='width: 30px;height:18px;'></select>"); 
			$fieldattrTD.append("文本长度：");
			$fieldattrTD.append($fieldattr);
		}else if(fieldtypeVal == "2"){	//整数
			$("#fieldcheck").val("^-?\\d+$");
		}else if(fieldtypeVal == "3"){	//浮点数
			var $fieldattr = $("<input type='text' id='fieldattr' name='fieldattr' value='2' style='width: 30px;height:18px;'></select>"); 
			$fieldattrTD.append("小数点位数：");
			$fieldattrTD.append($fieldattr);
			$("#fieldcheck").val("^(-?[\\d+]{1,22})(\\.[\\d+]{1,2})?$");
			$fieldattr.bind("change", function(){
				var newValue = this.value;
				if(newValue == ""){
       	  			newValue = 2;
       	  		}
       	  		newValue = parseInt(newValue);
       	  		var newFieldcheck = '^(-?[\\d+]{1,'+(24-newValue)+'})(\\.[\\d+]{1,'+newValue+'})?$';
       	  		$("#fieldcheck").val(newFieldcheck);
			});
		}else if(fieldtypeVal == "4"){	//日期
			var $fieldattr = $("<input type='text' id='fieldattr' name='fieldattr' value='(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)' style='width: 165px;height:18px;'></select>"); 
			$fieldattrTD.append($fieldattr);
		}else if(fieldtypeVal == "5"){	//时间
			//nothing to do
		}else if(fieldtypeVal == "6"){	//日期时间
			$("#fieldcheck").val("{dateFmt:'yyyy-MM-dd HH:mm:ss',alwaysUseStartDate:true}");
		}
		toChangeFieldnamePrefix();
	}
	
	function getFieldnameInitNoForShow(fieldnameInitNo){
		if(fieldnameInitNo < 99){
			fieldnameInitNo = "000".substring(fieldnameInitNo.toString().length) + fieldnameInitNo;
		}
		return fieldnameInitNo;
	}
	
	function theFieldnameIsExistInForm(fieldname){
		var isExist = false;
		parent.grid.store.each(function(record){
			if(record.get("fieldname") == fieldname){
				isExist = true;
				return;
			}
		});
		return isExist;
	}
	
	function toChangeFieldnamePrefix(){
		var tempFieldnamePrefixVal;
		var $htmltype = $("#htmltype");
		var htmltypeVal = $htmltype.val();
		if(htmltypeVal == "1"){	//单行文本
			var $fieldtype = $("#fieldtype");
			var fieldtypeVal = $("#fieldtype").val();
			if(fieldtypeVal == "1"){	//文本
				tempFieldnamePrefixVal = "input";
			}else if(fieldtypeVal == "2"){	//整数
				tempFieldnamePrefixVal = "int";
			}else if(fieldtypeVal == "3"){	//浮点数
				tempFieldnamePrefixVal = "float";
			}else if(fieldtypeVal == "4"){	//日期
				tempFieldnamePrefixVal = "date";
			}else if(fieldtypeVal == "5"){	//时间
				tempFieldnamePrefixVal = "time";
			}else if(fieldtypeVal == "6"){	//日期时间
				tempFieldnamePrefixVal = "datetime";
			}else{
				tempFieldnamePrefixVal = "不识别的字段类型";
			}
		}else if(htmltypeVal == "2"){	//多行文本
			tempFieldnamePrefixVal = "text";
		}else if(htmltypeVal == "3"){	//带格式文本
			tempFieldnamePrefixVal = "richtext";
		}else if(htmltypeVal == "4"){	//checkbox
			tempFieldnamePrefixVal = "checkbox";
		}else if(htmltypeVal == "8"){	//checkbox多选
			tempFieldnamePrefixVal = "checkboxm";
		}else if(htmltypeVal == "5"){	//选择项
			tempFieldnamePrefixVal = "select";
		}else if(htmltypeVal == "6"){	//关联选择
			tempFieldnamePrefixVal = "browser";
		}else if(htmltypeVal == "7"){	//附件
			tempFieldnamePrefixVal = "attach";
		}else{
			tempFieldnamePrefixVal = "不识别的表现类型";
		}
		$("#fieldnamePrefix").val(tempFieldnamePrefixVal);
	}
</script>
</head>
<body>
  <div id="pagemenubar" style="z-index:100;"></div>
  
  <table style="line-height: 30px;">
  	<colgroup>
  		<col width="120px"/>
  		<col width="*"/>
  	</colgroup>
  	<tr>
		<td class="FieldName" nowrap>表现形式：</td>
		<td class="FieldValue" nowrap>
			<select id="htmltype" name="htmltype">
				
			</select>
		</td>
	</tr>
	<tr>
		<td class="FieldName" nowrap>字段类型：</td>
		<td class="FieldValue" nowrap id="fieldtypeTD">
			
		</td>
	</tr>
	<tr>
		<td class="FieldName" nowrap>字段属性：</td>
		<td class="FieldValue" nowrap id="fieldattrTD">
			
		</td>
	</tr>
	<tr>
		<td class="FieldName" nowrap>字段验证：</td>
		<td class="FieldValue" nowrap>
			<textarea id="fieldcheck" name="fieldcheck" style="width: 95%; height: 60px;"></textarea>
		</td>
	</tr>
	<tr>
		<td class="FieldName" nowrap>字段名称前缀：</td>
		<td class="FieldValue" nowrap>
			<input type="text" id="fieldnamePrefix" name="fieldnamePrefix" value="" class="inputstyle" onchange="checkInput('fieldnamePrefix','fieldnamePrefixSpan')"/>
			<span id="fieldnamePrefixSpan" name="fieldnamePrefixSpan" />
				
			</span>
		</td>
	</tr>
	<tr>
		<td class="FieldName" nowrap>字段名称初始编号：</td>
		<td class="FieldValue" nowrap>
			<input type="text" id="fieldnameInitNo" name="fieldnameInitNo" value="1" class="inputstyle" onchange="checkInput('fieldnameInitNo','fieldnameInitNoSpan')"/>
			<span id="fieldnameInitNoSpan" name="fieldnameInitNoSpan"/>
				
			</span>
		</td>
	</tr>
	<tr>
		<td class="FieldName" nowrap>数量：</td>
		<td class="FieldValue" nowrap>
			<input type="text" id="count" name="count" class="inputstyle" value="5" onchange="checkInput('count','countSpan')"/>
			<span id="countSpan" name="countSpan"/>
				
			</span>
		</td>
	</tr>
	<tr>
		<td colspan="2" style="background: url('/images/lightbulb.png') no-repeat;background-position:4px 6px; padding-left: 25px;border-bottom: 1px solid #efefde;">提示：如想生成名称为field001至field020的字段，那么可将字段名称前缀填写为field，初始编号为1，数量为20即可。</td>
	</tr>
  </table>
</body>
</html>
