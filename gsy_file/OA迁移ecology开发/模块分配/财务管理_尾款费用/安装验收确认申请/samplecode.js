<script type='text/javascript'>
/*页面元素加载后执行代码块*******************************START********************************************** */
jQuery(function () {
	//jQuery.ajaxSetup({async:false});

	var bxjehj = "10423"; //报销金额合计id
	var cqb = "10457"; //厂区别id
	var bxrgh = "10502"; //报销人工号id
	var bxrgsdm = "10429"; //报销人公司代码id
	var khyh = "10387"; //薪资开户银行id
	var cbr = "10489"; //承办人id
	var gsdm = "10362"; //公司代码id

	feeTypeSelect(); //费用类别下拉框初始化

	//if(!jQuery('#requestid').val()) loadInfo();//初始化币别、汇率和付款条款，已用ecology节点前操作实现初始化

	//根据报销人工号带出下列部分信息
	jQuery("#field" + bxrgh).bindPropertyChange(function () {
		isOrNo(); //分管领导和厂区总经理是否是同一人选择框的选定
		setfield1(); // 内部订单号、籍别、安全等级，从人力资源表带出
		getsupplyinfo(); //供应商信息
	});
	/*******根据报销总额的限制条件来控制付款信息的显示与否START******* */
	jQuery("#field" + bxjehj).bindPropertyChange(function () {

		var secLevel = "10430"; //安全级别id,用于隐藏或显示后面的付款信息
		var supplier = "10443"; //供应商id

		var fptotal = jQuery("#field" + bxjehj).val(); //报销金额合计
		var factype = jQuery("#field" + cqb + "span").text(); //厂区别

		var cs = factype.indexOf("常熟厂") >= 0;
		var pj = factype.indexOf("盘锦厂") >= 0;
		var yz = factype.indexOf("仪征厂") >= 0;

		var startIndex = jQuery("#field" + secLevel + "_tdwrap").parent("tr"); //安全级别所在行

		//是否显示付款信息
		if ((fptotal <= 500 && (cs || pj)) || (fptotal <= 2000 && yz)) {
			startIndex.next().hide().next().hide().next().hide().next().hide().next().hide();
			AttrUtil.bEditorial(supplier);
		} else if ((fptotal > 500 && (cs || pj)) || (fptotal > 2000 && yz)) {
			startIndex.next().show().next().show().next().show().next().show().next().show();
			AttrUtil.bMustInput(supplier);
		}
	});
	/*******根据报销总额的限制条件来控制付款信息的显示与否END******* */

	jQuery("#field" + bxrgsdm).bindPropertyChange(function () {
		var sql1 = "SELECT subcompanyid1 FROM hrmresource WHERE id = " + jQuery("#field" + cbr).val();
		jQuery.getJSON('/EHSM/datautil.jsp', {
			sql1: sql1
		}, function (data) {
			if (data && data.length > 0) {
				if (data[0].subcompanyid1 == jQuery("#field" + gsdm).val()) {
					var sign1 = jQuery("#field" + bxrgsdm + "span").text().indexOf("1010") >= 0;
					var sign2 = jQuery("#field" + bxrgsdm + "span").text().indexOf("1020") >= 0;
					if (sign1 || sign2) {
						jQuery("#field" + khyh + "_tdwrap").parent("tr").show();
						AttrUtil.mustInput(khyh);
					} else {
						jQuery("#field" + khyh + "_tdwrap").parent("tr").hide();
						AttrUtil.editorial(khyh);
					}
				}
			}
		});
	});

	jQuery("#field" + khyh).bindPropertyChange(function () {
		console.log("eweaver--jianma()涉及查表，感觉可优化");
	});

	jQuery("#field" + "公司代码").bindPropertyChange(function () {
		console.log("eweaver--differentcode()涉及查表，感觉可优化");
	});

	//jQuery.ajaxSetup({async:false});
});
/*页面元素加载后执行代码块*******************************END********************************************** */
/*
函数执行场景：点击明细表2添加明细按钮会执行这个函数

其中的操作包括：初始化每一行明细中的币种和汇率分别为RMB和1.0000;
				给每一行的发票税率字段注册监听，税率变动，则重新计算当前明细
*/
function _customAddFun1() {
	var fpbz = "10612"; //发票币种字段id
	var fphl = "10602"; //发票汇率字段id
	var fpsl = "10604"; //发票税率字段id
	var jnjws = "13001"; //价内价外税字段id
	var bxje = "10603"; //报销金额字段id
	var fpje = "10609"; //发票金额字段id
	var wse = "10611"; //未税额字段id
	var bbje = "10613"; //本币金额字段id
	var zzsse = "10610"; //增值税税额字段id

	var i = jQuery("#indexnum1").val() - 1; //增加行字段id后的行标识

	//明细表币种以及汇率初始化
	jQuery("#field" + fpbz + "_" + i).val('1');
	jQuery("#field" + fpbz + "_" + i + 'span').html('RMB');
	jQuery("#field" + fphl + "_" + i).val('1.0000');
	jQuery("#field" + fphl + "_" + i + 'span').html('1.0000');

	//发票税率改变，则更新对应的价内价外税计算公式
	jQuery("#field" + fpsl + "_" + i).live("change", function () {
		var jnjw = jQuery("#field" + jnjws + "_" + i).val();
		if (jnjw == 0) { //价外税的标识是0，所以明细表计算公式更新成价外税的计算公式
			window.calRuleCfg.detail_1.rowcal = "detailfield_" + bxje + "=detailfield_" + fpje + "*detailfield_" + fphl + ";detailfield_" + wse + "=detailfield_" + fpje + "/(100+detailfield_" + fpsl + ")*100;detailfield_" + bbje + "=detailfield_" + wse + "*detailfield_" + fphl + ";detailfield_" + zzsse + "=detailfield_" + fpje + "-detailfield_" + wse;
		} else if (jnjw == 1) { //更新明细表计算公式为价内税的计算公式
			window.calRuleCfg.detail_1.rowcal = "detailfield_" + bxje + "=detailfield_" + fpje + "*detailfield_" + fphl + ";detailfield_" + wse + "=detailfield_" + fpje + "*(100-detailfield_" + fpsl + ")/100;detailfield_" + bbje + "=detailfield_" + wse + "*detailfield_" + fphl + ";detailfield_" + zzsse + "=detailfield_" + fpje + "-detailfield_" + wse;
		}
	});
}

