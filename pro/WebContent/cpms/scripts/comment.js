var fckBasePath= '/fck/';
function f$(id){
	return document.getElementById(id);
}
function addComment(){
	CommentForm.style.display="";
	showReplay.style.display="none";
	comments.style.display="none";
}
function onSave(){
	var oEditor = FCKeditorAPI.GetInstance('content');
	var value =oEditor.GetXHTML(true);
	if(f$("subject").value||value){
		CommentForm.submit();
	}
}
function hideComment(){
	CommentForm.style.display="none";
	showReplay.style.display="";
	comments.style.display="";
}
function init(){
	initFCK('content','CommentEditor');
}
function addAttach(attachid, attachname){
    var oDiv = f$("fileUploadDIV");
    var span = document.createElement("SPAN");
    span.style.margin="0 10 0 5";
    span.id = attachid;
	span.innerHTML = '<img src="/images/silk/accessory.gif" border="0">' + attachname + '<a style="margin:0 5 0 5;" title="删除" href="#" onclick = javascript:delAttach("' + attachid + '");>删除</a>';
	if(f$("attachs").value){
		f$("attachs").value = f$("attachs").value+","+attachid;
	}else{
		f$("attachs").value = attachid;
	}
	oDiv.appendChild(span);
}
function delAttach(attachid){
    if (confirm("确定删除吗？")) {
        var oSpan = f$(attachid);
        oSpan.removeNode(true);
        var attachs = f$("attachs").value;
        f$("attachs").value = attachs.replace(attachid + ",", "");
    }
}
function disabledButton(){
	f$("saveComment").disable=true;
}
function enableButton(){
	f$("saveComment").disable=false;
}
function getrefobj(inputname,inputspan,refid,viewurl,isneed){
	if(inputname.substring(3,(inputname.length-6))){
        if(f$(inputname.substring(3,(inputname.length-6))))
        	f$(inputname.substring(3,(inputname.length-6))).value='';
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
			if (isneed=='0'){
				document.all(inputspan).innerHTML = '';
			}else{
				document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
			}
        }
     }
}