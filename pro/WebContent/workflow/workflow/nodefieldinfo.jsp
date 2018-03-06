<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.workflow.request.model.Workflownodestyle"%>
<%
		WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
		NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");
		ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
		FormfieldService formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");
		WorkflowNodeStyleService workflowNodeStyleService = (WorkflowNodeStyleService)BaseContext.getBean("workflowNodeStyleService");
		String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
		Workflowinfo workflowinfo = workflowinfoService.get(workflowid);//得到流程信息
		List nodelist = nodeinfoService.getNodelistByworkflowid(workflowid);//得到该流程的节点
		FormlinkService formlinkService = (FormlinkService)BaseContext.getBean("formlinkService");
		String formid = workflowinfo.getFormid();
		Forminfo mainForminfo = forminfoService.getForminfoById(formid);

		String strHql = "";
		List list;
		int formtype = mainForminfo.getObjtype().intValue();
		String allformids =  "'" + formid + "'";
		ArrayList showformids = new ArrayList();
		if (formtype == 1) {
			strHql = "from Formlink where oid='" + formid + "' order by pid";
			list = formlinkService.findFormlink(strHql);

			for (int i = 0; i < list.size(); i++) {
				Formlink formlink = (Formlink) list.get(i);
				allformids += ",'" + formlink.getPid() + "'";
			}
		}
		else{
		
				showformids.add(formid);
			
		}
		strHql = "from Formlink where oid in(" + allformids + ") and pid in("
				+ allformids + ") and oid !='" + formid
				+ "'";
		list = formlinkService.findFormlink(strHql);
		for(int i=0;i<list.size();i++){
			Formlink formlink = (Formlink) list.get(i);
			String oid = StringHelper.null2String(formlink.getOid());
			String pid = StringHelper.null2String(formlink.getPid());
			int typeid = formlink.getTypeid().intValue();;
			if(StringHelper.isEmpty(oid)||StringHelper.isEmpty(pid))
				continue;
				
			if(showformids.indexOf(oid)==-1)
				showformids.add(oid);
			if(typeid!=2){	
				if(showformids.indexOf(pid)==-1)
					showformids.add(pid);	
			}			
		}
		
%>

<html>
  <head>
  
  </head>
  <body>
	<form action="" target="_self" name="StyleForm"  method="post">
			<select class=inputstyle  name="nodeid" id="nodeid" onChange="onNodeChange()">
			    <option class=Inputstyle value="-1"><STRONG><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0066") %><!-- 所有节点 --></STRONG>
				<%
					Iterator nodeit= nodelist.iterator();
				    while (nodeit.hasNext()){
				         Nodeinfo nodeinfo =  (Nodeinfo)nodeit.next();  
				%>
				<option value=<%=nodeinfo.getId()%> ><%=nodeinfo.getObjname()%></option>	                   
				<%
					} // end while
				%>
			</select>
			<BUTTON Class=Btn type=button accessKey=S onClick="javascript:onSubmitStyle();"><U>S</U>-<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0060") %><!-- 全部保存 --></BUTTON>
			<br>
				
