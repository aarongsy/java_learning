<!-- script代码，如果需要引用js文件，请使用与HTML中相同的方式。 -->
<script type="text/javascript">
    jQuery(document).ready(function() {
        var sfyg = jQuery("#field8061").val();
        if (sfyg.length > 0) {
            if (sfyg == 0) {
                delRowFunmd0(0);
                jQuery(".yg").hide();
                jQuery(".wg").show();
            } else {
                delRowFunmd0(1);
                jQuery(".wg").hide();
                jQuery(".yg").show();
            }
        }
        jQuery("#indexnum1").bindPropertyChange(function() {

            var zxjhh = jQuery("#field8381").val();
            if (zxjhh.length == 0) {
                Dialog.alert("请先选装卸计划号");
            }
            addZxjhh(zxjhh);
        });

        function addZxjhh(zxjhh) {
            var index = jQuery("#indexnum1").val() - 1;
            jQuery("#field11861_" + index + "span").html(zxjhh);
            jQuery("#field11861_" + index).val(zxjhh)
        }


        jQuery("#field8061").bindPropertyChange(function() {
            var sfyg = jQuery("#field8061").val();
            if (sfyg.length > 0) {
                if (sfyg == 0) {
                    delRowFunmd0(0);
                    jQuery(".yg").hide();
                    jQuery(".wg").show();
                } else {
                    delRowFunmd0(1);
                    jQuery(".wg").hide();
                    jQuery(".yg").show();
                }
            } else {
                delRowFunmd0(0);
                delRowFunmd0(1);
            }
        });

        jQuery("#field8281").bindPropertyChange(function() {
            var sfdg = jQuery("#field8281").val();
            if (sfdg.length > 0) {
                if (sfdg == 0) {
                    jQuery(".dg").hide();
                } else {
                    jQuery(".dg").show();
                }
            }
        });

        jQuery("#field9461").bindPropertyChange(function() {
            delRowFunmd0(0);
        });
        checkCustomize = function() {
            var sfzf = jQuery("#field13401 option:selected").val();
            console.log("是否作废:" + sfzf);
            if (sfzf == '1') {
                return true;
            }
            return checkALL();
        }
    });

    function checkALL() {
        var sfyg = jQuery("#field8061").val();
        if (sfyg == "0") {
            return checkWg();
        }
        if (sfyg == "1") {
            return check1() && checkYg();
            // if(check1() && checkYg()){
            //     return false;
            // }
        }
        return false;
    }

    function checkWg() {
        var dateRanges = [];
        var mxlists = jQuery("#submitdtlid1").val().split(",");
        console.log(mxlists);
        var result = false;
        var mxjsls = [];
        for (var i = 0; i < mxlists.length; i++) {
            var index1 = mxlists[i];
            var dh1 = jQuery("#field10741_" + index1).val(); //订单号
            var xc1 = jQuery("#field10742_" + index1).val(); //项次号
            var slpc = jQuery("#field11922_" + index1).val(); //该批次次装卸数量
            var sltotal = jQuery("#field13301_" + index1).val(); //应该装卸总量
            console.log("取得数据---订单号:" + dh1 + ",项次：" + xc1 + ",该批次次装卸数量：" + slpc + ",应该装卸总量:" + sltotal);

            if (mxjsls.length > 0) {
                for (var k = 0; k < mxjsls.length; k++) {
                    console.log("k:" + k);
                    var mxjs = mxjsls[k];
                    console.log(mxjs);
                    if (mxjs.dh == dh1 && mxjs.xc == xc1) {
                        var slsum = parseFloat(mxjs.sl) + parseFloat(slpc);

                        mxjs.sl = slsum.toString();
                    }
                }

            } else {
                var mxjs = {
                    "dh": dh1,
                    "xc": xc1,
                    "sl": slpc,
                    "sltotal": sltotal
                };
                mxjsls.push(mxjs);
            }

        }
        console.log(JSON.stringify(mxjsls));
        for (var i = 0; i < mxjsls.length; i++) {
            var jsobj = mxjsls[i];
            if (parseFloat(jsobj.sl) == parseFloat(jsobj.sltotal)) {
                //Dialog.alert("数目填写正确");
                result = true;

            } else {
                Dialog.alert("提示！单号为：" + jsobj.dh + ",项次为：" + jsobj.xc + ",应装卸总数为：" + jsobj.sltotal + ",实际填写装卸总数为：" + jsobj.sl);
            }

        }
        return result;


    }

    function checkYg() {
        var result = false;
        var mxnum; //所属明细
        var ddhid; //订单号表id
        var xcid; //项次表单id
        var bczxslid; //本次装卸数量表单id
        var sfyg = jQuery("#field8061").val();
        var submitdtlid;
        if (sfyg == "1") {
            mxnum = "#indexnum0";
            ddhid = "#field9901_";
            xcid = "#field9903_";
            bczxslid = "#field7832_";
            submitdtlid = "#submitdtlid0";
        }
        if (sfyg == "0") {
            mxnum = "#indexnum1";
            ddhid = "#field10741_";
            xcid = "#field10742_";
            bczxslid = "#field8009_";
            submitdtlid = "#submitdtlid1";

        }
        var idss = jQuery(submitdtlid).val();

        console.log(mxnum + "--" + ddhid + "--" + xcid + "--" + bczxslid + "--" + submitdtlid);
        console.log(idss);

        var submitdtlids = idss.split(",");
        var jsonArr = [];
        console.log(submitdtlids);
        for (var j = 0; j < submitdtlids.length; j++) {
            var i = submitdtlids[j];
            var arr;
            var ddh = jQuery(ddhid + i).val();
            var xc = jQuery(xcid + i).val();
            var bczxsl = jQuery(bczxslid + i).val();
            if (ddh.length > 0 && xc.length > 0 && bczxsl.length > 0) {
                arr = {
                    "ddh": ddh,
                    "xc": xc,
                    "bczxsl": bczxsl
                };
                jsonArr.push(arr);
            }
        }
        console.log(jsonArr);

        jQuery.ajax({
            url: "/sapjsp/lhsq.jsp",
            data: {
                "mxdata": JSON.stringify(jsonArr)
            },
            type: "POST",
            async: false,
            success: function(data) {
                var newData = data.replace(/(^\s*)|(\s*$)/g, "");
                console.log(newData);
                if (newData) {
                    if (newData == "success") {
                        console.log("数据更新成功");
                        result = true;
                    } else {
                        Dialog.alert(newData);
                    }
                }
            }
        })
        return result;
    }




    function check1() {
        var dateRanges = [];
        var bczxsl;
        var zsl;
        // var num = jQuery("#indexnum0").val();
        var submitdtlid0 = jQuery("#submitdtlid0").val();
        var num = submitdtlid0.split(",");
        var tt;
        var result = true;
        var failmsg;
        for (var j = 0; j < num.length; j++) {
            var i = num[j];
            bczxsl = jQuery("#field7832_" + i).val();
            var zdzxl = jQuery("field12901_" + i).val(); //最大装卸量
            var ph = jQuery("field12881_" + i).val(); //批号
            var pcyzzsl = 0; //批次已装卸数量
            var pcbczzsl = 0; //累计本次批次装卸数量
            for (var n = 0; n < num.length; n++) {
                var pc = jQuery("field12881_" + n).val(); //批号
                if (ph == pc) {
                    pcyzzsl = jQuery("#field13700_" + n).val();
                    pcbczzsl = pcbczzsl + jQuery("#field7832_" + n).val();
                }
            }
            if (zdzxl - pcyzzsl - pcbczzsl < 0) {
                return false;
            }
            zsl = parseFloat(jQuery("#field7831_" + i).val()) - parseFloat(jQuery("#field11701_" + i).val());
            console.log(bczxsl + "-" + zsl);
            if (bczxsl - zsl > 0) {
                result = false;
                failmsg = {
                    "ddh": jQuery("#field9901_" + i).val(),
                    "xc": jQuery("#field9903_" + i).val()
                };
                break;
            }
            if (bczxsl > zdzxl) {
                Dialog.alert("单号为：" + jQuery("#field9901_" + i).val() + "，项次为：" + jQuery("#field9903_" + i).val() + ",批号" + ph + "的明细中，本次装卸数量只和不能大于批号允许最大装卸量，请重新填写!");
            }
            for (var j = i + 1; j < num; j++) {
                if ((jQuery("#field9901_" + i).val() == jQuery("#field9901_" + j).val()) && jQuery("#field9903_" + i).val() == jQuery("#field9903_" + j).val()) {
                    tt = parseFloat(bczxsl) + parseFloat(jQuery("#field7832_" + j).val());
                    console.log(tt + "-" + zsl);
                    if (tt - zsl > 0) {
                        result = false;
                        failmsg = {
                            "ddh": jQuery("#field9901_" + i).val(),
                            "xc": jQuery("#field9903_" + i).val()
                        };
                        break;
                    }
                    /*
                    var _tmp = {
                        'bczxsl': tt,
                        'zsl': jQuery("#field7831_" + i).val()
                    };
                    dateRanges.push(_tmp);
                    */
                }
            }
        }
        if (result) {

            return true;
        } else {
            Dialog.alert("单号为：" + failmsg.ddh + "，项次为：" + failmsg.xc + "的明细中，本次装卸数量只和不能大于剩余总数量，请重新填写!");
            return false;
        }
    }
</script>
<script type="text/javascript" src="/sapjsp/util.js"></script>
