<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@ page import="com.eweaver.workflow.workflow.service.ExportService"%>
<%@ page import="com.eweaver.workflow.workflow.model.Export"%>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>

<%
		WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
		ExportService exportService = (ExportService)BaseContext.getBean("exportService");
		NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");
		String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
		Workflowinfo workflowinfo = workflowinfoService.get(workflowid);
        SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
    Setitem gmode = setitemService.getSetitem("402880311e723ad0011e72782a0d0005");
    String graphmode = "0";
    if (gmode != null && !StringHelper.isEmpty(gmode.getItemvalue())) {
        graphmode = gmode.getItemvalue();
    }
		String formid = workflowinfo.getFormid();
	//	request.setAttribute("workflowid",workflowid);
	//	Workflowinfo workflowinfo = workflowinfoService.get("1");
		//获得一个流程的的所有节点


		List exportlist = exportService.getAllExportByWorkflowID(workflowid);
		List nodelist = nodeinfoService.getNodelistByworkflowid(workflowid);
		int rowsum=0; 
		
		Iterator nodeit= nodelist.iterator();
%>

<html>
  <head>
  </head>
  
  <body>

     
<!--页面菜单开始-->     

<div id="pagemenubar" style="z-index:100;"></div> 


<!--页面菜单结束-->   
  
   <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=crud" name="EweaverForm"  method="post">
 <input type="hidden" name="workflowid" size=25 value="<%=workflowid%>">
 <%if(graphmode.equals("0")){%>
       <select class=inputstyle  name="curnode">
       <option class=Inputstyle value="-1"><STRONG>************<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0016") %><!-- 请选择当前节点 -->**************</STRONG>


       <%
                                  //Iterator nodeit= nodelist.iterator();
                                  String thenodeoptions = "";
                                  while (nodeit.hasNext()){
                                     Nodeinfo nodeinfo =  (Nodeinfo)nodeit.next();


                               %>
                                  <option value=<%=nodeinfo.getId()%> ><%=nodeinfo.getObjname()%></option>
                               <%
                               thenodeoptions += "<option value="+StringHelper.null2String(nodeinfo.getId()) + "><strong>"+StringHelper.null2String(nodeinfo.getObjname())+"</strong>";
                                  } // end while
                               %>

       </select>

       <BUTTON type=button Class=Btn type=button accessKey=A onclick="javascript:addExportRow('<%=thenodeoptions%>','<%=formid%>');"><U>A</U>-<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0053") %><!-- 添加出口 --></BUTTON>
       <BUTTON type=button Class=Btn type=button accessKey=D onclick="if(isdel()){deleteExportRow();}"><U>D</U>-<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0054") %><!-- 删除出口 --></BUTTON>
       <BUTTON type=button Class=Btn type=button accessKey=S onclick="if(checkEndnodeId()){saveExportAll();}"><U>S</U>-<%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023") %><!-- 保存 --></BUTTON>

 <%}%>
<div id="odiv">
 <table class="">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
      <TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
  </table>
  <table class=liststyle cellspacing=1   cols=6 id="vTable">
       <input type="hidden"  name="row" id="row" value=""/>
      	<COLGROUP>
  	<COL width="5%">
  	<COL width="20%">
  	<COL width="35%">
  	<COL width="20%">
  	<COL width="10%">
  	<COL width="10%">
    	   <tr class=header>
            <td> <%=labelService.getLabelName("402881f00c7690cf010c769feebc0019")%></td><!--选中--> 
            <td> <%=labelService.getLabelName("402881ee0c715de3010c7248aaad0072")%></td><!--节点名称--> 
            
            <td> <%=labelService.getLabelName("402881f00c7690cf010c76a0ddde001c")%></td><!--条件--> 
           
            <td> <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0055") %><!-- 条件描述 --></td><!--出口名称--> 
            <td> <%=labelService.getLabelName("402881f00c7690cf010c76a16682001f")%></td><!--出口名称--> 
            <!--td> <--%=labelService.getLabelName("402881f00c7690cf010c76a1d1580022")%></td><!--按钮名称--> 
            <td> <%=labelService.getLabelName("402881f00c7690cf010c76a23a740025")%></td><!--目标节点--> 
</tr>
<tr class="Line"><td colspan="7"> </td></tr>


