<!-- script代码，如果需要引用js文件，请使用与HTML中相同的方式。 -->
<script type="text/javascript" src="/EHSM/AttrUtil_1.1.js"></script>
<script type="text/javascript">
    /*
    *  TODO
     *  请在此处编写javascript代码
     */

var _localvar = { //布局id
    sexfh: 'CSS275', //速尔（鑫飞鸿）
    dhp: 'SHD036', //DHP
    sfkd: 'SZG022', //顺丰快递简码
    ems: 'JSS039', //EMS
    qydgj: '11994', //隐藏字段_选择区域信息带国家暂存
    kdgsdm: '12013', //快递公司代码
    kdsd: '12014', //快递速度
    kdywlx: '12015', //快递业务类型
    bgnr: '12018', //包裹内容
    wpjg: '12019', //物品价格
    kdwplb: '12016', //快递物品类别
    invo1: 'invo1', //是否为发票行标识
    sfwfp: '11995', //是否为发票
    fpxx_tr: 'fpxx_tr', //快递申请发票信息明细表所在行标识
    wjnr: '11998', //文件内容类型
    wjnr_tr: 'filetype', //文件内容类型行标识
    zzkm: '12017', //总账科目
    xsdd_tr: 'xsdd_tr', //快递销售订单明细表所在行标识
    salweight: 'salweight', //重量合计，销售订单净价值合计所在行标识
    xsddTable: 'oTable1', //快递销售订单明细表
    sdfw: '12010', //送递范围
    ycfy: '12052', //异常费用
    fygsgsmc: '12007', //费用归属公司名称
    fjkdgs: '12011', //发件快递公司
    sm: '12054', //税码
    fygsry: '12003', //费用归属人员
    fygsbm: '12004', //费用归属部门
    fygscbzx: '12006', //费用归属成本中心
    fygscbzxmc: '12008', //费用归属成本中心名称
    jjr: '12001', //寄件人
    jzkg: '12040', //净重（kg）
    cqb: '12061', //厂区别
    fygsgsdm: '12005' //费用归属公司代码
}

var _sdfw_option = {
    gn: ['0', '国内'],
    gj: ['1', '国际']
}

var _kdsd_option = {
    pt: ['0', '普通'],
    jjj: ['1', '经济件'],
    dt: ['2', '当天(江浙沪)']
}

var _kdywlx_option = { //快递业务类型选项值
    wj: ['0', '文件'],
    yp: ['1', '样品'],
    ch: ['2', '出货'],
    sb: ['3', '设备'],
    syp: ['4', '试验品'],
    qt: ['5', '其他']
}

var _kdwplb_option = { //快递物品类别选项值
    bx: ['0', '不限'],
    ptbg: ['1', '普通包裹'],
    ytbg: ['2', '液体包裹'],
    ftbg: ['3', '粉体包裹'],
    wxbg: ['4', '危险包裹'],
    klbg: ['5', '颗粒包裹']
}

var _sfwfp_option = { //是否为发票选项值
    yes: ['0', '是'],
    no: ['1', '否']
}

var _zzkm_val = { //总账科目可能会修改到的值
    val1: '55060600',
    val2: '55060700'
}

var _oTable_index = { //明细表序号
    fpxx_index: '0',
    xsdd_index: '1'
}

jQuery(function () {
    hidefield();
    changevalue();
    jQuery('#field' + _localvar.fygsry).bindPropertyChange(changevalue); //费用归属人员改变时，更新相应的字段的值
    jQuery('#field' + _localvar.kdywlx).bindPropertyChange(changeinputstate); //快递业务类型改变时，判断包裹内容是否必填
    jQuery('#field' + _localvar.jjr).bindPropertyChange(updatepsninfo); //寄件人发生改变时，更新相应的费用归属信息
    jQuery('#field' + _localvar.jzkg).live('keyup', getnetprice); //净重值发生改变时，获取预计加毛重的值
});

/**
 * 获取预计加毛重的值
 */
function getnetprice() {

}

/**
 * 寄件人发生改变时，更新相应的费用归属信息
 */
function updatepsninfo() {
    var fygsry = jQuery('#field' + _localvar.fygsry);
    var jjr = jQuery('#field' + _localvar.jjr);
    var fygsryspan = jQuery('#field' + _localvar.fygsry + 'span');
    var jjrspan = jQuery('#field' + _localvar.jjr + 'span');

    var jjr_val = jjr.val();
    var jjrspan_html = jjrspan.html();

    fygsry.val(jjr_val);
    fygsryspan.html(jjrspan_html);
    changevalue(); //更新相应的费用成本中心等信息
}

