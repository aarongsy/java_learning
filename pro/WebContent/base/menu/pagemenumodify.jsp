<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.menu.service.*"%>
<%@ page import="com.eweaver.base.menu.model.*"%>
<%@ page import="com.eweaver.customaction.service.CustomactionService" %>
<%@ page import="com.eweaver.customaction.model.Customaction" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.workflow.request.service.WorkflowService" %>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo" %>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%
    String id = StringHelper.null2String(request.getParameter("id"));
    PagemenuService pagemenuService = (PagemenuService) BaseContext.getBean("pagemenuService");
    SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
    CustomactionService customactionService = (CustomactionService) BaseContext.getBean("customactionService");
    CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
    WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
    NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");
     FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
    ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
    ReportdefService reportdefService=(ReportdefService)BaseContext.getBean("reportdefService");

    Pagemenu pagemenu=pagemenuService.getPagemenuById(id);
 String moduleid=StringHelper.null2String(pagemenu.getModuleid());
 String copymoduleid=StringHelper.null2String(request.getParameter("copymoduleid"));
 String iscopy=StringHelper.null2String(request.getParameter("iscopy"));
    String tourl=StringHelper.null2String(pagemenu.getTourl());
    tourl = tourl.replaceAll("\'", "\\\\\'");
    tourl = tourl.replaceAll("\n", "");
    tourl = tourl.replaceAll("\r", "");
    tourl = tourl.replaceAll("\t", "");
    tourl = tourl.replaceAll("\"", "\\\\\"");

    LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    if(StringHelper.isEmpty(iscopy))
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+"','B','delete',function(){onDelete('"+id+"')});";

    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<style type="text/css">
		#pagemenubar table {width:0}
		.dropdown .x-btn-left{background:url('');width:0;height:0}
		.dropdown .x-btn-center{background:url('')}
		.dropdown .x-btn-right{background:url('')}
		.dropdown .x-btn-center{text-align:left}
		.x-panel-btns-ct table {width:0}
		.t1 {COLOR: #cc0000; TEXT-DECORATION: underline}
		.x-window-dlg .ext-mb-error {
			background:transparent url('<%=request.getContextPath()%>/images/silk/right.gif') no-repeat scroll left top;
		}
		.x-toolbar table {width:0}
		.x-panel-btns-ct {
			padding: 0px;
		}
		.x-panel-btns-ct table {width:0}
		/*override skin/global.css*/
		button{
			color: #000;
		}
	</style>
 
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
      <script type="text/javascript">

      	//重定义多语言弹出窗口的宽度和高度
		labelDialogWidth = 500;
		labelDialogHeight = 250;
		
          var menutourl2;
        Ext.onReady(function() {

            Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>
        <%}%>
            Ext.EventManager.on("tourl", 'contextmenu', showMenu); //监听事件
            menutourl2 = new Ext.menu.Menu({
                id: 'mainMenutourl',
                items: [
                    {
                        text: '分类体系',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('pkg'),
                        checkHandler: onItemChecktourlcategory2
                    },
                    {
                        text: '流程',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('arrow_switch'),
                        checkHandler: onItemChecktourlworkflow2
                    },
                    {
                        text: '报表',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('application_osx'),
                        checkHandler: onItemChecktourlreport2
                    }
                ]
            });
            var menu = new Ext.menu.Menu({
                id: 'mainMenu',
                items: [
                    {
                        text: '分类体系',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('pkg'),
                        checkHandler: onItemCheck
                    },
                    {
                        text: '流程信息',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('arrow_switch'),
                        checkHandler: onItemCheck
                    },
                    {
                        text: '流程节点信息',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('application_osx'),
                        checkHandler: onItemChecknode
                    },
                    {
                        text: '表单布局',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('application_form'),
                        checkHandler: onItemCheckform
                    },
                    {
                        text: '报表',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('report'),
                        checkHandler: onItemCheckreport
                    },
                    {
                        text: '手动输入',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('page_portrait_shot'),
                        checkHandler: onItemCheckwrite
                    }
                ]
            });
            var tbmenu = new Ext.Button({
                text:'<font size=2>链接源</font>',
                menu : menu
            });
            tbmenu.render('menu');
            var menutourl = new Ext.menu.Menu({
                id: 'mainMenutourl',
                items: [
                    {
                        text: '分类体系',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('pkg'),
                        checkHandler: onItemChecktourlcategory
                    },
                    {
                        text: '流程',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('arrow_switch'),
                        checkHandler: onItemChecktourlworkflow
                    },
                    {
                        text: '报表',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('application_osx'),
                        checkHandler: onItemChecktourlreport
                    },{
                        text: '手动输入',
                        checked: false,
                        iconCls:Ext.ux.iconMgr.getIcon('page_portrait_shot'),
                        checkHandler: onItemChecktourlwrite
                    }
                ]
            });
            var tbmenutourl = new Ext.Button({
                text:'<font size=2>链接目标</font>',
                menu : menutourl
            });
            tbmenutourl.render('menutourl');

        });

            function onItemChecktourlcategory(item,checked){
             var objdiv=document.all('divtourl').innerHTML='<TEXTAREA STYLE="width:100%" class=InputStyle id="tourl" rows=10 name="tourl" style="display:none" ></TEXTAREA>';
                 getBrowsertourl('/base/category/categorybrowser.jsp', 'tourl','tourlspan', '1');
                document.all('tourltype').value=1;
             document.all('tourlspan').style.display='block';

             }
        function onItemChecktourlworkflow(item,text){
            var objdiv=document.all('divtourl').innerHTML='<TEXTAREA STYLE="width:100%" class=InputStyle id="tourl" rows=10 name="tourl" style="display:none"></TEXTAREA>';
                 getBrowsertourl('/workflow/workflow/workflowinfobrowser.jsp', 'tourl','tourlspan', '2');
                document.all('tourltype').value=2;
            document.all('tourlspan').style.display='block';


             }
      function onItemChecktourlreport(item,text){
          var objdiv = document.all('divtourl').innerHTML = '<TEXTAREA STYLE="width:100%" class=InputStyle id="tourl" rows=10 name="tourl" style="display:none"></TEXTAREA>';
          getBrowsertourl('/workflow/report/reportbrowser.jsp', 'tourl', 'tourlspan', '3');

          document.all('tourltype').value = 3;
          document.all('tourlspan').style.display = 'block';
             }
          function  onItemChecktourlwrite(item,checked){
              document.all('tourlspan').style.display = 'none';
               var objdiv = document.all('divtourl').innerHTML = '<TEXTAREA STYLE="width:100%" class=InputStyle id="tourl" rows=10 name="tourl" ><%=tourl%></TEXTAREA>';

              document.all('tourltype').value = 4;
          }
           function onItemCheckform(item,checked){
             var objdiv=document.all('pageM').innerHTML='<input type="hidden" class="InputStyle2" style="width:95%" name="pageprop" id="pageprop"/>';
                getBrowser2('/workflow/form/formlayoutbrowser.jsp', 'pageprop','pagepropspan', '1');
               document.all('proptype').value=5;
              document.all('pagepropspan').style.display='block';
                 document.all('objtable').value='formlayout';
                  document.all('objtable').readOnly=true;
               var showstyle=document.all('showstyle');
                  if(showstyle.options[1]==null){
                var oOption = document.createElement("OPTION");
                showstyle.options.add(oOption);
               oOption.innerText ="Tab页面";
               oOption.value = "2";}
          }
          function onItemCheckreport(item,checked){
             var objdiv=document.all('pageM').innerHTML='<input type="hidden" class="InputStyle2" style="width:95%" name="pageprop" id="pageprop"/>';
                getBrowser2('/workflow/report/reportbrowser.jsp', 'pageprop','pagepropspan', '1');
               document.all('proptype').value=6;
              document.all('pagepropspan').style.display='block';
                document.all('objtable').value='reportdef';
                  document.all('objtable').readOnly=true;
               var showstyle=document.all('showstyle');
             if(showstyle.options[1]!=null);
              showstyle.remove(1);
          }
          function onItemChecktourlcategory2(item, checked) {
              getid('/base/category/categorybrowser.jsp', 'tourl');

          }
          function onItemChecktourlworkflow2(item, text) {
              getid('/workflow/workflow/workflowinfobrowser.jsp', 'tourl');

          }
          function onItemChecktourlreport2(item, text) {
              getid('/workflow/report/reportbrowser.jsp', 'tourl');

          }

          function onItemCheck(item, checked) {
              if (item.text == "分类体系") {
                  var objdiv = document.all('pageM').innerHTML = '<input type="hidden" class="InputStyle2" style="width:95%" name="pageprop" id="pageprop"/>';
                  getBrowser2('/base/category/categorybrowser.jsp', 'pageprop', 'pagepropspan', '1');
                  document.all('proptype').value = 1;
                  document.all('pagepropspan').style.display = 'block';
                  document.all('objtable').value='category';
                  document.all('objtable').readOnly=true;
                  var showstyle=document.all('showstyle');
                  if(showstyle.options[1]==null){
                var oOption = document.createElement("OPTION");
                showstyle.options.add(oOption);
               oOption.innerText ="Tab页面";
               oOption.value = "2";
                  }
              }

              else if (item.text = '流程信息') {
                  var objdiv = document.all('pageM').innerHTML = '<input type="hidden" class="InputStyle2" style="width:95%" name="pageprop" id="pageprop"/>';
                  getBrowser2('/workflow/workflow/workflowinfobrowser.jsp', 'pageprop', 'pagepropspan', '1');
                  document.all('proptype').value = 2;
                  document.all('pagepropspan').style.display = 'block';
                    document.all('objtable').value='workflowinfo';
                  document.all('objtable').readOnly=true;
                  var showstyle=document.all('showstyle');
                 if(showstyle.options[1]==null){
                var oOption = document.createElement("OPTION");
                showstyle.options.add(oOption);
               oOption.innerText ="Tab页面";
               oOption.value = "2";
                  }

              }
          }
          function onItemChecknode(item, checked) {
              var objdiv = document.all('pageM').innerHTML = '<input type="hidden" class="InputStyle2" style="width:95%" name="pageprop" id="pageprop"/>';
              getBrowser2('/workflow/workflow/nodeinfobrowser.jsp', 'pageprop', 'pagepropspan', '1');
              document.all('proptype').value = 3;
              document.all('pagepropspan').style.display = 'block';
                document.all('objtable').value='nodeinfo';
                  document.all('objtable').readOnly=true;
              var showstyle=document.all('showstyle');
                 if(showstyle.options[1]==null){
                var oOption = document.createElement("OPTION");
                showstyle.options.add(oOption);
               oOption.innerText ="Tab页面";
               oOption.value = "2";
                  }

          }
          function onItemCheckwrite(item, checked) {
              document.all('pagepropspan').style.display = 'none';
              var objdiv = document.getElementById('pageM').innerHTML = '<input type="text" class="InputStyle2" style="width:95%" name="pageprop" id="pageprop" value="<%if("4".equals(pagemenu.getProptype())){%><%=StringHelper.null2String(pagemenu.getPageprop())%><%}%>"/>';
              document.all('proptype').value = 4;
                document.all('objtable').value='';
                  document.all('objtable').readOnly=false;
                   var showstyle=document.all('showstyle');
                  if(showstyle.options[1]==null){
                var oOption = document.createElement("OPTION");
                showstyle.options.add(oOption);
               oOption.innerText ="Tab页面";
               oOption.value = "2";}
          }
    </script>
  </head> 
  <body>

