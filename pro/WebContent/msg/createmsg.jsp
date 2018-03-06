<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/workflow.js"></script>
<script type="text/javascript" src="/js/formbase.js"></script>
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/interface/WorkflowService.js'></script>
<script src='/dwr/interface/WordModuleService.js'></script>
<script src='/dwr/interface/RequestlogService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>


<style type="text/css">
#msgDiv{
	padding:8px;
	border: solid 1px #909090;
	background-color: #ffffe1;
	color: red;
}
#pagemenubar table {width:0}
</style>
</head>
<%                                         
String humresname = "";
String currentuserName = currentuser.getObjname();
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
String success=StringHelper.null2String(request.getParameter("success"));
String humresid=StringHelper.null2String(request.getParameter("humresid"));
String msg=StringHelper.null2String(request.getParameter("msg"));
String objid=StringHelper.null2String(request.getParameter("objid"));
List<String> humreslist = StringHelper.string2ArrayList(humresid,",");
for(String humres:humreslist){
    Humres humresobj=humresService.getHumresById(humres);
    humresname+=humresobj.getObjname()+",";
}

%>
<script type="text/javascript">
    Ext.onReady(function(){
    	var tb = new Ext.Toolbar();
    	tb.render('pagemenubar');
    	addBtn(tb,'发送','S','phone_go',function(){onSend()});
    	addBtn(tb,'清除','R','erase',function(){reset()});
    });

    function onSend(){
      if(Ext.getDom('msgcontent').value==''){
        pop('请输入短信内容') ;
        return;
      };
      if(Ext.getDom('showmessagespan').innerText!=''){
          pop('手机号输入有误，请联系系统管理员！') ;
          return;
      };
        
      var numbers=Ext.getDom('number').value;
	  var humresids=Ext.getDom('humresids').value;
      if(numbers==''&&humresids.value==''){
        pop('请指定接收人') ;
        return;
      };
	  //验证输入的手机号
      if(numbers.length>0){
		var numberarr = numbers.split(',');
		for(var i=0,len=numberarr.length;i<len;i++){
			if(!isMobile(numberarr[i])){
				alert('您输入的手机号 [ '+numberarr[i]+' ] 有误 ! ');
				return;
			}
		}
      }
      var myMask = new Ext.LoadMask(Ext.getBody(), {
					msg: '信息发送中，请稍后....',
					removeMask: true 
	  });
      myMask.show();
      Ext.Ajax.request({
          form:EweaverForm,
          success: function(res) {
          	  alert('消息已成功发送');
          	  myMask.hide();
              reset();
          }
      });
    }

  //校验手机号码：必须以数字开头,11位。
   function isMobile(object){
	   var s =object; 
	   if(typeof(s)=='undefined'){
			return false;
	   }
	   var reg0 = /^0?\d{11}$/;
	   var my = false;
	   if (reg0.test(s))my=true;
	       if(s!=""){
	           if (!my){
	              document.getElementById('number').value="";
	              document.getElementById('number').focus();
	              return false;
	           }
	       }
	   return true;
   }

    
    function reset(){
        //location.reload();
       $('#EweaverForm span').text('');
       $('#EweaverForm input[type=text]').val('');
       $('#EweaverForm textarea').val('');
       $('#EweaverForm input[type=checkbox]').each(function(){
           this.checked=false;
       });
       $('#EweaverForm input[type=hidden]').each(function(){
           if(this.name.indexOf('con')==0)
           this.value='';
       });
       $('#EweaverForm select').val('');
       $('#EweaverForm span[fillin=1]').each(function(){
           this.innerHTML='<img src=/images/base/checkinput.gif>';
       });
}
function checkmobile(){
	var sql='';
	var humresids=Ext.getDom('humresids').value;
	var showmessage='';
	//验证选择人是否有手机号
	if(humresids.length>0){
		<%if("1".equals(SQLMap.getDbtype())){//SQLServer数据库%> 
			sql = 'select objname+\'(\'+isnull(Tel2,\'空\')+\')\' OBJNAME from humres where \''+humresids+'\' like \'%\'+id+\'%\' and (tel2 is null or len(tel2)!=11) order by objno'; 
		<%}else{%> 
			sql = 'select objname||\'(\'||nvl(Tel2,\'空\')||\')\' OBJNAME from humres where \''+humresids+'\' like \'%\'||id||\'%\' and (tel2 is null or length(tel2)!=11) order by objno'; 
		<%}%>
		DataService.getValues(sql,{ 
		callback: 
			function(data){ 
				if(data.length>0) { 
					for(var i=0,len=data.length;i<len;i++){
						var objname;
						<%if("1".equals(SQLMap.getDbtype())){//SQLServer数据库%>
							objname=data[i].OBJNAME;
						<%}else{%>
							objname=data[i].objname;
						<%}%>
						if(objname!=null){
							 showmessage = showmessage+objname+' , '; 
						}
					}
				} 
				if(showmessage.length>0)
				{
					showmessage=showmessage.substring(0,showmessage.length-1);
					showmessage='提示接收人员[ '+showmessage+' ]手机号有误！';
					document.getElementById('showmessagespan').innerHTML=showmessage;
				}
				else
				{
					document.getElementById('showmessagespan').innerHTML='';
				}
			} 
		});
	}else{
		document.getElementById('showmessagespan').innerHTML='';
	}
}
function pop(msg){
	document.getElementById("msgDiv").style.display="";
	document.getElementById("msgDiv").innerText=msg;
	setTimeout(function(){document.getElementById("msgDiv").style.display="none";},5000);
}
</script>
<body>
<div id="pagemenubar"></div>
<div id="msgDiv" style="display:none;"></div>
<form action="/ServiceAction/com.eweaver.base.msg.servlet.MessageAction" name="EweaverForm"  id="EweaverForm" method="post" onsubmit="return false">
<input type="hidden" id="status" name="status" value="2"/>
<input type="hidden" id="objid" name="objid" value="<%=objid%>"/>
<table>
  	<tr>
      <td width="65px;" class="FieldName" align="right">接收人：</td>
      <td class="FieldValue">

	      <button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/humresbrowserm.jsp?bid=2','humresids','humresidspan','1');"></button>
          <input type="hidden"   name="humresids" id="humresids" value="<%=humresid%>" onpropertychange="javascript:checkmobile();"/>
          <span id = "humresidspan" ><%=humresname%></span>
		  <br><br>
		  <span id = "showmessagespan" style="color:red;"></span>
      </td>
	</tr>

	<tr>
	   <td class="FieldName"  align="right">其他号码：</td>
	   <td class="FieldValue"><textarea type="text"  style="width: 100%" id="number"  name="number" ></textarea></td>
	</tr>
    <tr>
       <td class="FieldName"  align="right">短信内容：</td>
       <td class="FieldValue">
           <textarea style="width: 100%" rows="5" name="msgcontent" id="msgcontent" onpropertychange="countText();"><%=msg%></textarea>
       </td>
    </tr>
    <tr>
       <td class="FieldName" ></td>
       <td class="FieldValue" id="countMSG">
       </td>
    </tr>
    <tr>
       <td class="FieldName" ></td>
       <td class="FieldValue">
           <div style="padding:5px;color: red;">注：
				<ul>1. 多个手机号码请用英文逗号分隔</ul>
				<ul>2. 默认会在短信后面添加发送者姓名</ul>
				<ul>3. 每条短信最多65个字符,超出将自动分割为多条</ul>
			</div>
       </td>
    </tr>
</table>
</form>
<script type="text/javascript">
function countText(){
	var size = document.getElementById('msgcontent').value.length;
	countMSG.innerText='已输入'+size+'个字符';
}
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog('/base/popupmain.jsp?url='+viewurl);
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