//费用归属人员发生变化时，更新相应字段的值
function changevalue() {
    var fygsry = jQuery('#field' + _localvar.fygsry);
    var fygsryspan = jQuery('#field' + _localvar.fygsry + 'span');
    var fygsbm = jQuery('#field' + _localvar.fygsbm);
    var fygsbmspan = jQuery('#field' + _localvar.fygsbm + 'span');
    var fygscbzx = jQuery('#field' + _localvar.fygscbzx);
    var fygscbzxspan = jQuery('#field' + _localvar.fygscbzx + 'span');
    var fygscbzxmc = jQuery('#field' + _localvar.fygscbzxmc);
    var fygscbzxmcspan = jQuery('#field' + _localvar.fygscbzxmc + 'span');
    var fygsgsmc = jQuery('#field' + _localvar.fygsgsmc);

    var fygsry_val = fygsry.val();

    var sql1 = 'select r.lastname,r.departmentid,d.departmentname,r.subcompanyid1,r.costcenterid from hrmresource r,hrmdepartment d ';
    var sql2 = 'where r.departmentid = d.id ';
    var sql3 = 'and r.id = ' + fygsry_val;
    jQuery.getJSON('/EHSM/datautil.jsp', {
        sql1: sql1,
        sql2: sql2,
        sql3: sql3
    }, function (data) {
        if (!!data && data.length > 0) {
            fygsbm.val(data[0].departmentid); //费用归属部门
            fygsbmspan.html(data[0].departmentname); //费用归属部门span
            fygsryspan.html(data[0].lastname); //费用归属人员span
            fygscbzx.val(data[0].costcenterid); //费用归属成本中心
            fygscbzxspan.html(data[0].costcenterid); //费用归属成本中心span
            fygscbzxmc.val(data[0].costcenterid); //费用归属成本中心
            fygscbzxmcspan.html(data[0].costcenterid); //费用归属成本中心span
            fygsgsmc.val(data[0].subcompanyid1); //费用归属公司名称
            setCompanyCode(_localvar.fygsgsdm, data[0].subcompanyid1); //费用归属公司代码
            getshowname(_localvar.fygsgsmc, 'subcompanyname', 'hrmsubcompany', data[0].subcompanyid1);
        }
    });
}

//传入要设置的字段id和公司id，设置公司代码
function setCompanyCode(fieldid, comid) {
    var code = jQuery('#field' + fieldid);
    var codespan = jQuery('#field' + fieldid + 'span');

    var sql1 = 'select comcode from hrmsubcompanydefined d,hrmsubcompany s where d.subcomid = s.id and s.id = ' + comid;
    console.log('setCompanyCode--'+sql1);
    jQuery.getJSON('/EHSM/datautil.jsp', {
        sql1: sql1
    }, function (data) {
        console.log(data);
        if (!!data && data.length > 0) {
            code.val(data[0].comcode);
            codespan.html(data[0].comcode);
        }
    });
}

//根据id设置显示的名称
function getshowname(field, queryField, form, id) {
    var showspan = jQuery('#field' + field + 'span');
    var sql1 = 'select ' + queryField + ' as name from ' + form + ' where id = ' + id;
    jQuery.getJSON('/EHSM/datautil.jsp', {
        sql1: sql1
    }, function (data) {
        if (!!data && data.length > 0) {
            showspan.html(data[0].name);
        }
    });
}
//
function hidefield() {
    var qydgj = jQuery('#field' + _localvar.qydgj);
    var kdgsdm = jQuery('#field' + _localvar.kdgsdm);
    var kdsd = jQuery('#field' + _localvar.kdsd);

    qydgj.hide();

    var kdgsdm_val = kdgsdm.val(); //快递公司代码
    if (kdgsdm_val != _localvar.sfkd) { //只有顺丰快递可以选择快递的速度，其他的快递公司只能默认为普通速度，并不允许更改
        kdsd.attr('disabled', true);
    }
    changeinputstate();
    setspeed();
}

/**
 * 快递业务类型改变时，判断包裹内容是否必填
 */
