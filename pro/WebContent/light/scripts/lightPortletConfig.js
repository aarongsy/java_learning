lightPortletConfig = function(configInfo){
	if(configInfo){
		this.id = configInfo.configId;
		this.portletStyle = new lightPortletStyle(configInfo.portletStyle);
	}else{
		this.id = "-1";
		this.portletStyle = new lightPortletStyle(
			{
				"id": "-1",
				"objname": "default style",
				"description": "default style",
				"windowFontSize": "12px",
				"windowFontFamily": "Verdana, helvetica, arial",	
				"windowBGColor": "",
				"windowTopBorderWidth": 1,
				"windowTopBorderStyle": "solid",	
				"windowTopBorderColor": "#8db2e3",
				"windowRightBorderWidth": 1,
				"windowRightBorderStyle": "solid",
				"windowRightBorderColor": "#8db2e3",	
				"windowBottomBorderWidth": 1,
				"windowBottomBorderStyle": "solid",
				"windowBottomBorderColor": "#8db2e3",
				"windowLeftBorderWidth": 1,
				"windowLeftBorderStyle": "solid",
				"windowLeftBorderColor": "#8db2e3",
				"hasHeader": 1,
				"headerHeight":20,
				"headerBGColor":"#FFFFFF",
				"headerBGImage": "/js/ext/resources/images/default/grid/grid3-hrow.gif",
				"headerBGImageRepeat": "repeat-x",
				"hasHeaderRefreshBtn":1,
				"hasHeaderMinBtn":1,
				"headerRefreshBtnPath":"/light/images/refresh_on.gif",
				"headerMaxBtnPath":"/light/images/max_on.gif",
				"headerMinBtnPath":"/light/images/min_on.gif",
				"hasHeaderMaxBtn":1,
				"headerCornerStyle":1,
				"hasFooter":0,
				"footerHeight":20,
				"footerBGColor":"#FFFFFF",
				"footerBGImage": "",
				"footerBGImageRepeat": "no-repeat",
				"hasFooterMaxBtn":0,
				"footerMaxBtnPath":"/light/images/max_on.gif",
				"footerRefreshBtnPath":"/light/images/refresh_on.gif",
				"hasFooterRefreshBtn":0,
				"footerMinBtnPath":"/light/images/min_on.gif",
				"hasFooterMinBtn":0,
				"footerCornerStyle":1
			}
		);
	}
}