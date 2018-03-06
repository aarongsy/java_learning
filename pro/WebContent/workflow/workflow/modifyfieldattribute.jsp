<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.form.model.Formlayoutfield"%>
<%@ page import="com.eweaver.workflow.form.service.*" %>

<%
		FormlayoutfieldService formlayoutfieldService = (FormlayoutfieldService) BaseContext.getBean("formlayoutfieldService");
		ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
		FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");
		String formlayoutid = StringHelper.null2String(request.getParameter("layoutid")) ;
        FormlinkService formlinkService=(FormlinkService)BaseContext.getBean("formlinkService");
		List layoutfieldList = new ArrayList();
		layoutfieldList = formlayoutfieldService.getFormlayoutField(formlayoutid) ;
		List pformlist = new ArrayList();//所有从表列表

		List layoutfieldlist2 = new ArrayList();
		String formids = "" ;//所有form的id ;
		for (int i=0;i<layoutfieldList.size();i++){
			Formlayoutfield formlayoutfield = (Formlayoutfield)layoutfieldList.get(i);
			if (formlayoutfield.getFormid()!=null) {//从表样式信息
				pformlist.add(formlayoutfield);//加入从表列表
			}
			else {//字段样式信息
				String sFieldid = formlayoutfield.getFieldname();
				Formfield formfield = formfieldService.getFormfieldById(sFieldid) ;
				formlayoutfield.setFormid(formfield.getFormid());
				layoutfieldlist2.add(formlayoutfield);
				String formid4 = formfield.getFormid();
				if (formids.indexOf(formid4)==-1){
					if (formids.equals("")){
						formids += formid4 ;
					}
					else {
						formids += "," + formid4 ; 
					}
					
				}
				
 			}
		}
		for (int i=0;i<pformlist.size();i++){
			Formlayoutfield formlayoutfield3 = (Formlayoutfield)pformlist.get(i);
			String formid5 = formlayoutfield3.getFormid();
			
				if (formids.indexOf(formid5)==-1){
					if (formids.equals("")){
						formids += formid5 ;
					}
					else {
						formids += "," + formid5 ; 
					}
					
				}
		}
		String [] formidslist = formids.split(",") ;
    //if showstyle is not defined,add showstyle for them.
    ArrayList pformidlist = new ArrayList();
    for (String fid : formidslist) {
        List fls = formlinkService.findFormlink("from Formlink where pid='" + fid + "' and typeid=2 and isdelete=0");
        if (fls.size() > 0)
            pformidlist.add(fid);
    }
    ArrayList pformidlistexist=new ArrayList();
    for(int i=0;i<pformlist.size();i++){
        Formlayoutfield layoutfield = (Formlayoutfield)pformlist.get(i) ;
         pformidlistexist.add(layoutfield.getFormid());  //获取已存在的明细表id
    }
    if (pformlist.size() >= 0 && pformidlist.size() > 0) {
        for (Object pformid : pformidlist) {
            if(pformidlistexist.contains(pformid)){
                continue;
            }
            Formlayoutfield flf = new Formlayoutfield();
            flf.setLayoutid(formlayoutid);
            flf.setFormid((String) pformid);
            flf.setShowstyle(3);
            formlayoutfieldService.saveOrUpdate(flf);
            pformlist.add(flf);
        }
    }
    
    String funNames = "";
    FormlayoutService formlayoutService = (FormlayoutService)BaseContext.getBean("formlayoutService");
	Formlayout formlayout = formlayoutService.getFormlayoutById(formlayoutid);
	String layoutinfo = formlayout.getLayoutinfo();
	while(layoutinfo != null && layoutinfo.indexOf("function") != -1){
		int index = layoutinfo.indexOf("function");
		layoutinfo = layoutinfo.substring(index + 8);
		if(layoutinfo.indexOf("(") != -1){
			String funName = layoutinfo.substring(0, layoutinfo.indexOf("("));
			if(funName.trim().length() != 0){
				funNames = funNames + funName.trim() + ",";
			}
		}
	}
	String funNamesParam = "";
	if(funNames.length() != 0){
		funNames = funNames.substring(0, funNames.length() - 1);
		funNamesParam = "&funnames=" + funNames;
	}
