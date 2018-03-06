
function saveBlogItem(datas,url){
    var data0 = eval(datas);
    var returnValue = ""; 
    if (typeof data0 != "object") {
        return {
            status: '-1'
        };
    }
    else {
        jQuery.ajax({
            success: function(data){
                returnValue = jQuery.trim(data);
            },
            error: function(data){
                returnValue= jQuery.trim(data);
            },
            data: data0,
            url: url + "?t=" + new Date().getTime(),
            type: "post",
            async: false
        });
    }
	return eval('('+returnValue+')');
}

function getIndex(blogid){
  jQuery.post("blogOperation.jsp?operation=getIndex&blogid="+blogid,function(data){
        var index=eval('('+data+')');
        if(index.work){
           jQuery("#workIndex").html(index.work.workIndex); 
           jQuery("#workIndexCount").attr("title",index.work.workIndexTitle).html(index.work.workIndexStar);
        }
        if(index.mood){
           jQuery("#moodIndex").html(""+index.mood.moodIndex); 
           jQuery("#moodIndexCount").attr("title",index.mood.moodIndexTitle).html(index.mood.moodIndexStar);
        }
        
        if(index.schedule){
           jQuery("#scheduleIndex").html(""+index.schedule.scheduleIndex); 
           jQuery("#scheduleIndexCount").attr("title",index.schedule.scheduleIndexTitle).html(index.schedule.scheduleIndexStar);
        }
    });
}

