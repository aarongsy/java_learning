<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.setitem.model.Setitem"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.searchcustomize.service.SearchcustomizeService"%>
<%@ page import="com.eweaver.base.searchcustomize.model.*"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%
	SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");

	Humres humres = new Humres();

String showCheckbox="true";
String tablename = "humres";
HumresService humresService = (HumresService) BaseContext.getBean("humresService"); 
OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService"); 
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
 String sqlwhere= StringHelper.null2String(request.getParameter("sqlwhere"));
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");


boolean allowSwitch=sysuserService.isAllowSwitch();
if(allowSwitch){
   Sysuser su=(Sysuser)request.getSession(true).getAttribute("eweaver_user@bean");
  if(!sysuserService.checkUserPerm(su,request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.SwitchUserAction"))
  allowSwitch=false;
}
String jsonStr=null;
//Map queryFilterMap = (Map)request.getSession().getAttribute("sysuserQueryFilter");
 /*if(queryFilterMap != null){
        JSONObject jsonObject=new JSONObject();
        Set keySet=queryFilterMap.keySet();
        for(Object key:keySet){
            try{
            String value=(String)queryFilterMap.get(key);
             if(!StringHelper.isEmpty(value))
            jsonObject.put(key,value);
            }catch(Exception e)
            {
                e.toString();
            }

        }
        if(!"".equals(sqlwhere.trim())){
        jsonObject.put("sqlwhere",sqlwhere);
        }
        jsonStr=jsonObject.toString();
    }*/
%>
<%
	pagemenustr += "addBtn(tb,'"
			+ labelService
					.getLabelName("402881e60aa85b6e010aa862c2ed0004")
			+ "','S','zoom',function(){onSubmit()});";
	pagemenustr += "addBtn(tb,'关闭选中的帐号','C','lock',function(){onClose()});";
	pagemenustr += "addBtn(tb,'打开选中的帐号','O','lock_open',function(){onOpen()});";

	Setitem setitempass=setitemService.getSetitem("402888534deft8d001besxe952edgy15");
    if(setitempass.getItemvalue().equals("1")) {
		pagemenustr += "addBtn(tb,'关闭动态密码','C','lock',function(){onCloseDynamicpass()});";
		pagemenustr += "addBtn(tb,'打开动态密码','O','lock_open',function(){onOpenDynamicpass()});";
    }
    Setitem setitemUserKey=setitemService.getSetitem("402888534deft8d001besxe952edgy16");
    if(setitemUserKey.getItemvalue().equals("1")) {
		pagemenustr += "addBtn(tb,'关闭usbkey','C','lock',function(){onCloseUsbkey()});";
		pagemenustr += "addBtn(tb,'打开usbkey','O','lock_open',function(){onOpenUsbkey()});";
    }
    /****************************************暂时注释掉IM start*********************************************/
    Setitem setitemIm=setitemService.getSetitem("40288347363855d101363855d2030293");
    if(setitemIm!=null&&StringHelper.null2String(setitemIm.getItemvalue()).equals("1")) {
 		pagemenustr +="addBtn(tb,'启用IM','C','lock',function(){onCloseOpenCol(1,'openim')});";
    	pagemenustr +="addBtn(tb,'关闭IM','O','lock_open',function(){onCloseOpenCol(0,'closeim')});";
    }
    /****************************************暂时注释掉IM end*********************************************/
	pagemenustr += "addBtn(tb,'清空','R','erase',function(){onReset()});";
%>
<html>
  <head>
  <style type="text/css">
        .x-toolbar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
      #pagemenubar table {width:0}
   a { color:blue; cursor:pointer; }
  </style>
  <script language="JScript.Encode" src="<%= request.getContextPath()%>/js/rtxint.js"></script>
  <script language="JScript.Encode" src="<%= request.getContextPath()%>/js/browinfo.js"></script>

  <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery/jquery-1.7.2.min.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type='text/javascript' src='<%= request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
  <script type="text/javascript">
 Ext.LoadMask.prototype.msg='加载中,请稍后...';
    var store;
    var selected=new Array();
    var dlg0;
  <%
   String action=request.getContextPath()+"/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=isgetsysuser";
  %>
          Ext.onReady(function(){
              Ext.QuickTips.init();
          <%if(!pagemenustr.equals("")){%>
              var tb = new Ext.Toolbar();
              tb.render('pagemenubar');
          <%=pagemenustr%>
          <%}%>
	    store = new Ext.data.Store({
	        proxy: new Ext.data.HttpProxy({
	            url: '<%=action%>'
	        }),
	        reader: new Ext.data.JsonReader({
	            root: 'result',
	            totalProperty: 'totalcount',
	            fields: ['objname','loginnum','hrstatus','dept','isclose','dynamicpass','isopenim','isusbkey','login','id','objid']
	        })
	
	    });
    //store.setDefaultSort('id', 'desc');

    var sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([sm, {header: "姓名",  sortable: false,  dataIndex: 'objname'},
                {header: "账号", sortable: false,   dataIndex: 'loginnum'},
                {header: "人事状态", sortable: false,   dataIndex: 'hrstatus'},
                {header: "部门", sortable: false,   dataIndex: 'dept'},
                {header: "账号状态",  sortable: false, dataIndex: 'isclose'},
                {header:"动态密码", sortable:false, dataIndex:'dynamicpass'},
                {header: "IM状态",  sortable: false, dataIndex: 'isopenim'},
                {header:"usbkey", sortable:false, dataIndex:'isusbkey'},
                {header: "&nbsp;", sortable: false, dataIndex: 'login'}]);
    
    resizeExtGridColumnWidth(cm);

    cm.defaultSortable = true;

                   var grid = new Ext.grid.GridPanel({
                       region: 'center',
                       store: store,
                       cm: cm,
                       trackMouseOver:false,
                       sm:sm ,
                       loadMask: true,
                       viewConfig: {
                           forceFit: isResizeExtGridColumn() ? false : true,
                           enableRowBody:true,
                           sortAscText:'升序',
                           sortDescText:'降序',
                           columnsText:'列定义',
                           getRowClass : function(record, rowIndex, p, store){
                               return 'x-grid3-row-collapsed';
                           }
                       },
                       bbar: new Ext.PagingToolbar({
                           pageSize: 20,
            store: store,
            displayInfo: true,
            beforePageText:"第",
            afterPageText:"页/{0}",
            firstText:"第一页",
            prevText:"上页",
            nextText:"下页",
            lastText:"最后页",
            displayMsg: '显示 {0} - {1}条记录 / {2}',
            emptyMsg: "没有结果返回"
        })

    });
    /*store.on('beforeload',function(){
        alert(selected.length);
    });*/

   //store.baseParams=<%=(jsonStr==null?"{}":jsonStr)%>

    store.on('load',function(st,recs){
        for(var i=0;i<recs.length;i++){
            var reqid=recs[i].get('objid');
        for(var j=0;j<selected.length;j++){
                    if(reqid ==selected[j]){
                         sm.selectRecords([recs[i]],true);
                     }
                 }
    }
    }
            );
    sm.on('rowselect',function(selMdl,rowIndex,rec ){
        var reqid=rec.get('objid');
        for(var i=0;i<selected.length;i++){
                    if(reqid ==selected[i]){
                         return;
                     }
                 }
        selected.push(reqid)
    }
            );
    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        var reqid=rec.get('objid');
        for(var i=0;i<selected.length;i++){
                    if(reqid ==selected[i]){
                        selected.remove(reqid)
                         return;
                     }
                 }

    }
            );

    //Viewport
var viewport = new Ext.Viewport({
          layout: 'border',
        items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
	});
       store.baseParams.issysuser=1;
      store.load({params:{start:0, limit:20}});
    dlg0 = new Ext.Window({
                layout:'border',
                closeAction:'hide',
                plain: true,
                modal :true,
                width:viewport.getSize().width*0.8,
                height:viewport.getSize().height*0.8,
                buttons: [{
                    text     : '关闭',
                    handler  : function(){
                        dlg0.hide();
                         selected=[];
                         onSubmit();
                    } 

                }],
                items:[{
                id:'dlgpanel',
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            }] 
            });
});

  function clicknum(url)
  {
     this.dlg0.setTitle('登录账号');
    this.dlg0.getComponent('dlgpanel').setSrc(url);
    this.dlg0.show();
  }
	function onClose(){
	   if(selected.length==0){
	       Ext.Msg.buttonText={ok:'确定'};
		   Ext.MessageBox.alert('', '请选择账号！');
		   return;
	   }
	   if(selected.toString().indexOf("402881e70be6d209010be75668750014") != -1){
			Ext.Msg.buttonText={ok:'确定'};
			Ext.MessageBox.alert('', '选择关闭的账号中包含sysadmin，sysadmin不能被关闭，请更正！');
			return;
	   }
	   Ext.Ajax.request({
	       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=close',
	       params:{ids:selected.toString()},
	       success: function(res) {
	           if (res.responseText == 'nolic') {
	               dlg0.getComponent('dlgpanel').setSrc('<%=request.getContextPath()%>/base/lics/licsin.jsp');
	                dlg0.show();
	            } else if (res.responseText == 'noright'){
	                Ext.Msg.buttonText={ok:'确定'};
		            Ext.MessageBox.alert('', '没有权限！',function(){
		                selected=[];
		                onSubmit();
		            }) ;
	            }else if(res.responseText=='ok'){
			    	Ext.Msg.buttonText={ok:'确定'};                                                
			    	Ext.MessageBox.alert('', '账号已成功关闭！', function() {
				        selected=[];
				        onSubmit();
				    })
			    }else{
			        Ext.Msg.buttonText={ok:'确定'};                                                
			    	Ext.MessageBox.alert('',"姓名为："+res.responseText+"没有账号无法关闭！", function() {
				        selected=[];
				        onSubmit();
				    })
				}
	        }
	    });
	}

	function onOpen() {
	    if(selected.length==0){
	        Ext.Msg.buttonText={ok:'确定'};
		    Ext.MessageBox.alert('', '请选择账号！');
		    return;
	    }
	    Ext.Ajax.request({
	        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=open',
	        params:{ids:selected.toString()},
	        success: function(res) {
	            if (res.responseText == 'nolic') {
	                //dlg0.getComponent('dlgpanel').setSrc('<%=request.getContextPath()%>/base/lics/licsin.jsp');
	                //dlg0.show();
					Ext.Msg.buttonText={ok:'确定'};
	              	Ext.MessageBox.alert('', '超出License限制!',function(){
	                 selected=[];
	                onSubmit(); 
	              }) ;
	            } else if (res.responseText == 'noright'){
	                Ext.Msg.buttonText={ok:'确定'};
	              Ext.MessageBox.alert('', '没有权限！',function(){
	                 selected=[];
	                onSubmit(); 
	              }) ;
	
	            } else if(res.responseText=='ok'){
			    	Ext.Msg.buttonText={ok:'确定'};                                                
			    	Ext.MessageBox.alert('', '账号已成功打开！', function() {
				        selected=[];
				        onSubmit();
				    })
			    }else{
			        Ext.Msg.buttonText={ok:'确定'};                                                
			    	Ext.MessageBox.alert('',"姓名为："+res.responseText+"没有账号无法打开！", function() {
				        selected=[];
				        onSubmit();
				    })
				}
	        }
	    });
	}
 
	function onCloseDynamicpass(){
	    if(selected.length==0){
	        Ext.Msg.buttonText={ok:'确定'};
		    Ext.MessageBox.alert('', '请选择账号！');
		    return;
	    }
	    Ext.Ajax.request({
	        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=closedynamicpass',
	        params:{ids:selected.toString()},
	        success: function(res) {
	            if (res.responseText == 'nolic') {
	                dlg0.getComponent('dlgpanel').setSrc('<%=request.getContextPath()%>/base/lics/licsin.jsp');
	                dlg0.show();
	            } else if (res.responseText == 'noright'){
	                Ext.Msg.buttonText={ok:'确定'};
		            Ext.MessageBox.alert('', '没有权限！',function(){
		                selected=[];
		                onSubmit();
		            }) ;
	            } else{
	                Ext.Msg.buttonText={ok:'确定'};
		            Ext.MessageBox.alert('', '动态密码已成功关闭！', function() {
		                selected=[];
		                onSubmit();
		            })
		        }
	        }
	    });
	}

	function onOpenDynamicpass() {
		if(selected.length==0){
		    Ext.Msg.buttonText={ok:'确定'};
			Ext.MessageBox.alert('', '请选择账号！');
			return;
		}
		Ext.Ajax.request({
			url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=opendynamicpass',
			params:{ids:selected.toString()},
			success: function(res) {
			    if (res.responseText == 'nolic') {
			        dlg0.getComponent('dlgpanel').setSrc('<%=request.getContextPath()%>/base/lics/licsin.jsp');
			        dlg0.show();
			
			    } else if (res.responseText == 'noright'){
			        Ext.Msg.buttonText={ok:'确定'};
			      Ext.MessageBox.alert('', '没有权限！',function(){
			         selected=[];
			        onSubmit(); 
			      }) ;
			
			    } else{
			        Ext.Msg.buttonText={ok:'确定'};                                                
				    Ext.MessageBox.alert('', '动态密码已成功打开！', function() {
				        selected=[];
				        onSubmit();
				    })
				}
			}
		});
	}
 
	function onCloseUsbkey(){
	    if(selected.length==0){
	        Ext.Msg.buttonText={ok:'确定'};
		    Ext.MessageBox.alert('', '请选择账号！');
		    return;
	    }
	    Ext.Ajax.request({
	        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=closeusbkey',
			params:{ids:selected.toString()},
			success: function(res) {
			    if (res.responseText == 'nolic') {
			        dlg0.getComponent('dlgpanel').setSrc('<%=request.getContextPath()%>/base/lics/licsin.jsp');
			        dlg0.show();
			    } else if (res.responseText == 'noright'){
			        Ext.Msg.buttonText={ok:'确定'};
				    Ext.MessageBox.alert('', '没有权限！',function(){
				        selected=[];
				        onSubmit();
				    }) ;
			    } else{
			        Ext.Msg.buttonText={ok:'确定'};
				    Ext.MessageBox.alert('', 'USBKEY已成功关闭！', function() {
				        selected=[];
				        onSubmit();
				    })
				}
	        }
	    });
	}

	function onOpenUsbkey() {
	    if(selected.length==0){
	        Ext.Msg.buttonText={ok:'确定'};
		    Ext.MessageBox.alert('', '请选择账号！');
		    return;
	    }
	    Ext.Ajax.request({
	        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=openusbkey',
			params:{ids:selected.toString()},
			success: function(res) {
			    if (res.responseText == 'nolic') {
			        dlg0.getComponent('dlgpanel').setSrc('<%=request.getContextPath()%>/base/lics/licsin.jsp');
			        dlg0.show();
			
			    } else if (res.responseText == 'noright'){
					Ext.Msg.buttonText={ok:'确定'};
					Ext.MessageBox.alert('', '没有权限！',function(){
						selected=[];
						onSubmit(); 
					}) ;
			    } else if(res.responseText=='ok'){
			    	Ext.Msg.buttonText={ok:'确定'};                                                
			    	Ext.MessageBox.alert('', 'USBKEY成功打开！', function() {
				        selected=[];
				        onSubmit();
				    })
			    }else{
			        Ext.Msg.buttonText={ok:'确定'};                                                
			    	Ext.MessageBox.alert('',"账号为："+res.responseText+"没有usbkey密钥无法打开！", function() {
				        selected=[];
				        onSubmit();
				    })
				}
	        }
	    });
	}
 
   function onReset() {
         $j('#EweaverForm span').text('');
         $j('#EweaverForm input[type=text]').val('');
         $j('#EweaverForm input[type=checkbox]').each(function(){
             this.checked=false;
         });
         $j('#EweaverForm input[type=hidden]').val('');
         $j('#EweaverForm select').val('');

       }
  </script>

  </head>     
  <body>
