<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ include file="/base/init.jsp"%>
<%
String id = request.getParameter("id");
Forminfo forminfo = ((ForminfoService)BaseContext.getBean("forminfoService")).getForminfoById(id);
int objtype=forminfo.getObjtype();
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
List selectitemlist = selectitemService.getSelectitemList("402881ec0c68ca65010c68d4d68b000a",null);
Selectitem selectitem;
String selectItemId = forminfo.getSelectitemid();
String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
String isworkflow=StringHelper.null2String(request.getParameter("isworkflow"));
pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";//提交
pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";//返回
%>
<html>
<head>
<style type="text/css">
     #pagemenubar table {width:0}
</style>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script>
var contentPanel=null;
    Ext.onReady(function(){
        var cp = new Ext.state.CookieProvider({
       expires: new Date(new Date().getTime()+(1000*60*60*24*30))
   });
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>

     var c = new Ext.Panel({
               title:'<%=labelService.getLabelNameByKeyId("402881e50b8e316a010b8e6a55fb0008") %>',iconCls:Ext.ux.iconMgr.getIcon('application'),//表单信息
               layout: 'border',
               items: [{region:'center',autoScroll:true,contentEl:'ajaxcontentarea'}]
           });
     var moduletab=cp.get('moduletab');
     if(moduletab==undefined)
     moduletab=0;
        if(moduletab>0)
        moduletab=moduletab-1;
        moduletab=0;
     contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            activeTab:moduletab ,
            items:[c]
        });
        <%if(objtype!=1){%>
     var fieldPanel=addTab(contentPanel,'<%=request.getContextPath()%>/workflow/form/formfieldlist.jsp?forminfoid=<%=id%>&moduleid=<%=moduleid%>','<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b961f6f910008") %>','application_view_columns');//字段管理
     addTab(contentPanel,'<%=request.getContextPath()%>/workflow/form/formfieldlistexcel.jsp?forminfoid=<%=id%>','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380077") %>','application_view_list');//导入导出字段设置
        <%}%>
     addTab(contentPanel,'<%=request.getContextPath()%>/workflow/form/formlinklist.jsp?forminfoid=<%=id%>&moduleid=<%=moduleid%>','<%=labelService.getLabelNameByKeyId("402881ea0b9b879b010b9b9ae8820009") %>','application_cascade');//表单关系
     addTab(contentPanel,'<%=request.getContextPath()%>/workflow/form/formlayoutlist.jsp?forminfoid=<%=id%>','<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c7251b2340084") %>','application_osx');//表单布局


      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [contentPanel]
	});
	<%
	if("true".equalsIgnoreCase(request.getParameter("toField")) && objtype!=1){
		out.println("contentPanel.setActiveTab(fieldPanel);");
	}
	%>
    });