function editContent(obj){
    
    //服务器状态判断
    if(!checkServer())
        return;
	var tid=jQuery(obj).parents(".reportItem").attr("tid");
	var item=jQuery("div[tid="+tid+"]");
	displayLoading(1,"data");
	jQuery.post("blogOperation.jsp?operation=getDiscussContent&discussid="+tid,function(data){
	    var content=jQuery.trim(data);
		var editor=item.find(".editor[tid="+tid+"]");
		
		var workdate=item.attr("forDate");
		jQuery(".editorTmp").find(".uploadDiv").attr("id","uploadDiv_"+workdate);
		var editorTmp=jQuery(".editorTmp").html();
		editor.html(editorTmp);
		editor.show();
		editorId="text_"+new Date().getTime();
		editor.find("textarea[name=submitText]").attr("id",editorId);
		var height=item.find(".reportContent[tid="+tid+"]").height();
		highEditor(editorId,height);
		if(jQuery("#uploadDiv_"+workdate).length>0)
		   bindUploaderDiv(jQuery("#uploadDiv_"+workdate),"relatedacc",editorId);
		   
		KE.html(editorId,content);
		item.find(".discussView").css("display","none");
		var selectedQty=item.find(".qty_items_out[val="+item.attr("appItemId")+"]");
		var inputobj=item.find(".opt_mood_title");
		var valueobj=item.find("input[name=qty_mood]");
		jQuery(inputobj).html(jQuery(selectedQty).html());
		jQuery(valueobj).attr("value",item.attr("appItemId"));
		//editor.find("#uploadIframe").attr("src","/blog/fileupload.jsp");
		//alert(editor.find("#uploadIframeDIV").html());
		var iframeObj = document.createElement("<iframe width=\"100px\" height=\"15\" name=\"uploadIframe"+tid+"\" id=\"uploadIframe"+tid+"\" frameborder=0 scrolling=no src=\"/blog/fileupload.jsp?fieldid="+tid+"\"></iframe>");
		/*
		iframeObj.style.width=100;
		iframeObj.style.heigth=15;
		iframeObj.name="uploadIframe"+tid;
		iframeObj.id="uploadIframe"+tid;
		iframeObj.frameborder=0;
		iframeObj.scrolling="no";
		iframeObj.src="/blog/fileupload.jsp?fieldid="+tid;
		* */
		displayLoading(0);
		KE.util.focus(editorId);
		editor.find("#uploadIframeDIV").html(iframeObj);
	});
}
function saveContent(obj){
    //服务器状态判断
    if(!checkServer())
        return;
    var item=jQuery(obj).parents(".reportItem");                 
	var forDate=item.attr("forDate");                              //工作日
	var isToday=item.attr("isToday");                              //是否为今天提交
	var todayItem=jQuery(".reportItem:first[isTodayItem=true]");   //今天已经提交的记录
	var unsubmit=todayItem.attr("unsubmit");                       //几天是否提交
	var editorId=item.find("textarea[name=submitText]").attr("id");
	var discussid=item.attr("tid");                                //微博记录id
	var type="mood";
	var appItemId=item.find("input[name=qty_mood]").val();         //微博心情id
	if(!KE.g[editorId].wyswygMode){
	    alert("请将编辑器切换到可视化模式！"); //请将编辑器切换到可视化模式！
	    return ;
	}    
	
	if(isToday=="true"&&todayItem.find(".discussView").is(":hidden")){
	   alert("请取消对今天工作微博的编辑"); //请取消对今天工作微博的编辑
	   return ;
	}
	
	//获取内容中图片大小
	jQuery(KE.g[editorId].iframeDoc.body).find("img").each(function(){
	   var imgWidth=jQuery(this).width();
	   jQuery(this).attr("imgWidth",imgWidth);
	});
	var content=KE.html(editorId);

	if(jQuery.trim(content)==""){
		alert("请输入内容");  //请输入内容 
		return;
	}
	displayLoading(1,"save");
	
	//当为今天提交，存在今天记录已经提交的记录，内容追加时需要换行
	var contenttemp=content;
	if(isToday=="true"&&todayItem.length>0&&unsubmit!=="true")
	   content="<br>"+content;
	var backInfo=saveBlogItem({'discussid':discussid,'content':content,'forDate':forDate,'type':type,'appItemId':appItemId,'isEditor':'1'},"saveBlogOperation.jsp");
	
	if(backInfo.status=="1"){
	  if(isToday!="true"||todayItem.length==0||(isToday=="true"&&todayItem.length>0&&unsubmit=="true")){
	    
		var topBlogItem;
		if(isToday=="true"&&todayItem.length>0&&unsubmit=="true"){
		   topBlogItem=todayItem.find(".discussView");
		   topBlogItem.attr("appItemId",appItemId);
		}else{
		   topBlogItem=item.find(".discussView");
		   item.attr("appItemId",appItemId);
		}
		   
		var topBlogItemContent="";
		//不存在今天提交记录时，添加一条提交记录
		if(isToday=="true"&&todayItem.length==0){
		   topBlogItemContent="<div class='reportItem' userid='"+backInfo.backdata.userid+"'  id="+backInfo.backdata.id+" tid="+backInfo.backdata.id+" forDate="+backInfo.backdata.forDate+"  appItemId='"+backInfo.backdata.appItemId+"'  isTodayItem='true' isToday='false'>"
		                       +"<table width='100%' style='TABLE-LAYOUT: fixed;'><tr><td valign='top' width='75px' nowrap='nowrap'><div class='dateArea'>"
		                       +"<div class='day'>今天</div><div class='yearAndMonth'>"+new Date(backInfo.backdata.forDate.replace(/-/g,"/")).pattern("MM月dd日")+"</div></div></td><td valign='top'><div class='discussView'>";  
		}
		topBlogItemContent=topBlogItemContent+"<div class='sortInfo' ><span style='float: left;'><span class='name'>&nbsp;<a href='viewBlog.jsp?blogid="+backInfo.backdata.userid+"' target='_blank'>"+backInfo.backdata.userName+"</a>&nbsp;</span>"
		+"<div class='state "+(backInfo.backdata.type=='1'?"after":"ok")+"' title='"+(backInfo.backdata.type=='1'?"补交于":"提交于")+"'></div><span class='datetime'>"+backInfo.backdata.createdatetime+"&nbsp;</span>"; // 补交于 提交于
		
		//上级评分
		if(backInfo.backdata.isManagerScore=="1") //启用上级评分
		  topBlogItemContent+="<span isRaty='false' style='width: 100px' score='"+backInfo.backdata.score+"' readOnly='true' discussid='"+backInfo.backdata.id+"' target='blog_raty_keep_"+backInfo.backdata.id+"' class='blog_raty' id='blog_raty_"+backInfo.backdata.id+"'></span>";
		//心情
		if(backInfo.backdata.faceImg!=undefined){
			topBlogItemContent+="<img id='moodIcon' style='margin-left: 2px;margin-right: 2px' width='16px' src='"+backInfo.backdata.faceImg+"' alt='"+backInfo.backdata.itemName+"'/>";
		}
		//微博来自哪里
		if(backInfo.backdata.comefrom!="0"){
		    var comefrom=backInfo.backdata.comefrom;
		    var comefromTemp="";
		    if(comefrom=="1")  
		        comefromTemp="(来自Iphone)";
		    else if(comefrom=="2")  
		        comefromTemp="(来自Ipad)";
		    else if(comefrom=="3")  
		        comefromTemp="(来自Android)";          
		    else if(comefrom=="4")  
		        comefromTemp="(来自Web手机版)";
		    else
		        comefromTemp="";
		    topBlogItemContent+="<span class='comefrom'>"+comefromTemp+"</span> ";	
		}
		
		topBlogItemContent+="</span><span class='sortInfoRightBar'>"
		+"	&nbsp;<span onclick=\"editContent(this)\" style='cursor:pointer'><a>编辑</a></span>" //编辑	
		+"&nbsp;<span style='cursor:pointer' onclick=\"showReplySubmitBox(this,'"+backInfo.backdata.id+"',{'uid':'"+backInfo.backdata.userid+"','level':'0'},0)\"><a>评论</a></span>"
		+"&nbsp;<span style='cursor:pointer' onclick=\"showReplySubmitBox(this,'"+backInfo.backdata.id+"',{'uid':'"+backInfo.backdata.userid+"','level':'0'},1)\"><a>私评</a></span>"
		+"</span></div><div class='clear reportContent' tid="+backInfo.backdata.id+">"+content+"</div>"
		
		//当编辑的记录中包含回复内容时，避免回复内容被清除
		if (topBlogItem.find('.reply').length > 0) {
			topBlogItem.find('.reply').prevAll().remove();
			topBlogItem.find('.reply').before(topBlogItemContent);
		}else{
			if(isToday=="true"&&todayItem.length==0){
		       topBlogItemContent=topBlogItemContent+"</div><div class='commitBox'></div><div class='editor' tid="+backInfo.backdata.id+" style='display: none;'></div></td></tr></table></div>"
		    }else
			   topBlogItem.html(topBlogItemContent);
		}
		if(isToday=="true"&&todayItem.length==0){
		   item.after(topBlogItemContent);
		   item.next().find(".reportContent img").each(function(){
			   initImg(this); 
			});
		}else{
			topBlogItem.show();
			if(isToday=="true"&&todayItem.length>0&&unsubmit=="true"){
			    todayItem.find(".editor[tid=0]").attr("tid",backInfo.backdata.id);
			    todayItem.attr("tid",backInfo.backdata.id);
			    todayItem.attr("unsubmit",false);
			}    
			else{
				item.attr("tid",backInfo.backdata.id);
				if(item.find(".editor[tid=0]").length==1){ //未补交情况下
				     item.find(".editor[tid=0]").attr("tid",backInfo.backdata.id).hide();
				}else{
				     item.find(".editor[tid="+backInfo.backdata.id+"]").hide();
				}
				item.attr("unsubmit",false);
			}
			topBlogItem.find(".reportContent img").each(function(){
			   initImg(this);
			});
		}
		managerScore(jQuery("#blog_raty_"+backInfo.backdata.id)[0]);//上级评分初始化
	  }else{
	    if(todayItem.length>0){
	       var tempdiv=jQuery("<div>"+contenttemp+"</div>");
	       tempdiv.find("img").each(function(){
			   initImg(this);
			});
	       todayItem.find(".reportContent:first").append(tempdiv);
	       var selectedQty=item.find(".qty_items_out[val="+appItemId+"]");
	       var imgsrc=selectedQty.find("img").attr("src");
		   todayItem.find("#moodIcon").attr("src",imgsrc);
		   todayItem.attr("appItemId",appItemId);
	    }
	  }	
	  if(isToday=="true"){
		  KE.html(editorId,"");
		  KE.create(editorId);
	  }
	  msgRemind();
	}else if(backInfo.status=="2"){
		alert("评论"); //服务器超时
	}else{
	    alert("保存失败"); //保存失败
	}
	
	displayLoading(0);
}


