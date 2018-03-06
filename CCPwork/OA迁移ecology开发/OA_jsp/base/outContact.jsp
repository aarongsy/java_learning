<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%


	DataService ds = new DataService();
	StringBuffer cont = new StringBuffer();
	String sql = "select * from selectitem where typeid='4028807327e0e09d0127e599f48e04cc'  order by dsporder";
	List dataList = ds.getValues(sql);
	StringBuffer buf1 = new StringBuffer();
	for(int k=0,size=dataList.size() ; k<size ; k++) {
		Map m = (Map)dataList.get(k);
		String objname = StringHelper.null2String(m.get("objname")) ;
		String id = StringHelper.null2String(m.get("id")) ;
		String imagefield = StringHelper.null2String(m.get("imagefield")) ;
		buf1.append("addTab(contentPanel,'/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=4028807327e0e09d0127e5ca6c59055c&con4028807327e0e09d0127e5a981e004e6_value="+id+"','"+objname+"','"+imagefield+"');");
	}
%>
<html>
<head>
<style type="text/css">
     #pagemenubar table {width:0}
</style>

<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script>
    Ext.SSL_SECURE_URL='about:blank';
    Ext.onReady(function(){
        var cp = new Ext.state.CookieProvider({
       expires: new Date(new Date().getTime()+(1000*60*60*24*30))
   });
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');

     var c = new Ext.Panel({
               title:'全部',iconCls:Ext.ux.iconMgr.getIcon('config'),
               layout: 'border',
               items: [{region:'center',autoScroll:true,contentEl:'divSum'}]
           });
      
     var moduletab=cp.get('moduletab');
     if(moduletab==undefined)
     moduletab=0;
     
     
     var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            activeTab:moduletab ,
            items:[c]
           
        });
        <%out.println(buf1.toString());%>
        contentPanel.items.each(function(it,index,length){
         it.on('activate',function(p){
             if(length==8)
             cp.set('moduletab',index+1);
             else
             cp.set('moduletab',index);
            
        })
     });

    
      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [contentPanel]
	});
   
    })
</script>
</head>
<body>
<div id="divSum">
<div id="pagemenubar"> </div>
<iframe frameborder=0 width="100%" height="100%" style="scoll:no;" src="/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=4028807327e0e09d0127e5ca6c59055c"></iframe>
</div>