<div id="pagemenubar" style="z-index:100;"></div>
	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.PagemenuAction?action=modify" name="EweaverForm" method="post">
            <input type="hidden" name="iscopy" value="<%=iscopy%>">
            <input type="hidden" name="copymoduleid" value="<%=copymoduleid%>">
        <input type="hidden" class="InputStyle2" style="width:95%" id="proptype" name='proptype' value="<%=StringHelper.null2String(pagemenu.getProptype())%>"/>
            <input type="hidden" class="InputStyle2" style="width:95%" id="tourltype" name='tourltype' value="<%=StringHelper.null2String(pagemenu.getTourltype())%>"/>
            <input type="hidden" class="InputStyle2" style="width:95%" id="tourltext" name='tourltext' value="<%=StringHelper.null2String(pagemenu.getTourlspan())%>"/>



<table>
	<colgroup> 
		<col width="50%">
		<col width="50%">
	</colgroup>
    <%if(StringHelper.isEmpty(iscopy)){%>
	<input type="hidden" name="id" value="<%=pagemenu.getId()%>">
    <input type="hidden" name="moduleid" value="<%=pagemenu.getModuleid()%>">
    <%}else{%>
    <input type="hidden" name="id" value="">
    <%} %>
  <tr>
	<td valign=top width="100%">
		       <table class=noborder>
				<colgroup> 
					<col width="20%">
					<col width="80%">
				</colgroup>	


		        <tr>
					<td class="FieldName" nowrap>
					&nbsp;&nbsp;&nbsp;扩展名称
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:50%" name="showname" value="<%=StringHelper.null2String(pagemenu.getShowname())%>"/>
						<span id="objnamespan"/><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
						<% if(!StringHelper.isEmpty(pagemenu.getId())){ %>
							<%=labelCustomService.getLabelPicHtml(pagemenu.getId(), LabelType.Pagemenu) %>
						<% } %>
					</td>
				</tr>
                 <%if(StringHelper.isEmpty(iscopy)){%>
                   <!-- 去掉此标签ID, 此方式的页面扩展的国际化已废弃
			        <tr style="display:none">
						<td class="FieldName" nowrap>
						&nbsp;&nbsp;&nbsp;标签ID
						</td>
						<td class="FieldValue"> 
							<input type="text" class="InputStyle2" style="width:50%" name="labelid" value="<%=StringHelper.null2String(pagemenu.getLabelid())%>"/>
						</td>
					</tr> -->
                  <%}else{%>
                  		<!-- 去掉此标签ID, 此方式的页面扩展的国际化已废弃
                  		<input type="hidden" class="InputStyle2" style="width:50%" name="labelid" value=""/> -->
                  <%}%>
		        <tr>
					<td class="FieldName" nowrap>
                        <div id="menu" class="dropdown" align="left"></div>
					</td>
					<td class="FieldValue">
                                 <%
                                String pageprop=StringHelper.null2String(pagemenu.getPageprop());
                                String workflowname="";
                                Category category=new Category();
                                Nodeinfo nodeinfo=new Nodeinfo();
                                 String objstr="";
                              if("1".equals(pagemenu.getProptype())){  //分类
                                category=categoryService.getCategoryById(pageprop);
                                  objstr=category.getObjname();

                              }else if("2".equals(pagemenu.getProptype())){    //流程
                                   workflowname=workflowinfoService.getWorkflowName(pageprop) ;
                                   objstr=workflowname;
                              }else if("3".equals(pagemenu.getProptype())){     //节点
                                    nodeinfo=nodeinfoService.getNodeinfoDao().get(pageprop);
                                  objstr=nodeinfo.getObjname();
                                }else if("5".equals(pagemenu.getProptype())){
                                  Formlayout formlayout=formlayoutService.getFormlayoutById(pageprop);
                                    Forminfo forminfo=forminfoService.getForminfoById(formlayout.getFormid());
                                    objstr=formlayoutService.getFormlayoutById(pageprop).getLayoutname()+"("+forminfo.getObjname()+")";
                              }else if("6".equals(pagemenu.getProptype())){  //报表
                                  objstr=reportdefService.getReportdefNameById(pageprop);
                              }else{    //自动输入
                                   objstr=StringHelper.null2String(pagemenu.getPageprop());
                                    }
                                     %>
                        <span id="pagepropspan"><%=StringHelper.null2String(objstr)%></span>
                               <div id="pageM" >
                            <input type="hidden" class="InputStyle2" style="width:95%" name="pageprop" id="pageprop" value="<%=StringHelper.null2String(pagemenu.getPageprop())%>"/>
                        </div>
					</td>
				</tr>
                    <tr>
					<td class="FieldName" nowrap>
					&nbsp;&nbsp;&nbsp;自定义菜单动作
					</td>
					<td class="FieldValue">
						 <input type="button"  class=Browser onclick="javascript:getBrowser('/customaction/customactionbrowser.jsp','customid','customidspan','1');" />
                         <input type="hidden"   name="customid" value="<%=pagemenu.getCustomactionid()%>" />
                         <span id = "customidspan" >
                             <%
                               Customaction customaction=customactionService.getCustomaction(pagemenu.getCustomactionid());
                             %>
                             <%=StringHelper.null2String(customaction.getObjname())%>
                         </span>
					</td>
				</tr>
                    <tr>
					<td class="FieldName" nowrap>
					  &nbsp;&nbsp;&nbsp;显示样式
					</td>
					<td class="FieldValue">
						<select id="showstyle" name="showstyle" onchange=" showstylechange(this.options[this.options.selectedIndex].value)">
                            <%
                            String selected1="";
                             String selected2="";
                                if("2".equals(pagemenu.getShowstyle())){
                                    selected2="selected";
                                }else{
                                   selected1="selected";
                                }
                            %>
                            <option value="1" <%=selected1%>>页面按钮</option>
                            <%
                              if(!"6".equals(pagemenu.getPageprop())){
                            %>
                            <option value="2" <%=selected2%>>Tab页面</option>
                            <%}%>
						</select>
					</td>
				</tr>
                     <tr id="btntr">
					<td class="FieldName" nowrap>
					  &nbsp;&nbsp;&nbsp;页面按钮形式
					</td>
					<td class="FieldValue">
                        <%
                            String selbtn1="";
                            String selbtn2="";
                            String selbtn3="";
                            if(pagemenu.getBtnshowstyle()==null||pagemenu.getBtnshowstyle()==""){
                               selbtn3="selected";
                            }else{
                                if("1".equals(pagemenu.getBtnshowstyle())){
                                  selbtn1="selected";
                                }else if("2".equals(pagemenu.getBtnshowstyle())){
                                     selbtn2="selected";
                                }else if("3".equals(pagemenu.getBtnshowstyle())){
                                   selbtn3="selected";
                                }
                            }

                        %>
						<select id="btnshowstyle" name="btnshowstyle">
                            <option value="1" <%=selbtn1%>>新的Tab页</option>
                            <option value="2" <%=selbtn2%>>弹出窗口</option>
                            <option value="3" <%=selbtn3%>>其他形式</option>
						</select>
					</td>
				</tr>
                <%
                 if(!StringHelper.isEmpty(pagemenu.getCustomactionid())){
                %>
                <tr id="tractionuse">
                    <%}else{%>
                <tr id="tractionuse" style="display:none">
                    <%}%>
                    <td class="FieldName" nowrap>
                      &nbsp;&nbsp;&nbsp;自定义菜单用于
                    </td>
                    <td class="FieldValue">
                        <%
                            String selaction1="";
                            String selaction2="";
                           if(pagemenu.getActionuse()==1){
                               selaction2="selected";
                           }else{
                                selaction1="selected";
                           }

                        %>
                        <select id="actionuse" name="actionuse" onchange="ActionUsageChange(this)">
                            <option value="0" <%=selaction1%>>修改单张卡片</option>
                            <option value="1" <%=selaction2%>>报表批量修改</option>
                        </select>
                    </td>

                </tr>
		        <tr>
					<td class="FieldName" nowrap>
                        <div id="menutourl" class="dropdown" align="left"></div>
					</td>
					<td class="FieldValue">
                                 <%
                                   boolean flag=!StringHelper.isEmpty(pagemenu.getCustomactionid());
                                     if(pagemenu.getTourltype()==null||pagemenu.getTourltype()==""){
                                         flag=true;
                                     }else {
                                         if(pagemenu.getTourltype().equals("4")){
                                             flag=true;
                                         }
                                     }
                                 %>
                        <div id="divtourl">
						<TEXTAREA <%if(flag){%>STYLE="width:100%"<%}else{%> STYLE="width:100%;display:none"<%}%>class=InputStyle rows=10 id="tourl" name="tourl" readonly="true"><%=StringHelper.null2String(pagemenu.getTourl())%>
                     	</TEXTAREA>
                         </div>
                          <%
                          String tourltype=StringHelper.null2String(pagemenu.getTourltype());
                           String tourlspan=StringHelper.null2String(pagemenu.getTourlspan());
                              String str="";
                              if("1".equals(tourltype)){  //分类体系
                                 str=categoryService.getCategoryById(tourlspan).getObjname();
                              }else if("2".equals(tourltype)){  //流程
                                 str=workflowinfoService.getWorkflowName(tourlspan);
                              }else if("3".equals(tourltype)){   //报表
                                 str=reportdefService.getReportdefNameById(tourlspan);
                              }else{       //手动输入
                                 str=pagemenu.getTourl();
                              }
                          %>
                        <span id="tourlspan"  <%if(flag){%> style="display:none"<%}%>><%=StringHelper.null2String(str)%></span>

					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap></td>
					<td class="FieldValue">当前用户：{currentuserid}，当前部门：{curorgid}</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap></td>
					<td class="FieldValue">当前日期：{currentdate}，当前时间：{currenttime}，当前年份：{currentyear}</td>
				</tr>
                   <tr>
                       <td  class="FieldName" nowrap></td>
                       	<td class="FieldValue">'/'=%2F  '?'=%3F  '&'=%26  ' '=+  '='=%3D</td>
                   </tr>
		        <tr>
					<td class="FieldName" nowrap>
					&nbsp;&nbsp;&nbsp;快捷键
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:20%" name="accesskey" value="<%=StringHelper.null2String(pagemenu.getAccesskey())%>"/>
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					&nbsp;&nbsp;&nbsp;关联ID
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:50%" name="objid" value="<%=StringHelper.null2String(pagemenu.getObjid())%>"/>
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					&nbsp;&nbsp;&nbsp;关联表名
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:50%" name="objtable" value="<%=StringHelper.null2String(pagemenu.getObjtable())%>" readonly="true"/>
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					&nbsp;&nbsp;&nbsp;所需权限
					</td>
					<td class="FieldValue">
     <SELECT class="InputStyle2"  name=righttype id="righttype">
         <option value="0" <%if("".equals(pagemenu.getRighttype())){%>selected="selected" <%}%>>未选择</option>
       <%
        	List list = selectitemService.getSelectitemList("402880371fb07b8d011fb0889c890002",null);

           for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		//非类型设置不允许给创建权限。

        %>

          <option value="<%=optcode%>" <%if(optcode.equals(pagemenu.getRighttype())){%>selected="selected" <%}%>><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%
          }
          %>
      </SELECT>
					</td>
				</tr>
                <tr>
					<td class="FieldName" nowrap>
						&nbsp;&nbsp;&nbsp;所选图片
					</td>
					<td class="FieldValue">
						<input style="width:80%" type="text" name="imagfile" id="imagfile"  value="<%=StringHelper.null2String(pagemenu.getImgfile())%>"/>
						<img id="imgFilePre" src="<%=StringHelper.null2String(pagemenu.getImgfile())%>" />
						<a href="javascript:;" onclick="BrowserImages(function(n){if(!n)return;document.getElementById('imagfile').value=n;document.getElementById('imgFilePre').src=contextPath+n;});">浏览..</a>
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					&nbsp;&nbsp;&nbsp;显示顺序
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:20%" name="dsporder" value="<%=StringHelper.null2String(pagemenu.getDsporder())%>"/>
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					&nbsp;&nbsp;&nbsp;是否显示
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:20%" name="isshow" value="<%=StringHelper.null2String(pagemenu.getIsshow())%>"/>
					</td>
				</tr>
				
				<tr>
					<td class="FieldName" nowrap>
					&nbsp;&nbsp;&nbsp;显示条件
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle" STYLE="width:100%;text-align:left" id="col1" name="col1"  value="<%=StringHelper.null2String(pagemenu.getCol1())%>"/>
						
					</td>
				</tr>

			 </table>
	  </td>

