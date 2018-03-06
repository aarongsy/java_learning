function getDataList(paras) {
    util.getData({
        "loadingTarget": document.body,
        "paras": paras,
        "callback": function(data) {
            if (data.error) {
                $("#workflowsignmore").remove()
            } else {
                var pageindex = data.pageindex;
                var pagesize = data.pagesize;
                var count = data.count;
                var ishavepre = data.ishavepre;
                var ishavenext = data.ishavenext
                var pagecount = data.pagecount;
                $("input[name='workflowsignid']").val(pageindex);
                var viewsignHtml = "";
                var currentPageDataCnt = new Date().getTime();
                if (data.logs != undefined && data.logs != null && count != "0") {
                    $.each(data.logs, 
                    function(i, item) {
                        currentPageDataCnt++;
                        var annexDocHtmls = item.annexDocHtmls;
                        var id = item.id;
                        var nodeId = item.nodeId;
                        var nodeName = item.nodeName;
                        var operateDate = item.operateDate;
                        var operateTime = item.operateTime;
                        var operateType = item.operateType;
                        var operatorDept = item.operatorDept;
                        var operatorId = item.operatorId;
                        var operatorName = item.operatorName;
                        var operatorSign = item.operatorSign;
                        var receivedPersons = item.receivedPersons;
                        var remark = item.remark;
                        var remarkSign = item.remarkSign;
                        var signDocHtmls = item.signDocHtmls;
                        var signWorkFlowHtmls = item.signWorkFlowHtmls;
                        var nodeRowName = '节点';
                        var operationRowName = '操作';
                        var receivedRowName = '接收人';
                        var accessoryRowName = '相关附件';
                        var signDocHtmlsRowName = '相关文档';
                        var signWorkFlowHtmlsRowName = '相关流程';
                        viewsignHtml += "<div style=\"width:100%;height:1px;border-top:1px solid #CFD3D8;overflow:hidden;margin-top:5px;\" name=\"moresigninfodiv\"></div>" + "<div style=\"width:100%;\">" + "	<div class=\"signRow\" style=\"font-size:14px;font-weight:bold;color:#000;\">";
                        if (remarkSign != null && remarkSign != undefined) {
                            viewsignHtml += "<div style=\"width:100%;\">" + "    <img src=\"/news/show.do?fileid=" + remarkSign + "\">" + "</div>"
                        } else {
                            viewsignHtml += remark
                        }
                        viewsignHtml += "</div>";
                        if (operatorSign != null && viewsignHtml != undefined) {
                            viewsignHtml += "<div style=\"width:100%;\">" + "<img src=\"/news/show.do?url=" + operatorSign + "\"/>" + "</div>"
                        } else {
                            viewsignHtml += "<div class=\"signRow\">" + operatorDept + "&nbsp;/&nbsp;" + operatorName + "&nbsp;" + operateDate + "&nbsp;" + operateTime + "" + "</div>"
                        }
                        viewsignHtml += "<div class=\"signRow\">" + nodeRowName + ":" + nodeName + "&nbsp;&nbsp;&nbsp;&nbsp;" + operationRowName + ":" + operateType + "</div>" + "<div class=\"signRow\">" + receivedRowName + ":<span onclick=\"showwfsigndetail(this, 'wfsignreceivedp" + currentPageDataCnt + "');\" style=\"font-size:12px;\">" + ((util.isNullOrEmpty(receivedPersons) == false && receivedPersons.length > 15) ? (receivedPersons.substring(0, 15) + "...&nbsp;&nbsp;<span style=\"color: blue;\">显示</span>") : receivedPersons) + "</span><span id=\"wfsignreceivedp" + currentPageDataCnt + "\" style=\"display:none;\">" + receivedPersons + "</span>" + "</div>";
                        if (!util.isNullOrEmpty(signDocHtmls) || !util.isNullOrEmpty(signWorkFlowHtmls) || !util.isNullOrEmpty(annexDocHtmls)) {
                            viewsignHtml += "<br /><div style=\"border-top:1px dashed #AAAAAA;height:1px; overflow:hidden;margin-left:12px;margin-right:12px;\"></div>"
                        }
                        if (!util.isNullOrEmpty(signDocHtmls)) {
                            viewsignHtml += "<div class=\"signRow\">" + signDocHtmlsRowName + ":" + signDocHtmls + "</div>"
                        }
                        if (!util.isNullOrEmpty(signWorkFlowHtmls)) {
                            viewsignHtml += "<div class=\"signRow\">" + signWorkFlowHtmlsRowName + ":" + signWorkFlowHtmls + "</div>"
                        }
                        if (!util.isNullOrEmpty(annexDocHtmls)) {
                            viewsignHtml += "<div class=\"signRow\">" + accessoryRowName + ":" + annexDocHtmls + "</div>"
                        }
                        viewsignHtml += "</div>"
                    })
                }
                $("#cleaboth").remove();
                $("#workflowsignmore").remove();
                if (ishavenext == "1") {
                    var moreRowName = '展开全部';
                    viewsignHtml += "<div id=\"workflowsignmore\" class=\"operationBt\" style=\"font-size:12px;height:20px;line-height:20px;float:right;margin-right:10px;margin-top:10px;\" onclick=\"javascript:doexpand();\"><span id=\"moresigninfotext\">更多</span></div>" + "<div id=\"cleaboth\" style=\"clear:both;\"></div>"
                }
                $("#workflowrequestsignblock").append(viewsignHtml)
            }
        }
    })
}	