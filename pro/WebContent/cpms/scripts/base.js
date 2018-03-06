var win;
function getrefobj(inputname, inputspan, refid, param, viewurl, isneed) {
	if (document.getElementById(inputname.replace("field", "input")) != null)
		document.getElementById(inputname.replace("field", "input")).value = "";
	var fck = param.indexOf("function:");
	if (fck > -1) {
	} else {
		var param = parserRefParam(inputname, param);
	}
	var idsin = document.getElementsByName(inputname)[0].value;
	var id;
	if (Ext.isIE) {
		try {
			var url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin
			if (idsin.length > 900) { //当idsin过长时，ie的url不支持过长的地址
				url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param;
			}
			id = openDialog(url);
		} catch (e) {
			return
		}
		if (id != null) {
			if (id[0] != '0') {
				document.all(inputname).value = id[0];
				document.all(inputspan).innerHTML = id[1];
				if (fck > -1) {
					funcname = param.substring(9);
					scripts = "valid=" + funcname + "('" + id[0] + "');";
					eval(scripts);
					if (!valid) { //valid默认的返回true;
						document.all(inputname).value = '';
						if (isneed == '0')
							document.all(inputspan).innerHTML = '';
						else
							document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
					}
				}
			} else {
				document.all(inputname).value = '';
				if (isneed == '0')
					document.all(inputspan).innerHTML = '';
				else
					document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

			}
		}
	} else {
		url = '/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;

		var callback = function() {
			try {
				id = dialog.getFrameWindow().dialogValue;
			} catch (e) {
			}
			if (id != null) {
				if (id[0] != '0') {
					document.all(inputname).value = id[0];
					document.all(inputspan).innerHTML = id[1];
					if (fck > -1) {
						funcname = param.substring(9);
						scripts = "valid=" + funcname + "('" + id[0] + "');";
						eval(scripts);
						if (!valid) { //valid默认的返回true;
							document.all(inputname).value = '';
							if (isneed == '0')
								document.all(inputspan).innerHTML = '';
							else
								document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
						}
					}
				} else {
					document.all(inputname).value = '';
					if (isneed == '0')
						document.all(inputspan).innerHTML = '';
					else
						document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

				}
			}
		}
		if (!win) {
			win = new Ext.Window( {
			layout : 'border',
			width : Ext.getBody().getWidth() * 0.8,
			height : Ext.getBody().getHeight() * 0.8,
			plain : true,
			modal : true,
			items : {
			id : 'dialog',
			region : 'center',
			iconCls : 'portalIcon',
			xtype : 'iframepanel',
			frameConfig : {
			autoCreate : {
			id : 'portal',
			name : 'portal',
			frameborder : 0
			},
			eventsFollowFrameLinks : false
			},
			closable : false,
			autoScroll : true
			}
			});
		}
		win.close = function() {
			this.hide();
			win.getComponent('dialog').setSrc('about:blank');
			callback();
		};
		win.render(Ext.getBody());
		var dialog = win.getComponent('dialog');
		dialog.setSrc(url);
		win.show();
	}
}