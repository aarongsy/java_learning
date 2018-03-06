<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.workflow.request.model.Requestbase" %>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService" %>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo" %>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2008-9-5
  Time: 14:06:07
  To change this template use File | Settings | File Templates.
--%>
<html>
  <head><title><%=labelService.getLabelNameByKeyId("40288035249e13cc01249e5819e70091") %><!-- 人员权限检索 --></title>

<script  type='text/javascript' src='<%= request.getContextPath()%>/js/workflow.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/WorkflowService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%= request.getContextPath()%>/dwr/util.js'></script>

<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript">
<%
    String requestid = StringHelper.null2String(request.getParameter("requestid"));
    RequestbaseService requestbaseService = (RequestbaseService)BaseContext.getBean("requestbaseService");
    NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");
    WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    Requestbase requestbase = requestbaseService.getRequestbaseById(requestid);
    Workflowinfo workflowinfo = workflowinfoService.get(requestbase.getWorkflowid());
    List<Nodeinfo> list = nodeinfoService.getNodelistByworkflowid(requestbase.getWorkflowid());

    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009")+"','E','accept',function(){sAlert()});";//提交
%>
    Ext.onReady(function(){
        var cp = new Ext.state.CookieProvider({
       expires: new Date(new Date().getTime()+(1000*60*60*24*30))
   });

            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>

      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [{region:'center',autoScroll:true,contentEl:'divSum'}]
	});
});
    function sAlert(){
        if(document.getElementById("requestid").value==''){
            alert("<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf26000a") %>");//请选择需要处理的人员！
        }else{
//            document.EweaverForm.action="getPerm.jsp?userid="+document.getElementById("requestid").value;
            document.EweaverForm.submit();
        }
    }
</script>

  <style type="text/css">
    .x-toolbar table {width:0}
      a { color:blue; cursor:pointer; }
    #pagemenubar table {width:0}
    /*TD{*/
        /*width:16%;*/
    /*}*/
     .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
  </style>
  <script type="text/javascript">


  </script>
  </head>
  <body>
<div id="divSum">
 <div id="pagemenubar"></div>
  <%--<form action="/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?action=download" enctype="multipart/form-data" method="post">--%>
  <%--</form>--%>
<form action="getPerm.jsp" name="EweaverForm" id="EweaverForm" method="post">
	    <input type="hidden" name="workflowids" id="workflowids">
        <input type="hidden" name="meddlednode" id="meddlednode">
        <table style="border:0" style="float:left;position:absolute;">
				<colgroup>
					<col width="10%">
					<col width="50%">
					<col width="40%">
				</colgroup>

            <TR><TD class=Spacing colspan=3></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD class=Spacing colspan=3 align="center"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf26000b") %><!-- 请在下面选择流程的处理节点 --></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
            <%
                Nodeinfo nodeinfo = new Nodeinfo();
                for(int i=0;i<list.size();i++){
                    nodeinfo = list.get(i);
            %>
			<tr>
				<td>
					<input type="radio" value="<%=nodeinfo.getId()%>" id="rejectednode1" name="rejectednode1" onclick="javascript:document.getElementById('meddlednode').value='<%=nodeinfo.getId()%>';"><%=StringHelper.null2String(nodeinfo.getObjname())%>
				</td>
			</tr>
            <%
                }
            %>
        <tr>
            <td align="center" colspan="3">
            &nbsp;
            </td>
        </tr>
            <TR><TD class=Spacing colspan=3></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD class=Spacing colspan=3 align="center"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf26000c") %><!-- 请在下面选择该流程被干预后的节点操作者 --></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
            <TR>
            <TD><%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76b1476b0034") %><!-- 操作者 -->：</TD>
            <TD colspan=2>
            <select id="opttype" name="opttype" onchange="selectChanged()">
                <option value="0"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf26000d") %><!-- 所选节点操作者 --></option>
                <option value="1"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf26000e") %><!-- 手动指定操作者 --></option>
            </select>
            </TD>
            </TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
            <TR id="humrestr" style="display:none">
                <TD><%=labelService.getLabelNameByKeyId("40288035248fd7a801248feef7930266") %><!-- 请选择 -->：</TD>
                <TD colspan=2>
                <button type="button" class="Browser" id="humresidBrowser" name="humresidBrowser" onclick="onShowMutiResource('humresidSpan','humresid')"></button>
                <input type="hidden" id="humresid" name="humresid" value="<%=currentuser.getId()%>"/>
                <span id = "humresidSpan"><%=currentuser.getObjname()%></span>
                </TD>
            </TR>
            <TR id="opttr" style="display:none">
                <TD><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf27000f") %><!-- 操作关系 -->：</TD>
                <TD colspan=2>
                    <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf27000f") %><!-- 操作关系 -->：
                    <select id="optRelations" name="optRelations">
                        <option value="2"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270010") %><!-- 非会签 --></option>
                        <option value="3"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270011") %><!-- 会签 --></option>
                        <option value="5"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270012") %><!-- 依次逐个会签 --></option>
                    </select>
                </TD>
            </TR>
            <TR id="layouttr" style="display:none">
                <TD><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270013") %><!-- 布局选择 -->：<br><br></TD>
                <TD colspan=2>=l<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71e26c980030") %><!-- 编辑布局 -->：
                <select id="layoutid" name="layoutid">
                    <option value=""><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270014") %><!-- 未选择 --></option>
                    <%
                        List<Map> layoutList = baseJdbcDao.executeSqlForList("select id,layoutname from formlayout where formid='"+workflowinfo.getFormid()+"' and typeid=2");
                        for(Map map : layoutList){
                    %>
                    <option value="<%=StringHelper.null2String(map.get("id"))%>"><%=StringHelper.null2String(map.get("layoutname"))%></option>
                    <%
                        }
                    %>
                </select>
                <%=labelService.getLabelNameByKeyId("40288035247ef73101247f0017b90005") %><!-- 查看布局 -->：
                <select id="layoutid1" name="layoutid1">
                    <option value=""><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270014") %><!-- 未选择 --></option>
                    <%
                        layoutList = baseJdbcDao.executeSqlForList("select id,layoutname from formlayout where formid='"+workflowinfo.getFormid()+"' and typeid=1");
                        for(Map map : layoutList){
                    %>
                    <option value="<%=StringHelper.null2String(map.get("id"))%>"><%=StringHelper.null2String(map.get("layoutname"))%></option>
                    <%
                        }
                    %>
                </select>
                <br><br></TD>
            </TR>
	    </table>
        </form>
 </div>
