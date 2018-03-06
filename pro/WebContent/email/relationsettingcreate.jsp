<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.email.service.EmailtypeService" %>
<%@ page import="com.eweaver.email.model.Emailtype" %>
<%@ page import="com.eweaver.email.model.Eserverinfo" %>
<%@ page import="com.eweaver.email.service.EserverinfoService" %>
<%@ page import="com.eweaver.email.service.RelationsetService" %>
<%@ page import="com.eweaver.email.model.Relationset" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ include file="/base/init.jsp"%>
<html>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";
    String id = StringHelper.null2String(request.getParameter("id"));
    RelationsetService relationsetService = (RelationsetService) BaseContext.getBean("relationsetService");
    RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
    Relationset relationset=new Relationset();
    if(!StringHelper.isEmpty(id)){
        relationset=relationsetService.getRelationset(id);
    }

%>
<head>

    <style type="text/css">
       hr{ height:2px;border:none;border-top:1px solid gray;}
    </style>
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
<form id="eweaverForm" name="EweaverForm" method="post" action="">
         <table>
                  <colgroup>
                      <col width="20%">
                      <col width="">
                  </colgroup>
              <tr>
                      <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0004")%><!-- 设置名 -->
                      </td>
                      <td class="FieldValue">
                          <input  type="text" name="objname" style="width:90%;"   id="objname" value="<%=StringHelper.null2String(relationset.getObjname())%>"/>
                      </td>
                  </tr>
                  <tr>
                      <td class="FieldName" nowrap >
                         <%=labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026")%><!-- 类型 -->
                      </td>
                      <td class="FieldValue">
                           <select id="objtype" name="objtype" onchange="">
                               <%
                                   String selected1 = "";
                                   String selected2 = "";
                                   if (relationset.getObjtype().equals("0")) {
                                    selected1="selected";
                                   } else {
                                    selected2="selected";
                                   }
                               %>
                            <option value="0" <%=selected1%> ><%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd26d4200017")%></option><!-- 人力资源 -->
                            <option value="1" <%=selected2%>><%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2a5efa0019")%></option><!-- 通讯录 -->
                        </select>
                      </td>
                  </tr>
                <tr>
					<td class="FieldName" nowrap>
                       <%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0016")%><!-- 关联browser框 -->
                    </td>
					<td class="FieldValue">
                           <button  type="button" class=Browser type="button" onclick="javascript:getBrowser('<%= request.getContextPath()%>/base/refobj/refobjbrowser.jsp','browservalue','browservaluespan','0');"></button>
                        <input type="hidden"  name="browservalue" id="browservalue" value="<%=StringHelper.null2String(relationset.getBrowservalue())%>" onChange="checkInput('browservalue','browservaluespan')"/>
						<span id=browservaluespan>
                            <%
                                Refobj refobj=new Refobj();
                                if(!StringHelper.isEmpty(relationset.getBrowservalue())) {
                                    refobj=refobjService.getRefobj(relationset.getBrowservalue());
                                }
                            %>
                            <%=refobj.getObjname()%>
						</span>
					</td>
				</tr>
              </table>
	</form>
</body>
<script type="text/javascript">
    function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog(contextPath+'/base/popupmain.jsp?url='+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
        document.all(inputname).value = id[0];
        document.all(inputspan).innerHTML = id[1];

    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
 }
    function onSubmit(){
        var objname=document.getElementById("objname").value;
        var objtype=document.getElementById("objtype").value;
        var browservalue=document.getElementById("browservalue").value;
          Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=relation&from=create',
         params:{id:'<%=id%>',objname:objname,objtype:objtype,browservalue:browservalue},
        success: function() {
        location.href="<%=request.getContextPath()%>/email/relationsettinglist.jsp";
        }
    });
    }
    function onReturn(){   
        location.href="<%=request.getContextPath()%>/email/relationsettinglist.jsp";
    }
</script>
</html>