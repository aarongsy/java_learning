
//清空明细表groupid
function delRowFunmd0(groupid){
		var oTable = jQuery("table#oTable"+groupid);
		var checkObj = oTable.find("input[name='check_node_"+groupid+"']");
		if(checkObj.size()>0){

				var curindex = parseInt($G("nodesnum"+groupid).value);
				var submitdtlStr = $G("submitdtlid"+groupid).value;
				var deldtlStr = $G("deldtlid"+groupid).value;
				checkObj.each(function(){
					var rowIndex = jQuery(this).val();
					var belRow = oTable.find("tr[_target='datarow'][_rowindex='"+rowIndex+"']");
					var keyid = belRow.find("input[name='dtl_id_"+groupid+"_"+rowIndex+"']").val();
					//提交序号串删除对应行号
					var submitdtlArr = submitdtlStr.split(',');
					submitdtlStr = "";
					for(var i=0; i<submitdtlArr.length; i++){
						if(submitdtlArr[i] != rowIndex)
							submitdtlStr += ","+submitdtlArr[i];
					}
					if(submitdtlStr.length > 0 && submitdtlStr.substring(0,1) === ",")
						submitdtlStr = submitdtlStr.substring(1);
					//已有明细主键存隐藏域
					if(keyid != "")
						deldtlStr += ","+keyid;
					//IE下需先销毁附件上传的object对象，才能remove行
					try{
						belRow.find("td[_fieldid][_fieldtype='6_1'],td[_fieldid][_fieldtype='6_2']").each(function(){
							var swfObj = eval("oUpload"+jQuery(this).attr("_fieldid"));
							swfObj.destroy();
						});
					}catch(e){}
					belRow.remove();
					curindex--;
				});
				$G("submitdtlid"+groupid).value = submitdtlStr;
				if(deldtlStr.length >0 && deldtlStr.substring(0,1) === ",")
					deldtlStr = deldtlStr.substring(1);
				$G("deldtlid"+groupid).value = deldtlStr;
				$G("nodesnum"+groupid).value = curindex;
				//序号重排
				oTable.find("input[name='check_node_"+groupid+"']").each(function(index){
					var belRow = oTable.find("tr[_target='datarow'][_rowindex='"+jQuery(this).val()+"']");
					belRow.find("span[name='detailIndexSpan"+groupid+"']").text(index+1);
				});
				oTable.find("input[name='check_all_record']").attr("checked", false);
				//表单设计器，删除行触发公式计算
				triFormula_delRow(groupid);
				try{
					calSum(groupid);
				}catch(e){}

	}
}
//保存勾选的明细，删除其余明细
function saveRowFunmd0(groupid){
		var oTable = jQuery("table#oTable"+groupid);
		var checkObj = oTable.find("input[name='check_node_"+groupid+"']:not(checked)");

		if(checkObj.size()>0){

				var curindex = parseInt($G("nodesnum"+groupid).value);
				var submitdtlStr = $G("submitdtlid"+groupid).value;
				var deldtlStr = $G("deldtlid"+groupid).value;
				checkObj.each(function(){
					var rowIndex = jQuery(this).val();
					var belRow = oTable.find("tr[_target='datarow'][_rowindex='"+rowIndex+"']");
					var keyid = belRow.find("input[name='dtl_id_"+groupid+"_"+rowIndex+"']").val();
					//提交序号串删除对应行号
					var submitdtlArr = submitdtlStr.split(',');
					submitdtlStr = "";
					for(var i=0; i<submitdtlArr.length; i++){
						if(submitdtlArr[i] != rowIndex)
							submitdtlStr += ","+submitdtlArr[i];
					}
					if(submitdtlStr.length > 0 && submitdtlStr.substring(0,1) === ",")
						submitdtlStr = submitdtlStr.substring(1);
					//已有明细主键存隐藏域
					if(keyid != "")
						deldtlStr += ","+keyid;
					//IE下需先销毁附件上传的object对象，才能remove行
					try{
						belRow.find("td[_fieldid][_fieldtype='6_1'],td[_fieldid][_fieldtype='6_2']").each(function(){
							var swfObj = eval("oUpload"+jQuery(this).attr("_fieldid"));
							swfObj.destroy();
						});
					}catch(e){}
					belRow.remove();
					curindex--;
				});
				$G("submitdtlid"+groupid).value = submitdtlStr;
				if(deldtlStr.length >0 && deldtlStr.substring(0,1) === ",")
					deldtlStr = deldtlStr.substring(1);
				$G("deldtlid"+groupid).value = deldtlStr;
				$G("nodesnum"+groupid).value = curindex;
				//序号重排
				oTable.find("input[name='check_node_"+groupid+"']").each(function(index){
					var belRow = oTable.find("tr[_target='datarow'][_rowindex='"+jQuery(this).val()+"']");
					belRow.find("span[name='detailIndexSpan"+groupid+"']").text(index+1);
				});
				oTable.find("input[name='check_all_record']").attr("checked", false);
				//表单设计器，删除行触发公式计算
				triFormula_delRow(groupid);
				try{
					calSum(groupid);
				}catch(e){}

	}
}
//建模表情况明细
function delRowFunJM(groupid){
	var oTable = jQuery("table#oTable"+groupid);
	var checkObj = oTable.find("input[name='check_mode_"+groupid+"']");
	if(checkObj.size()>0){
	
			var curindex = parseInt($G("modesnum"+groupid).value);
			var submitdtlStr = $G("submitdtlid"+groupid).value;
			var deldtlStr = $G("deldtlid"+groupid).value;
			checkObj.each(function(){
				var rowIndex = jQuery(this).val();
				var belRow = oTable.find("tr[_target='datarow'][_rowindex='"+rowIndex+"']");
				var keyid = belRow.find("input[name='dtl_id_"+groupid+"_"+rowIndex+"']").val();
				//提交序号串删除对应行号
				var submitdtlArr = submitdtlStr.split(',');
				submitdtlStr = "";
				for(var i=0; i<submitdtlArr.length; i++){
					if(submitdtlArr[i] != rowIndex)
						submitdtlStr += ","+submitdtlArr[i];
				}
				if(submitdtlStr.length > 0 && submitdtlStr.substring(0,1) === ",")
					submitdtlStr = submitdtlStr.substring(1);
				//已有明细主键存隐藏域
				if(keyid != "")
					deldtlStr += ","+keyid;
				//IE下需先销毁附件上传的object对象，才能remove行
				try{
					belRow.find("td[_fieldid][_fieldtype='6_1'],td[_fieldid][_fieldtype='6_2']").each(function(){
						var swfObj = eval("oUpload"+jQuery(this).attr("_fieldid"));
						swfObj.destroy();
					});
				}catch(e){}
				belRow.remove();
				curindex--;
			});
			$G("submitdtlid"+groupid).value = submitdtlStr;
			if(deldtlStr.length >0 && deldtlStr.substring(0,1) === ",")
				deldtlStr = deldtlStr.substring(1);
			$G("deldtlid"+groupid).value = deldtlStr;
			$G("modesnum"+groupid).value = curindex;
			//序号重排
			oTable.find("input[name='check_mode_"+groupid+"']").each(function(index){
				var belRow = oTable.find("tr[_target='datarow'][_rowindex='"+jQuery(this).val()+"']");
				belRow.find("span[name='detailIndexSpan"+groupid+"']").text(index+1);
			});
			oTable.find("input[name='check_all_record']").attr("checked", false);
			//表单设计器，删除行触发公式计算
			triFormula_delRow(groupid);
			try{
				calSum(groupid);
			}catch(e){}
			try{		//自定义函数接口,必须在最后，必须try-catch
				eval("_customDelFun"+groupid+"()");
			}catch(e){}
		
	
}
}