</script>
</head>
<body>
<div id="ajaxcontentarea">
    <div id="pagemenubar"></div>
	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=modify" target="_self" name="EweaverForm"  method="post">
			<input type=hidden name=id value="<%=forminfo.getId()%>" />
            <input type=hidden name=moduleid value="<%=forminfo.getModuleid()%>" />
		<table>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tr style="display:none;">
					<td class="FieldName" nowrap>
						 <%=labelService.getLabelName("402881e90bcbc9cc010bcbcb1aab0008")%>
					</td>
					<td class="FieldValue">
                    <input id="selectitemid" name="selectitemid" value='<%=selectItemId%>'>

					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("297ee7020b338edd010b3390af720002")%>:
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="tbname" value="<%=forminfo.getObjname()%>" onchange="checkInput('tbname','labelnamespan')"  /><span id=labelnamespan></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("297ee7020b338edd010b33919af10003")%>:
					</td>
					<td  class="FieldValue">
						<input style="width=95%" type="text" name="tbdesc" value="<%=StringHelper.null2String(forminfo.getObjdesc())%>" />
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402881e90b36c0ac010b36c21eed0001") %><!-- 表单类型 -->:
					</td>
					<td class="FieldValue">
						<% 
						String[] names=new String[]{labelService.getLabelName("402881e90b36c6a0010b36cdc9fe0004"),
						labelService.getLabelName("402881e90b36c6a0010b36cd0f0c0003"),"","",labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370066")};//虚拟表单
						%>
						<%=names[forminfo.getObjtype()]%>
						<input type="hidden" name="tbType" value="<%=forminfo.getObjtype()%>" />
    				</td>
				</tr>
				<% if(forminfo.getObjtype().intValue()==0){%>
                <tr id="oDiv">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370067") %><!-- 用途 -->:
					</td>
					<td class="FieldValue">
						<% if(StringHelper.null2String(forminfo.getCol1()).equals("1")){%><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370069") %><!-- 交流 --><%} else if(StringHelper.null2String(forminfo.getCol1()).equals("2")){%><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0000") %><!-- 日程 --><%} else {%><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370068") %><!-- 普通 --><%}%>
						<input style="width=95%" type="hidden" name="purpose" value="<%=forminfo.getCol1()%>"/>
					</td>
				</tr>
				<tr id="oDiv">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e90b36c0ac010b36c3f9fc0002")%>:
					</td>
					<td class="FieldValue">
						<%=forminfo.getObjtablename()%>
						<input style="width=95%" type="hidden" name="tablename" value="<%=forminfo.getObjtablename()%>"/>
					</td>
				</tr>
				<%}else if(forminfo.getObjtype()==4){
				%>	
				<tr>
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006a") %><!-- 数据源 -->:</td>
					<td class="FieldValue">
						<%=forminfo.getCol2()%>
						<input type="hidden" name="vdatasource" value="<%=forminfo.getCol2()%>"/>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006b") %><!-- 物理表名 -->:</td>
					<td class="FieldValue">
						<%=forminfo.getObjtablename()%>
						<input type="hidden" name="vtableName" value="<%=forminfo.getObjtablename()%>"/>
					</td>
				</tr>
				<%}%>
			</table>
        </form>
		</div>
    </body>
<script language="javascript">

   function saveexcelfield(formid){
       var fieldid="";
       var checkboxs=document.getElementsByName("checkboxs");
       for(var i=0;i<checkboxs.length;i++){
           if(checkboxs[i].type=="checkbox"&&checkboxs[i].checked==true){
               fieldid=fieldid+checkboxs[i].value+",";
           }
       }
       FormfieldService.saveExcelField(fieldid,formid,saveexcelfieldcallback);
   }

   function saveexcelfieldcallback(data){
       alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0001") %>");//导入导出字段已成功保存!
   }

   function choosecheckbox(){
       var chooseAll=document.getElementById("chooseAll");
       var checkboxs=document.getElementsByName("checkboxs");
       if(chooseAll.type=="checkbox"){
           if(chooseAll.checked==true){
               for(var i=0;i<checkboxs.length;i++){
                   if(checkboxs[i].type=="checkbox"){
                       checkboxs[i].checked=true;
                   }
               }
           }else{
               for(var i=0;i<checkboxs.length;i++){
                   if(checkboxs[i].type=="checkbox"){
                       checkboxs[i].checked=false;
                   }
               }
           }
       }
   }
   function onSubmit(){
   	checkfields="tbname";
   	checkmessage='<%=labelService.getLabelName("297ee7020b338edd010b3390af720002")%>:<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>';
   	if(!checkForm(EweaverForm,checkfields,checkmessage)){
   		return false;
   	}

   	document.EweaverForm.submit();
   }

   function onReturn(){
       <%if(StringHelper.isEmpty(isworkflow)){%>
     document.location.href="<%=request.getContextPath()%>/workflow/form/forminfolist.jsp?moduleid=<%=moduleid%>";
       <%}else{%>
       document.location.href="<%=request.getContextPath()%>/workflow/workflow/workflowinfolist.jsp?moduleid=<%=moduleid%>";

       <%}%>
   }
   function oncreateformfield(url,flag){
       var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
       if(flag=="excel"){
          tab5.fireEvent("onclick");
       }else{
          tab2.fireEvent("onclick");
       }
   }

   function oncreateformlink(url){
   	var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
   	tab3.fireEvent("onclick");
   }


   function oncreateformlayout(url){
   	var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+ url,window,
			"dialogHeight: "+screen.availHeight+"; dialogWidth: "+screen.availWidth+"; center: Yes; help: No; resizable: yes; status: No");
   	tab4.fireEvent("onclick");

   }

    function onDeleteFormfield(id){
	    if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){

		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=delete&id="+id;
		param.updatestring=id;
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");

	   	}

   		tab2.fireEvent("onclick");
   	}
    function onDeleteFormlink(id){
	    if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){

		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormlinkAction?action=delete&id="+id;
		param.updatestring=id;
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");

	   	}

   		tab3.fireEvent("onclick");
   	}

    function onDeleteFormlayout(id){
        document.getElementById("checkLayoutId").value=id;
        FormlayoutService.checkOptLayout(id,callback);
   	}

   	function callback(data){
        if(data!=null&&data!=""){
            alert(data);
        }else{
            var id=document.getElementById("checkLayoutId").value;
            FormlayoutService.getPermissionObj(id,showTable);
   	    }
   	}

    function showTable(data){
      if(data!="" && data!=null){
          sAlert(data);
      }else{
          var id=document.getElementById("checkLayoutId").value;
          showAlert(id);
      }
    }

    function addTable(data){
          var refreshBody=document.getElementById("refreshBody");
          DWRUtil.removeAllRows(refreshBody);//删除table的更新元素
          DWRUtil.addRows(refreshBody, data, [ getPermissionType,getCategoryName,getNodeinfoName,getWorkflowName,getOpttype,getOperateObj,toShow,toDelete ],//getCheck,getAllUnit是表的对应的列,
          {
             rowCreator:function(options) {//创建行，对其进行增添颜色
             var row = document.createElement("tr");
             var index = options.rowIndex * 50;
             row.style.color = "#999999";
             row.style.height = 20;
             return row;
             },
             cellCreator:function(options) {//创建单元格，对其进行增添颜色
             var td = document.createElement("td");
             var index = 255 - (options.rowIndex * 50);
             td.style.backgroundColor = "#f7f7f7";
             td.style.fontWeight = "bold";
             return td;
             }
          });
    }
