<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportSearchfieldService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService" %>
<%@ page import="com.eweaver.workflow.form.model.Formlink" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%
    String reportid = StringHelper.null2String(request.getParameter("id"));
    String formid = StringHelper.null2String(request.getParameter("formid"));
    FormlinkService formlinkService = (FormlinkService) BaseContext.getBean("formlinkService");
    ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
    ReportdefService reportdefService=(ReportdefService)BaseContext.getBean("reportdefService");
    LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
    Forminfo forminfo = forminfoService.getForminfoById(formid);
    String forminfoid = "";
    if (forminfo.getObjtype() == 1) { //通过抽象表单的id来获得主表的id
        String forminfotable = forminfo.getObjtablename();
        String sql = "select id from forminfo where objtablename='" + forminfotable + "' and objtype=0";
        List list = forminfoService.getBaseJdbcDao().getJdbcTemplate().queryForList(sql);
        for (Object o : list) {
            forminfoid = ((Map) o).get("id") == null ? "" : ((Map) o).get("id").toString();
        }
        String secFormid=reportdefService.getReportdef(reportid).getSecformid();
        forminfoid+="','"+secFormid;
    } else {
        forminfoid = formid;
    }
ReportfieldService reportfieldService=(ReportfieldService)BaseContext.getBean("reportfieldService");
FormfieldService formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");
ReportSearchfieldService reportSearchfieldService=(ReportSearchfieldService)BaseContext.getBean("reportSearchfieldService");

String sql1 = "from Formfield where isdelete<1 and htmltype!='3' and labelname is not null and formid in('"+forminfoid+"') and id not in (select formfieldid from Reportsearchfield where reportid ='"+reportid+"') order by formid";

List list = reportSearchfieldService.getReportsearchfieldList(sql1);
String sql2 = "from Reportsearchfield where reportid ='"+reportid+"'";
List list2 = reportSearchfieldService.getReportsearchfieldList(sql2);
%>
<%
    pagemenustr =  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','S','accept',function(){onSubmit()});";//确定
%>
<html>
  <head>
  <Style>
     #pagemenubar table {width:0}
</Style>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
 <script type="text/javascript">
     Ext.onReady(function(){
             var tb = new Ext.Toolbar();
             tb.render('pagemenubar');
         <%=pagemenustr%>

      var c = new Ext.Panel({
                title:'<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220003")%>',iconCls:Ext.ux.iconMgr.getIcon('config'),//查询条件定义
                layout: 'border',
                items: [{region:'center',autoScroll:true,contentEl:'divSum'}]
            });
      var contentPanel = new Ext.TabPanel({
             region:'center',
             id:'tabPanel',
             deferredRender:false,
             enableTabScroll:true,
             autoScroll:true,
             activeTab:0 ,
             items:[c]
         });
         <%
          if(!"humres".equals(forminfo.getObjtablename())&&!"docbase".equals(forminfo.getObjtablename())){
         %>
      addTab(contentPanel,'<%=request.getContextPath()%>/workflow/report/groupfield/reportfieldorlist.jsp?reportid=<%=reportid%>','<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220004")%>','page_portrait');//关系配置
         <%}%>
      addTab(contentPanel,'<%=request.getContextPath()%>/workflow/report/groupfield/reportcombinefield.jsp?reportid=<%=reportid%>&formid=<%=formid%>','<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220005")%>','application');//组合字段
     var viewport = new Ext.Viewport({
         layout: 'border',
         items: [contentPanel]
     });

     })

 </script>
  </head> 
  <body>
 <div id="divSum">
<div id="pagemenubar" style="z-index:100;"></div> 
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportsearchfieldAction?action=modify" name="EweaverForm" method="post">
<TABLE>
<input type="hidden" name="rpid" value="<%=reportid%>">
<input type="hidden" name="formid" value="<%=formid%>">
	<colgroup>
	   <col width="5%">
	   <col width="5%">
	</colgroup>
      	<tr class="Header">
      	<TD><%=labelService.getLabelName("40288184119b6f4601119c3cdd77002d")%></TD><!-- 高级搜索 -->
      	<TD><%=labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")%></TD><!-- 快捷搜索-->
         <td><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220006")%></td><!-- 是否必填 -->
        <TD><%=labelService.getLabelName("402881e60b95cc1b010b96212bc80009")%></TD><!-- 字段名称-->
      	<TD><%=labelService.getLabelName("402881e60b95cc1b010b965dc554000c")%></TD><!-- 显示名称-->
        <TD><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a004a")%></TD><!--表单 -->
      	<TD><%=labelService.getLabelName("402881e70b774c35010b774d4c410009")%></TD><!-- 显示顺序-->
      	</tr>