/*replyid 被回复评论id relatedid被回复评论中相关人id */
function addAply(tm,tid,replyid,relatedid){
    //服务器状态判断
    if(!checkServer())
        return; 
	var item=jQuery(tm).parents(".reportItem");
	var content=item.find("textarea[name=replayContent]").val();
	var workdate=item.attr("forDate");
	var bediscussantid=item.attr("userid");
	var commentType=jQuery(tm).parents(".commitBox").attr("commentType");
	

	if(""==jQuery.trim(content)){
		alert("请填写评论内容"); //请填写评论内容'
		return;
	}
	if(content.indexOf("relatedid=\""+relatedid+"\"")==-1){
		replyid=0;
	}
	
	displayLoading(1,"save");
	var backInfo=saveBlogItem({'content':content,'action':'add','discussid':tid,'replyid':replyid,'relatedid':relatedid,'commentType':commentType,'workdate':workdate,'bediscussantid':bediscussantid},"blogCommentOparation.jsp");
	
	if(backInfo.status=="1"){
	    item.find(".deleteOperation").hide();
		var temp="";
		temp+="<div id=\"re_"+backInfo.backdata.id+"\"><div class=\"space\"></div><div class=\"sortInfo replyTitle\">"
			 +"<span class=\"name\">&nbsp;<a href='viewBlog.jsp?blogid="+backInfo.backdata.userid+"' target='_blank'>"+backInfo.backdata.username  
			 +"</a>&nbsp;</span>"
			 +"<div class=\"state re\" title='评论于'></div><span class=\"datetime\">"+backInfo.backdata.createdatetime+(backInfo.backdata.commentType=="1"?"&nbsp;<span class='comefrom'>(私评)</span>":"") //评论于
			 +"&nbsp;</span><span class='sortInfoRightBar'><a href='javascript:void(0)' class='deleteOperation' onclick=\"deleteDiscuss(this,"+backInfo.backdata.discussid+",'"+backInfo.backdata.id+"')\">删除</a>" //删除
			 +"&nbsp;<a href='javascript:void(0)' onclick=\"showReplySubmitBox(this,"+backInfo.backdata.discussid+",{'uid':'"+backInfo.backdata.userid+"','name':'"+backInfo.backdata.username+"','level':'1','replyid':'"+backInfo.backdata.id+"'},0)\">评论</a>" //评论
			 +"&nbsp;<a href='javascript:void(0)' onclick=\"showReplySubmitBox(this,"+backInfo.backdata.discussid+",{'uid':'"+backInfo.backdata.userid+"','name':'"+backInfo.backdata.username+"','level':'1','replyid':'"+backInfo.backdata.id+"'},1)\">私评</a>" //私评
			 +"</span></div><div class=\"clear reportContent\">"+content  
			 +"</div>";
			 if (item.find(".reply").length == 0) {
					item.find(".discussView").append("<div class=\"reply\" target=\""+tid+"\"></div>");
			}else{
				temp="<div class=\"dotedline\"></div>"+temp;
			}
			temp=temp+"</div>";
		item.find(".reply").append(temp);
		
		item.find(".reportContent img").each(function(){
		   initImg(this);
		});
		
		jQuery("textarea[name="+tid+"]").html("");
		jQuery(tm).parent().parent().hide();
		item.find(".commitBox").attr("state","0");
		jQuery(document.body).focus();
		item.find(".commitBox").html("");
	}
	else if(backInfo.status=="2"){
		alert("服务器超时"); //服务器超时
	}
	displayLoading(0);
}


function showReplySubmitBox(obj,tid,extral,commentType){
	var content="";
	var item=jQuery(obj).parents(".reportItem");
	
	if(item.find(".commitBox").attr("state")== "1"){
	   alert("请取消正在编辑的评论");  //请取消正在编辑的评论
	   return;
	}   
	
	var editorid=(new Date()).getTime();
	if(extral.level=="1"){
		//content="<a style='color:#1d76a4;' relatedid='"+extral.uid+"' unselectable='off' contenteditable='false' style='cursor:pointer'  href='javascript:void(0)' onclick='openBlog("+extral.uid+")'>@"+extral.name+"&nbsp;</a>";
	    content="<button type='button' relatedid='"+extral.uid+"' onclick=\"try{openBlog('"+extral.uid+"','"+extral.name+"');}catch(e){}\" style='border:medium none;padding:0px;margin:0px;;background:none;color:#1d76a4;cursor:pointer;font-family:微软雅黑 !important;font-size:12px !important;font:none !important;height:18px !important;text-align:left;' contenteditable='false'  unselectable='off'>@"+extral.name+"&nbsp;</button>&nbsp;";
	}
	var temp="";
	temp+="<span>评论内容</span><br>"; //评论内容
	temp+="<textarea id='text_"+editorid+"' name='replayContent'>"+content+"</textarea>";
	temp+="<div class='appitem_bg'><input type=\"button\" class=\"commitBoxButton\" onclick=\"addAply(this,"+tid+"";
	if(extral.level=='1')
	  temp+=","+extral.replyid+",'"+extral.uid+"'";
	else
	  temp+=",0,'0'";
	temp+=")\"><input type='button' class='editCancel' style='float:none'  onclick=\"replyCancel(this)\" value='取消'></div>"; //取消
	item.find(".commitBox").append(temp);
	item.find(".commitBox").attr("state","1");
	item.find(".commitBox").attr("commentType",commentType);
	
	item.find(".commitBox").css("display","block");
	jQuery("#text_"+editorid).focus();
	highEditorForReply("text_"+editorid);
	
}

function replyCancel(obj){
    jQuery(document.body).focus(); //避免删除div时 页面焦点丢失
	var item=jQuery(obj).parents(".reportItem");
	item.find(".commitBox").css("display","none");
	item.find(".commitBox").attr("state","0");
	item.find(".commitBox").html("");
	
}
function editCancel(obj){
	jQuery(obj).parents(".editor").css("display", "none");
	jQuery(obj).parents(".reportItem").find(".discussView").css("display", "block");
	
}
function showAfterSubmit(obj){
	var item=jQuery(obj).parents(".reportItem");
	item.find(".discussView").css("display","none");
	var isToday=item.attr("isToday");
	var workdate=item.attr("forDate");
	if(isToday=="true")
	    workdate="";
	var editor=item.find(".editor");
	if(editor.find("textarea").length!=0){
		if(editor.css("display")=="none")
			editor.css("display","inline");
		else{
			//KE.html(editor.find("textarea").attr("id"),"");
		}
		return;
	}
	
	jQuery(".editorTmp").find(".uploadDiv").attr("id","uploadDiv_"+workdate);
	var editorTmp=jQuery(".editorTmp").html();
	
	editor.html(editorTmp);
	item.find(".editor").show();
	editor=item.find(".editor");
	editorId="text_"+new Date().getTime();
	editor.find("textarea[name=submitText]").attr("id",editorId);
	highEditor(editorId);
	
	if(jQuery("#uploadDiv_"+workdate).length>0)
       bindUploaderDiv(jQuery("#uploadDiv_"+workdate),"relatedacc",editorId);
    
	if(item.attr("isToday")=="false"){
		editor.find(".editCancel").css("display","inline");
	}else{
		editor.find(".editCancel").css("display","none");
	}
}

