<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.light.portal.core.service.PortalService" %>
<%@ page import="org.light.portal.core.entity.PortalTab" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ include file="/base/init.jsp"%>
<%!
   private String setStrASCII(String str){
	if(str.length()>=4){
		if(str.substring(str.length()-4,str.length()).equals("0x5c")){
			str = str.substring(0,str.length()-4)+"&#92;";
		}
		for(int i = 0;i<str.length();i++){
			str = str.replace("0x3b","&#59;");
			str = str.replace("0x22","&#34;");
		}
	}
	return str;
}
%>
<%
PortalService portalService = (PortalService) BaseContext.getBean("portalService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
String pid = StringHelper.null2String(request.getParameter("pid"));
PortalTab portaltab=null;
String manageIdsName="";
if(NumberHelper.getIntegerValue(request.getParameter("id"),-1)!=-1){
portaltab = portalService.getPortalTabById(NumberHelper.getIntegerValue(request.getParameter("id")));
if(portaltab!=null){
	pid=""+portaltab.getPid();
	if(!StringHelper.isEmpty(portaltab.getManageIds())){
		manageIdsName=humresService.getHrmresNameById(portaltab.getManageIds());
	}
}
}

 pagemenustr =  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','S','accept',function(){EditOK()});";//确定

%>
<html>
<head>
<style type="text/css">
     #pagemenubar table {width:0}
</style>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script>
    Ext.onReady(function(){
    <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>
        <%}%>
    })
</script>
</head>
<body>
<div id="pagemenubar"> </div>
	           
  	<table>
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="20%">
					<col width="">
				</colgroup>
				<% if(portaltab!= null){%>
				<tr>
					<td class="FieldName" nowrap>id</td>
					<td class="FieldValue">
						<%=StringHelper.null2String(portaltab.getId())%>
						<span style="margin-left: 20px;font-family: Microsoft YaHei;">(注：如需要将此门户单独显示在菜单中,可在菜单中配置如下URL: /portal.jsp?targetPortalTabId=<%=StringHelper.null2String(portaltab.getId())%>)</span>
					</td>
                    <input type="hidden" name="id" id="id"  value="<%=StringHelper.null2String(portaltab.getId())%>" />
                    <input type="hidden" name="col1" id="col1"  value="<%=StringHelper.null2String(portaltab.getCol1())%>" />
				</tr>
				<%}else{%>
                	<input type="hidden" name="id" id="id"  value="" />
                	<input type="hidden" name="col1" id="col1"  value="" />
                <%}%>
				<tr>

				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009")%><!-- 标题 -->
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width=50%" type="text" name="label"  id="label" value="<%=portaltab==null?"":setStrASCII(StringHelper.null2String(portaltab.getLabel()))%>" onChange="checkInput('label','labelspan')" onkeypress="checkQuotes_KeyPress()"/>
						<span id="labelspan" name="labelspan"/>
						<% if(portaltab==null||StringHelper.null2String(portaltab.getLabel()).equals("")){%>
						<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>
						<%}%>
						</span>
						<% if(portaltab != null && !StringHelper.isEmpty(portaltab.getCol1())){%>
							<%=labelCustomService.getLabelPicHtml(portaltab.getCol1(), LabelType.PortalTab) %>
						<% } %>
					</td>
				</tr>
				<tr style="display:none">
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						pid
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width=50%" type="text" name="pid" id="pid"  value="<%=pid%>"/>
					</td>
				</tr>

				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402881e70b774c35010b774d4c410009")%><!-- 显示顺序 -->
					</td>
				<!-- 输入框列 -->	
					<td class="FieldValue">
						<input style="width=10%" type="text" name="dsporder" id="dsporder" value="<%=portaltab==null?"0":StringHelper.null2String(portaltab.getDsporder())%>" onkeypress="checkInt_KeyPress()"/>
					</td>
				</tr>			
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402881ec0bdbf198010bdbf3ae300003")%><!-- 布局类型 -->
					</td>
				<!-- 输入框列 -->	
					<td class="FieldValue">
						  <select name="absolute" id="absolute">
						  		<option value="0" <%=(portaltab!=null&&portaltab.getAbsolute()!=null&&portaltab.getAbsolute()==0)?"selected":""%>>相对定位</option>
						  		<option value="1" <%=(portaltab!=null&&portaltab.getAbsolute()!=null&&portaltab.getAbsolute()==1)?"selected":""%>>绝对定位</option>
    					 </select>
				</tr>
				<tr>
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b002b")%><!-- 滚屏 --></td>
					<td class="FieldValue"><input style="" type="text" name="scrolls" id="scrolls" value="<%=(portaltab!=null&&portaltab.getScrolls()!=null)?portaltab.getScrolls():"1"%>"/></td>
				</tr>
                <tr>

				<!-- 变量名列 -->
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b002c")%><!-- 栏位宽度 -->
					</td>
				<!-- 输入框列 必输入 -->
					<td class="FieldValue">
						<input style="width:80%" type="text" name="widths" id="widths"  value="<%=(portaltab!=null&&portaltab.getWidths()!=null)?portaltab.getWidths():"512,512"%>" onChange="checkInput('widths','widthspan')"/>
						<span id="widthspan"/></span>
					</td>
				</tr>
				<tr><td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b002d")%><!-- 管理员 --></td>
					<td class="FieldValue">
					<button  type="button" class=Browser onclick="javascript:getBrowser(contextPath+'/base/refobj/baseobjbrowser.jsp?id=402881eb0bd30911010bd321d8600015','manageIds','manageIdsspan');"></button>
			<input type="hidden"  name="manageIds" id="manageIds" value="<%=(portaltab!=null)?portaltab.getManageIds():""%>"/>
			<span id="manageIdsspan"><%=manageIdsName%></span>
					
					</td>
				</tr>
			</table>
    </body>