<div id="divSearch" >
<div id="pagemenubar"></div>
  <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=list" id='EweaverForm' name="EweaverForm"  method="post">
      <input type="hidden" value="1" name="issysuser" id="issysuser">
      <table id=searchTable>
    <tr>
      <td class="FieldName" width=10% nowrap>
			   <%=labelService.getLabelName("402881e70b7728ca010b7730905d000b")%>
		 </td>
		 <td class="FieldName" width=15% nowrap>
			 <input type="text" class="InputStyle2" size="8" name="objname" />
		 </td>
         <td class="FieldName" width=10% nowrap>
			人事状态&nbsp;
		</td>
		<td class="FieldName" width=15% nowrap>
			 <select name="hrstatus">
			 	<option></option>
                 <%
           List selectitemlist=selectitemService.getSelectitemList2("402881ea0b1c751a010b1ccf7dbe0002",null); //402881ea0b1c751a010b1ccf7dbe0002为人事状态的id
               Iterator it2 = selectitemlist.iterator();
                     while(it2.hasNext()){
                         Selectitem selectitem=(Selectitem)it2.next();
        %>

                <option value=<%=selectitem.getId()%> ><%=selectitem.getObjname()%></option>
				 <%}%>
             </select>
		 </td>
         <td class="FieldName" width=10% nowrap>所属部门
         </td>
         <td class="FieldName" width=15% nowrap>
              <%
                  StringBuffer sb=new StringBuffer();
                  StringBuffer directscript=new StringBuffer();
                RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
			Refobj refobj = refobjService.getRefobj("402881e60bfee880010bff17101a000c");//部门的fieldtype
			if(refobj != null){
				String _refid = StringHelper.null2String(refobj.getId());
				String _refurl = StringHelper.null2String(refobj.getRefurl());
				String _viewurl = StringHelper.null2String(refobj.getViewurl());
				String _reftable = StringHelper.null2String(refobj.getReftable());
				String _keyfield = StringHelper.null2String(refobj.getKeyfield());
				String _viewfield = StringHelper.null2String(refobj.getViewfield());
				String showname = "";
                 int isdirect=NumberHelper.getIntegerValue(refobj.getIsdirectinput(),0).intValue();
                 String _selfield=StringHelper.null2String(refobj.getSelfield());
                _selfield=StringHelper.getEncodeStr(_selfield);
                 if(isdirect==1)
                {
                  //加一个用于提示的文本框
                 	if (!StringHelper.isEmpty(_selfield)) {
                	    _selfield = _selfield.replaceAll("\r\n"," ");
					}
                    sb.append("<input type=text class=\"InputStyle2\" name=orgunitids id=orgid onfocus=\"checkdirect(this)\">");
                    directscript.append(" $(\"#orgid\").autocomplete(\""+request.getContextPath()+"/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=getdemo&reftable="+_reftable+"&viewfield="+_viewfield+"&selfield="+_selfield+"&keyfield="+_keyfield+"\", {\n" +
                                         "\t\twidth: 260,\n" +
                                                    "        max:15,\n" +
                                                    "        matchCase:true,\n" +
                                                    "        scroll: true,\n" +
                                                    "        scrollHeight: 300,          \n" +
                                                    "        selectFirst: false});");


                                 directscript.append("\n" +
                                     "                             $(\"#orgid\").result(function(event, data, formatted) {\n" +
                                     "                                     if (data)\n" +
                                     "                                         document.getElementById('conorgunitid').value=data[1];\n" +
                                     "                                 });");

                }
                sb.append(" <input type='button'  class=Browser onclick=\"javascript:getBrowser('"+request.getContextPath()+"/base/refobj/baseobjbrowser.jsp?id=402881e60bfee880010bff17101a000c','orgunitid','orgunitidspan','0');\"/>");
                  if(isdirect==1)
                sb.append(" <input type=\"hidden\" id=conorgunitid  name=\"orgunitid\"/>");
                else
                 sb.append(" <input type=\"hidden\"  name=\"orgunitid\"/>");
sb.append(" <span id=orgunitidspan></span>\n" +
"       <input type=\"checkbox\" id=\"checkbox\" name=\"checkbox\"\n" +
"\t\t\t onClick=\"javascript:checkSub(this)\">");
            }
                   out.print(sb.toString());
              %>

	     </td>
	     	<td class="FieldName" width=10% nowrap>
			 帐号状态&nbsp;
			 </td>
			 <td class="FieldName" width=15% nowrap>
			 <select name="logonStatus">
			 	<option></option>
				<option value="0" >正常</option>
				<option value="1" >关闭</option>
			 </select>
		 </td>
    </tr>
      <tr>


		 <td class="FieldName" width=10% nowrap>
			   <%=labelService.getLabelName("402881eb0bcbfd19010bccd7006a0041")%>
		 </td>

		 <td class="FieldName" width=15% nowrap>
			 <input type="text" class="InputStyle2" size="8" name="counter" />
		 </td>
		<td class="FieldName" width=10% nowrap>
			 动态密码&nbsp;
	    </td>
	    <td class="FieldName" width=15% nowrap>
			 <select name="dynamicpass">
			 	<option></option>
				<option value="0" >未启用</option>
				<option value="1" >已启用</option>
			 </select>
		 </td>
		 <td class="FieldName" width=10% nowrap>
			 UKEY状态&nbsp;
			 </td>
		<td class="FieldName" width=15% nowrap>
			 <select name="isusb">
			 	<option></option>
				<option value="0" >未启用</option>
				<option value="1" >已启用</option>
			 </select>
		 </td>
		 <td class="FieldName" width=10% nowrap>
			 IM状态&nbsp;
			</td>
		<td class="FieldName" width=15% nowrap>
			 <select name="isim">
			 	<option></option>
				<option value="0" >未启用</option>
				<option value="1" >已启用</option>
			 </select>
		 </td>
		 </tr>		
		</table>
		<input type="hidden" name="sqlwhere" value="<%=sqlwhere%>" />
		</form>
	</div>


