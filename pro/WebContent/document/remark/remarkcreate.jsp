<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%
//EweaverUser eweaveruser = BaseContext.getRemoteUser();
//Humres currentuser = eweaveruser.getHumres();
String objid=request.getParameter("objid");
//String pagemenustr = "addBtn(tb,'提交','S','accept',function(){onSubmit()});";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
      <style type="text/css">
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
  </style>
  <title><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e89000c")%></title><!--文档点评  -->
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type='text/javascript' src='/js/ext/examples/grid/RowExpander.js'></script>
<script type='text/javascript' src='/js/ext/ux/TreeGrid.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript">

</script>
  </head> 
  <body>
<!--页面菜单结束--> 
        
        <!-- form -->
		<form action="/ServiceAction/com.eweaver.document.remark.servlet.RemarkAction?action=create" name="EweaverForm" method="post">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-left:3px;margin-top:3px;">
				 <colgroup> 
					<col width="50%">
					<col width="50%">
				</colgroup>	
				<input type="hidden" name="objid" value="<%=objid%>">
				<input type="hidden" name="humresid" value="<%=currentuser.getId()%>">
				  <tr>
				    <td nowrap><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98004a")%>：&nbsp;&nbsp;&nbsp;<!--点评内容  -->
				    <input type="radio" name="score" checked value="1">1<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%><!-- 分 -->

				    <input type="radio" name="score" value="2">2<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%><!-- 分 -->

				    <input type="radio" name="score" value="3">3<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%><!-- 分 -->

				    <input type="radio" name="score" value="4">4<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%><!-- 分 -->

				    <input type="radio" name="score" value="5">5<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%><!-- 分 -->

				    </td>
				    <td nowrap><!-- 推荐该文章:<input type="checkbox" name="score2" value="" onclick="cbclick(this)"> --></td>
				  </tr>
				  <tr>
				    <td ColSpan="2"><textarea STYLE="width:100%" class=InputStyle rows=7 name="objdesc"></textarea></td>
				  </tr>
				</table>
				<div style="margin-left:3px;margin-top:5px;">
					<input type="button" value="<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009")%>" onclick="onSubmit();"/><!-- 提交 -->
				</div>
		</form>
<script language="javascript">
    function cbclick(obj){
     if(obj.checked){
         document.all('score2').value=1;
     }else{
         document.all('score2').value='';
     }
    }
function onSubmit(){
    var objdesc=document.all('objdesc').value;
   if(objdesc==''||objdesc==null){
     Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98004b")%>');//点评内容不能为空！
    }else{
       var score;
       var radios = document.getElementsByName("score");
       for (var i = 0; i < radios.length; i++)
       {
           if (radios[i].checked == true)
           {
               score = radios[i].value;
           }
       }
       var objid = '<%=objid%>';
       var humresid = '<%=currentuser.getId()%>';
       //var score2=document.all('score2').value;
       var score2 = "";
       var objdesc=document.all('objdesc').value;
        Ext.Ajax.request({
                     url: '/ServiceAction/com.eweaver.document.remark.servlet.RemarkAction?action=create',
                     params:{score:score,objid:objid,humresid:humresid,score2:score2,objdesc:objdesc},
                     success: function() {
                        Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98004c")%>',function(){//点评成功！
                        	self.parent.location.reload();
                            location.href='/document/remark/remarkcreate.jsp?objid=<%=objid%>' ;
                        });
                     }
                 });
    }
}    
</script> 
    </body>
</html>

