<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.security.model.PermissionBatchAction"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.model.PermissionBatchActionDetail"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionBatchActionService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService"%>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%
    String actionId=StringHelper.null2String(request.getParameter("id"));
    PermissionBatchActionService permissionBatchActionService = (PermissionBatchActionService) BaseContext.getBean("permissionBatchActionService");
    CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
    ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
    FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
    FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
    ReportdefService reportdefService = (ReportdefService) BaseContext.getBean("reportdefService");
    WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
    PermissionBatchAction act=permissionBatchActionService.getPermissionBatchAction(actionId);
    int type=0;
    if(request.getParameter("type")!=null&&!"".equals(request.getParameter("type"))){
        type=NumberHelper.getIntegerValue(request.getParameter("type"),1);
    }
    if(type==0){
        type=NumberHelper.getIntegerValue(act.getType(),1);
    }
    int cardtype=NumberHelper.getIntegerValue(act.getCardtype(),0);
    String reportId = StringHelper.null2String(request.getParameter("reportId"));
    String reportName="";
    String realFormId="";//实际表单
    String fieldId;
    String optType="";
    String viewLayoutId="";
    String editLayoutId="";
    Integer viewPriority=-1;
    Integer editPriority=-1;

    realFormId=StringHelper.null2String(act.getFormId());
    fieldId=StringHelper.null2String(act.getFieldid());
    if(reportId.equals(""))
    reportId=StringHelper.null2String(act.getReportId());
    optType=StringHelper.null2String(act.getOptType());
    viewLayoutId=StringHelper.null2String(act.getViewLayoutId());
    editLayoutId=StringHelper.null2String(act.getEditLayoutId());
    viewPriority=act.getViewPriority();
    editPriority=act.getEditPriority();
    NotifyDefineService notifyDefineService = (NotifyDefineService) BaseContext.getBean("notifyDefineService");
    String formId="";//分类上的表单定义
    List forms=new ArrayList();
    List layoutlist = new ArrayList();
    if(!reportId.equals("")){
    Reportdef reportdef=reportdefService.getReportdef(reportId);
    formId=reportdef.getFormid();
    reportName=reportdef.getObjname();
    forms=notifyDefineService.getForminfos(formId,forms);
    String strDefHql = "from Formlayout where formid='" + formId + "'";
    List listdef = formlayoutService.findFormlayout(strDefHql);
    layoutlist.addAll(listdef);
    }
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.PermissionBatchActionAction?action=getdetaillist&id="+actionId;
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
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
   <script src="<%= request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
   <script src="<%= request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%= request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
 
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
     <script type="text/javascript">
         Ext.SSL_SECURE_URL='about:blank';
         Ext.LoadMask.prototype.msg='加载...';
         var store;
         var dlg0;
         Ext.onReady(function() {
             Ext.QuickTips.init();
         <%if(!pagemenustr.equals("")){%>
             var tb = new Ext.Toolbar();
             tb.render('pagemenubar');
         <%=pagemenustr%>
         <%}%>
             store = new Ext.data.Store({
                 proxy: new Ext.data.HttpProxy({
                     url: '<%=action%>'
                 }),
                 reader: new Ext.data.JsonReader({
                     root: 'result',
                     totalProperty: 'totalcount',
                     fields: ['objname','type','catorwork','formname','formfieldname','optType','viewlayoutname','editlayoutname','del','id']


                 })

             });
             var cm = new Ext.grid.ColumnModel([{header: "任务", sortable: false,  dataIndex: 'objname'},
                 {header: "类型", sortable: false,   dataIndex: 'type'},
                 {header: "分类or流程",  sortable: false, dataIndex: 'catorwork'},
                 {header: "表单",  sortable: false, dataIndex: 'formname'},
                 {header: "字段",  sortable: false, dataIndex: 'formfieldname'},
                 {header: "权限类型",  sortable: false, dataIndex: 'optType'},
                 {header: "显示布局",  sortable: false, dataIndex: 'viewlayoutname'},
                {header: "编辑布局",  sortable: false, dataIndex: 'editlayoutname'} ,
                 {header: "操作",  sortable: false, dataIndex: 'del'}
             ]);
             var grid = new Ext.grid.GridPanel({
                 region: 'center',
                 store: store,
                 cm: cm,
                 trackMouseOver:false,
                 loadMask: true,
                  viewConfig: {
                                          forceFit:true,
                                          enableRowBody:true,
                                          sortAscText:'升序',
                                          sortDescText:'降序',
                                          columnsText:'列定义',
                                          getRowClass : function(record, rowIndex, p, store){
                                              return 'x-grid3-row-collapsed';
                                          }
                                      },
                                     tbar: [Ext.get('divadd').dom.innerHTML],
                                      bbar: new Ext.PagingToolbar({
                                          pageSize: 20,
                           store: store,
                           displayInfo: true,
                           beforePageText:"第",
                           afterPageText:"页/{0}",
                           firstText:"第一页",
                           prevText:"上页",
                           nextText:"下页",
                           lastText:"最后页",
                           displayMsg: '显示 {0} - {1}条记录 / {2}',
                           emptyMsg: "没有结果返回"
                       })

             });
             store.load({params:{start:0, limit:20}});

             //Viewport
             var viewport = new Ext.Viewport({
                 layout: 'border',
                 items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
             });
         });

   </script>
  </head>
  <body>
  <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionBatchActionAction?action=modify" name="EweaverForm" method="post">
