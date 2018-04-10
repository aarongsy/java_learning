<script type="text/javascript">
/**
 *
 * @author jisuqiang
 * @date 2017-12-16
 */
jQuery(document).ready(function() {

    bindChange();

    checkCustomize = function() {
        return true;
    }
});

function bindChange() {
    var html = "<input type='button' value='生成凭证行项目' class='middle e8_btn_top_first' id='accquire' />";
    $("#needButton").append(html);
    $("#accquire").click(function() {
        accquire();
    });
    var html = "<input type='button' value='上传sap凭证项目' class='middle e8_btn_top_first' id='upsap' />";
    $("#upbutton").append(html);
    $("#upsap").click(function() {
        upsap();
    });
    var html2 = '<input type="button" onclick="clearRead()" class="middle e8_btn_top_first" value="获取未清行项目" style="margin-top:4px;"/>';
    jQuery("#readButton").append(html2);

    $("#sumvalue12352").bindPropertyChange(function() {
        calcAmount1();
    });
    $("#sumvalue12353").bindPropertyChange(function() {
        calcAmount1();
    });

    $("#sumvalue12322").bindPropertyChange(function() {
        calcAmount2();
    });
    $("#sumvalue12362").bindPropertyChange(function() {
        calcAmount2();
    });
    checkWL();
    $("#field12227").bindPropertyChange(function() {
        getSaphl();
    });
}
//获取发票汇率
function getSaphl() {
    var fpzb = $("#field12227").val(); //发票币种
    var bwbz = $("#field12228").val(); //本位币种
    jQuery.ajax({
        url: "/sapjsp/JsonAction.jsp?",
        data: {
            "currncy": fpzb,
            "to_currncy": bwbz,
            "action": "getData"
        },
        type: "POST",
        dataType: "JSON",
        async: false,
        success: function(data) {
            if (data) {
                console.log(data);
                console.log("-------");
                console.log(JSON.parse(data));
                if (JSON.parse(data).flag == "X") {
                    ValSapn("#field12235", JSON.parse(data).rate);
                } else {
                    ValSapn("#field12235", "1.0000");
                }
            }
        },
        error: function() {
            Dialog.alert("发生错误");
        }
    })

}