function afterSubmit(fordate){
		var item=jQuery("div[forDate="+fordate+"]");
		var content=KE.html("text_"+fordate);
		var backInfo=saveBlogItem({'content':content,'forDate':fordate},"saveBlogOperation.jsp");
		item.find(".state").removeClass("no").addClass("after");
		item.find(".state").after("<span class=\"datetime\">补交于:"+backInfo.backdata.curDate+" "+backInfo.backdata.curTime+"&nbsp;</span>"); //补交于
		item.find(".sortInfoRightBar").html("");
		item.find(".sortInfo").after("<div class=\"clear reportContent\"></div>");
		item.find(".reportContent").after("<div class=\"commitBox\"></div>");
		if(item.find(".state").hasClass("no")){
			item.find(".state").removeClass("no");
			item.find(".state").addClass("ok");
		}
		item.attr("tid",backInfo.backdata.id)
		item.find(".reportContent").html(content);
		item.find(".afterSubmit").remove();
		item.find(".unSumit").remove();
}


/*高级编辑器*/
function highEditorForReply(remarkid){
    if(jQuery("#"+remarkid).is(":visible")){
		
		var  items=[
						'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 
						'title', 'fontname', 'fontsize',  'textcolor', 'bold','italic',  'strikethrough', 'advtable'
				   ];
			 
	    KE.init({
					id : remarkid,
					height : '150px',
					width:'auto',
					resizeMode:1,
					imageUploadJson : '/kindeditor/jsp/upload_json.jsp',
				    allowFileManager : false,
	                newlineTag:'br',
	                items : items,
				    afterCreate : function(id) {
						KE.util.focus(id);
				    }
	   });
	   KE.create(remarkid);
	}
}

	
/*高级编辑器*/
function highEditor(remarkid,height){
    height=!height||height<150?150:height;
    if(jQuery("#"+remarkid).is(":visible")){
		
		var  items=[
						'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 
						'title', 'fontname', 'fontsize',  'textcolor', 'bold','italic',  'strikethrough', 'image', 'advtable'
				   ];
			 
	    KE.init({
					id : remarkid,
					height :height+'px',
					width:'auto',
					resizeMode:1,
					imageUploadJson : '/kindeditor/jsp/upload_json.jsp',
				    allowFileManager : false,
	                newlineTag:'br',
	                items : items,
				    afterCreate : function(id) {
						KE.util.focus(id);
				    }
	   });
	   KE.create(remarkid);
	}
}


 function show_select(input,option,value,type,e,obj){
      e.cancelBubble=true;
	  inputobj=document.getElementById(input);
	  inputobj=obj;
	  optionobj=jQuery(obj).next();
	  valueobj=jQuery(obj).parent().find(".qty");
	  if(optionobj.css("display")==""){
	  	 optionobj.css("display","none");
	  	 return ;
	  }else{
	  	optionobj.css("display","");
	  }
	  optionobj.onblur=function () {
	    optionobj.style.display="none";
	  }
	  if(type=="mood"){
		 jQuery(inputobj).focus();
		 jQuery(optionobj).find("div").each(function(){
			     jQuery(this).hover(
			              function(){
			                  jQuery(this).addClass("qty_items_over");
			                  jQuery(this).removeClass("qty_items_out");
			              },
			              function(){
			                  jQuery(this).addClass("qty_items_out");
			                  jQuery(this).removeClass("qty_items_over");
			              }
			      );   
		          jQuery(this).click(function(){
		          	optionobj.hide();
		          	jQuery(inputobj).html(jQuery(this).html());
					jQuery(valueobj).val(jQuery(this).attr("val"));
		          });
		  });
	 }
	}

function search(content,startdate,enddate,obj,blogid){
	var content= jQuery("#"+content).val();
	var ac=jQuery(obj).attr("from");            //来自页面
	var startdate=jQuery("#"+startdate).val();
	var enddate=jQuery("#"+enddate).val();
	var url="discussList.jsp?requestType=search&t="+new Date().getTime();
	
	if(ac=="gz"&&""==jQuery.trim(content)){
		window.location="myAttention.jsp?startDate="+startdate+"&endDate="+enddate;
		return; 
	}
	
	displayLoading(1,"search");
	jQuery.post(encodeURI(url+"&content="+content),{"startDate":startdate,"endDate":enddate,'blogid':blogid,'ac':ac},function(a){
	    
	    if(ac=="myBlog"){
	       jQuery(".tabStyle2").find(".select2").removeClass("select2");
	       jQuery("#blog").addClass("select2");
	    }   
		jQuery("#reportBody").html(a.replace(/<link.*?>.*?/, ''));
		
		if(""!=jQuery.trim(content)){
		   jQuery('#reportBody .reportItem').each(function(){
		      jQuery(this).find(".reportContent:first").highlight(content, {needUnhighlight: true});
		   });
		 }
		
		//图片初始化处理  
		jQuery('.reportContent img').each(function(){
		    initImg(this);
		});   
		
		//上级评分初始化
		jQuery(".blog_raty").each(function(){
		   managerScore(this);
		});
		
		displayLoading(0,"search");
	});
}
function reset(startdate,enddate){
	jQuery("#"+startdate).val(jQuery("#"+startdate+"_").val());
	jQuery("#"+startdate+"span").text(jQuery("#"+startdate+"_").val());
	jQuery("#"+enddate).val(jQuery("#"+enddate+"_").val());
	jQuery("#"+enddate+"span").text(jQuery("#"+enddate+"_").val());
	jQuery("#content").val("");
}
//提醒
function unSumitRemind(obj,remindid,discussant,workdate){
    var isRemind=jQuery(obj).attr("isRemind");
    if(isRemind!="true"){
		jQuery.post("blogOperation.jsp?operation=unsubmitRemind&remindid="+remindid+"&discussant="+discussant+"&workdate="+workdate,function(){
		   jQuery(obj).text("已提醒");//已提醒
		   jQuery(obj).attr("isRemind","true");
		   jQuery(obj).css({'color':'red','cursor':'normal'});
		});
	 } 
	}