%>
<html>
  <head>
  	<style type="text/css">
  		html,body{
  			overflow: hidden;
  		}
  	</style>
  	<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
  	<script type="text/javascript">
  		window.onload = function(){
  			var theWidth = window.screen.width - 20;
  			var theHeight;
  			if(window.screen.height > document.body.clientHeight){
  				theHeight = document.body.clientHeight - 30;
  			}else{
  				theHeight = window.screen.height - 150;
  			}
  			var forIE10HackDiv = document.getElementById("forIE10HackDiv");
  			forIE10HackDiv.style.width = theWidth + "px";
  			forIE10HackDiv.style.height = theHeight + "px";
  		};
  	</script>
  </head>
  <body>
  <div style="height: 30px;">
 	<input type=hidden id="formlayoutid" value="<%=formlayoutid%>">
	<BUTTON Class=Btn type=button accessKey=S onClick="javascript:onSubmitStyle();"><U>S</U>-<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0060") %><!-- 全部保存 --></BUTTON><br>
  </div>
  <div id="forIE10HackDiv" style="overflow-y: scroll;">
<!--  result  -->

<%
	int vheader = 0;
	
	if (formidslist.length!=0){
	
	for (int i=0;i<formidslist.length;i++){ //////////////////////////////////////begin for 1
	
		String formid = formidslist[i];//找到formid
%>

<%=(forminfoService.getForminfoById(formid)).getObjname()%>
		<table id="<%=formid%>">
				<!------ 列宽控制 ------>
<%
		if(vheader==0)
		{
%>
				<tr class="Header">
					<td width="0%" style="display:none"></td>
					<td width="0%" style="display:none"></td>
					<td width="5%"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360059") %><!-- 字段 --></td>        																		  <!--字段名 -->
                    <td width="15%"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0061") %><!-- 字段名 --></td>      																		  <!--字段显示名称 -->
					<td width="5%"><%=labelService.getLabelNameByKeyId("402881e50ad58ade010ad58f1aef0001") %><!-- 顺序 --></td>
                    <td width="9%"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %><!-- 显示 --><input type="checkbox" value="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0062") %>" id="all_isshow" onClick="allisshow()"></td>        <!--显示 --><!-- 全选 -->
					<td width="10%"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71f0ef500041") %><input type="checkbox" value="全选" id="all_iseditable" onClick="alliseditable()"></td> <!--可编辑 -->
					<td width="11%"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71f152fc0044") %><input type="checkbox" value="全选" id="all_notnull" onClick="allisnotnull()"></td>  <!--必须输入 -->
					<td width="12%"><%=labelService.getLabelNameByKeyId("402883e23c12db77013c12db7dbb0000") %><input type="checkbox" value="全选" id="all_ishtmlsignatureprotected" onClick="allishtmlsignatureprotected()"></td>
					<td width="15%"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0063") %></td>      																		  <!--默认值 -->
					<td width="18%"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0064") %></td>        																		  <!--公式 -->
				</tr>
<%
		vheader++;
		}
			else
		{
%>
				<tr style="display:none">
					<td width="0%"></td>
					<td width="0%"></td>
					<td width="5%"></td>
                    <td width="15%"></td>
					<td width="5%"></td>
                    <td width="9%"></td>
					<td width="10%"></td>
					<td width="11%"></td>
					<td width="12%"></td>
					<td width="15%"></td>
					<td width="18%"></td>
				</tr>
<%
		}
%>

<%
				boolean isLight=false;
				String trclassname="";
				//**************** begin for ************************
				for(int j=0;j<layoutfieldlist2.size();j++)  //////////////////////////begin for .....................
				{	
					Formlayoutfield formlayoutfield = (Formlayoutfield)layoutfieldlist2.get(j);

					Formfield formfield = formfieldService.getFormfieldById(formlayoutfield.getFieldname()) ;//找到当前的fieldid
					if ((formfield.getFormid().trim()).equals(formid)){      //////////和该table的id比较////////begin if ......................
						isLight=!isLight;
					    if(isLight) trclassname="DataLight";
						else trclassname="DataDark";
						int showstyle = formlayoutfield.getShowstyle().intValue();
						String checked_isshow = "" ;
						String checked_iseditable = "" ;
						String checked_notnull = "" ;
						if (showstyle == 0){
							
						}
						else if (showstyle ==1){
							checked_isshow = "checked" ;
						}
						else if (showstyle ==2 ){
							checked_isshow = "checked" ;
							checked_iseditable = "checked" ;
							
						}
						else if (showstyle == 3){
							checked_isshow = "checked" ;
							checked_iseditable = "checked" ;
							checked_notnull = "checked" ;
						}
						String checked_ishtmlsignatureprotected="";
						int ishtmlsignatureprotecte=NumberHelper.string2Int(formlayoutfield.getIsHtmlSignatureProtected(),0);
						if(ishtmlsignatureprotecte==1){
							checked_ishtmlsignatureprotected="checked";
						}
						
						String defvalue = StringHelper.null2String(formlayoutfield.getDefaultvalue());
                        int col1 = NumberHelper.getIntegerValue(formlayoutfield.getCol1(),0);
						if (defvalue.equalsIgnoreCase("null")) defvalue = "";
						String formula = StringHelper.null2String(formlayoutfield.getFormula());
						if (formula.equalsIgnoreCase("null") ) formula = "";
						String formula1=formula;
						if (!formula.equals("")){
							String quot2 = "&quot;";
							String quot1 = "\"" ;
							formula1 = StringHelper.replaceString(formula,quot1,quot2) ;
						}
%>
				<tr id="<%=formfield.getId()%>" class="<%=trclassname%>">
				
					<!--************* fieldid ************* -->
					<td width="0%" style="display:none"><%=formfield.getId()%></td>
					
					<td width="0%" style="display:none"><%=formlayoutfield.getId()%></td>
					
					<!-- ***********字段名************-->
					<td width="5%" ><%=formfield.getFieldname()%></td>

					<!-- ***********字段显示名************-->
					<td width="15%" ><%=formfield.getLabelname()%></td>
				    <td width="5%" ><input type="text" size=25 id="<%=formfield.getId()%>col1" value="<%=col1%>" onkeypress="checkInt_KeyPress()"></td>
					<!-- ***********是否显示************-->
					<td width="9%" ><input type="checkbox" value="" id="<%=formfield.getId()%>isshow" <%=checked_isshow%> onClick="checkShow('<%=formfield.getId()%>')"></td>
					
					<!-- ***********是否可编辑************-->
					<td width="10%" ><input type="checkbox" value="" id="<%=formfield.getId()%>iseditable" <%=checked_iseditable%> onClick="checkEditable('<%=formfield.getId()%>')"></td>
					
					<!-- ***********是否必须输入************-->
					<td width="11%" ><input type="checkbox" value="" id="<%=formfield.getId()%>notnull" <%=checked_notnull%> onClick="checkNotnull('<%=formfield.getId()%>')"></td>
					
					<!-- ***********是否受电子签章保护************-->
					<td width="12%" ><input type="checkbox" value="" id="<%=formfield.getId()%>ishtmlsignatureprotected" <%=checked_ishtmlsignatureprotected%> onClick="checkIshtmlsignatureprotected('<%=formfield.getId()%>')"></td>
					
					<!-- ***********默认值************-->
					<td width="15%" ><input type="text" size=25 id="<%=formfield.getId()%>defaultvalue" value="<%=defvalue%>"></td>
					
					<!-- ***********公式************-->
					<td width="18%" ><input type="text" size=50 id="<%=formfield.getId()%>formula" value="<%=formula1%>" readOnly onClick="javascript:fieldstyleedit('/workflow/workflow/dlg_fieldattribute.jsp?fieldid=<%=formfield.getId()%>&forminfoid=<%=formid%><%=funNamesParam %>')"></td>
				</tr>
				<%
				}
				//**************** end if  ************************ 
				}
				//*************** end for  ************************
				%>
				
		</table>
		
<%
////////////////////////////****end for 1 ***********************
	} 
	}//end if ///////////////