function upsap() {
    var pzrq = $("#field12301").val(); //凭证日期
    var pzlx = $("#field12302").val(); //凭证类型
    var gsdm = $("#field12310").val(); //公司代码
    var hbdm = $("#field12311").val(); //货币代码
    var hl = $("#field12304").val(); //汇率
    var notesid = $("#field12313").val(); //notesid
    var list1 = [];
    var list2 = [];
    var mx1 = $("#submitdtlid1").val().split(",");
    if (mx1 != '') {

        for (var i = 0; i < mx1.length; i++) {
            var temp = {
                "VC_FLAG": $("#field12335_" + mx1[i]).val(), //供应商客户标识
                "VC_NO": $("#field12336_" + mx1[i]).val(), //供应商或客户编号
                "SGL_FLAG": $("#field12337_" + mx1[i]).val(), //特殊总账标识
                "DOC_NO": $("#field12338_" + mx1[i]).val(), //需清帐凭证编号
                "DOC_YEAR": $("#field12339_" + mx1[i]).val(), //会计年度
                "DOC_ITEM": $("#field12340_" + mx1[i]).val(), //行项目号              
                "CL_MONEY": $("#field12341_" + mx1[i]).val(), //清帐金额
                "CL_TEXT": $("#field12343_" + mx1[i]).val(), //清帐文本
            }
            list1.push(temp);
        }
        var mx5 = $("#submitdtlid5").val().split(",");
        if (mx5 != '') {
            for (var i = 0; i < mx5.length; i++) {
                var temp = {
                    "PSTNG_CODE": $("#field12397_" + mx5[i]).val(), //记账码
                    "GL_ACCOUNT": $("#field12398_" + mx5[i]).val(), //总账科目
                    "MONEY": $("#field12399_" + mx5[i]).val(), //金额
                    "TAX_CODE": $("#field12406_" + mx5[i]).val(), //税码
                    "COST_CENTER": $("#field12407_" + mx5[i]).val(), //成本中心
                    "NO": $("#field12411_" + mx5[i]).val(), //订单号           
                    "ITEM": $("#field12412_" + mx5[i]).val(), //订单项次
                    "ITEM_TEXT": $("#field12410_" + mx5[i]).val(), //行项目文本
                    "BANK_TYPE": $("#field12409_" + mx5[i]).val(), //合作银行类型
                    "PAY_LOCK": $("#field12402_" + mx5[i]).val(), //冻结付款
                    "PAY_TERMS": $("#field12400_" + mx5[i]).val(), //付款条款            
                    "PAY_WAY": $("#field12403_" + mx5[i]).val(), //付款方式
                    "PAY_DATE": $("#field12401_" + mx5[i]).val(), //到期日
                    "PAY_CUR": $("#field12404_" + mx5[i]).val(), //支付货币
                    "PAY_MONEY": $("#field12405_" + mx5[i]).val(), //支付金额
                    "MATERIAL": $("#field12408_" + mx5[i]).val(), //物理号
                }
                list2.push(temp);
            }
        }
    }

    if (list1.length > 0 && list2.length > 0) {
        console.log(list1);
        console.log(list2);
        jQuery.ajax({
            url: "/sapjsp/QZ_UP_SAP.jsp",
            data: {
                "list1": JSON.stringify(list1),
                "list2": JSON.stringify(list2),
                "DOC_DATE": pzrq, //凭证日期
                "DOC_TYPE": pzlx, //凭证类型
                "COMP_CODE": gsdm, //公司代码
                "CURRENCY": hbdm, //货币代码
                "EXCHNG_RATE": hl, //汇率
                "NOTESID": notesid //notesid
            },
            type: "POST",
            dataType: "JSON",
            async: false,
            success: function(data) {
                console.log(data);
                if (data) {
                    if (data.FLAG == 'X') {
                        Dialog.alert("上传SAP成功");
                        ValSapn("#field12308", data.FLAG);
                        ValSapn("#field12314", data.AC_DOC_NO);
                        ValSapn("#field12307", data.ERR_MSG);
                    } else {
                        Dialog.alert("上传失败，请检查数据是否正确无误");
                        ValSapn("#field12307", data.ERR_MSG);
                    }
                }
            },
            error: function() {
                Dialog.alert("发生错误");
            }
        });
    }


    var mx6 = $("#submitdtlid6").val().split(",");
    if (mx6 != '') {
        var list = [];
        for (var i = 0; i < mx6.length; i++) {
            var temp = {
                "gsdm": $("#field12415").val(), //公司代码
                "wlh": $("#field12941_" + mx6[i]).val(), //物料号
                "wlje": $("#field12942_" + mx6[i]).val(), //物料金额
                "notesid": $("#field12943_" + mx6[i]).val(), //notesid
            }
            list.push(temp);
        }
        console.log(list);
        jQuery.ajax({
            url: "/sapjsp/QZ_UP_SAP_WL.jsp",
            data: {
                "list": JSON.stringify(list),
            },
            type: "POST",
            dataType: "JSON",
            async: false,
            success: function(data) {
                if (data) {
                    console.log(data);
                    jQuery.each(data.result, function(i, item) {
                        ValSapn("#field12944_" + mx6[i], item.MBLNR);
                    });
                }
            },
            error: function() {
                Dialog.alert("发生错误");
            }
        });

    }
}

function calcAmount1() {
    //暂估币种=发票币种，则暂估未税金额合计=清账明细的清账金额合计+其他费用明细的清账未税金额合计
    //暂估币种≠ 发票币种， 则暂估未税金额合计 = 清账明细的清账本位币差额合计 + 未清项明细的未清项本位币金额合计的绝对值 + 其他费用明细的清账本位币金额合计
    var sumvalue12325 = $("#sumvalue12325").val(); //清帐金额合计
    var sumvalue12352 = $("#sumvalue12352").val(); //其他费用明细的清账未税金额合计

    var sumvalue12328 = $("#sumvalue12328").val(); //清帐本位币差额合计
    var sumvalue12342 = Math.abs($("#sumvalue12342").val()); //为清项本位币金额合计绝对值
    var sumvalue12353 = $("#sumvalue12353").val(); //其他费用明细本位币金额合计

    var zgbz = $("#field12226").val(); //暂估币种
    var fpzb = $("#field12227").val(); //发票币种
    var amount;
    if (zgbz == fpzb && zgbz != '' && fpzb != '') {
        console.log("暂估币种=发票币种");
        //暂估未税金额合计
        amount = parseFloat(sumvalue12325) + parseFloat(sumvalue12352);
    } else if (zgbz != fpzb && zgbz != '' && fpzb != '') {
        console.log("暂估币种!=发票币种");
        amount = parseFloat(sumvalue12328) + parseFloat(sumvalue12342) + parseFloat(sumvalue12353);
    } else {
        amount = 0;
    }

    $("#field12256").val(amount);
    $("#field12256span").text(amount);
}

