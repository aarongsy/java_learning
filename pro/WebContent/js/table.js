var act_bgc	= "#F5FAF7";
var act_fc	= "black";
var cur_bgc	= "#A9E4B8";
var cur_fc	= "black";

//添加行
function add_row1(the_tableid) {
	var the_table=document.getElementById(the_tableid);
	var the_row,the_cell;
	the_row = -1;
	var newrow=the_table.insertRow(the_row);
	for (var i=0;i<the_table.rows[0].cells.length;i++) {
		the_cell=newrow.insertCell(i);
		if (i == 0)
		{
			the_cell.innerHTML="<input type='checkbox' name='checkbox_"+the_table.id+"'/>";
			the_cell.align = "center";
			continue;
		} else if (i==2)
		{
			the_cell.innerHTML="<select class='InputStyle2'/>";
			continue;
		}
		the_cell.innerHTML="<input type='text' class='InputStyle2' maxlength=24 value='' style='width: 80%'/>";
	}
}
//添加行
function add_row(the_tableid) {
	var the_table=document.getElementById(the_tableid);
	var the_row,the_cell;
	the_row = -1;
	var newrow=the_table.insertRow(the_row);
 if(!tblObj)
    return null;
  if(rowIndex<0)
    rowIndex=tblObj.rows.length+rowIndex+1;
  if(rowIndex<0 || rowIndex>tblObj.rows.length)
    rowIndex=tblObj.rows.length;
  var newRow=tblObj.insertRow(rowIndex);
  if(tblObj.rows.length>1)
  {
    var refIndex=(rowIndex>=1)?rowIndex-1:tblObj.rows.length-1;
	if(refRow==null)
      refRow=(refIndex>=0)?tblObj.rows[refIndex]:null;
    if(refRow!=null)
    {
      for(var i=0;i<refRow.attributes.length;i++)
      {
        var attrName=refRow.attributes[i].name;
        var attrValue=refRow.getAttribute(attrName);
        if(attrValue!="" && attrValue!=null)
          newRow.setAttribute(attrName,attrValue);
      }
      newRow.className=refRow.className;//属性中没有className
    }
    for(var i=0,size=refRow.cells.length; refRow && i<size; i++)
    {
      var newCell=newRow.insertCell(i);
      newCell.innerHTML=refRow.cells[i].innerHTML;
      for(var j=0;j<refRow.cells[i].attributes.length;j++)
      {
        var attrName=refRow.cells[i].attributes[j].name;
        var attrValue=refRow.cells[i].getAttribute(attrName);
        if(attrValue!="" && attrValue!=null)
          newCell.setAttribute(attrName,attrValue);
      }
      newCell.className=refRow.cells[i].className;
      TableUtil.copyTdChildValues(newCell,refRow.cells[i],isSetDefault);
    }
  }
}
//删除行
function del_row(the_tableid) {
	var the_table=document.getElementById(the_tableid);
	if(the_table.rows.length==1) return;
	var the_row;
	var cks = document.getElementsByName("checkbox_"+the_table.id);
	var y = cks.length;
    for (var i = 1; i < y ; )
    {
		  if (cks[i].checked)
		  {
             the_table.deleteRow(i);
			 y--;
		  } else {
		    i++;
		  }
    }
	
}
//全部选定，全部取消
function ck_all(the_tableid){
	var the_table=document.getElementById(the_tableid);
  //var cks = document.getElementsByName("check_box");
  var ck_all = document.all("ck_all_"+the_table.id);
  var cks = document.getElementsByName("checkbox_"+the_table.id);
  if (ck_all.checked)
  {
      for (var i = 1; i < cks.length ; i++)
      {
		  cks[i].checked = true;
      }
  } else {
      for (var i = 1; i < cks.length ; i++)
      {
		  cks[i].checked = false;
      }
  }
}

function get_Element(the_ele,the_tag){
	the_tag = the_tag.toLowerCase();
	if(the_ele.tagName.toLowerCase()==the_tag)return the_ele;
	while(the_ele=the_ele.offsetParent){
		if(the_ele.tagName.toLowerCase()==the_tag)return the_ele;
	}
	return(null);
}

//鼠标移上去事件
function moveover(the_tableid){
	var the_table=document.getElementById(the_tableid);
   var the_obj = event.srcElement;
	var i = 0;
	if(the_obj.tagName.toLowerCase() != "table"){
		var the_td	= get_Element(the_obj,"td");
		if(the_td==null) return;
		var the_tr	= the_td.parentElement;
		var the_table	= get_Element(the_td,"table");
		if(the_tr.rowIndex!=0){
			for(i=0;i<the_tr.cells.length;i++){
				with(the_tr.cells[i]){
					runtimeStyle.backgroundColor=act_bgc;
					runtimeStyle.color=act_fc;					
				}
			}
		}else{
			for(i=1;i<the_table.rows.length;i++){
				with(the_table.rows[i].cells(the_td.cellIndex)){
					runtimeStyle.backgroundColor=act_bgc;
					runtimeStyle.color=act_fc;
				}
			}
			the_td.style.cursor="s-resize";
		}
	}
}

//鼠标移开事件
function moveout(the_tableid){
	var the_table=document.getElementById(the_tableid);
    var i=0;
    var the_obj = event.srcElement;
	if(the_obj.tagName.toLowerCase() != "table"){
		var the_td	= get_Element(the_obj,"td");
		if(the_td==null) return;
		var the_tr	= the_td.parentElement;
		if(the_tr.rowIndex!=0){
			for(i=0;i<the_tr.cells.length;i++){
				with(the_tr.cells[i]){
					runtimeStyle.backgroundColor='';
					runtimeStyle.color='';				
				}
			}
		}else{
			var the_table=the_tr.parentElement.parentElement;
			for(i=0;i<the_table.rows.length;i++){
				with(the_table.rows[i].cells(the_td.cellIndex)){
					runtimeStyle.backgroundColor='';
					runtimeStyle.color='';
				}
			}
		}
	}
}

function clickIt(the_tableid){
	/*var the_table=document.getElementById(the_tableid);
	var the_obj = event.srcElement;
    var the_tr	= the_obj.parentElement;
	var cks = document.getElementsByName("checkbox_node_"+the_table.id);
	if (cks[the_tr.rowIndex].checked)
	{
		cks[the_tr.rowIndex].checked=false;
	} else 
	{
	    cks[the_tr.rowIndex].checked=true;
	}*/
}