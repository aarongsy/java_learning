WeaverUtil.isDebug = false;
var RssReadPortlet={
	doSubmit:function(a,c){
		var b = Light.getPortletById(c);
		var cnlabelname = a.form.reportLabel.value;
        var col1 = a.form.col1.value;
        if(col1 == ''){
        	b.title = cnlabelname;
        	submitForm();
        }else{
	        Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
				method : 'post',
				params:{   
					keyword : col1,
					cnlabelname : cnlabelname
				}, 
				success: function (response)    
		        {   
		        	b.title = response.responseText;
		        	submitForm();
		        },
			 	failure: function(response,opts) {    
				 	alert('Error', response.responseText);   
				 	submitForm();
				}  
			}); 
		}
		function submitForm(){
			document.currentForm=a.form;
			document.pressed="add";
			document.mode="view";
			a.form.submit();
		}
		return true
	},
	changeViewType:function(b){}
};
var ReportPortlet = {
    addOption: function(e) {
        var d = e.options[e.selectedIndex];
        var b = true;
        var c = Ext.get("myFields").dom.options;
        Ext.each(c,
        function(g) {
            if (g.value != d.value) {} else {
                b = false;
                return false
            }
        });
        if (b) {
            var a = document.createElement("option");
            a.value = d.value;
            a.text = d.text;
            a.title = d.text;
            Ext.get("myFields").dom.options.add(a);
            var f = a.cloneNode();
            f.value = "20%";
            f.text = "20%";
            f.title = "20%";
            Ext.get("myFieldsWidth").dom.options.add(f)
        }
    },
    delOption: function(b) {
        if (typeof(b.selectedIndex) == "undefined" || b.options.length <= 0) {
            return
        }
        var a = b.selectedIndex;
        b.options.remove(a);
        if (Ext.get("myFieldsWidth").dom.options.length > 0) {
            Ext.get("myFieldsWidth").dom.options.remove(a)
        }
    },
    changeWidth: function(b) {
        if (typeof(b.selectedIndex) == "undefined" || b.options.length <= 0) {
            return
        }
        var a = b.options[b.selectedIndex];
        var c = a.value;
        c = prompt("填写字段宽度，数字或百分比:", "修改字段列显示宽度", c);
        if (c) {
            a.value = c;
            a.text = c
        }
    },
    doSubmit: function(d, f) {
        var e = Light.getPortletById(f);
        var cnlabelname = d.form.reportLabel.value;
        var col1 = d.form.col1.value;
        if(col1 == ''){
        	e.title = cnlabelname;
        	submitForm();
        }else{
	        Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
				method : 'post',
				params:{   
					keyword : col1,
					cnlabelname : cnlabelname
				}, 
				success: function (response)    
		        {   
		        	e.title = response.responseText;
		        	submitForm();
		        },
			 	failure: function(response,opts) {    
				 	alert('Error', response.responseText);   
				 	submitForm();
				}  
			}); 
		}
		function submitForm(){
			document.currentForm = d.form;
	        document.pressed = "add";
	        document.mode = "view";
	        d.form.myFields.multiple = true;
	        d.form.myFieldsWidth.multiple = true;
	        var b = d.form.myFields.options;
	        for (var a = 0; a < b.length; a++) {
	            b[a].selected = true
	        }
	        var c = d.form.myFieldsWidth.options;
	        for (var a = 0; a < c.length; a++) {
	            c[a].selected = true
	        }
	        d.form.submit();
		}
        return true
    },
    getReportFields: function(b) {
        var a = b.options[b.selectedIndex].value;
        RemotePortal.getFieldsByReportId(a,
        function(e) {
            //DWRUtil.removeAllOptions("reportFields");
            //DWRUtil.removeAllOptions("myFields");
        	Ext.get("reportFields").dom.options.length = 0;
        	Ext.get("myFields").dom.options.length = 0;
        	Ext.get("myFieldsWidth").dom.options.length = 0;
            var d = Ext.get("reportFields").dom.options;
            var c = null;
            for (var f in e) {
                if (f.indexOf("JSON") > 0) {
                    continue
                }
                c = document.createElement("option");
                c.value = f;
                c.text = e[f] + "-" + f;
                d.add(c)
            }
        })
    },
    sortField: function(c) {
        var f = Ext.get("myFields").dom;
        var b = Ext.get("myFieldsWidth").dom;
        var a = f.selectedIndex;
        if (typeof(a) == "undefined") {
            return
        }
        var d = f.options;
        var e = b.options;
        if (a + c >= 0 && d[a + c] && d[a]) {
            d[a + c].swapNode(d[a]);
            if ((a + c) <= e.length) {
                e[a + c].swapNode(e[a])
            }
        }
    }
};
var DocbasePortlet = {
    doSubmit: function(a, c) {
        var b = Light.getPortletById(c);
        var cnlabelname = a.form.reportLabel.value;
        var col1 = a.form.col1.value;
        if(col1 == ''){
        	b.title = cnlabelname;
        	submitForm();
        }else{
	        Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
				method : 'post',
				params:{   
					keyword : col1,
					cnlabelname : cnlabelname
				}, 
				success: function (response)    
		        {   
		        	b.title = response.responseText;
		        	submitForm();
		        },
			 	failure: function(response,opts) {    
				 	alert('Error', response.responseText);   
				 	submitForm();
				}  
			}); 
		}
		function submitForm(){
			document.currentForm = a.form;
	        document.pressed = "add";
	        document.mode = "view";
	        a.form.submit();
		}
        return true
    },
    changeViewType: function(b) {
        var a = b.options[b.selectedIndex].value;
        if (a == "1") {
            Ext.get("abstractLengthSpan").enableDisplayMode().hide();
            Ext.get("imgWidthSpan").enableDisplayMode().hide();
            document.getElementById('GraBpic').checked = false;
            Ext.get("grabpicspan").enableDisplayMode().hide();
        } else {
            Ext.get("abstractLengthSpan").enableDisplayMode().show();
            Ext.get("imgWidthSpan").enableDisplayMode().show();
            if(a == "4"){
        		Ext.get("grabpicspan").enableDisplayMode().show();
        	}else{
        		document.getElementById('GraBpic').checked = false;
        		Ext.get("grabpicspan").enableDisplayMode().hide();
        	}
        }
    }
};
var SlidePortlet = {
    doSubmit: function(a, c) {
        var b = Light.getPortletById(c);
        var cnlabelname = a.form.reportLabel.value;
        var col1 = a.form.col1.value;
        if(col1 == ''){
        	b.title = cnlabelname;
        	submitForm();
        }else{
	        Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
				method : 'post',
				params:{   
					keyword : col1,
					cnlabelname : cnlabelname
				}, 
				success: function (response)    
		        {   
		        	b.title = response.responseText;
		        	submitForm();
		        },
			 	failure: function(response,opts) {    
				 	alert('Error', response.responseText);   
				 	submitForm();
				}  
			}); 
		}
		function submitForm(){
			document.currentForm = a.form;
	        document.pressed = "add";
	        document.mode = "view";
	        a.form.submit();
		}
        return true
    }
};
var ShortcutPortlet = {
    doSubmit: function(a, c) {
        var b = Light.getPortletById(c);
        var cnlabelname = a.form.reportLabel.value;
        var col1 = a.form.col1.value;
        if(col1 == ''){
        	b.title = cnlabelname;
        	submitForm();
        }else{
	        Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
				method : 'post',
				params:{   
					keyword : col1,
					cnlabelname : cnlabelname
				}, 
				success: function (response)    
		        {   
		        	b.title = response.responseText;
		        	submitForm();
		        },
			 	failure: function(response,opts) {    
				 	alert('Error', response.responseText);   
				 	submitForm();
				}  
			}); 
		}
		function submitForm(){
			document.currentForm = a.form;
	        document.pressed = "add";
	        document.mode = "view";
	        a.form.submit();
		}
        return true
    }
};
var TodoWorkflowPortlet = {
    doSubmit: function(a, c) {
        var b = Light.getPortletById(c);
        var cnlabelname = a.form.title.value;
        var col1 = a.form.col1.value;
        if(col1 == ''){
        	b.title = cnlabelname;
        	submitForm();
        }else{
	        Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
				method : 'post',
				params:{   
					keyword : col1,
					cnlabelname : cnlabelname
				}, 
				success: function (response)    
		        {   
		        	b.title = response.responseText;
		        	submitForm();
		        },
			 	failure: function(response,opts) {    
				 	alert('Error', response.responseText);   
				 	submitForm();
				}  
			}); 
		}
		function submitForm(){
			document.currentForm = a.form;
	        document.pressed = "add";
	        document.mode = "view";
	        a.form.submit();
		}
        return true
    },
    changeWidth: function(a) {
        ReportPortlet.changeWidth(a)
    },
    refresh: function() {
        if (typeof(Light) == "undefined" || typeof(Light.portal) == "undefined") {
            return
        }
        var b = Light.portal.GetFocusedTabId();
        if (typeof(b) == "undefined") {
            return
        }
        var a = b.substring(8, b.length);
        var f = Light.portal.tabs[a].portlets;
        var d = f.length;
        var e = null;
        for (var c = 0; c < d; c++) {
            e = f[c];
            for (var g = 0; g < e.length; g++) {
                if (e[g].requestUrl.endsWith("todoWorkflowPortlet.lp")) {
                    e[g].refresh()
                }
            }
        }
    }
};
var MailPortlet = {
    edit: function(b) {
        if (Ext.isEmpty(b)) {
            return
        }
        var a = Light.getPortletById(b);
        if (Ext.isEmpty(a)) {
            return
        }
        a.edit()
    },
    doSubmit: function(a,c) {
    	var b = Light.getPortletById(c);
        var cnlabelname = a.form.title.value;
        var col1 = a.form.col1.value;
        if(col1 == ''){
        	b.title = cnlabelname;
        	submitForm();
        }else{
	        Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
				method : 'post',
				params:{   
					keyword : col1,
					cnlabelname : cnlabelname
				}, 
				success: function (response)    
		        {   
		        	b.title = response.responseText;
		        	submitForm();
		        },
			 	failure: function(response,opts) {    
				 	alert('Error', response.responseText);   
				 	submitForm();
				}  
			}); 
		}
		function submitForm(){
			document.currentForm = a.form;
	        document.pressed = "add";
	        document.mode = "view";
	        a.form.submit();
		}
        return true
    },
    openClient: function() {
        try {
            var b = new ActiveXObject("wscript.shell");
            if (!Ext.isEmpty(this._client)) {
                b.run("" + this._client)
            }
        } catch(a) {
            alert("Error:" + a.description)
        }
    },
    _client: null,
    timerId: null,
    _letId: null,
    refreshMail: function(b, c, d, a) {
        this._letId = b;
        this.optId = c;
        this._client = a;
        if (!Ext.isEmpty(this.timerId)) {
            window.clearInterval(this.timerId)
        }
        this.timerId = window.setInterval("MailPortlet.getEmail();", d * 1000 * 60)
    },
    optId: null,
    rePosition: function(b) {
        if (typeof(b) == "undefined") {
            b = MailPortlet._letId
        }
        var a = Light.portal.GetFocusedTabId();
        var d = a.substring(8, a.length);
        var c = Light.getPortletById(b);
        if (c) {
            Light.portal.tabs[d].rePositionPortlets(c)
        }
    },
    getEmail: function() {
        if (Ext.isEmpty(Ext.getDom("mailList"))) {
            return
        }
        GetemailsService.getEamilNew(this.optId,
        function(a) {
            //DWRUtil.removeAllOptions("mailList");
        	jQuery("#mailList li").remove();
            if (Ext.isEmpty(a) || !Ext.isArray(a)) {
                Ext.DomHelper.append("mailList", {
                    tag: "li",
                    html: "获取邮件错误!"
                });
                return
            }
            Ext.DomHelper.append("mailList", {
                tag: "li",
                html: '共有邮件(<span style="color:red">' + a.length + "</span>)封!"
            });
            for (var b = 0; b < a.length; b++) {
                if (Ext.isEmpty(a[b])) {
                    a[b] = "untitle"
                }
                Ext.DomHelper.append("mailList", {
                    tag: "li",
                    html: (b + 1) + '、<a href="javascript:;" onclick="MailPortlet.openClient();">' + a[b] + "</a>"
                })
            }
            MailPortlet.rePosition()
        })
    }
};
var TemplatePortlet = {
    doSubmit: function(a, c) {
        var b = Light.getPortletById(c);
        var f = document.getElementById("templatePortletForm_" + c);
        var cnlabelname = f.title.value;
        var col1 = f.col1.value;
        if(col1 == ''){
        	b.title = cnlabelname;
        	submitForm();
        }else{
	        Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
				method : 'post',
				params:{   
					keyword : col1,
					cnlabelname : cnlabelname
				}, 
				success: function (response)    
		        {   
		        	b.title = response.responseText;
		        	submitForm();
		        },
			 	failure: function(response,opts) {    
				 	alert('Error', response.responseText);   
				 	submitForm();
				}  
			}); 
		}
        function submitForm(){
	        document.currentForm = f;
	        document.pressed = "add";
	        document.mode = "view";
	        f.submit();
        }
        return true
    }
};