function calcAmount2() {
    var sumvalue12322 = $("#sumvalue12322").val(); //暂估未税金额合计
    var sumvalue12362 = $("#sumvalue12362").val(); //发票未税金额合计

    var amount = parseFloat(sumvalue12362) - parseFloat(sumvalue12322);
    //暂估差异金额=发票明细的未税金额合计-暂估未税金额合计
    $("#field12246").val(amount);
    $("#field12246span").text(amount);
}

function copy() {
    var tbrq = $("#field12231").val(); //填表日期
    var gsdm = $("#field12224").val(); //公司代码
    var fpbz = $("#field12227").val(); //发票币种
    var lcbh = $("#field12221").val(); //流程编号
    var hl = $("#field12235").val(); //发票汇率

    ValSapn("#field12301", tbrq);
    ValSapn("#field12302", "KG");
    ValSapn("#field12310", gsdm);
    ValSapn("#field12311", fpbz);
    ValSapn("#field12305", "费用暂估清帐");
    ValSapn("#field12313", lcbh);
    ValSapn("#field12304", hl);
}

function accquire() {
    copy();
    //TODO
    var fpdh = $("#field12234").val(); //发票单号
    var cysbh = $("#field12225").val(); //承运商编号
    var fktjdm = $("#field12260").val(); //付款条件代码
    var fkjzrq = $("#field12251").val(); //付款基准日期
    var fkdj = $("#field12255").val(); //付款冻结
    var fkfs = $("#field12249").val(); //付款方式代码

    var yh = $("#field12243").val(); //银行合作类型

    var zgbz = $("#field12226").val(); //暂估币种
    var fpzb = $("#field12227").val(); //发票币种

    if (fpdh == '') {
        Dialog.alert("请填写发票单号!");
        return;
    }

    var list = [];
    for (var i = 0; i < $("#indexnum3").val(); i++) {
        console.log("1.获取发票明细");
        var mx3 = $("#submitdtlid3").val().split(","); //明细3明细
        if (mx3 != '') {
            for (var i = 0; i < mx3.length; i++) {
                var zfhbje = $("#field12365_" + mx3[i]).val();
                var zfhb = $("#field12241").val(); //支付货币
                if (zfhbje == '') {
                    zfhb = '';
                }
                var temp = {
                    "jzm": 31, //记账码
                    "zzkm": cysbh, //总账科目
                    "je": $("#field12360_" + mx3[i]).val(), //发票未税金额
                    "fktj": fktjdm, //付款条件代码
                    "fkdj": fkdj,
                    "fkjzrq": fkjzrq,
                    "fkfs": fkfs,
                    "zfhbje": zfhbje,
                    "zfhb": zfhb,
                    "yh": yh
                }

                list.push(temp);
            }
        }
    }

    var zgcyje = $("#field12246").val(); //暂估差异金额
    if (zgcyje != '' && zgcyje - 0 != 0) {
        console.log("2.暂估差异金额");
        var index = $("#submitdtlid0").val().split(",")[0];
        console.log(index);
        var jzm = "40";
        if (zgcyje - 0 < 0) {
            jzm = "50";
        }
        var temp = {
            "jzm": jzm, //记账码
            "zzkm": $("#field12248").val(), //总账科目(暂估差异总账科目)
            "je": Math.abs($("#field12246").val()), //暂估差异金额的绝对值
            "sm": $("#field12259").val(), //税码
            "cbzx": $("#field12258").val(), //成本中心
            "ddh": $("#field12316_" + index).val(), //订单号
            "xc": $("#field12317_" + index).val(), //项次
            "wlh": $("#field12332_" + index).val(), //物料号
            "wb": ""
        }
        list.push(temp);
    }

    if (mx3 != '') {
        for (var i = 0; i < mx3.length; i++) {
            console.log("3.获取发票明细的税额");
            var fpse = $("#field12361_" + mx3[i]).val(); //发票税额
            if (fpse - 0 > 0) {
                var temp = {
                    "jzm": 40, //记账码
                    "zzkm": "21710101", //总账科目
                    "je": fpse, //暂估差异金额的绝对值
                    "sm": $("#field12259").val(), //税码
                    "wb": ""
                }
                list.push(temp);
            }
        }
    }

    //TODO
    if (zgbz != fpzb && zgbz != '' && fpzb != '') {
        var mx0 = $("#submitdtlid0").val().split(","); //明细0明细
        if (mx0 != '') {
            var bebce = $("#sumvalue12328").val(); //本位币差额合计
            var ywbce = $("#sumvalue12327").val(); //业务比差额合计
            var hl = $("#field12235").val(); //发票汇率
            var total = parseFloat(bebce) - parseFloat(ywbce) * parseFloat(hl);
            var jzm = 40;
            if (total - 0 < 0) {
                jzm = 50;
            }
            if (total - 0 != 0) {

                var temp = {
                    "jzm": jzm, //记账码
                    "zzkm": "55030300", //总账科目
                    "je": Math.abs(total), //暂估差异金额的绝对值
                    "sm": $("#field12259").val(), //税码
                    "wb": "汇兑差",
                    "cbzx": "20101400"
                }
            }
            list.push(temp);

        }
    }

    var mx4 = $("#submitdtlid4").val().split(","); //明细4明细
    if (mx4 != '') {
        for (var i = 0; i < mx4.length; i++) {
            console.log("5.获取其他费用清帐会计明细");
            var jzm = "40";
            var je = "";
            var zefyxj = $("#field12389_" + mx4[i]).val(); //增额费用小计
            var zefybwb = $("#field12390_" + mx4[i]).val(); //增额费用本位币小计
            if (zgbz == fpzb && zgbz != '' && fpzb != '') {
                if (zefyxj - 0 < 0) {
                    jzm = "50";
                }
                je = Math.abs(zefyxj);
            } else {
                if (zefybwb - 0 < 0) {
                    jzm = "50";
                }
                je = Math.abs(zefybwb);
            }
            var temp = {
                "jzm": jzm, //记账码
                "zzkm": $("#field12381_" + mx4[i]).val(), //总账科目(暂估差异总账科目)
                "je": je, //暂估差异金额的绝对值
                "sm": $("#field12259").val(), //税码
                "cbzx": $("#field12392_" + mx4[i]).val(), //成本中心
                "ddh": $("#field12395_" + index).val(), //订单号
                "xc": $("#field12396_" + index).val(), //项次
                "wlh": $("#field12391_" + index).val(), //物料号
                "wb": ""
            }
            list.push(temp);
        }
    }
    console.log(list);
    delRowFunmd0(5);
    addMX5(list);
    accquireWL();
    Dialog.alert("生成凭证行项目成功！");
}

