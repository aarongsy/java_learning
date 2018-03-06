<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.interfaces.outter.service.OuttersysService" %>
<%@ page import="com.eweaver.interfaces.outter.model.Outtersys" %>
<%@ page import="com.eweaver.interfaces.outter.model.Outtersysdetail" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
    String sysid=StringHelper.null2String(request.getParameter("sysid"));
    String accountname=StringHelper.null2String(request.getParameter("accountname"));
    String accountpass=StringHelper.null2String(request.getParameter("accountpass"));
    OuttersysService outtersysService=(OuttersysService)BaseContext.getBean("outtersysService");
    Outtersys outtersys=new Outtersys();
    String sysidd="";
    String sysidspan="";
    if(!StringHelper.isEmpty(sysid)){
        String sql="from Outtersys where sysid='"+sysid+"'";
            List list=(List)outtersysService.getOuttersyses(sql);
            outtersys=(Outtersys)list.get(0);
        sysidd=outtersys.getSysid();
        sysidspan=outtersys.getObjname();
    }
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";

%>
<html>
  <head>
   <script src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
  <Style>
 	UL    { margin-left:22pt; margin-top:0em; margin-bottom: 0 }
   	UL LI {list-style-image: url('<%=request.getContextPath()%>/images/book.gif'); margin-bottom: 4}
</Style>
      <style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
      .x-panel-btns-ct {
        padding: 0px;
    }
    .x-panel-btns-ct table {width:0}
  </style>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
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
<script language="javascript">
function onSubmit(){
   	checkfields="accountname,accountpass,sysid";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){

           //alert(document.EweaverForm.action);
           document.EweaverForm.submit();
   	}
}
</script>
  </head>
  <body>
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.interfaces.outter.servlet.OuttersysAction?action=createsetting" name="EweaverForm" method="post">
<table>
    <colgroup>
        <col width="50%">
        <col width="50%">
    </colgroup>
    <tr>
        <td valign=top>
            <table class=noborder>
                <colgroup>
                    <col width="20%">
                    <col width="80%">
                </colgroup>
                <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780006")%><!-- 账号 -->
                    </td>
                    <td class="FieldValue">
                        <input type="text" class="InputStyle2" style="width:95%" name="accountname" id="accountname" value="<%=accountname%>" onchange="checkInput('accountname','accountnamespan')"/>
                        <span name="accountnamespan" id="accountnamespan">
                        	<img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                        </span>
                    </td>
                </tr>

                <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bccd7f1bd0042")%><!-- 密码 -->
                    </td>
                    <td class="FieldValue">
                        <input type="password" class="InputStyle2" style="width:95%" name="accountpass" value="<%=accountpass%>" onchange="checkInput('accountpass','accountpassspan')"/>
                        <span name="accountpassspan" id="accountpassspan">
                        	<img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                        </span>
                    </td>
                </tr>
                <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780007")%><!-- 集成登录名称 -->
                    </td>
                    <td class="FieldValue">

                        <button  type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/interfaces/outter/outtersysbrowser.jsp','sysid','sysidspan','1');"></button>
                        <input type="hidden"   name="sysid" value="<%=sysidd%>"/>
                        <span id = "sysidspan"><%=sysidspan%><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
                    </td>
                </tr>
                <%
                 for(Object o:outtersys.getOuttersysdetail()){
                     Outtersysdetail outtersysdetail=(Outtersysdetail)o;
                     if(outtersysdetail.getObjtype()==2) {
                %>
                <tr>
                   <td class="FieldName" nowrap>
                        <%=outtersysdetail.getLabelname()%>
                    </td>
                    <td class="FieldValue">
                        <input type="text" class="InputStyle2" style="width:95%" name="<%=outtersysdetail.getObjname()%>" value=""/>
                        <img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                    </td>
                </tr>
                <%}}%>
                <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780008")%><!-- 访问类型 -->
                    </td>
                    <td class="FieldValue">
                        <select name="visittype" id="visittype">
                            <option value="1"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780009")%><!-- 内网访问 --></option>
                            <option value="2"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7378000a")%><!-- 外网访问 --></option>
                          </select>
                    </td>
                </tr>

            </table>
            <br>
        </td>
    </tr>
</table>
    </form>
<script type="text/javascript">
   function getBrowser(viewurl,inputname,inputspan,isneed){
       var accountname=document.all('accountname').value;
       var accountpass=document.all('accountpass').value;
    var id;
    try{
    id=openDialog('/base/popupmain.jsp?url='+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
        //window.location="accountsettingcreate.jsp?sysid="+id[0]+"&accountname="+accountname+"&accountpass="+accountpass;
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
</script>
  </body>
</html>
