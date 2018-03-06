<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ include file="/base/init.jsp"%>
<%
ModuleService moduleService =(ModuleService)BaseContext.getBean("moduleService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
String id=StringHelper.null2String(request.getParameter("id"));
  String isnewmodule=StringHelper.null2String(request.getParameter("isnewmodule"));
Module module=moduleService.getModule(id);
    String pid = StringHelper.trimToNull(request.getParameter("pid"));
if(pid != null){
	if(pid.equalsIgnoreCase("r00t"))
		pid = null;
}
if(pid == null)
	pid = module.getPid();
 pagemenustr =  "addBtn(tb,'确定','S','accept',function(){EditOK()});";
%>
<html>
<head>
<style type="text/css">
     #pagemenubar table {width:0}
</style>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script>
    Ext.SSL_SECURE_URL='about:blank';
    Ext.onReady(function(){
        var cp = new Ext.state.CookieProvider({
       expires: new Date(new Date().getTime()+(1000*60*60*24*30))
   });
 <%if(module.getId()!=null||!StringHelper.isEmpty(isnewmodule)){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>

     var c = new Ext.Panel({
               title:'模块定义',iconCls:Ext.ux.iconMgr.getIcon('config'),
               layout: 'border',
               items: [{region:'center',autoScroll:true,contentEl:'divSum'}]
           });
      <%}%>
     var moduletab=cp.get('moduletab');
     if(moduletab==undefined)
     moduletab=0;
     <%if(module.getId()==null){%>
        if(moduletab>0)
        moduletab=moduletab-1;
        <%}%>
     <%if(!StringHelper.isEmpty(isnewmodule)){%>
        moduletab=0;
        <%}%>
     var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            activeTab:moduletab <%if(module.getId()!=null||!StringHelper.isEmpty(isnewmodule)){%>,
            items:[c]
           <%}%>
        });
       <%if(StringHelper.isEmpty(isnewmodule)){%>
     addTab(contentPanel,'<%=request.getContextPath()%>/base/selectitem/selectitemtypelist.jsp?moduleid=<%=module.getId()%>','select字段维护','page_portrait');
     addTab(contentPanel,'<%=request.getContextPath()%>/base/refobj/refobjlist.jsp?moduleid=<%=module.getId()%>','browser框字段维护','page_paintbrush');
     addTab(contentPanel,'<%=request.getContextPath()%>/workflow/form/forminfolist.jsp?moduleid=<%=module.getId()%>','表单','application_form');
     addTab(contentPanel,'<%=request.getContextPath()%>/base/category/categorymanager.jsp?moduleid=<%=module.getId()%>','分类','pkg');
     addTab(contentPanel,'<%=request.getContextPath()%>/workflow/workflow/workflowinfolist.jsp?moduleid=<%=module.getId()%>','流程','arrow_switch');
     addTab(contentPanel,'<%=request.getContextPath()%>/workflow/report/reportdeflist.jsp?moduleid=<%=module.getId()%>','报表','report');
     addTab(contentPanel,'<%=request.getContextPath()%>/base/menu/pagemenulist.jsp?moduleid=<%=module.getId()%>','页面扩展','button');
     addTab(contentPanel,'<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerListAction?moduleid=<%=module.getId()%>','树形设置','outline');
     addTab(contentPanel,'<%=request.getContextPath()%>/base/menu/menumanager.jsp?menutype=2&moduleid=<%=StringHelper.null2String(module.getId())%>','菜单','application_side_tree');
        contentPanel.items.each(function(it,index,length){
         it.on('activate',function(p){
             if(length==8)
             cp.set('moduletab',index+1);
             else
             cp.set('moduletab',index);
            
        })
     });

    <%}%>
      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [contentPanel]
	});
   
    })