//全部提醒	
function unSumitRemindAll(obj,remindid,workdate){
  jQuery(obj).parents("table:first").find(".unSumitRemind").each(function(){
     jQuery(this).click();
  });
  jQuery(obj).text("全部已经提醒");//全部已经提醒
  jQuery(obj).attr("isRemind","true");
  jQuery(obj).css({'color':'red','cursor':'normal'});
} 

//提交回复时，提交等待
function displayLoading(state,flag){
  if(state==1){
        //遮照打开
        var bgHeight=document.body.scrollHeight; 
        var bgWidth=window.parent.document.body.offsetWidth;
        jQuery("#bg").css("height",bgHeight,"width",bgWidth);
        jQuery("#bg").show();
        
        if(flag=="save")
           jQuery("#loadingMsg").html("正在保存，请稍等...");   //正在保存，请稍等...
        else if(flag=="page")
           jQuery("#loadingMsg").html("页面加载中，请稍候...");   //页面加载中，请稍候...
        else if(flag=="data"||flag=="search")
           jQuery("#loadingMsg").html("正在获取数据,请稍等...");   //正在获取数据,请稍等...  
              
        //显示loading
	    var loadingHeight=jQuery("#loading").height();
	    var loadingWidth=jQuery("#loading").width();
	    jQuery("#loading").css({"top":document.body.scrollTop + document.body.clientHeight/2 - loadingHeight/2,"left":document.body.scrollLeft + document.body.clientWidth/2 - loadingWidth/2});
	    jQuery("#loading").show();
    }else{
        jQuery("#loading").hide();
        jQuery("#bg").hide(); //遮照关闭
    }
}

 /*chartType 报表类型  blog 微博 mood心情 
  value需要查看的人员或者部门、分部id 
  year 年份 
  type 1人员 2 分部 3 部门 
  title报表标题
*/
function openChart(chartType,value,year,type,title){

    var diag = new Dialog();
    diag.Modal = true;
    diag.Drag=true;
	diag.Width = 680;
	diag.Height = 420;
	diag.ShowButtonRow=false;
	diag.Title = title;

	diag.URL = "blogChart.jsp?chartType="+chartType+"&value="+value+"&type="+type+"&year="+year+"&title="+title;
    diag.show();
 }
 
 //初始化图片
 function initImg(obj){
       var imgWidth=jQuery(obj).attr("imgWidth");
	   if(imgWidth>400)
	      jQuery(obj).width(400);
	   else if(imgWidth==0)
	      jQuery(obj).width(400);   
	   else{
	      if(jQuery(obj).width()>400)
	         jQuery(obj).width(400);
	   }  
	   
	
	   jQuery(obj).coomixPic({
			path: 'js/weaverImgZoom/images',	// 设置coomixPic图片文件夹路径
			preload: true,		// 设置是否提前缓存视野内的大图片
			blur: true,			// 设置加载大图是否有模糊变清晰的效果
			
			// 语言设置
		    left: '左旋转按钮文字',		// 左旋转按钮文字
		    right: '右旋转按钮文字',		// 右旋转按钮文字
		    source: '查看原图按钮文字',    // 查看原图按钮文字
			hide:'收起'       //收起
	   });
	
 }
 
  //上级评分
 function managerScore(obj){
        if(jQuery(obj).attr("isRaty")=="true")
           return ;
           
        jQuery(obj).attr("isRaty","true"); 			       
	    var blog_raty_id=jQuery(obj).attr("id");
	    var score=jQuery(obj).attr("score");
	    var discussid=jQuery(obj).attr("discussid");
	    var readOnly=jQuery(obj).attr("readOnly");
	    var isReadOnly=false;
	    if(readOnly=="true")
	        isReadOnly=true;
	        
	    jQuery('#'+blog_raty_id).raty({
	       path:'js/raty/img/',
	       hintList:['1分', '2分', '3分', '4分', '5分'], //分
	       readOnly:isReadOnly,
	       start:score,
	       noRatedMsg:'上级没有评分', //上级没有评分
	       click: function(score, evt) {
               jQuery.post("blogOperation.jsp?operation=managerScore&discussid="+discussid+"&score="+score)
           }
	    });
 }

   //打开应用程序
   function openApp(obj,type){
	   var editorId=jQuery(obj).parents(".editor").find("textarea[name=submitText]").attr("id");
	   var htmlstr=onShowApp(type);
	   if(htmlstr){      
	     if(KE.g[editorId].wyswygMode)
	        KE.insertHtml(editorId,htmlstr);
	     else
	        alert("请将编辑器切换到可视化模式！"); //请将编辑器切换到可视化模式！
	   }  
	}
  
  function onShowApp(type){
	   var id1;
       if(type=='doc'){
	      //id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids=");
    	   getrefobj('docbrowser','docbrowserspan','402881e70ebfb96c010ebfbf16de0004','','/document/base/docbaseview.jsp?id=','0');
    	   var docids = document.getElementsByName("docbrowser")[0].value;
    	   var docNames = 	document.getElementById("docbrowserspan").innerText;
    	   id1={id:docids,name:docNames};
	   }else if(type=='project')   
	      id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids=");
	   else if(type=='task')   
	      id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?resourceids=");
	   else if(type=='crm')   
	      id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids=");
	   else if(type=='workflow'){
		   //id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="); 
		   getrefobj('workflowbrowser','workflowbrowserspan','402881e70ebfb96c010ebfc561db000f','','/workflow/request/workflow.jsp?requestid=','0');
		   var docids = document.getElementsByName("workflowbrowser")[0].value;
    	   var docNames = 	document.getElementById("workflowbrowserspan").innerText;
    	   id1={id:docids,name:docNames};
	   }else if(type='upload'){
		   var attachid = jQuery("#addattachvalueid").val();
           var attachname = jQuery("#addattachvalueid").attr("title");
           id1 = {id:attachid,name:attachname};
	   }else if(type="workplan")
		  id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workplan/data/WorkplanEventsBrowser.jsp");    
       if(id1){
    	   
	       var ids=id1.id;
	       var names=id1.name;
	       var desc=id1.resourcedesc;
	       if(ids.length>500)
	          alert("您选择的数量太多，数据库将无法保存，请重新选择！");
	       else if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var description=(true&&desc)?desc.split("\7"):"";
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!=''){
	            	  /*
						if(type=="workplan"){
							var desc_i=description[i];
							sHtml = sHtml+"<br/><b><a style='' href='javascript:void(0)'  linkid="+tempid+" linkType='"+type+"' onclick='try{return openAppLink(this,"+tempid+");}catch(e){}' ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+tempname+"</a></b>&nbsp<br/>"+
									"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+decodeURIComponent(desc_i);
						}else{
		                	sHtml = sHtml+"<a href='javascript:void(0)'  linkid="+tempid+" linkType='"+type+"' onclick='try{return openAppLink(this,"+tempid+");}catch(e){}' ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+tempname+"</a>&nbsp";
						}
						* */
	            	   if(type=="doc"){
	            		   sHtml = sHtml+"<a href='javascript:void(0)'  linkid="+tempid+" linkType='"+type+"' "+"onclick=\"onUrl('/document/base/docbaseview.jsp?id="+tempid+"','"+tempname+"','tab"+tempid+"')\""+"' ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+tempname+"</a>&nbsp";
	            	   }else if(type=="workflow"){
	            		   sHtml = sHtml+"<a href='javascript:void(0)'  linkid="+tempid+" linkType='"+type+"' "+"onclick=\"onUrl('/workflow/request/workflow.jsp?requestid="+tempid+"','"+tempname+"','tab"+tempid+"')\""+"' ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+tempname+"</a>&nbsp";
	            	   }else if(type=="upload"){
	            		   var temptype = "";
				           if(tempname.indexOf(".")>-1){
				        	   var index = tempname.lastIndexOf(".");
				        	   temptype = tempname.substring(index+1,tempname.length).toLowerCase();
				           }
	            		   if(temptype!=""&&"doc,docx,pdf,txt,ppt,pptx,xls,xlsx,jpg,png,gif,bmp,html,htm".indexOf(temptype)>-1){
	            			    var tmptitle = "";
	            			    var ind = tempname.lastIndexOf(".");
	            			    tmptitle = tempname.substring(0,ind);
	            		   		sHtml = sHtml+"<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+tempid+"&from=formservice','附件-"+tmptitle+"','"+tempname+"')\"  linkid="+tempid+" linkType='"+type+"' ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+tempname+"</a>&nbsp";
	            		   		sHtml = sHtml+"<a href='/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+tempid+"&isdownload=1'  linkid="+tempid+" linkType='"+type+"' ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:4px'>下载</a>&nbsp";
	            		   }else{
	            			   sHtml = sHtml+"<a href='/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+tempid+"&isdownload=1'  linkid="+tempid+" linkType='"+type+"'  ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+tempname+"</a>&nbsp";
	            			   sHtml = sHtml+"<a href='/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+tempid+"&isdownload=1'  linkid="+tempid+" linkType='"+type+"'  ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:4px'>下载</a>&nbsp";
	            		   }
	            	   }
			        }
	          }
	          return sHtml;
	       }
       }else{
       }
}
  
  
  //阅读记录
  function readDiscuss(obj,discussid,blogid){
      var isRead=jQuery(obj).attr("isRead");
      jQuery(obj).css("background","#F5F5F5");
      if(isRead=="false"){
        jQuery(obj).attr("isRead","true");
        jQuery.post("blogOperation.jsp?operation=readDiscuss&discussid="+discussid+"&blogid="+blogid,function(){
            jQuery("#new_"+discussid).hide();
	        var count=jQuery("#homepage").find(".count").text();
	        count=count-1;
	        if(count>0)
	           jQuery("#homepage").find(".count").text(count);
	        else
	           jQuery("#homepage").find(".msg-count").hide();   
	        });
      }  
   }
   
   function moveout(obj){
     jQuery(obj).css("background","#fff");
   }
   
   //打开应用连接
   function openAppLink(obj,linkid){
     
     var linkType=jQuery(obj).attr("linkType");
     var discussid=jQuery(obj).parents(".reportItem").attr("id");
     if(linkType=="doc")
        window.open("/docs/docs/DocDsp.jsp?id="+linkid+"&blogDiscussid="+discussid);
     else if(linkType=="task")   
        window.open("/proj/process/ViewTask.jsp?taskrecordid="+linkid+"&blogDiscussid="+discussid);
     else if(linkType=="crm")   
        window.open("/CRM/data/ViewCustomer.jsp?CustomerID="+linkid+"&blogDiscussid="+discussid);   
     else if(linkType=="workflow")   
        window.open("/workflow/request/ViewRequest.jsp?requestid="+linkid+"&blogDiscussid="+discussid);   
     else if(linkType=="project")   
        window.open("/proj/data/ViewProject.jsp?ProjID="+linkid+"&blogDiscussid="+discussid);   
     else if(linkType=="workplan")
    	 window.open("/workplan/data/WorkPlanDetail.jsp?workid="+linkid+"&from="+discussid);    
     return false;   
   }
 
    //打开附件
	function opendoc(showid,versionid,docImagefileid,obj){
	    var discussid=jQuery(obj).parents(".reportItem").attr("id");
	    openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&imagefileId="+docImagefileid+"&blogDiscussid="+discussid+"&isFromAccessory=true&isfromcoworkdoc=1");
	}
	//打开附件
	function opendoc1(showid,obj){
	   var discussid=jQuery(obj).parents(".reportItem").attr("id");
	   openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=0&blogDiscussid="+discussid);
	}
	//下载附件
	function downloads(files,obj){
	    var discussid=jQuery(obj).parents(".reportItem").attr("id");
	   jQuery("#downloadFrame").attr("src","/weaver/weaver.file.FileDownload?fileid="+files+"&download=1&blogDiscussid="+discussid);
	}
    
    //时间日期格式化
    Date.prototype.pattern=function(fmt) {     
	    var o = {     
	    "M+" : this.getMonth()+1, //月份     
	    "d+" : this.getDate(), //日     
	    "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时     
	    "H+" : this.getHours(), //小时     
	    "m+" : this.getMinutes(), //分     
	    "s+" : this.getSeconds(), //秒     
	    "q+" : Math.floor((this.getMonth()+3)/3), //季度     
	    "S" : this.getMilliseconds() //毫秒     
	    };     
	    var week = {     
	    "0" : "\u65e5",     
	    "1" : "\u4e00",     
	    "2" : "\u4e8c",     
	    "3" : "\u4e09",     
	    "4" : "\u56db",     
	    "5" : "\u4e94",     
	    "6" : "\u516d"    
	    };     
	    if(/(y+)/.test(fmt)){     
	        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));     
	    }     
	    if(/(E+)/.test(fmt)){     
	        fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "\u661f\u671f" : "\u5468") : "")+week[this.getDay()+""]);     
	    }     
	    for(var k in o){     
	        if(new RegExp("("+ k +")").test(fmt)){     
	            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));     
	        }     
	    }     
    return fmt;     
   }
   
   	//打开报表
	function openReport(){
		jQuery(".menuItem").each(function(){
		   jQuery(this).removeClass("selected");
		});
	    jQuery("#myBlog").addClass("selected");
	    jQuery("#report").click();                     //加载报表
	    jQuery("#myBlogMenu").show();                  //显示菜单
		jQuery("#searchBtn").attr("from","myBlog");    //修改搜索来源页
	}
	
	function doAttention(obj,attentionid,islower,eve){
        var itemName=jQuery(obj).parent().parent().find(".title").text();
        var status=jQuery(obj).attr("status");
        if(status=="cancel"){
           jQuery.post("blogOperation.jsp?operation=cancelAttention&islower="+islower+"&attentionid="+attentionid);
           jQuery(obj).attr("status","add");
           jQuery(obj).find("#btnLabel").html("<span class='add'>+</span>添加关注</span>");  
        }
        if(status=="add"){
           jQuery.post("blogOperation.jsp?operation=addAttention&islower="+islower+"&attentionid="+attentionid);
           jQuery(obj).attr("status","cancel");
           jQuery(obj).find("#btnLabel").html("<span class='add'>-</span>取消关注</span>");  
        }
        if(status=="apply"){
          if(jQuery(obj).attr("isApply")!=="true"){
            jQuery.post("blogOperation.jsp?operation=requestAttention&islower="+islower+"&attentionid="+attentionid,function(){
               alert("申请已经发送"); //申请已经发送
               jQuery(obj).find("#btnLabel").html("<span class='apply'>√</span>已申请</span>");
               jQuery(obj).attr("isApply","true");
            });
          }else {
              alert("申请已经发送"); //申请已经发送
          }  
        }
        eve.cancelBubble=true;
      }
	
	//检查服务器状态
	function checkServer(){
		return true;
	    var xmlhttp;
	    if (window.XMLHttpRequest) {
	    	xmlhttp = new XMLHttpRequest();
	    }  
	    else if (window.ActiveXObject) {
	    	xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");  
	    }
	    var URL = "/systeminfo/CheckConn.jsp?userid=<%=user.getId()%>&time="+new Date();
	    var flag=true;
	    jQuery.ajax({
            url: URL,
            type: "post",
            async: false,
            success: function(data){
               if(data=='1') {
	    			var diag = new Dialog();
					diag.Width = 300;
					diag.Height = 180;
					diag.ShowCloseButton=false;
					diag.Title = "网页超时提醒";
					//diag.InvokeElementId="pageOverlay"
					diag.URL = "/wui/theme/ecology7/page/loginSmall.jsp?username=<%=user.getId()%>";
					diag.show();
			        flag=false;
	    		}
	    		else if(data=='2') {
	    			var flag_msg = '网络故障或其它原因导致您连接不上服务器，请复制下重要信息稍候再提交！';
	    			Dialog.alert(flag_msg);
	    			flag=false;
	    		}else{
	    		    flag=true;
	    		}
            }
        });
        return flag;
	}
	
 function openBlog(blogid,username){
	var url="/blog/viewBlog.jsp?blogid="+blogid;
	onUrl(url,username+'的微博','tab'+username,"tab"+blogid);
 }
 //获得更多
 function getMore(obj,url,requestType,content){
       displayLoading(1,"data");
       jQuery.post(url,function(data){
           jQuery(obj).remove();
		    var tempdiv=jQuery("<div>"+data+"</div>");
		    //初始化处理图片
	        tempdiv.find('.reportContent img').each(function(){
				initImg(this);
		    });
		    
		    if(requestType=="search"&&""!=jQuery.trim(content)){
		      tempdiv.find('.reportItem').each(function(){
		         jQuery(this).find(".reportContent:first").highlight(content, {needUnhighlight: true});
		      });
		      //tempdiv.highlight(content, {needUnhighlight: true});
		    }  
		     jQuery("#reportBody").append(tempdiv); 
            
		    //上级评分处理
		    jQuery(".blog_raty").each(function(){
		       if(jQuery(this).attr("isRaty")!="true"){
			       managerScore(this);
			       jQuery(this).attr("isRaty","true"); 
			   }    
			});
		    displayLoading(0);
		});
    }
  //消息提醒
  function msgRemind(){
    var diag = new Dialog();
    diag.Title = "消息提醒";//消息提醒
    diag.Width = 180;
	diag.Height = 80;   
	diag.Modal = false;
	diag.AutoClose=3;
	diag.InnerHtml='<div style="color:#1d76a4;font-size:14px;vertical-align: middle;padding-top:15px">工作微博发表成功</div>';//工作微博发表成功  
	diag.show();
  }
  
  