%>
<!---------result------>
<br>
<%
if (pformlist.size()!=0){//////////////begin if
%>
<table id="formstyle">

<%
for (int i=0;i<pformlist.size();i++){////////////begin for 
	Formlayoutfield layoutfield = (Formlayoutfield)pformlist.get(i) ;
	String pformid = layoutfield.getFormid() ;
	String condition = StringHelper.null2String(layoutfield.getDefaultvalue()) ;
	if (condition.equalsIgnoreCase("null")) condition = "";
	while(condition.indexOf("\"")!=-1){
		condition=condition.replace("\"","&quot;");
	}
	int formstyle = layoutfield.getShowstyle().intValue() ;
	String radio1checked = "";
	String radio2checked = "";
	String radio3checked = "";
	String radio4checked = "";
	if (formstyle==0){
		radio1checked = "checked" ;
	}
	else if (formstyle == 1){
		radio2checked ="checked" ;
	}
	else if (formstyle == 2){
		radio3checked ="checked" ;
	}
	else if (formstyle == 3){
		radio4checked ="checked" ;
	}
%>
	<tr>
		<td width="0%" style="display:none"><%=pformid%></td>
		<td width="0%" style="display:none"><%=layoutfield.getId()%></td>
		<td width="15%"><%=forminfoService.getForminfoById(pformid).getObjname()%></td>
		<td width="30%"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71f249c90047") %><!-- 不可添加,不可删除 --><INPUT type=radio name="<%=pformid%>radio" value="0" <%=radio1checked%> > <%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71f30607004a") %><!-- 可添加,不可删除 --><INPUT type=radio name="<%=pformid%>radio" value="1" <%=radio2checked%> > <%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71f36d25004d") %> <!-- 不可添加,可删除 --><INPUT type=radio name="<%=pformid%>radio" value="2" <%=radio3checked%> > <%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71f456220050") %><!--  --><INPUT type=radio name="<%=pformid%>radio" value="3" <%=radio4checked%> ></td>
		<td width="55%"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0065") %><!-- 筛选条件 --><input type="text" id="<%=pformid%>condition" value="<%=condition%>"  readOnly onClick="javascript:showcondition(this.value,'<%=pformid%>')"></td>
	</tr>
