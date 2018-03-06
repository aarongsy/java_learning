<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:directive.page import="javax.sql.DataSource"/>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
   String selectItemId = StringHelper.trimToNull(request.getParameter("selectitemid"));
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   List selectitemlist = selectitemService.getSelectitemList("402881ec0c68ca65010c68d4d68b000a",null);
   Selectitem selectitem;
    String moduleid=StringHelper.trimToNull(request.getParameter("moduleid"));
   if(!StringHelper.isEmpty(moduleid)){
       
   }
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
%>
<html>
  <head>
    <title><%=labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")%></title>
    <script>
    <%if(request.getParameter("issuccess")!=null){%>
        <%if(request.getParameter("issuccess").equals("1") || request.getParameter("issuccess").equals("3")){
        	String url="/workflow/form/forminfomodify.jsp?toField=true&id="+request.getParameter("formid")+"&moduleid="+moduleid;
        	out.println("parent.location.href='"+url+"';");
        	out.println("window.close();");
        	out.println("</script>");
        %>
        <%}else if(request.getParameter("issuccess").equals("2")){%>
             alert('<%=labelService.getLabelName("402880c018de680d0118deaeb832000c")%>');
        <%}%>
    <%}%>
	</script>
  <style type="text/css">
       .x-toolbar table {width:0}
       #pagemenubar table {width:0}
         .x-panel-btns-ct {
           padding: 0px;
       }
       .x-panel-btns-ct table {width:0}
   </style>
   
      <style type="text/css">
   #pagemenubar table {width:0}
  </style>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
  <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/engine.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/util.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js"></script>
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
	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=create" target="_self" name="EweaverForm"  method="post">
 <input type="hidden" value="<%=moduleid%>" name="moduleid">
		<table name="tbl1" id="tbl1">
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>		
				<tbody>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("297ee7020b338edd010b3390af720002")%>:
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="tbname"  onchange="checkInput('tbname','tbnamespan')" /><span id=tbnamespan name=tbnamespan><IMG src='<%=request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("297ee7020b338edd010b33919af10003")%>:
					</td>
					<td  class="FieldValue">
						<input style="width=95%" type="text" name="tbdesc"/>
					</td>
				</tr>
				<tr id="tablenametr">
					<td class="FieldName" nowrap><%=labelService.getLabelName("402881e90b36c0ac010b36c3f9fc0002")%>:</td>
					<td class="FieldValue">uf_<input style="width: 150px" MAXLENGTH="26" type="text" name="tablename" id="tablename"  onkeyup="value=value.replace(/[^\w]/ig,'')" /></td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402881e90b36c0ac010b36c21eed0001") %><!-- 表单类型 -->:
					</td>
					<td class="FieldValue">
						  <select name="tbType" id="tbType" onchange="changetbname()">
						  		<option value="1" ><%=labelService.getLabelName("402881e90b36c6a0010b36cd0f0c0003")%></option>
						  		<option value="0" selected><%=labelService.getLabelName("402881e90b36c6a0010b36cdc9fe0004")%></option>
						  		<option value="4"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370066") %><!-- 虚拟表单 --></option>
    					 </select>
    				</td>
				</tr>
                <tr id="purposetr">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370067") %><!-- 用途 -->:
					</td>
					<td class="FieldValue">
						  <select name="purpose" id="purpose">
						  		<option value="0" selected><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370068") %><!-- 普通 --></option>
                                <option value="1" ><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370069") %><!-- 交流 --></option>
                               <%-- <option value="2" >日程</option>--%>
    					 </select>
    				</td>
				</tr>
				
				<tr id="vitualForm" style="display:none">
					<td colspan="2">
					<table>
						<colgroup>
							<col width="20%">
							<col width="80%">
						</colgroup>
						<tr>
							<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006a") %><!-- 数据源 -->:</td>
							<%String[] names=BaseContext.getBeanNames(DataSource.class); %>
							<td class="FieldValue"><select onchange="DS.getTables(this);" id="vdatasource" name="vdatasource">
							<option value="">&nbsp;</option>
							<%for(String n:names)out.println("<option value=\""+n+"\">"+n+"</option>"); %>
							</select></td>
						</tr>
						<tr>
							<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006c") %><!-- 表名 --></td>
							<td class="FieldValue"><select onchange="DS.getFields(this);" id="vtableName" name="vtableName"></select></td>
						</tr>
						<tr>
							<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006d") %><!-- 字段列表 -->:
							<input type="checkbox" checked onclick="onCheckAll(this);" />
							</td>
							<td class="FieldValue"><ol id="dlist"></ol></td>
						</tr>
					</table>
				</tr>
				</tbody>
			</table> 

		</form>
