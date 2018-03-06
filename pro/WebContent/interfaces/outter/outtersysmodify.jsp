<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.base.security.service.logic.CardCombinationService" %>
<%@ page import="com.eweaver.base.security.model.Cardcombination" %>
<%@ page import="com.eweaver.base.security.model.Cardcombinationdetail" %>
<%@ page import="com.eweaver.interfaces.outter.service.OuttersysService" %>
<%@ page import="com.eweaver.interfaces.outter.model.Outtersys" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
    String sysid=StringHelper.null2String(request.getParameter("sysid"));
    OuttersysService outtersysService=(OuttersysService)BaseContext.getBean("outtersysService");
    Outtersys outtersys=new Outtersys();
    if(!StringHelper.isEmpty(sysid)){
        String  sql="from Outtersys where sysid='"+sysid+"'";
        List list=outtersysService.getOuttersyses(sql);
           outtersys=(Outtersys)list.get(0);
    }
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.interfaces.outter.servlet.OuttersysAction?action=detaillist";
%>

<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";
%>
<html>
  <head>
         <style type="text/css">
     .x-toolbar table {width:0}
     #pagemenubar table {width:0}
       .x-panel-btns-ct {
         padding: 0px;
     }
     .x-panel-btns-ct table {width:0}
        a { color:blue; cursor:pointer; }
   </style>
   <script src="<%= request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
   <script src="<%= request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%= request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
     <script type="text/javascript">
         Ext.SSL_SECURE_URL='about:blank';
         Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
         var store;
         var dlg0;
         var selected = new Array();         
         Ext.onReady(function() {
             Ext.QuickTips.init();
         <%if(!pagemenustr.equals("")){%>
             var tb = new Ext.Toolbar();
             tb.render('pagemenubar');
         <%=pagemenustr%>
         <%}%>
          var objtypestore=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['1','<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379001a")%>'],['2','<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790015")%>']]//固定值//用户录入
                  });
             store = new Ext.data.Store({
                 proxy: new Ext.data.HttpProxy({
                     url: '<%=action%>'
                 }),
                 reader: new Ext.data.JsonReader({
                     root: 'result',
                     totalProperty: 'totalcount',
                     fields: ['objname','labelname','objtype','objtypevalue','id']


                 })

             });
             var fm = Ext.form;
                  function objtypeRender(value, m, record, rowIndex, colIndex){

              var objtype=objtypestore.getById(value);
           if (typeof(objtype) == "undefined")

               return ''
           else
               return objtype.get('text');
          }
             var sm = new Ext.grid.CheckboxSelectionModel();             
             var cm = new Ext.grid.ColumnModel([sm,{header: "<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379001c")%>", sortable: false,  dataIndex: 'objname',editor:new fm.TextField({//参数名称
                      allowBlank: true
                  })},
                 {header: "<%=labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026")%>",  sortable: false, dataIndex: 'objtype',renderer:objtypeRender },//类型
                      {header: "<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbe161b000b")%>", sortable: false,   dataIndex: 'labelname',editor:new fm.TextField({//标签名
                      allowBlank: true
                  })},
                 {header: "<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379001a")%>", sortable: false,   dataIndex: 'objtypevalue'},//固定值
                   {header: "", sortable: false,   dataIndex: 'id',hidden:true}
             ]);
             var Plant = Ext.data.Record.create([
          {name: 'objname', type: 'string'},
          {name: 'labelname', type: 'string'},
          {name: 'objtype', type: 'string'},
         {name: 'objtypevalue', type: 'string'},
           {name: 'id', type: 'string'},


      ]);
             var grid = new Ext.grid.EditorGridPanel({
                 region: 'center',
                 store: store,
                 cm: cm,
                 sm:sm ,
                 trackMouseOver:false,
                 loadMask: true,
                  viewConfig: {
                                          forceFit:true,
                                          enableRowBody:true,
                                          sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                                          sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                                          columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                                          getRowClass : function(record, rowIndex, p, store){
                                              return 'x-grid3-row-collapsed';
                                          }
                                      },
   tbar: [{
          text: '<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290049")%>',//添加
          handler : function(){
              var p = new Plant({
                  objname: '',
                  objtype: '',
                  labelname: '',
                  objtypevalue: '',
                  id:''

              });
              grid.stopEditing();
              store.insert(0, p);
              grid.startEditing(0, 0);
          }
      },{
          text: '<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%>',//删除
          handler : function(){
             onDelete();
          }
      }],                                      bbar: new Ext.PagingToolbar({
                                          pageSize: 20,
                           store: store,
                           displayInfo: true,
                           beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
                           afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
                           firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
                           prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
                           nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
                           lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
                           displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示//条记录
                           emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
                       }),
                   listeners : {
                      'afteredit' : function(e) {
                          if(e.column ==2){
                              if(e.value==2){
                                  e.record.set('objtypevalue','');
                              }else{
                                     e.record.set('labelname','');
                              }
                          }
                      }
                   }

             });
             store.baseParams.sysid='<%=sysid%>';
             store.load({params:{start:0, limit:20}});
              sm.on('rowselect',function(selMdl,rowIndex,rec ){
                  var reqid=rec.get('id');
                  for(var i=0;i<selected.length;i++){
                              if(reqid ==selected[i]){
                                   return;
                               }
                           }
                  selected.push(reqid)
              }
                      );
              sm.on('rowdeselect',function(selMdl,rowIndex,rec){
                  var reqid=rec.get('id');
                  for(var i=0;i<selected.length;i++){
                              if(reqid ==selected[i]){
                                  selected.remove(reqid)
                                   return;
                               }
                           }

              }
                      );
             //Viewport
              grid.on("cellclick",function (grid, rowIndex, columnIndex, e) {
                  var record = grid.store.getAt(rowIndex);
                  if(columnIndex==2){
                       grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                  typeAhead: true,
                  triggerAction: 'all',
                  store:objtypestore,
                  mode: 'local',
                  valueField:'value',
                  displayField:'text',
                  listClass: 'x-combo-list-small'})));
                  }
                  if(columnIndex==3){
                      if (record.get('objtype') == 2) {
                          grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
                              allowBlank: true
                          })));
                      } else {
                          grid.getColumnModel().setEditor(columnIndex, null);
                      }
                  }
                  if (columnIndex == 4) {
                      if (record.get('objtype') == 1) {
                          grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
                              allowBlank: true
                          })));
                      } else {
                          grid.getColumnModel().setEditor(columnIndex, null);
                      }
                  }

              });
             var viewport = new Ext.Viewport({
                 layout: 'border',
                 items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
             });
         });

   </script>
  </head>
  <body>
  <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.interfaces.outter.servlet.OuttersysAction?action=modify" name="EweaverForm" method="post">
