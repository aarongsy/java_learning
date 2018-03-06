<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.base.selectitem.service.*" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Properties" %>
<%@ include file="/base/init.jsp"%>
<%
    pagemenustr =  "addBtn(tb,'确定','S','accept',function(){OnConfirm()});";
    SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
    FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
    SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
    String rule0 = "";
    String rule1 = "";
    String rule2 = "checked";
    String rule3 = "";
    String rule4 = "";
    String rule5 = "";
    String rule6 = "";
    String count0 = "";
    String count1 = "";
    String count2 = "";
    String count3 = "";
    String count4 = "";
      String count5 = "";
    String count6 = "";
    String count7 = "";
    String passmodel0="";
    String passmodel1="";


%>
<html>
<head>
    <style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
     .x-panel-btns-ct {
       padding: 0px;
   }
   .x-panel-btns-ct table {width:0}
 </style>

 <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
 <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
  <script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/datapicker/WdatePicker.js" ></script>
  <script src='/dwr/interface/HumresService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
  
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
<div id="pagemenubar"> </div>
<body>
<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.setitem.servlet.SetitemAction?action=setting" name="EweaverForm" method="post">
    <table>
          <colgroup>
                <col width="30%">
                <col width="">
            </colgroup>
        <tr>
            <td class="FieldName" nowrap >页面风格 </td>
            <td class="FieldValue">
                  <%
                       Setitem setitem1=setitemService.getSetitem("402880311baf53bc011bb048b4a90005");
                        String selectedpage1="";
                          String selectedpage2="";
                       String selectedpage3="";
                       String selectedpage4="";
                       String selectedpage5="";
                        if(setitem1.getItemvalue().equals("default")) {
                            selectedpage1="selected";
                        } else if(setitem1.getItemvalue().equals("gray")){
                            selectedpage2="selected";
                        }else if(setitem1.getItemvalue().equals("purple")) {
                           selectedpage3="selected";
                        }else if(setitem1.getItemvalue().equals("olive")){
                             selectedpage4="selected";
                        }else if(setitem1.getItemvalue().equals("light-orange")){
                             selectedpage5="selected";
                        }
                    %>
                <select style="width:40%;" id="402880311baf53bc011bb048b4a90005" name="402880311baf53bc011bb048b4a90005">
                    <option value="default" <%=selectedpage1%>>浅蓝色风格(默认)</option>
                      <option value="gray" <%=selectedpage2%>>灰色风格</option>
                    <option value="purple" <%=selectedpage3%>>紫色风格</option>
                      <option value="olive" <%=selectedpage4%>>绿色风格</option>
                    <option value="light-orange" <%=selectedpage5%>>橙色风格</option>
                </select>
            </td>
        </tr>
         <%-- <tr>
            <td class="FieldName" nowrap>首页知识地图 </td>
            <td class="FieldValue">
                <%
                    Setitem setitem2=setitemService.getSetitem("402881e80c2f884a010c2fa7b5cb0005");
                %>
               <input type="text" name="402881e80c2f884a010c2fa7b5cb0005" id="402881e80c2f884a010c2fa7b5cb0005" style="width:90%;" value="<%=setitem2.getItemvalue()%>">
            </td>
        </tr>--%>
        <tr>
            <td class="FieldName" nowrap>登录是否使用验证码</td>
            <td class="FieldValue">
                  <%
                       Setitem setitem3=setitemService.getSetitem("402881e40ac0e0b2010ac13ff4ee0003");
                        String selected1no="";
                          String selected1yes="";
                        if(setitem3.getItemvalue().equals("1")) {
                            selected1yes="selected";
                        } else{
                            selected1no="selected";
                        }
                    %>
              <select style="width:40%;" id="402881e40ac0e0b2010ac13ff4ee0003" name="402881e40ac0e0b2010ac13ff4ee0003">
                    <option value="1" <%=selected1yes%>>是</option>
                      <option value="0" <%=selected1no%>>否</option>
                </select>
            </td>
        </tr>

           <tr>
            <td class="FieldName" nowrap>树形报表是否默认列表显示</td>
            <td class="FieldValue">
                  <%
                       Setitem setitemlist=setitemService.getSetitem("4028818411b2334e0185ed352670175");
                        String selectedlist0no="";
                          String selectedlist1yes="";
                        if(setitemlist.getItemvalue().equals("1")) {
                            selectedlist1yes="selected";                                                                                    
                        } else{
                            selectedlist0no="selected";
                        }
                    %>
              <select style="width:40%;" id="4028818411b2334e0185ed352670175" name="4028818411b2334e0185ed352670175">
                    <option value="1" <%=selectedlist1yes%>>是</option>
                      <option value="0" <%=selectedlist0no%>>否</option>
                </select>
            </td>
        </tr>
           <tr>
            <td class="FieldName" nowrap>是否显示下拉列表个人签字意见</td>
            <td class="FieldValue">
                  <%
                       Setitem setitemselect=setitemService.getSetitem("4089487d23f9e66e0123ffe23303253b");
                        String s1no="";
                          String s1yes="";
                        if(setitemselect.getItemvalue().equals("1")) {
                            s1yes="selected";
                        } else{
                            s1no="selected";
                        }
                    %>
              <select style="width:40%;" id="4089487d23f9e66e0123ffe23303253b" name="4089487d23f9e66e0123ffe23303253b">
                    <option value="1" <%=s1yes%>>是</option>
                      <option value="0" <%=s1no%>>否</option>
                </select>
            </td>
        </tr>
        <%-- <tr>
            <td class="FieldName" nowrap> 系统首页显示的链接地址 </td>
            <td class="FieldValue">
                <%
                    Setitem setitem4=setitemService.getSetitem("4028818411f8978d0111f8d4f3700060");
                
                %>
               <input type="text" name="4028818411f8978d0111f8d4f3700060" id="4028818411f8978d0111f8d4f3700060" style="width:90%;" value="<%=setitem4.getItemvalue()%>">
            </td>
        </tr>--%>
        <tr>
            <td class="FieldName" nowrap> 是否图形化设计流程</td>
            <td class="FieldValue">
                 <%
                       Setitem setitem5=setitemService.getSetitem("402880311e723ad0011e72782a0d0005");
                        String selected5no="";
                          String selected5yes="";
                        if(setitem5.getItemvalue().equals("1")) {
                            selected5yes="selected";
                        } else{
                            selected5no="selected";
                        }
                    %>
          <select style="width:40%;" id="402880311e723ad0011e72782a0d0005" name="402880311e723ad0011e72782a0d0005">
                    <option value="1" <%=selected5yes%>>是</option>
                      <option value="0" <%=selected5no%>>否</option>
                </select>
            </td>
        </tr>
           <tr>
            <td class="FieldName" nowrap> 是否用新的出口条件设计</td>
            <td class="FieldValue">
                 <%
                       Setitem setitemsql=setitemService.getSetitem("402880369e583ad001besxe82a0d0005");
                        String selectedsqlno="";
                          String selectedsqlyes="";
                        if(setitemsql.getItemvalue().equals("1")) {
                            selectedsqlyes="selected";
                        } else{
                            selectedsqlno="selected";
                        }
                    %>
          <select style="width:40%;" id="402880369e583ad001besxe82a0d0005" name="402880369e583ad001besxe82a0d0005">
                    <option value="1" <%=selectedsqlyes%>>是</option>
                      <option value="0" <%=selectedsqlno%>>否</option>
                </select>
            </td>
        </tr>
        
         <tr>
            <td class="FieldName" nowrap> 是否启用内网IP登陆限制</td>
            <td class="FieldValue">
                 <%
                       Setitem setitemIP=setitemService.getSetitem("4028836134c18c690134c18c6b680000");
                          String selectedIPno="";
                          String selectedIPyes="";
                        if(setitemIP.getItemvalue().equals("1")) {
                        	selectedIPyes="selected";
                        } else{
                        	selectedIPno="selected";
                        }
                    %>
          <select style="width:40%;" id="4028836134c18c690134c18c6b680000" name="4028836134c18c690134c18c6b680000" >
                    <option value="1" <%=selectedIPyes%>>是</option>
                      <option value="0" <%=selectedIPno%>>否</option>
                </select>

            </td>
        </tr>
        
           <tr>
            <td class="FieldName" nowrap> 是否使用动态密码</td>
            <td class="FieldValue">
                 <%
                       Setitem setitempass=setitemService.getSetitem("402888534deft8d001besxe952edgy15");
                        String selectedpassno="";
                          String selectedpassyes="";
                        if(setitempass.getItemvalue().equals("1")) {
                            selectedpassyes="selected";
                        } else{
                            selectedpassno="selected";
                        }
                    %>
          <select style="width:40%;" id="402888534deft8d001besxe952edgy15" name="402888534deft8d001besxe952edgy15" onchange="passChange(this)">
                    <option value="1" <%=selectedpassyes%>>是</option>
                      <option value="0" <%=selectedpassno%>>否</option>
                </select>

            </td>
        </tr>
        
       
       
         <%
             boolean flag=false;
             if(setitempass.getItemvalue().equals("1")){
                 flag=true;
                 String sql="select * from dynamicpassrule where setitemid='402888534deft8d001besxe952edgy15'";
                List listp= baseJdbcDao.getJdbcTemplate().queryForList(sql);
                 String passrule;
                 String passcount;
                 String ispassmodel;

                 if(listp.size()>0){
                      passrule = ((Map) listp.get(0)).get("passrule") == null ? "" : ((Map)listp.get(0)).get("passrule").toString();
                     int prule=Integer.valueOf(passrule).intValue();
                     rule2="";
                     switch (prule) {
                         case 0:
                             rule0 = "checked";
                             break;
                         case 1:
                             rule1 = "checked";
                             break;
                         case 2:
                             rule2 = "checked";
                             break;
                         case 3:
                             rule3 = "checked";
                             break;
                         case 4:
                             rule4 = "checked";
                             break;
                          case 5:
                             rule5 = "checked";
                             break;
                         case 6:
                             rule6 = "checked";
                             break;
                         default:
                              rule2 = "checked";
                             break;

                     }
                     passcount = ((Map) listp.get(0)).get("passcount") == null ? "" : ((Map)listp.get(0)).get("passcount").toString();
                      int pcount=Integer.valueOf(passcount).intValue();
                     switch (pcount) {
                         case 4:
                             count0 = "selected";
                             break;
                         case 6:
                             count1 = "selected";
                             break;
                         case 7:
                             count2 = "selected";
                             break;
                         case 8:
                             count3 = "selected";
                             break;
                         case 9:
                             count4 = "selected";
                             break;
                         case 10:
                             count5 = "selected";
                             break;
                         case 11:
                             count6 = "selected";
                             break;
                         case 12:
                             count7 = "selected";
                             break;
                     }

                     ispassmodel = ((Map) listp.get(0)).get("ispassmodel") == null ? "" : ((Map)listp.get(0)).get("ispassmodel").toString();
                     if(ispassmodel.equals("0")){
                         passmodel0="selected";
                     }else{
                         passmodel1="selected";

                     }
                 }

             }

         %>
           <tr id="pass1" <%if(!flag){%>style="display:none"<%}%>>
            <td class="FieldName" nowrap> </td>
            <td class="FieldValue">
                  <table>
                      <tr>
                          <td>规则：<%--<input type="radio" name="passrule" value="4"  <%=rule4%>>大写--%> <input type="radio" name="passrule" value="5" <%=rule5%>>小写<input type="radio" name="passrule" value="6" <%=rule6%>>数字<%--<input type="radio" name="passrule" value="0"  <%=rule0%>>大写小写组合 <input type="radio" name="passrule" value="1" <%=rule1%>>大写数字组合--%><input type="radio" name="passrule" value="2" <%=rule2%>>小写数字组合<input type="radio" name="passrule" value="3" <%=rule3%> >大写小写数字组合</td>
                      </tr>
                  </table>
            </td>
        </tr>
          <tr id="pass2"<%if(!flag){%>style="display:none"<%}%>>
            <td class="FieldName" nowrap> </td>
            <td class="FieldValue">
                  <table>
                      <tr>
                          <td>位数：<select id="passcount" name="passcount">
                              <option value="6" <%=count1%>>6</option>
                              <option value="7" <%=count2%>>7</option>
                              <option value="8" <%=count3%>>8</option>
                              <option value="9" <%=count4%>>9</option>
                              <option value="10" <%=count5%>>10</option>
                              <option value="11" <%=count6%>>11</option>
                              <option value="12" <%=count7%>>12</option>
                          </select>&nbsp;&nbsp;&nbsp; 是否明码输入：
                              <select id="ispassmodel" name="ispassmodel">
                                  <option value="0" <%=passmodel0%>>否</option>
                                  <option value="1" <%=passmodel1%>>是</option>
                               </select>
                          </td>
                       
                      </tr>
                  </table>
            </td>
        </tr>
        <!-- begin add by cjl 首次登录是否修改密码  -->
          <tr>
            <td class="FieldName" nowrap> 是否首次登录修改密码</td>
            <td class="FieldValue">
                 <%
                       Setitem setitemupdatepass=setitemService.getSetitem("297e930d347445a101347445ca4e0000");
                        String selectedupdatepassno="";
                          String selectedupdatepassyes="";
                        if(setitemupdatepass.getItemvalue().equals("1")) {
                        	selectedupdatepassyes="selected";
                        } else{
                        	selectedupdatepassno="selected";
                        }
                    %>
          <select style="width:40%;" id="297e930d347445a101347445ca4e0000" name="297e930d347445a101347445ca4e0000" onchange="updatepassChange(this)">
                    <option value="1" <%=selectedupdatepassyes%>>是</option>
                      <option value="0" <%=selectedupdatepassno%>>否</option>
                </select>

            </td>
        </tr> 
         <%
             boolean updateflag=false;
         String updaterule0 = "";
         String updaterule1 = "";
         String updaterule2 = "checked";
         String updaterule3 = "";
         String updaterule4 = "";
         String updaterule5 = "";
         String updaterule6 = "";
         String updatecount0 = "";
         String updatecount1 = "";
         String updatecount2 = "";
         String updatecount3 = "";
         String updatecount4 = "";
         String updatecount5 = "";
         String updatecount6 = "";
         String updatecount7 = "";
         String updatepassmodel0="";
         String updatepassmodel1="";
             if(setitemupdatepass.getItemvalue().equals("1")){
            	 updateflag=true;
                 String sql="select * from dynamicpassrule where setitemid='297e930d347445a101347445ca4e0000'";
                 List listp= baseJdbcDao.getJdbcTemplate().queryForList(sql);
                 String passrule;
                 String passcount;
                 String ispassmodel;

                 if(listp.size()>0){
                     passrule = ((Map) listp.get(0)).get("passrule") == null ? "" : ((Map)listp.get(0)).get("passrule").toString();
                     int prule=Integer.valueOf(passrule).intValue();
                     updaterule2="";
                     switch (prule) {
                         case 0:
                        	 updaterule0 = "checked";
                             break;
                         case 1:
                        	 updaterule1 = "checked";
                             break;
                         case 2:
                        	 updaterule2 = "checked";
                             break;
                         case 3:
                        	 updaterule3 = "checked";
                             break;
                         case 4:
                        	 updaterule4 = "checked";
                             break;
                          case 5:
                        	  updaterule5 = "checked";
                             break;
                         case 6:
                        	 updaterule6 = "checked";
                             break;
                         default:
                        	 updaterule2 = "checked";
                             break;

                     }
                     passcount = ((Map) listp.get(0)).get("passcount") == null ? "" : ((Map)listp.get(0)).get("passcount").toString();
                      int pcount=Integer.valueOf(passcount).intValue();
                     switch (pcount) {
                         case 4:
                        	 updatecount0 = "selected";
                             break;
                         case 6:
                        	 updatecount1 = "selected";
                             break;
                         case 7:
                        	 updatecount2 = "selected";
                             break;
                         case 8:
                        	 updatecount3 = "selected";
                             break;
                         case 9:
                        	 updatecount4 = "selected";
                             break;
                         case 10:
                        	 updatecount5 = "selected";
                             break;
                         case 11:
                        	 updatecount6 = "selected";
                             break;
                         case 12:
                        	 updatecount7 = "selected";
                             break;
                     }

                     ispassmodel = ((Map) listp.get(0)).get("ispassmodel") == null ? "" : ((Map)listp.get(0)).get("ispassmodel").toString();
                     if(ispassmodel.equals("0")){
                    	 updatepassmodel0="selected";
                     }else{
                    	 updatepassmodel1="selected";

                     }
                 }

             }

         %>
           <tr id="updatepass1" <%if(!updateflag){%>style="display:none"<%}%>>
            <td class="FieldName" nowrap> </td>
            <td class="FieldValue">
                  <table>
                      <tr>
                          <td>规则：<%--<input type="radio" name="passrule" value="4"  <%=rule4%>>大写--%> 
                          <input type="radio" name="updatepassrule" value="5" <%=updaterule5%>>小写
                          <input type="radio" name="updatepassrule" value="6" <%=updaterule6%>>数字
                          <%--<input type="radio" name="passrule" value="0"  <%=rule0%>>大写小写组合 
                          <input type="radio" name="passrule" value="1" <%=rule1%>>大写数字组合--%>
                          <input type="radio" name="updatepassrule" value="2" <%=updaterule2%>>小写数字组合
                          <input type="radio" name="updatepassrule" value="3" <%=updaterule3%> >大写小写数字组合
                           &nbsp;&nbsp;
                                                                  位数：<select id="updatepasscount" name="updatepasscount">
                              <option value="6" <%=updatecount1%>>6</option>
                              <option value="7" <%=updatecount2%>>7</option>
                              <option value="8" <%=updatecount3%>>8</option>
                              <option value="9" <%=updatecount4%>>9</option>
                              <option value="10" <%=updatecount5%>>10</option>
                              <option value="11" <%=updatecount6%>>11</option>
                              <option value="12" <%=updatecount7%>>12</option> 
                              </select>
                          </td>
                      </tr>
                  </table>
            </td>
        </tr>
        <!-- 
          <tr id="updatepass2"<%if(!updateflag){%>style="display:none"<%}%>>
            <td class="FieldName" nowrap> </td>
            <td class="FieldValue">
                  <table>
                      <tr>
                          <td>位数：<select id="updatepasscount" name="updatepasscount">
                              <option value="6" <%=updatecount1%>>6</option>
                              <option value="7" <%=updatecount2%>>7</option>
                              <option value="8" <%=updatecount3%>>8</option>
                              <option value="9" <%=updatecount4%>>9</option>
                              <option value="10" <%=updatecount5%>>10</option>
                              <option value="11" <%=updatecount6%>>11</option>
                              <option value="12" <%=updatecount7%>>12</option>
                          </select>&nbsp;&nbsp;&nbsp; 是否明码输入：
                              <select id="updateispassmodel" name="updateispassmodel">
                                  <option value="0" <%=updatepassmodel0%>>否</option>
                                  <option value="1" <%=updatepassmodel1%>>是</option>
                               </select>
                          </td>
                       
                      </tr>
                  </table>
            </td>
        </tr>
         -->
        <!-- -end  -->
        <!-- begin 密码有效期 -->
         <tr>
            <td class="FieldName" nowrap>设置密码有效期</td>
            <td class="FieldValue">
              <table width="100%" border="0">
                      <tr height="20">
                          <td width="10">
                 <%
                 String sql1="SELECT * FROM PASSEXPIRYDATE WHERE ID='402881e4349f1a4101349f1a51790002'";
                 List listc= baseJdbcDao.getJdbcTemplate().queryForList(sql1);
                 String custombegindate="";
                 String customdate="";
                 String custselect="";
                 String hiddendate = "";
                 if(listc.size()>0){
                	 custombegindate = ((Map) listc.get(0)).get("custombegindate") == null ? "" : ((Map)listc.get(0)).get("custombegindate").toString();
                	 customdate = ((Map) listc.get(0)).get("customdate") == null ? "" : ((Map)listc.get(0)).get("customdate").toString();
                	 custselect = ((Map) listc.get(0)).get("custselect") == null ? "" : ((Map)listc.get(0)).get("custselect").toString();
                	 hiddendate = ((Map) listc.get(0)).get("hiddendate") == null ? "" : ((Map)listc.get(0)).get("hiddendate").toString();
                 }
                List selectitemlist =  selectitemService.getSelectitemList("ff808081349e68f001349e7789160002",null);
                 %>
               <select  id="ff808081349eb5d201349eb5e2890002" name="ff808081349eb5d201349eb5e2890002" onchange="setpassdate(this)" >
                      <% for(int i =0;i<selectitemlist.size();i++){
                    	  Selectitem stitem = (Selectitem)selectitemlist.get(i);
                    	  Setitem setpassdate=setitemService.getSetitem("ff808081349eb5d201349eb5e2890002");
                    	  if(stitem.getId().equals(setpassdate.getItemvalue())){
                      %>
                    	  <option value="<%=stitem.getId() %>" selected="selected"><%=stitem.getObjname() %></option>
                     <%
                    	  }else{
                    		  %>
                    		  <option value="<%=stitem.getId() %>" ><%=stitem.getObjname() %></option>
                    	<%}
                     }%>
                </select>
               </td>
               <td width="160">
                <div id="customdatediv" style="display: block;width:160">&nbsp;&nbsp;&nbsp;&nbsp;
                规定日期：<input type="text" id="custombegindate" name ="custombegindate"  onclick="WdatePicker()" value="<%=custombegindate %>" size="8"
                onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','规定日期')"  >
                <input type="hidden" id="hiddendate" name="hiddendate" value="<%=custombegindate %>"/>
               </div>
               </td>
               <td >
               <div id="custom" style="display: block;">
               <script>
                function myKeyDown() {
			        var k = window.event.keyCode;
			        if ((k == 46) || (k == 8) || (k == 189) || (k == 109) || (k == 110) || (k > 48 && k <= 57) || (k >= 96 && k <= 105) || (k >= 37 && k <= 40))
			        { }
			        else if (k == 13) {
			            window.event.keyCode = 9;
			        }
			        else {
			            window.event.returnValue = false;
			        }
			    }
               </script>
              规定周期：<input type="text" value="<%=customdate %>" style="ime-mode:disabled" id = "customdate" name="customdate" onkeydown="myKeyDown()" size="4"/> 
               <%
                List slist =  selectitemService.getSelectitemList("ff808081349e68f001349edbdb420008",null);
                %>
               <select id="custselect" name="custselect" >
                      <% for(int i =0;i<slist.size();i++){
                    	  Selectitem stitem = (Selectitem)slist.get(i);
                    	  if(stitem.getId().equals(custselect)){
                      %>
                    	  <option value="<%=stitem.getId() %>" selected="selected"><%=stitem.getObjname() %></option>
                     <%}else{%>
                    		  <option value="<%=stitem.getId() %>" ><%=stitem.getObjname() %></option>
                    <%}}%>
                </select>
               </div>
               </td>
               </tr>
               </table>
            </td>
        </tr> 
        <!-- end 密码有效期 -->
        <!-----------------------------------------------------------------
        //hj 2011.11.7    add -->
        <tr>
            <td class="FieldName" nowrap> 登录名是否区分大小写</td>
            <td class="FieldValue">
                 <%
                       Setitem setitemisdx=setitemService.getSetitem("402880e71284a7ed011284fcf3de0012");
                        String selecteddxno="";
                          String selecteddxyes="";
                        if(setitemisdx.getItemvalue().equals("1")) {
                            selecteddxyes="selected";
                        } else{
                            selecteddxno="selected";
                        }
                    %>
          <select style="width:40%;" id="402880e71284a7ed011284fcf3de0012" name="402880e71284a7ed011284fcf3de0012">
                    <option value="1" <%=selecteddxyes%>>是</option>
                      <option value="0" <%=selecteddxno%>>否</option>
                </select>

            </td>
        </tr>
        <!----------------------------------------------------------------->
           <tr>
            <td class="FieldName" nowrap> 是否允许userkey登录</td>
            <td class="FieldValue">
                 <%
                       Setitem setitemUserKey=setitemService.getSetitem("402888534deft8d001besxe952edgy16");
                        String selectedUserKeyNo="";
                          String selectedUserKeyYes="";
                        if(setitemUserKey.getItemvalue().equals("1")) {
                            selectedUserKeyYes="selected";
                        } else{
                            selectedUserKeyNo="selected";
                        }
                    %>
          <select style="width:40%;" id="402888534deft8d001besxe952edgy16" name="402888534deft8d001besxe952edgy16">
                    <option value="1" <%=selectedUserKeyYes%>>是</option>
                      <option value="0" <%=selectedUserKeyNo%>>否</option>
                </select>
            </td>
        </tr>
        <%
           Properties mapping = new Properties();
           InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("eweaver.properties");
           try {
               mapping.load(inputStream);
           } catch (Exception e) {
               //log.error(e);
           }
           Enumeration keys = mapping.keys();
		   String attr = "";
		   while (keys.hasMoreElements()) {
              String col = (String) keys.nextElement();
              if (col.indexOf("weaverim") > -1)
            	  attr = mapping.getProperty(col);
		   }
		   if ("true".equals(attr)) {
         %>
        <tr>
            <td class="FieldName" nowrap> 是否启用IM</td>
            <td class="FieldValue">
                 <%
                       Setitem setitemIM=setitemService.getSetitem("40288347363855d101363855d2030293");
                        String selectedIMNo="";
                          String selectedIMYes="";
                        if(setitemIM.getItemvalue().equals("1")) {
                            selectedIMYes="selected";
                        } else{
                            selectedIMNo="selected";
                        }
                    %>
          <select style="width:40%;" id="40288347363855d101363855d2030293" name="40288347363855d101363855d2030293">
                    <option value="1" <%=selectedIMYes%>>是</option>
                      <option value="0" <%=selectedIMNo%>>否</option>
                </select>
            </td>
        </tr>
        <%} %>
           <tr>
            <td class="FieldName" nowrap> 是否允许知会人转发</td>
            <td class="FieldValue">
                 <%
                       Setitem setitemForward=setitemService.getSetitem("402888534deft8d001besxe952edgy17");
                        String selectedForwardNo="";
                          String selectedForwardYes="";
                        if(setitemForward.getItemvalue().equals("1")) {
                            selectedForwardYes="selected";
                        } else{
                            selectedForwardNo="selected";
                        }
                    %>
          <select style="width:40%;" id="402888534deft8d001besxe952edgy17" name="402888534deft8d001besxe952edgy17">
                    <option value="1" <%=selectedForwardYes%>>是</option>
                      <option value="0" <%=selectedForwardNo%>>否</option>
                </select>
            </td>
        </tr>
           <tr>
            <td class="FieldName" nowrap> 是否允许历史操作者转发</td>
            <td class="FieldValue">
                 <%
                       Setitem setitemHForward=setitemService.getSetitem("402888534deft8d001besxe952edgy18");
                        String selectedHForwardNo="";
                          String selectedHForwardYes="";
                        if(setitemHForward.getItemvalue().equals("1")) {
                            selectedHForwardYes="selected";
                        } else{
                            selectedHForwardNo="selected";
                        }
                    %>
          <select style="width:40%;" id="402888534deft8d001besxe952edgy18" name="402888534deft8d001besxe952edgy18">
                    <option value="1" <%=selectedHForwardYes%>>是</option>
                      <option value="0" <%=selectedHForwardNo%>>否</option>
                </select>
            </td>
        </tr>
           <tr>
            <td class="FieldName" nowrap> 是否允许知会人知会整个流程</td>
            <td class="FieldValue">
                 <%
                       Setitem knowallworkflowsetitem=setitemService.getSetitem("402888534deft8d001besxe952edgy19");
                        String knowallworkflowNo="";
                          String knowallworkflowYes="";
                        if(knowallworkflowsetitem.getItemvalue().equals("1")) {
                            knowallworkflowYes="selected";
                        } else{
                            knowallworkflowNo="selected";
                        }
                    %>
          <select style="width:40%;" id="402888534deft8d001besxe952edgy19" name="402888534deft8d001besxe952edgy19">
                    <option value="1" <%=knowallworkflowYes%>>是</option>
                      <option value="0" <%=knowallworkflowNo%>>否</option>
                </select>
            </td>
        </tr>
            <tr>
            <td class="FieldName" nowrap> 是否允许从邮件中直接查看流程</td>
            <td class="FieldValue">
                 <%
                       Setitem viewworkflow=setitemService.getSetitem("40288856895ft8d001bece2952edgy17");
                        String viewworkflowNo="";
                          String viewworkflowYes="";
                        if(viewworkflow.getItemvalue().equals("1")) {
                            viewworkflowYes="selected";
                        } else{
                            viewworkflowNo="selected";
                        }
                    %>
          <select style="width:40%;" id="40288856895ft8d001bece2952edgy17" name="40288856895ft8d001bece2952edgy17">
                    <option value="1" <%=viewworkflowYes%>>是</option>
                      <option value="0" <%=viewworkflowNo%>>否</option>
                </select>
            </td>
        </tr>
             <tr>
            <td class="FieldName" nowrap> 流程保存时是否检查必填</td>
            <td class="FieldValue">
                 <%
                       Setitem workflowsave=setitemService.getSetitem("40288856895ft8d001beceezxse22952");
                        String workflowsaveNo="";
                          String workflowsaveYes="";
                        if(workflowsave.getItemvalue().equals("1")) {
                            workflowsaveYes="selected";
                        } else{
                            workflowsaveNo="selected";
                        }
                    %>
          <select style="width:40%;" id="40288856895ft8d001beceezxse22952" name="40288856895ft8d001beceezxse22952">
                    <option value="1" <%=workflowsaveYes%>>是</option>
                      <option value="0" <%=workflowsaveNo%>>否</option>
                </select>
            </td>
        </tr>
        <tr>
        	 <td class="FieldName" nowrap> 流程是否显示编号</td>
        	 <td class="FieldValue">
        	 	 <%
	        	 	 Setitem isdisplayworkflowno=setitemService.getSetitem("402883c9369ff2be01369ff2c8a5026f");
	                 String workflownoYes="";
	                   String workflownoNo="";
	                 if(isdisplayworkflowno.getItemvalue().equals("1")) {
	                     workflownoYes="selected";
	                 } else{
	                     workflownoNo="selected";
	                 }	
        	 	 %>
          <select style="width:40%;" id="402883c9369ff2be01369ff2c8a5026f" name="402883c9369ff2be01369ff2c8a5026f">
                    <option value="1" <%=workflownoYes%>>是</option>
                      <option value="0" <%=workflownoNo%>>否</option>
                </select>
        	 </td>
        </tr>
       <tr>
            <td class="FieldName" nowrap>门户文档元素是否显示总记录数</td>
            <td class="FieldValue">
                 <%
                       Setitem attendanceItem=setitemService.getSetitem("82bb8269e5054f449bfd82a68cf85287");
                        String No="";
                        String Yes="";
                        if(attendanceItem.getItemvalue().equals("1")) {
                            Yes="selected";
                        } else{
                            No="selected";
                        }
                    %>
          <select style="width:40%;" id="bdcbccfdc8eb446a906081a2049b70c2" name="82bb8269e5054f449bfd82a68cf85287">
                    <option value="1" <%=Yes%>>是</option>
                      <option value="0" <%=No%>>否</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap>部门是否显示全名称</td>
            <td class="FieldValue">
                 <%
                       Setitem orgallNameItem=setitemService.getSetitem("11171015F8BC4599A7A68388C93440FD");
                        String orgallNameNo="";
                        String orgallNameYes="";
                        if(orgallNameItem.getItemvalue().equals("1")) {
                            orgallNameYes="selected";
                        } else{
                            orgallNameNo="selected";
                        }
                    %>
          <select style="width:40%;" id="11171015F8BC4599A7A68388C93440FD" name="11171015F8BC4599A7A68388C93440FD">
                    <option value="1" <%=orgallNameYes%>>是</option>
                      <option value="0" <%=orgallNameNo%>>否</option>
                </select>
            </td>
        </tr>
         <tr>
            <td class="FieldName" nowrap> 人力资源通用创建布局</td>
            <td class="FieldValue">
                <%
                    Setitem setitem6=setitemService.getSetitem("402880e71284a7ed011284fa24910007");

                %>
                 <select style="width:40%;" id="402880e71284a7ed011284fa24910007" name="402880e71284a7ed011284fa24910007">
                       <%
                           String sql="from Formlayout where formid='402881e80c33c761010c33c8594e0005'";
                     List list=formlayoutService.findFormlayout(sql);
                           for(int i=0;i<list.size();i++){
                               Formlayout formlayout1=(Formlayout)list.get(i);
                               String selected1="";
                               if(formlayout1.getId().equals(setitem6.getItemvalue())) {
                                       selected1="selected";
                               }
                               %>
                            <option value="<%=formlayout1.getId()%>" <%=selected1%> ><%=formlayout1.getLayoutname()%></option>

                          <% }
                     %>
                </select>

            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap> 人力资源本身查看布局 </td>
            <td class="FieldValue">
                 <%
                    Setitem setitem7=setitemService.getSetitem("402880e71284a7ed011284fae5ad0010");

                %>
                 <select style="width:40%;" id="402880e71284a7ed011284fae5ad0010" name="402880e71284a7ed011284fae5ad0010">
                       <%
                           String sql2="from Formlayout where formid='402881e80c33c761010c33c8594e0005'";
                     List list2=formlayoutService.findFormlayout(sql2);
                           for(int i=0;i<list2.size();i++){
                               Formlayout formlayout2=(Formlayout)list2.get(i);
                               String selected1="";
                               if(formlayout2.getId().equals(setitem7.getItemvalue())) {
                                       selected1="selected";
                               }
                               %>
                            <option value="<%=formlayout2.getId()%>" <%=selected1%> ><%=formlayout2.getLayoutname()%></option>

                          <% }
                     %>
                </select>
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap> 人力资源经理查看布局</td>
            <td class="FieldValue">
                 <%
                    Setitem setitem8=setitemService.getSetitem("402880e71284a7ed011284fae5ad0011");

                %>
                 <select style="width:40%;" id="402880e71284a7ed011284fae5ad0011" name="402880e71284a7ed011284fae5ad0011">
                       <%
                           String sql3="from Formlayout where formid='402881e80c33c761010c33c8594e0005'";
                     List list3=formlayoutService.findFormlayout(sql3);
                           for(int i=0;i<list3.size();i++){
                               Formlayout formlayout3=(Formlayout)list3.get(i);
                               String selected1="";
                               if(formlayout3.getId().equals(setitem8.getItemvalue())) {
                                       selected1="selected";
                               }
                               %>
                            <option value="<%=formlayout3.getId()%>" <%=selected1%> ><%=formlayout3.getLayoutname()%></option>

                          <% }
                     %>
                </select>
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap> 人力资源通用查看布局 </td>
            <td class="FieldValue">
                     <%
                    Setitem setitem9=setitemService.getSetitem("402880e71284a7ed011284fae5ad0009");

                %>
                 <select style="width:40%;" id="402880e71284a7ed011284fae5ad0009" name="402880e71284a7ed011284fae5ad0009">
                       <%
                           String sql4="from Formlayout where formid='402881e80c33c761010c33c8594e0005'";
                     List list4=formlayoutService.findFormlayout(sql4);
                           for(int i=0;i<list4.size();i++){
                               Formlayout formlayout4=(Formlayout)list4.get(i);
                               String selected1="";
                               if(formlayout4.getId().equals(setitem9.getItemvalue())) {
                                       selected1="selected";
                               }
                               %>
                            <option value="<%=formlayout4.getId()%>" <%=selected1%> ><%=formlayout4.getLayoutname()%></option>

                          <% }
                     %>
                </select>
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap> 人力资源管理员查看布局 </td>
            <td class="FieldValue">
                         <%
                    Setitem setitem10=setitemService.getSetitem("402880e71284a7ed011284fb84a6000b");

                %>
                  <select style="width:40%;" id="402880e71284a7ed011284fb84a6000b" name="402880e71284a7ed011284fb84a6000b">
                       <%
                           String sql5="from Formlayout where formid='402881e80c33c761010c33c8594e0005'";
                     List list5=formlayoutService.findFormlayout(sql5);
                           for(int i=0;i<list5.size();i++){
                               Formlayout formlayout5=(Formlayout)list5.get(i);
                               String selected1="";
                               if(formlayout5.getId().equals(setitem10.getItemvalue())) {
                                       selected1="selected";
                               }
                               %>
                            <option value="<%=formlayout5.getId()%>" <%=selected1%> ><%=formlayout5.getLayoutname()%></option>

                          <% }
                     %>
                </select>
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap> 人力资源本身编辑布局</td>
            <td class="FieldValue">
                     <%
                    Setitem setitem11=setitemService.getSetitem("402880e71284a7ed011284fc1cb3000e");

                %>
                 <select style="width:40%;" id="402880e71284a7ed011284fc1cb3000e" name="402880e71284a7ed011284fc1cb3000e">
                       <%
                           String sql6="from Formlayout where formid='402881e80c33c761010c33c8594e0005'";
                     List list6=formlayoutService.findFormlayout(sql6);
                           for(int i=0;i<list6.size();i++){
                               Formlayout formlayout6=(Formlayout)list6.get(i);
                               String selected1="";
                               if(formlayout6.getId().equals(setitem11.getItemvalue())) {
                                       selected1="selected";
                               }
                               %>
                            <option value="<%=formlayout6.getId()%>" <%=selected1%> ><%=formlayout6.getLayoutname()%></option>

                          <% }
                     %>
                </select>
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap> 人力资源管理员编辑布局</td>
            <td class="FieldValue">
                    <%
                    Setitem setitem12=setitemService.getSetitem("402880e71284a7ed011284fc78fe000f");

                %>
                <select style="width:40%;" id="402880e71284a7ed011284fc78fe000f" name="402880e71284a7ed011284fc78fe000f">
                       <%
                           String sql7="from Formlayout where formid='402881e80c33c761010c33c8594e0005'";
                     List list7=formlayoutService.findFormlayout(sql7);
                           for(int i=0;i<list7.size();i++){
                               Formlayout formlayout7=(Formlayout)list7.get(i);
                               String selected1="";
                               if(formlayout7.getId().equals(setitem12.getItemvalue())) {
                                       selected1="selected";
                               }
                               %>
                            <option value="<%=formlayout7.getId()%>" <%=selected1%> ><%=formlayout7.getLayoutname()%></option>

                          <% }
                     %>
                </select>
            </td>
        </tr>
         <tr>
            <td class="FieldName" nowrap> 人力资源关联对象布局 </td>
            <td class="FieldValue">
                     <%
                    Setitem setitem13=setitemService.getSetitem("402880e71284a7ed011284fcf3de0011");

                %>
                 <select style="width:40%;" id="402880e71284a7ed011284fcf3de0011" name="402880e71284a7ed011284fcf3de0011">
                       <%
                           String sql8="from Formlayout where formid='402881e80c33c761010c33c8594e0005'";
                     List list8=formlayoutService.findFormlayout(sql8);
                           for(int i=0;i<list8.size();i++){
                               Formlayout formlayout8=(Formlayout)list8.get(i);
                               String selected1="";
                               if(formlayout8.getId().equals(setitem13.getItemvalue())) {
                                       selected1="selected";
                               }
                               %>
                            <option value="<%=formlayout8.getId()%>" <%=selected1%> ><%=formlayout8.getLayoutname()%></option>

                          <% }
                     %>
                </select>
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap> 人力资源经理编辑布局</td>
            <td class="FieldValue">
                   <%
                    Setitem setitem14=setitemService.getSetitem("402880ca16a408970116a8677d89005e");

                %>
                 <select style="width:40%;" id="402880ca16a408970116a8677d89005e" name="402880ca16a408970116a8677d89005e">
                       <%
                           String sql9="from Formlayout where formid='402881e80c33c761010c33c8594e0005'";
                     List list9=formlayoutService.findFormlayout(sql9);
                           for(int i=0;i<list9.size();i++){
                               Formlayout formlayout9=(Formlayout)list9.get(i);
                               String selected1="";
                               if(formlayout9.getId().equals(setitem14.getItemvalue())) {
                                       selected1="selected";
                               }
                               %>
                            <option value="<%=formlayout9.getId()%>" <%=selected1%> ><%=formlayout9.getLayoutname()%></option>

                          <% }
                     %>
                </select>
            </td>
        </tr>
        <tr>
        	 <td class="FieldName" nowrap> 组织与角色合并</td>
        	 <td class="FieldValue">
        	 	 <%
	        	 	 Setitem ismergemenu=setitemService.getSetitem("2a6561cd79684e689d6ff1a6e89d8616");
        	 	 %>
          		<select style="width:40%;" id="2a6561cd79684e689d6ff1a6e89d8616" name="2a6561cd79684e689d6ff1a6e89d8616">
                    <option value="1" <%=((ismergemenu.getItemvalue()!=null&&ismergemenu.getItemvalue().equals("1"))?"selected":"")%>>是</option>
                    <option value="0" <%=((ismergemenu.getItemvalue()==null||ismergemenu.getItemvalue().equals("0"))?"selected":"")%>>否</option>
                </select>
        	 </td>
        </tr>
        <tr>
        	 <td class="FieldName" nowrap> 只显示一次流转记录</td>
        	 <td class="FieldValue">
        	 	 <%
	        	 	 Setitem isonlynoelog=setitemService.getSetitem("dd4851f9f7c84bcaa83f3f1273bdf869");
        	 	 %>
          		<select style="width:40%;" id="dd4851f9f7c84bcaa83f3f1273bdf869" name="dd4851f9f7c84bcaa83f3f1273bdf869">
  					<option value="1" <%=((isonlynoelog.getItemvalue()!=null&&isonlynoelog.getItemvalue().equals("1"))?"selected":"")%>>是</option>
                    <option value="0" <%=((isonlynoelog.getItemvalue()==null||isonlynoelog.getItemvalue().equals("0"))?"selected":"")%>>否</option>
                </select>
        	 </td>
        </tr>
        <%--<tr>
            <td class="FieldName" nowrap> 快捷菜单id </td>
            <td class="FieldValue">
                  <%
                    Setitem setitem15=setitemService.getSetitem("402881df0f9e8df5010f9e9b5f060043");

                %>
          <input type="text" name="402881df0f9e8df5010f9e9b5f060043" id="402881df0f9e8df5010f9e9b5f060043" style="width:90%;" value="<%=setitem15.getItemvalue()%>">
            </td>
        </tr>--%>
        <tr>
            <td class="FieldName" nowrap> 新建流程隐藏的流程类型</td>
            <td class="FieldValue">
                  <%
                    Setitem setitem16=setitemService.getSetitem("40288183120ddca401120de9f4dc0006");
                %>
          <input type="text" name="40288183120ddca401120de9f4dc0006" id="40288183120ddca401120de9f4dc0006" style="width:200;" value="<%=StringHelper.null2String(setitem16.getItemvalue())%>">
          (** 多个时用英文字符的逗号分隔)  
            </td>
        </tr>
         <tr>
            <td class="FieldName" nowrap> 查看日志记录时间间隔 </td>
            <td class="FieldValue">
                  <%
                    Setitem setitem17=setitemService.getSetitem("402881e50fab280d010fac26316e003c");
                %>
          <input type="text" name="402881e50fab280d010fac26316e003c" id="402881e50fab280d010fac26316e003c" style="width:200;" value="<%=setitem17.getItemvalue()%>">
          (** 在设置的时间间隔内同一个用户多次查看一个对象只记录一次日志)
            </td>
        </tr>
        <tr>
        	<%
        	setitem1=setitemService.getSetitem("fad398ab07e24a5f92cdff30d6d96499");
			%>
            <td class="FieldName" nowrap ><%=setitem1.getItemname()%></td>
            <td class="FieldValue">
            <%
            	List list1=new ArrayList();
				if(!StringHelper.isEmpty(setitem1.getItemvalue())){
					String[] arIds=setitem1.getItemvalue().split(",");
					list1=Arrays.asList(arIds);
				}
					Map<String,String> modMap=new HashMap<String,String>();
					modMap.put("SysroleDao", "角色");
					modMap.put("SyspermsDao", "权限");
					modMap.put("NodeinfoDao", "工作流节点");
					modMap.put("ForminfoDao", "表单");
					modMap.put("WorkflowinfoDao", "工作流");
					modMap.put("ReportdefDao", "报表");
					modMap.put("CategoryDao", "分类");
					Iterator<String> ite=modMap.keySet().iterator();
					String key=null;
					while(ite.hasNext()){
						key=ite.next();
						out.println("<label for=\"chk"+key+"\"><input id=\"chk"+key+"\" type=\"checkbox\" name=\"fad398ab07e24a5f92cdff30d6d96499\" "+(list1.contains(key)?"checked":"")+" value=\""+key+"\"/>"+modMap.get(key)+"</label>&nbsp;&nbsp;");
					}
			%>
            </td>
        </tr>
        <tr>
        	<%
        		Setitem setitem18 = setitemService.getSetitem("b50cd5ba74b64893a893fe660aol987h");
			%>
            <td class="FieldName" nowrap >表单布局编辑时是否开启语法高亮</td>
            <td class="FieldValue">
           		<select style="width:40%;" id="b50cd5ba74b64893a893fe660aol987h" name="b50cd5ba74b64893a893fe660aol987h">
                    <option value="0" <%if(setitem18.getItemvalue().equals("0")){ %> selected="selected" <%} %>>关闭</option>
					<option value="1" <%if(setitem18.getItemvalue().equals("1")){ %> selected="selected" <%} %>>开启</option>
                </select>
            </td>
        </tr>
        <tr>
        	<%
        		Setitem setitem21 = setitemService.getSetitem("402883c33c8f80bf013c8f80c4480293");
			%>
            <td class="FieldName" nowrap >弹出提醒停留间隔</td>
            <td class="FieldValue">
           		<input type="text" name="402883c33c8f80bf013c8f80c4480293" id="402883c33c8f80bf013c8f80c4480293" style="width:200;" value="<%=setitem21.getItemvalue()%>">
                (** 单位为秒，默认时间3s，设置为0则不隐藏)
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap>是否启用新代办</td>
            <td class="FieldValue">
                  <%
                       Setitem setitem19=setitemService.getSetitem("4028833039d773910139d7739b370000");
                       String selected19no="";
                       String selected19yes="";
                        if(setitem19.getItemvalue().equals("1")) {
                        	selected19yes="selected";
                        } else{
                        	selected19no="selected";
                        }
                    %>
              <select style="width:40%;" id="4028833039d773910139d7739b370000" name="4028833039d773910139d7739b370000" onchange="changeButtonStyle(this);">
                    <option value="1" <%=selected19yes%>>是</option>
                    <option value="0" <%=selected19no%>>否</option>
              </select>
              <input type="button" value="初始化" id="initButton" onclick="initData();">
            </td>
        </tr>
       <%-- <tr>
            <td class="FieldName" nowrap> 项目进度视图显示文档id </td>
            <td class="FieldValue">
                   <%
                    Setitem setitem18=setitemService.getSetitem("297e0f290fc1e1aa010fc2008f8300f8");
                %>
          <input type="text" name="297e0f290fc1e1aa010fc2008f8300f8" id="297e0f290fc1e1aa010fc2008f8300f8" style="width:90%;" value="<%=setitem18.getItemvalue()%>">
            </td>
        </tr>--%>
        <tr>
        	<%
        		Setitem setitem20 = setitemService.getSetitem("8EA5529F1E014B58A2D2E9E41477273E");
			%>
            <td class="FieldName" nowrap >初始化微博中的人员上级</td>
            <td class="FieldValue">
           		<select style="width:40%;" id="8EA5529F1E014B58A2D2E9E41477273E" name="8EA5529F1E014B58A2D2E9E41477273E">
                    <option value="0" <%if(setitem20.getItemvalue().equals("0")){ %> selected="selected" <%} %>>否</option>
					<option value="1" <%if(setitem20.getItemvalue().equals("1")){ %> selected="selected" <%} %>>是</option>
                </select>
                <%if(setitem20.getItemvalue().equals("1")){ %>
                <span id="initButtonSpan"><button type="button" onclick="initManagers(this)">初始化所有员工上级</button></span>
                <%} %>
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript">
       $(document).ready(function(){
		var val=$("#4028833039d773910139d7739b370000").val();
		if(val=="1"){
			$("#initButton").show();
		}else{
			$("#initButton").hide();
		}
	})
    function initManagers(obj){
    	obj.disabled=true;
    	obj.value="处理中...";
    	obj.title="请检查系统控制台是否完成";
    	DWREngine.setAsync(false);
		HumresService.initAllHumresManagers();
		DWREngine.setAsync(true);
    }
    function OnConfirm(){
    	if (!formCheck()) return;
        document.EweaverForm.submit();
    }
    function formCheck()
    {        
      var mm=/^\d+$/;
      if(!mm.test(document.getElementById("402883c33c8f80bf013c8f80c4480293").value))
      {
         alert("弹出提醒时间间隔请输入0或正整数");
         return false;
      }
      return true;
    }
    function passChange(obj) {
        var pass1 = document.all('pass1');
        var pass2 = document.all('pass2');
        if (obj.value == 1) {
            pass1.style.display = 'block';
            pass2.style.display = 'block';
        } else {
            pass1.style.display = 'none';
            pass2.style.display = 'none';
        }

    }
    //首次登陆更改密码 add by cjl 2012-12-25
    function updatepassChange(obj) {
        var updatepass1 = document.all('updatepass1');
        //var updatepass2 = document.all('updatepass2');
        if (obj.value == 1) {
            updatepass1.style.display = 'block';
          //  updatepass2.style.display = 'block';
        } else {
            updatepass1.style.display = 'none';
           // updatepass2.style.display = 'none';
        }

    }
    /**
     * 设置密码过期
     * @param {Object} obj
     */
    function setpassdate(obj){
    	 var spanobj1 = document.all('custom');
    	 var spanobj2 = document.all('customdatediv');
    	if(obj.value == "ff808081349e68f001349e8521300007"){
    		spanobj1.style.display = 'none';
    		spanobj2.style.display = 'none';
    	}else{
    		spanobj2.style.display = 'block';
    		if(obj.value == "ff808081349e68f001349e7944840006"){
    			spanobj1.style.display = 'block';
    		}else{
    			spanobj1.style.display = 'none';
    		}
    	}
    }
     /**
      * 初始化密码过期
      */
    function onloadselect(){
    	var selectitem  =  document.all('ff808081349eb5d201349eb5e2890002');
    	var spanobj1 = document.all('custom');
    	 var spanobj2 = document.all('customdatediv');
    	if(selectitem.value=="ff808081349e68f001349e8521300007"){
    		spanobj1.style.display = 'none';
    		spanobj2.style.display = 'none';
    	}else{
    		spanobj2.style.display = 'block';
    		if(selectitem.value == "ff808081349e68f001349e7944840006"){
    			spanobj1.style.display = 'block';
    		}else{
    			spanobj1.style.display = 'none';
    		}
    	}
    } 
      onloadselect();
      function initData(){
		var myMask = new Ext.LoadMask(Ext.getBody(), {
		    msg: '正在处理，请稍后...',
		    removeMask: true //完成后移除
		});
		myMask.show();
		
		Ext.Ajax.request({
	        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.TodoitemsAction',
	        params:{},
	        success: function(request) {
	        	Ext.Msg.alert('',request.responseText);
	            myMask.hide();
	        },
	        failure: function (request) {
		        myMask.hide();
		        Ext.Msg.alert('错误', request.responseText);
		    }
	    });
	}
    
	function changeButtonStyle(obj){
		var value=$(obj).val();
		if(value=="1"){
			$("#initButton").show();
		}else{
			$("#initButton").hide();
		}
	}
</script>
</body>
</html>