<input type="hidden" name="id" value="<%=actionId%>">
		       <table class=noborder>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
		        <tr class=Title>
					<th colspan=2 nowrap><%=labelService.getLabelName("402881e80ca5d67a010ca5e168090006")%><!--报表信息--></th>
                     <th/>
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>
		        </tr>
				<tr>
					<td class="FieldName" nowrap>
					    操作名
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%" name="objname" value="<%=StringHelper.null2String(act.getObjname()) %>"/>
						<%if((StringHelper.null2String(act.getObjname())).equals("")){%>
						<img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
						<%}%>
					</td>
				</tr>



				<tr>
					<td class="FieldName" nowrap>
					  类型
                    <td class="FieldValue">
                        <select name="type" onChange="optionChanged()">
                            <option value="1" <%if(type==1){%>selected<%}%>>授权</option>
                            <option value="2" <%if(type==2){%>selected<%}%>>移交</option>
                        </select>
                    </td>
				</tr>
                 <tr>
                    <td class="FieldName" nowrap>
                        报表
                   </td>
                   <td class="FieldValue">
                         <button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/report/reportbrowser.jsp','reportId','reportIdspan','1');"></button>
                         <input type="hidden"   name="reportId" value="<%=reportId%>" />
                         <span id = "reportIdspan" ><%=reportName%></span>
                    </td>
                 </tr>
                 <tr>
                    <td class="FieldName" nowrap>
                        表单
                   </td>
                   <td class="FieldValue">
                        <select name="formId" onchange="getOptions(this.value)">
                           <%for(Object form:forms){
                               String formName=((Forminfo)form).getObjname();
                               formId= ((Forminfo)form).getId();
                           %>
                           <option value="<%=formId%>" <%if(realFormId.equals(formId)){%>selected<%}%>><%=formName%></option>
                           <%}%>
                       </select>
                    </td>
                 </tr>
                 <tr <%if(type==1){%>style='display:none'<%}%>>
                    <td class="FieldName" nowrap>
                        字段
                   </td>
                   <td class="FieldValue">
                       <select name="fieldId">

                       </select>
                    </td>
                 </tr>
                 <tr <%if(type==2){%>style='display:none'<%}%>>
                   <td class="FieldName" nowrap>
                        权限类型
                   </td>
                    <td class="FieldValue">
                        <input type='checkbox' name="optType"  class="InputStyle2" value="3" <%if(optType.indexOf("3")>-1){%>checked<%}%>>查看<br>
                        <input type='checkbox' name="optType"  class="InputStyle2" value="15" <%if(optType.indexOf("15")>-1){%>checked<%}%>>编辑<br>
                        <input type='checkbox' name="optType"  class="InputStyle2" value="105" <%if(optType.indexOf("105")>-1){%>checked<%}%>>删除<br>
                        <input type='checkbox' name="optType"  class="InputStyle2" value="165" <%if(optType.indexOf("165")>-1){%>checked<%}%>>共享
                    </td>
                 </tr>
                 <tr <%if(type==2){%>style='display:none'<%}%>>
                   <td class="FieldName" nowrap>显示布局</td>
                    <td class="FieldValue">
                        <select class="inputstyle" style="width:180px"  name="viewLayoutId" >
                        <option value=""></option>
                        <%
                        for(int i=0; i<layoutlist.size(); i++){
                            Formlayout formlayout=(Formlayout)layoutlist.get(i);
                            String selected = "";%>
                            <option value=<%=formlayout.getId()%> <%if(viewLayoutId.equals(formlayout.getId())){%>selected<%}%>><%=formlayout.getLayoutname()%></option>
                        <%}%>
                        </select>
                        优先级
                        <INPUT type=text class="InputStyle2"   name="viewPriority" MAXLENGTH =3 value="<%=viewPriority%>">
                     </td>
                 </tr>
                 <tr <%if(type==2){%>style='display:none'<%}%>>
                   <td class="FieldName" nowrap>
                        编辑布局
                   </td>
                    <td class="FieldValue">
                    <select class="inputstyle" style="width:180px"  name="editLayoutId" >
                        <option value=""></option>
                        <%
                        for(int i=0; i<layoutlist.size(); i++){
                            Formlayout formlayout=(Formlayout)layoutlist.get(i);
                            String selected = "";%>
                            <option value=<%=formlayout.getId()%> <%if(editLayoutId.equals(formlayout.getId())){%>selected<%}%>><%=formlayout.getLayoutname()%></option>
                        <%}%>
                        </select>
                        优先级
                        <INPUT type=text class="InputStyle2"   name="editPriority" MAXLENGTH =3 value="<%=editPriority%>">
                    </td>
                 </tr>

                <tr>
					<td class="FieldName" nowrap>
					  卡片类型
					<td class="FieldValue">
                        <select class="inputstyle" style="width:140px"  name="cardtype" >
                            <option value=0 <%if(cardtype==0){%>selected<%}%>>结果包含流程和表单</option>
                            <option value=1 <%if(cardtype==1){%>selected<%}%>>结果仅包含表单卡片</option>
                            <option value=2 <%if(cardtype==2){%>selected<%}%>>结果仅包含流程卡片</option>
                        </select>
                    </td>
				</tr>
                <tr>
					<td class="FieldName" nowrap>
					  操作对象
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%" name="operationObj" value="<%=StringHelper.null2String(act.getOperationObj()) %>"/>
						<%if((StringHelper.null2String(act.getOperationObj())).equals("")){%>
                        <img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                        <%}%>
                    </td>
				</tr>
                <tr>
					<td class="FieldName" nowrap>
					  目标对象
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%" name="targetObj" value="<%=StringHelper.null2String(act.getTargetObj()) %>"/>
						<%if((StringHelper.null2String(act.getTargetObj())).equals("")){%>
						<img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
						<%}%>
                    </td>
				</tr>

                <tr>
					<td class="Line" colspan=100% nowrap>
					</td>
		        </tr>

		        <tr class=Title>
					<th colspan=2 nowrap>操作描述</th>
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>
		        </tr>
				<tr>
					<td class="FieldValue" colspan=2>
					<TEXTAREA STYLE="width:100%" class=InputStyle rows=4 name="objdesc"><%=StringHelper.null2String(act.getObjdesc())%></TEXTAREA>
					</td>
				</tr>