<input type="hidden" id="id" name="id" value="<%=outtersys.getId()%>">
    <input type="hidden" name="jsonstr" id="jsonstr" value="" >
    <table>
        <colgroup>
            <col width="50%">
            <col width="50%">
        </colgroup>
        <tr>
            <td valign=top>
                <table class=noborder>
                    <colgroup>
                        <col width="20%">
                        <col width="80%">
                    </colgroup>
                     <tr>
                        <td class="FieldName" nowrap>
                            <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790012")%><!-- 标识 -->
                        </td>
                        <td class="FieldValue">
                            <input type="text" class="InputStyle2" style="width:95%" name="sysid" value="<%=StringHelper.null2String(outtersys.getSysid())%>" readonly="true"/>
                            <img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldName" nowrap>
                            <%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc16ecb1000b")%><!-- 名称 -->
                        </td>
                        <td class="FieldValue">
                            <input type="text" class="InputStyle2" style="width:95%" name="objname" value="<%=StringHelper.null2String(outtersys.getObjname())%>"/>
                            <img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                        </td>
                    </tr>

                    <tr>
                        <td class="FieldName" nowrap>
                            <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7378000e")%><!-- 内网地址 -->
                        </td>
                        <td class="FieldValue">
                            <input type="text" class="InputStyle2" style="width:95%" name="inneradd" value="<%=StringHelper.null2String(outtersys.getInneradd())%>"/>
                            <img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldName" nowrap>
                            <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7378000f")%><!-- 外网地址 -->
                        </td>
                        <td class="FieldValue">
                            <input type="text" class="InputStyle2" style="width:95%" name="outteradd" value="<%=StringHelper.null2String(outtersys.getOutteradd())%>"/>
                            <img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                        </td>
                    </tr>
                       <tr>
                        <td class="FieldName" nowrap>
                            <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790013")%><!-- 账号登入方式 -->
                        </td>
                        <td class="FieldValue">
                            <%
                             String sel1="";
                             String sel2="";
                             if(outtersys.getUsernametype()!=null){
                            int usernametype=outtersys.getUsernametype().intValue();
                                if(usernametype==1){
                                    sel1="selected";
                                }else{
                                    sel2="selected";
                                }
                             }
                            %>
                            <select name="usernametype" id="usernametype" onchange="usernamechange(this)">
                                <option value="1" <%=sel1%>><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790014")%></option><!-- 使用eweaver账号 -->
                                <option value="2" <%=sel2%>><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790015")%></option><!-- 用户录入 -->
                            </select>

                        </td>
                    </tr>
                    <tr>
                        <td class="FieldName" nowrap>
                            <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780010")%><!-- 账号参数名 -->
                        </td>
                        <td class="FieldValue">
                            <input type="text" class="InputStyle2" style="width:95%" name="username" value="<%=StringHelper.null2String(outtersys.getUsername())%>"/>
                        </td>
                    </tr>
                    <tr>
                    <td class="FieldName" nowrap>
                   <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790016")%><!-- 密码登入方式 -->
                    </td>
                    <td class="FieldValue">
                        <%
                         String select1="";
                         String select2="";
                         if(outtersys.getPasstype()!=null){
                        int passtype=outtersys.getPasstype().intValue();
                            if(passtype==1){
                                    select1="selected";
                            }else{
                                   select2="selected";
                            }
                         }
                        %>
                        <select name="passtype" id="passtype" onchange="passtypechange(this)">
                            <option value="1" <%=select1%>><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790014")%></option><!-- 使用eweaver账号 -->
                            <option value="2" <%=select2%>><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790015")%></option><!-- 用户录入 -->
                        </select>
                    </td>
                </tr>

                    <tr>
                        <td class="FieldName" nowrap>
                            <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780011")%><!-- 密码参数名 -->
                        </td>
                        <td class="FieldValue">
                            <input type="text" class="InputStyle2" style="width:95%" name="pass" value="<%=StringHelper.null2String(outtersys.getPass())%>"/>
                        </td>
                    </tr>

                        <td class="FieldName" nowrap>
                            <%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e")%><!-- 说明 -->
                        </td>
                        <td class="FieldValue">
                            <TEXTAREA STYLE="width:100%" class=InputStyle rows=4 name="description"><%=StringHelper.null2String(outtersys.getDescription())%></TEXTAREA>

                        </td>
                    </tr>
                </table>


                <br>

            </td>
        </tr>
    </table>