function accquireWL() {
    if (checkWL()) {
        var mx0 = $("#submitdtlid0").val().split(","); //明细0明细    
        var list1 = [];
        var totalList = [];
        if (mx0 != '') {

            for (var i = 0; i < mx0.length; i++) {
                var zzkm = $("#field12330_" + mx0[i]).val(); //总账科目
                var lx = $("#field12333_" + mx0[i]).val(); //类型
                var wlh = $("#field12332_" + mx0[i]).val(); //物料号
                var ddh = $("#field12316_" + mx0[i]).val(); //订单号
                var xc = $("#field12317_" + mx0[i]).val(); //项次
                var zgbwbje = $("#field12324_" + mx0[i]).val(); //暂估本位币金额
                if (zzkm == "12470000" && lx == '1' && zzkm != '' && wlh != '' && ddh != '' && xc != '') {
                    var temp = {
                        "zzkm": zzkm,
                        "wlh": wlh, //物料号
                        "ddh": ddh, //订单号
                        "xc": xc, //项次
                        "zgbwbje": zgbwbje, //暂估本位币金额
                        "total": zgbwbje,
                        "ftje": 0 //分摊金额
                    }
                    list1.push(temp);
                }
            }
            for (var i = 0; i < list1.length; i++) {
                var flag = 0
                for (var j = i + 1; j < list1.length; j++) {
                    if (list1[i].wlh == list1[j].wlh && list1[i].ddh == list1[j].ddh && list1[i].xc == list1[j].xc) {
                        list1[i].zgbwbje = parseFloat(list1[i].zgbwbje) + parseFloat(list1[j].zgbwbje);
                        list1.splice(j, 1);
                        flag = 1;
                    }

                }
            }

            for (var i = 0; i < list1.length; i++) {
                totalList.push(list1[i]);
            }
            for (var i = 0; i < list1.length; i++) {
                if (i - 0 > 0) {
                    list1[i].total = parseFloat(list1[i].zgbwbje) + parseFloat(list1[i - 1].zgbwbje);
                }
            }
        }

        var list2 = [];
        var mx4 = $("#submitdtlid4").val().split(","); //明细4明细    
        if (mx4 != '') {
            for (var i = 0; i < mx4.length; i++) {
                var zzkm = $("#field12381_" + mx4[i]).val(); //总账科目
                var lx = $("#field12394_" + mx4[i]).val(); //类型
                var wlh = $("#field12332_" + mx4[i]).val(); //物料号
                var ddh = $("#field12395_" + mx4[i]).val(); //订单号
                var xc = $("#field12396_" + mx4[i]).val(); //项次
                var zgbwbje = $("#field12386_" + mx4[i]).val(); //暂估本位币金额
                if (zzkm == "12470000" && lx == '1' && zzkm != '' && wlh != '' && ddh != '' && xc != '') {
                    var temp = {
                        "zzkm": zzkm,
                        "wlh": wlh, //物料号
                        "ddh": ddh, //订单号
                        "xc": xc, //项次
                        "zgbwbje": zgbwbje, //暂估本位币金额
                        "total": "",
                        "ftje": "" //分摊金额
                    }
                    list2.push(temp);
                }
            }
            for (var i = 0; i < list2.length; i++) {
                var flag = 0;
                for (var j = i + 1; j < list2.length; j++) {
                    if (list2[i].wlh == list2[j].wlh && list2[i].ddh == list2[j].ddh && list2[i].xc == list2[j].xc) {
                        list2[i].zgbwbje = parseFloat(list2[i].zgbwbje) + parseFloat(list2[j].zgbwbje);
                        list2.splice(j, 1);
                        flag = 1;
                    }

                }
            }
            for (var i = 0; i < list2.length; i++) {
                totalList.push(list2[i]);
            }
        }
        var list3 = [];
        var zgcyje = $("#field12246").val(); //暂估差异金额
        var zgcyzzkm = $("#field12248").val(); //暂估差异总账科目
        var sum = 0;
        if (zgcyje - 0 != 0 && zgcyzzkm == '12470000' && zgcyzzkm != null) {
            for (var i = 0; i < list1.length; i++) {
                if (i - 1 != 0) {
                    list1[i].ftje = parseFloat(parseFloat(zgcyje) * (parseFloat(list1[i].zgbwbje) / parseFloat(list1[list1.length - 1].total))).toFixed(2);
                    sum += list1[i].ftje;
                }
                if (i - 1 == 0) {
                    list1[i].ftje = zgcyje - sum;
                }
                var temp = {
                    "zzkm": "12470000",
                    "wlh": list1[i].wlh, //物料号
                    "ddh": list1[i].ddh, //订单号
                    "xc": list1[i].xc, //项次
                    "zgbwbje": list1[i].ftje, //暂估本位币金额
                    "total": "",
                    "ftje": 0 //分摊金额
                }
                list3.push(temp);
            }
        }
        for (var i = 0; i < list3.length; i++) {
            totalList.push(list3[i]);
        }

        console.log(list1);
        console.log(list2);
        console.log(list3);
        //console.log(totalList);
        //console.log(totalList.length);

        for (var i = 0; i < totalList.length; i++) {
            for (var j = i + 1; j < totalList.length; j++) {
                if (totalList[i].wlh == totalList[j].wlh && totalList[i].ddh == totalList[j].ddh && totalList[i].xc == totalList[j].xc) {
                    totalList[i].zgbwbje = parseFloat(totalList[i].zgbwbje) + parseFloat(totalList[j].zgbwbje);
                    totalList.splice(j, 1);
                }

            }
        }
        console.log(totalList);
        if (totalList.length > 0) {
            delRowFunmd0(6);
            for (var i = 0; i < totalList.length; i++) {
                addRow6(6);
                var hang_number = parseInt(jQuery("#indexnum6").val()) - 1;
                ValSapn("#field12941_" + hang_number, totalList[i].wlh);
                ValSapn("#field12942_" + hang_number, totalList[i].zgbwbje);
            }
        }

    }
}

