<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
List categorylist = categoryService.getSubCategoryList2(null,null,null,null);
%>

<html>
<head>
<style type="text/css">
    TABLE {
	width:0;
}
</style>
<script  type='text/javascript' src='<%= request.getContextPath()%>/js/workflow.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/RightTransferService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%= request.getContextPath()%>/dwr/util.js'></script>

<script type="text/javascript" src="<%= request.getContextPath()%>/js/dojo.js"></script>
<script type="text/javascript">
	dojo.require("dojo.lang.*");
	dojo.require("dojo.widget.Tree");
	dojo.require("dojo.widget.TreeRPCController");
	dojo.require("dojo.widget.TreeSelector");
	dojo.require("dojo.widget.TreeNode");
	dojo.require("dojo.widget.TreeContextMenu"); 
</script>
<script type="text/javascript">
var btn1;
var btn2;
var total=0;
var currentCount=0;
var refresstimer;
var pbar1;
var pbar2;
Ext.onReady(function(){
    //==== Progress bar1  ====
    pbar1 = new Ext.ProgressBar({
       text:'0%'
    });
    btn1 = Ext.get('btn1');
    btn2 = Ext.get('btn2');
    btn1.on('click', function(){
        if(document.all("from").value==""){
        alert("请选择权限被转移人");
        return;
        }
        if(document.all("to").value==""){
        alert("请选择权限被赋予人");
        return;
        }
        if(document.all("from").value==document.all("to").value){
        alert("不能选择相同的人员");
        return;
        }
        if(getStr("key")==""){
        alert("请选择分类");
        return;
        }
        total=0;
        currentCount=0;
        btn1.dom.disabled = true;
        btn2.dom.disabled = true;
        Ext.fly('p1').setDisplayed(true);
        Ext.fly('p1text').update('');
        if (!pbar1.rendered){
            pbar1.render('p1');
        }else{
            pbar1.text = '0%';
            pbar1.show();
        }
        doTransfer(true);
        if(total==-1){    
        pbar1.reset(true);
        btn1.dom.disabled = false;
        btn2.dom.disabled = false;
        Ext.fly('p1text').update('请等待先前的任务完成').show();
        return;
        }
        if(total==0){
        pbar1.reset(true);
        btn1.dom.disabled = false;
        btn2.dom.disabled = false;
        Ext.fly('p1text').update('复制完成').show();
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('复制完成!').show();
        });
    });

    //==== Progress bar 2 ====
    pbar2 = new Ext.ProgressBar({
    });
    pbar2.on('update', function(val){
        //You can handle this event at each progress interval if
        //needed to perform some other action
        //Ext.fly('p2text').dom.innerHTML += '.';
    });
    btn2.on('click', function(){
        if(document.all("from").value==""){
        alert("请选择权限被转移人");
        return;
        }
        if(document.all("to").value==""){
        alert("请选择权限被赋予人");
        return;
        }
        if(document.all("from").value==document.all("to").value){
        alert("不能选择相同的人员");
        return;
        }
        if(getStr("key")==""){
        alert("请选择分类");
        return;
        }
        Ext.fly('p2text').update('');
        btn1.dom.disabled = true;
        btn2.dom.disabled = true;
        Ext.fly('p2').setDisplayed(true);
        if (!pbar2.rendered){
            pbar2.render('p2');
        }else{
            pbar2.show();
        }
        doTransfer(false);
        pbar2.wait({
            interval:200,
            //duration:5000,
            increment:15,
            fn:function(){
                btn1.dom.disabled = false;
                btn2.dom.disabled = false;
                pbar2.reset(true);
                Ext.fly('p2text').update('剪切完成!');
            }
        });
    });

});


var Runner = function(){
    var f = function(pbar,count, cb){

        return function(){
            doRefresh();
            if(currentCount >= count){
                btn1.dom.disabled = false;
                btn2.dom.disabled = false;
                clearInterval(refresstimer);
                cb();
            }else{
					var i = currentCount/count;
                    pbar.updateProgress(i, Math.round(100*i)+'%');
            }
       };
    };
    return {
        run : function(pbar, count, cb){
            var ms = 5000/count;
              try{
              refresstimer=setInterval(f(pbar, count, cb),2);
              }catch(e){}
                  
        }
    }
}();
</script>
</head>  
<body>    
<div id="pagemenubar" style="z-index:100;">
<button type="button" id='btn1'class='btn' accessKey='C'><U>C</U>--复制</button>
<button type="button" id='btn2'class='btn' accessKey='C'><U>X</U>--剪切</button>
</div>


<!--页面菜单结束-->
   	<form action="" name="EweaverForm"  method="post">  

<TABLE ID=searchTable width="100%" height="100%" class="noborder">
<tr>
</tr>
<tr>
    <td colspan="2">
        <div class="status" id="p1text" style="display:none"></div>
        <div id="p1" style="width:300px;display:none"></div>
    </td>
</tr>
<tr>
    <td colspan="2">
        <span class="status" id="p2text"></span>
        <div id="p2" style="width:300px;display:none"></div>
    </td>
</tr>
<tr>
<TD class=FieldName noWrap colspan="2">转移从:
<button type="button" class=Browser  onclick="javascript:getrefobj('from','fromspan','402881e70bc70ed1010bc75e0361000f','','<%= request.getContextPath()%>/humres/base/humresview.jsp?id=','1')"></button>
    <input type="hidden" name="from"  id="from"><span name="fromspan" id="fromspan"><img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