<script>
    function EditOK() {
		var id = getEncodeStr(document.getElementById("id").value);
		var label = getEncodeStr(document.getElementById("label").value);
		/** begin 将特殊字符 已ASCII码值存取到数据库 **/
		for(var i = 0; i<label.length;i++){
			label = label.replace("|22","0x22");  //字符出现 “"”
			label = label.replace("|3b","0x3b");  // 字符出现 “;”
		}
		if(label.substring(label.length-3,label.length) == "|5c"){
		label = label.replace("|5c","0x5c");  // 字符最后出现 “\”
		}
		/** end **/
		var pid = getEncodeStr(document.getElementById("pid").value);
		var absolute = getEncodeStr(document.getElementById("absolute").value);
        var widths = getEncodeStr(document.getElementById("widths").value);
		var dsporder = getEncodeStr(document.getElementById("dsporder").value);
		var manageIds = getEncodeStr(document.getElementById("manageIds").value);
		var scrolls = getEncodeStr(document.getElementById("scrolls").value);
		var col1 = getEncodeStr(document.getElementById("col1").value);
		if(label == ""){
			alert("<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>");
			return;
		}

   		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.portal.servlet.PortalAction?action=modifyPortalTab";
		
		var isTb = confirm("是否同步组织门户?");
		var updatestring ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
		updatestring += "<data>";
		updatestring += "<id>"+id+"</id>";
		updatestring += "<label>"+label+"</label>";
		updatestring += "<pid>"+pid+"</pid>";
		updatestring += "<absolute>"+absolute+"</absolute>";
		updatestring += "<widths>"+widths+"</widths>";
		updatestring += "<dsporder>"+dsporder+"</dsporder>";
		updatestring += "<manageids>"+manageIds+"</manageids>";
		updatestring += "<scrolls>"+scrolls+"</scrolls>";
		updatestring += "<col1>"+col1+"</col1>";
		updatestring += "<isTb>"+isTb+"</isTb>";
		updatestring += "</data>";
//		alert(updatestring);
		param.updatestring=updatestring;
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");

	   if(id != ""){
			var selectedNode = parent.portalTree.getSelectionModel().getSelectedNode();
			if(selectedNode != null){
				var showname = getValidStr(document.getElementById("label").value);
				selectedNode.setText(showname);
			}
			window.location='portalmodify.jsp?id=' + id;
		}else{	//create
				var selectedNode = parent.portalTree.getSelectionModel().getSelectedNode();
                if(selectedNode.isLeaf()){
                selectedNode.parentNode.reload();
                }else
                selectedNode.reload();
                window.location='portalmodify.jsp?id='+selectedNode.id;

		}
	}

    function getBrowser(viewurl, inputname, inputspan, isneed) {
        var id;
        try {
            id = openDialog('/base/popupmain.jsp?url=' + viewurl);
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
                    document.all(inputspan).innerHTML = '<img src='+contextPath+'/images/base/checkinput.gif>';

            }
        }
    }
</script>
</html>