//    var getObjid = function(data) { return '<a href="javascript:void(0)">'+data.objid+'</a>' };


       function showAlert(id){
	    if( confirm('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0002") %>')){//确定要删除您选择的布局吗?

		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormlayoutAction?action=delete&layoutid="+id;
		param.updatestring=id;
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");

	   	}

   		tab4.fireEvent("onclick");
   	}

    function showDiv(id,data){
        var obj=document.getElementById(id);
        var rect = GetAbsoluteLocation(obj);
        var top = rect.absoluteTop;
        var left = rect.absoluteLeft;
        var divObj=document.getElementById("showDivObj");
        document.getElementById("msg").innerHTML="&nbsp;"+data;

        document.getElementById("msg").style.width=data.length>42?data.length*11-30:data.length*12;
        divObj.style.top=top+20;
        if(data.length>40){
            divObj.style.left=left-260;
        }else{
            divObj.style.left=left-80;
        }
        divObj.style.display="block";
    }

    function goDelete(){
        var ruleids="";
        var allCheckBox = document.getElementsByName("unitCheck");
        for(i=0;i<allCheckBox.length;i++){
            if(allCheckBox[i].type=="checkbox"&&allCheckBox[i].checked==true){
                ruleids+=allCheckBox[i].value+",";
            }
        }
        if(ruleids==""||ruleids==null){
            alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0003") %>");//请选择需要删除的项!
        }else{
            FormlayoutService.deletepermissionrule(ruleids,deleteCallBack);
        }
    }

    function deleteCallBack(data){
        
        if(data=="ok"){
            var mychoose=document.getElementById("divObj");
            var mytable=document.getElementById("displayTable");
            mychoose.appendChild(mytable);
            var bgObj=document.getElementById("bgDiv");
            document.body.removeChild(bgObj);
            var msgObj=document.getElementById("msgDiv");
            document.body.removeChild(msgObj);

            var id=document.getElementById("checkLayoutId").value;
            FormlayoutService.getPermissionObj(id,showTable);
        }else{
            alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0004") %>");//删除失败,请重试!
        }
    }

</script>
</html>