</table>

      	</form>
</div>
  <div id="divadd">
  <table>
      <tr>
          <td><th colspan=2 nowrap><a href="<%=request.getContextPath()%>/base/security/permissionBatchAction/permissionBatchActionDetailCreate.jsp?actionId=<%=actionId%>">添加</a></th>
</td>
      </tr>
  </table>
  </div>
<script language="javascript">
function onSubmit(){
   	checkfields="";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}

    function onReturn(){
       window.location="<%=request.getContextPath()%>/base/security/permissionBatchAction/permissionBatchActionList.jsp" ;
}
function getOptions(formId){
    if(formId!="")
    FormfieldService.getFieldByForm(formId,6,'402881e70bc70ed1010bc75e0361000f',callback)
}
function callback(list){
    DWRUtil.removeAllOptions("fieldId");
    DWRUtil.addOptions("fieldId",list,"id","fieldname");
   <%if(!fieldId.equals("")){%>
    var objselect = document.all("fieldId");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=fieldId%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    <%}%>
}
getOptions(document.all("formId").value);
function optionChanged(){
    var mySelect=document.EweaverForm.type;
    for(var i=0;i<mySelect.length;i++){
        if(mySelect.options[i].selected==true){
            window.location="permissionBatchActionModify.jsp?type="+mySelect.options[i].value+"&id=<%=actionId%>";
        }
    }
}
    function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
        window.location="permissionBatchActionModify.jsp?id=<%=actionId%>&reportId="+id[0]
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