<script language="javascript">
var select1,input1,tbl1;

   function onSubmit(){
   	<%--var checkfields="tbname";--%>
   	<%--checkmessage='<%=labelService.getLabelName("297ee7020b338edd010b3390af720002")%>:<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>';--%>
   	<%--if(!checkForm(EweaverForm,checkfields,checkmessage)){--%>
   		<%--return false;--%>
   	<%--}--%>

   	<%--checkfields="tablename";--%>
   	<%--var tbType=document.EweaverForm.tbType.value;--%>
   	<%--if(Number(tbType)==0)--%>
   	<%--{--%>
   	   <%--checkmessage='<%=labelService.getLabelName("402881e90b36c0ac010b36c3f9fc0002")%>:<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>';--%>
   	   <%--if(!checkForm(EweaverForm,checkfields,checkmessage)){--%>
   		  <%--return false;--%>
   	   <%--}--%>
   	<%--}--%>

    if(document.EweaverForm.tbname.value==''){
        alert("<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006e") %>.");//表单名称不能为空
        return false;
    }
    var tbType=Ext.getDom('tbType').value;
    if(tbType!='4' && tbType!=1 && document.getElementById('tablename').value==''){
        alert("<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006f") %>.");//数据库表名不能为空
        return false;
    }

	
   	if(tbType!='4' && document.getElementById('tablename').value.length>20){
        alert("<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380070") %>");//对不起,您设置的数据库表名长度超出了20个字符,请重置.
           return false;
    }
   	    document.EweaverForm.submit();

   }	

    function changetbname(){
        var tbtype = document.getElementById('tbType');
        var tablenametr = document.getElementById('tablenametr');
        var table = document.getElementById('tablename');
        var purposetr = document.getElementById('purposetr');
        if(tbtype.value==1 || tbtype.value=='4'){
            table.value ="";
            tablenametr.style.display = "none";
            purposetr.style.display = "none";
        }else{
            tablenametr.style.display = "";
            purposetr.style.display = "";
        }
		Ext.getDom('vitualForm').style.display=(tbtype.value=='4')?'':'none';
    }

var DS={
getTables:function(obj){
	var val=obj.value;
	Ext.getDom('vtableName').innerHTML='';
	Ext.getDom('dlist').innerHTML='';
	if(val!='0'){
		var opt=document.createElement('option');
		Ext.getDom('vtableName').add(opt);
		opt.value='0';opt.text=' ';
		FormfieldService.getTablesByDS(val,function(l){
			for(var i=0;i<l.length;i++){
				var opt=document.createElement('option');
				Ext.getDom('vtableName').add(opt);
				opt.value=l[i];opt.text=l[i];
			}
		});
	}
},
getFields:function(obj){
	var val=obj.value;
	Ext.getDom('dlist').innerHTML='';
	if(val!='0'){
		FormfieldService.getFieldsByTable(Ext.getDom('vdatasource').value,val,function(l){
			for(var i=0;i<l.length;i++){
				Ext.DomHelper.append('dlist',{tag:'li',html:'<input type="checkbox" value="'+l[i]+'" checked name="vfieldName"/>'+l[i]});
			}
		});
	}
}

};

function onCheckAll(o) {
	var vfieldObj = document.getElementsByName("vfieldName");
	if (vfieldObj != null && typeof(vfieldObj) != "undefined") {
        if (o.checked == true) {
            for (var i = 0 ; i < vfieldObj.length ; i++) {
                vfieldObj[i].checked = true;;
            }
        } else {
        	for (var i = 0 ; i < vfieldObj.length ; i++) {
        		vfieldObj[i].checked = false;;
            }
        }
	}
}

 </script>
  </body>
</html>