</script>
</head>
<body>
<div id="divSum">
<div id="pagemenubar"> </div>
	<form id="eweaverForm">           
  	<table>
	<!-- 列宽控制 -->
				<colgroup>
					<col width="20%">
					<col width="">
				</colgroup>
				<% if(module.getId() != null){%>
				<tr>
					<td class="FieldName" nowrap>id</td>
					<td class="FieldValue"><%=StringHelper.null2String(module.getId())%></td>
				</tr>
				<%}%>
				<input type="hidden" name="id" id="id"  value="<%=StringHelper.null2String(module.getId())%>" />
				<tr >
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						labelid
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width:50%" type="text" name="labelid" id="labelid" value="<%=StringHelper.null2String(module.getLabelid())%>"/>
						<%=labelService.getLabelName(module.getLabelid())%>
					</td>
				</tr>
                 <tr style="display:none">
				<!-- 变量名列 -->
					<td class="FieldName" nowrap>
						pid
					</td>
				<!-- 输入框列 必输入 -->
					<td class="FieldValue">
						<input style="width=50%" type="text" name="pid" id="pid"  value="<%=StringHelper.null2String(pid)%>"/>
						<input type="hidden" name="oid"  id="oid" value="<%=StringHelper.null2String(pid)%>"/>
					</td>
				</tr>
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						模块名称
					</td>
				<!-- 输入框列 必输入 -->	
					<td class="FieldValue">
						<input style="width:50%" type="text" name="objname"  id="objname" value="<%=StringHelper.null2String(module.getObjname())%>" onChange="checkInput('objname','objnamespan')" onkeypress="checkQuotes_KeyPress()"/>
						<span id="objnamespan" name="objnamespan"/>
						<% if(StringHelper.null2String(module.getObjname()).equals("")){%>
						<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>
						<%}%>

						<% if(module.getId()!= null){%>
							<%=labelCustomService.getLabelPicHtml(module.getId(), LabelType.Module) %>
						<%} %>
						</span>
					</td>
				</tr>
				<tr>
				<!-- 变量名列 -->	
					<td class="FieldName" nowrap>
						显示顺序
					</td>
				<!-- 输入框列 -->	
					<td class="FieldValue">
						<input style="width:10%" type="text" name="dsporder" id="dsporder" value="<%=StringHelper.null2String(module.getDsporder())%>"/>
					</td>
				</tr>			
                 <tr>
				<!-- 变量名列 -->
					<td class="FieldName" nowrap>
						模块说明
					</td>
				<!-- 输入框列 -->
					<td class="FieldValue">
						<textarea rows="10" cols="60" id="description" name="description"><%=StringHelper.null2String(module.getDescription())%></textarea>
					</td>
				</tr>
			</table>
        </form>
    </div>
    </body>
<script type="text/javascript">
 function EditOK() {
		var id = document.getElementById("id").value;
		var labelid = document.getElementById("labelid").value;
		var objname = document.getElementById("objname").value;
		var pid = document.getElementById("pid").value;
		var oid = document.getElementById("oid").value;
		var dsporder = document.getElementById("dsporder").value;
        var description = document.getElementById("description").value;
		if(objname == ""){
			alert("<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>");
			return;
		}
		//----浏览器兼容性修改为ajax请求----
		var result;
		var url="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=modify";
			Ext.Ajax.request({   
					url: url,   
					method : 'post',
					params:{   
						id : id,
						labelid : labelid,
						objname : objname,
						pid : pid,
						oid : oid,
						dsporder : dsporder,
						description : description
					}, 
					success: function (response)    
			        {   
						result=Ext.util.JSON.decode(response.responseText);
					   	if(id != ""){
					   		var selectedNode = parent.moduleTree.getSelectionModel().getSelectedNode();
							if(selectedNode != null){
								var showname = getValidStr(document.getElementById("objname").value);
								//selectedNode.setText(showname);
								Ext.Ajax.request({   
									url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
									method : 'post',
									params:{   
										keyword : id,
										cnlabelname : showname
									}, 
									success: function (response)    
							        {   
							        	selectedNode.setText(response.responseText);
							        },
								 	failure: function(response,opts) {    
									 	alert('Error', response.responseText);   
									}  
								}); 
							}
						}else{	//create
							if(result != null){
								var selectedNode = parent.moduleTree.getSelectionModel().getSelectedNode();
				                selectedNode.reload();
				                window.location='modulemodify.jsp?id='+selectedNode.id;
							}
						}
			        },
				 	failure: function(response,opts) {    
					 	alert('Error', response.responseText);   
					}  
				});  
	}
</script>
</html>