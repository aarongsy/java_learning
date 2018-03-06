<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.lang.String"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.workflow.util.FormfieldTranslate"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.workflow.util.FormfieldTranslate"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%
String id=request.getParameter("formid");
if(StringHelper.isEmpty(id)){
	String formfieldid = request.getParameter("formfieldid");
	RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
	ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
	FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");
	DataService dataService = new DataService();
	Formfield formfield = null;
	String browsorid = "";
	
	if(!StringHelper.isEmpty(formfieldid)){
		formfield = formfieldService.getFormfieldById(formfieldid);
		browsorid = formfield.getFieldtype();
		Refobj refobj = refobjService.getRefobj(browsorid);
		String reftable = refobj.getReftable();

		String sql = "select f.id from Forminfo f where objtablename='"+ reftable +"'";
		id = (String)dataService.getValue(sql);
	}
}


%>

<html>
  <head>
   
  </head>
  
  <body>
  <!--页面菜单开始-->     
<%
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
pagemenustr += "{D,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:btnclear_onclick()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->  
			<TABLE ID=BrowserTable class=BrowserStyle cellspacing=1>
				<tr class="Header">
					<TH><%=labelService.getLabelName("402881e60b95cc1b010b965dc554000c")%><!-- 显示名称-->
					</TH>	
					<TH><%=labelService.getLabelName("402881e60b95cc1b010b96212bc80009")%><!-- 字段名称-->
					</TH>
					<TH><%=labelService.getLabelName("402881e60b95cc1b010b9621ab87000a")%><!-- 表现形式-->
					</TH>
					<TH><%=labelService.getLabelName("402881e60b95cc1b010b9621d0e1000b")%><!-- 字段类型-->
					</TH>
					<TH><%=labelService.getLabelName("402881e60b96db15010b988c02340010")%><!-- 字段属性-->
					</TH>
					<TH><%=labelService.getLabelName("402881e60b95cc1b010b965f6a0c000d")%><!-- 显示标签-->
					</TH>
				</tr>
				<%
			
					String strHql="from Formfield where formid='"+ id +"' and isdelete<1 and labelname is not null order by fieldname";
					List list = ((FormfieldService)BaseContext.getBean("formfieldService")).findFormfield(strHql);
					
					boolean isLight=false;
					String trclassname="";
				    for(int i=0;i<list.size();i++)
				    {
				        Formfield formfield=(Formfield)list.get(i);
				        
						isLight=!isLight;
						if(isLight) trclassname="DataLight";
						else trclassname="DataDark";
				%>
				<tr class="<%=trclassname%>">
					<td style="display:none">
						<%=formfield.getId()%>
					</td>	
					<td nowrap>
						<%=StringHelper.null2String(formfield.getLabelname())%>
					</td>			
					<td nowrap>
						<%=formfield.getFieldname()%>
					</td>
					<td nowrap>
						<%=FormfieldTranslate.getUITypeById(formfield.getHtmltype().intValue())%>
					</td>
						<%  int _htmltype = formfield.getHtmltype().intValue();
							String _fieldtype = FormfieldTranslate.getFieldTypeById(formfield.getFieldtype());
							if(_fieldtype.equals("")&&_htmltype==5){
								_fieldtype = ((SelectitemtypeService)BaseContext.getBean("selectitemtypeService"))
												.getSelectitemtypeById(formfield.getFieldtype()).getObjname();
							}
							//todo 关联选择...
						%>					
					<td nowrap  value='<%=_htmltype %>'><%=StringHelper.null2String(_fieldtype)%></td>
					<td nowrap>
						<%
							String _fieldattr = StringHelper.null2String(formfield.getFieldattr());							
							if(!_fieldattr.equals("")){
							 if(formfield.getFieldtype().equals("1"))
							 	_fieldattr = labelService.getLabelName("402881e60b95cc1b010b96605fe50010")+":"+_fieldattr;
							 else if(formfield.getFieldtype().equals("3"))
							 	_fieldattr = labelService.getLabelName("402881e60b95cc1b010b966017e0000f")+":"+_fieldattr;
							 else if(formfield.getFieldtype().equals("4"))	
							 	_fieldattr = labelService.getLabelName("402881e60b95cc1b010b96605fe50010")+":"+_fieldattr;
							 else if(formfield.getFieldtype().equals("5"))
							   _fieldattr = labelService.getLabelName("402881e60b95cc1b010b96605fe50010")+":"+_fieldattr;
							} 
						%>	 
						<%=_fieldattr%>
					</td>
					<td nowrap>
						<%if(!StringHelper.null2String(formfield.getLabelid()).equals("")){%>
						<%=labelService.getLabelName(formfield.getLabelid())%>
						<%}%>
					</td>
				</tr>
				<%
				}
			   
				%>
			</table>
  </body>
</html>
<SCRIPT LANGUAGE=VBS>

Sub btnclear_onclick()
     getArray "0",""
End Sub

Sub BrowserTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then 
     getArray e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText,e.parentelement.cells(4).innerText,e.parentelement.cells(3).innerText
   ElseIf e.TagName = "A" Then
      getArray e.parentelement.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText,e.parentelement.cells(4).innerText,e.parentelement.cells(3).innerText
   End If
End Sub

Sub BrowserTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub

Sub BrowserTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub



</SCRIPT>
<script>
    function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
<script language="javascript"> 
  function onSubmit(){
    document.EweaverForm.submit();
  } 
</SCRIPT>    