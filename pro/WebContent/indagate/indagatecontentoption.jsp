<%@ page import="com.eweaver.indagate.service.IndagatecontentService" %>
<%@ page import="com.eweaver.indagate.model.Indagatecontent" %>
<%@ page import="com.eweaver.indagate.model.Indagateoption" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%
 pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    IndagatecontentService indagatecontentService = (IndagatecontentService) BaseContext.getBean("indagatecontentService");    
    String contentid=StringHelper.null2String(request.getParameter("contentid"));
    Indagatecontent indagatecontent=new Indagatecontent();
    if(!StringHelper.isEmpty(contentid)){
      indagatecontent=indagatecontentService.getIndagatecontent(contentid);
    }
%>
  <head>

   <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script type="text/javascript">
            Ext.onReady(function(){
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
  <div id="pagemenubar" style="z-index:100;"></div>
	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.indagate.servlet.IndagateAction?action=createoption" name="EweaverForm" method="post">
        <input type="hidden" id="contentid" name="contentid" value="<%=contentid%>">
        <input type="hidden" id="minoption" name="minoption" value="<%=indagatecontent.getMinoption()%>">
        <input type="hidden" id="maxoption" name="maxoption" value="<%=indagatecontent.getMaxoption()%>">
    <table width="98%" border="0" align="center" cellpadding="5" cellspacing="1" bgcolor="#5C99DC">
       <tr bgcolor="#FFFFFF">
         <td class="Info_Title" width="18%" align="center">调查主题: </td>
         <td class="Info_Title" width="82%">
           <input name="objsubject" type="text" size="90" maxlength="100" value="<%=StringHelper.null2String(indagatecontent.getObjsubject())%>">
         </td>
       </tr>
        <%
        int count=indagatecontent.getOptioncount();
          List list=  new ArrayList(indagatecontent.getIndagateoption());
            for(int i=0;i<count;i++){
                 if(list.size()>0){
                     for(int j=0;j<list.size();j++){
                         Indagateoption indagateoption=(Indagateoption)list.get(j);
                         if(indagateoption.getObjname().equals("objname"+i)){
        %>
     <tr bgcolor="#FFFFFF">
         <input type="hidden" name="id<%=i%>" value="<%=StringHelper.null2String(indagateoption.getId())%>">
         <td class="Info_Title" align="center" width="18%">选项<%=i%></td>
          <td class="Info_Title" width="82%"><input type="text" value="<%=StringHelper.null2String(indagateoption.getObjvalue())%>" name="objname<%=i%>">顺序:<input type="text" name="dsorder<%=i%>" value="<%=StringHelper.null2String(indagateoption.getDsorder())%>"> </td>

     </tr>
        <%}}}else{%>
           <tr bgcolor="#FFFFFF">
         <td class="Info_Title" align="center" width="18%">选项<%=i%></td>
          <td class="Info_Title" width="82%"><input type="text" name="objname<%=i%>">顺序:<input type="text" name="dsorder<%=i%>" value=""> </td>
     </tr>
        <%}}%>
     </table>
     </form>
     <br> <br><br>

</form>
<script language="javascript">
    function onSubmit(){
        document.EweaverForm.submit();
    }
    
    function closeWin(){
    	alert("提交成功！");
        parent.dlg0.hide();
        parent.dlg0.getComponent('dlgpanel').setSrc('about:blank');
        parent.contentstore.load({params:{start:0, limit:20}});
    }
     Ext.onReady(function(){
    	 <%
    	 String isok = StringHelper.null2String(request.getParameter("isok"));
    	 if("1".equals(isok)){%>
    	 closeWin();
    	 <%}%>
     });
</script>
  </body>
</html>
