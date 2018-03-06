/**!
 * @name AttrUtil for Ecology8 
 *
 * @version v1.1
 *
 * @author TimothyZ
 *
 * @since 2017-12-14
 */
/**@description 用于设置字段只读，编辑，必填,明细表字段未测试
 * @function fieldViewCtrl(fieldid,fieldattr)
 * @param fieldid 元素id，例如field13069 fieldid='13069'
 * @param fieldattr 字段属性操作，-1:只读 0:恢复默认状态 1:必填 2.可编辑
 */
var AttrUtil = function () {
    function appendCheck(fieldid) {
        jQuery("input[name='needcheck']").val(function (i, v) {
            if (v.search(fieldid) == -1)
                return v + ",field" + fieldid;
            return v;
        });
    }

    function removeCheck(fieldid) {
        jQuery("input[name='needcheck']").val(function (i, v) {
            if (v.search(fieldid) != -1)
                return v.replace(",field" + fieldid, "");
            return v;
        });
    }

    /**
     *   2018-01-19 字段字段控制
     *   fieldid : 字段ID
     *   flag : 是否必填,true 只读，flase 编辑或者必填
     *   fieldattr : 字段属性操作，-1:只读 0:恢复默认状态 1:必填 2.可编辑
     */
    function fieldViewCtrl(fieldid, fieldattr) {
        var flag = false;
        if (fieldattr != -1 && fieldattr != 0 && fieldattr != 1 && fieldattr != 2) return Dialog.alert('未能识别的字段属性控制标识符!');
        if (fieldattr == -1) {
            flag = true;
        }
        if (!!flag) {
            //设置为只读
            try {
                //选择框
                var obj = jQuery("#field" + fieldid + "");
                var objTagname = $GetEle("field" + fieldid + "").tagName;
                //名称规则为 field"+fielid+"_readonlytext. 
                var tempid = "field" + fieldid + "_readonlytext";
                var prestr = "<span id='" + tempid + "' style='line-height:30px!important;'>";
                var endstr = "</span>";
                var afterstr = "";
                var iscreate = true;
                try {
                    jQuery("#" + tempid).remove(); //移除显示的span
                    if (jQuery("#" + tempid).length > 0) {
                        removeElement($GetEle(tempid));
                        iscreate = true;
                    }
                } catch (ex) {
                    if (window.console) console.log("removeElement flag=" + flag + "  error : " + ex.message + " span length = " + jQuery("#" + tempid).length);
                }

                //下拉字段
                if (objTagname == "SELECT") {
                    afterstr = obj.find("option:selected").text();
                    if (iscreate) {
                        obj.after(prestr + afterstr + endstr);
                    }
                    obj.hide();
                } else if (objTagname == 'TEXTAREA') {
                    if (obj.length == 0) {
                        obj = jQuery("textarea[name='field" + fieldid + "']");
                    }
                    //编辑器的多行文档
                    if (jQuery("#field" + fieldid).find("iframe").length > 0) {
                        if (!!UE.getEditor('field' + fieldid)) {
                            afterstr = UE.getEditor('field' + fieldid).getContent();
                            UE.getEditor('field' + fieldid).setHide(); //隐藏编辑器框
                        }
                        if (iscreate) {
                            obj.after(prestr + afterstr + endstr);
                        }
                        obj.hide();
                    } else {
                        //不带编辑器的多行文本
                        afterstr = obj.val();
                        if (iscreate) {
                            obj.after(prestr + afterstr + endstr);
                        }
                        obj.hide();
                        try {
                            var height = obj.css("height");
                        } catch (e) {

                        }
                    }
                } else if (objTagname == 'DIV') { //UE编辑把field+fieldid占用了。 通过div在来判断
                    if (!!UE.getEditor('field' + fieldid)) {
                        afterstr = UE.getEditor('field' + fieldid).getContent();
                        UE.getEditor('field' + fieldid).setHide(); //隐藏编辑器框
                        if (iscreate) {
                            obj.after(prestr + afterstr + endstr);
                        }
                        obj.hide();
                    }

                } else if (objTagname == 'INPUT') { //所有input属性的
                    if (obj.length == 0) {
                        obj = jQuery("input[name='field" + fieldid + "']");
                    }
                    if (obj.attr("type") == "text") { //文本类型
                        //表单设计器设置单元格格式
                        var obj_format = jQuery("input[name='field" + fieldid + "_format']");
                        if (obj_format.length > 0) {
                            obj_format.hide();
                            afterstr = obj_format.val();
                        } else {
                            afterstr = obj.val();
                        }
                        if (iscreate) {
                            obj.after(prestr + afterstr + endstr);
                        }
                        obj.hide();
                        //绑定联动事件改变只读对象值，解决可编辑变为只读后，再被计算赋值值不同步问题
                        var _syncUpdateStr = "syncUpdateReadOnlyText(this);";
                        if (jQuery.browser.msie) {
                            var _onpropertychangeStr = obj[0].getAttribute("onpropertychange"); //只能通过原生JS获取不能使用attr
                            if (!!!_onpropertychangeStr) _onpropertychangeStr = "";
                            if (_onpropertychangeStr.indexOf(_syncUpdateStr) == -1)
                                obj[0].setAttribute("onpropertychange", _onpropertychangeStr + ";" + _syncUpdateStr)
                        } else {
                            if (typeof loadListener === 'function') {
                                var _listenerStr = obj.attr("_listener");
                                if (!!!_listenerStr) _listenerStr = "";
                                if (_listenerStr.indexOf(_syncUpdateStr) == -1)
                                    obj.attr("_listener", _listenerStr + ";" + _syncUpdateStr);
                                loadListener();
                            }
                        }
                    } else if (obj.attr("type") == 'checkbox') { //复选框
                        obj.attr("readOnly", "true");
                    } else if (obj.attr("type") == "hidden") { //假定为浏览按钮
                        if (jQuery("#field" + fieldid + "_tab").length > 0) {
                            //金额转换
                            var labelobj = jQuery("#field_lable" + fieldid);
                            afterstr = labelobj.val();
                            if (iscreate) {
                                labelobj.after(prestr + afterstr + endstr);
                            }
                            labelobj.hide();
                            var chinglishobj = jQuery("input[name='field_chinglish" + fieldid + "']");
                            if (chinglishobj.length > 0) { //明细没有这行              
                                afterstr = chinglishobj.val();
                                chinglishobj.after("<span id='field" + fieldid + "_readonlytext_cn'>" + afterstr + "</span>");
                                //金额转换增加一个 _readonlytext_cn
                                chinglishobj.hide();
                            }
                        } else if (jQuery("#field" + fieldid + "_browserbtn").length > 0) {
                            //所有的浏览按钮
                            //文档、人力资源之类的浏览按钮
                            var divobj = jQuery("#field" + fieldid + "_browserbtn").parent().parent().parent().parent();
                            //if(divobj.css("display")!='none'){
                            //不知道为什么选择部门或者分部的时候重复多次调用这个方法，增加是否处理过的判断
                            //var divobj = jQuery("#field"+fieldid+"_browserbtn").parents(".e8_os");
                            afterstr = jQuery("#field" + fieldid + "span").html(); //.filter( ".e8_delClass" );
                            if (iscreate) {
                                divobj.after(prestr + afterstr + endstr);
                            }
                            try {
                                jQuery("#" + tempid + " .e8_delClass").remove();
                            } catch (e) {
                                //alert(e.message);
                            }
                            divobj.hide();
                            //}
                        } else if (jQuery("#_areaselect_field" + fieldid).length > 0) {
                            if (jQuery("#" + fieldid) && jQuery("#" + fieldid).val() != '' && jQuery("#" + fieldid).val() != '0') {
                                var divobj = jQuery("#_areaselect_field" + fieldid);
                                if (jQuery("span[key='" + fieldid + "areawflabel']").length > 0) {
                                    jQuery("span[key='" + fieldid + "areawflabel']").remove();
                                }
                                if (jQuery("#field" + fieldid + "span").length > 0) {
                                    jQuery("#field" + fieldid + "span").attr("name", "field" + fieldid + "span_hide");
                                    jQuery("#field" + fieldid + "span").attr("id", "field" + fieldid + "span_hide");
                                }
                                divobj.parent().find('script').remove();
                                divobj.parent().html(divobj.parent().html() + "<span id='field" + fieldid + "span' key='" + fieldid + "areawflabel' name='field" + fieldid + "span'>" + jQuery("#field" + fieldid + "span_hide").text().replace("x", "") + "</span>");
                                jQuery("#_areaselect_field" + fieldid).hide();
                            } else {
                                var divobj = jQuery("#_areaselect_field" + fieldid);
                                divobj.hide();
                            }
                        } else if (jQuery("#field_lable" + fieldid).length > 0 && jQuery("#field" + fieldid + "_tab").length == 0) { //明细金额转换
                            afterstr = jQuery("#field_lable" + fieldid).val();
                            if (iscreate) {
                                jQuery("#field_lable" + fieldid).after(prestr + afterstr + endstr);
                            }
                            jQuery("#field_lable" + fieldid).hide();
                        } else {
                            //日期和时间按钮
                            if (obj.siblings(".calendar").length > 0) {
                                obj.siblings(".calendar").hide()
                            }

                            if (obj.siblings(".Clock").length > 0) {
                                obj.siblings(".Clock").hide()
                            }
                            //明细的日期和时间
                            if (jQuery("#field" + fieldid + "browser").length > 0) {
                                jQuery("#field" + fieldid + "browser").hide();
                            }

                            if (jQuery("#field" + fieldid + "spanimg").length > 0) {
                                jQuery("#field" + fieldid + "spanimg").html("");
                            }
                            if (jQuery("#field_lable" + fieldid + "span").length > 0) {
                                jQuery("#field_lable" + fieldid + "span").html("");
                            }
                        }
                    }
                }
                //处理感叹号
                if (jQuery("#field" + fieldid + "spanimg").length > 0) {
                    jQuery("#field" + fieldid + "spanimg").html("");
                }
                if (jQuery("#field" + fieldid + "span").length > 0 && jQuery("#field" + fieldid + "spanimg").length < 1) {
                    if (jQuery("#field" + fieldid + "span").html().indexOf("BacoError_wev8") != -1) {
                        jQuery("#field" + fieldid + "span").html("");
                    }
                }
                jQuery("#field" + fieldid + "").attr("viewtype", "0");
                jQuery("#field_lable" + fieldid + "").attr("viewtype", "0");
                if (window.console) console.log("fieldid = " + fieldid + " isedit=" + jQuery("#field_lable" + fieldid + "").attr("viewtype"));
                removeCheck(fieldid);
            } catch (e) {
                //if(window.console) console.log("显示属性联动设置异常（"+flag+"）："+e.message);
            }
        } else {
            //设置编辑或者必填
            try {
                //选择框
                var obj = jQuery("#field" + fieldid + "");
                var objTagname = $GetEle("field" + fieldid + "").tagName;
                //名称规则为 field"+fielid+"_readonlytext. 
                var hideid = "field" + fieldid + "_readonlytext";
                var tempvalue = "";
                jQuery("#" + hideid).remove(); //移除显示的span
                if (jQuery("#" + hideid).length > 0) {
                    removeElement($GetEle(hideid));
                }
                //if(window.console) console.log("fieldid = "+fieldid+" objTagname="+objTagname+" type = "+obj.attr("type")+" fieldattr="+fieldattr);
                //下拉字段
                if (objTagname == "SELECT") {
                    obj.show();
                    tempvalue = obj.val();
                } else if (objTagname == 'TEXTAREA') {
                    if (obj.length == 0) {
                        obj = jQuery("textarea[name='field" + fieldid + "']");
                    }
                    obj.show();
                    tempvalue = jQuery("textarea[name='field" + fieldid + "']").val();
                } else if (objTagname == 'DIV') { //UE编辑把field+fieldid占用了。 通过div在来判断
                    try {
                        if (jQuery("textarea[name='field" + fieldid + "']")) {
                            if (!!UE.getEditor('field' + fieldid)) {
                                UE.getEditor('field' + fieldid).setShow(); //显示编辑器框
                                jQuery("textarea[name='field" + fieldid + "']").val(UE.getEditor('field' + fieldid).getContent());
                                tempvalue = jQuery("textarea[name='field" + fieldid + "']").val();
                            }
                        }
                        obj.show();
                    } catch (et) {
                        if (window.console) console.log("et error :: " + et.message);
                    }
                } else if (objTagname == 'INPUT') { //所有input属性的
                    if (obj.length == 0) {
                        obj = jQuery("input[name='field" + fieldid + "']");
                    }
                    if (obj.attr("type") == "text") { //文本类型
                        if (jQuery("#field_lable" + fieldid).length > 0) {
                            jQuery("#field_lable" + fieldid).show();
                            tempvalue = jQuery("#field_lable" + fieldid).val();
                        } else {
                            //表单设计器设置单元格格式
                            var obj_format = jQuery("input[name='field" + fieldid + "_format']");
                            if (obj_format.length > 0) {
                                obj_format.show();
                                obj.hide();
                            } else {
                                obj.show();
                            }
                            tempvalue = obj.val();
                        }
                    } else if (obj.attr("type") == 'checkbox') { //复选框
                        obj.removeAttr("readOnly");
                        if (obj.attr("checked") || obj.attr("checked") == 'true') {
                            tempvalue = "1";
                        }
                        if (fieldattr == 2) {
                            return;
                        }
                    } else if (obj.attr("type") == "hidden") { //假定为浏览按钮
                        if (jQuery("#field" + fieldid + "_tab").length > 0) {
                            //金额转换
                            var labelobj = jQuery("#field_lable" + fieldid);
                            labelobj.show();
                            var chinglishobj = jQuery("input[name='field_chinglish" + fieldid + "']");
                            if (chinglishobj.length > 0) { //明细没有这个
                                //金额转换增加一个 _readonlytext_cn  这里要清除
                                jQuery("#field" + fieldid + "_readonlytext_cn").remove();
                                chinglishobj.show();
                                tempvalue = labelobj.val();
                            }

                        } else if (jQuery("#field" + fieldid + "_browserbtn").length > 0) {
                            //所有的浏览按钮
                            //文档、人力资源之类的浏览按钮
                            var divobj = jQuery("#field" + fieldid + "_browserbtn").parent().parent().parent().parent();
                            //if(divobj.css("display")=='none'){
                            //不知道为什么选择部门或者分部的时候重复多次调用这个方法，增加是否处理过的判断
                            //var divobj = jQuery("#field"+fieldid+"_browserbtn").parents(".e8_os");
                            divobj.show();
                            tempvalue = obj.val();
                            //}
                        } else if (jQuery("#_areaselect_field" + fieldid).length > 0) {

                            var divobj = jQuery("#_areaselect_field" + fieldid);
                            divobj.show();
                            tempvalue = obj.val();
                            if (jQuery("#field" + fieldid + "span_hide").length > 0) {
                                if (jQuery("span[key='" + fieldid + "areawflabel']").length > 0) {
                                    jQuery("span[key='" + fieldid + "areawflabel']").remove();
                                }
                                jQuery("#field" + fieldid + "span_hide").attr("name", "field" + fieldid + "span");
                                jQuery("#field" + fieldid + "span_hide").attr("id", "field" + fieldid + "span");
                            }
                        } else if (jQuery("#field_lable" + fieldid).length > 0 && jQuery("#field" + fieldid + "_tab").length == 0) { //明细金额转换
                            jQuery("#field_lable" + fieldid).show();
                            tempvalue = jQuery("#field_lable" + fieldid).val();
                            if (fieldattr == 1) {
                                jQuery("#field" + fieldid + "").attr("viewtype", "0");
                                jQuery("#field_lable" + fieldid + "").attr("viewtype", "0");
                            }
                        } else {
                            //日期和时间按钮
                            if (obj.siblings(".calendar").length > 0) {
                                obj.siblings(".calendar").show()
                            }
                            if (obj.siblings(".Clock").length > 0) {
                                obj.siblings(".Clock").show()
                            }
                            //明细的日期和时间
                            if (jQuery("#field" + fieldid + "browser").length > 0) {
                                jQuery("#field" + fieldid + "browser").show();
                            }
                            tempvalue = obj.val();
                        }
                    }
                }

                if (jQuery("#field" + fieldid + "wrapspan").length > 0) {
                    var c = 0;
                    while (c < 10) {
                        if (jQuery("#field" + fieldid + "spanimg").length == 0) {
                            sleep(200);
                            //if(window.console) console.log("field = "+fieldid+" 没检测到spanimg "+$GetEle("#field"+fieldid+"__")+"//"+$GetEle("#field"+fieldid+"_browserbtn"));
                            //if(window.console) console.log("field = "+fieldid+" 没检测到spanimg html = "+jQuery("#field"+fieldid+"wrapspan").html());
                        } else {
                            break;
                        }
                        c++;
                    }
                }
                if (fieldattr == 1) { //必填的时候增加必填标识
                    jQuery("#field" + fieldid + "").attr("viewtype", "1");
                    jQuery("#field_lable" + fieldid + "").attr("viewtype", "1");
                    jQuery("textarea[name='field" + fieldid + "']").attr("viewtype", "1");

                    if (tempvalue == '') {
                        if (jQuery("#field" + fieldid + "__").length > 0) {
                            jQuery("#field" + fieldid + "spanimg").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
                            jQuery("#field" + fieldid + "span").html("");
                        } else {
                            if (jQuery("#field_lable" + fieldid + "span").length > 0) {
                                jQuery("#field_lable" + fieldid + "span").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
                                jQuery("#field" + fieldid + "spanimg").html("");
                            } else {
                                jQuery("#field" + fieldid + "span").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
                                jQuery("#field" + fieldid + "spanimg").html("");
                            }
                        }
                    }
                    appendCheck(fieldid);
                } else if (fieldattr == 2) {
                    //处理感叹号
                    if (jQuery("#field" + fieldid + "spanimg").length > 0) {
                        jQuery("#field" + fieldid + "spanimg").html("");
                    }
                    if (jQuery("#field" + fieldid + "span").length > 0 && jQuery("#field" + fieldid + "spanimg").length < 1) {
                        if (jQuery("#field" + fieldid + "span").html().indexOf("BacoError_wev8") != -1) {
                            jQuery("#field" + fieldid + "span").html("");
                        }
                    }
                    jQuery("#field" + fieldid + "").attr("viewtype", "0");
                    jQuery("#field_lable" + fieldid + "").attr("viewtype", "0");
                    if (window.console) console.log("fieldid = " + fieldid + " isedit=" + jQuery("#field_lable" + fieldid + "").attr("viewtype"));
                    removeCheck(fieldid);
                } else if (fieldattr == 0) {
                    //oldfieldview54702_0
                    var isedit = jQuery("input[name='oldfieldview" + fieldid + "']").val();
                    //if(window.console) console.log("fieldid = "+fieldid+" isedit="+isedit);
                    if (isedit > 2) {
                        jQuery("#field" + fieldid + "").attr("viewtype", "1");
                        jQuery("#field_lable" + fieldid + "").attr("viewtype", "1");
                        jQuery("textarea[name='field" + fieldid + "']").attr("viewtype", "1");
                        if (tempvalue == '') {
                            if (jQuery("#field" + fieldid + "__").length > 0) {
                                jQuery("#field" + fieldid + "spanimg").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
                                jQuery("#field" + fieldid + "span").html("");
                            } else {
                                if (jQuery("#field_lable" + fieldid + "span").length > 0) {
                                    jQuery("#field_lable" + fieldid + "span").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
                                    jQuery("#field" + fieldid + "spanimg").html("");
                                } else {
                                    jQuery("#field" + fieldid + "span").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
                                    jQuery("#field" + fieldid + "spanimg").html("");
                                }
                            }
                        }
                        appendCheck(fieldid);
                    } else {
                        jQuery("#field" + fieldid + "").attr("viewtype", "0");
                        jQuery("#field_lable" + fieldid + "").attr("viewtype", "0");
                        jQuery("textarea[name='field" + fieldid + "']").attr("viewtype", "0");
                        if (jQuery("#field" + fieldid + "span").html().indexOf("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>") != -1) {
                            jQuery("#field" + fieldid + "span").html("");
                        }
                        removeCheck(fieldid);
                    }
                }
            } catch (e) {
                //if(window.console) console.log("显示属性联动设置异常（"+flag+"）："+e.message);
            }
        }
    }

    return {
        fieldViewCtrl: fieldViewCtrl
    }
}();