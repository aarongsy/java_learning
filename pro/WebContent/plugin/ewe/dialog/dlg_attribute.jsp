<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@page import="org.springframework.jdbc.datasource.DriverManagerDataSource"%>
<%@page import="org.logicalcobwebs.proxool.ProxoolDataSource"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.model.Formlayout"%>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formlink"%>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.util.FormLayoutTranslate"%>
<%@ page import="com.eweaver.base.Page"%>

<%

String fieldid=request.getParameter("fieldid");
String forminfoid=request.getParameter("forminfoid");

ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
Forminfo forminfo = (Forminfo)forminfoService.getForminfoById(forminfoid);

boolean bSystable = false;
if("402881e60c85ac00010c864dfcc20057".equals(forminfo.getSelectitemid()))
	bSystable = true;
int formtype = forminfo.getObjtype().intValue();

String funnames = StringHelper.null2String(request.getParameter("funnames"));
%>

<html>
  <head>
<title>字段属性定义</title>

      <script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
      <script language=javascript src="dialog.js"></script>
      <link href='dialog.css' type='text/css' rel='stylesheet'>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <style type="text/css">
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
      
      	#maskDiv{	
      		width: 100%;
      		height: 100%;
      		background-color: EFEFDE;
      		position: absolute;
      		left: 0px;
      		top: 0px;
      		position: absolute;
      		filter:alpha(opacity=60);
			-moz-opacity:0.6;
			-khtml-opacity: 0.6;
			opacity: 0.6;	
			z-index: 1000;
			display: none;
      	}
      	#jsCodeConfigDiv{
      		width: 450px;
      		height: 350px;
      		background-color: white;
      		position: absolute;
      		left: 28px;
      		top: 33px;
      		z-index: 1100;
      		border: 2px solid #ADAAAD;
      		display: none;
      	}
      	#jsCodeConfigDiv .content{
      		margin-top: 10px;
      	}
      	#jsCodeConfigDiv .content table tr{
      		height: 30px;
      	}
      	#jsCodeConfigDiv .btn{
      		position: absolute;
      		bottom: 5px;
      		right: 5px;
      	}
      	#funNamesDiv{
      		height: 120px;border: 1px solid #ADAEB5;width: 285px;overflow: auto;margin-top: 5px;
      	}
      	#funNamesDiv ul li{
      		height: 20px;
      	}
      	#funNamesDiv ul li a{
      		display: block;
      		padding-left: 3px;
      		cursor: pointer;
      		text-decoration: none;
      		color: #000;
      	}
      	#funNamesDiv ul li a:hover {
			background: #319AFF;
			color: #fff;
			text-decoration: none;
		}
      </style>
      <script type="text/javascript">
      	var sqlWin;
          var menu;
        Ext.onReady(function() {
            Ext.EventManager.on("rule", 'contextmenu', showMenu); //监听事件
              menu = new Ext.menu.Menu({
                id: 'mainMenutourl',
                items: [
                    {
                        text: '提交后生成编号',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('pkg'),
                        checkHandler: onItemCheck
                    } ,{
                        text: '提交前生成编号',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('pkg'),
                        checkHandler: onItemCheck
                    }
                ]
            });
             sqlWin= new Ext.Window({        
		         layout:'border',        
		         width:500,        
		         height:300,        
		         plain: true,      
		         modal:true,
		         closable:false,
		         title:'SQL',        
		           items: {        
		             id:'dialog',        
		             region:'center',        
		             iconCls:'portalIcon',        
		             contentEl:'SQLDiv',        
		             closable:false,        
		             autoScroll:true        
		         } ,       
		         buttons: [{text : '确定',        
		            handler  : function() {
		        	 	setSQL();
		            }        
		        },{        
		            text     : '取消',        
		            handler  : function() {        
		                sqlWin.hide();        
		            }        
		        }]       
		     });   
        });
          function onItemCheck(item,checked){
              if(item.text=='提交后生成编号'){
                    getBrowser('/base/sequence/sequencelistbrowser.jsp', 'rule', '1');
              }else{

                   getBrowser('/base/sequence/sequencelistbrowser.jsp', 'rule', '2');
              }


          }
             var section=null;
  function showMenu(e){
    e.preventDefault();
    section=document.selection.createRange();  //获得鼠标所选中的区域
    var target = e.getTarget();
	menu.show(target);
	var pos=e.getXY();
	menu.showAt(pos);
}
function getBrowser(viewurl,inputname,isneed) {
    var id;
    try {
        id = openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>' + viewurl);
    } catch(e) {
    }
    if (id != null) {
        if (id[0] != '0') {
            if (isneed == 1) {
                if (section.text.length == 32) {
                    section.text = id[0];
                } else {
                    var str = "NO('#" + id[0] + "#',4)" ;
                    document.getElementById(inputname).innerHTML = str;

                }

            } else {
                if (section.text.length == 32) {
                    section.text = id[0];
                } else {
                    var str = "no('#" + id[0] + "#',4)" ;
                    document.getElementById(inputname).innerHTML = str;

                }

            }

        } else {
            document.getElementById(inputname).innerHTML = '';

        }
    }
}
      </script>