</body>
  <script type="text/javascript">
      function selectChanged(){
          var opttype = document.getElementById("opttype");
          var humrestr = document.getElementById("humrestr");
          var opttr = document.getElementById("opttr");
          var layouttr = document.getElementById("layouttr");
          if(opttype.value=="0"){
              humrestr.style.display="none";
              opttr.style.display="none";
              layouttr.style.display="none";
          }else{
              humrestr.style.display="block";
              opttr.style.display="block";
              layouttr.style.display="block";
          }
      }
      function sAlert(){
          if(document.getElementById('meddlednode').value==""){
              alert("<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270015") %>");//您还未指定节点！
          }else{
              var opttype = document.getElementById("opttype");
              var humresid = document.getElementById("humresid"); 
              var optRelations = "";
              var layoutid = "";
              var layoutid1 = "";
              var humres = "";
              if(opttype.value=="1"){
                 //  alert(humresid.innerHTML);
                  if(humresid.value==""){
                      alert("<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270016") %>");//您还未选择操作者！
                      return;
                  }
                  humres = humresid.value;
                  optRelations = document.getElementById("optRelations").value;
                  layoutid = document.getElementById("layoutid").value;
                  layoutid1 = document.getElementById("layoutid1").value;
              }
              WorkflowService.modifyWorkflowMeddle('<%=requestid%>',document.getElementById('meddlednode').value,humres,optRelations,layoutid,layoutid1,rollbackData);
          }
      }
      function rollbackData(data){
          if(data!=""){
              if(data=="nobody"){
                  alert("<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270017") %>");//对不起，您选择的节点找不到相应的操作者！请手动选择特定的操作者来处理！
              }else{
                  document.location.href="/workflow/request/close.jsp?requestname="+data+"&mode=ismeddle";
              }
          }else{
              alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003e") %>");//操作失败！
          }
      }
      function onShowMutiResource(tdname,inputname){
	var id;
    try{
    id=openDialog("/base/popupmain.jsp?url=/humres/base/humresbrowserm.jsp?sqlwhere=hrstatus%3D'4028804c16acfbc00116ccba13802935'&humresidsin="+document.all(inputname).value);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(tdname).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		document.all(tdname).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
 }
  </script>

</html>