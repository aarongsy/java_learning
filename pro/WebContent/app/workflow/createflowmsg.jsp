<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestlogService"%>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2008-9-26
  Time: 16:05:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
  <head>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>

  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>

      <style type="text/css">
          .InputStyle2{
    background:rgb(247,247,247);border:1px solid rgb(214,211,214);font-size:16px;align:center;
}
          #pagemenubar table {width:0}
      </style>

  </head>
  <%                                         
      String humresid = "";
      String humresname = "";
      //发送
      pagemenustr += "{S,"+labelService.getLabelNameByKeyId("8A72C1EFBFCF46F0A55D28BF25443905")+",javascript:onSend()}";
      PagemenuService _pagemenuService = (PagemenuService) BaseContext.getBean("pagemenuService");
      HumresService humresService = (HumresService) BaseContext.getBean("humresService");
      String pagemenubarstr = _pagemenuService.getPagemenuBarstr(pagemenustr);
      pagemenubarstr = pagemenubarstr.replace("\\\"", "\"");
      String success=StringHelper.null2String(request.getParameter("success"));
			String id = StringHelper.null2String(request.getParameter("id"));
			EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
			String userid=eweaveruser1.getId();
			DataService ds = new DataService();
			String workflowname="";
			String curUserID="";
			String title="";
			//取流程信息
			String sql="select t.workflowid, (select objname from workflowinfo where id=t.workflowid) workflowname,t.requestname,t.creater,(select objname from humres where id=t.creater) creator,t.isfinished from requestbase t where t.id='"+id+"' and t.isfinished=0";
			List flow = ds.getValues(sql);
			if(flow.size()>0)
			{
				Map m = (Map)flow.get(0);
				workflowname = m.get("workflowname").toString();
				curUserID = m.get("creater").toString();
				title = m.get("requestname").toString();
			}
			else
			{
				out.println("<div align=center>"+labelService.getLabelNameByKeyId("78DE409C9525452E9D97FBFD42E83D25")+"</div>");//流程已处理结束!
				return;
			}
			if(!userid.equals(curUserID))
			{
				//out.println("<div align=center>非流程申请人，不能使用流程催办功能!</div>");
				//return;
			}
			//取未操作用户
			RequestlogService requestlogService= (RequestlogService) BaseContext.getBean("requestlogService");
			List curNodeList = requestlogService.getCurrentNodeIds(id);
			List userList = new ArrayList();
      String catcher="";
			for(int i=0,size=curNodeList.size();i<size;i++)
			{
				String[] usersStr = StringHelper.null2String(requestlogService.getOperatorList0Str(curNodeList.get(i).toString(),id,null)).split(",");
				//System.out.println(requestlogService.getOperatorList0Str(curNodeList.get(i).toString(),id,null));
				for(int j=0,size1=usersStr.length;j<size1;j++)
				{
					if(usersStr[j]!=null&&usersStr[j].length()>0)
						userList.add(usersStr[j]);
				}
			}
      String msg=StringHelper.null2String(request.getParameter("msg"));
			if(msg.length()<1)
			{
			  //msg="[催办事宜]:"+title+"("+workflowname+"),请及时处理！";
				msg="["+labelService.getLabelNameByKeyId("D5C864DFF9B14F69A8BDEFDCCBFD3FF3")+"]:"+title+"("+workflowname+"),"+labelService.getLabelNameByKeyId("4335F0F1E0184CF3B2E63DD7DD65278F")+"";
			}
			for(int i=0,size=userList.size();i<size;i++)
			{
				String userid1 = userList.get(i).toString();
				for(int j=i+1,size1=userList.size();j<size1;j++)
				{
					if(userid1.equals(userList.get(j).toString()))
					{
						userList.remove(j);
						j=j-1;
						size=size-1;
						size1=size1-1;
					}
				}
			}
			StringBuffer userCheckBox = new StringBuffer();
			for(int i=0,size=userList.size();i<size;i++)
			{
				Humres humresobj=humresService.getHumresById(userList.get(i).toString());
				humresname=humresobj.getObjname();
				userCheckBox.append("<input type=\"checkbox\" value=\""+userList.get(i).toString()+"\" checked name=\"usercheckbox\" onchange=\"javascript:reSetValue(this);\"> "+humresname +"&nbsp;&nbsp;");
				humresid= humresid+userList.get(i).toString()+",";
			}
			
			if(humresid.length()>0)
				humresid=humresid.substring(0,humresid.length()-1);
				

  %>
  <script type="text/javascript">
       Ext.onReady(function(){
      var tb = new Ext.Toolbar();
      tb.render('pagemenubar');
      //发送
      addBtn(tb,'<%=labelService.getLabelNameByKeyId("8A72C1EFBFCF46F0A55D28BF25443905")%>','S','phone',function(){onSend(this)});
      //清除
      addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")%>','R','erase',function(){reset()});
       });
      function onSend(obj)
      {
				
				
        if(Ext.getDom('msgcontent').value==''){
         //pop('请输入短信内容') ;
          pop('<%=labelService.getLabelNameByKeyId("C9543FB2A589409BB70F5A326B57CF3F")%>') ;
          return false;
        };
        if(Ext.getDom('humresids').value==''){
        //pop('请指定接收人') ;
          pop('<%=labelService.getLabelNameByKeyId("99D2FE352CCB442795997059ACA3AA35")%>') ;
          return false;
        };
        obj.disable();
        Ext.Ajax.request({
            form:EweaverForm,
            success: function(res) {
              //top.frames[1].pop('已发送');
                top.frames[1].pop('<%=labelService.getLabelNameByKeyId("BF745BA7C6B94607AF6847474FD9C9FD")%>');
								var commonDialog=top.leftFrame.commonDialog;

								if(commonDialog){ 
								
								 var frameid='tab'+top.frames[1].contentPanel.getActiveTab().id;
								 parent.daliog0.hide();
								 
								}
            }
        });
      }
      function reset(){
         //$('#EweaverForm span').text('');
         //$('#EweaverForm input[type=text]').val('');
         $('#EweaverForm textarea').val('');
         //$('#EweaverForm input[type=checkbox]').each(function(){
         //    this.checked=false;
         //});
         //$('#EweaverForm input[type=hidden]').each(function(){
         //    if(this.name.indexOf('con')==0)
         //    this.value='';
         //});
         //$('#EweaverForm select').val('');
         //$('#EweaverForm span[fillin=1]').each(function(){
         //    this.innerHTML='<img src=/images/base/checkinput.gif>';
         //});
   }
  </script>
  <body>
   <div id="pagemenubar"></div>
  <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.msg.servlet.MessageAction" name="EweaverForm"  id="EweaverForm" method="post" onsubmit="return false">


      <table>
          <colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
     
    <tr>
        <td><%=labelService.getLabelNameByKeyId("239057140C1D4259AE4CB0DCE47B9956")%>：</td><!-- 被催办人 -->
        <td>
            <table>
                 <colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
                <tr>
                    <td class="FieldValue">
