<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.base.security.service.logic.CardCombinationService" %>
<%@ page import="com.eweaver.base.security.model.Cardcombination" %>
<%@ page import="com.eweaver.base.security.model.Cardcombinationdetail" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.base.security.service.logic.RightTransferService" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ page import="com.eweaver.document.base.model.Attach" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
     String id=StringHelper.null2String(request.getParameter("id"));
    ReportdefService reportdefService = (ReportdefService) BaseContext.getBean("reportdefService");
    FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
    NotifyDefineService notifyDefineService = (NotifyDefineService) BaseContext.getBean("notifyDefineService");
    CardCombinationService cardCombinationService=(CardCombinationService)BaseContext.getBean("cardCombinationService");
    SelectitemService selectitemService=(SelectitemService)BaseContext.getBean("selectitemService");
    RefobjService refobjService=(RefobjService)BaseContext.getBean("refobjService");
    RightTransferService rightTransferService=(RightTransferService)BaseContext.getBean("rightTransferService");
    AttachService attachService=(AttachService)BaseContext.getBean("attachService");
      Formfield formfield=new Formfield();
     Cardcombination cbin=cardCombinationService.getCardBination(id);
        String reportId = StringHelper.null2String(request.getParameter("reportId"));
       String methodfield=StringHelper.null2String(request.getParameter("methodfield"));
        if(reportId.equals(""))
    reportId=StringHelper.null2String(cbin.getReportid());
        String formId="";//分类上的表单定义
        String fieldId="";
        String realFormId="";
         String comfieldid="";
         String removefield="";
        String reportName="";
        String objname="";
        String methodfieldvalue="";
        List forms=new ArrayList();
       if(!reportId.equals("")){
    Reportdef reportdef=reportdefService.getReportdef(reportId);
    formId=reportdef.getFormid();
    reportName=reportdef.getObjname();
    forms=notifyDefineService.getForminfos(formId,forms);

    }
    methodfieldvalue=StringHelper.null2String(cbin.getMethodfieldvalue());
    realFormId=StringHelper.null2String(cbin.getFormid());
    comfieldid=StringHelper.null2String(cbin.getComfieldid());
    removefield=StringHelper.null2String(cbin.getRemovefield());
     int ismethod=NumberHelper.getIntegerValue(cbin.getIsmethod(),0);
    objname=StringHelper.null2String(cbin.getObjname());
    if(StringHelper.isEmpty(methodfield)){
        methodfield=StringHelper.null2String(cbin.getMethodfield());
        formfield=formfieldService.getFormfieldById(cbin.getMethodfield());
    }else{
        formfield=formfieldService.getFormfieldById(methodfield);
        objname = StringHelper.null2String(request.getParameter("objname"));
        comfieldid = StringHelper.null2String(request.getParameter("comFieldId"));
        realFormId = StringHelper.null2String(request.getParameter("formId"));
        ismethod = NumberHelper.getIntegerValue(request.getParameter("ismethod"), 0);
        methodfield = StringHelper.null2String(request.getParameter("methodfield"));
    }
    String showValue="";
    String value=StringHelper.null2String(cbin.getMethodfieldvalue());
    if(formfield!=null&&!StringHelper.isEmpty(formfield.getId())){
    if (formfield.getHtmltype() == 5) {    //选择项
        Selectitem selectitem = selectitemService.getSelectitemById(value);
        showValue = selectitem.getObjname();

    } else if (formfield.getHtmltype() == 6) {  //关联选择
        Refobj refobj = refobjService.getRefobj(formfield.getFieldtype());
        if (refobj != null) {
            String _reftable = StringHelper.null2String(refobj
                    .getReftable());
            String _keyfield = StringHelper.null2String(refobj
                    .getKeyfield());
            String _viewfield = StringHelper.null2String(refobj
                    .getViewfield());
            String sqlref = "select " + _viewfield + " from " + _reftable + " where " + _keyfield + "=?";
            List<Map> listref = rightTransferService.getBaseJdbcDao().getJdbcTemplate().queryForList(sqlref, new Object[]{value});
            for (Map m : listref) {
                showValue = m.values().toString().substring(1, (m.values().toString().length()) - 1);
            }

        }

    } else if (formfield.getHtmltype() == 7) { //附件
        Attach attach = attachService.getAttach(value);
        String attachname = StringHelper.null2String(attach.getObjname());
        showValue = attachname;
    } else { //其他
        showValue = value;
    }
    }
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.CardBinationAction?action=getdetaillist&id="+id;
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
         Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
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
                     fields: ['objname','formname','fieldname','del','id']


                 })

             });
             var cm = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800074")%>", sortable: false,  dataIndex: 'objname'},//任务
                 {header: "<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a004a")%>", sortable: false,   dataIndex: 'formname'},//表单
                 {header: "<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360059")%>",  sortable: false, dataIndex: 'fieldname'},//字段
                 {header: "<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e")%>",  sortable: false, dataIndex: 'del'}//操作
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
                                          sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                                          sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                                          columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                                          getRowClass : function(record, rowIndex, p, store){
                                              return 'x-grid3-row-collapsed';
                                          }
                                      },
                                     tbar: [Ext.get('divadd').dom.innerHTML],
                                      bbar: new Ext.PagingToolbar({
                                          pageSize: 20,
                           store: store,
                           displayInfo: true,
                           beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
                           afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
                           firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
                           prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
                           nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
                           lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
                           displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示//条记录
                           emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
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
<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.CardBinationAction?action=modify" name="EweaverForm" method="post">
 <input type="hidden" name="id" value="<%=id%>">
<table>
	<colgroup>
		<col width="50%">
		<col width="50%">
	</colgroup>
  <tr>
	<td valign=top>
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
					    <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790052")%><!-- 操作名 -->
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%" name="objname" value="<%=objname%>" />
                         <%if(objname.equals("")){%>
                        <img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                     <%}%>
                    </td>
				</tr>

                 <tr>
                      <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402881f00c9078ba010c907b291a0006")%><!-- 报表 -->
	   </td>
	   <td class="FieldValue">
	         <button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/report/reportbrowser.jsp','reportId','reportIdspan','1');"></button>
                         <input type="hidden"   name="reportId" value="<%=reportId%>" />
                         <span id = "reportIdspan" ><%=reportName%></span>
		</td>
	 </tr>
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a004a")%><!-- 表单 -->
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

                   <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790053")%><!-- 合并模糊查询字段 -->
                   </td>
                   <td class="FieldValue">
                       <select name="comFieldId">
                       </select>
                    </td>
                 </tr>

                   <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379005d")%><!-- 被合并卡片处理方式 -->
                   </td>
                   <td class="FieldValue">
                       <select name="ismethod" onchange="methodchange(this)">
                           <%
                               String selected1="";
                               String selected2="";
                               if(ismethod==0){
                                   selected1="selected";
                               }else{
                                  selected2="selected";
                               }
                           %>
                           <option value="0" <%=selected1%>><%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%><!-- 删除 --></option>
                           <option value="1" <%=selected2%>><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379005e")%><!-- 变更字段 --></option>
                       </select>
                    </td>

                 </tr>
                   <%
                    if(ismethod==1){
                   %>
                   <tr  id="methodfieldtd" >
                       <%}else{%>
                   <tr  id="methodfieldtd" style="display:none">       
                       <%}%>
                       <td class="FieldName">
                         <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379005e")%><!-- 变更字段 -->
                       </td>
                        <td class="FieldValue">
                           <select name="methodfield" onchange="FieldValue(this)" >

                       </select></td>
                   </tr>
                     <%
                    if(ismethod==1){
                   %>
                   <tr  id="methodfieldvaluetd" >
                       <%}else{%>
                   <tr  id="methodfieldvaluetd" style="display:none">
                       <%}%>
                       <td class="FieldName">
                         <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379005f")%><!-- 变更字段的值 -->
                       </td>
                            <%
                       if (!StringHelper.isEmpty(methodfield) && formfield.getHtmltype() == 1 && formfield.getFieldtype().equals("4")) {
                   %>
                       <td class="FieldValue">
                           <button type="button" class="Calendar" id=SelectDate2
                                   onclick="javascript:getdate('con<%=methodfield%>_value','con<%=methodfield%>_span','0')"></button>
                           &nbsp;
                           <span id="con<%=methodfield%>_span"><%=StringHelper.null2String(showValue)%></span>
                           <input type=hidden name="con<%=methodfield%>_value"
                                  value="<%=StringHelper.null2String(value)%>">
                       </td>
                   <%} else if (!StringHelper.isEmpty(methodfield) && formfield.getHtmltype() == 1 && formfield.getFieldtype().equals("5")) {%>
                       <td class="FieldValue">
                           <button type="button" class="Calendar" id=SelectDate3
                                   onclick="javascript:gettime('con<%=methodfield%>_value','con<%=methodfield%>_span','0')"></button>
                           &nbsp;
                           <span id="con<%=methodfield%>_span"><%=StringHelper.null2String(showValue)%></span>
                           <input type=hidden name="con<%=methodfield%>_value"
                                  value="<%=StringHelper.null2String(value)%>">
                       </td>
                   <%} else if (!StringHelper.isEmpty(methodfield) && formfield.getHtmltype() == 6) {%>
                               <%

                           Refobj refobj = refobjService.getRefobj(formfield.getFieldtype());
                           String _refid = StringHelper.null2String(refobj.getId());
                           String _refurl = StringHelper.null2String(refobj.getRefurl());
                           String _viewurl = StringHelper.null2String(refobj.getViewurl());
                           String _reftable = StringHelper.null2String(refobj.getReftable());
                           String _keyfield = StringHelper.null2String(refobj.getKeyfield());
                           String _viewfield = StringHelper.null2String(refobj.getViewfield());
                           String showname = "";
                           StringBuffer sb = new StringBuffer("");
                           sb.append("<td class='FieldValue'> \n\r<button type=button class=Browser onclick=\"javascript:getrefobj('con" + methodfield + "_value','field_" + methodfield + "span','" + _refid + "','" + _viewurl + "','0');\"></button>");
                           sb.append("\n\r<input type=\"hidden\" name=\"con" + methodfield + "_value\" value=\"" + value + "\"    >");
                           sb.append("\n\r<span id=\"field_" + methodfield + "span\" name=\"field_" + methodfield + "span\" >");
                           sb.append(showValue);
                           sb.append("</span>\n\r</td> ");
                           out.print(sb.toString());
                       %>


                   <%} else if (StringHelper.isEmpty(methodfield)) {%>

                   <%} else if (!StringHelper.isEmpty(methodfield) && formfield.getHtmltype() == 5) {%>

                       <%
                           List list = selectitemService.getSelectitemList(formfield.getFieldtype(), null);
                           StringBuffer sb = new StringBuffer("");
                           sb.append("<input type=\"hidden\" name=\"field_"
                                   + methodfield + "_fieldcheck\" value=\"" + formfield.getFieldcheck() + "\" >");
                           sb.append("<td class='FieldValue'>\n\r <select class=\"InputStyle2\" id=\"con" + methodfield + "_value\"  name=\"con" + methodfield + "_value\"   onchange=\"fillotherselect(this,'" + methodfield
                                   + "'," + "-1" + ")\"  >");
                           String _isempty = "";
                           if (StringHelper.isEmpty(value))
                               _isempty = " selected ";
                           sb.append("\n\r<option value=\"\" " + _isempty + " ></option>");
                           for (int i = 0; i < list.size(); i++) {
                               Selectitem _selectitem = (Selectitem) list.get(i);
                               String _selectvalue = StringHelper.null2String(_selectitem.getId());
                               String _selectname = StringHelper.null2String(_selectitem.getObjname());
                               String selected = "";
                               if (_selectvalue.equalsIgnoreCase(StringHelper.null2String(value)))
                                   selected = " selected ";
                               sb.append("\n\r<option value=\"" + _selectvalue + "\" " + selected + " >" + _selectname + "</option>");
                           }
                           sb.append("</select>\n\r</td> ");
                           out.print(sb.toString());

                       %>
                   <%} else {%>

                   <td class="FieldValue">
                       <textarea rows="5" cols="50" id="con<%=methodfield%>_value" name="con<%=methodfield%>_value">
                           <%=StringHelper.null2String(showValue)%>
                       </textarea>
                   </td>
                   <%}%>
                   </tr>
                  <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790060")%><!-- 排除查询列 -->
                   </td>
                   <td class="FieldValue">
                       <select name="removefield" >
                       </select>
                    </td>
                 </tr>
		        <tr class=Title>
					<th colspan=2 nowrap><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e")%><!-- 说明 --></th>
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>
		        </tr>
				<tr>
					<td class="FieldValue" colspan=2>
					<TEXTAREA STYLE="width:100%" class=InputStyle rows=4 name="description"><%=StringHelper.null2String(cbin.getDescription())%></TEXTAREA>
					</td>
				</tr>

</table>
</td>
    </tr>
    </table>
    </form>
  </div>
<div id="divadd">
    <table>
        <tr>
            <td><th colspan=2 nowrap><a href="<%= request.getContextPath()%>/base/cardcombination/cardcombinationdetailcreate.jsp?actionId=<%=StringHelper.null2String(cbin.getId())%>"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290049")%><!-- 添加 --></a></th></td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    function onReturn(){
        document.location.href="<%=request.getContextPath()%>/base/cardcombination/cardcombinationlist.jsp";

    }
    function onSubmit(){
   	checkfields="";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}
function getOptions(formId){
    if(formId!=""){
       FormfieldService.getAllFieldByFormIdExist(formId,callback2);
        FormfieldService.getAllFieldByFormIdExist(formId,callback3);
        FormfieldService.getAllFieldByFormIdExist(formId,callback4);

    }
}

function callback2(list){
    DWRUtil.removeAllOptions("comfieldid");
    DWRUtil.addOptions("comfieldid",list,"id","fieldname");
   <%if(!comfieldid.equals("")){%>
    var objselect = document.all("comfieldid");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=comfieldid%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    <%}%>
}
     function callback3(list){
    DWRUtil.removeAllOptions("methodfield");
    DWRUtil.addOptions("methodfield",list,"id","fieldname");
   <%if(!methodfield.equals("")){%>
    var objselect = document.all("methodfield");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=methodfield%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    <%}%>
}
         function callback4(list){
             var objselect=document.all('removefield');
    DWRUtil.removeAllOptions("removefield");
  var oOption = document.createElement("OPTION");
        objselect.options.add(oOption);
        oOption.innerText =" ";
        oOption.value = "";
    DWRUtil.addOptions("removefield",list,"id","fieldname");
   <%if(!removefield.equals("")){%>
    var objselect = document.all("removefield");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=removefield%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    <%}%>
}
getOptions(document.all("formId").value);

     function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
          window.location="cardcombinationmodify.jsp?id=<%=id%>&reportId="+id[0];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
    function methodchange(obj){
           var value=obj.value;
        if(value==0){
            document.all('methodfieldtd').style.display='none';
             document.all('methodfieldtd').value='';
            document.all('methodfieldvaluetd').style.display='none';
            document.all('methodfieldvaluetd').value='';
        }else{
            document.all('methodfieldtd').style.display='block';
            document.all('methodfieldvaluetd').style.display='block';
            

        }

    }
    function FieldValue(obj){
        var objname=document.all('objname').value;
        var reportId=document.all('reportId').value;
        var formId=document.all('formId').value;
        var comFieldId=document.all('comFieldId').value;
        var ismethod=document.all('ismethod').value;
        var methodfield=document.all('methodfield').value;
        window.location="cardcombinationmodify.jsp?id=<%=id%>&reportId="+reportId+"&formId="+formId+"&comFieldId="+comFieldId+"&ismethod="+ismethod+"&methodfield="+methodfield+"&objname="+objname ;

    }
 function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
    var idsin = document.all(inputname).value;
        var url='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath() %>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
        if(idsin.length>900){   //当idsin过长时，ie的url不支持过长的地址
           url='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath() %>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
        }
    var id;
    try{
    id=openDialog(url);
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
		document.all(inputspan).innerHTML = '<img src=/oa/images/base/checkinput.gif>';

    }
    }
    }
         function fillotherselect(elementobj,fieldid,rowindex){

	var elementvalue = Trim(getValidStr(elementobj.value));//选择项的值


	var objname = "field_"+fieldid+"_fieldcheck";

	var fieldcheck = Trim(getValidStr(document.all(objname).value));//用于保存选择项子项的值(formfieldid)

	if(fieldcheck=="")
		return;

//	DataService.getValues(createList(fieldcheck,rowindex),"select id,objname from selectitem where pid = '"+elementvalue+"'");
	var sql ="<%=SQLMap.getSQLString("base/cardcombination/cardcombinationmodify.jsp")%>";

	DataService.getValues(sql,{
      callback:function(dataFromServer) {
        createList(dataFromServer, fieldcheck,rowindex);
      }
   }
	);

}
</script>
  </body>
</html>
