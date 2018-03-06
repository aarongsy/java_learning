<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Properties" %>
<link href="/js/swfupload/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers.js"></script>

	<script type='text/javascript' src='/messager/resource-cn.js'></script>

<%-- ****************************判断文件是否符合上传格式 start***********************************--%>
    <%
         Properties mapping = new Properties();
         InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("im.properties");
         try {
             mapping.load(inputStream);
         } catch (Exception e) {
             //log.error(e);
         }
         Enumeration keys = mapping.keys();
         String fileUploadType = "";
         while (keys.hasMoreElements()) {
            String col = (String) keys.nextElement();
            if (col.indexOf("fileUploadType") > -1)
            	fileUploadType = mapping.getProperty(col);
         }
    %>
<%--****************************判断文件是否符合上传格式 end***********************************--%>
<style>
.progressContainer,.red,.green,.blue  {
	
	border-left:0px;
	border-right:0px;
	border-top:0px;
}</style>
<script language="javascript">

FileProgress.prototype.setComplete = function () {
	this.fileProgressElement.className = "progressContainer blue";
	this.fileProgressElement.childNodes[3].className = "progressBarComplete";
	this.fileProgressElement.childNodes[3].style.width = "";
};

function getUploader(objWindow,windowid,sendTo){
	var oUploader=null;
	try{
		var settings = {
			flash_url : "/js/swfupload/swfupload.swf",
		    post_params: {
		        "isNeedCreateDoc": "0",
		        sendTo:sendTo
		    },        
			upload_url: "/messager/DocUploader.jsp?filesize="+Config.FileSize+"&filetype=<%=fileUploadType%>",
			file_size_limit : Config.MaxUploadImageSize+" MB",
			file_types : "*.*",
			file_types_description : "All Files",
			file_upload_limit : "50",
			file_queue_limit : "0",
			custom_settings : {
				index:1
				//progressTarget : "fsUploadProgress_"+windowid				
			},
			debug: false,
			
			button_image_url : "/messager/images/add.png",	// Relative to the SWF file
			button_placeholder_id : "btnSelectedAcc_"+windowid,
	
			button_width: 125,
			button_height: 18,
			button_text : '<span class="button">'+rMsg.sendAccs+'('+Config.FileSize+' MB)</span>',
			button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
			button_text_top_padding: 0,
			button_text_left_padding: 18,
				
			button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
			button_cursor: SWFUpload.CURSOR.HAND,
			
			//file_queued_handler : fileQueued,
			file_queued_handler : function(file) {
				try {
					var roundNum=new Date().getTime();
					var divUploadId="fsUploadProgress_"+windowid+"_"+roundNum;
					objWindow.setCusData("divUploadId",divUploadId);
					var divUploaderShow="<div class='fieldset flash' id='"+divUploadId+"' style='width:220px;overflow:auto;'/>" ;					
					objWindow.showMessage(divUploaderShow,"me");
					
					
					var progress = new FileProgress(file,divUploadId);
					progress.setStatus("Pending...");
					progress.toggleCancel(true, this);
					
				} catch (ex) {
					this.debug(ex);
				}

			},
			file_queue_error_handler : fileQueueError,
			file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){		
				if (numFilesSelected > 0) {		
					/*if(window.confirm("s?")){
						this.settings.post_params.isNeedCreateDoc="1";
						alert(this.settings.post_params.isNeedCreateDoc)
					}	*/					
					
					this.startUpload();						
				}
			},
			upload_start_handler : uploadStart,
			upload_progress_handler : uploadProgress,			
			upload_error_handler : uploadError,
			queue_complete_handler : queueComplete,
	
			upload_success_handler : function (file, server_data) {	
			    if (file==null || file.name==null || file.name == "") return;
			    var suffix = file.name.substring(file.name.lastIndexOf(".")+1).toLowerCase().trim();
			    if ("<%=fileUploadType%>".indexOf(suffix) != -1) {
			        var divUploadId=objWindow.getCusData("divUploadId");
					  var progress = new FileProgress(file, divUploadId);
					  progress.setError();
					 progress.setStatus(rMsg.messagetype);
					  progress.toggleCancel(false);
			    } else {
					eval("var data="+$.trim(server_data));
					if(data.value=="0"){ 
					  //alert(rMsg.messagesize); 
					  //uploadError(file,-250,rMsg.messagesize);
					  var divUploadId=objWindow.getCusData("divUploadId");
					  var progress = new FileProgress(file, divUploadId);
					  progress.setError();
					 progress.setStatus(rMsg.messagesize);
					  progress.toggleCancel(false);
					} else {		
						var strSend="";
						if(data.type=="docid"){
							strSend="<div style='border-bottom:1px solid #CEE2F2;margin:3;padding:3;background:#F0F5FF;width:220px;word-break:break-all' class='messagerA'>"+rMsg.sendFile+
							file.name+"<br><a href='void(0)' onClick='window.open(\"/docs/docs/DocDsp.jsp?id="+data.value
							+"&download=1&isOpenFirstAss=1\");return false'>"+rMsg.clickDownload+"</a><br>("+rMsg.fileShareToYou+")</div>";
						} else {
							strSend="<div style='border-bottom:1px solid #CEE2F2;margin:3;padding:3;background:#F0F5FF;width:220px;word-break:break-all' class='messagerA'>"+rMsg.sendFile+
							file.name+"<br><a href='void(0)' onClick='window.open(\"/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+(data.value).trim()
							+"&isdownload=1\");return false'>"+rMsg.clickDownload+"</a><br>("+rMsg.onlySaveOneDay+")</div>";
						}	
		
						ControlWindow.getWindow(sendTo).send(strSend,false);
						//sendMessage(sendTo,strSend);				 
		
						var divUploadId=objWindow.getCusData("divUploadId");
						var progress = new FileProgress(file, divUploadId);
						progress.setComplete();
						progress.setStatus("Complete.");
						progress.toggleCancel(false);
					}
				}
			},				
			upload_complete_handler : function(file){			
				try {
					if (this.getStats().files_queued == 0) {									
						//alert('done')	
						//$("#fsUploadProgress_"+windowid).fadeOut("slow");
					} else {	
						this.startUpload();
					}
				} catch (ex) { alert(ex); }
			}
		};
		oUploader = new SWFUpload(settings);
	} catch(e){alert(e)}
	return oUploader;
}




function flashChecker() {
	var hasFlash = 0; //
	var flashVersion = 0; //
	var isIE = /*@cc_on!@*/0; //

	if (isIE) {
		var swf = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
		if (swf) {
			hasFlash = 1;
			VSwf = swf.GetVariable("$version");
			flashVersion = parseInt(VSwf.split(" ")[1].split(",")[0]);
		}
	} else {
		if (navigator.plugins && navigator.plugins.length > 0) {
			var swf = navigator.plugins["Shockwave Flash"];
			if (swf) {
				hasFlash = 1;
				var words = swf.description.split(" ");
				for ( var i = 0; i < words.length; ++i) {
					if (isNaN(parseInt(words[i])))
						continue;
					flashVersion = parseInt(words[i]);
				}
			}
		}
	}
	return {
		f :hasFlash,
		v :flashVersion
	};
}
var fls = flashChecker();
var flashversion = 0;
if (fls.f) {
	flashversion = fls.v;
}
if (flashversion < 9){
	alert("qq!")
}
</script>
<div id="divStatus" style="display:none"></div>