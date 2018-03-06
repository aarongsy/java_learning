/*
颜色选择器
http://code.ciaoca.cn/
日期：2011-11-16

settings 参数说明
-----
color:默认颜色
title:关联的元素
------------------------------ */
(function($){
	$.fn.colorSelect=function(settings){
		if(this.length<1){return;};

		// 默认值
		settings=$.extend({
			color:"#000000",
			title:null
		},settings);

		var color_obj=this;
		if(color_obj.val().length>0){
			settings.color=color_obj.val();
		};

		// 更改颜色函数
		var colorThis=function(c){
			color_obj.val(c).css("backgroundColor",c);
			if(settings.title!=null){
				$(settings.title).css("color",c);
			};
		};

		colorThis(settings.color);

		// 创建选择器
		var color_pane,color_table;
		color_pane=$("<div></div>",{"class":"html_colorpane"}).appendTo("body");

		// 初始化选择器面板
		var color_hex=["00","33","66","99","cc","ff"];
		var spcolor_hex=["ff0000","00ff00","0000ff","ffff00","00ffff","ff00ff"];

		color_table="<h5><span>清除颜色</span><em title='关闭'>×</em></h5><table>";
		for(var i=0;i<2;i++){
			for(var j=0;j<6;j++){
				color_table+="<tr>";
				color_table+="<td title='#000000' style='background-color:#000000'>";
				if(i==0){
					color_table+="<td title='#"+color_hex[j]+color_hex[j]+color_hex[j]+"' style='background-color:#"+color_hex[j]+color_hex[j]+color_hex[j]+"'>";
				}else{
					color_table+="<td title='#"+spcolor_hex[j]+"' style='background-color:#"+spcolor_hex[j]+"'>";
				};
				color_table+="<td title='#000000' style='background-color:#000000'>";
				for(var k=0;k<3;k++){
					for(var l=0;l<6;l++){
						color_table+="<td title='#"+color_hex[k+i*3]+color_hex[l]+color_hex[j]+"' style='background-color:#"+color_hex[k+i*3]+color_hex[l]+color_hex[j]+"'>";
					};
				};
			};
		};
		color_table+="</table>";
		color_pane.html(color_table);

		var color_title,color_clear,color_exit,color_select;
		color_title=color_pane.find("h5");
		color_clear=color_title.find("span");
		color_exit=color_title.find("em");
		color_select=color_pane.find("td");

		// 显示面板事件
		color_obj.bind("click",function(){
			var pane_top,pane_left;
			pane_top=color_obj.offset().top+color_obj.outerHeight();
			pane_left=color_obj.offset().left;
			color_pane.css({"top":pane_top,"left":pane_left}).toggle();
		});

		// 清除颜色事件
		color_clear.bind("click",function(){
			color_pane.hide();
			colorThis(settings.color);
		});

		// 关闭面板事件
		color_exit.bind("click",function(){
			color_pane.hide();
		});

		// 选择颜色事件
		color_select.bind("click",function(){
			var color_val=this.title;
			colorThis(color_val);
			color_pane.hide();
		});
	};
})(jQuery);