<script language="JavaScript">
function setDefaults() {
	document.all("rule").innerHTML = dialogArguments.parent.document.all("<%=fieldid%>_initvaluespan").innerHTML;
	
	document.all("rule").focus();
	storeCaret(document.all("rule"));
	
	
	adjustDialog();
	
}

function addfield(fieldname){
	fieldname = " "+fieldname+" ";
	insertAtCaret(document.all("rule"),fieldname);
	document.all("rule").focus();
}

function append(appstr){

	if(appstr == "SUM" || appstr == "RMB" || appstr == "SQL" || appstr == "MAX" || appstr == "PARM" || appstr == "EQ" || appstr == "NQ" || appstr == "LT" || appstr == "LE" || appstr == "GT" || appstr == "GE"){
		appstr = appstr +"(\"  \") ";
		insertAtCaret(document.all("rule"),appstr);
	}else{
		if(appstr == "0" ||appstr == "1" ||appstr == "2" ||appstr == "3" ||appstr == "4" ||appstr == "5" ||appstr == "6" ||appstr == "7" ||appstr == "8" ||appstr == "9" )
			appstr = appstr;
		else
			appstr = " "+appstr+" ";
		insertAtCaret(document.all("rule"),appstr);
	}
	document.all("rule").focus();
}

function storeCaret (textEl) {
	if (textEl.createTextRange) 
	textEl.caretPos = document.selection.createRange().duplicate();    
}

function insertAtCaret (textEl, text) {
	if (textEl.createTextRange && textEl.caretPos) {
	var caretPos = textEl.caretPos;
	caretPos.text =caretPos.text.charAt(caretPos.text.length - 1) == ' ' ?text + ' ' : text;      
	}      
	else        
	textEl.value  = text;
    
} 

function reset(){
	document.all("rule").innerHTML = "";	
	document.all("rule").focus();
}

function save(){
	var sHtml = document.all("rule").innerHTML;	
	dialogArguments.parent.document.all("<%=fieldid%>_initvalue").value = sHtml;
	dialogArguments.parent.document.all("<%=fieldid%>_initvaluespan").innerHTML = sHtml;
	window.close();
	
}

function cancel(){
	window.close();
}

	function getformfield(formid){
       	DataService.getValues(createList,"select id,labelname from formfield where formid='"+formid+"' and isdelete < 1");
       	return true;
    }
    function createList(data)
	{
	    DWRUtil.removeAllOptions("objfieldid");
	    DWRUtil.addOptions("objfieldid", data,"id","labelname");
	}
	
	
function cool_webcontrol(control)
{

  var id = "$"+control.value+"$";
  
	insertAtCaret(document.all("rule"),id);
	document.all("rule").focus();
  	
}


function fillAFunInCode(funName){
	var jsCode_code = document.getElementById("jsCode_code");
	insertAtCaret(jsCode_code, funName + "();");
}

function openJSCodeConfigWIn(){
	document.getElementById("maskDiv").style.display = "block";
	document.getElementById("jsCodeConfigDiv").style.display = "block";
	
	initJSConfig();
}

function closeJSCodeConfigWIn(){
	document.getElementById("maskDiv").style.display = "none";
	document.getElementById("jsCodeConfigDiv").style.display = "none";
}