<!-- ------------------------------------------->
<%
	boolean showheader = true;
	for(int _index=0;_index<showformids.size();_index++){
		String _formid = StringHelper.null2String(showformids.get(_index));
		Forminfo _forminfo = forminfoService.getForminfoById(_formid);
%>
<br>
<DIV id="TopTitle" class=TopTitle Style="display:''"><b><%=StringHelper.null2String(_forminfo.getObjname())%></b></DIV>

		<table id="<%=_formid%>" width=100%>
				<% if(showheader){%>
				<tr class="Header">
					<td style="display:none"></td>
					<td width="20%"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360059") %><!-- 字段 --></td>       																					 <!--字段名 -->
					<td width="20%"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0061") %></td>      																				 <!--字段显示名称 -->
					<td width="30%"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0067") %></td>      																				 <!--显示名 -->
					<td width="10%"><input type="checkbox" value="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0062") %>" id="all_isshow" onClick="allisshow()"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %>显示</td>        		 <!--显示 --><!-- 全选 -->
					<td width="10%"><input type="checkbox" value="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0062") %>" id="all_iseditable" onClick="alliseditable()"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71f0ef500041") %></td>     <!--可编辑 -->
					<td width="10%"><input type="checkbox" value="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0062") %>" id="all_notnull" onClick="allisnotnull()"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71f152fc0044") %>必须输入</td>    	 <!--必须输入 -->
					
				</tr>
				<%}else{%>
					<tr></tr>
				<%}%>
				<%
				boolean isLight=false;
				String trclassname="";
				//**************** begin for ************************//
				strHql = "from Formfield where formid ='"+ _formid+"' and isdelete<1 order by formid";
				List mainFieldList = formfieldService.findFormfield(strHql);
				List fieldstylelist = workflowNodeStyleService.getFormStyle(workflowid,"-1",_formid) ;
				for(int i=0;i<mainFieldList.size();i++)
				{
					isLight=!isLight;
					if(isLight) trclassname="DataLight";
					else trclassname="DataDark";
					Formfield formfield = (Formfield)mainFieldList.get(i);
					String showname = "";
					int showstyle = 0;
					for (int j=0;j<fieldstylelist.size();j++){
						Workflownodestyle workflowNodeStyle = (Workflownodestyle)fieldstylelist.get(j);
						if (_formid.equals(workflowNodeStyle.getFormid()) && (workflowNodeStyle.getFieldid()).equals(formfield.getId())){
							showname = StringHelper.null2String(workflowNodeStyle.getDefaultvalue());
							if (showname.equals("")){
								//showname = formfield.getFieldname();
							}
							showstyle = workflowNodeStyle.getShowtype().intValue();
							break ;
						}
					}
					String fieldisshow = "" ;
					String fieldeditable =	"";
					String fieldnotnull = "";
					if (showstyle==0){
						fieldisshow = "" ;
						fieldeditable =	"";
						fieldnotnull = "";
					}
					if (showstyle==1){
						fieldisshow = "checked" ;
						fieldeditable =	"";
						fieldnotnull = "";
					}
					if (showstyle==2){
						fieldisshow = "checked" ;
						fieldeditable =	"checked";
						fieldnotnull = "";
					}
					if (showstyle==3){
						fieldisshow = "checked" ;
						fieldeditable =	"checked";
						fieldnotnull = "checked";
					}
				%>
				
				<tr id="<%=formfield.getId()%>" class="<%=trclassname%>">
				
					<!--************* fieldid ************* -->
					<td style="display:none"><%=StringHelper.null2String(formfield.getId())%></td>
					
					<!-- ***********字段名************-->
					<td  width="20%"><%=StringHelper.null2String(formfield.getFieldname())%></td>
					
					<!-- ***********字段显示名************-->
					<td  width="20%"><%=StringHelper.null2String(formfield.getLabelname())%></td>
					
					<!-- ***********显示名************-->
					<td  width="30%"><input type="text" id="<%=formfield.getId()%>showname" value="<%=showname%>" onmouseover="this.select()"></td>
				
					<!-- ***********是否显示************-->
					<td  width="10%"><input type="checkbox" value="" id="<%=formfield.getId()%>isshow" <%=fieldisshow%> onClick="checkShow('<%=formfield.getId()%>')"></td>
					
					<!-- ***********是否可编辑************-->
					<td  width="10%"><input type="checkbox" value="" id="<%=formfield.getId()%>iseditable" <%=fieldeditable%> onClick="checkEditable('<%=formfield.getId()%>')"></td>
					
					<!-- ***********是否必须输入************-->
					<td  width="10%"><input type="checkbox" value="" id="<%=formfield.getId()%>notnull" <%=fieldnotnull%> onClick="checkNotnull('<%=formfield.getId()%>')"></td>
					
				</tr>
				<%
				}
				//**************** end for ************************//
				%>
				
		</table>
		
<%
		showheader = false;
	}
%>
	</form>
  </body>
