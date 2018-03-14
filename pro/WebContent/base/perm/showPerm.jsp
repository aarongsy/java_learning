<%@ page contentType="text/html; charset=UTF-8"%>
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
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService" %>
<%

Humres humres = new Humres();

String showCheckbox="true";
String tablename = "humres";
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService");
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
 String sqlwhere= StringHelper.null2String(request.getParameter("sqlwhere"));
    String roleid = StringHelper.null2String(request.getParameter("roleid"));
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
PermissiondetailService permissiondetailService  = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
String accountid = StringHelper.null2String(request.getParameter("requestid"));
boolean allowSwitch=sysuserService.isAllowSwitch();
if(allowSwitch){
   Sysuser su=(Sysuser)request.getSession(true).getAttribute("eweaver_user@bean");
  if(!sysuserService.checkUserPerm(su,request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.SwitchUserAction"))
  allowSwitch=false;
}
String jsonStr=null;

%>
<%
    pagemenustr += "addBtn(tb,'快捷搜索','S','zoom',function(){onSubmit()});";
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
    <script src='<%= request.getContextPath()%>/dwr/interface/HumresSalaryCalculationService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/util.js'></script>

  <script language="JScript.Encode" src="<%= request.getContextPath()%>/js/rtxint.js"></script>
  <script language="JScript.Encode" src="<%= request.getContextPath()%>/js/browinfo.js"></script>
  
  <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type='text/javascript' src='<%= request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
  <script type="text/javascript">
 Ext.LoadMask.prototype.msg='加载中,请稍后...';
    var store;
    var selected=new Array();
  <%
   String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunitTreeAction?action=showperm&roleid="+roleid;
  %>
          Ext.onReady(function(){

              Ext.QuickTips.init();
            //==== Progress bar1  ====
            pbar1 = new Ext.ProgressBar({
               text:'0%'
            });

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
            fields: ['permname','permdesc','id']
        })

    });
    //store.setDefaultSort('id', 'desc');

    var sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([sm, {header: "资源名称",  sortable: false,  dataIndex: 'permname'},
                {header: "资源描述", sortable: false,   dataIndex: 'permdesc'}]);

    cm.defaultSortable = true;

                   var grid = new Ext.grid.GridPanel({
                       region: 'center',
                       store: store,
                       cm: cm,
                       trackMouseOver:false,
                       sm:sm ,
                       loadMask: true,
                       viewConfig: {
                           forceFit:true,
                           enableRowBody:true,
                           sortAscText:'升序',
                           sortDescText:'降序',
                           columnsText:'列定义',
                           getRowClass : function(record, rowIndex, p, store){
                               return 'x-grid3-row-collapsed';
                           }
                       },
                       bbar: new Ext.PagingToolbar({
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
        items: [grid]
	});
      onSubmit();
});
  </script>

  </head>
  <body>
<div id="divSearch" >
<div id="pagemenubar"></div>
  <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=list" id='EweaverForm' name="EweaverForm"  method="post">
</form>
</div>
      </div>
<script language="javascript" type="text/javascript">
       var inputid;
      var spanid;
      var temp;
     function checkdirect(obj)
  {
      inputid=obj.id;
      spanid=obj.name;

      temp=0;
  }
      var $j = jQuery.noConflict();
      $j(document).ready(function($){
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

    function getrefobj(inputname,inputspan,refid,viewurl,isneed){

          if(inputname.substring(3,(inputname.length-6))){
              if(document.getElementById(inputname.substring(3,(inputname.length-6))))
       document.getElementById(inputname.substring(3,(inputname.length-6))).value="";
          }
      var id;
      try{
      id=openDialog('/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid);
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
          document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

              }
           }
   }
</script>
<script>
    function switchUser(obj) {
        top.location.href = "<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SwitchSysAdminAction?id=" + obj;
    }
</script>
<script type="text/javascript">
    //*********************************模式对话框特效(start)*********************************//
            function sAlert(){
            var msgw,msgh,bordercolor;
            msgw=420;//提示窗口的宽度
            msgh=80;//提示窗口的高度
            bordercolor="#336699";//提示窗口的边框颜色

            var sWidth,sHeight;
            sWidth=document.body.offsetWidth;
            sHeight=document.body.offsetHeight;

            var bgObj=document.createElement("div");
            bgObj.setAttribute('id','bgDiv');
            bgObj.style.position="absolute";
            bgObj.style.top="0";
            bgObj.style.background="#777";
            bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";
            bgObj.style.opacity="0.6";
            bgObj.style.left="0";
            bgObj.style.width=sWidth + "px";
            bgObj.style.height=sHeight + "px";
            document.body.appendChild(bgObj);
            var msgObj=document.createElement("div")
            msgObj.setAttribute("id","msgDiv");
            msgObj.setAttribute("align","center");
            msgObj.style.position="absolute";
            msgObj.style.background="white";
            msgObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
            msgObj.style.border="1px solid " + bordercolor;
            msgObj.style.width=msgw + "px";
            msgObj.style.height=msgh + "px";
          msgObj.style.top=(document.documentElement.scrollTop + (sHeight-msgh)/2) + "px";
          msgObj.style.left=(sWidth-msgw)/2 + "px";

          var title=document.createElement("h4");
          title.setAttribute("id","msgTitle");
          title.setAttribute("align","right");
          title.style.margin="0";
          title.style.padding="3px";
          title.style.background=bordercolor;
          title.style.filter="progid:DXImageTransform.Microsoft.Alpha(startX=20, startY=20, finishX=100, finishY=100,style=1,opacity=75,finishOpacity=100);";
          title.style.opacity="0.75";
          title.style.border="1px solid " + bordercolor;
          title.style.height="18px";
          title.style.font="12px Verdana, Geneva, Arial, Helvetica, sans-serif";
          title.style.color="white";
          title.style.cursor="pointer";
          title.innerHTML="关闭";
          title.onclick=function(){
               var progressBarhome=document.getElementById("progressBarhome");
               var progressBar=document.getElementById("progressBar");
            progressBarhome.appendChild(progressBar);
               var bgObj=document.getElementById("bgDiv");
            document.body.removeChild(bgObj);
               var title=document.getElementById("msgTitle");
               document.getElementById("msgDiv").removeChild(title);
               var msgObj=document.getElementById("msgDiv");
            document.body.removeChild(msgObj);
               document.getElementById("progressBarhome").style.display="none";
        }
          document.body.appendChild(msgObj);
          document.getElementById("msgDiv").appendChild(title);
		  var progressBar=document.getElementById("progressBar");
          progressBar.style.display="block";
          document.getElementById("importMessage").style.display="block";
	      document.getElementById("msgDiv").appendChild(progressBar);
          doCalculation();
      }
//*********************************模式对话框特效(end)*********************************//
</script>
  </body>
</html>