<!-- script代码，如果需要引用js文件，请使用与HTML中相同的方式。 -->
<script type="text/javascript">
    $(document).ready(function() {
        var blurfield = "#field9881";
        $(blurfield).bind('change', function() {
            var ponos = $(blurfield).val(); //shipping柜号
            console.log("ponos:" + ponos);
            deleteAll(0);
            if (ponos == '')
                return;

            $.post("/sapjsp/DG_PO_COPY_SAP.jsp?ponos=" + ponos, function(data) {
                if (data) {
                    if (data.length > 48) {
                        Dialog.alert("Data acquisition success!");
                        var ponoses = data.split("![]");
                        for (var i = 1; i < ponoses.length; i++) {
                            console.log(ponoses[i]);
                            var fields = ponoses[i].split("|");
                            addRow0(0);
                            var hang_number = parseInt(jQuery("#indexnum0").val()) - 1;

                            /*
                            jQuery("#field9621_" + hang_number).val(fields[0]);
                            jQuery("#field9622_" + hang_number).val(fields[1]);
                            jQuery("#field9623_" + hang_number).val(fields[2]);
                            jQuery("#field9624_" + hang_number).val(fields[3]);
                            jQuery("#field9625_" + hang_number).val(fields[4]);
                            jQuery("#field9626_" + hang_number).val(fields[5]);
                            jQuery("#field9627_" + hang_number).val(fields[6]);
                            */
                            jQuery("#field9628_" + hang_number).val(fields[7]);
                            /*
                            jQuery("#field9629_" + hang_number).val(fields[8]);
                            jQuery("#field9630_" + hang_number).val(fields[9]);
                            jQuery("#field9631_" + hang_number).val(fields[10]);
                            jQuery("#field9632_" + hang_number).val(fields[11]);
                            jQuery("#field9633_" + hang_number).val(fields[12]);
                            jQuery("#field9634_" + hang_number).val(fields[13]);
                            jQuery("#field9635_" + hang_number).val(fields[14]);
                            jQuery("#field9636_" + hang_number).val(fields[15]);
                            jQuery("#field9637_" + hang_number).val(fields[16]);
                            jQuery("#field9638_" + hang_number).val(fields[17]);
                            jQuery("#field9639_" + hang_number).val(fields[18]);
                            jQuery("#field9640_" + hang_number).val(fields[19]);
                            jQuery("#field9641_" + hang_number).val(fields[20]);
                            jQuery("#field9642_" + hang_number).val(fields[21]);
                            jQuery("#field9643_" + hang_number).val(fields[22]);
                            jQuery("#field9644_" + hang_number).val(fields[23]);
                            jQuery("#field9645_" + hang_number).val(fields[24]);
                            jQuery("#field9646_" + hang_number).val(fields[25]);
                            jQuery("#field9647_" + hang_number).val(fields[26]);
                            jQuery("#field9648_" + hang_number).val(fields[27]);
                            */

                            fieldidvalue("#field9621_" + hang_number, fields[0]);
                            fieldidvalue("#field9622_" + hang_number, fields[1]);
                            fieldidvalue("#field9623_" + hang_number, fields[2]);
                            fieldidvalue("#field9624_" + hang_number, fields[3]);
                            fieldidvalue("#field9625_" + hang_number, fields[4]);
                            fieldidvalue("#field9626_" + hang_number, fields[5]);
                            fieldidvalue("#field9627_" + hang_number, fields[6]);
                            //fieldidvalue("#field9628_" + hang_number, fields[33]);
                            jQuery("#field9628_" + hang_number).val(fields[33]);
                            fieldidvalue("#field9629_" + hang_number, fields[8]);
                            fieldidvalue("#field9630_" + hang_number, fields[9]);
                            fieldidvalue("#field9631_" + hang_number, fields[10]);
                            fieldidvalue("#field9632_" + hang_number, fields[11]);
                            fieldidvalue("#field9633_" + hang_number, fields[12]);
                            fieldidvalue("#field9634_" + hang_number, fields[13]);
                            fieldidvalue("#field9635_" + hang_number, fields[14]);
                            fieldidvalue("#field9636_" + hang_number, fields[15]);
                            fieldidvalue("#field9637_" + hang_number, fields[16]);
                            fieldidvalue("#field9638_" + hang_number, fields[17]);
                            fieldidvalue("#field9639_" + hang_number, fields[18]);
                            fieldidvalue("#field9640_" + hang_number, fields[19]);
                            fieldidvalue("#field9641_" + hang_number, fields[20]);
                            fieldidvalue("#field9642_" + hang_number, fields[21]);
                            fieldidvalue("#field9643_" + hang_number, fields[22]);
                            fieldidvalue("#field9644_" + hang_number, fields[23]);
                            fieldidvalue("#field9645_" + hang_number, fields[24]);
                            fieldidvalue("#field9646_" + hang_number, fields[25]);
                            fieldidvalue("#field9647_" + hang_number, fields[26]);
                            fieldidvalue("#field9648_" + hang_number, fields[27]);

                            jQuery("#field10002_" + hang_number).val(fields[28]);
                            jQuery("#field10003_" + hang_number).val(fields[29]);
                            jQuery("#field10004_" + hang_number).val(fields[30]);
                            jQuery("#field10005_" + hang_number).val(fields[31]);
                            jQuery("#field10006_" + hang_number).val(fields[32]);
                            //jQuery("#field10007_" + hang_number).val(fields[33]);
                            fieldidvalue("#field10007_" + hang_number, fields[33]);
                            jQuery("#field10008_" + hang_number).val(fields[34]);
                            jQuery("#field10009_" + hang_number).val(fields[35]);
                            jQuery("#field10010_" + hang_number).val(fields[36]);
                            jQuery("#field10011_" + hang_number).val(fields[37]);
                            jQuery("#field10012_" + hang_number).val(fields[38]);
                            jQuery("#field10013_" + hang_number).val(fields[39]);
                            jQuery("#field10014_" + hang_number).val(fields[40]);
                            jQuery("#field10015_" + hang_number).val(fields[41]);
                            jQuery("#field10016_" + hang_number).val(fields[42]);
                            jQuery("#field10017_" + hang_number).val(fields[43]);
                            jQuery("#field10018_" + hang_number).val(fields[44]);
                            jQuery("#field10019_" + hang_number).val(fields[45]);
                            jQuery("#field10020_" + hang_number).val(fields[46]);
                            jQuery("#field10021_" + hang_number).val(fields[47]);
                            jQuery("#field10022_" + hang_number).val(fields[48]);
                            jQuery("#field10023_" + hang_number).val(fields[49]);
                            jQuery("#field10024_" + hang_number).val(fields[50]);
                            jQuery("#field10025_" + hang_number).val(fields[51]);
                            jQuery("#field10026_" + hang_number).val(fields[52]);
                            jQuery("#field10027_" + hang_number).val(fields[53]);
                            jQuery("#field10028_" + hang_number).val(fields[54]);
                            jQuery("#field10029_" + hang_number).val(fields[55]);
                            jQuery("#field10030_" + hang_number).val(fields[56]);
                            jQuery("#field10031_" + hang_number).val(fields[57]);
                            jQuery("#field10032_" + hang_number).val(fields[58]);
                            jQuery("#field12541_" + hang_number).val(fields[59]);
                        }
                    } else {
                        Dialog.alert("Data acquisition failure!");
                    }
                }
            });
        })
    })

    function deleteAll(dtnum) {
        delRowFunmd0(dtnum);
    }

    function fieldidvalue(fieldid, value) {
        jQuery(fieldid).val(value);
        jQuery(fieldid + "span").html(value);
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

    function isnull(jhyzl) {
        jQuery("td>input[id^='field9628_']").each(function() {
            var row = jQuery(this).attr("name").split("_")[1];
            var isval = jQuery(this).val();
            if (isval == null || isval == 0) {
                jhyzl = 1;
            }
        });
        return jhyzl;
    }

    function checkCurrentTimes() {
        var jhyzl = 0;
        jhyzl = isnull(jhyzl);
        if (jhyzl == 1) {
            alert("计划运载量为空或等于0！");
            return false; //阻止提交
        } else {
            return true; //允许提交
        }
    }

    $(document).ready(function() {
        checkCustomize = function() {
            return checkCurrentTimes();
        }
    })
</script>
