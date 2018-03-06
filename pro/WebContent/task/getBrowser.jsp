<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="com.eweaver.interfaces.model.*" %>
<%@ page import="com.eweaver.interfaces.workflow.*" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitemtype"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%
String objid= request.getParameter("objid");
String rowindex = request.getParameter("rowindex");
String value = request.getParameter("value");
String htmltype = request.getParameter("htmltype");
if("6".equals(htmltype)){
RefobjService refobjService = (RefobjService)BaseContext.getBean("refobjService");
Refobj refobj = refobjService.getRefobj(objid);
if(refobj == null) {
out.print(StringHelper.null2String(value));
} else {
String url = refobj.getViewurl();
String reftable = refobj.getReftable();
String viewfield = refobj.getViewfield();
String keyfield = refobj.getKeyfield();
String sql = "select " + viewfield +" from " + reftable +" where " + keyfield + "='"+value+"'";
DataService dataService = new DataService();
String objname = dataService.getSQLValue(sql);
%>
 <button type=button class=Browser name="button_402880b223ffb124012408ec1126093e"
							     onclick="javascript:getrefobj('default_<%=rowindex %>','default_<%=rowindex %>span','<%=objid %>','','','1');"></button>
								<input type="hidden" name="default_<%=rowindex %>" value="<%=value%>"  style='width: 288px; height: 17px'  >
								<span id="default_<%=rowindex %>span" name="default_<%=rowindex %>span" ><%=StringHelper.null2String(objname)%></span>
<%
}} else if("5".equals(htmltype)){
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");// new SelectitemService(); 
Selectitem selectitem = null;
List<Selectitem> selectList = selectitemService.getSelectitemList(objid,"emptvalue");
if(selectList == null || selectList.isEmpty()) {
out.print(StringHelper.null2String(value));
} else {
%>
<select id="default_<%=rowindex %>" name="default_<%=rowindex %>">
<%
for(Selectitem item : selectList){
String itemid = item.getId();
String itemName = item.getObjname();
%>
<option <%if(itemid.equals(value)){%>selected="selected" <%}%> value="<%=itemid%>"><%=itemName %></option>			    
<%
}
%>
</select>
<%
}
} else if("4".equals(objid) && "1".equals(htmltype)) {
%>
<input onpropertychange="dateChange1('<%=rowindex %>')" type="text" name="default_<%=rowindex %>" size=10 id="default_<%=rowindex %>"
								onclick="WdatePicker()"
								value="<%=StringHelper.null2String(value)%>" />
<%
}
else if("5".equals(objid) && "1".equals(htmltype)) {
%>
<input onpropertychange="dateChange1('<%=rowindex %>')" type="text"  name="default_<%=rowindex %>" size=10 id="default_<%=rowindex %>"
								onclick="WdatePicker({startDate:'%H:00:00',dateFmt:'H:mm:ss'})"
								value="<%=StringHelper.null2String(value) %>" />
<%
} else {
out.print(StringHelper.null2String(value));
}%>