function changeRuleContent(){
	var jsCode_code = document.getElementById("jsCode_code");
	var jsCode_eventMode = document.getElementById("jsCode_eventMode");
	var jsCode_isWinOnloadRun = document.getElementById("jsCode_isWinOnloadRun");
	var content = "js:{\"code\":\""+jsCode_code.value+"\", \"eventMode\":\""+jsCode_eventMode.value+"\", \"isWinOnloadRun\":"+jsCode_isWinOnloadRun.value+"}";
	document.all("rule").value = content;
}

function initJSConfig(){
	var content = document.all("rule").value;
	var jsPattern = new RegExp("js\\s*:\\s*\\{.+?\\}");
	if(jsPattern.test(content)){
		content = content.substring(content.indexOf("{"));
		var jsConfig = eval("(" + content + ")");
		document.getElementById("jsCode_code").value = jsConfig["code"];
		
		var jsCode_eventMode = document.getElementById("jsCode_eventMode");
		for(var i = 0; i < jsCode_eventMode.options.length; i++){
			if(jsCode_eventMode.options[i].value == jsConfig["eventMode"]){
				jsCode_eventMode.options[i].selected = true;
				break;
			}
		}
		
		var jsCode_isWinOnloadRun = document.getElementById("jsCode_isWinOnloadRun");
		for(var i = 0; i < jsCode_isWinOnloadRun.options.length; i++){
			if(jsCode_isWinOnloadRun.options[i].value == String(jsConfig["isWinOnloadRun"])){
				jsCode_isWinOnloadRun.options[i].selected = true;
				break;
			}
		}
	}
			
	var jsCode_code = document.getElementById("jsCode_code");
	jsCode_code.focus()
	var txtRange = document.selection.createRange();  
	txtRange.moveStart( "character", jsCode_code.value.length);  
	txtRange.moveEnd( "character", 0 );  
	txtRange.select();  
	storeCaret(document.getElementById("jsCode_code"));
}


/**
 * 带数据源SQL
 */
function sqlWithDataSource(){
	var SQLDiv = document.getElementById("SQLDiv");
	SQLDiv.style.display = "";
	var rule = document.getElementById("rule");
	var ruleVal = rule.value;
	var DS = document.getElementById("DS");
	var dstypespan = document.getElementById("dstypespan");
	ruleVal = ruleVal.replace(/(^\s*)|(\s*$)/g, "");//去掉左右空格
	var reg1 = /^SQL\(".*",".*",".*"\)$/;
	var reg2 = /^SQL\(".*"\)$/;
	//---------
	var ruleDS = document.getElementById("ruleDS");
	if(ruleVal==""){//如果为空
		DS.options[0].selected = true;
		dstypespan.innerHTML ="";
		ruleDS.value = "SQL(\" \"\,\" \",\" \")";
		sqlWin.show();
	}else{
		if(reg1.test(ruleVal)){
			ruleDS.value = ruleVal;
			var last = ruleVal.lastIndexOf("\"");
			var subStr = ruleVal.substring(0,last);
			var first = subStr.lastIndexOf("\"");
			var dsname = subStr.substring(first+1,last).replace(/(^\s*)|(\s*$)/g, "");
			var options = DS.options;
			for(var i=0;i<options.length;i++){
				if(options[i].text==dsname){
					DS.options[i].selected = true;
					dstypespan.innerHTML = DS.options[i].value;
					break;
				}
			}
			sqlWin.show();
		}else{
			if(reg2.test(ruleVal)){
				ruleDS.value = ruleVal;
				DS.options[0].selected = true;
					dstypespan.innerHTML ="";
				sqlWin.show();
			}else{
				if(confirm("当前字段属性框内语句不符合SQL(\"   \")的形式，是否继续？")){
					ruleDS.value = "SQL(\" \"\,\" \",\" \")";
					DS.options[0].selected = true;
					dstypespan.innerHTML ="";
					sqlWin.show();
				}
			}
		}
	}
	
}