var TabPortlet = {
	doSubmit: function(a, c) {
        var b = Light.getPortletById(c);
        var cnlabelname = a.form.title.value;
        var col1 = a.form.col1.value;
        if(col1 == ''){
        	b.title = cnlabelname;
        	submitForm();
        }else{
	        Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
				method : 'post',
				params:{   
					keyword : col1,
					cnlabelname : cnlabelname
				}, 
				success: function (response)    
		        {   
		        	b.title = response.responseText;
		        	submitForm();
		        },
			 	failure: function(response,opts) {    
				 	alert('Error', response.responseText);   
				 	submitForm();
				}  
			}); 
		}
		function submitForm(){
	        document.currentForm = a.form;
	        document.pressed = "add";
	        document.mode = "view";
	        a.form.submit();
        }
        return true;
    },
    refreshRequestTab: function() {
        if (typeof(Light) == "undefined" || typeof(Light.portal) == "undefined") {
            return
        }
        var b = Light.portal.GetFocusedTabId();
        if (typeof(b) == "undefined") {
            return
        }
        var a = b.substring(8, b.length);
        var f = Light.portal.tabs[a].portlets;
        var d = f.length;
        var e = null;
        for (var c = 0; c < d; c++) {
            e = f[c];
            for (var g = 0; g < e.length; g++) {
                if (e[g].requestUrl.endsWith("tabPortlet.lp")) {
                	if(e[g].window.container.innerHTML.indexOf('rqstListContainer')!=-1){//TODO
                    	e[g].refresh()
                    }
                }
            }
        }
    }
};

