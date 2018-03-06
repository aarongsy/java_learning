var imgSrc=[ "/searchengine/images/number20.gif", "/searchengine/images/number40.gif","/searchengine/images/number80.gif","/searchengine/images/number201.gif", "/searchengine/images/number401.gif", "/searchengine/images/number801.gif"];
var showSrc=["/searchengine/images/jian2.gif","/searchengine/images/xiang2.gif","/searchengine/images/jian1.gif","/searchengine/images/xiang1.gif"];

function Search(){
	document.VelcroForm.pageno.value="1";
	if(document.VelcroForm.q.value=="") {
	    alert("请输入搜索关键词");
	    document.VelcroForm.searchKeys.focus;
	    return;
	}		
	var d=new Date();
	var begin=d.getTime();
	var flag=isKey();
	if(flag==false) return ;
	document.VelcroForm.action = "/ServiceAction/com.eweaver.searchengine.servlet.LuceneAction?action=search&begintime="+begin+"&sortmode=1";
	document.VelcroForm.submit();
}  
function SearchPageNo(pagesize) {
	document.VelcroForm.pageno.value="1";
	if(document.VelcroForm.q.value=="") {
	    alert("请输入搜索关键词");
	    document.VelcroForm.searchKeys.focus;
	    return;
	}		
	if(pagesize == "20") {
		document.getElementById("40").src=imgSrc[1];
		document.getElementById("20").src=imgSrc[3];
		document.getElementById("80").src=imgSrc[2];
	}
	if(pagesize == "40") {
		document.getElementById("40").src=imgSrc[4];
		document.getElementById("20").src=imgSrc[0];
		document.getElementById("80").src=imgSrc[2];
	}
	if(pagesize == "80") {
		document.getElementById("40").src=imgSrc[1];
		document.getElementById("20").src=imgSrc[0];
		document.getElementById("80").src=imgSrc[5];
		
	}
	var showType = document.getElementById("showType").value;
	var showInt = showType;
	var d=new Date();
	var begin=d.getTime();
	var flag=isKey();
	if(flag==false) return ;
	document.VelcroForm.action="/ServiceAction/com.eweaver.searchengine.servlet.LuceneAction?action=search&begintime="+begin+"&flag=1&pagesize="+pagesize;
	document.VelcroForm.submit();

}
function SearchInResult(){
	document.VelcroForm.pageno.value="1";	
	if(document.VelcroForm.searchKeys.value=="") {
	    alert("请输入搜索关键词");
	    document.VelcroForm.searchKeys.focus;
	    return;
	}			
	var d=new Date();
	var begin=d.getTime();
	var flag=isKey();
	if(flag==false) return ;
	document.VelcroForm.action="/ServiceAction/com.eweaver.searchengine.servlet.LuceneAction?action=search&secondSearch=1&begintime="+begin+"&flag=1&sortmode=1";
	document.VelcroForm.submit();
}  
function openchild(inputvalue){
	var returnvalue = new String(window.showModalDialog("/document/base/basechild.jsp?objid=" + inputvalue,"Width=110,Height=100"));
} 
/**
 * 过滤lucene的关键字
 */
function isKey(){
	var searcherkey=document.VelcroForm.q.value;
	if(searcherkey.trim().indexOf("+")==0) { alert("您输入了违法字符!");return false;}
	if(searcherkey.trim().indexOf("-")==0) { alert("您输入了违法字符!");return false;}
	if(searcherkey.trim().indexOf("*")==0) { alert("您输入了违法字符!");return false;}
	if(searcherkey.trim().indexOf("/")==0) { alert("您输入了违法字符!");return false;}
	if(searcherkey.trim().indexOf("AND")==0) { alert("您输入了违法字符!");return false;}
	if(searcherkey.trim().indexOf("OR")==0) { alert("您输入了违法字符!");return false;}
	if(searcherkey.trim().indexOf("?")==0) { alert("您输入了违法字符!");return false;}		
}
// 去除左右空格
String.prototype.trim　= function(){      
    // 用正则表达式将前后空格
    // 用空字符串替代。
    var t = this.replace(/(^\s*)|(\s*$)/g, "");    
    return t.replace(/(^　*)|(　*$)/g, "");    
}

function toAdvance(){
	window.location.href="advancesearch.jsp";	
	
}
function checkkeydown(){
	if(window.event.keyCode==13)
	    Search();
}

var count=0;

function showSimple(type) {

	var obj = document.getElementsByName("hide")
	for (i=0;i< obj.length;i++) {
		
		if (obj[i].style==null)
			continue;
			if(type == "detail") {
				obj[i].style.display = "";
				document.getElementById("simple").src = showSrc[0];
				document.getElementById("detail").src = showSrc[3];
				document.getElementById("showType").value = "1";				
			}
			if(type == "simple") {
				obj[i].style.display = "none";
				document.getElementById("simple").src = showSrc[2];
				document.getElementById("detail").src = showSrc[1];
				document.getElementById("showType").value = "0";				
			}
	}
	return false;
}
function shrink(){
	var obj=document.getElementById("tips");
	document.getElementById("minus").style.display="none";
	document.getElementById("plus").style.display="";
	obj.style.display="none";
}



function extensive(){
	
	var obj=document.getElementById("tips");
	
	obj.style.display="";
	document.getElementById("plus").style.display="none";
	document.getElementById("minus").style.display="";
}

function showSummaryDiv(oSpan,obj){ 
    var oDiv = document.getElementById(oSpan)
    if(oDiv) {
	   // var newX=document.body.scrollLeft+event.clientX;
	   // var newY=document.body.scrollTop+event.clientY;
	 	oDiv.style.display='';
	 	oDiv.className="summaryDIV";
	 	oDiv.style.top=obj.offsetTop+17;
	 	oDiv.style.left=obj.offsetLeft-95;
    }
}
function hiddenSummaryDiv(oSpan){ 
    var oDiv = document.getElementById(oSpan)
    if(oDiv) {
	 	oDiv.style.display='none';
	    }
	}
function csort(){		
	document.VelcroForm.action = "/ServiceAction/com.eweaver.searchengine.servlet.LuceneAction?action=search&begintime="+new Date().getTime()+"&normal=1&flag=1";
	document.VelcroForm.pageno.value=1;
	var flag=isKey();
	if(flag==false) return ;
	document.VelcroForm.submit();
}
  
function onSearch(pageno){
	document.VelcroForm.action="<%=action%>";
   	document.VelcroForm.pageno.value=pageno;
   	document.VelcroForm.target="";
	document.VelcroForm.submit();
} 
 