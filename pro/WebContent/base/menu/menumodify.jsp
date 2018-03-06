<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.menu.MenuDisPositionEnum"%>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService"%>
<%@ page import="com.eweaver.base.module.model.Module"%>
<%@ include file="/base/init.jsp"%>
<%
MenuService menuService =(MenuService)BaseContext.getBean("menuService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
ModuleService moduleService = (ModuleService)BaseContext.getBean("moduleService");
String isadd="0";
Menu menu = menuService.getMenu(request.getParameter("id"));
String menutype = StringHelper.null2String(request.getParameter("menutype"));
if(menu!=null && menu.getMenutype()!=null && !"1".equals(menutype)) {
	menutype=""+menu.getMenutype();
}
if(menu.getMenuname()!=null){
	isadd="1";
}
String nodeType="1";
if(menu!=null && menu.getNodetype()!=null)
	nodeType=""+menu.getNodetype();
String pid = StringHelper.trimToNull(request.getParameter("pid"));
if(pid != null){
	if(pid.equalsIgnoreCase("treeRoot"))
		pid = null;
}
if(pid == null)
	pid = menu.getPid();
 pagemenustr =  "addBtn(tb,'确定','S','accept',function(){EditOK()});";
if(pid!=null&&pid.equals("r00t"))
pid="";

//是否需要显示所属模块
boolean isNeedShowModule = menutype.equals("2");	//当是用户菜单时 
String paramModuleid = StringHelper.null2String(request.getParameter("moduleid"));
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
				<% if(menu.getId()!= null){%>
				<tr>
					<td class="FieldName" nowrap>id</td>
					<td class="FieldValue"><%=StringHelper.null2String(menu.getId())%></td>
				</tr>
				<%}%>
				<input type="hidden" name="id" id="id"  value="<%=StringHelper.null2String(menu.getId())%>" />
				<tr style="display:none">
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						labelid
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width=50%" type="text" name="labelid" id="labelid" value="<%=StringHelper.null2String(menu.getLabelid())%>"/>
						<%=labelService.getLabelName(menu.getLabelid())%>
					</td>
				</tr>
				<tr>

				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						menuname
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width=50%" type="text" name="menuname"  id="menuname" maxlength="100" value="<%=StringHelper.null2String(menu.getMenuname())%>" onChange="checkInput('menuname','menunamespan')"/>
						<span id="menunamespan" name="menunamespan"/>
						<% if(StringHelper.null2String(menu.getMenuname()).equals("")){%>
							<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>
						<%}%>
						</span>
						<% if(menu.getId()!= null){%>
							<%=labelCustomService.getLabelPicHtml(menu.getId(), LabelType.Menu) %>
						<%} %>
					</td>
				</tr>
				<tr style="display: none;">
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						pid
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input readonly="true" style="width=50%" type="text" name="pid" id="pid"  value="<%=StringHelper.null2String(pid)%>"/>
						<input type="hidden" name="oid"  id="oid" value="<%=StringHelper.null2String(pid)%>"/> 
					</td>
				</tr>

				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						url
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<TEXTAREA id="url" name="url" ROWS="5" COLS="65"><%=StringHelper.null2String(menu.getUrl())%></TEXTAREA>
					</td>
				</tr>
				<tr <%if(!isNeedShowModule){%> style="display: none;"<%}%>>
					<td class="FieldName" nowrap>
						菜单所属模块
					</td>
					<td class="FieldValue">
						<% if(StringHelper.isEmpty(pid)){ //顶级菜单 %>
							
							<% 
								String moduleid; 
								if(StringHelper.isEmpty(menu.getId())){	//新建
									moduleid = paramModuleid; 
								}else{	//修改
									moduleid = StringHelper.null2String(menu.getModuleid()); 
								}
							%>
							
							<button  type="button" class=Browser onclick="javascript:getBrowser('/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');"></button>
							<input type="hidden" id="moduleid"  name="moduleid" value="<%=moduleid %>"/>
							<span id="moduleidspan">
								<% if(!StringHelper.isEmpty(moduleid)){ %>
										<%=moduleService.getModuleNameById(moduleid) %>
								<% } %>
							</span>
							<!-- 此隐藏属性用于标记判断moduleid是否被修改 -->
							<input type="hidden" id="flagModuleid"  name="flagModuleid" value="<%=moduleid %>"/>
						<% } else { //子菜单 
							String moduleid = menuService.getModuleidWithTopLevelMenu(pid);
							if(!StringHelper.isEmpty(moduleid)){
						%>
								<%=moduleService.getModuleNameById(moduleid) %>
						<% 	} %>
							<input type="hidden" id="moduleid"  name="moduleid" value="<%=moduleid %>"/> <!-- 子菜单的模块id暂时设计成没有意义 -->
							<!-- 此隐藏属性用于标记判断moduleid是否被修改 -->
							<input type="hidden" id="flagModuleid"  name="flagModuleid" value=""/>
						<% } %>
					</td>
				</tr>
				<%//if(StringHelper.isEmpty(pid)){%>
					<tr>
					<td class="FieldName" nowrap>
						菜单显示位置
					</td>
					<td class="FieldValue">
						<%
						  boolean isCreateRootMenu = false;
						  if(StringHelper.isEmpty(menu.getId())){ //是否新建
							  isCreateRootMenu = true;
						  }
						  String displayPosition = StringHelper.null2String(menu.getDisplayPosition());
						  MenuDisPositionEnum[] disPositions = MenuDisPositionEnum.values();
						  for(MenuDisPositionEnum disPosition : disPositions){
							boolean checked = false;
							if(displayPosition.contains(disPosition.toString())){
								checked = true;
							}
							if(isCreateRootMenu && disPosition == MenuDisPositionEnum.left){ //新建顶级菜单时默认选中左侧
								checked = true;	
							} 
						%>
						  	<input type="checkbox" name="displayPosition" value="<%=disPosition.toString() %>" <%if(checked){ %> checked="checked" <%} %>/><%=disPosition.getShowName() %>
						  <%}
						%>
					</td>
				</tr>
				<%//}%>
                   <tr style="display:none">
                
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						menutype
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width=10%" type="text" name="menutype" id="menutype"  value="<%=menutype%>" onChange="checkInput('menutype','menutypespan')"/> 
						<span id="menutypespan"/></span>
						<%=labelService.getLabelName("402881e90bd6c49d010bd6e2536e0002")%>
					</td>
				</tr>

                   <tr style="display:none">

				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						nodetype
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width=10%" type="text" name="nodetype"  id="nodetype" value="<%=nodeType%>"/>
						<%=labelService.getLabelName("402881e90bd6c49d010bd6e3265e0003")%>
					</td>
				</tr>
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						imgfile
					</td>
				<!-- 输入框列 -->	
					<td class="FieldValue">
						<input style="width=80%" type="text" name="imagfile" id="imagfile"  value="<%="".equals(StringHelper.null2String(menu.getImgfile()))?"/images/silk/application_view_columns.gif":StringHelper.null2String(menu.getImgfile())%>"/>
						<img id="imgFilePre" src="<%="".equals(StringHelper.null2String(menu.getImgfile()))?request.getContextPath()+"/images/silk/application_view_columns.gif":StringHelper.null2String(request.getContextPath()+menu.getImgfile())%>" />
						<a href="javascript:;" onclick="BrowserImages(function(n){if(!n)return;document.getElementById('imagfile').value=n;document.getElementById('imgFilePre').src=contextPath+n;});">浏览..</a>
					</td>
				</tr>		
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						dsporder
					</td>
				<!-- 输入框列 -->	
					<td class="FieldValue">
						<input style="width=10%" type="text" name="dsporder" id="dsporder" value="<%=StringHelper.null2String(menu.getDsporder())%>"/>
					</td>
				</tr>			
				<tr style="display:none">
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						isshow
					<br><br></td>
				<!-- 输入框列 -->	
					<td class="FieldValue">
						  <select name="isshow" id="isshow">
						  		<option value="1" <%=menu.getIsshow()==null?"":menu.getIsshow().intValue()==1?"selected":""%>><%=labelService.getLabelName("402881eb0bd66c95010bd67f5e310002")%></option>
						  		<option value="0" <%=menu.getIsshow()==null?"":menu.getIsshow().intValue()==0?"selected":""%>><%=labelService.getLabelName("402881eb0bd66c95010bd68004400003")%></option>	
    					 </select>
				<br><br></tr>	
				<tr >
					<td class="FieldName" nowrap>
						condition
					</td>
					<td class="FieldValue">
						<TEXTAREA id="condition" name="condition" ROWS="5" COLS="65"><%=StringHelper.null2String(menu.getCondition())%></TEXTAREA>
						<br/>菜单附加条件设置(如代办数量)可用变量 当前用户:{currentuser},当前组织单元:{currentorgunit},当前日期：{currentdate}
					</td>
				</tr>	
			</table>
    </body>
<script>
    function EditOK() {
    	if(checkmenuname()){	//菜单名称不合法
    		return;
    	}
		var id = getEncodeStr(document.getElementById("id").value);
		var labelid = getEncodeStr(document.getElementById("labelid").value);
		var menuname = getEncodeStr(document.getElementById("menuname").value);
		var pid = getEncodeStr(document.getElementById("pid").value);
		var oid = getEncodeStr(document.getElementById("oid").value);
		var url = getEncodeStr(document.getElementById("url").value);
		var menutype = getEncodeStr(document.getElementById("menutype").value);
		var nodetype = getEncodeStr(document.getElementById("nodetype").value);
		var imagfile = getEncodeStr(document.getElementById("imagfile").value);
		var dsporder = getEncodeStr(document.getElementById("dsporder").value);
		var dsporder1 = document.getElementById("dsporder").value;
		if(dsporder1.substr(0,1)=="-"){
			dsporder1=dsporder1.substr(1);
		}
		if(isNaN(dsporder1)){
			alert("dsporder必须是数字，请重新输入！");
			return;
		}
		
		var isshow = getEncodeStr(document.getElementById("isshow").value);
		var condition = getEncodeStr(document.getElementById("condition").value);
		var displayPosition = "";
		var displayPositionArray = document.getElementsByName("displayPosition");
		if(displayPositionArray){
			for(var i = 0; i < displayPositionArray.length; i++){
				if(displayPositionArray[i].checked){
					displayPosition += displayPositionArray[i].value + ",";
				}
			}
			if(displayPosition != ""){
				displayPosition = displayPosition.substring(0,displayPosition.length-1);
			}
		}
		if(menuname == ""){
			alert("<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>");
			return;
		}
		
		var moduleid = getEncodeStr(document.getElementById("moduleid").value);
		
		var isTb;
    	<%if(menutype.equals("1")){%>	//系统菜单,系统菜单不同步到组织菜单并且不弹出同步到组织菜单的对话框
    		isTb=false;
    	<%}else{%>
    		isTb=confirm("是否同步组织菜单?");
    	<%}%>
    	
   		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.MenuTree2Action?action=modify&isadd=<%=isadd %>";

		var updatestring ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
		updatestring += "<data>";
		updatestring += "<id>"+id+"</id>";
		updatestring += "<labelid>"+labelid+"</labelid>";
		updatestring += "<menuname>"+menuname+"</menuname>";
		updatestring += "<pid>"+pid+"</pid>";
		updatestring += "<oid>"+oid+"</oid>";
		updatestring += "<url>"+url+"</url>";
		updatestring += "<menutype>"+menutype+"</menutype>";
		updatestring += "<nodetype>"+nodetype+"</nodetype>";
		updatestring += "<imagfile>"+imagfile+"</imagfile>";
		updatestring += "<dsporder>"+dsporder+"</dsporder>";
		updatestring += "<isshow>"+isshow+"</isshow>";
		updatestring += "<condition>"+condition+"</condition>";
		updatestring += "<isTb>"+isTb+"</isTb>";
		updatestring += "<displayPosition>"+displayPosition+"</displayPosition>";
		updatestring += "<moduleid>"+moduleid+"</moduleid>";
		updatestring += "</data>";

//		alert(updatestring);
		param.updatestring=updatestring;
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");
	   
	   if(id != ""){
			var selectedNode = parent.menuTree.getSelectionModel().getSelectedNode();
			var flagModuleid = getEncodeStr(document.getElementById("flagModuleid").value);
			//是否在模块管理的菜单中修改了菜单的模块id
			var isModifyModuleInModuleManage = ('<%=paramModuleid%>' != '') && (flagModuleid != moduleid);
			if(isModifyModuleInModuleManage){
				selectedNode.parentNode.reload();
			}else{
				if(selectedNode != null){
					var showname = getValidStr(document.getElementById("menuname").value);
					Ext.Ajax.request({   
						url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
						method : 'post',
						params:{   
							keyword : id,
							cnlabelname : showname
						}, 
						success: function (response)    
				        {   
				        	selectedNode.setText(response.responseText);
				        },
					 	failure: function(response,opts) {    
						 	alert('Error', response.responseText);   
						}  
					}); 
				}
			}
		}else{	//create
			if(result != null){
				var selectedNode = parent.menuTree.getSelectionModel().getSelectedNode();
				var moduleid =getEncodeStr(document.getElementById("flagModuleid").value);
                if(selectedNode.isLeaf()){
                selectedNode.parentNode.reload();
                }else
                selectedNode.reload();
                if(moduleid!=null&&moduleid!=''){
                	window.location='menumodify.jsp?menutype=2&pid='+selectedNode.id+'&moduleid='+moduleid;
                }else{
                	window.location='menumodify.jsp?id='+selectedNode.id;
                }
			}
		}
	}
    function checkmenuname(){
    	var menuname = document.getElementById('menuname');
    	//未过滤()（）
		var flag = false;
		for(var i = 0; i < menuname.value.length; i++){
			var c = menuname.value.charAt(i);
			//alert(menuname.value.charCodeAt(i));
			var isChinese = /[\u4E00-\u9FA5]/gi.test(c);
			var isLetter = /[a-zA-Z]/gi.test(c);
			var isNumber = /[0-9]/gi.test(c);
			var isSpecialChar = /[()（）]/gi.test(c);
			if(!isChinese && !isLetter && !isNumber && !isSpecialChar){
				flag = true;
				break;
			}
		}		 
		if(flag){
			msg="<img src=\"/images/base/bacocross.gif\" width=\"13\" height=\"13\"><font color='red'>菜单中包含特殊字符，请更正</font>";
			document.getElementById("menunamespan").innerHTML=msg;
			menuname.value = "";
			menuname.focus();
		}
		return flag;
    }
    
    function getBrowser(viewurl, inputname, inputspan, isneed) {
        var id;
        try {
            id = openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=' + viewurl);
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
                    document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
            }
        }
    }
</script>
</html>