var Portlet = {
    getBrowser: function(c, d, f, g, elementid) {
		//重新替换url中的selected
		var url = c;
		var start = url.indexOf("&selected=");
		if(elementid&&start!=-1){
			var element = document.getElementById(elementid);
			if(element){
				var val = element.value;
				var substr = url.substring(start+"&selected=".length);
				var laststr = "";
				var subindex = substr.indexOf("&");
				if(subindex!=-1){//后还有参数
					laststr = substr.substring(subindex);
				}
				url = url.substring(0,start)+"&selected="+val+laststr;
			}
		}
        var b = 0;
        var e = window.showModalDialog(contextPath + "/base/popupmain.jsp?url=" + encodeURIComponent(url),"","dialogHeight:450px;dialogWidth:800px;status:no;center:yes;resizable:yes");
        var a = false;
        if (typeof(g) == "undefined") {
            a = false
        } else {
            if (typeof(g) == "string") {
                a = (g == "0" || g.toLowerCase() == "y" || g.toLowerCase() == "f") ? false: true
            } else {
                if (typeof(g) == "number") {
                    a = (g == 0) ? false: true
                } else {
                    if (typeof(g) == "boolean") {
                        a = g
                    }
                }
            }
        }
        if (typeof(e) != "undefined") {
            if (e[0] != "0") {
                Ext.get(d).dom.value = e[0];
                Ext.get(f).dom.innerHTML = e[1]
            } else {
                Ext.get(d).dom.value = "";
                Ext.get(f).dom.innerHTML = (a) ? "<img src=/images/checkinput.gif>": ""
            }
        } else {
            b = -1
        }
        return b
    },
    rePosition: function(b) {
        var a = Light.portal.GetFocusedTabId();
        var d = a.substring(8, a.length);
        var c = Light.getPortletById(b);
        if (c) {
            Light.portal.tabs[d].rePositionPortlets(c)
        }
    }
};

