<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunitlink"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunittypeService"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%
    OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
    OrgunittypeService orgunittypeService = (OrgunittypeService)BaseContext.getBean("orgunittypeService");
    SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
    String moduleid=StringHelper.trimToNull(request.getParameter("moduleid"));
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<style type="text/css">
		a { color:blue; cursor:pointer; }
		.x-toolbar table {width:0}
		#pagemenubar table {width:0}
		.x-panel-btns-ct {
	    	padding: 0px;
		}
		.dropdown .x-btn-left{background:url('');width:0;height:0}
		.dropdown .x-btn-center{background:url('')}
		.dropdown .x-btn-right{background:url('')}
		.dropdown .x-btn-center{text-align:left}
		.x-panel-btns-ct table {width:0}
		.t1 {COLOR: #cc0000; TEXT-DECORATION: underline}
		.x-window-dlg .ext-mb-error {
			background:transparent url('<%=request.getContextPath()%>/images/silk/right.gif') no-repeat scroll left top;
		}
		#pagemenubar table {width:0}
		/*override skin/global.css*/
		button{
			color: #000;
		}
	</style>
  
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
      <script type="text/javascript">
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
            }, {
                text: '表单布局',
                 checked: false,
                iconCls:Ext.ux.iconMgr.getIcon('application_form'),
                checkHandler: onItemCheckform
            }, {
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
            }]
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
                    },
                    {
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
              var objdiv = document.all('divtourl').innerHTML = '<TEXTAREA STYLE="width:100%" class=InputStyle id="tourl" rows=10 name="tourl" ></TEXTAREA>';
              document.all('tourltype').value = 4;
          }

                 function onItemChecktourlcategory2(item,checked){
                getid('/base/category/categorybrowser.jsp', 'tourl');

             }
        function onItemChecktourlworkflow2(item,text){
               getid('/workflow/workflow/workflowinfobrowser.jsp', 'tourl');

             }
      function onItemChecktourlreport2(item,text){
                 getid('/workflow/report/reportbrowser.jsp', 'torul');

             }
        function onItemCheck(item, checked) {
            if (item.text == "分类体系"){
                var objdiv=document.all('pageM').innerHTML='<input type="hidden" class="InputStyle2" style="width:95%" name="pageprop" id="pageprop"/>';
                  getBrowser2('/base/category/categorybrowser.jsp', 'pageprop','pagepropspan', '1');
                document.all('proptype').value=1;
                document.all('pagepropspan').style.display='block';
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

            else if (item.text = '流程信息'){
                var objdiv=document.all('pageM').innerHTML='<input type="hidden" class="InputStyle2" style="width:95%" name="pageprop" id="pageprop"/>';
                getBrowser2('/workflow/workflow/workflowinfobrowser.jsp', 'pageprop','pagepropspan', '1');
                 document.all('proptype').value=2;
                document.all('pagepropspan').style.display='block';
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
          function onItemChecknode(item,checked){
              var objdiv=document.all('pageM').innerHTML='<input type="hidden" class="InputStyle2" style="width:95%" name="pageprop" id="pageprop"/>';
                getBrowser2('/workflow/workflow/nodeinfobrowser.jsp', 'pageprop','pagepropspan', '1');
               document.all('proptype').value=3;
              document.all('pagepropspan').style.display='block';
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
               oOption.value = "2";
                  }
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
          function onItemCheckwrite(item,checked){
              document.all('pagepropspan').style.display='none';
              var objdiv=document.all('pageM').innerHTML='<input type="text" class="InputStyle2" style="width:95%" name="pageprop" id="pageprop"/>';
               document.all('proptype').value=4 ;
                document.all('objtable').value='';
                document.all('objtable').readOnly=false;
               var showstyle=document.all('showstyle');
                  if(showstyle.options[1]==null){
                var oOption = document.createElement("OPTION");
                showstyle.options.add(oOption);
               oOption.innerText ="Tab页面";
               oOption.value = "2";
                  }
        }
    </script>
  </head> 
  <body>
<div id="pagemenubar" style="z-index:100;"></div> 
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.PagemenuAction?action=create" name="EweaverForm" method="post">
        <input type="hidden" value="<%=moduleid%>" name="moduleid">
    <input type="hidden" class="InputStyle2" style="width:95%" name="proptype" id="proptype" value=""/>
    <input type="hidden" class="InputStyle2" style="width:95%" name="tourltype" id="tourltype" value=""/>
    <input type="hidden" class="InputStyle2" style="width:95%" name="tourltext" id="tourltext" value=""/>


<table>
	<colgroup> 
		<col width="50%">
		<col width="50%">
	</colgroup>	
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
						<input type="text" class="InputStyle2" style="width:50%" name="showname"/>
						<span id="objnamespan"/><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
					</td>
				</tr>
				<!-- 去掉此标签ID, 此方式的页面扩展的国际化已废弃
		        <tr>
					<td class="FieldName" nowrap>
					  &nbsp;&nbsp;&nbsp;标签ID
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:50%" name="labelid"/>
					</td>
				</tr> -->
				
		        <tr>
					<td class="FieldName" nowrap>
                         <div id="menu" class="dropdown" align="left"></div>
					</td>
					<td class="FieldValue">
                             <span id="pagepropspan" ></span>
                        <div id="pageM">

                            <input type="hidden" class="InputStyle2" style="width:95%" name="pageprop" id="pageprop"/>

                        </div>
					</td>
				</tr>
                    <tr>
					<td class="FieldName" nowrap>
					  &nbsp;&nbsp;&nbsp;自定义菜单动作
					</td>
					<td class="FieldValue">
						 <input type="button"  class=Browser onclick="javascript:getBrowser('/customaction/customactionbrowser.jsp','customid','customidspan','1');" />
                         <input type="hidden"   name="customid" value="" />
                         <span id = "customidspan" >
                         </span>
					</td>
				</tr>
                   <tr>
					<td class="FieldName" nowrap>
					  &nbsp;&nbsp;&nbsp;显示样式
					</td>
					<td class="FieldValue">
						<select id="showstyle" name="showstyle" onchange="showstylechange(this)">
                            <option value="1">页面按钮</option>
                            <option value="2">Tab页面</option>
						</select>
					</td>
				</tr>
                    <tr id="btntr">
					<td class="FieldName" nowrap>
					  &nbsp;&nbsp;&nbsp;页面按钮形式
					</td>
					<td class="FieldValue">
						<select id="btnshowstyle" name="btnshowstyle">
                            <option value="1">新的Tab页</option>
                            <option value="2">弹出窗口</option>
                            <option value="3">其他形式</option>
						</select>
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
                        <div id="menutourl" class="dropdown" align="left"></div>
					</td>
					<td class="FieldValue">
                        <div id="divtourl">
						<TEXTAREA STYLE="width:100%" class=InputStyle id="tourl" rows=10 name="tourl" >
                     	</TEXTAREA>
                         </div>
                        <span id="tourlspan">

                        </span>
                     	'/'=%2F  '?'=%3F  '&'=%26  ' '=+  '='=%3D
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					  &nbsp;&nbsp;&nbsp;快捷键
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:20%" name="accesskey"/>
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					  &nbsp;&nbsp;&nbsp;关联Id
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:50%" name="objid"/>
					</td>
				</tr>				
		        <tr>
					<td class="FieldName" nowrap>
					  &nbsp;&nbsp;&nbsp;关联表名
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:50%" name="objtable" readonly="true"/>
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					  &nbsp;&nbsp;&nbsp;所需权限
					</td>
					<td class="FieldValue" nowrap>
     <SELECT class="InputStyle2"  name=righttype id="righttype">
         <option value="0">未选择</option>
       <%
        	List list = selectitemService.getSelectitemList("402880371fb07b8d011fb0889c890002",null);

           for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		//非类型设置不允许给创建权限。

        %>

          <option value="<%=optcode%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
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
						<input style="width:80%" type="text" name="imagfile" id="imagfile"/>
						<img id="imgFilePre"/>
						<a href="javascript:;" onclick="BrowserImages(function(n){if(!n)return;document.getElementById('imagfile').value=n;document.getElementById('imgFilePre').src=contextPath+n;});">浏览..</a>
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					  &nbsp;&nbsp;&nbsp;显示顺序
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:20%" value="1" name="dsporder"/>
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					  &nbsp;&nbsp;&nbsp;是否显示
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:20%" value="1" name="isshow"/>
					</td>
				</tr>

			 </table>
	  </td>
</table>
</form>
<script language="javascript">
    function getBrowsertourl(viewurl, inputname,inputnamespan,str) {
        var id;
        try {
            id = openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>' + viewurl);
        } catch(e) {
        }
        if (id != null) {
            if (id[0] != '0') {
                if(str==1){
                   document.all(inputname).innerHTML="/workflow/request/formbase.jsp?categoryid="+id[0];
                    document.all(inputnamespan).innerHTML=id[1];
                    document.all('tourltext').value=id[0];

                }else if(str==2){
                    document.all(inputname).innerHTML="/workflow/request/workflow.jsp?workflowid="+id[0];
                       document.all(inputnamespan).innerHTML=id[1];
                    document.all('tourltext').value=id[0];

                    
                }else if(str==3){
                    document.all(inputname).innerHTML="/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase="+id[2]+"&reportid="+id[0];
                       document.all(inputnamespan).innerHTML=id[1];
                    document.all('tourltext').value=id[0];

                }
            } else {
                document.all(inputname).value = '';

            }
        }
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
      function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
        readonlytrue();
    }else{
        readonlyfalse();
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';


            }
         }
 }
      function readonlytrue(){
            document.all("tourl").value="javascript:doAction('{id}','{customactionid}')";
            document.all("tourl").readOnly=true;
      }
      function readonlyfalse(){
            document.all("tourl").value="";
            document.all("tourl").readOnly=false;
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
function BrowserImages(_callback){
	var ret=openDialog("<%=request.getContextPath()%>/base/menu/iconsBrowser.jsp?p=/silk");
	_callback(ret);
}
        function getid(viewurl,inputname){
    var id;
    try{
        id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
      section.text=id[0];
    }else{
		document.all(inputname).value = '';
            }
         }
 }
    var section=null;
  function showMenu(e){
    e.preventDefault();
    section=document.selection.createRange();  //获得鼠标所选中的区域
    var target = e.getTarget();
	menutourl2.show(target);
	var pos=e.getXY();
	menutourl2.showAt(pos);
}
    function showstylechange(obj){
        var btntr=document.all("btntr");
        if(obj.value==1){
              btntr.style.display='';
        }else{
            btntr.style.display='none';

        }
    }
</script>
  </body>
</html>
