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
<%@ page import="com.eweaver.base.security.service.logic.PermissionBatchActionService" %>
<%@ page import="com.eweaver.base.security.model.PermissionBatchAction" %>
<%
String actionId=StringHelper.null2String(request.getParameter("id"));
if(actionId.equals(""))
return;
PermissionBatchActionService permissionBatchActionService = (PermissionBatchActionService) BaseContext.getBean("permissionBatchActionService");
PermissionBatchAction permissionBatchAction=permissionBatchActionService.getPermissionBatchAction(actionId) ;
if(permissionBatchAction==null)
return;
titlename=permissionBatchAction.getObjname();
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


<script type="text/javascript">
var btn1;
var total=0;
var currentCount=0;
var refresstimer;
var pbar1;
Ext.onReady(function(){
    //==== Progress bar1  ====
    pbar1 = new Ext.ProgressBar({
       text:'0%'
    });
    btn1 = Ext.get('btn1');
    btn1[0].on('click', function(){
        if(document.all("from").value==""){
        alert("请选择A");
        return;
        }
        if(document.all("to").value==""){
        alert("请选择B");
        return;
        }
        if(document.all("from").value==document.all("to").value){
        alert("A和B不能相同");
        return;
        }

        total=0;
        currentCount=0;
        btn1.dom.disabled = true;
        Ext.fly('p1').setDisplayed(true);
        Ext.fly('p1text').update('');
        if (!pbar1.rendered){
            pbar1.render('p1');
        }else{
            pbar1.text = '0%';
            pbar1.show();
        }
        doTransfer('<%=actionId%>');
        if(total==-1){    
        pbar1.reset(true);
        btn1.dom.disabled = false;
        Ext.fly('p1text').update('请等待先前的任务完成').show();
        return;
        }
        if(total==0){
        pbar1.reset(true);
        btn1.dom.disabled = false;
        Ext.fly('p1text').update('操作完成').show();
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('操作完成!').show();
        });
    });
});


var Runner = function(){
    var f = function(pbar,count, cb){

        return function(){
            doRefresh();
            if(currentCount >= count){
                btn1.dom.disabled = false;
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
<button type="button" name='btn1'class='btn' accessKey='C'><U>C</U>--处理</button>
        <div class="status" id="p1text" style="display:none"></div>
        <div id="p1" style="width:300px;display:none"></div>
</div>


<!--页面菜单结束-->
   	<form action="" name="EweaverForm"  method="post">  

<TABLE ID=searchTable width="100%" height="100%" class="noborder">
	<colgroup>
		<col width="20%">
		<col width="80%">
	</colgroup>    
<tr class=Title>
</tr>
<tr>
    <td colspan="2">
    </td>
</tr>

				<tr>
					<td class="FieldName" nowrap>
					    <%=permissionBatchAction.getOperationObj()%>:
					</td>
					<td class="FieldValue">
                        <button type="button" class=Browser  onclick="javascript:getrefobj('from','fromspan','402881e70bc70ed1010bc75e0361000f','','<%= request.getContextPath()%>/humres/base/humresview.jsp?id=','1')"></button>
                        <input type="hidden" name="from"  id="from"><span name="fromspan" id="fromspan"><img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
					</td>
				</tr>

				<tr>
					<td class="FieldName" nowrap>
					    <%=permissionBatchAction.getTargetObj()%>:
					</td>
					<td class="FieldValue">
                        <button type="button" class=Browser  onclick="javascript:getrefobj('to','tospan','402881e70bc70ed1010bc75e0361000f','','<%= request.getContextPath()%>/humres/base/humresview.jsp?id=','1')"></button>
                        <input type="hidden" name="to"  id="to"><span name="tospan" id="tospan"><img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
					</td>
				</tr>

		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>
		        </tr>
		        <tr class=Title>
					<th colspan=2 nowrap><b>操作说明</b></th>
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>
		        </tr>
				<tr>
					<td class="FieldValue" colspan=2>
					<TEXTAREA STYLE="width:100%" class=InputStyle rows=2><%=permissionBatchAction.getObjdesc()%></TEXTAREA>
					</td>
				</tr>
</table>
           
</form>

<script language="javascript">  


function doTransfer(actionId){
    from=document.all("from").value;
    to=document.all("to").value;
    DWREngine.setAsync(false);
    RightTransferService.permissionBatchAction(actionId,from,to,returnTotal);
    DWREngine.setAsync(true);

}
function returnTotal(o){
    total=o;
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