<%
						   Iterator exportIT= exportlist.iterator();
						  int rows=1;
						   while (exportIT.hasNext()){
							  Export exportinfo =  (Export)exportIT.next();
             
						%>

<TR class=DataLight>

	<td height="23"><input type='checkbox' name='check_node'"  value="<%=exportinfo.getId()%>" >
	<input type="hidden" name="id" size=25 value="<%=exportinfo.getId()%>">
	
	</td>
    <%
    	Iterator nodeit3= nodelist.iterator();
    	String nodename = "";
    	
		 while (nodeit3.hasNext()){
		 		Nodeinfo nodeinfo =  (Nodeinfo)nodeit3.next();
		 		String checkit = "";
				if(nodeinfo.getId().equals(exportinfo.getStartnodeid())){
					nodename = nodeinfo.getObjname();
					break;
				}
		}
    %>	
    <td  height="23"><%=nodename%>
    <input type="hidden" name="startnodeid" value="<%=exportinfo.getStartnodeid()%>">
    </td>
    <td class="FieldValue">
    <%
    	String url="/workflow/workflow/exportbrowser.jsp?formid=" + formid + "&&condition=" + StringHelper.null2String(exportinfo.getCondition());
    	url = URLEncoder.encode(url, "UTF-8");
    %>
	   <button  type="button" class=Browser onclick="javascript:getBrowserExport('<%=url%>','condition<%=rows%>','conditionspan<%=rows%>','0');"></button>
	   <input type="hidden"  name="condition<%=rows%>" value="<%=StringHelper.null2String(exportinfo.getCondition())%>"/>
	   
	   <span id="conditionspan<%=rows%>" nowrap><%=StringHelper.null2String(exportinfo.getCondition())%></span>    
    </td>

 <td  height="23"><input class=Inputstyle type="text" name="conditionname" value="<%=StringHelper.null2String(exportinfo.getCol1())%>"></td>
   
    <td  height="23"><input class=Inputstyle type="text" name="linkname" value="<%=StringHelper.null2String(exportinfo.getLinkname())%>"></td>
    <!-- td  height="23"><input class=Inputstyle type="text" name="btnname" value="<--%=StringHelper.null2String(exportinfo.getBtnname())%>"></td-->   
    <td height="23">
    <select class=inputstyle  name="endnodeid" >
	<option value="-1"><STRONG> <%=labelService.getLabelName("402881f00c7690cf010c76a305fd0028")%></strong><!--请选择目标节点--> 
	<%
		Iterator nodeit2= nodelist.iterator();
		 while (nodeit2.hasNext()){
		 		Nodeinfo nodeinfo =  (Nodeinfo)nodeit2.next();
		 		String checkit = "";
				if(nodeinfo.getId().equals(exportinfo.getEndnodeid())){
					checkit = "selected";
				}
	%>
	
	<option value="<%=nodeinfo.getId()%>" <%=checkit%>><%=nodeinfo.getObjname()%></option>
	<%
	}
	%>
	
	</select>
</td>
</tr>

<%
rows++;
}%>
</table>



<br>
<center>
<input type="hidden" value="wfnodeportal" name="src">
  <input type="hidden" value="49" name="wfid">
  <input type="hidden" value="0" name="nodessum">
  <input type="hidden" value="" name="delids">
<center>
</div>
 </form>    
 
 <script language="JavaScript" src="<%=request.getContextPath()%>/js/addRowBg.js" >
</script>  
<script language=javascript>
var rowColor="" ;
rowindex = 0;
delids = "";
function addExportRow(thenodeoptions,formid){

	var oOption=document.EweaverForm.curnode.options[document.EweaverForm.curnode.selectedIndex];
	if(oOption.value == -1){
		alert("<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0056") %>");//请选择一个节点
		return;
	}
		
		
	tmpval = oOption.value;
	tmptype = tmpval;
	
	tmptype = tmptype.substring(tmptype.indexOf("_")+1);
	
	ncol = vTable.cols;
	rowColor = getRowBg();
	oRow = vTable.insertRow();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		//oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input  type='checkbox' name='check_node' value='0'><input  type='hidden' name='id'> "; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;		
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = oOption.text + "<input type='hidden' name='startnodeid' value='"+tmpval+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 2: 
				var oDiv = document.createElement("div"); 
				var rowNum = vTable.rows.length;
				rowNum = rowNum +1;
				alert(rowNum);
				var temphtml = "javascript:getBrowser('<%=request.getContextPath()%>/workflow/workflow/exportbrowser.jsp?formid=<%=formid%>','condition','conditionspan','0');";
				var sHtml = "<button  type=button class=Browser onclick= " + temphtml + "></button>";
				sHtml += "<input type='hidden'  name='condition"+rowNum+"' />";
				sHtml += "<span id='conditionspan"+rowNum+"'/></span>";

				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;				
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='text' class=inputstyle name='conditionname'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='text' class=inputstyle name='linkname'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
		
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<select class=inputstyle  name='endnodeid'>";
				sHtml+= "<option value='-1'><%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76a305fd0028") %></option>";//请选择目标节点
				sHtml+= thenodeoptions;
				sHtml+= "</select>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;							
		}
	}
}
function deleteExportRow()
{
	alert("<%=labelService.getLabelNameByKeyId("402881e90aac1cd3010aac1d97730001") %>");//确定要删除吗？
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
			
				if(document.forms[0].elements[i].value!='0'){
					var did = document.forms[0].elements[i].value;
					document.all("delids").value =document.all("delids").value +",'"+did+"'";				
				}
				vTable.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}
	}
  
	window.document.EweaverForm.submit();
}


function isdel(){
	var count = 0;
	len = document.forms[0].elements.length;
	var i=0;

	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			if(document.forms[0].elements[i].checked==true) {
					count++;			
			}
	}

	if(count>0){
		return true;
	}else{
		return false;
	}
		
}
function saveExportAll(){
	document.forms[0].nodessum.value=rowindex;
	document.forms[0].delids.value=delids;
	
	window.document.EweaverForm.submit();
}

function checkSame(curNodePortal,selNodePortal){

    if(document.all(curNodePortal).value==document.all(selNodePortal).value)
    alert("<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0057") %>");//警告：目标节点与当前节点一样！
}

function checkEndnodeId(){
	var lenstartnodeid = document.EweaverForm.startnodeid.length;
	if(lenstartnodeid > 1){
		var i=0;
		var target ="";
		for(i=0; i<lenstartnodeid; i++){
			if(document.EweaverForm.endnodeid[i].value == "-1"){
				alert("<%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76a305fd0028") %>");//请选择目标节点
				return false;
			}
		}
	}else{
		if(document.EweaverForm.endnodeid.value == "-1"){
			alert("<%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76a305fd0028") %>");//请选择目标节点
			return false;
		}
	}

	return true;
}

</script>
  
  </body>
</html>

