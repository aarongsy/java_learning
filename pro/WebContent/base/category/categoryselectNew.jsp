<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ include file="/base/init.jsp"%>
<%
String html = "";
String url = "";
String id = StringHelper.null2String(request.getParameter("categoryid")); 
String model = StringHelper.null2String(request.getParameter("model"));
String setSubject=StringHelper.null2String(request.getParameter("setSubject"));
String paramater=StringHelper.null2String(request.getParameter("paramater"));
if (!StringHelper.isEmpty(paramater)){
	paramater="&paramater="+paramater;
}else{
	paramater="";
}
int level = NumberHelper.getIntegerValue(request.getParameter("level"));
if(level<=0) level=3;
if("docbase".equalsIgnoreCase(model)){
	url = "/document/base/docbasecreate.jsp?setSubject="+setSubject+"&categoryid=";
}else{
	url = "/workflow/request/formbase.jsp?categoryid=";
}

CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
%>
<html>
<head>
<style>
#div0,#div1,#div2,#div3{width:50%;height:5%;float:left;}
ul{margin-left:25px;}
li{text-decoration:underline;line-height:18px;}
li a{text-decoration:underline;}
#pagemenubar table {width:0}
.x-toolbar table {width:0}
</style>
<script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%=request.getContextPath()%>/dwr/interface/CategoryService.js'></script>
<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%=request.getContextPath()%>/dwr/util.js'></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajaxqueue.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript">
function insertUL(str, i){
    Ext.DomHelper.insertHtml("afterBegin",Ext.getDom("div"+i),str);
}
function expand(id){
	var o;
	if(id){
		o = document.getElementById(id);
	}else{
		o = event.srcElement;
		while(o.tagName!="LI"){
			if(o.tagName=="A"){
				location.href = o.href;
				return false;
			}
			o = o.parentNode;
		}
	}
	if(!o) return false;
	if(o.getAttribute("loaded")){
		if(o.getAttribute("expanding")){
			for(var i=0;i<o.childNodes.length;i++){
				var n = o.childNodes[i]; 
				if(n.tagName=="UL"){
					n.style.display = n.style.display=="none" ? "" : "none";
				}
			}
		}
	}else{
		load(o);
	}
}
function load(o){
    o.setAttribute('loaded','true');
	o.setAttribute('expanding','true');
    Ext.Ajax.request({
        url:contextPath+'/ServiceAction/com.eweaver.base.category.servlet.CategoryAction?action=getcategorylist',
        params:{pid:o.id,model:'<%=model%>'},
        success: function(res) {
            if (res.responseText != null) {
                data = eval(res.responseText);
                o.appendChild(createEl(o, data));
                var nodes = o.childNodes;
                for (var i = 0; i < nodes.length; i++) {
                    if (nodes[i].tagName == "UL") {
                        for (var j = 0; j < nodes[i].childNodes.length; j++) {
                            if (nodes[i].childNodes[j].getAttribute('level') <<%=level%>) {
                                $(nodes[i].childNodes[j].id).bind('click', expandHandler);
                                $(nodes[i].childNodes[j].id).trigger('click');
                            }
                        }
                    }
                }
            }
        }
    });

}
function createEl(parentObj,data){
	var u = document.createElement("UL");
	for(var i=0;i<data.length;i++){
		var l = document.createElement("LI");
		l.id = data[i].id;
		l.innerHTML = data[i].col3=="1" ?"<a href=\"javascript:onclickCloseWin(\'"+data[i].id +"\',\'"+data[i].objname+"\')\">"+data[i].objname+"</a>": data[i].objname;
		l.level = parseInt(parentObj.level) + 1;
        $(l).bind("click",expandHandler);
		u.appendChild(l);
        if(l.level <<%=level%>)
        $(l).trigger('click');
	}
	return u;
}
var expandHandler=function(ev){
       var o = ev.target;
       ev.stopPropagation();
		while(o.tagName!="LI"){
			if(o.tagName=="A"){
				location.href = o.href;
				return false;
			}
			o = o.parentNode;
		}

	if(!o) return false;
	if(o.getAttribute("loaded")){
		if(o.getAttribute("expanding")){
			for(var i=0;i<o.childNodes.length;i++){
				var n = o.childNodes[i];
				if(n.tagName=="UL"){
					n.style.display = n.style.display=="none" ? "" : "none";
				}
			}
		}
	}else{
		load(o);
	}
    };
function expandToLevel() {
    $('LI').each(function() {
        if (this.getAttribute('level') <<%=level%>) {
            $(this).bind('click', expandHandler);
            $(this).trigger('click');
        }
    })
}
window.onload = function(){
	<%
	List list = categoryService.getSubCategoryList(id, model);
	int size = list.size();
	if(size>0){
		for(int i=0;i<size;i++){
			Category c = (Category)list.get(i);
			html = "<ul><li id=\""+c.getId()+"\" level=\"1\" >";
			html += "1".equals(c.getCol3()) ? "<a href=\"javascript:onclickCloseWin(\\\'"+c.getId()+"\\\',\\\'"+c.getObjname()+"\\\')\" ><b>"+c.getObjname()+"</b></a>" : "<b>"+c.getObjname()+"</b>";
			html += "</li></ul>";
						if(i%2==0){
				out.print("insertUL('"+html+"', "+(i%4+1)+");");
		 }else{
				out.print("insertUL('"+html+"', "+(i%4-1)+");");
		 }
		 //out.print("insertUL('"+html+"', "+(3-i%4)+");");//三行的改法
		}
	}
	%>
	expandToLevel();
}
//处理返回结果
function onclickCloseWin(id,objname){
        var return_array = new Array();
        return_array[0]=id;
        return_array[1]=objname;
        window.returnValue = return_array;
		window.close();
}

Ext.onReady(function() {
    var gBtnHandler = function(btn) {
		window.close();
    }
    var cBtnHandler = function(btn) {
        var return_array = new Array();
        return_array[0]="";
        return_array[1]="";
        window.returnValue = return_array;
		window.close();
    }
    var myTopToolbar = new Ext.Toolbar([{
                text    : '<%=labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")%>(C)',//清除
		        handler : cBtnHandler,
		        id:'C',
		        key:'c',
		        iconCls:Ext.ux.iconMgr.getIcon('erase'),
		        alt:true
            }, {
                text    : '<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")%>(G)',//返回
		        handler : gBtnHandler,
		        id:'G',
		        key:'g',
		        iconCls:Ext.ux.iconMgr.getIcon('arrow_redo'),
		        alt:true
            }]);
    myTopToolbar.render('pagemenubar');
    myTopToolbar.add('->');
    myTopToolbar.add(pagemenutable);
});
</script> 
</head>
  
<body>
<div id="pagemenubar"></div>
<table  id="pagemenutable">
	<tr>
		<td ><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d34f87000f")%>:&nbsp;&nbsp;</td><!-- 展开 -->
		<td >
			<select onchange="javascript:location.href='categoryselectNew.jsp?model=<%=model %>&categoryid=<%=id %>&level='+this.value;">
			<%for(int i=1;i<10;i++){
				out.print("<option value='"+i+"' ");
				if(i==level) out.print("selected");
				out.print(">"+i+"</option>"); 
			}%>
			</select>&nbsp;<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790079")%>&nbsp;&nbsp;<!-- 级 -->
		</td>
	</tr>
</table>
<div id="div0"></div>
<div id="div1"></div>
<div id="div2"></div>
<div id="div3"></div>
</body>
</html>