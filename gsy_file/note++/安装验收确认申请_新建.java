package clip;

WeaverUtil.load(function() {
	getcheck();
	ordernum()  ;
	//getobj();
});

function getData() {
	DWREngine.setAsync(false);
	if(requestid) {
		//onSubmit(1);
		var orderno=document.getElementById('field_采购订单').value;//订单编号
		//alert(orderno);
		Ext.Ajax.request( {
			url: '/app/weikuan/checkgetrowinfo.jsp?action=getData',
			params:{requestid:requestid,orderno:orderno},
			success: function(res) {
				jsonResult = eval('('+res.responseText+')');
			}
	    });
		alert('请刷新！');
	} else {
		alert('请先保存数据！');
	}
	DWREngine.setAsync(true);
}

function getsupplyinfo() {
	DWREngine.setAsync(false);
	//alert(11312312312312);
	var purchno=document.getElementById('field_采购订单').value;//订单编号
	alert('获取供应商信息');
	Ext.Ajax.request({
		url: '/app/weikuan/getsupplyinfo.jsp',
		params:{requestid:requestid,purchno:purchno},
		success: function(res) {
			jsonResult = eval('('+res.responseText+')');
			//alert(jsonResult .LIFNR);             供应商简码
			document.getElementById('field_供应商简码').value=jsonResult .LIFNR ;                              //供应商简码
			document.getElementById('field_供应商简码span').innerHTML=jsonResult .LIFNR;
			document.getElementById('field_供应商名称').value=jsonResult .NAME1 ;                          //供应商名称
			document.getElementById('field_供应商名称span').innerHTML=jsonResult .NAME1;
			document.getElementById('field_付款条件').value=jsonResult .ZTERM;
			document.getElementById('field_付款条件span').innerHTML=jsonResult .ZTERM;
			var sql='update uf_fn_acceptconfirm set  suppliercode=\''+jsonResult .LIFNR +'\',payterm=\''+jsonResult .ZTERM '\',suppliername=\''+jsonResult .NAME1 +'\'where requestid=\''+requestid+'\'';
			DataService.executeSql(sql, {callback:function(data) {}});
		}
	});
	getcheck();
	getsupplyinfo2();
	DWREngine.setAsync(true);
}

function getsupplyinfo2() {
	var purchno=document.getElementById('field_采购订单').value;//订单编号
	if(purchno!='') {
		alert('获取采购员');
		Ext.Ajax.request( {
			url: '/app/weikuan/getname.jsp',
			params:{requestid:requestid,purchno:purchno},
			success: function(res) {
				jsonResult = eval('('+res.responseText+')');
				document.getElementById('field_采购员').value=jsonResult .EKGRP;//采购员
				document.getElementById('field_采购员span').innerHTML=jsonResult .EKGRP;

			}
		});
	} else {
		alert('请先输入采购订单号！');
		document.getElementById('field_采购员').value=''; //采购组
		document.getElementById('field_采购员span').innerHTML='';
	}
}

function getcheck() {
	var payterm=document.getElementById('field_付款条件').value
	var sql='select residuenum from uf_fn_installmentdata  where code=\''+payterm+'\'';
	DataService.getValues(sql, {
		callback:function(data) {
			if(data&&data.length>0) {
				for (var i=0; i<data.length ; i++) {
					var sql2='update uf_fn_acceptconfirm set  residue=\''+data[0].residuenum+'\' where requestid=\''+requestid+'\' ';
					DataService.executeSql(sql2, {callback:function(data) {}});
				}
			}
		}
	});

}