var ExternalNetwork = {
	doSubmit: function(a, c) {
        var b = Light.getPortletById(c);
        var cnlabelname = a.form.title.value;
        var col1 = a.form.col1.value;
        if(col1 == ''){
        	b.title = cnlabelname;
        	submitForm();
        }else{
	        Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
				method : 'post',
				params:{   
					keyword : col1,
					cnlabelname : cnlabelname
				}, 
				success: function (response)    
		        {   
		        	b.title = response.responseText;
		        	submitForm();
		        },
			 	failure: function(response,opts) {    
				 	alert('Error', response.responseText);   
				 	submitForm();
				}  
			}); 
		}
		function submitForm(){
			document.pressed='save';
	        document.mode='view';
	        document.resetLastAction='1';
	        a.form.submit();
		}
        return true;
    }
};

var ChartPortlet = {
	doSubmit: function(a, c) {
        var b = Light.getPortletById(c);
        var cnlabelname = a.form.title.value;
        var col1 = a.form.col1.value;
        if(col1 == ''){
        	b.title = cnlabelname;
        	submitForm();
        }else{
	        Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
				method : 'post',
				params:{   
					keyword : col1,
					cnlabelname : cnlabelname
				}, 
				success: function (response)    
		        {   
		        	b.title = response.responseText;
		        	submitForm();
		        },
			 	failure: function(response,opts) {    
				 	alert('Error', response.responseText);   
				 	submitForm();
				}  
			}); 
		}
		function submitForm(){
			document.pressed='add';
	        document.mode='view';
	        a.form.submit();
		}
        return true;
    }
};