function changeSqlDS(){
	var ruleDS = document.getElementById("ruleDS");
	var ruleVal = ruleDS.value;
	ruleVal = ruleVal.replace(/(^\s*)|(\s*$)/g, "");//去掉左右空格
	var reg1 = /^SQL\(".*",".*",".*"\)$/;
	var reg2 = /^SQL\(".*"\)$/;
	//----
	var DS = document.getElementById("DS");
	var index = DS.selectedIndex;
	var selVal = DS.options[index].value;
	var selText = DS.options[index].text;
	dstypespan.innerHTML = selVal;
	//alert(selVal+"----"+selText);
	if(ruleVal==""){//如果为空
		ruleDS.value = "SQL(\" \"\,\" "+selVal+" \",\" "+selText+" \")";
	}else{
		var count1 = countSubstr(ruleVal,"\"",true);//查找双引号出现的次数
		var count2 = countSubstr(ruleVal,",",true);//查找逗号号出现的次数
		if(reg1.test(ruleVal)){
			var lastindex = ruleVal.lastIndexOf(",");//最后一次出现的位置
			var subStr = ruleVal.substring(0,lastindex);
			lastindex = subStr.lastIndexOf(",");//倒数第二次
			subStr = subStr.substring(0,lastindex);
			var first = subStr.indexOf("\"");
			var last = subStr.lastIndexOf("\"");
			var sql = subStr.substring(first+1,last);
			//alert(sql);
			ruleDS.value = "SQL(\""+sql+"\"\,\""+selVal+"\",\""+selText+"\")";
		}else{
			if(reg2.test(ruleVal)){
				var first = ruleVal.indexOf("\"");
				var last = ruleVal.lastIndexOf("\"");
				var sql = ruleVal.substring(first+1,last);
				ruleDS.value = "SQL(\""+sql+"\"\,\""+selVal+"\",\""+selText+"\")";
			}else{
				if(confirm("当前字段属性框内语句不符合SQL(\" \",\" \",\"  \")的形式，是否继续？")){
					ruleDS.value = "SQL(\" \"\,\" "+selVal+" \",\" "+selText+" \")";
				}
			}
		}
	}
}

function setSQL(){
	var ruleDS = document.getElementById("ruleDS");
	var rule = document.getElementById("rule");
	var DS = document.getElementById("DS");
	var index = DS.selectedIndex;
	if(index==0){
		alert("请选择数据源!");
		return;
	}else{
		rule.value = ruleDS.value;
		 sqlWin.hide();
	}
}

function countSubstr(str,substr,isIgnore){
	 var count;
	 var reg="";
	 if(isIgnore==true){
	 	reg="/"+substr+"/gi"; 
	 }else{
	 	reg="/"+substr+"/g";
	 }
 	 reg=eval(reg);
	 if(str.match(reg)==null){
	 	count=0;
	 }else{
	 	count=str.match(reg).length;
	 }
	 return count;
}
</script>
<base target="_self">
</head>

<body topmargin="0" leftmargin="0" style="border: 0; margin: 0;" scroll="no" onLoad="setDefaults()">