</form>
  </div>
<script type="text/javascript">
    function onDelete(){
          var totalsize = selected.length;
              if (totalsize == 0) {
                  Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};//确定
                  Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7378000c")%>');//请选中您所要删除的内容！
                  return;
              }
               Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%>'};//是//否
              Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380075")%>', function (btn, text) {//您确定要删除吗?
                  if (btn == 'yes') {
                      Ext.Ajax.request({
                          url: ' <%= request.getContextPath()%>/ServiceAction/com.eweaver.interfaces.outter.servlet.OuttersysAction?action=delDetail',
                          params:{ids:selected.toString(),sysid:'<%=sysid%>'},
                          success: function() {
                           store.load({params:{start:0, limit:20}});
                          }
                      });
                  } else {
                      selected=[];
                      store.load({params:{start:0, limit:20}});
                  }
              });
    }
    function onModify(url){
        alert(url);
    location.href="<%=request.getContextPath()%>"+url;
}
    function onReturn(){
        document.location.href="<%=request.getContextPath()%>/interfaces/outter/outtersyslist.jsp";

    }
    function onSubmit(){
             records = store.getModifiedRecords();
          datas = new Array();
        for (i = 0; i < records.length; i++) {
            datas.push(records[i].data);
        }
        var jsonstr = Ext.util.JSON.encode(datas);
       document.all('jsonstr').value=jsonstr;
   	checkfields="";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}

    function usernamechange(obj){
        var username=document.all('username');
        if(obj.value==1){
            username.value='j_username';
        }else{
         username.value='';
        }

    }
      function passtypechange(obj){
          var pass=document.all('pass');
          if(obj.value==1){
              pass.value='j_password';
          }else{
              pass.value='';

          }
      }

</script>
  </body>
</html>
