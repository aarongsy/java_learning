//作用：进行签章
function DoSignature(){
	var fieldsList="";
	var formfieldArr=formfields.split(";");
	for(var i=0;i<formfieldArr.length;i++){
		var formfield=formfieldArr[i];
		if(formfield!=null&&formfield!=""){
			var strs=formfield.split("=");
			var formfieldid=strs[0];
			var formfieldlabelname=strs[1];
			var obj=jq("[name=field_"+formfieldid+"]");
			if(obj.length!=0){
				fieldsList+="field_"+formfieldid+"="+formfieldlabelname+";";
			}else{
				var obj2=jq("[name^=field_"+formfieldid+"_]").not(jq("[name^=field_"+formfieldid+"_][name$=span]"));
				if(obj2.length!=0){
					obj2.each(function(i){
						fieldsList+=jq(this).attr("name")+"="+formfieldlabelname+i+";";
					})
				}
			}
		}
	}
	if(fieldsList!=""){
		SignatureControl.FieldsList=fieldsList;
	}else{
		SignatureControl.FieldsList="requestid=requestid;";
	}
	
	SignatureControl.Position(460,260);                      //签章位置，屏幕坐标
	//SignatureControl.UserName="lyj";                         //文件版签章用户
	var mResult=SignatureControl.RunSignature(false);                         //执行签章操作
}

//作用：显示或隐藏签章
function ShowSignature(visibleValue)
{
   var mLength=document.getElementsByName("iHtmlSignature").length;
   for (var i=0;i<mLength;i++){
       var vItem=document.getElementsByName("iHtmlSignature")[i];
       vItem.Visiabled = visibleValue;
   }
}

//作用：显示文档中签章
function ShowSignatureByDocumentID(documentID){
	SignatureControl.ShowSignature(documentID);
}