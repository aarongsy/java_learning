<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*"%>
<script>
setTimeout('window.close();',10000);
</script> 
<%
 //request.setCharacterEncoding("UTF-8");
 String objname=StringHelper.null2String(request.getParameter("o"));
 String tablename = StringHelper.null2String(request.getParameter("tablename"));
 //objname=new String(objname.getBytes("ISO-8859-1"),"utf8");
 
 List list=StringHelper.string2ArrayList(objname,",");
 BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
 %>                
<html>
<head>
<title><%=labelService.getLabelNameByKeyId("402883d934c1e1340134c1e134980000") %></title><!-- 生日提醒 -->
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" style="text-align:center">
<div style="height:100%;width:499;text-align:center">
<table width="300" cellspacing="0" cellpadding="0" align="center" height="100%">
  <tr>
    <td align="left" valign="top" height="247"><img src="<%=request.getContextPath() %>/app/birthday/BirthdayBg_1.jpg"></td>
  </tr>
  <tr> 
    <td align="left" valign="top" background="<%=request.getContextPath() %>/app/birthday/BirthdayBg_2.jpg"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="30"><br>
          </td>
          <td width="220" align="left" valign="top"><font color="#FFFFFF"><br>
          <%=labelService.getLabelNameByKeyId("402883d934c1e6120134c1e6131a0000") %>
            <!-- 添一份快乐,发张贺卡吧! <br>
            任何人都需要真诚的祝福,<br>
            你的亲人、你的友人,你的爱人……<br>
            送出你的心意吧!<br> -->
            <br>
            <br>
            </font></td>
          <td width="80">&nbsp;</td>
          <td align="left" valign="top"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="60" height="18"><font color="#FFFFFF"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550022") %>:</font></td><!-- 生日名单 -->
                <td >&nbsp;</td>
              </tr>
               <tr> 
                <td width="60" height="18">&nbsp;</td>
                <td >&nbsp;</td>
              </tr>
             <%
             if(!StringHelper.isEmpty(tablename)&&!"humres".equals(tablename)){
             for(int i=0;i<list.size();i++){ 
             String ids=list.get(i).toString();           
			 String orgname=ids;
			 String objnames="";			 			
             %>
              <tr>                
                <td width='50' height="18"><font color="#FFFFFF"><%=objnames%></font></td>
                <td width="130"><font color="#FFFFFF"><%=orgname%></font></td>
              </tr>
             <%} }            
             else{            
             for(int i=0;i<list.size();i++){ 
             String ids=list.get(i).toString();
             String sqlorg="select (select objname from orgunit where id=a.orgid) as objname,a.objname as objnames from humres a where id='"+ids+"' and  hrstatus='4028804c16acfbc00116ccba13802935' and isdelete=0";
			 List listorg=baseJdbcDao.getJdbcTemplate().queryForList(sqlorg);
			 String orgname="";
			 String objnames="";
			 if(listorg.size()>0){
			 orgname=((Map)listorg.get(0)).get("objname")==null?"":((Map)listorg.get(0)).get("objname").toString();
			 objnames=((Map)listorg.get(0)).get("objnames")==null?"":((Map)listorg.get(0)).get("objnames").toString();
 			}
             %>
              <tr>                
                <td width='50' height="18"><font color="#FFFFFF"><%=objnames%></font></td>
                <td width="130"><font color="#FFFFFF"><%=orgname%></font></td>
              </tr>
             <%} }%>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</div>
</body>
</html>