<table width="100%" height=220 border="0" cellspacing="1" style="width:500px;height:380px;" cellpadding="3" align="center" valign=top  id=tabDialogSize>
<tr><td colspan=3>
<textarea class="InputStyle3" name="rule" id="rule" cols=67 rows=8 ONSELECT="storeCaret(this);" ONCLICK="storeCaret(this);" ONKEYUP="storeCaret(this);">  
</textarea>
</td>
</tr>
      <tr class="TableHeader" height=20>
      <td align="center"><b>关联表单</b></td>
      <td align="center"><b>表单字段</b></td>
      <td align="center" colspan=2><b>操作</b></td>
      </tr>
      <tr height=160><td align="center" width=120>
      <select size=8 name="objformid" style="width:120" onchange="javascript:getformfield(this.value);">
      <option value="<%=forminfoid%>" selected><%=((Forminfo)forminfoService.getForminfoById(forminfoid)).getObjname()%></option>
      <%if(formtype==1){
      		String strHql="from Formlink where oid='"+forminfoid+"' order by typeid desc";
			List list = ((FormlinkService)BaseContext.getBean("formlinkService")).findFormlink(strHql);
		
		    for(int i=0;i<list.size();i++)
		    {
		        Formlink formlink=(Formlink)list.get(i);
		%>	
			<option value="<%=formlink.getPid()%>"><%=((Forminfo)forminfoService.getForminfoById(formlink.getPid())).getObjname()%></option>
			<%}
		}%>		
      </select></td>
      <td align="center" width=120 >
      <select size=8 id="objfieldid" name="objfieldid" style="width:120" ondblclick="cool_webcontrol(this)">
       <%
      		String strHql="from Formfield where formid='"+forminfoid+"' and labelname is not null and isdelete <1 order by id";
			List list = ((FormfieldService)BaseContext.getBean("formfieldService")).findFormfield(strHql);
		
		    for(int i=0;i<list.size();i++)
		    {
		        Formfield formfield=(Formfield)list.get(i);
		        
		      	String showValue = formfield.getId();
		%>	
			<option value="<%=showValue%>"><%=formfield.getLabelname()%></option>
			<%}%>		
      </select></td>
      <td align="center" width=240 height=120>
      <table  width="100%" height=120 border="0" cellspacing="0" cellpadding="3" align="center" valign=top >
      <tr>
      <td width=70><button type=button style="width:50" onclick="append('EQ');" title="等于"> = </button></td>
      <td width=70><button type=button style="width:50" onclick="append('NQ');" title="不等于"> != </button></td>
      <td width=140><button type=button style="width:100" onclick="append('$currentdate$');" title="当前日期"> 当前日期 </button></td>
      </tr>   <tr>
      <td width=70><button type=button style="width:50" onclick="append('LT');" title="小于"> < </button></td>
      <td width=70><button type=button style="width:50" onclick="append('LE');" title="小于等于"> <= </button></td>
      <td width=140><button type=button style="width:100" onclick="append('$currenttime$');" title="当前时间"> 当前时间 </button></td>
      </tr>   <tr>
      <td width=70><button type=button style="width:50" onclick="append('GT');" title="大于"> > </button></td>
      <td width=70><button type=button style="width:50" onclick="append('GE');" title="大于等于"> >= </button></td>
      <td width=140><button type=button style="width:100" onclick="append('$currentuser$');" title="当前用户"> 当前用户 </button></td>
      </tr>  <tr>
      <td width=70><button type=button style="width:50" onclick="append('SUM');" title="加和">SUM</button></td>
      <td width=70><button type=button style="width:50" onclick="append('RMB');" title="金额转换">RMB</button></td>
      <td width=140><button type=button style="width:100" onclick="append('$currentorgunit$');" title="当前部门"> 当前部门 </button></td>
      </tr>    <tr>
      <td width=70><button type=button style="width:50" onclick="append('SQL');" title="SQL语句">SQL</button></td>
      <td width=70><button type=button style="width:50" onclick="append('MAX');" title="最大值">MAX</button></td>
      <td width=140><button type=button style="width:100" onclick="append('PARM');" title="获取参数"> 获取参数 </button></td>
      </tr>
      <tr>
      <td width=70><button type=button style="width:50" onclick="sqlWithDataSource()" title="带数据源SQL">SQL(DS)</button></td>
      <td width=70><button type=button style="width:50" onclick="openJSCodeConfigWIn();" title="绑定JS代码"> JS代码 </button></td>
      <td width=140><button type=button style="width:100" onclick="append('$currentdatetime$');" title="当前日期时间"> 当前日期时间 </button></td>
      </tr>
      </table>
      </td>
      </tr>
      <tr valign=top ><td valign=top align=right colspan=3>
       <button type=button style="width:80" onclick="reset();" >重置</button>&nbsp;&nbsp;&nbsp;&nbsp;
       <button type=button style="width:80" onclick="save();" >确定</button>&nbsp;&nbsp;&nbsp;&nbsp;
       <button type=button style="width:80"  onclick="cancel();">取消</button>&nbsp;&nbsp;&nbsp;&nbsp;
      </td></tr>
       </table>
       
       <div id="maskDiv"></div>
       <div id="jsCodeConfigDiv">
       		<div class="content">
       			<table>
       				<colgroup>
       					<col width="125px" style="text-align: right;padding-right: 5px;"></col>
       					<col width="*"></col>
       				</colgroup>
       				<tr>
       					<td>JS代码：</td>
       					<td><textarea id="jsCode_code" style="width: 285px; height: 100px;" ONSELECT="storeCaret(this);" ONCLICK="storeCaret(this);" ONKEYUP="storeCaret(this);"></textarea> </td>
       				</tr>
       				<tr>
       					<td>函数选取(双击)：</td>
       					<td>
       						<div id="funNamesDiv">
       							<ul>
       								<%
       									if(!StringHelper.isEmpty(funnames)){
       										String[] funNamesArray = funnames.split(",");
       										for(String funName : funNamesArray){%>
       											<li><a href="javascript:fillAFunInCode('<%=funName %>');">function <%=funName %></a></li>
       								<%	
       										}
       									}
       								%>
       							</ul>
       						</div>
       					</td>
       				</tr>
       				<tr>
       					<td>何时运行该代码：</td>
       					<td>
       						<select id="jsCode_eventMode">
       							<option value="change">值被改变时</option>
       							<option value="click">被单击时</option>
       						</select>
       					</td>
       				</tr>
       				<tr>
       					<td>页面加载时是否运行：</td>
       					<td>
       						<select id="jsCode_isWinOnloadRun">
       							<option value="false">否(不运行)</option>
       							<option value="true">是(运行该代码)</option>
       						</select>
       					</td>
       				</tr>
       			</table>
       		</div>
       		<div class="btn">
       			<span><button type=button style="width:100" onclick="changeRuleContent();closeJSCodeConfigWIn();">确定</button></span>
       			<span style="margin-left: 5px;"><button type=button style="width:100" onclick="closeJSCodeConfigWIn();">关闭</button></span>
       		</div>
       </div>
       <div name="SQLDiv" id="SQLDiv" style="display: none">
       		<table>
       			<colgroup>
       				<col width="15%">
       				<col width="85%">
       			</colgroup>
       			<tr>
       				<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006a") %></td><!-- 数据源 -->
       				<td class="FieldValue">
       					<select style="width: 200px;" onchange="changeSqlDS()" id="DS" name="DS">
       						<option></option>
       						<%String[] dsnames=BaseContext.getBeanNames(DataSource.class); %>
       						<%
       						for(int i=0;i<dsnames.length;i++){
       							String dsName = dsnames[i];
       							JdbcTemplate jdbcTemplate = BaseContext.getJdbcTemp(dsName);
       							Object obj = jdbcTemplate.getDataSource();
       							String url = "";
       							if(obj instanceof DriverManagerDataSource){
       								DriverManagerDataSource dataSource  = (DriverManagerDataSource)jdbcTemplate.getDataSource();
       								url = dataSource.getUrl();
       							}else if(obj instanceof ProxoolDataSource){
       								ProxoolDataSource dataSource = (ProxoolDataSource)jdbcTemplate.getDataSource();
       								url = dataSource.getDriverUrl();
       							}
       							url = url.toLowerCase();
       							String dstype = "";
       							if(url.indexOf("oracle")!=-1){//oracle
       								dstype = "oracle";
       							}else if(url.indexOf("sqlserver")!=-1){
       								dstype = "sqlserver";
       							}else if(url.indexOf("mysql")!=-1){
       								dstype = "mysql";
       							}else if(url.indexOf("postgresql")!=-1){
       								dstype = "postgresql";
       							}else if(url.indexOf("db2")!=-1){
       								dstype = "db2";
       							}else if(url.indexOf("interbase")!=-1){
       								dstype = "interbase";
       							}else if(url.indexOf("hsql")!=-1){
       								dstype = "hsql";
       							}
       						%>
       							<option value="<%=dstype %>"><%=dsName %></option>
       						<%} %>
       					</select>
       				</td>
       			</tr>
       			<tr>
       				<td class="FieldName"><%=labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026") %></td>
       				<td class="FieldValue">
       					<span id="dstypespan" name="dstypespan"></span>
       				</td>
       			</tr>
       			<tr>
       				<td class="FieldValue" colspan="2">
       					<textarea style="width: 100%;height: 170px" id="ruleDS" name="ruleDS"></textarea>
       				</td>
       			</tr>
       		</table>
       </div>
</body>
</FORM>
</html>