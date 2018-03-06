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
<%@ page import="com.eweaver.interfaces.outter.service.AccountsettingService" %>
<%@ page import="com.eweaver.interfaces.outter.model.Accountsetting" %>
<%@ page import="com.eweaver.interfaces.outter.model.Outtersysdetail" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
String sysid = StringHelper.null2String(request.getParameter("sysid"));
String baseparam1="";//账号参数名
String baseparam2="";//密码参数名
Integer basetype1=0;//是否使用eweaver账号
Integer basetype2=0;//是否使用eweaver密码
OuttersysService outtersysService=(OuttersysService)BaseContext.getBean("outtersysService");
    BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

 String hql="from Outtersys where sysid='"+sysid+"'";
    List list=outtersysService.getOuttersyses(hql);
    Outtersys outtersys = null;
    if(list.isEmpty()) {
    	//outtersys= new Outtersys();
    	out.println(labelService.getLabelNameByKeyId("402883d7353baf7101353baf7378000d"));//无相关集成数据
    	return;
    } else {
    	outtersys=(Outtersys)list.get(0);
    }
    
    
    String id=outtersys.getId();
     baseparam1=outtersys.getUsername();
     baseparam2=outtersys.getPass();
    String iurl=outtersys.getInneradd();
    String ourl=outtersys.getOutteradd();
     basetype1=outtersys.getUsernametype();
    basetype2=outtersys.getPasstype();
    String serverurl="";
 String hql1="from Accountsetting where sysid='"+sysid+"' and userid='"+eweaveruser.getId()+"'";
    AccountsettingService accountsettingService=(AccountsettingService)BaseContext.getBean("accountsettingService");
    List listaccount=accountsettingService.getAccountsettings(hql1);
     Accountsetting accountsetting=new Accountsetting();
    if(listaccount.size()>0){
         accountsetting=(Accountsetting)listaccount.get(0);

    }
   String accountname=accountsetting.getAccountname();
   String accountpass=accountsetting.getAccountpass();
   
   SetitemService setitemService = (SetitemService)BaseContext.getBean("setitemService");
   String isEncrypt = setitemService.getSetitem("a34f4e1ccf2f478b8b306cd5357da13c").getItemvalue();
   if("1".equals(isEncrypt)){
       try{
     	  accountpass = EncryptHelper.decrypt(EncryptHelper.parseHexStr2Byte(accountpass), EncryptHelper.key);
       }catch(Exception e){
     	  e.printStackTrace();
       }
   }
   
   String visittype=accountsetting.getVisittype();
    if(basetype1 != null && basetype1==1){  //使用eweaver账号
        accountname=eweaveruser.getUsername();
    }
    if(basetype2 != null && basetype2==1){  //使用eweaver密码
        HttpSession se=request.getSession();
        accountpass=(String)se.getAttribute("password");
    }
    if("1".equals(visittype)){   //内网
        serverurl=iurl;
    }else{    //外网
       serverurl=ourl;
    }
String str="<html><body>\n" +
            "<form name=Loginform action='"+serverurl+"' method=post target='_blank'>" ;
    int count=0;
 for(Object o:outtersys.getOuttersysdetail()){
     Outtersysdetail outtersysdetail=(Outtersysdetail)o;
     int objtype=outtersysdetail.getObjtype().intValue();
     String paramname=outtersysdetail.getObjname();
     String paramvalue=outtersysdetail.getObjtypevalue();
      if(objtype==1){//固定值
        ;
	  }else if(objtype==2){//用户输入
         String sql="select * from outter_params where sysid='"+sysid+"' and userid='"+eweaveruser.getId()+"' and  paramname='"+paramname+"'";
          List listvalue=baseJdbcDao.getJdbcTemplate().queryForList(sql);
          if(listvalue.size()>0){
           paramvalue=(String)((Map)listvalue.get(0)).get("paramvalue")==null?"":(String)((Map)listvalue.get(0)).get("paramvalue");
          }

	  }
	  str+="<INPUT type='hidden' NAME='"+paramname+"' VALUE='"+paramvalue+"'>";
     
 }
      str+="<INPUT type='hidden' NAME='"+baseparam1+"' VALUE='"+accountname+"'>" +
           "<INPUT type='hidden' NAME='"+baseparam2+"' VALUE='"+accountpass+"'>";

   /********************用户自己添加代码 start******************/
 if(sysid.equals("cs")){
    str+="</form></body></html>" ;
out.print(str);  %>
  <script>
      Loginform.target='_self';
      Loginform.submit();
      window.open('http://localhost:8081/main/main.jsp');
  </script>

<% }else if(sysid.equals("1")){
    str+="</form></body></html>" +
     "<script>Loginform.submit();</script>";
out.print(str);
 }else{
    str+="</form></body></html>" +
     "<script>Loginform.submit();</script>";
out.print(str);
 }
    /********************用户自己添加代码end ******************/

%>