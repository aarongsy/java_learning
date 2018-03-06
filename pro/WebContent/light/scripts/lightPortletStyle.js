lightPortletStyle = function(styleInfo){
	this.id = styleInfo.id;
	this.objname = styleInfo.objname;									//样式名称
	this.description = styleInfo.description;							//样式描述
	this.windowFontSize = styleInfo.windowFontSize;						//窗体中字体大小
	this.windowFontFamily = styleInfo.windowFontFamily;					//窗体字体
	this.windowBGColor = styleInfo.windowBGColor;						//窗体背景颜色
	this.windowTopBorderWidth = styleInfo.windowTopBorderWidth;			//窗体上边框宽度(单位px)
	this.windowTopBorderStyle = styleInfo.windowTopBorderStyle;			//窗体上边框样式
	this.windowTopBorderColor = styleInfo.windowTopBorderColor;			//窗体上边框颜色
	this.windowRightBorderWidth = styleInfo.windowRightBorderWidth;		//窗体右边框宽度(单位px)
	this.windowRightBorderStyle = styleInfo.windowRightBorderStyle;		//窗体右边框样式
	this.windowRightBorderColor = styleInfo.windowRightBorderColor;		//窗体右边框颜色
	this.windowBottomBorderWidth = styleInfo.windowBottomBorderWidth;	//窗体下边框宽度(单位px)
	this.windowBottomBorderStyle = styleInfo.windowBottomBorderStyle;	//窗体下边框样式
	this.windowBottomBorderColor = styleInfo.windowBottomBorderColor;	//窗体下边框颜色
	this.windowLeftBorderWidth = styleInfo.windowLeftBorderWidth;	//窗体左边框宽度(单位px)
	this.windowLeftBorderStyle = styleInfo.windowLeftBorderStyle;	//窗体左边框样式
	this.windowLeftBorderColor = styleInfo.windowLeftBorderColor;	//窗体左边框颜色
	this.hasHeader = (styleInfo.hasHeader == 1);					//是否显示标题栏(true 为显示 false为隐藏)
	this.headerHeight = styleInfo.headerHeight;						//标题栏高度(单位 px)
	this.headerBGColor = styleInfo.headerBGColor;					//标题栏背景颜色
	this.headerBGImage = styleInfo.headerBGImage;					//标题栏背景图片
	this.headerBGImageRepeat = styleInfo.headerBGImageRepeat;		//标题栏背景图片重复方式
	this.headerCornerStyle = styleInfo.headerCornerStyle;			//标题边角显示样式(1为直角, 0为圆角)
	this.hasHeaderRefreshBtn = (styleInfo.hasHeaderRefreshBtn == 1);//标题栏是否包含刷新按钮(true为显示, false为隐藏)
	this.headerRefreshBtnPath = styleInfo.headerRefreshBtnPath;		//标题栏刷新按钮的图片路径
	this.hasHeaderMinBtn = (styleInfo.hasHeaderMinBtn == 1);		//标题栏是否包含最小化按钮(true为显示, false为隐藏)
	this.headerMinBtnPath = styleInfo.headerMinBtnPath;				//标题栏最小化按钮的图片路径
	this.hasHeaderMaxBtn = (styleInfo.hasHeaderMaxBtn == 1);		//标题栏是否包含最大化按钮(true为显示, false为隐藏)
	this.headerMaxBtnPath = styleInfo.headerMaxBtnPath;				//标题栏最大化按钮的图片路径
	this.hasFooter = (styleInfo.hasFooter == 1);					//是否显示底部(true 为显示 false为隐藏)
	this.footerHeight = styleInfo.footerHeight;						//底部高度(单位 px)
	this.footerBGColor = styleInfo.footerBGColor;					//底部背景颜色
	this.footerBGImage = styleInfo.footerBGImage;					//底部背景图片
	this.footerBGImageRepeat = styleInfo.footerBGImageRepeat;		//底部背景图片重复方式
	this.footerCornerStyle = styleInfo.footerCornerStyle;			//底部边角显示样式(1为直角, 0为圆角)
	this.hasFooterRefreshBtn = (styleInfo.hasFooterRefreshBtn == 1);//底部是否包含刷新按钮(true为显示, false为隐藏)
	this.footerRefreshBtnPath = styleInfo.footerRefreshBtnPath;		//底部刷新按钮的图片路径
	this.hasFooterMinBtn = (styleInfo.hasFooterMinBtn == 1);		//底部是否包含最小化按钮(true为显示, false为隐藏)
	this.footerMinBtnPath = styleInfo.footerMinBtnPath;				//底部最小化按钮的图片路径
	this.hasFooterMaxBtn = (styleInfo.hasFooterMaxBtn == 1);		//底部是否包含最大化按钮(true为显示, false为隐藏)
	this.footerMaxBtnPath = styleInfo.footerMaxBtnPath;				//底部最大化按钮的图片路径
}
lightPortletStyle.prototype.isNoStyle = function(){
	return this.id == "-1";
}