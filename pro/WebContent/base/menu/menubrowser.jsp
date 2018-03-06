<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.label.model.Label" %>
<%@ include file="/base/init.jsp"%>
<%
String menutype = StringHelper.trimToNull(request.getParameter("menutype"));
String isshow = StringHelper.trimToNull(request.getParameter("isshow"));
String pid = StringHelper.trimToNull(request.getParameter("pid"));

MenuService menuService =(MenuService)BaseContext.getBean("menuService");
List menuList = menuService.getSubMenus(pid,menutype,isshow);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<script language=javascript src="<%=request.getContextPath()%>/js/coco_tree.js"></script>
  	<script src='<%=request.getContextPath()%>/dwr/interface/MenuService.js'></script>
  	<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
  <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
  </head> 
  <body >

<table height=100%>
	<tr>
		<td valign=top>
		
<!--页面菜单开始-->     
<%
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
pagemenustr += "{Q,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:btnclear_onclick()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 

<div id="divtree" align=left ></div>
         </td>
	</tr>
</table>

<script>
pid = "0";
var icons=new coco_imagelist()
icons.path = contextPath+"/images/base/coco_tree/"
icons.add("minus_m","collapse")
icons.add("minus_top","collapse_top")
icons.add("minus_end","collapse_end")
icons.add("plus_m","expand")
icons.add("plus_top","expand_top")
icons.add("plus_end","expand_end")
icons.add("branch","leaf")
icons.add("branch_end","twig")
icons.add("vline","line")
icons.add("blank")
var tree1=new coco_tree(icons,0,divtree)
var root=tree1.root
//var n0 = root.add('菜单');

<%
for(int i=0;i<menuList.size();i++){
	Menu menu1 = (Menu)menuList.get(i);
	String checked="";
	if(menu1.getIsshow().intValue()==1) checked="checked";
	  	String _menuname=labelService.getLabelName(menu1.getMenuname());// 把menuname存放的是标签管理的关键字
	  	if(StringHelper.isEmpty(_menuname)){
	  	_menuname=menu1.getMenuname();
	  	}
	out.println("var n"+menu1.getId()+"=tree1.add(root,'last','<input type=checkbox name=checklist value="+menu1.getId()+">"+_menuname+"','"+menu1.getId()+"','','url:menumainframe','menumodify.jsp?id="+menu1.getId()+"');");
}

%>
	
tree1.expandToTier(1)
//鼠标移入时


tree1.onmouseover=function(node) 
{ 
    node.label.style.textDecoration="underline" 
} 
tree1.onmouseout=function(node) 
{ 
    node.label.style.textDecoration="none" 
}
currentkey = ""; //避免在一个节点多点几次时出现重复数据
tree1.onclick=function(node)
{
	if(window.event.srcElement.name == "checklist"){
		key = node.getKey();
		text = node.getPath();
		node_ondbclick(key,text);
	}
	if(currentkey!=node.getKey()){
		currentkey = node.getKey();
		if(!node.hasChild)	appendSub(node.getKey());
	}
}

tree1.oncheck=function(srcNode)
{
	if(srcNode.checkBox.checked)  //添加
	{
		document.frmSearch.haschecked.value += srcNode.getIndex() + ","
	}else    //取消
	{
		var ind = document.frmSearch.haschecked.value.indexOf(","+srcNode.getIndex()+",");
		if(ind!=-1){
			var tmp1 = document.frmSearch.haschecked.value.substring(0,ind);
			var tmp2 = document.frmSearch.haschecked.value.substring(ind+1);
			var ind2 = tmp2.indexOf(",");
			tmp2 = tmp2.substring(ind2);
			document.frmSearch.haschecked.value = tmp1 + tmp2;
		}
	}
}


 function appendSub(_pid){

 	pid = _pid;
  	 MenuService.getSubMenus(fillTable, _pid,null,null);
  }
  var getId = function(unit) { return unit.id };
  var getMenuname = function(unit) {  return unit.menuname };
  var getUrl = function(unit) {  return unit.url };
  var isshow = function(unit) {  return unit.isshow };
  var checked = function(unit){
  	if(isshow(unit)!=0)return "checked";
  	return "";
  }
  function fillTable(Menu){ 
  
  for(menuindex=0;menuindex<Menu.length;menuindex++){
		
			for( nodeindex=0;nodeindex<tree1.nodes.length;nodeindex++){
			//alert(tree1.nodes[nodeindex].getKey());
				if(tree1.nodes[nodeindex].getKey()==pid){
					eval("var n"+getId(Menu[menuindex])+"=tree1.add(tree1.nodes[nodeindex],'last','<input type=checkbox name=checklist  value="+getId(Menu[menuindex])+">"+getMenuname(Menu[menuindex])+"','"+getId(Menu[menuindex])+"','','url:menumainframe','menumodify.jsp?id="+getId(Menu[menuindex])+"')");	
				}
			}
	}  	
  }
  
     function onSubmit(){
   		document.EweaverForm.submit();
   }
    function onCreate(id){
   		 var url="<%=request.getContextPath()%>/base/menu/menucreate.jsp";
     	 parent.menumainframe.location.href=url;
   }
</script>
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
    getArray "0",""

End Sub
Sub node_ondbclick(key,text)
     getArray key,text
End Sub
Sub BrowserTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     getArray e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText
   ElseIf e.TagName = "A" Then
      getArray e.parentelement.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText
   End If
End Sub
Sub BrowserTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowserTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub
</SCRIPT>
<script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
  </body>
</html>
