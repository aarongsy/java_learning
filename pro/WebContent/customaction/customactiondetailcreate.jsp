<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.subprocess.service.SubprocesssetService" %>
<%@ page import="com.eweaver.workflow.subprocess.model.Subprocessset" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.customaction.service.CustomactionService" %>
<%@ page import="com.eweaver.customaction.model.Customaction" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.customaction.model.Customactiondetail" %>
<%@ page import="com.eweaver.document.base.model.Attach" %>
<%@ page import="com.eweaver.base.security.service.logic.RightTransferService" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<%
 String detailid=StringHelper.null2String(request.getParameter("id"));
String formid=StringHelper.null2String(request.getParameter("formid"));
String formfieldid=StringHelper.null2String(request.getParameter("formfieldid"));
String actionid=StringHelper.null2String(request.getParameter("actionid"));
ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
FormfieldService  formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");
SelectitemService  selectitemService=(SelectitemService)BaseContext.getBean("selectitemService");
 RefobjService  refobjService=(RefobjService)BaseContext.getBean("refobjService");
  RightTransferService  rightTransferService=(RightTransferService)BaseContext.getBean("rightTransferService");
CustomactionService customactionService=(CustomactionService)BaseContext.getBean("customactionService");
AttachService attachService=(AttachService)BaseContext.getBean("attachService");
Formfield formfield=formfieldService.getFormfieldById(formfieldid);
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.customaction.servlet.CustomactionAction?action=getformfield";
        String _value="";
   String showValue="";
    String value="";
    String sel0="";
    String sel1="";
    String sel2="";
    String seldate1="";
    String seldate2="";
    String seltime1="";
    String seltime2="";
    String str5sel0="";
    String str5sel1="";
    String str5style="";
    String str5stylespan="";
    String selreobj="";
    if (!StringHelper.isEmpty(detailid)) {
        Customaction customaction = customactionService.getCustomaction(actionid);
        for (Object o : customaction.getActionDetails()) {
            Customactiondetail actDetail = (Customactiondetail) o;
            if (detailid.equals(actDetail.getId())) {
                formfieldid = StringHelper.null2String(actDetail.getFieldid());
              formfield=formfieldService.getFormfieldById(formfieldid);
                value = StringHelper.null2String(actDetail.getDefvalue());
                if (formfield.getHtmltype() == 5) {    //选择项
                    if(value.startsWith("$")&&value.endsWith("$")&&value.length()==34){
                       showValue=value;
                        str5sel1="selected";
                        str5style="style=display:none";
                    }else{
                         Selectitem selectitem = selectitemService.getSelectitemById(value.toString());
                         showValue = selectitem.getObjname();
                        str5sel0="selected";
                        str5stylespan="style=display:none";
                    }


                } else if (formfield.getHtmltype() == 6) {  //关联选择
                    if(value.startsWith("$")&&value.endsWith("$")&&value.length()==34){
                        selreobj="selected";
                         showValue=value;
                    }else if (value.equals("$currentuser$")) {
                        sel1="selected";
                       showValue = "$currentuser$";
                    } else if (value.equals("$currentorgunit$")) {
                        sel2="selected";
                        showValue = "$currentorgunit$";
                    } else {
                        sel0="selected";
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
                    }
                } else if (formfield.getHtmltype() == 7) { //附件
                    Attach attach = attachService.getAttach(value);
                    String attachname = StringHelper.null2String(attach.getObjname());
                    showValue = attachname;
                } else { //其他
                    if(formfield.getHtmltype()==1&&formfield.getFieldtype().equals("4")){
                        seldate2="selected";
                        seltime2="selected";
                    }else if(formfield.getHtmltype()==1&&formfield.getFieldtype().equals("5")){
                    }else{
                        seltime1="selected";
                        seldate1="selected";
                         showValue = value;
                    }

                }

                break;
            }
        }
    }
%>
<%

    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','S','accept',function(){onConfirm()});";//