//获取供应商信息
function getsupplyinfo() {
	console.log('getsupplyinfo--供应商信息未完成');
}

//获取内部订单号
function setfield1() {
	console.log('setfield1--内部订单号、籍别台籍陆籍、安全等级，根据报销员工工号从人力资源表中带出');
}

//分管领导和厂区总经理是否是同一人选择框的选定
function isOrNo() {
	console.log('isOrNo--分管领导和厂区总经理是否是同一人选择框的判断未完成,涉及人力资源表字段');
}

//付款条款初始化
function payTerm() {
	var fktk = "10453"; //付款条款id
	var fktkz = "167"; //付款条款值

	jQuery("#field" + fktk).val(fktkz);
	jQuery("#field" + fktk + "span").html('GS');
}

//费用类别下拉框初始化，只留下营业人员及其他费用
function feeTypeSelect() {
	var freeSelect = "10397"; //下拉框id

	var options = jQuery("#field" + freeSelect).find('option');
	options.each(function (i) {
		if (i != 0 && i != 2 && i != 3) {
			this.remove();
		}
	});
}

//加载主表中的币种以及汇率信息
function loadInvoiceInfo() {
	var zbbb = "10503"; //主表币别id
	var zbhl = "10405"; //主表汇率id
	var jjfy = "10509"; //交际费用id

	//主表币别初始化
	jQuery("#field" + zbbb).val('1');
	jQuery("#field" + zbbb + "span").html('RMB');

	//主表汇率初始化
	jQuery("#field" + zbhl).val('1.0000');
	jQuery("#field" + zbhl + "span").html('1.0000');

	//交际费用合计初始化
	jQuery("#field" + jjfy).val('0.00');
}

//初始化数据加载
function loadInfo() {
	loadInvoiceInfo(); //加载发票信息明细表、主表中的币种以及汇率信息
	payTerm(); //付款条款
}
</script>
<script type="text/javascript" src="/EHSM/AttrUtil.js"></script>









































