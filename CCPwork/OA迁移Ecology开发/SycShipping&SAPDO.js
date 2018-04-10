<!-- script代码，如果需要引用js文件，请使用与HTML中相同的方式。 -->
<script type="text/javascript">
$(document).ready(function() {
    var blurfield = "#field7981";
    /*
    $("#field7781").bind('change', function() {
        var v = $("#field7781").val();
        if (v == '0' || v == '') {
            $(".hideDt1").hide();
            deleteAll(0);
        } else {
            $(".hideDt1").show();
        }

    });
    */
    $(blurfield).bindPropertyChange(function() {
        var shipping = $(blurfield).val(); //shipping柜号
        console.log("shipping:" + shipping);
        if (shipping.length < 1)
            return;

        $.post("/sapjsp/ewaverdata-shipping.jsp?shipping=" + shipping, function(data) {
            if (data) {
                if (data.length > 0) {
                    Dialog.alert("Data acquisition success!");
                    deleteAll(0);
                    var shippings = data.split("![]");
                    for (var i = 1; i < shippings.length; i++) {
                        console.log(shippings[i]);
                        var fields = shippings[i].split("|");
                        addRow0(0);
                        var hang_number = parseInt(jQuery("#indexnum0").val()) - 1;

                        ValSapn("#field7308_" + hang_number, fields[0]);
                        ValSapn("#field7309_" + hang_number, fields[1]);
                        ValSapn("#field7362_" + hang_number, fields[2]);
                        ValSapn("#field7311_" + hang_number, fields[3]);
                        ValSapn("#field7312_" + hang_number, fields[4]);
                        ValSapn("#field7313_" + hang_number, fields[5]);
                        ValSapn("#field7314_" + hang_number, fields[6]);
                        ValSapn("#field7315_" + hang_number, fields[7]);
                        ValSapn("#field7316_" + hang_number, fields[8]);
                        ValSapn("#field7317_" + hang_number, fields[9]);
                        ValSapn("#field7318_" + hang_number, fields[10]);
                        ValSapn("#field7319_" + hang_number, fields[11]);
                        ValSapn("#field7320_" + hang_number, fields[12]);
                        ValSapn("#field7321_" + hang_number, fields[13]);
                        ValSapn("#field7322_" + hang_number, fields[14]);
                        ValSapn("#field7323_" + hang_number, fields[15]);
                        ValSapn("#field7324_" + hang_number, fields[16]);
                        ValSapn("#field7325_" + hang_number, fields[17]);
                        ValSapn("#field7326_" + hang_number, fields[18]);
                        ValSapn("#field7327_" + hang_number, fields[19]);
                        ValSapn("#field7328_" + hang_number, fields[20]);
                        ValSapn("#field7329_" + hang_number, fields[21]);
                        ValSapn("#field7330_" + hang_number, fields[22]);
                        ValSapn("#field7331_" + hang_number, fields[23]);
                        ValSapn("#field7332_" + hang_number, fields[24]);
                        ValSapn("#field7333_" + hang_number, fields[25]);
                        ValSapn("#field7881_" + hang_number, fields[26]);
                        ValSapn("#field7882_" + hang_number, fields[27]);
                        ValSapn("#field7883_" + hang_number, fields[28]);
                        ValSapn("#field13141_" + hang_number, fields[29]);
                        ValSapn("#field13142_" + hang_number, fields[30]);
ValSapn("#field13437_" + hang_number, fields[31]);
                    }
                }
            }
        });
    })
})

function ValSapn(fieldid, fieldval) {
    jQuery(fieldid).val(fieldval);
    jQuery(fieldid + "span").text(fieldval);
}

function deleteAll(dtnum) {
    delRowFunmd0(dtnum);
}

function delRowFunmd0(groupid) {
    var oTable = $("table#oTable" + groupid);
    var checkObj = oTable.find("input[name='check_node_" + groupid + "']");
    if (checkObj.size() > 0) {

        var curindex = parseInt($G("nodesnum" + groupid).value);
        var submitdtlStr = $G("submitdtlid" + groupid).value;
        var deldtlStr = $G("deldtlid" + groupid).value;
        checkObj.each(function() {
            var rowIndex = $(this).val();
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
                belRow.find("td[_fieldid][_fieldtype='6_1'],td[_fieldid][_fieldtype='6_2']").each(function() {
                    var swfObj = eval("oUpload" + $(this).attr("_fieldid"));
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
        oTable.find("input[name='check_node_" + groupid + "']").each(function(index) {
            var belRow = oTable.find("tr[_target='datarow'][_rowindex='" + $(this).val() + "']");
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

//批量打印
function getAll() {
    var billids = _xtable_CheckedCheckboxId();
    var requestids = "";
    if (billids == "") {
        alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>'); ///请至少选择一条记录。
        return;
    }
    $.post("/sapjsp/getAllRequestid.jsp?billids=" + billids, function(data) {
        if (data) {
            var billid = data.split("![]");
            for (var i = 1; i < billid.length; i++) {
                requestids += billid[i];
            }
            alert(requestids);
            window.open("/workflow/multiprint/MultiPrintRequest.jsp?multirequestid=" + requestids);
        }
    });
}
</script>





