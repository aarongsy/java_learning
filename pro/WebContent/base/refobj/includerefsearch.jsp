<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.refobj.service.*"%>
<%@ page import="com.eweaver.base.refobj.model.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.base.*"%>
<%
Refobj refobj = new Refobj();
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
List refobjList=refobjService.getAllRefobj2();
%>

<!-- 扩展搜索信息开始-->
		<input type="hidden"  name="refobjlistsize" value="<%=refobjList.size()%>">
<br>
<FIELDSET 100%><LEGEND>业务协同搜索条件</LEGEND>
<table>
	<colgroup> 
     <col width="15%">
     <col width="35%">
     <col width="15%">
     <col width="35%">
	</colgroup>	  
				</tr>	    
		<%
		for(int i=0;i<refobjList.size();i++){
		   refobj=(Refobj)refobjList.get(i);
		   if(!StringHelper.null2String(refobj.getIsrefobjlink()).equals("1")) continue;
			%>
			 		<td class="FieldName" nowrap><%=refobj.getObjname()%></td>
			 		<td class="FieldValue" align=left>
			 		<button  type="button" class=Browser onclick="javascript:getBrowser3('/base/refobj/baseobjbrowser.jsp?id=<%=refobj.getId()%>','objid2<%=i%>','objid2span<%=i%>','0','<%=refobj.getId()%>');"></button>
					<input type="hidden"  name="objid2<%=i%>" value="">
					<span id="objid2span<%=i%>"/></span>
					</td>
		<%if(i%2!=0){%> 
			</tr>
		<%}%>			 	
<%}%>
</table>
</FIELDSET>
<!-- 扩展搜索信息结束-->	

<script type="text/javascript">
    function getBrowser3(url,inputname,inputspan,objtypeid2){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
    
</script>