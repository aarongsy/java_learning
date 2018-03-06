<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitemtype"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ include file="/base/init.jsp"%>

<%
  Selectitemtype selectitemtype = ((SelectitemtypeService)BaseContext.getBean("selectitemtypeService")).getSelectitemtypeById(request.getParameter("id"));
   String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+"','B','delete',function(){onDelete('"+selectitemtype.getId()+"')});";

    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";

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
   <body>
 <div id="pagemenubar" style="z-index:100;"></div>
        <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemtypeAction?action=modify"  name="EweaverForm" method="post">
		  <input type="hidden" value="<%=moduleid%>" id="moduleid" name="moduleid">
            <table>
				<colgroup>
					<col width="20%">
					<col width="">
					<col width="">
				</colgroup>	
				<tr>
					<td class="FieldName" nowrap>
					  <%=labelService.getLabelName("402881e50acc0d40010acc521b4f0003")%>
					</td>
					<td class="FieldValue">
						<input type="text" style="width:95%" name="id" value="<%=selectitemtype.getId()%>" readonly />
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e50ad58ade010ad5978f060006")%>
					</td>
					<td class="FieldValue">
						<input style="width:95%" type="text" name="objname"value="<%=selectitemtype.getObjname()%>" onChange="checkInput('objname','objnamespan')" />
						<span id=objnamespan></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e50ad58ade010ad59927580007")%>
					</td>
					<td class="FieldValue">
						<input style="width:95%" type="text" name="pid" value="<%=StringHelper.null2String(selectitemtype.getPid())%>"  />
						<!-- span id=pidspan></span-->
					</td>
				</tr> 
		    	<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001")%>
					</td>
					<td class="FieldValue">
						<input style="width:95%" type="text" name="dsporder" value="<%=selectitemtype.getDsporder()%>" onChange="checkInput('dsporder','dsporderspan')" />
						<span id=dsporderspan></span>
					</td>
				</tr>			
		</table>   	
		</form>	   
<script language="javascript">
   function onSubmit(){
   	checkfields="objname,dsporder";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>"
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
   }
   function onDelete(id){
       if(id=='4028803522c5ca070122c5d78b8f0002'){ //语言种类不可删除
               Ext.Msg.buttonText={ok:'确定'};
                       Ext.MessageBox.alert('', '不可删除！');
           return;
       }
       Ext.Msg.buttonText={yes:'是',no:'否'};
              Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
                  if (btn == 'yes') {
                      Ext.Ajax.request({
                          url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemtypeAction?action=delete&moduleid=<%=moduleid%>&id='+id,
                          success: function() {
                              this.location.href="<%=request.getContextPath()%>/base/selectitem/selectitemtypelist.jsp?moduleid=<%=moduleid%>";

                          }
                      });
                  }
              });
   }
  function onReturn(){
     document.location.href="<%=request.getContextPath()%>/base/selectitem/selectitemtypelist.jsp?moduleid=<%=moduleid%>";
   }
 </script>		   
		   
  </body>
 </html>