function getrefobj(inputname, inputspan, refid, param, viewurl, isneed){
    if (document.getElementById(inputname.replace("field", "input")) != null) {
        document.getElementById(inputname.replace("field", "input")).value = "";
    }
    var fck = param.indexOf("function:");
    if (fck > -1) {
    }
    else {
        var param = parserRefParam(inputname, param);
    }
    var idsin = document.getElementsByName(inputname)[0].value;
    var url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
    if (idsin.length > 900) { //当idsin过长时，ie的url不支持过长的地址
        url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param;
    }
    var id;
    var browserName=navigator.userAgent.toLowerCase();
    var isSafari = /webkit/i.test(browserName) &&!(/chrome/i.test(browserName) && /webkit/i.test(browserName) && /mozilla/i.test(browserName));
    /*
     * 因为岗位的Browser框页面代码结构不支持使用ext窗口打开并取值的情况，故在safari浏览器的环境下使用模态对话框打开岗位browser
     * safari浏览器也可以很好的支持模态对话框,以下其他类别的Browser框类同
     */
    var isStationBrowserInSafari = isSafari && (refid == '402881e510efab3d0110efba0e820008' || refid == '40288041120a675e01120a7ce31a0019');
    //流程单选 || 工作流程单选 || 工作流程多选
	var isWorkflowBrowserInSafari = isSafari && (refid == '402881980cf7781e010cf8060910009b' || refid == '402880371d60e90c011d6107be5c0008' || refid == '40288032239dd0ca0123a2273d270006');	
	//员工多选
	var isHumresBrowserInSafari = isSafari && refid == '402881eb0bd30911010bd321d8600015';	
	
    if (!Ext.isSafari) {
        try {
            // id=openDialog(url,idsin);
            id = window.showModalDialog(url, idsin, 'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
        } 
        catch (e) {
            return
        }
        
        if (id != null) {
            if (id[0] != '0') {
                document.getElementsByName(inputname)[0].value = id[0];
                document.getElementById(inputspan).innerHTML = id[1];
                //alert(document.all(inputspan).innerHTML+"<>"+id[1]);
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
            }
            else {
                document.all(inputname).value = '';
                if (isneed == '0') 
                    document.all(inputspan).innerHTML = '';
                else 
                    document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                
            }
        }
    }
    else {
        url = '/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
        var callback = function(){
            try {
                id = dialog.getFrameWindow().dialogValue;
            } 
            catch (e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    document.all(inputname).value = id[0];
                    WeaverUtil.fire(document.all(inputname));
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
                }
                else {
                    document.all(inputname).value = '';
                    if (isneed == '0') 
                        document.all(inputspan).innerHTML = '';
                    else 
                        document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                    
                }
            }
        }
        if (!win) {
            win = new Ext.Window({
                layout: 'border',
                width: Ext.getBody().getWidth() * 0.85,
                height: Ext.getBody().getHeight() * 0.85,
                plain: true,
                modal: true,
                items: {
                    id: 'dialog',
                    region: 'center',
                    iconCls: 'portalIcon',
                    xtype: 'iframepanel',
                    frameConfig: {
                        autoCreate: {
                            id: 'portal',
                            name: 'portal',
                            frameborder: 0
                        },
                        eventsFollowFrameLinks: false
                    },
                    closable: false,
                    autoScroll: true
                }
            });
        }
        win.close = function(){
            this.hide();
            win.getComponent('dialog').setSrc('about:blank');
            callback();
        }
        win.render(Ext.getBody());
        var dialog = win.getComponent('dialog');
        dialog.setSrc(url);
        win.show();
    }
   }