function checkWL() {
    var mx0 = $("#submitdtlid0").val().split(","); //明细0明细    
    if (mx0 != '') {
        var index = 0;
        for (var i = 0; i < mx0.length; i++) {
            var zzkm = $("#field12330_" + mx0[i]).val(); //总账科目
            var wlh = $("#field12332_" + mx0[i]).val(); //物料号
            if (zzkm == '12470000' && wlh != '') {
                index++;
            }

        }
    }
    if (index - 0 > 0) {
        $(".wlpz").show();
        return true;
    } else {
        $(".wlpz").hide();
        return false;
    }
}

function addMX5(list) {
    for (var i = 0; i < list.length; i++) {
        addRow5(5);
        var hang_number = parseInt(jQuery("#indexnum5").val()) - 1;
        ValSapn("#field12397_" + hang_number, list[i].jzm);
        ValSapn("#field12398_" + hang_number, list[i].zzkm);
        ValSapn("#field12399_" + hang_number, list[i].je);
        ValSapn("#field12400_" + hang_number, list[i].fktj);
        ValSapn("#field12401_" + hang_number, list[i].fkjzrq);
        ValSapn("#field12402_" + hang_number, list[i].fkdj);
        ValSapn("#field12403_" + hang_number, list[i].fkfs);
        ValSapn("#field12404_" + hang_number, list[i].zfhb);
        ValSapn("#field12405_" + hang_number, list[i].zfhbje);
        ValSapn("#field12406_" + hang_number, list[i].sm);
        ValSapn("#field12407_" + hang_number, list[i].cbzx);
        ValSapn("#field12408_" + hang_number, list[i].wlh);
        ValSapn("#field12409_" + hang_number, list[i].yh);
        ValSapn("#field12410_" + hang_number, list[i].wb);
        ValSapn("#field12411_" + hang_number, list[i].ddh);
        ValSapn("#field12412_" + hang_number, list[i].xc);

    }
}