转移到:
<button type="button" class=Browser  onclick="javascript:getrefobj('to','tospan','402881e70bc70ed1010bc75e0361000f','','<%= request.getContextPath()%>/humres/base/humresview.jsp?id=','1')"></button>
    <input type="hidden" name="to"  id="to"><span name="tospan" id="tospan"><img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span></TD>
</tr>
<tr>
<td width="20%" valign="top">




		<div dojoType="TreeRPCController" RPCUrl="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.category.servlet.CategoryTreeAction?action=getChildrenForRightTransfer" widgetId="treeController" DNDController="create"></div>
		<div dojoType="TreeSelector" widgetId="treeSelector"></div>
		<div dojoType="Tree" DNDMode="between" selector="treeSelector" actionsDisabled="move" widgetId="Tree"  controller="treeController"  toggler="explor">
		  <%
					for(int i=0;i<categorylist.size();i++){
						Category category1 = (Category)categorylist.get(i);
						String objname=category1.getObjname();
						String objid = category1.getId();
                        String link = "<a href='#' onclick=doUrl('"+objid+"'); >"+objname+"</a>";
						int childrennum = category1.getChildrennum().intValue();

						String isfolder = "false";
						if(childrennum>0)
							isfolder = "true";

				%>
		
		<div dojoType="TreeNode" widgetId="<%=objid%>" object="<%=objname%>" objectId="<%=objid%>"  title="<%=link%>" actionsDisabled="remove"  isFolder="<%=isfolder%>">		
        </div>
        <%}%>
        </div>
</td>
<td width="80%" valign="top">
	<!--########Select Table Start########-->
	<table  cellspacing="0" align="left" width="100%" class=noborder>
		<tr>
			<td align="center" valign="top" width="30%">
				<img src="<%= request.getContextPath()%>/images/arrow_u.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881e70b227478010b22783d2f0004")%>" onclick="javascript:upFromList();">
				<br><br>
					<img src="<%= request.getContextPath()%>/images/arrow_all.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69932470005")%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="<%= request.getContextPath()%>/images/arrow_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="<%= request.getContextPath()%>/images/arrow_all_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69a97a00006")%>" onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src="<%= request.getContextPath()%>/images/arrow_d.gif"   style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69b730b0007")%>" onclick="javascript:downFromList();">
				<br>
				<br>
			</td>
			<td align="center" valign="top" width="80%">
				<select size="20"  name="srcList" multiple="true" style="width:100%" class="InputStyle">
				</select>
			</td>
		</tr>
	</table>
</td>
</tr>
</table>
</form>
<script language=vbs>
Sub btnok_onclick()	 
	getArray getStr("key"),getStr("text")
End Sub

Sub btnclear_onclick()
     getArray "0",""
End Sub
</script>
<script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
<script language="javascript">  
function getStr(mode){
	var str = "" ;
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = 0; i < len; i++) {
		if(mode=="key"){
			var key = destList.options[i].value;
			if(key!="null" && key!="")
				str += key + ",";
		}else if(mode=="text"){
			var text = destList.options[i].innerText;
			if(text!="")
				str += text + ",";
		}
	}
	if (str.length!=0)
		str = str.substring(0,str.length-1);
//		alert(str);
	return str;
}

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
function doUrl(key){
	event.srcElement.checked=true;
	var oOption = document.createElement("OPTION");
	if(!isExistEntry(key,document.all("srcList"))){
		document.all("srcList").options.add(oOption);
		oOption.value = key;
		oOption.innerText = getNodetitle(key);	
	}		
}
 
function addAllToList(){
	var treeController = dojo.widget.manager.getWidgetsByType("TreeNode");
	for( nodeindex=0;nodeindex<treeController.length;nodeindex++){
		doUrl(treeController[nodeindex].objectId);
	}
}

function isExistEntry(entry,destList){
	var arrayObj = destList.options;
	for(var i=0;i<arrayObj.length;i++){
		if(entry == arrayObj[i].value){
			return true;
		}
	}
	return false;
} 

function deleteAllFromList(){
	var destList  = document.all("srcList");
	destList.options.length=0;
}

function deleteFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if (destList.options[i].selected == true) {
			destList.options.remove(i);
		}
	}
}

function upFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }

}

function downFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
}
function doAlert(){
	alert("对不起，你没有权限!");
}

function doTransfer(iscopy){
    from=document.all("from").value;
    to=document.all("to").value;
    categoryIdsStr=getStr("key");
    categoryIds=categoryIdsStr.split(",");
    if(iscopy){
    DWREngine.setAsync(false);
    RightTransferService.transfer(from,to,iscopy,categoryIds,returnTotal);
    DWREngine.setAsync(true);
    }else{
    DWREngine.setAsync(true);
    RightTransferService.transfer(from,to,iscopy,categoryIds,returnCut);    
    }
}
function returnTotal(o){
    total=o;
}
function returnCut(o){
    Ext.TaskMgr.stop(pbar2.waitTimer);
}
function returnCurrentCount(o){
    currentCount=o
}
function doRefresh(){
    RightTransferService.getCurrentCount(returnCurrentCount);
}
function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
    param = parserRefParam(inputname,param);
	idsin = document.all(inputname).value;
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id="+refid+"&"+param+"&idsin="+idsin);
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
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
</script>

</body>
</html>