</table>
</form>
<script language="javascript">
     function getBrowsertourl(viewurl, inputname,inputnamespan, str) {
        var id;
        try {
            id = openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>' + viewurl);
        } catch(e) {
        }
        if (id != null) {
            if (id[0] != '0') {
                if(str==1){
                   document.all(inputname).innerHTML="/workflow/request/formbase.jsp?categoryid="+id[0];
                     document.all('tourltext').value=id[0];
                    document.all(inputnamespan).innerHTML=id[1];
                }else if(str==2){
                    document.all(inputname).innerHTML="/workflow/request/workflow.jsp?workflowid="+id[0];
                     document.all('tourltext').value=id[0];
                    document.all(inputnamespan).innerHTML=id[1];

                }else if(str==3){
                    document.all(inputname).innerHTML="/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase="+id[2]+"&reportid="+id[0];
                     document.all('tourltext').value=id[0];
                    document.all(inputnamespan).innerHTML=id[1];
                }
            } else {
                readonlyfalse();
        		document.all(inputname).value = '';
        		document.all('tourltext').value = '';
        		document.all(inputnamespan).innerHTML = '';
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
     document.all('tractionuse').style.display='block';
        readonlytrue(0);
    }else{
        document.all('tractionuse').style.display='none';
        readonlyfalse();
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';


            }
         }
 }
     function ActionUsageChange(obj){
         readonlytrue(obj.value);
     }
      function readonlytrue(value){
          if (value == 0) {
              document.all("tourl").value = "javascript:doAction('{id}','{customactionid}')";
          } else {
              document.all("tourl").value = "javascript:doAction('{customactionid}')";
          }
          document.all("tourl").readOnly = true;
          document.all("tourl").style.display = 'block';
          document.all("tourlspan").style.display = 'none';

      }
      function readonlyfalse(){
            document.all("tourl").value="";
            document.all("tourl").readOnly=false;
          document.all("tourl").style.display='block';
          document.all("tourlspan").style.display='none';


      }
      function onReturn(){
     document.location.href="<%=request.getContextPath()%>/base/menu/pagemenulist.jsp?moduleid=<%=moduleid%>";
   }
