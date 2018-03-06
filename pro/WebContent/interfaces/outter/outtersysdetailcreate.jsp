<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.base.security.service.logic.CardCombinationService" %>
<%@ page import="com.eweaver.base.security.model.Cardcombination" %>
<%@ page import="com.eweaver.base.security.model.Cardcombinationdetail" %>
<%@ page import="com.eweaver.interfaces.outter.model.Outtersys" %>
<%@ page import="com.eweaver.interfaces.outter.service.OuttersysService" %>
<%@ page import="com.eweaver.interfaces.outter.model.Outtersysdetail" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
 String sysid=StringHelper.null2String(request.getParameter("sysid"));
 String id=StringHelper.null2String(request.getParameter("id"));
    OuttersysService outtersysService=(OuttersysService)BaseContext.getBean("outtersysService");
    String objname="";
    String labelname="";
    String objtype="";
    String objtypevalue="";
    String description="";
    if(!StringHelper.isEmpty(id)){
        String sql="from Outtersys where sysid='"+sysid+"'";
        List list=outtersysService.getOuttersyses(sql);
        Outtersys outtersys=(Outtersys)list.get(0);
        for(Object o:outtersys.getOuttersysdetail()){
            Outtersysdetail outtersysdetail=(Outtersysdetail)o;
            if(outtersysdetail.getId().equals(id)){
              objname=outtersysdetail.getObjname();
                labelname=outtersysdetail.getLabelname();
                objtype=outtersysdetail.getObjtype().toString();
                objtypevalue=outtersysdetail.getObjtypevalue();
            }
        }
    }

%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";

%>
<html>
  <head>
   <script src="<%= request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
   <script src="<%= request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%= request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <style type="text/css">
     #pagemenubar table {width:0}
</style>
    <script type="text/javascript">
      Ext.onReady(function() {
          Ext.QuickTips.init();
      <%if(!pagemenustr.equals("")){%>
          var tb = new Ext.Toolbar();
          tb.render('pagemenubar');
          <%=pagemenustr%>
      <%}%>
      });
  </script>
  </head>
  <body>
<div id="pagemenubar"></div>
<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.interfaces.outter.servlet.OuttersysAction?action=createDetail" name="EweaverForm" method="post">
 <input type="hidden" name="sysid" value="<%=sysid%>"/>
    <input type="hidden" name="id" value="<%=id%>">
		       <table class=noborder>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tr>
					<td class="FieldName" nowrap>
					    <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790018")%><!-- 参数名 -->
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%" name="objname" id="objname" value="<%=StringHelper.null2String(objname)%>" />
						<img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
					</td>
				</tr>

                 <tr>
                      <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790019")%><!-- 标签 -->
	   </td>
	   <td class="FieldValue">
           <input type="text" class="InputStyle2" style="width:95%" name="labelname" id="labelname" value="<%=StringHelper.null2String(labelname)%>" />
						<img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
	   </td>
	 </tr>
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026")%><!-- 类型 -->
	   </td>
	   <td class="FieldValue">
           <select id="objtype" name="objtype" onchange="objtypechange(this)">
               <%
                    String sel1="";
                   String sel2="";
                   String sel3="";
                   String sel4="";
                if("4".equals(objtype)){
                    sel4="selected";
                } else if("3".equals(objtype)){
                    sel3="selected";
                }else if("2".equals(objtype)){
                     sel2="selected";
                }else{
                    sel1="selected";
                }
               %>
               <option value="1" <%=sel1%>><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379001a")%><!-- 固定值 --></option>
               <option value="2" <%=sel2%>><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790015")%><!-- 用户录入 --></option>
           </select>
	   </td>
	 </tr>

	 <tr id="objtypevaluetr" style="display:block">
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379001b")%><!-- 参数值 -->
	   </td>
	   <td class="FieldValue">
           <input type="text" class="InputStyle2" style="width:95%" name="objtypevalue" id="objtypevalue" value="<%=StringHelper.null2String(objtypevalue)%>" />
		</td>
	 </tr>

</table>
    </form>
<script type="text/javascript">
    function onSubmit(){
           checkfields="";
           checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
           if(checkForm(EweaverForm,checkfields,checkmessage)){
               document.EweaverForm.submit();
           }
    }

    function onReturn(){
        document.location.href="<%=request.getContextPath()%>/interfaces/outter/outtersysmodify.jsp?sysid=<%=sysid%>";

    }
    function objtypechange(obj){
        var objtypevaluetr=document.all('objtypevaluetr');
        if(obj.value==1){
            objtypevaluetr.style.display='block';
        }else{
            objtypevaluetr.style.display='none';
        }
    }
</script>
  </body>
</html>