<%
         boolean flagcomfield=false;
		boolean isLight=false;
		String trclassname="";
		Reportsearchfield reportsearchfield=null;
		Formfield formfield=null;
		Reportfield reportfield=null;
		String fieldname="";
		String fieldid="";
		String fieldid2="";
		String showname="";
		String isquestsearch = "";
        String isfillin="";
        String tablename="";
        Integer dsporder = new Integer(0);
		if(list2.size()>0){

				for (int i = 0; i < list2.size(); i++) {
				   reportsearchfield=(Reportsearchfield)list2.get(i);
				   if(reportsearchfield.getDsporder()!=null){
					   dsporder = reportsearchfield.getDsporder();
				   }
				   
				   fieldid=StringHelper.null2String(reportsearchfield.getFormfieldid());
				   isquestsearch = StringHelper.null2String(reportsearchfield.getIsquestsearch());
                  isfillin=StringHelper.null2String(reportsearchfield.getIsfillin());
                   String checked = "";
                    String isfillinchecked="";
                    if(isfillin.equals("1"))
                    {
                        isfillinchecked="checked";
                    }
                     if(isquestsearch.equals("1")){
				   	checked = "checked";
				   }
				   
				   if(fieldid!=""){
                       if(fieldid.equals("40288035249e012493f200077c7d3901")){
                          flagcomfield=true; 
                       }
				      formfield=formfieldService.getFormfieldById(fieldid);
				      if(formfield!=null){
				      fieldname=StringHelper.null2String(formfield.getLabelname());
                      tablename=forminfoService.getForminfoById(formfield.getFormid()).getObjname();    
				      }
				    List reportfieldlist=reportfieldService.getReportfieldListByReportID(reportid);
				    showname="";
				    if(reportfieldlist.size()!=0){
				        for(int j=0;j<reportfieldlist.size();j++){
				           reportfield=(Reportfield)reportfieldlist.get(j);
				           fieldid2=StringHelper.null2String(reportfield.getFormfieldid());
				           if(fieldid.equals(fieldid2)){
				             showname = labelCustomService.getLabelNameByReportfieldForCurrentLanguage(reportfield);
				           }
				    }
				    }
				   }
				  	isLight=!isLight;					
					if(isLight) trclassname="DataLight";
					else trclassname="DataDark";
		%>
		<tr class="<%=trclassname%>">
		      	<TD><input  type='checkbox' name='check_node' value="<%=fieldid%>" checked></TD>
		      	<TD><input  type='checkbox' name='isquestsearch' value='<%=fieldid%>' <%=checked %>></TD>
               <TD><input  type='checkbox' name='isfillin' value='<%=fieldid%>'  <%=isfillinchecked %>></TD>
                  <TD><%=fieldname%></TD>
		      	<TD><%=StringHelper.null2String(showname)%></TD>
                <TD><%=StringHelper.null2String(tablename)%></TD>
		      	<TD width="5%"><input name="dsporder<%=fieldid%>" value="<%=dsporder%>" class="InputStyle2" onKeyPress='checkInt_KeyPress()'></TD>
		      	</TR>
		<%}}
if(list.size()>0){
 
		for (int i = 0; i < list.size(); i++) {
		   formfield=(Formfield)list.get(i);
		   fieldname=StringHelper.null2String(formfield.getLabelname());
           tablename=forminfoService.getForminfoById(formfield.getFormid()).getObjname(); 
		   fieldid=StringHelper.null2String(formfield.getId());
		   List reportfieldlist=reportfieldService.getReportfieldListByReportID(reportid);
		   showname="";
		    if(reportfieldlist.size()!=0){
		        for(int j=0;j<reportfieldlist.size();j++){
		           reportfield=(Reportfield)reportfieldlist.get(j);
		           fieldid2=StringHelper.null2String(reportfield.getFormfieldid());
		           if(fieldid.equals(fieldid2)){
		        	   showname = labelCustomService.getLabelNameByReportfieldForCurrentLanguage(reportfield);
		           }
		    }
		    }
		  	isLight=!isLight;					
			if(isLight) trclassname="DataLight";
			else trclassname="DataDark";
%>
<tr class="<%=trclassname%>">
      	<TD><input  type='checkbox' name='check_node' value='<%=fieldid%>'></TD>
      	<TD><input  type='checkbox' name='isquestsearch' value='<%=fieldid%>'></TD>
          <TD><input  type='checkbox' name='isfillin' value='<%=fieldid%>' ></TD>
          <TD><%=fieldname%></TD>
      	<TD><%=StringHelper.null2String(showname)%></TD>
        <TD><%=StringHelper.null2String(tablename)%></TD>
		<TD width="5%"><input name="dsporder<%=fieldid%>" value="" class="InputStyle2" onKeyPress='checkInt_KeyPress()'></TD>
      	</TR>
<%}}%>
    <tr<%if(flagcomfield){%> style="display:none" <%}%>>
        <TD><input type='checkbox' name='check_node' value='40288035249e012493f200077c7d3901'></TD>
        <TD><input type='checkbox' name='isquestsearch' value='40288035249e012493f200077c7d3901'></TD>
        <TD><input type='checkbox' name='isfillin' value='40288035249e012493f200077c7d3901'></TD>
        <TD><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220005")%></TD><!-- 组合字段 -->
        <TD></TD>
        <TD></TD>
        <TD width="5%"><input name="dsporder40288035249e012493f200077c7d3901" value="" class="InputStyle2"
                              onKeyPress='checkInt_KeyPress()'></TD>
    </TR>


</TABLE>

</form>
</div>
 <script language="javascript"> 
function onSubmit(){
 document.EweaverForm.submit();
}    

</script> 
</body>
</html>