var GaugePortlet = {
	doSubmit: function(a, c) {
        var b = Light.getPortletById(c);
        var cnlabelname = a.form.title.value;
        var col1 = a.form.col1.value;
        if(col1 == ''){
        	b.title = cnlabelname;
        	submitForm();
        }else{
	        Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
				method : 'post',
				params:{   
					keyword : col1,
					cnlabelname : cnlabelname
				}, 
				success: function (response)    
		        {   
		        	b.title = response.responseText;
		        	submitForm();
		        },
			 	failure: function(response,opts) {    
				 	alert('Error', response.responseText);   
				 	submitForm();
				}  
			}); 
		}
		function submitForm(){
			document.pressed='add';
	        document.mode='view';
	        jQuery(a.form).find(":input").each(function(){
	        	if((this.type == "text" || this.type == "hidden" || this.tagName == 'TEXTAREA') && this.value == ""){
	        		this.value = "null";
	        	}
	        });
	        a.form.submit();
		}
        return true;
    }
};


//协作区
var PortletCowork = {
	doSubmit: function(a, c) {
        var b = Light.getPortletById(c);
        b.title =  a.form.reportLabel.value;
        document.currentForm = a.form;
        document.pressed = "add";
        document.mode = "view";
        a.form.submit();
        return true;
    },
    refreshRequestTab: function() {
        if (typeof(Light) == "undefined" || typeof(Light.portal) == "undefined") {
            return
        }
        var b = Light.portal.GetFocusedTabId();
        if (typeof(b) == "undefined") {
            return
        }
        var a = b.substring(8, b.length);
        var f = Light.portal.tabs[a].portlets;
        var d = f.length;
        var e = null;
        for (var c = 0; c < d; c++) {
            e = f[c];
            for (var g = 0; g < e.length; g++) {
                if (e[g].requestUrl.endsWith("portletCowork.lp")) {
                	if(e[g].window.container.innerHTML.indexOf('rqstListContainer')!=-1){//TODO
                    	e[g].refresh()
                    }
                }
            }
        }
    }
};