function clearRead() {
    var cysbh = $("#field12225").val(); //承运商编号
    var gsdm = $("#field12224").val(); //公司代码
    if (cysbh == '' || gsdm == '') {
        Dialog.alert("承运商编码和公司代码为空,获取失败!");
        return;
    }

    var list = [];
    var HKONTS = [];
    var BELNRS = [];

    for (var i = 0; i < $("#indexnum0").val(); i++) {
        if ($("#field12334_" + i).val() != '' && $("#field12334_" + i).val() != null) {
            HKONTS.push($("#field12330_" + i).val()); //总账科目
            BELNRS.push($("#field12334_" + i).val()); //sap凭证编号
        }
    }
    console.log("HKONTS" + HKONTS);
    console.log("BELNRS" + BELNRS);
    jQuery.ajax({
        url: "/sapjsp/QZ_FI_READ.jsp",
        data: {
            "HKONTS": HKONTS,
            "BELNRS": BELNRS,
            "cysbh": cysbh,
            "gsdm": gsdm
        },
        type: "POST",
        dataType: "JSON",
        async: false,
        success: function(data) {
            if (data) {
                console.log(data);
                if (data.flag == "X") {
                    Dialog.alert("获取未清项数据成功!");
                    delRowFunmd0(1);
                    jQuery.each(data.result, function(i, item) {
                        addRow1(1);
                        var hang_number = parseInt(jQuery("#indexnum1").val()) - 1;
                        ValSapn("#field12335_" + hang_number, item.KOART);
                        ValSapn("#field12336_" + hang_number, item.HKONT);
                        ValSapn("#field12337_" + hang_number, item.UMSKZ);
                        ValSapn("#field12338_" + hang_number, item.BELNR);
                        ValSapn("#field12339_" + hang_number, item.GJAHR);
                        ValSapn("#field12340_" + hang_number, item.BUZEI);
                        ValSapn("#field12341_" + hang_number, item.WRBTR);
                        ValSapn("#field12342_" + hang_number, item.DMBTR);
                        ValSapn("#field12343_" + hang_number, item.SGTXT);
                    });

                } else {
                    Dialog.alert(data);
                }
            }
        }
    })
}

function ValSapn(fieldid, fieldval) {
    jQuery(fieldid).val(fieldval);
    jQuery(fieldid + "span").text(fieldval);
}
</script>
<script type = "text/javascript" src = "/sapjsp/util.js" > </script>