function parserRefParam(inputname,_fieldcheck){
		if(getValidStr(_fieldcheck)=="")
			return;
		strend = inputname.substring(38);
		spos = _fieldcheck.indexOf("$");
		while(spos != -1){
			epos = _fieldcheck.indexOf("$",spos+1);
			if (spos != -1 && epos != -1) {
				pname = _fieldcheck.substring(spos + 1, epos);
				pname = "field_"+pname+strend;
				pvalue = getValidStr(document.all(pname).value);
				_fieldcheck = _fieldcheck.substring(0,spos)+pvalue+_fieldcheck.substring(epos+1);
			}
			spos = _fieldcheck.indexOf("$",epos+1);
		}
		_fieldcheck = _fieldcheck.ReplaceAll("%27","'");
		spos = _fieldcheck.indexOf("sqlwhere=");
		var sqlwhere = "";
		if(spos !=-1){
			epos = _fieldcheck.indexOf("&",spos+1);
			if(epos ==-1){
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9);
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere;
				
			}else{
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9,epos);
				var etag = _fieldcheck.substring(epos);
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere+etag;
			}
		}
		return _fieldcheck;
	}

function getValidStr(str) {
	str+="";
	if (str=="undefined" || str=="null")
		return "";
	else
		return str;
}
var contextPath = '';
function onUrl(url,title,id,inactive,image){
	if(top){
		if(top.isUseNewMainPage() && typeof(top.onTabUrl) == 'function'){	//新页面打开tab页的方法
			top.onTabUrl(url,title,id,true);
		}else if(!top.isUseNewMainPage() && top.frames[1] && typeof(top.frames[1].onUrl)=='function'){	//现有页面打开tab页的方法
	        top.frames[1].onUrl(url,title,id,inactive,image);
	    }else{
	        var str = document.location.toString();
	        var httpstr = str.substring(0,str.lastIndexOf(":"));
	        str = str.substring(str.lastIndexOf(":"),str.length);
	        str = str.substring(0,str.indexOf("/"));
	        window.open(httpstr+str+contextPath+url);
	    }
	}else{
		var str = document.location.toString();
        var httpstr = str.substring(0,str.lastIndexOf(":"));
        str = str.substring(str.lastIndexOf(":"),str.length);
        str = str.substring(0,str.indexOf("/"));
        window.open(httpstr+str+contextPath+url);
	}
}