<script language="javascript" type="text/javascript">
       var inputid;
      var spanid;
      var temp;
     function checkdirect(obj)
  {
      inputid=obj.id;
      spanid=obj.name;

	temp = 0;
}
var $j = jQuery.noConflict();
$j(document).ready(function($){
              <%=directscript%>
         $.Autocompleter.Selection = function(field, start, end) {
             if( field.createTextRange ){
              var selRange = field.createTextRange();
              selRange.collapse(true);
              selRange.moveStart("character", start);
              selRange.moveEnd("character", end);
              selRange.select();
              if(inputid==undefined||spanid==undefined)
                 return;
               var len=field.value.indexOf("  ");
                   if(temp==0&&len>0){
                   temp=1;
               var  length=field.value.length;

               var data=field.value;

              document.getElementById(inputid).value=field.value.substring(0,field.value.indexOf("  "));
             document.getElementById(spanid+'pan').innerHTML= data.substring(len,length);
               }else{

                 var data=field.value;

              document.getElementById(inputid).value=data;
             document.getElementById(spanid+'pan').innerHTML= data;

                   }
       } else if( field.setSelectionRange ){
              field.setSelectionRange(start, end);
          } else {
                 if( field.selectionStart ){
                  field.selectionStart = start;
                  field.selectionEnd = end;
              }
          }
          field.focus();
      };

       });