%>
  <head>

      <style type="text/css">
     .x-toolbar table {width:0}
     #pagemenubar table {width:0}
       .x-panel-btns-ct {
         padding: 0px;
     }
     .x-panel-btns-ct table {width:0}
  .css1{background-color:   #FFFFFF}
  .css2{background-color:#E7E7E7;}
   </style>
      <script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/interface/FormfieldService.js'></script>
        <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
   
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>

     <script type="text/javascript">
         var store;
         var dlg0;
       Ext.onReady(function() {

           Ext.QuickTips.init();
       <%if(!pagemenustr.equals("")){%>
           var tb = new Ext.Toolbar();
           tb.render('pagemenubar');
           <%=pagemenustr%>
       <%}%>
           dlg0 = new Ext.Window({
                layout:'border',
                closeAction:'close',
                plain: true,
                modal :true,
                width:400,
                height:300,
                items: new Ext.Panel({
                    region:'center',
                    autoScroll:true,
                    html:Ext.get('dialog0').dom.innerHTML
                }),
                listeners:{'beforecolose':function(win){
                	win.hide();
                	return false;
                }}
            });
       });

   </script>

  </head>
  <body>
  <div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>
  <form name="EweaverForm" id="EweaverForm" method="post" action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.customaction.servlet.CustomactionAction?action=createdetail">
    <input type="hidden" name="actionid" value="<%=actionid%>">
      <input type="hidden" name="detailid" value="<%=detailid%>">
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
                   <tr>
                       <td class="FieldName" nowrap>
                           字段
                       </td>
                       <td class="FieldValue">
                           <select id="formfieldid" name="formfieldid" onchange="fieldchange()">

                           </select>
                       </td>
                   </tr>
                   <%
                       if (!StringHelper.isEmpty(formfieldid) && formfield.getHtmltype() == 1 &&"4".equals(formfield.getFieldtype())) {
                   %>
                   <tr>
                       <td class="FieldName" nowrap>
                           <%=formfield.getLabelname()%>
                       </td>
                       <td class="FieldValue">
                           <select onchange="currdateChange(this)">
                               <option value="0" <%=seldate1%>>请选择--<%=formfield.getLabelname()%></option>
                               <option value="1" <%=seldate2%>>当期日期</option>
                               <option value="2" <%=seldate2%>>获取其他字段的值</option>

                           </select>
                           <input type=text name="con<%=formfieldid%>_value"
                                  value="<%=StringHelper.null2String(value)%>" onclick="WdatePicker()" >
                       </td>

                   </tr>
                   <%} else if (!StringHelper.isEmpty(formfieldid) && formfield.getHtmltype() == 1 && formfield.getFieldtype().equals("5")) {%>
                   <tr>
                       <td class="FieldName" nowrap>
                           <%=formfield.getLabelname()%>
                       </td>
                       <td class="FieldValue">
                            <select onchange="currtimeChange(this)">
                               <option value="0" <%=seltime1%>>请选择--<%=formfield.getLabelname()%></option>
                               <option value="1" <%=seltime2%>>当期时间</option>
                                <option value="2" <%=seldate2%>>获取其他字段的值</option>


                           </select>
                           <input type=text name="con<%=formfieldid%>_value"
                                  value="<%=StringHelper.null2String(value)%>" onclick="WdatePicker({startDate:'%H:00:00',dateFmt:'H:mm:ss'})">
                       </td>

                   </tr>
                   <%} else if (!StringHelper.isEmpty(formfieldid) && formfield.getHtmltype() == 6) {%>
                   <tr>
                       <td class="FieldName" nowrap>
                           <%=formfield.getLabelname()%>
                       </td>

                       <%

                           Refobj refobj = refobjService.getRefobj(formfield.getFieldtype());
                           String _refid = StringHelper.null2String(refobj.getId());
                           String _refurl = StringHelper.null2String(refobj.getRefurl());
                           String _viewurl = StringHelper.null2String(refobj.getViewurl());
                           String _reftable = StringHelper.null2String(refobj.getReftable());
                           String _keyfield = StringHelper.null2String(refobj.getKeyfield());
                           String _viewfield = StringHelper.null2String(refobj.getViewfield());
                           String showname = "";

                           if (!StringHelper.isEmpty(_value)) {
                               String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(_value) + ")";
                               DataService dataService = new DataService();
                               List valuelist = dataService.getValues(sql);
                               for (int i = 0; i < valuelist.size(); i++) {
                                   Map refmap = (Map) valuelist.get(i);
                                   String _objid = StringHelper.null2String((String) refmap.get("objid"));
                                   String _objname = StringHelper.null2String((String) refmap.get("objname"));
                                   if (!StringHelper.isEmpty(_viewurl))
                                       showname += "&nbsp;&nbsp;<a href=\"" + _viewurl + _objid + "\" target=\"_blank\" >";
                                   showname += _objname;
                                   if (!StringHelper.isEmpty(_viewurl))
                                       showname += "</a>";
                               }
                           }

                           StringBuffer sb = new StringBuffer("");
                           sb.append("<td><table> <colgroup>\n" +
"                       <col width=\"20%\">\n" +
"                       <col width=\"60%\">\n" +
"                     </colgroup><tr><td class='FieldValue' >");
                           sb.append("<select onchange=curuserChange(this)><option value=0 "+sel0+">请选择--"+formfield.getLabelname()+"</option><option value=1 "+sel1+">当前用户</option><option value=2 "+sel2+">当前部门</option> <option value=3 "+selreobj+">获取其他字段的值</option></select>") ;
                           sb.append("<td class='FieldValue'> \n\r<button  type=button class=Browser id=\"field_" + formfieldid + "button\" onclick=\"javascript:getrefobj('con" + formfieldid + "_value','field_" + formfieldid + "span','" + _refid + "','" + _viewurl + "','0');\"></button>");
                           sb.append("\n\r<input type=\"hidden\" name=\"con" + formfieldid + "_value\" value=\"" + value + "\"    >");
                           sb.append("\n\r<span id=\"field_" + formfieldid + "span\" name=\"field_" + formfieldid + "span\" >");
                           sb.append(showValue);
                           sb.append("</span>\n\r</td></tr></table></td> ");
                           out.print(sb.toString());
                       %>

                   </tr>
                   <%} else if (StringHelper.isEmpty(formfieldid)) {%>

                   <%} else if (!StringHelper.isEmpty(formfieldid) && formfield.getHtmltype() == 5) {%>
                   <tr>
                       <td class="FieldName" nowrap>
                           <%=formfield.getLabelname()%>
                       </td>
                       <%
                           List list = selectitemService.getSelectitemList(formfield.getFieldtype(), null);
                           StringBuffer sb = new StringBuffer("");
                           sb.append("<input type=\"hidden\" name=\"field_"
                                   + formfieldid + "_fieldcheck\" value=\"" + formfield.getFieldcheck() + "\" >");
                           sb.append("<td class='FieldValue'>\n\r<select onchange='Selchange(this)'><option value=0 "+str5sel0+">请选择"+formfield.getLabelname()+"</option><option value=1 "+str5sel1+">获取其他字段的值</option></select>\n\r <select class=\"InputStyle2\" "+str5style+" id=\"con" + formfieldid + "_value\"  name=\"con" + formfieldid + "_value\"   onchange=\"fillotherselect(this,'" + formfieldid
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
                           sb.append("</select>\n\r" );
                           sb.append("<span name=\"con" + formfieldid + "_valuespan\" id=\"con" + formfieldid + "_valuespan\" "+str5stylespan+" >"+value+"</span> ");
                           sb.append("<input type=hidden name=\"con" + formfieldid + "_valuespan2\" id=\"con" + formfieldid + "_valuespan2\" >");

                           sb.append( "</td> ");
                           out.print(sb.toString());

                       %>
                   </tr>
                   <%} else {%>
                   <tr>
                       <td class="FieldName" nowrap>
                           <%=formfield.getLabelname()%>
                       </td>

                   <td class="FieldValue">
                       <table>
                           <tr>
                               <td>
                                 <select onchange="ChangeField(this)">
                                     <option value="0"><%=formfield.getLabelname()%></option>
                                     <option value="1">获取产品应字段值</option>
                                 </select>
                           </td></tr>
                           <tr><td>
                                <textarea rows="5" cols="50" id="con<%=formfieldid%>_value" name="con<%=formfieldid%>_value">
                           <%=StringHelper.null2String(showValue)%>       </textarea>

                           </td></tr>
                       </table>

                   </td>
                       </tr>
                   <%}%>
               </table>
	  </td>

</table>
 <div id="dialog0" style="display:none">
     <table cellspacing="0" rules="all" border="1" id="GridView1" style="background-color:White;border-collapse:collapse;" onclick="chkid(this)">
         <th scope="col"><b>字段显示名</b></th><th scope="col"><b>字段名</b></th>
        <%
            if(!StringHelper.isEmpty(formfieldid)){
            Formfield ff=formfieldService.getFormfieldById(formfieldid) ;
                String fieldtype=ff.getFieldtype();
                if(ff.getHtmltype()==6){
                    fieldtype="";
                }
            List listff=formfieldService.getFieldByForm(ff.getFormid(),ff.getHtmltype(),fieldtype);
            for(int i=0;i<listff.size();i++){
                Formfield formfielda=(Formfield)listff.get(i);
        %>
       <tr  id="tr<%=formfielda.getId()%>" ondblclick="ModClick('<%=formfielda.getId()%>');" ><td><%=formfielda.getLabelname()%></td><td><%=formfielda.getFieldname()%></td></tr>
         <%}}%>
    </table>
 </div>
</form>
      </div>
   <script type="text/javascript">
       function currtimeChange(obj){
           if(obj.value==0){
               document.all('con<%=formfield.getId()%>_value').value='';
           }else if(obj.value==1){
              document.all('con<%=formfield.getId()%>_value').value='$currenttime$'; 
           }else if(obj.value==2){
               dlg0.show();
           }

       }
       function currdateChange(obj){
           if(obj.value==0){
               document.all('con<%=formfield.getId()%>_value').value='';
           }else if(obj.value==1){
             document.all('con<%=formfield.getId()%>_value').value='$currentdate$';
           }else if(obj.value==2){
              dlg0.show();
           }
         }
       <%if(!StringHelper.isEmpty(sel1)||!StringHelper.isEmpty(sel2) ){%>
       document.all('field_<%=formfield.getId()%>button').style.display='none';
       <%}%>
       function curuserChange(obj){
           if(obj.value==0){
               document.all('field_<%=formfield.getId()%>button').style.display='block';
               document.all('con<%=formfield.getId()%>_value').value='';
               document.all('field_<%=formfield.getId()%>span').innerHTML='';
           }else if(obj.value==1){
               document.all('field_<%=formfield.getId()%>button').style.display='none';
               document.all('con<%=formfield.getId()%>_value').value='$currentuser$';
               document.all('field_<%=formfield.getId()%>span').innerHTML='$currentuser$';
           }else if(obj.value==2){
               document.all('field_<%=formfield.getId()%>button').style.display='none';
               document.all('con<%=formfield.getId()%>_value').value='$currentorgunit$';
               document.all('field_<%=formfield.getId()%>span').innerHTML='$currentorgunit$';
           }else if(obj.value==3){
              document.all('field_<%=formfield.getId()%>button').style.display='none';
               dlg0.show();
           }
       }
           getformfieldOptions('<%=formid%>');
       function getBrowser(viewurl, inputname, inputspan, isneed) {
        var id;
        try {
            id = getBrowser(contextPath + '/base/popupmain.jsp?url=' + viewurl);
        } catch(e) {
        }
        if (id != null) {
            if (id[0] != '0') {
                document.all(inputname).value = id[0];
                document.all(inputspan).innerHTML = id[1];
            } else {
                document.all(inputname).value = '';
                if (isneed == '0')
                    document.all(inputspan).innerHTML = '';
                else
                    document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
        }
    }
        function getformfieldOptions(formid){
         if (formid != "") {
           FormfieldService.getFieldByForm(formid,'','',callbackformfield);
        }
      }
      function callbackformfield(list) {
        DWRUtil.removeAllOptions("formfieldid");
        list.splice(0,0,{id:'0',labelname:'请选择字段'});
        DWRUtil.addOptions("formfieldid", list, "id", "labelname");
        var objselect = document.all("formfieldid");
        var selectLen = objselect.length;
        for (i = 0; i < selectLen; i++) {
            if (objselect.options[i].value == '<%=formfieldid%>') {
                objselect.options[i].selected = true;
                break;
            }
        }
    }
       function fieldchange(){
           var formfieldid = document.getElementById("formfieldid").value;
           if(formfieldid!='0')
          window.location="customactiondetailcreate.jsp?formfieldid="+formfieldid+"&formid=<%=formid%>&actionid=<%=actionid%>";
       }

       function onConfirm() {
           var formfieldid = document.getElementById("formfieldid").value;
           if(formfieldid=='0'){
           pop('请选择字段');
           return;
           }
           document.EweaverForm.submit();
           parent.dlg0.hide();
           parent.store.load({params:{start:0, limit:20}});
       }

        function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
            var idsin = document.all(inputname).value;
            var url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
                url = '<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
            }
    var id;
    try{
    id=openDialog(url,idsin);
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

	var sql ="<%=SQLMap.getSQLString("customaction/customactiondetailcreate.jsp")%>";
	DataService.getValues(sql,{
      callback:function(dataFromServer) {
        createList(dataFromServer, fieldcheck,rowindex);
      }
   }
	);

}

    function createList(data,fieldcheck,rowindex)
	{
		var select_array =fieldcheck.split(",");
		for(loop=0;loop<select_array.length;loop++){
			var objname = "con"+select_array[loop]+"_value";
			if(rowindex != -1)
				objname += "_"+rowindex;

			if(document.getElementById(objname) == null){
				return;
			}

			DWRUtil.removeAllOptions(objname);
		    DWRUtil.addOptions(objname, data,"id","objname");
		    fillotherselect(document.all(objname),select_array[loop],rowindex);
		}
	}
       function ChangeField(obj){
           if(obj.value==1){
               dlg0.show();
           }

       }
       var fid;
       function chkid(obj){
           for(var   i=0;i<obj.rows.length;i++)
            {
            if(i==event.srcElement.parentElement.rowIndex)
            {
            obj.rows(i).className="css2";
            }
            else
            obj.rows(i).className="css1";
            }

       }
       function ModClick(id){
              Ext.Ajax.request({
                     url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.customaction.servlet.CustomactionAction?action=getformfield',
                     params:{id:id},
                     success: function(res) {
                         if(res.responseText=='text'){
                             document.all('con<%=formfieldid%>_value').value='$'+id+'$';
                         }else if(res.responseText=='span'){
                               document.all('con<%=formfieldid%>_value').innerText='$'+id+'$';
                         }else if(res.responseText=='6span'){
                             document.all('con<%=formfieldid%>_value').value='$'+id+'$';
                             document.all('field_<%=formfield.getId()%>span').innerHTML='$'+id+'$';

                         }else if(res.responseText=='5span'){
                               document.all('con<%=formfieldid%>_valuespan2').value='$'+id+'$';
                             document.all('con<%=formfield.getId()%>_valuespan').innerHTML='$'+id+'$';
                         }
                     }
                 });
           dlg0.hide();
       }
       function Selchange(obj){
           if(obj.value==1){
               document.all('con<%=formfieldid%>_value').value='';
               document.all('con<%=formfieldid%>_value').style.display="none";
               document.all('con<%=formfieldid%>_valuespan').style.display="block";

                 dlg0.show();
           }else{
               document.all('con<%=formfieldid%>_valuespan2').value='';
                document.all('con<%=formfieldid%>_valuespan').innerHTML='';
               document.all('con<%=formfieldid%>_value').style.display="block";
               
           }
       }
   </script>

  </body>
</html>