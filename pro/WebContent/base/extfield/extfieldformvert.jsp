<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.extfield.service.ExtfieldService"%>
<%@ page import="com.eweaver.base.extfield.model.Extfieldset"%>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%
//垂直
String objid = StringHelper.trimToNull(request.getParameter("objid"));
String objtable = StringHelper.trimToNull(request.getParameter("objtable"));
LabelService labelService = (LabelService)BaseContext.getBean("labelService"); 
ExtfieldService  extfieldService = (ExtfieldService)BaseContext.getBean("extfieldService");
if(objtable != null){
List setList = extfieldService.getExtfieldsetListByObjtable(objtable);
Map extfieldMap = extfieldService.getExtfieldinfoValueMapByObj(objid);
Iterator it = 	setList.iterator();
while(it.hasNext()){
	Extfieldset extfieldset = (Extfieldset) it.next();
	if (extfieldset.getIsshow().intValue()==0) continue;
	String key = extfieldset.getId();
	int fieldtype = NumberHelper.string2Int(extfieldset.getFieldtype(),1);
	String showname = extfieldset.getLabelid()!=null?labelService.getLabelName(extfieldset.getLabelid()):StringHelper.null2String(extfieldset.getShowname());
	String value = StringHelper.null2String(extfieldMap.get(key));
%>
<tr>
	<td class="FieldName" nowrap>
		<%=showname%>
	</td>
	<td  class="FieldValue">
<%
if(fieldtype==1){%>	
		<input style="width=95%" type="text" name="<%=key%>" value="<%=value%>"/>
<%}
else if(fieldtype==2){
%>		
       	<button type="button" class="Calendar" onclick="javascript:getdate('<%=key%>','<%=key%>span','0')"></button>&nbsp; 
       	<span id=<%=key%>span><%=value%></span>
       	<input type=hidden name="<%=key%>" value="<%=value%>"> 
<%}
else if(fieldtype==3){
%>
		<input type="checkbox" name="<%=key%>" <%="".equals(value)?"":"checked"%> value="1"/>
<%}%>
	</td>
</tr>
<%}
}%>
