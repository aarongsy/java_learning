<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ include file="/base/init.jsp"%>
<%
	String loginid = StringHelper.null2String(request.getParameter("loginid"));
	String msg = StringHelper.null2String(request.getParameter("msg"));
	String userId = StringHelper.null2String(request.getParameter("userId"));
	String beginDate = StringHelper.null2String(request.getParameter("beginDate"));
	String endDate = StringHelper.null2String(request.getParameter("endDate"));
	String imagefilename = "/images/hdDOC.gif";
	//String titlename = SystemEnv.getHtmlLabelName(24530, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	String action=request.getContextPath()+"/ServiceAction/com.eweaver.im.servlet.MessageHistoryAction?action=history";
%>
<%   
	pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch()});";
	pagemenustr +="addBtn(tb,'"+labelService.getLabelName("40288035248eb3e801248f6fb6da0042")+"','R','erase',function(){onReset()});";//清空条件
%>
<!--声明结束-->

<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
  <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/ux/css/ext-ux-wiz.css" />
  <style type="text/css">
       .x-toolbar table {width:0}
       #pagemenubar table {width:0}
         .x-panel-btns-ct {
           padding: 0px;
       }
       .x-panel-btns-ct table {width:0}
	   <!--.x-grid3-cell-inner{white-space:normal;}-->
   </style>
 
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/CardLayout.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Wizard.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Card.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Header.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/main.js"></script>
<SCRIPT language="javascript" src="<%=request.getContextPath()%>/datapicker/WdatePicker.js"></script>
  
	<script language="javascript">
	Ext.SSL_SECURE_URL='about:blank';
    Ext.LoadMask.prototype.msg='<%=labelService.getLabelName("402883d934c0e39a0134c0e39afa0000")%>';//加载...
    var store;
	function contentRender(value,p,record) {
	    p.attr = 'style="white-space:normal;word-break:break-all;"';
        return "<span>"+value+"</span>";
	}
	Ext.onReady(function() {
	   Ext.QuickTips.init();
	    var tb = new Ext.Toolbar();
        tb.render('pagemenubar');
        <%=pagemenustr%>
        store = new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({
                url: '<%=action%>'
            }),
            reader: new Ext.data.JsonReader({
                root: 'result',
                totalProperty: 'totalcount',
                fields: ['id','jidcurrent','sendto','msg','strtime']
            })
        });
        var cm = new Ext.grid.ColumnModel([{header: "发送者", sortable: false, width:80, dataIndex: 'jidcurrent'},//发送者
            {header: "接收者",  sortable: false, width:80, dataIndex: 'sendto'},//接收者
            {header: "内容",  sortable: false, width:200, dataIndex: 'msg', renderer:contentRender},//内容
            {header: "时间",  sortable: true, width:100, dataIndex: 'strtime'}//时间
        ]);
        cm.defaultSortable = true;
        var grid = new Ext.grid.GridPanel({
            region: 'center',
            store: store,
            cm: cm,
            trackMouseOver:false,
            loadMask: true,
             viewConfig: {
                                     forceFit:true,
                                     enableRowBody:true,
                                     sortAscText:'升序',//升序
                                     sortDescText:'降序',//降序
                                     columnsText:'列定义',//列定义
                                     getRowClass : function(record, rowIndex, p, store){
                                         return 'x-grid3-row-collapsed';
                                     }
                                 },
                                 bbar: new Ext.PagingToolbar({
                                     pageSize: 20,
                      store: store,
                      displayInfo: true,
                      beforePageText:"第",//第
                      afterPageText:"页/{0}",//页
                      firstText:"第一页",//第一页
                      prevText:"上页",//上页
                      nextText:"下页",//下页
                      lastText:"最后页",//最后页
                      displayMsg: '显示 {0} - {1}条记录 / {2}',//显示     条记录
                      emptyMsg: "没有结果返回"//没有结果返回
                  })

        });
        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
        });
        onSearch();
	});
	</script>
	<script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
</head>

<!--声明开始 此断请不要修改  可以放在此处，也可放在此文件开始处-->

<%----@ include file="/docs/docs/DocCommExt.jsp"--%>
<%--@ include file="/docs/DocDetailLog.jsp"--%>

<%--@ include file="/systeminfo/TopTitleExt.jsp"--%>
<BODY>

<%--@ include file="/systeminfo/RightClickMenuConent.jsp"--%>
<%--@ include file="/systeminfo/RightClickMenu.jsp"--%>

<div id="divSearch">
    <div id="pagemenubar"></div>
    <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.im.servlet.MessageHistoryAction?action=history" name="EweaverForm" id="EweaverForm" method="post" onsubmit="return false">
<table id=searchTable>
    <TR>
		<TD class="FieldName" width=10% nowrap>内容</TD>
		<TD class="FieldValue"><input type="text" name="msg" id="msg" value="<%=msg%>"	class="inputstyle"></TD>

		<TD class="FieldName" width=10% nowrap>用户</TD>
		<TD class="FieldValue" width=20% nowrap>


		<button type="button" class="Browser"
			onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/humresbrowser.jsp','userid','useridspan','0');"></button>
		    <input type="hidden"  name="userid" value="<%=userId %>"/>
			<span id="useridspan"></span>
	</TR>
	<TR>
		<td colspan=4 class="line"></td>
	</TR>
	<TR>
		<TD class="FieldName" width=10% nowrap>时间</TD>
		<TD class="FieldValue">
			
			<input type=text class=inputstyle size=10 name="beginDate"  value="<%=beginDate%>" onclick="WdatePicker()">
                    -
            <input type=text class=inputstyle size=10 name="endDate"  value="<%=endDate%>" onclick="WdatePicker()">        
	    </TD>
		<TD class="FieldName" width=10% nowrap></TD>
		<TD class="FieldValue" width=20% nowrap></TD>
	</TR>

	<TR>
		<TD class="FieldName" valign="top" colspan=6></TD>
	</TR>
</TABLE>
</form>
</div>

</BODY>
</HTML>
<script language="javaScript">
     function onSearch()
    {
        var o = $('#EweaverForm').serializeArray();
        var data = {};
        for (var i = 0; i < o.length; i++) {
            if (o[i].value != null && o[i].value != "") {
                data[o[i].name] = o[i].value;
            }
        }
        store.baseParams = data;
        store.load({params:{start:0, limit:20}});
    }
      $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch();
       }
   });
   
   function onReset(){
        $('#EweaverForm span').text('');
         $('#EweaverForm input[type=text]').val('');
         $('#EweaverForm input[type=checkbox]').each(function(){
             this.checked=false;
         });
         $('#EweaverForm input[type=hidden]').val('');
         $('#EweaverForm select').val('');
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
         function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