function onSubmit(){
     var o=$j('#EweaverForm').serializeArray();
       var data={};
       for(var i=0;i<o.length;i++) {
           if(o[i].value!=null&&o[i].value!=""){
           data[o[i].name]=o[i].value;
           }
       }
       store.baseParams=data;
       store.load({params:{start:0, limit:20}});
}
       $j(document).keydown(function(event) {
             if (event.keyCode == 13) {
                onSubmit();
             }
         });
  function onCloseOpenCol(val,type) {
     if(selected.length==0){
         Ext.Msg.buttonText={ok:'确定'};
     Ext.MessageBox.alert('', '请选择账号！');
     return;
     }
     Ext.Ajax.request({
         url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action='+type+'',
         params:{ids:selected.toString()},
         success: function(res) {
             if (res.responseText == 'nolic') {
                 dlg0.getComponent('dlgpanel').setSrc('<%= request.getContextPath()%>/base/lics/licsin.jsp');
                 dlg0.show();

             } else if (res.responseText == 'noright'){
                 Ext.Msg.buttonText={ok:'确定'};
               Ext.MessageBox.alert('', '没有权限！',function(){
                  selected=[];
                 onSubmit(); 
               }) ;

             } else{
                 Ext.Msg.buttonText={ok:'确定'};                                                
             Ext.MessageBox.alert('', '操作成功！', function() {
                 selected=[];
                 onSubmit();
             })
         }
         }
     });


 }
function checkSub(e){
    if(e.checked){
        document.all("checkbox").value="1";
	}
	else {
        document.all("checkbox").value="" ;
	}
}
function checkAll(e, itemName){
	if(e.checked){
		e.value = "1";
	}else{
		e.value = "0";
	}
	var elements = document.getElementsByName(itemName);
	for (var i=0; i<elements.length; i++){
   		elements[i].checked = e.checked;
   		elements[i].value = e.value;
	}
}
function checkItem(e, allBoxId){
	var all = document.getElementById(allBoxId);
	if(!e.checked){
		e.value = "0";
		all.checked = false;
	}else{
		e.value = "1";
		var elements = document.getElementsByName(e.name);	
		for (var i=0; i<elements.length; i++){	
			if(!elements[i].checked) return;
		}
		all.checked = true;
	}
}
function getBrowser(viewurl,inputname,inputspan,isneed){
            if(document.getElementById(inputname.replace("orgunit","org"))!=null)
     document.getElementById(inputname.replace("orgunit","org")).value="";
       
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url='+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
</script>
<script>
    function switchUser(obj) {
        top.location.href = "<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SwitchSysAdminAction?id=" + obj;
    }
</script>
  </body>
</html>