function onSubmitBefore(issave) {
	if(issave==1) { //保存
		return true;
	} else {
		DWREngine.setAsync(false);

		var payterm=document.getElementById('field_付款条件').value;//付款条件
		var renum=document.getElementById('field_剩余期数').value;//剩余期数
		//alert(renum);

		if(renum=='40285a8d4bd90cff014bdea1e07c775c') {

			var length=0;
			var sql='select * from uf_fn_acceptorder    where requestid=\''+requestid+'\''
			DataService.getValues(sql, {
				callback:function(data) {
					// alert(data.length);
					if(data&&data.length>0) {
						length=data.length;
					}
				}
			});

			if(length==0) {
				alert('未获取采购订单！');
				return false;
			} else {
				return true;
			}

		} else {
			alert('订单不符合或无采购订单信息！');
			document.getElementById('field_供应商简码').value='';//供应商简码
			document.getElementById('field_供应商简码span').innerHTML='';
			document.getElementById('field_供应商名称span').innerHTML='';//供应商名称
			document.getElementById('field_供应商名称').value='';
			document.getElementById('field_采购订单').value='';//采购订单
			document.getElementById('field_采购订单span').innerHTML='';
			document.getElementById('field_采购员').value='';//采购员
			document.getElementById('field_采购员span').innerHTML='';
			document.getElementById('field_付款条件').value='';//付款条件
			document.getElementById('field_付款条件span').innerHTML='';
			document.getElementById('field_剩余期数').value='';//剩余期数
			document.getElementById('field_剩余期数span').innerHTML='';
			//采购订单行项目
			selectAll1('明细表id');
			return false;
		}
		DWREngine.setAsync(true);

	}
}  //删除所有行
function selectAll1 (tableid) {
	var tbl=document.getElementById('oTable'+tableid).rows.length-1;//明细表
	for( var i=0; i<tbl; i++) {
		document.getElementsByName('check_node_'+tableid)[i].checked=true;/
	}
	delrow(tableid);
}


function ordernum() {
	DWREngine.setAsync(false);
	var money='';
	var tbl=document.getElementById('明细表');
	var len=tbl.rows.length-1;
	var sql='select paytotal from uf_fn_acceptorder where requestid=\''+requestid+'\''

	DataService.getValues(sql, {
		callback:function(data) {
			if(data&&data.length>0) {
				for (var i=0; i<data.length ; i++ ) {
					money=money*1+data[i].paytotal*1;

				}

			}
		}
	});
	document.getElementById('field_总付款金额').value=money;
	document.getElementById('field_总付款金额span').innerHTML=money;

	DWREngine.setAsync(true);
}


function getjudge() {
	DWREngine.setAsync(false);
	var orderno='';
	var sql='select a.orderno from uf_fn_acceptconfirm a left join requestbase b on a.requestid=b.id  where isfinished=1';
	DataService.getValues(sql, {
		callback:function(data) {
			if(data&&data.length>0) {
				for (var i=0; i<data.length ; i++) {
					orderno=data[i].orderno;
					if (document.getElementById('field_采购订单').value==orderno) {
						alert('该采购订单已在流程内！');
						document.getElementById('field_采购订单').value='';
					} else {}
				}

			}
		}
	});
	DWREngine.setAsync(true);

}



/*
function getobj()
{
	var tbl=document.getElementById('oTable40285a8d4c1ff2fe014c2045dfda0814');
	var len=tbl.rows.length-1;
	var rowno='';
	var ordernums='';
	var money='';
	var paytotal='';

	var sql='select max(rowno)as rownos from uf_fn_acceptorder where requestid=\''+requestid+'\'';
	   DataService.getValues(sql,{
		callback:function(data)
		{
alert(data.length);
		 if(data&&data.length>0){
			for ( var i=10;i<=data[0].rownos;i=i*1+10 )
			{
alert(i);
				var sql1='select ordernum,money,paytotal from uf_fn_acceptorder where requestid=\''+requestid+'\' and rowno=\''+i+'\'';
				DataService.getValues(sql1,{
				callback:function(data1)
				{
//alert(data.length);
				 if(data1&&data1.length>0){
					 for (var j=0;j<data1.length ;j++ )
					 {
						 ordernums=ordernums*1+data1[j].ordernum*1;
alert(ordernums);
						 money=((data1[0].money*1)/ordernums)*data1[j].ordernum;
alert(money);
						 paytotal=((data1[0].paytotal*1)/ordernums)*data1[j].ordernum;
						 var sql2='update uf_fn_acceptorder set money=\''+money+'\',paytotal=\''+paymoney+'\' where requestid=\''+requestid+'\'and rowno=\''+i+'\' and ordernum=\''+ordernum[j]+'\'' ;
						 DataService.executeSql(sql2,{callback:function(data){}});
alert(sql2);

					 }
				}
				}
			});
			}
		}
		}
	});

}*/