<!--                         <button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/humresbrowserm.jsp?bid=2','humresids','humresidspan','1');"></button> -->
                         <input type="hidden"   name="humresids" id="humresids" value="<%=humresid%>" />
                         <span id = "humresidspan" ><%=userCheckBox.toString()%></span>
                    </td>
                </tr>
<!--                 <tr>
                      <td class="FieldName" nowrap>自定义号码：</td>
                     <td class="FieldValue"><input type="text"  class="InputStyle2" id="number" value="" name="number" ></td>
                </tr> -->
            </table>
        </td>
    </tr>
      <tr>
             <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("50320693449944DE8C9927A2A3007BC7")%>：</td><!-- 催办内容 -->
         <td class="FieldValue" colspan="2">
             <textarea rows="10" cols="40" name="msgcontent" id="msgcontent"><%=msg%></textarea>
         </td>
      </tr>
      </table>
  </form>
<script type="text/javascript">
    function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=new VBArray(window.showModalDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url='+viewurl)).toArray();
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
	function reSetValue(obj)
	{
		var objs = document.getElementsByName(obj.name);
		if(objs.length<0)document.getElementById("humresids").value="";
		var userid="";
		for(var i=0,len=objs.length;i<len;i++)
		{
			if(objs[i].checked)userid=userid+objs.value+",";
		}
		if(userid.length>0)
			userid=userid.substring(0,userid.length-1);
		document.getElementById("humresids").value=userid;
	}

</script>
  </body>
</html>