<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.security.mainpage.MainPageDefined"%>
<%@page import="com.eweaver.base.security.mainpage.MainPage"%>
<%@page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserrolelinkService"%>
<%@ page import="com.eweaver.base.security.model.Sysuserrolelink"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.base.personalSignature.service.PersonalSignatureService" %>
<%@ page import="com.eweaver.base.personalSignature.model.PersonalSignature" %>
<%
    String objid = eweaveruser.getHumres().getId();
    PersonalSignatureService personalSignatureService = (PersonalSignatureService) BaseContext.getBean("personalSignatureService");
    String language=StringHelper.isEmpty(eweaveruser.getSysuser().getLanguage())?"zh_CN":StringHelper.null2String(eweaveruser.getSysuser().getLanguage());
    String stylestr=style;
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")+"','S','accept',function(){save()});";//保存
%>
<html>
<head>

<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>    
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
 	 <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysuserAction?action=modifyPersonalSet" name="EweaverForm" id="EweaverForm"  method="post">	
		<table>
            <colgroup>
				<col width="20%">
				<col width="80%">
			</colgroup>
              <input type="hidden" id="objid" name="objid" value="<%=objid%>"> 
              
                <tr style="display: none;">
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("40288035249ec8aa01249f5ffca70047")%><!-- 系统语言 -->
					</td>
					<td class="FieldValue">
                        <select id="language" name="language">
                            <%
                                String sql = "select id,objname,typeid from selectitem where typeid='4028803522c5ca070122c5d78b8f0002' and isdelete=0 order by dsporder";
                                DataService dataService = new DataService();
                                List list = dataService.getValues(sql);
                                for(int i=0;i<list.size();i++){
                                	Map map = (Map)list.get(i);
                                	String id=(String)map.get("id");
                                	String objname = (String)map.get("objname");
                                	%>
                                	<option value="<%=objname %>" <%if(language.equals(objname)){ %> selected="selected"<%} %>><%=objname %></option>
                                	<%
                                }
                            %>
                        </select>
					</td>
				</tr>
              
				
				<tr>
				    <td class="FieldName" nowrap ><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0026")%> </td><!--页面风格  -->
				    <td class="FieldValue">
				          <%
				                String selectedpage1="";
				                  String selectedpage2="";
				               String selectedpage3="";
				               String selectedpage4="";
				               String selectedpage5="";
				                if(stylestr.equals("default")) {
				                    selectedpage1="selected";
				                } else if(stylestr.equals("gray")){
				                    selectedpage2="selected";
				                }else if(stylestr.equals("purple")) {
				                   selectedpage3="selected";
				                }else if(stylestr.equals("olive")){
				                     selectedpage4="selected";
				                }else if(stylestr.equals("light-orange")){
				                     selectedpage5="selected";
				                }
				            %>
				        <select style="width:40%;" id="stylestr" name="stylestr">
				            <option value="default" <%=selectedpage1%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0027")%></option><!-- 浅蓝色风格(默认) -->
				              <option value="gray" <%=selectedpage2%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0028")%></option><!-- 灰色风格 -->
				            <option value="purple" <%=selectedpage3%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0029")%></option><!-- 紫色风格 -->
				              <option value="olive" <%=selectedpage4%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002a")%></option><!--绿色风格  -->
				            <option value="light-orange" <%=selectedpage5%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002b")%></option><!-- 橙色风格 -->
				        </select>
				    </td>
				</tr>
        </table>

     </form>
  <script type="text/javascript">

      function save(){
          document.EweaverForm.submit();
      }</script>
  </body>
</html>
