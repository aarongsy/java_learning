
<script>
//用以Messager的配置信息
var wmServer="127.0.0.1";//222.66.55.190
//var wmServer="zengdongping"
var Config={	
	SITENAME:wmServer,  //资源显示名
	
	//SITENAME:"222.66.55.190", 
	JABBERSERVER:wmServer, //主机名
	//JABBERSERVER:"222.66.55.190", //主机名
	
	DEBUG_LVL:2, //默认调试级别  0..4 (4 = very noisy)
	DEFAULTPRIORITY:10,//默认人连接优先权	
	DEFAULTCONFERENCEROOM : "talks",
	DEFAULTCONFERENCESERVER: "conference."+wmServer,	
	HTTPBASE: "/JHB/",
	AlertFlag:"|[|(alert)|]|",	
	FocusFlag:"|[|(focus)|]|",
	BlurFlag:"|[|(blur)|]|",
	OnlineFlag:"|[|(online)|]|",
	TIMERVAL: "<%=300*1000%>",	
	TIMERVALFORMSG:"<%=60*1000%>",		
	TIMERVALFORRECONNECT:"<%=5*1000%>",	
	MessageWindowHeight:'400',
	MessageWindowMaxHeight:'400',
	MessageWindowWidth:'550',
	ChatWindowHeight:'150',
	ChatWindowWidth:'340',
	MaxUploadImageSize:"2000",
	FileSize : "5",

		initOnlineUsrNumMax : 50,
		target : 'current', //parent current
		ObjectWindow : window,

		msgRecordInterval : 15,
		USE_DEBUGJID : true, // 此属性为Ture是才能使用DEBUGJID用户得到调试信息
		DEBUGJID : "sysadmin@" + wmServer // 能得到调试信息的用户

	}
</script>