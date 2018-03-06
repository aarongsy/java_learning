<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>

<%@ include file="/base/init.jsp"%>

<%
    RefobjService refobjService=(RefobjService)BaseContext.getBean("refobjService");
  Refobj refobj = refobjService.getRefobj(request.getParameter("id"));
 
%>
<%
 pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
  pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+"','B','delete',function(){onDelete('"+refobj.getId()+"')});";
%>
<html>
  <head>
  <script type="text/javascript">
      function ischecked()
      {
          var checkbox=document.getElementById("isdirect");
         var mytdtext=document.getElementById("selname");
         var mytdvalue=document.getElementById("selfield");
      if(checkbox.type=="checkbox"&&checkbox.checked==true){
          mytdtext.innerText=" 直接录入查询字段";
          mytdvalue.innerHTML="<TEXTAREA  name=selfield ROWS=5 COLS=80></TEXTAREA>";
           mytdvalue.className='FieldValue';
          mytdtext.className='FieldName'
      }else{
         mytdtext.innerText="";
          mytdvalue.innerText="";
          mytdvalue.className="";
          mytdtext.className="";
      }
      }
  </script>


      <style type="text/css">
     .x-toolbar table {width:0}
     #pagemenubar table {width:0}
       .x-panel-btns-ct {
         padding: 0px;
     }
     .x-panel-btns-ct table {width:0}
   </style>

   <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
     <script type="text/javascript">
         var menu;
       Ext.onReady(function() {

           Ext.QuickTips.init();
       <%if(!pagemenustr.equals("")){%>
           var tb = new Ext.Toolbar();
           tb.render('pagemenubar');
           <%=pagemenustr%>
       <%}%>
            Ext.EventManager.on("refurl", 'contextmenu', showMenu); //监听事件
                 menu = new Ext.menu.Menu({
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
       });
          function onItemChecktourlcategory2(item,checked){
                getid('/base/category/categorybrowser.jsp', 'tourl');

             }
        function onItemChecktourlworkflow2(item,text){
               getid('/workflow/workflow/workflowinfobrowser.jsp', 'tourl');

             }
      function onItemChecktourlreport2(item,text){
                 getid('/workflow/report/reportbrowser.jsp', 'torul');

             }
   </script>

  </head>
  
  <body>
<div id="pagemenubar" style="z-index:100;"></div>
        <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=modify"  name="EweaverForm" method="post">
        		<input type=hidden name=id value="<%=refobj.getId()%>">
                <input type=hidden name=moduleid value="<%=refobj.getModuleid()%>">
		<table>	
				<colgroup>
					<col width="20%">
					<col width="">
					<col width="">
				</colgroup>	
				<tr>                                                                                       
					<td class="FieldName" nowrap>
				<%=labelService.getLabelName("402881eb0bcbfd19010bcc484f170015")%>
					</td>
					<td class="FieldValue">
						<input style="width:95%" type="text" name="objname" value="<%=StringHelper.null2String(refobj.getObjname())%>" onChange="checkInput('objname','objnamespan')" />
						<span id=objnamespan></span>
					</td>
				</tr>	
				<tr>
					<td class="FieldName" nowrap>
				<%=labelService.getLabelName("402881eb0bcbfd19010bcc4b5c690016")%>
					</td>
					<td class="FieldValue">
						<TEXTAREA id="refurl" name="refurl" ROWS="5" COLS="80"><%=StringHelper.null2String(refobj.getRefurl())%></TEXTAREA>
					</td>
				</tr>					
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881eb0bcbfd19010bcc50bcd70017")%>
					</td>
					<td class="FieldValue">
						<input style="width:95%" type="text" name="reftable" value="<%=StringHelper.null2String(refobj.getReftable())%>"/>
					</td>
				</tr>			
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881eb0bcbfd19010bcc548f5b0019")%>

					</td>
					<td class="FieldValue">
						<input style="width:95%" type="text" name="keyfield" value="<%=StringHelper.null2String(refobj.getKeyfield())%>"/>
					</td>
				</tr>			
				<tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelName("402881eb0bcbfd19010bcc55f035001a")%>
					</td>
					<td class="FieldValue">
						<input style="width:95%" type="text" name="viewfield" value="<%=StringHelper.null2String(refobj.getViewfield())%>"/>
					</td>
				</tr>			
				<tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelName("402881eb0bcbfd19010bcc574f57001b")%>
					</td>
					<td class="FieldValue">
						<input style="width:95%" type="text" name="viewurl" value="<%=StringHelper.null2String(refobj.getViewurl())%>"/>
					</td>
				</tr>			
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881eb0bcbfd19010bcc5270960018")%>
					</td>
					<td class="FieldValue">
						<input style="width:95%" type="text" name="filter" value="<%=StringHelper.null2String(refobj.getFilter())%>"/>
					</td>
				</tr>	
				<tr>
					<td class="FieldName" nowrap>
						排序
					</td>
					<td class="FieldValue">
						<input style="width:95%" type="text" name="col1" value="<%=StringHelper.null2String(refobj.getCol1())%>"/>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						browser框名称
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="col2" value="<%=StringHelper.null2String(refobj.getCol2())%>"/>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e90bff7b07010bffecf6e0000d")%>
					</td>
					<td class="FieldValue">
						<input type="checkbox" name="isrefobjlink" value="1" <%if(StringHelper.null2String(refobj.getIsrefobjlink()).equals("1")){%> checked <%}%> />
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						是否多选

					</td>
					<td class="FieldValue">
						<input type="checkbox" name="ismulti" value="1" <%if(StringHelper.null2String(refobj.getIsmulti()).equals("1")){%> checked <%}%> />
					</td>
				</tr>	
				<tr>
					<td class="FieldName" nowrap>
						是否授权对象
					</td>
					<td class="FieldValue">
						<input type="checkbox" name="ispermobj" value="1" <%if(StringHelper.null2String(refobj.getIspermobj()).equals("1")){%> checked <%}%> />
					</td>
				</tr>
                   <tr>
					<td class="FieldName" nowrap>
						是否直接录入
					</td>
					<td class="FieldValue">
						<input type="checkbox" name="isdirectinput" value="1" <%if(StringHelper.null2String(refobj.getIsdirectinput()).equals("1")){%> checked <%}%> id="isdirect" onclick="ischecked()"/>
					</td>
				</tr>

                 <tr>
                 <td nowrap id="selname">
                     <%
                 if(NumberHelper.getIntegerValue(refobj.getIsdirectinput(),0)==1){
                %>
                     直接录入查询字段 <%}%>
                 </td>
					<td id="selfield">

             <% if(NumberHelper.getIntegerValue(refobj.getIsdirectinput(),0)==1){
                %>     <%-- <input style="width=95%" type="text" name="selfield" value="<%=StringHelper.null2String(refobj.getSelfield())%>"/>--%>
                       <TEXTAREA  name="selfield" ROWS="5" COLS="80"><%=StringHelper.null2String(refobj.getSelfield())%></TEXTAREA>
                        <%}%>
                    </td>
            </tr>
    <tr style="display:none">
					<td class="FieldName" nowrap>
						相同表单合并browser框
					</td>
					<td class="FieldValue">
                       <button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/refobj/refobjbrowserm.jsp','mgid','mgidspan','0');"></button>
                        <%
                            String strspan="";
                         if(!StringHelper.isEmpty(refobj.getMgid())){
                                 List list=StringHelper.string2ArrayList(refobj.getMgid(),",");
                             for(int i=0;i<list.size();i++){
                                 String id=(String)list.get(i);
                                 Refobj ref=refobjService.getRefobj(id);
                                 if(StringHelper.isEmpty(strspan)){
                                     strspan=ref.getObjname();
                                 }else{
                                    strspan+=","+ref.getObjname();
                                 }
                             }
                         }
                        %>
			<input type="hidden"  name="mgid" value="<%=StringHelper.null2String(refobj.getMgid())%>"/>
			<span id="mgidspan"><%=StringHelper.null2String(strspan)%></span>
					</td>
				</tr>
        </table>
		</form>	   
<script language="javascript">
   function onSubmit(){
   	checkfields="objname";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>"
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
   }
   function onDelete(id){

       Ext.Msg.buttonText={yes:'是',no:'否'};
              Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
                  if (btn == 'yes') {
                      Ext.Ajax.request({
                          url: ' <%=request.getContextPath()%>/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=delete&id='+id,
                          success: function() {
                              pop( '删除成功！');
                          }
                      });
                  }
              });
   }
          var section=null;
  function showMenu(e){
    e.preventDefault();
    section=document.selection.createRange();  //获得鼠标所选中的区域
    var target = e.getTarget();
	menu.show(target);
	var pos=e.getXY();
	menu.showAt(pos);
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
        function getBrowser(viewurl, inputname, inputspan, isneed) {
        var id;
        try {
            id = openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=' + viewurl);
        } catch(e) {
        }
        if (id != null) {
            if (id[0] != '0') {
                document.all(inputname).value = id[0];
                document.all(inputspan).innerHTML = id[1];
            } else {
                document.all(inputname).value = '';
                if (isneed == '0')
                    document.all(inputspan).innerHTML = '';
                else
                    document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
        }
    }
 </script>		   
		   
  </body>
 </html>