<%
}///////////////end for
%>
</table>

<%
}////////////end if
%>
  </div>
	
  </body>
</html>
<script language="javascript">

	var req;
	
	function showcondition(condition,pformid){
		//while(condition.indexOf("%")!=-1){
			//condition=condition.replace("%","@");
		//}
		var url="/workflow/workflow/showcondition.jsp?condition=" + encodeURIComponent(condition) ;
		var id=window.showModalDialog(encodeURI("/base/popupmain.jsp?url=" + url),window,"dialogHeight: 420px"+"; dialogWidth: 610px"+"; center: Yes; help: No; resizable: no; status: No");
		document.all(pformid+"condition").value = id;
	}
	
   function fieldstyleedit(url){
   		var id=window.showModalDialog("/base/popupmain.jsp?url="+ url,document,"dialogHeight: 420px"+"; dialogWidth: 600px"+"; center: Yes; help: No; resizable: no; status: No");
			//tab.fireEvent("onClick") ;
			//document.location.href= url ;
   }

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
	
	function checkIshtmlsignatureprotected(fieldid){
		if (!document.all(fieldid+"ishtmlsignatureprotected").checked == true ){
			document.all("all_ishtmlsignatureprotected").checked = false ;
		}else{
			document.all("all_ishtmlsignatureprotected").checked = true ;
		}
	}
		
	function allisshow(){
		var tables = document.getElementsByTagName("table");
		if ( tables.length == 0 ) return ;
		for (var t=0;t<tables.length;t++){
			var table = tables[t];	
			if(table.id == "formstyle") continue;
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
			if(table.id == "formstyle") continue;
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
			if(table.id == "formstyle") continue;
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
	
	function allishtmlsignatureprotected(){
		var tables = document.getElementsByTagName("table");
		if ( tables.length == 0 ) return ;
		for (var t=0;t<tables.length;t++){
			var table = tables[t];
			if(table.id == "formstyle") continue;
			var checkbox_ishtmlsignatureprotected = document.all("all_ishtmlsignatureprotected");
			if ( checkbox_ishtmlsignatureprotected.checked == true ){
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText;
					document.all(fieldid+"ishtmlsignatureprotected").checked = true ;
				}
			}
			else {
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText ;
					document.all(fieldid+"ishtmlsignatureprotected").checked = false ;
				}
			}
		}

	}
	
	function onSubmitStyle(){
	
		var tables = document.getElementsByTagName("table");
		if (tables.length==0) return ;
		for (var k=0;k<tables.length;k++){
		
			var table = tables[k];
			var formid = table.id ;
			if(table.id == "formstyle"){
				if (table.rows!=0){
					for (var l=0;l<table.rows.length;l++){
						var pformid = table.rows(l).cells(0).innerText;
						var layoutfieldid = table.rows(l).cells(1).innerText;
						onOK2(layoutfieldid,pformid);
					}
				} 
			}
			else{
				for ( var i=1;i<table.rows.length;i++ ){
					var fieldid = table.rows(i).cells(0).innerText;
					var layoutfieldid = table.rows(i).cells(1).innerText;
					onOK(fieldid,formid,layoutfieldid);
				}
			}
		}
		alert("保存成功.");
	}
	
	function onOK2(layoutfieldid,pformid){
		var layoutid = document.all("formlayoutid");
		var radioid = pformid+"radio" ;
		var formstyle ;
		var formstyleoption = document.all(radioid);
		for (var i=0;i<formstyleoption.length;i++){
			if(formstyleoption[i].checked == true )
				formstyle = formstyleoption[i].value ;
		}
		var condition = document.all(pformid + "condition").value;
		
		var s="";
		for(var i=0;i<condition.length;i++){
			s+=condition.charCodeAt(i)+"@";
		}
		condition=s;
		
		var style = pformid + "~" + formstyle + "~ " + condition +"~";
		var url = "/ServiceAction/com.eweaver.workflow.request.servlet.FieldAttributeAction?from=pform&style=" + style + "&layoutid=" + layoutid + "&layoutfieldid=" + layoutfieldid;
	    if (window.XMLHttpRequest) {
	        req = new XMLHttpRequest();
	    } else if (window.ActiveXObject) {
	        req = new ActiveXObject("Microsoft.XMLHTTP");
	    }
	    req.open("POST", url, true);
	    req.onreadystatechange = callback2;
	    req.send(null);
	}
		
	function onOK(fieldid,formid,layoutfieldid){
		var layoutid = document.all("formlayoutid");
		var showstyle =0;
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
		
		var ishtmlsignatureprotected=0;
		if(document.all(fieldid+"ishtmlsignatureprotected").checked){
			ishtmlsignatureprotected=1;
		}
		

		var defaultvalue = document.all(fieldid+"defaultvalue").value;
        var col1 = document.all(fieldid+"col1").value;
		defaultvalue = " " + defaultvalue + " " ;
		var formula = document.all(fieldid+"formula").value;
		formula = " " + formula + " " ;
		var style = formid+"~"+fieldid + "~" + showstyle + "~" + defaultvalue + "~" + formula  + "~"+ col1  + "~"+ishtmlsignatureprotected+"~";
		style = encode(style);
		var url = "/ServiceAction/com.eweaver.workflow.request.servlet.FieldAttributeAction?from=field&layoutid=" + layoutid + "&style=" + style +"&layoutfieldid=" + layoutfieldid;
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