function onSubmit(){
   	checkfields="showname";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}    
   function onDelete(id){
           Ext.Msg.buttonText={yes:'是',no:'否'};
              Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
                  if (btn == 'yes') {
                      Ext.Ajax.request({
                          url: ' <%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.PagemenuAction?action=delete&id='+id,
                          success: function() {
                              this.location.href="<%=request.getContextPath()%>/base/menu/pagemenulist.jsp?moduleid=<%=moduleid%>";
                          }
                      });
                  } 
              });
   }
   function BrowserImages(_callback){
	var ret=openDialog("<%=request.getContextPath()%>/base/menu/iconsBrowser.jsp?p=/silk");
	_callback(ret);
}
                 function getBrowser2(viewurl,inputname,inputspan,isneed){
    var id;
    try{
        id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
    document.getElementById(inputname).value =id[0];
        document.getElementById(inputspan).innerHTML =id[1];

    }else{
		document.all(inputname).value = '';
        document.getElementById(inputspan).innerHTML ='';

            }
         }
 }
     function getid(viewurl, inputname) {
         var id;
         try {
             id = openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>' + viewurl);
         } catch(e) {
         }
         if (id != null) {
             if (id[0] != '0') {
                 section.text = id[0];
             } else {
                 document.all(inputname).value = '';
             }
         }
     }
     var section = null;
     function showMenu(e) {
         e.preventDefault();
         section = document.selection.createRange();  //获得鼠标所选中的区域
         var target = e.getTarget();
         menutourl2.show(target);
         var pos = e.getXY();
         menutourl2.showAt(pos);
     }
     showstylechange(<%=pagemenu.getShowstyle()%>);
  function showstylechange(value){
        var btntr=document.all("btntr");
        if(value==1){
              btntr.style.display='';
        }else{
            btntr.style.display='none';

        }
    }
</script> 
  </body>
</html>
