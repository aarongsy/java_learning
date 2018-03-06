var humresid = "";
var humersname="";
 function getXY(obj){
   var el=Ext.get(obj);
     var xy=el.getXY();
     var div=Ext.get('mainsupports');
      M('mainsupports').style.width = 373+"px";
     M('mainsupports').style.height = 216+"px";
      M('mainsupports').style.display='block';
     var width=viewport.getSize().width;
     var height=viewport.getSize().height;
     if((div.getSize().width+xy[0])>width){
         xy[0]-=div.getSize().width;
     }else{
         xy[0]+=28;
     }
     if((div.getHeight()+xy[1])>height){
         xy[1]-=div.getHeight();
     }else{
         xy[1]+=14;
         
     }
     div.setXY(xy).show();

 }
function M(id)
{
    var result = document.getElementById(id);
    if(result==null)
    {
    	result = parent.document.getElementById(id);
    }
    if(result==null)
    {
    	result = parent.parent.document.getElementById(id);
    }
    if(result==null)
    {
    	result = parent.parent.parent.document.getElementById(id);
    }
    return result;
}

function loadEmpty()
{
	void(0);
}
function openhrm(objid,obj,objname)
{
   humresid=objid;
   humersname=objname;
	getXY(obj);
    getResource(objid);
  	void(0);
}
function closediv()
{
	M('mainsupports').style.display="none";

  	void(0);
}
    function openemail()
{       
   onUrl('/email/sendemail.jsp?humresid='+humresid,'发送邮件');
}
function openhrmresource(url){
	if(!url){
		url = "/humres/base/humresview.jsp";
	}
 	onUrl(url + '?id='+humresid,humersname);
}