function changeinputstate() {
    var kdywlx = jQuery('#field' + _localvar.kdywlx);
    var kdwplb = jQuery('#field' + _localvar.kdwplb);
    var invo1 = jQuery('#field' + _localvar.invo1);
    var fpxx_tr = jQuery('#field' + _localvar.fpxx_tr);
    var wjnr_tr = jQuery('#field' + _localvar.wjnr_tr);
    var zzkm = jQuery('#field' + _localvar.zzkm);
    var zzkmspan = jQuery('#field' + _localvar.zzkm + 'span');
    var xsdd_tr = jQuery('#field' + _localvar.xsdd_tr);
    var salweight = jQuery('#field' + _localvar.salweight);

    var kdywlx_val = kdywlx.val();
    var invo1_val = invo1.val();

    if (kdywlx_val == _kdywlx_option.qt[0]) { //如果快递业务类型为其他，则包裹内容为必填，否则为选填
        AttrUtil.fieldViewCtrl(_localvar.bgnr, 1); //包裹内容为必填
    } else {
        AttrUtil.fieldViewCtrl(_localvar.bgnr, 2); //包裹内容为可编辑状态
    }

    if (kdywlx_val == _kdywlx_option.sb[0]) { //如果快递业务类型为设备，则物品价格为必填，否则为选填
        AttrUtil.fieldViewCtrl(_localvar.wpjg, 1); //物品价格为必填
    } else {
        AttrUtil.fieldViewCtrl(_localvar.wpjg, 2); //物品价格选填
    }

    if (kdywlx_val == _kdywlx_option.wj[0]) { //如果快递业务类型为文件，则快递物品类别默认为普通包裹
        kdwplb.val(_kdwplb_option.ptbg[0]); //物品类别默认为普通包裹
        invo1.show();
        AttrUtil.fieldViewCtrl(_localvar.sfwfp, 1); //是否为发票必须输入
        if (invo1_val == _sfwfp_option.yes[0]) { //如果是否为发票的值为是
            fpxx_tr.show();
        }
        //如果是文件，文件内容为必填
        AttrUtil.fieldViewCtrl(_localvar.wjnr, 1); //文件内容类型设置为必填
        wjnr_tr.show();
    } else {
        invo1.hide();
        AttrUtil.fieldViewCtrl(_localvar.sfwfp, 2); //是否为发票设置为可编辑
        fpxx_tr.hide();
        AttrUtil.fieldViewCtrl(_localvar.wjnr, 2);
        wjnr_tr.hide();
    }

    //如果快递业务类型为出货、样品，则更改总账科目的值
    if (kdywlx_val == _kdywlx_option.ch[0] || kdywlx_val == _kdywlx_option.yp[0]) {
        zzkm.val(_zzkm_val.val1);
        zzkmspan.html(_zzkm_val.val1);
        xsdd_tr.show();
        salweight.show();
        delDetailTable(_oTable_index.xsdd_index);
    } else {
        zzkm.val(_zzkm_val.val2);
        zzkmspan.html(_zzkm_val.val2);
        xsdd_tr.hide();
        salweight.hide();
        delDetailTable(_oTable_index.xsdd_index);
    }

}

/**
 * 快递公司代码发生改变时，速度可选/不可选，EMS时设置税码和异常费用
 */
function setspeed() {
    var kdgsdm = jQuery('#field' + _localvar.kdgsdm); //快递公司代码
    var kdsd = jQuery('#field' + _localvar.kdsd); //快递速度
    var sdfw = jQuery('#field' + _localvar.sdfw); //送递范围
    var ycfy = jQuery('#field' + _localvar.ycfy); //异常费用

    var kdgsdm_val = kdgsdm.val(); //快递公司代码值
    var sdfw_val = sdfw.val(); //送递范围值
    var ycfy_val = ycfy.val(); //异常费用的值

    //如果是顺丰快递，则速度可以选择，否则不允许选择速度
    if (kdgsdm_val == _localvar.sfkd) {
        kdsd.attr('disabled', false);
    } else {
        kdsd.attr('disabled', true);
        kdsd.val(_kdsd_option.pt[0]);
    }

    //如果是EMS(国际)，异常费用自动加4元
    if (kdgsdm_val == _localvar.ems && sdfw_val == _sdfw_option.gj) {
        if (ycfy_val == '') {
            ycfy.val('4');
        }
        getT0(); //默认为T0
    } else {
        setfield(); //获取税码信息
    }
    checkdanger();
}

/**
 * 限制只能有速尔和DHP寄危险品
 */
function checkdanger() {
    var kdwplb = jQuery('#field' + _localvar.kdwplb); //快递物品类别
    var kdgsdm = jQuery('#field' + _localvar.kdgsdm); //快递公司代码

    var kdwplb_val = kdwplb.val();
    var kdgsdm_val = kdgsdm.val();

    if (kdwplb_val == _kdwplb_option.ytbg || kdwplb_val == _kdwplb_option.wxbg) {
        if (kdgsdm_val != _localvar.sexfh && kdgsdm_val != _localvar.dhp) {
            Dialog.alert('危险品只能寄速尔(鑫飞鸿)和DHP');
            kdwplb.val('');
            AttrUtil.fieldViewCtrl(_localvar.kdwplb, 1);
        }
    }
}

/**
 * 设置税码为T0
 */