</html>
<script language="javascript">

	var req;

	function checkShow(fieldid){
		if (document.all(fieldid+"isshow").checked == false ){
			document.all(fieldid+"iseditable").checked = false ;
			document.all(fieldid+"notnull").checked = false ;
			document.all("all_isshow").checked = false ;
		}
	}
	
	function checkEditable(fieldid){
		if (document.all(fieldid+"iseditable").checked == true ){
			document.all(fieldid+"isshow").checked = true ;
		}
		else {
			document.all("all_iseditable").checked = false ;
			document.all(fieldid+"notnull").checked = false ;
		}
	}
	
	function checkNotnull(fieldid){
		if (document.all(fieldid+"notnull").checked == true ){
			document.all(fieldid+"iseditable").checked = true ;
			document.all(fieldid+"isshow").checked = true ;
		}
		else {
			document.all("all_notnull").checked = false ;
		}
	}
		
	function allisshow(){
		var tables = document.getElementsByTagName("table");
		if ( tables.length == 0 ) return ;
		for (var t=0;t<tables.length;t++){
			var table = tables[t];	
			var checkbox_isshow = document.all("all_isshow");
			if (checkbox_isshow.checked == true ){
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText;
					document.all(fieldid+"isshow").checked = true ;
				}
			}
			else {
				document.all("all_iseditable").checked = false ;
				document.all("all_notnull").checked = false ;
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText;
					document.all(fieldid+"isshow").checked = false ;
					document.all(fieldid+"iseditable").checked = false ;
					document.all(fieldid+"notnull").checked = false ;
				}
			}
		}
	}
	
	function alliseditable(){
	
		var tables = document.getElementsByTagName("table");
		if ( tables.length == 0 ) return ;
		for (var t=0;t<tables.length;t++){
			var table = tables[t];
			var checkbox_editable = document.all("all_iseditable");
			if (checkbox_editable.checked == true ){
				document.all("all_isshow").checked = true;
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText;
					document.all(fieldid+"isshow").checked = true ;
					document.all(fieldid+"iseditable").checked = true ;
				}
			}
			else {
				document.all("all_notnull").checked = false ;
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText;
					document.all(fieldid+"iseditable").checked = false ;
					document.all(fieldid+"notnull").checked = false ;
				}
			}
		}
	}
	
	function allisnotnull(){
		var tables = document.getElementsByTagName("table");
		if ( tables.length == 0 ) return ;
		for (var t=0;t<tables.length;t++){
			var table = tables[t];
			var checkbox_notnull = document.all("all_notnull");
			if ( checkbox_notnull.checked == true ){
				document.all("all_isshow").checked = true ;
				document.all("all_iseditable").checked = true ;
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText;
					document.all(fieldid+"isshow").checked = true ;
					document.all(fieldid+"iseditable").checked = true ;
					document.all(fieldid+"notnull").checked = true ;
				}
			}
			else {
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText ;
					document.all(fieldid+"notnull").checked = false ;
				}
			}
		}

	}
	
	function onSubmitStyle(){
		var curnodeid = document.all("nodeid").value ;
		var tables = document.getElementsByTagName("table");
		if (tables.length==0) return ;
		for (var k=0;k<tables.length;k++){
		
			var table = tables[k];
			var formid = table.id ;
			for ( var i=1;i<table.rows.length;i++ ){
				var fieldid = table.rows(i).cells(0).innerText;
				onOK(fieldid,formid);
			}
		}
		alert("<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0068") %>.");//保存成功
	}
	function onNodeChange(){
		for(var i=0;i<document.StyleForm.length;i++){
			var e = document.StyleForm.elements[i];
			if(e.type == "checkbox") e.checked = false ;
			if(e.type == "text") e.value = "" ;
		}
		
		var curnodeid = document.all("nodeid").value;

		var workflowid = "<%=workflowid%>" ;
		 
	    var url = "<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowNodeStyleAction?from=node&workflowid=" + workflowid + "&curnodeid=" + curnodeid ;
	
	    if (window.XMLHttpRequest) {
	    
	        req = new XMLHttpRequest();

	    } else if (window.ActiveXObject) {
	    
	        req = new ActiveXObject("Microsoft.XMLHTTP");

	    }
	    req.open("POST", url, true);
	    req.onreadystatechange = callback;
	    req.send(null);
	}
	
	function callback() {
	    if (req.readyState == 4) {
	        if (req.status == 200) {
	            parseMessage();            
	        }
	    }
	}

	function parseMessage() {
		var xmlDoc = req.responseXML;
		var styles = xmlDoc.getElementsByTagName("style");
		if (styles.length!=0){
			for (var i=0;i<styles.length;i++){
				var nodevalue = styles[i].childNodes[0].nodeValue;
				nodevalue = decode(nodevalue);
				var values = nodevalue.split("~");
				var formid = values[0];
				var fieldid = values[1];
				var showstyle = values[2];
				var defaultvalue = values[3];
				if (fieldid != null){ 
					var checkbox_isshow = document.all(fieldid+"isshow");
					var checkbox_iseditable = document.all(fieldid+"iseditable");
					var checkbox_notnull = document.all(fieldid+"notnull");
					var input_defaultvalue = document.all(fieldid+"showname");
					if (showstyle == 3){
						checkbox_isshow.checked = true ;
						checkbox_iseditable.checked = true;
						checkbox_notnull.checked = true ;
					}
					else if (showstyle == 2){
						checkbox_isshow.checked = true ;
						checkbox_iseditable.checked = true;
						checkbox_notnull.checked = false ;  
					}
					else if (showstyle == 1){
						checkbox_isshow.checked = true ;
						checkbox_iseditable.checked = false;
						checkbox_notnull.checked = false ; 
					}
					else if (showstyle == 0){
						checkbox_isshow.checked = false ;
						checkbox_iseditable.checked = false;
						checkbox_notnull.checked = false ;
					}
					input_defaultvalue.value = Trim(defaultvalue) ;
				}	

			}
		}
		else {
			var tables = document.getElementsByTagName("table");
			for (var i=0;i<tables.length;i++){
				var table = tables[i];
				for (var k=1;k<table.rows.length;k++){
					var showname = table.rows(k).cells(2).innerText;
					var fieldid = table.rows(k).cells(0).innerText ;
					
					var checkbox_isshow = document.all(fieldid+"isshow");
					var checkbox_iseditable = document.all(fieldid+"iseditable");
					var checkbox_notnull = document.all(fieldid+"notnull");
					
					checkbox_isshow.checked = false ;
					checkbox_iseditable.checked = false;
					checkbox_notnull.checked = false ;
					//document.all(fieldid+"showname")=showname ;
				}
			}
		}
	}
	
	function onOK(fieldid,formid){
		var workflowid = "<%=workflowid%>";
		var curnodeid = document.all("nodeid").value;
		var curformid = "" ;
		var showstyle ;
		if ( !document.all(fieldid+"isshow").checked ){
			showstyle = 0;
		}
		else {
			if ( !document.all(fieldid+"iseditable").checked ){
				showstyle = 1;
			}
			else {
				if ( !document.all(fieldid+"notnull").checked ){
					showstyle = 2;
				}
				else showstyle = 3;
			}
		}

		if(showstyle == 0)
			return;
		var showname = document.all(fieldid+"showname").value;
		showname = " " + showname + " " ;
		var style = formid+"~"+fieldid + "~" + showstyle + "~" + showname + "~";;
		style = encode(style);
		var url = "<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowNodeStyleAction?from=field&workflowid=" + workflowid + "&curnodeid=" + curnodeid + "&style=" + style;
	    if (window.XMLHttpRequest) {
	        req = new XMLHttpRequest();
	    } else if (window.ActiveXObject) {
	        req = new ActiveXObject("Microsoft.XMLHTTP");
	    }
	
	    req.open("POST", url, true);
	    req.onreadystatechange = callback2;
	    req.send(null);
	}

	function callback2(){
	    if (req.readyState == 4) {
	        if (req.status == 200) {
	        }
	    }
	}
	
</script>



