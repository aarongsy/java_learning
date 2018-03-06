<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ include file="/base/init.jsp"%>
<%
    pagemenustr =  "addBtn(tb,'确定','S','accept',function(){OnConfirm()});";
    SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
    SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
    List selectitemlist = selectitemService.getSelectitemList("402883b530490dcb013049956f330037",null);
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
<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.setitem.servlet.SetitemAction?action=infobell" name="EweaverForm" method="post">
    <table>
          <colgroup>
                <col width="20%">
                <col width="">
            </colgroup>
        <tr>
            <td class="FieldName" nowrap >是否使用即时通讯 </td>
            <td class="FieldValue">
                <select style="width:40%;" name="4028819d0e52bb04010e5342dd5a0048" id="4028819d0e52bb04010e5342dd5a0048">
                    <%
                       Setitem setitem1=setitemService.getSetitem("4028819d0e52bb04010e5342dd5a0048");
                        String selected1no="";
                          String selected1yes="";
                        if(setitem1.getItemvalue().equals("1")) {
                            selected1yes="selected";
                        } else{
                            selected1no="selected";
                        }
                    %>
                    <option value="0" <%=selected1no%>>否</option>
                    <option value="1" <%=selected1yes%>>是</option>
                </select>
            </td>
        </tr>
        <tr>
			<td class="FieldName" nowrap>即时通讯类型</td>
			<td  class="FieldValue">
                 <select style="width:40%;"  class="inputstyle"  name="0f6163a0d13c49b6aba3c9f6c9fb3e37" id="0f6163a0d13c49b6aba3c9f6c9fb3e37">
	                   <%
	                   Setitem setitem10=setitemService.getSetitem("0f6163a0d13c49b6aba3c9f6c9fb3e37");
	                   %>
                       <option value=""></option>
                       <%for(int i=0;i<selectitemlist.size();i++){
                       Selectitem selectitem=(Selectitem)selectitemlist.get(i);
                       %>
					   <option value="<%=selectitem.getId()%>" <%if(selectitem.getId().equals(setitem10.getItemvalue())){%> selected<%}%>>
						<%=selectitem.getObjname()%>
					   </option>
					   <%}%>
                 </select>
			</td>
		</tr>
        <% Setitem setitemDomainName = setitemService.getSetitem("86043639f1484116a3d0cd5718d41ce7");%>
        <tr>
            <td class="FieldName" nowrap><%=setitemDomainName.getItemname() %></td>
            <td class="FieldValue">
               <input type="text" name="86043639f1484116a3d0cd5718d41ce7" id="86043639f1484116a3d0cd5718d41ce7" style="width:90%;" value="<%=setitemDomainName.getItemvalue()%>">
            </td>
        </tr>
          <tr>
            <td class="FieldName" nowrap>即时通讯服务器地址 </td>
            <td class="FieldValue">
                <%
                    Setitem setitem2=setitemService.getSetitem("402881a10e5a107c010e5a5e41540039");
                %>
               <input type="text" name="402881a10e5a107c010e5a5e41540039" id="402881a10e5a107c010e5a5e41540039" style="width:90%;" value="<%=setitem2.getItemvalue()%>">
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap>即时通讯服务器端口 </td>
            <td class="FieldValue">
                  <%
                    Setitem setitem3=setitemService.getSetitem("402881a10e5a107c010e5a5ec0d5003b");
                %>
               <input type="text" name="402881a10e5a107c010e5a5ec0d5003b" id="402881a10e5a107c010e5a5ec0d5003b" style="width:90%;" value="<%=setitem3.getItemvalue()%>">
            </td>
        </tr>
         <tr>
            <td class="FieldName" nowrap> 是否使用手机短消息 </td>
            <td class="FieldValue">
                <%
                       Setitem setitem4=setitemService.getSetitem("402881a10e5e787f010e5f1eabeb0011");
                        String selected4no="";
                          String selected4yes="";
                        if(setitem4.getItemvalue().equals("1")) {
                            selected4yes="selected";
                        } else{
                            selected4no="selected";
                        }
                    %>
                <select style="width:40%;" name="402881a10e5e787f010e5f1eabeb0011" id="402881a10e5e787f010e5f1eabeb0011">
                   <option value="0" <%=selected4no%>>否</option>
                    <option value="1" <%=selected4yes%>>是</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap> 是否使用邮件 </td>
            <td class="FieldValue">
                <%
                       Setitem setitem5=setitemService.getSetitem("402881a10e5e787f010e5f1f4a4e0013");
                        String selected5no="";
                          String selected5yes="";
                        if(setitem5.getItemvalue().equals("1")) {
                            selected5yes="selected";
                        } else{
                            selected5no="selected";
                        }
                    %>
                <select style="width:40%;" name="402881a10e5e787f010e5f1f4a4e0013" id="402881a10e5e787f010e5f1f4a4e0013">
                    <option value="0" <%=selected5no%>>否</option>
                    <option value="1" <%=selected5yes%>>是</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap> 邮件服务器地址  </td>
            <td class="FieldValue">
                <%
                 Setitem setitem6=setitemService.getSetitem("402881aa0ec16e29010ec1737ce20004");
                %>
                <input type="text" name="402881aa0ec16e29010ec1737ce20004" id="402881aa0ec16e29010ec1737ce20004" style="width:90%;" value="<%=setitem6.getItemvalue()%>">
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap> 邮件服务器端口号   </td>
            <td class="FieldValue">
                  <%
                 Setitem setitem7=setitemService.getSetitem("402881aa0ec16e29010ec174315d0007");
                %>
                <input type="text" name="402881aa0ec16e29010ec174315d0007" id="402881aa0ec16e29010ec174315d0007" style="width:90%;" value="<%=setitem7.getItemvalue()%>">
            </td>
        </tr>
		<tr>
        	<td class="FieldName" nowrap> SMTP邮件地址  </td>
            <td class="FieldValue">
                   <%
                 Setitem setitem12=setitemService.getSetitem("4028835a3845652d013845652e3c0023");
                %>
                <input type="text" name="4028835a3845652d013845652e3c0023" id="4028835a3845652d013845652e3c0023" style="width:90%;" value="<%=setitem12.getItemvalue()%>">
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap> SMTP账户   </td>
            <td class="FieldValue">
                   <%
                 Setitem setitem8=setitemService.getSetitem("402881aa0ec16e29010ec175e1ad000d");
                %>
                <input type="text" name="402881aa0ec16e29010ec175e1ad000d" id="402881aa0ec16e29010ec175e1ad000d" style="width:90%;" value="<%=setitem8.getItemvalue()%>">
            </td>
        </tr>
         <tr>
            <td class="FieldName" nowrap> SMTP账户密码   </td>
            <td class="FieldValue">
              <%
                 Setitem setitem9=setitemService.getSetitem("402881aa0ec16e29010ec1769f8f0011");
                %>
                <input type="text" name="402881aa0ec16e29010ec1769f8f0011" id="402881aa0ec16e29010ec1769f8f0011" style="width:90%;" value="<%=setitem9.getItemvalue()%>">
            </td>
        </tr>
		<tr>
            <td class="FieldName" nowrap> url前缀 </td>
            <td class="FieldValue">
              <%
                 Setitem setitem13=setitemService.getSetitem("4028830838b303c00138b303c50b026e");
                %>
                <input type="text" name="4028830838b303c00138b303c50b026e" id="4028830838b303c00138b303c50b026e" style="width:90%;" value="<%=setitem13.getItemvalue()%>">
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript">
    function OnConfirm(){
        document.EweaverForm.submit();        
    }
</script>
</body>
</html>