/*附件上传操作*/
function addAttach(attachid, attachname,type){
	/*
    var oDiv = f$("fileUploadDIV");
    var oPdf = f$("pdfUploadDIV");
    var href = "href='javascript:deleteaddattach(\"" + attachid + "\")'";
    var span = document.createElement("SPAN");
    span.style.margin="0 10 0 5";
    span.id = attachid;
    if("pdf"==type){
    	span.innerHTML = '<img src="/images/silk/accessory.gif" border="0">' + attachname + '<a style="margin:0 5 0 5;" title="删除" href="#" onclick = javascript:deleteaddattach("' + attachid + '","pdf");>删除</a>';
    	oPdf.appendChild(span);
    	f$("attachid").value = attachid;
    	f$("pdfUploadDIV").style.display = "";
    	f$("pdfDIV").style.display = "none";
    }else{
    	span.innerHTML = '<img src="/images/silk/accessory.gif" border="0">' + attachname + '<a style="margin:0 5 0 5;" title="删除" href="#" onclick = javascript:deleteaddattach("' + attachid + '");>删除</a>';
    	jQuery("#addattachid").value += attachid + ",";
    	oDiv.appendChild(span);
    }
    */
    jQuery("#addattachvalueid").val(attachid);
    jQuery("#addattachvalueid").attr("title",attachname);
    //jQuery("#addattachvalueid").attr("filetype",type);
    if(type=="null"||type==null||type==undefined){
    	type="";
    }
    openApp(document.getElementById("uploadIframe"+type).parentNode.parentNode,'upload');
}