<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<html>
<head>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/dojo.js"></script>
<script type="text/javascript">
	dojo.require("dojo.lang.*");
	dojo.require("dojo.widget.Tree");
	dojo.require("dojo.widget.TreeRPCController");
	dojo.require("dojo.widget.TreeSelector");
	dojo.require("dojo.widget.TreeNode");
	dojo.require("dojo.widget.TreeContextMenu");
</script>
<script language="javascript">
function getNodetitle(objval){
	objNode = dojo.widget.manager.getWidgetById(objval);
	var retval = "/"+objNode.object;
	objNode = objNode.parent;
	while(objNode != null){
		if(getValidStr(objNode.object) != "")
			retval = "/"+objNode.object +retval;
		objNode = objNode.parent;
	}
	return retval;
}
</script>
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     getArray "0",""
End Sub
Sub doUrl(objval)
	window.parent.parent.optframe.location="<%=request.getContextPath()%>/notify/notifyList.jsp?id="+objval
End Sub
</script>
    <script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
</head>
<body >
<!--script>
dojo.addOnLoad(function() {
 	var treeController = dojo.widget.manager.getWidgetById('treeController');
    var treeNode = dojo.widget.manager.getWidgetById('2');
    treeController.expand(treeNode);
});
</script-->
<div>
<div dojoType="TreeRPCController" RPCUrl="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.notify.servlet.NotifyDefineAction?action=getChildren" widgetId="treeController" DNDController="create"></div>
<div dojoType="TreeSelector" widgetId="treeSelector"></div>
<div dojoType="Tree" DNDMode="between" selector="treeSelector" actionsDisabled="move" widgetId="Tree"  controller="treeController"  toggler="explor">

<div dojoType="TreeNode" widgetId="1" object="<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4003c") %>" objectId="notify_1"  title="<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4003c") %>" actionsDisabled="remove"  isFolder="true"><!-- 提醒消息 -->
</div>
</div>
    </div>

</body>
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     getArray "0",""
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
    dojo.addOnLoad(function() {
    var treeController = dojo.widget.manager.getWidgetById('treeController');
    var treeNode = dojo.widget.manager.getWidgetById('1');
    treeController.expand(treeNode);
    });
</script>
</html>