function getT0() {
    var fygsgsmc = jQuery('#field' + _localvar.fygsgsmc); //费用归属公司名称
    var fjkdgs = jQuery('#field' + _localvar.fjkdgs); //发件快递公司
    var sm = jQuery('#field' + _localvar.sm); //税码
    var smspan = jQuery('#field' + _localvar.sm + 'span'); //税码span

    var fygsgsmc_val = fygsgsmc.val();
    var fjkdgs_val = fjkdgs.val();

    var sql = 'select id from uf_oa_tax where taxcode = \'T0\'';

    jQuery.getJSON('/EHSM/datautil.jsp', {
        sql: sql
    }, function (data) {
        if (!!data && data.length > 0 && data[0].id != '') {
            sm.val(data[0].id);
            smspan.html('T0');
        } else {
            Dialog.alert('税码T0带出失败，请联系管理员!');
        }
    });
}

/**
 * 根据快递公司以及费用归属公司带出相应的税码信息
 */
function setfield() {
    var fygsgsmc = jQuery("#field" + _localvar.fygsgsmc);
    var fjkdgs = jQuery("#field" + _localvar.fjkdgs);

    var fygsgsmc_val = fygsgsmc.val();
    var fjkdgs_val = fjkdgs.val();

    var sql1 = 'select a.id,a.taxcode from uf_oa_delivtaxinfo b,uf_oa_tax a where a.id = b.taxcode and b.comcoe = ';
    var sql2 = '\'' + fygsgsmc_val + '\' and b.delivref = ';
    var sql3 = '\'' + fjkdgs_val + '\'';

    jQuery.getJSON('/EHSM/datautil.jsp', {
        sql1: sql1,
        sql2: sql2,
        sql3: sql3
    }, function (data) {
        if (!!data && data.length > 0 && data[0].id != '') {
            sm.val(data[0].id);
            smspan.html(data[0].taxcode);
        } else {
            if (!!!jQuery('requestid'))
                Dialog.alert('税码带出失败，请联系管理员!');
        }
    });
}

/**
 * 清空明细表行
 * @param {string} groupid 
 */
function delDetailTable(groupid) {
    var oTable = jQuery("table#oTable" + groupid);
    var checkObj = oTable.find("input[name='check_node_" + groupid + "']");
    if (checkObj.size() > 0) {
        var curindex = parseInt($G("nodesnum" + groupid).value);
        var submitdtlStr = $G("submitdtlid" + groupid).value;
        var deldtlStr = $G("deldtlid" + groupid).value;
        checkObj.each(function () {
            var rowIndex = jQuery(this).val();
            var belRow = oTable.find("tr[_target='datarow'][_rowindex='" + rowIndex + "']");
            var keyid = belRow.find("input[name='dtl_id_" + groupid + "_" + rowIndex + "']").val();
            //提交序号串删除对应行号
            var submitdtlArr = submitdtlStr.split(',');
            submitdtlStr = "";
            for (var i = 0; i < submitdtlArr.length; i++) {
                if (submitdtlArr[i] != rowIndex)
                    submitdtlStr += "," + submitdtlArr[i];
            }
            if (submitdtlStr.length > 0 && submitdtlStr.substring(0, 1) === ",")
                submitdtlStr = submitdtlStr.substring(1);
            //已有明细主键存隐藏域
            if (keyid != "")
                deldtlStr += "," + keyid;
            //IE下需先销毁附件上传的object对象，才能remove行
            try {
                belRow.find("td[_fieldid][_fieldtype='6_1'],td[_fieldid][_fieldtype='6_2']").each(function () {
                    var swfObj = eval("oUpload" + jQuery(this).attr("_fieldid"));
                    swfObj.destroy();
                });
            } catch (e) {}
            belRow.remove();
            curindex--;
        });
        $G("submitdtlid" + groupid).value = submitdtlStr;
        if (deldtlStr.length > 0 && deldtlStr.substring(0, 1) === ",")
            deldtlStr = deldtlStr.substring(1);
        $G("deldtlid" + groupid).value = deldtlStr;
        $G("nodesnum" + groupid).value = curindex;
        //序号重排
        oTable.find("input[name='check_node_" + groupid + "']").each(function (index) {
            var belRow = oTable.find("tr[_target='datarow'][_rowindex='" + jQuery(this).val() + "']");
            belRow.find("span[name='detailIndexSpan" + groupid + "']").text(index + 1);
        });
        oTable.find("input[name='check_all_record']").attr("checked", false);
        //表单设计器，删除行触发公式计算
        triFormula_delRow(groupid);
        try {
            calSum(groupid);
        } catch (e) {}

    }
}
</script>




























