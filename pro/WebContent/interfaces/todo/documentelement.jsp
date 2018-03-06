<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.security.util.PermissionUtil2"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.document.base.service.DocbaseService"%>
<%@page import="com.eweaver.base.log.service.LogService"%>
<%@page import="java.net.URLEncoder"%>
<%@ include file="/base/init.jsp"%>
<%

String categoryId = StringHelper.null2String(request.getParameter("categoryid"));

BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
SetitemService setitemService=(SetitemService)BaseContext.getBean("setitemService");
DocbaseService docbaseService=(DocbaseService)BaseContext.getBean("docbaseService");
PermissiondetailService permissiondetailService=(PermissiondetailService)BaseContext.getBean("permissiondetailService");
LogService logService =(LogService)BaseContext.getBean("logService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");

String basepath=BaseContext.getHttpbasepath();

Humres currentUser = BaseContext.getRemoteUser().getHumres();

Map<String,Object> map1=new HashMap<String,Object>();
Map data=new HashMap();
JSONObject jsonObj=new JSONObject();
jsonObj.put("showReply",0);
jsonObj.put("sqlWhere","");
jsonObj.put("categoryId",categoryId);//分类id
jsonObj.put("nCount",6);//显示条数
jsonObj.put("imgWidth",108);//图片宽度
jsonObj.put("titleAlign","left");//标题对齐方式
jsonObj.put("viewType",4);
jsonObj.put("isAbstract",0);//是否显示摘要
jsonObj.put("creatorWidth","20%");
jsonObj.put("createDateWidth","20%");
jsonObj.put("modifyDateWidth","20%");
jsonObj.put("isAuthor",0);//是否显示作者
jsonObj.put("isCreateDate",0);//是否显示创建日期
jsonObj.put("isModifyDate",0);//是否显示修改日期
jsonObj.put("titleLength",24);//标题长度
jsonObj.put("titleColors","");//标题颜色
jsonObj.put("abstractLength",50);//摘要长度
jsonObj.put("GraBpic",1);//是否抓取图片

Object obj=null;

obj=jsonObj.get("imgWidth");
int imgWidth=NumberHelper.string2Int(obj,108);
map1.put("imgWidth", imgWidth);
map1.put("imgHeight", (int)(imgWidth*0.75));

List<String> fieldsList=new ArrayList<String>();
fieldsList.add("subject");
fieldsList.add("creator");
fieldsList.add("createdate");
fieldsList.add("modifydate");

Map<String,String> fieldWidth=new HashMap<String,String>();
fieldWidth.put("creator",jsonObj.containsKey("creatorWidth")?jsonObj.get("creatorWidth").toString():"20%");
fieldWidth.put("createdate",jsonObj.containsKey("createDateWidth")?jsonObj.get("createDateWidth").toString():"20%");
fieldWidth.put("modifydate",jsonObj.containsKey("modifyDateWidth")?jsonObj.get("modifyDateWidth").toString():"20%");

if(!jsonObj.containsKey("isAuthor") || NumberHelper.string2Int(jsonObj.get("isAuthor"),0)!=1){
	fieldsList.remove("creator");//如果不显示创建者,则去除
	fieldWidth.remove("creator");
}
if(!jsonObj.containsKey("isCreateDate") || NumberHelper.string2Int(jsonObj.get("isCreateDate"),0)!=1){
	fieldsList.remove("createdate");
	fieldWidth.remove("createdate");
}
if(!jsonObj.containsKey("isModifyDate") || NumberHelper.string2Int(jsonObj.get("isModifyDate"),0)!=1){
	fieldsList.remove("modifydate");
	fieldWidth.remove("modifydate");
}
String[] widths=MapHelper.getMapValues(fieldWidth);
int width=100;
for(String w:widths){
	width-=NumberHelper.string2Int(w.replace("%",""), 20);
}
fieldWidth.put("subject", (width<=0)?"50%":width+"%");

map1.put("fields",fieldsList);
map1.put("fieldsCount",fieldsList.size());
map1.put("fieldWidth", fieldWidth);

String titleAlign="left";
if(jsonObj.containsKey("titleAlign"))
	titleAlign=jsonObj.get("titleAlign").toString();
map1.put("titleAlign", titleAlign);

int viewType=1;
obj=jsonObj.get("viewType");
if(obj!=null) viewType=Integer.valueOf(obj.toString());
map1.put("viewType", viewType);

obj=jsonObj.get("titleLength");
int titleLength=NumberHelper.string2Int(obj,24);

String titleColors = StringHelper.null2String(jsonObj.get("titleColors"));
String[] titleColorArray;
if(StringHelper.isEmpty(titleColors)){	//未设置颜色,默认使用黑色
	titleColorArray = new String[]{"#000"}; 
}else{
	titleColorArray = titleColors.split(",");
}
int colorIndex = 0;
map1.put("titleColors", titleColors);

obj=jsonObj.get("abstractLength");
int abstractLength=NumberHelper.string2Int(obj,100);

obj=jsonObj.get("isAbstract");
int isAbstract=NumberHelper.string2Int(obj,0);
map1.put("isAbstract",isAbstract);

obj=jsonObj.get("GraBpic");
int GraBpic=NumberHelper.string2Int(obj,0);
map1.put("GraBpic",GraBpic);

List<Map> list1 = new ArrayList();

StringBuffer sql=new StringBuffer("select id,subject,docabstract,doctype,content,createdate,modifydate,creator from docbase where isdelete=0 and 1=1 ");
int showReply=NumberHelper.getIntegerValue(jsonObj.get("showReply"),0);
if(showReply!=1)sql.append(" and pid is null ");//不搜索回复的文档.

String paramSqlWhere = StringHelper.null2String(jsonObj.get("sqlWhere"));
if(!"".equals(paramSqlWhere)){
	sql.append(" "+paramSqlWhere+" ");
}

obj=jsonObj.get("categoryId");
String catWhere="";
if(obj!=null && !StringHelper.isEmpty(obj.toString())){
	catWhere = SQLMap.getSQLString("org.light.portlets.DocbasePortlet.getDocbaseList",new String[]{obj.toString()});
	sql.append(" and "+catWhere);
}
sql.append(" order by createDate desc,createTime desc ");

String strSql = sql.toString();
strSql = strSql.replace("$currentuser$", currentUser.getId());
strSql = strSql.replace("$currentorgunit$", currentUser.getOrgid());
strSql = strSql.replace("$currentdate$", DateHelper.getCurrentDate());
   strSql = strSql.replace("$currenttime$", DateHelper.getCurrentTime());
   sql = new StringBuffer(strSql);

obj=jsonObj.get("nCount");
int rowNum=NumberHelper.string2Int(obj,10);

String[] sqls=PermissionUtil2.getPermissionSql2(sql.toString(), "docbase",new ArrayList());
String[] params=new String[]{};
if(!StringHelper.isEmpty(sqls[1])){//对Sysadmin查询时缺少参数进行填充
	params=sqls[1].split(",");
}

Page page2=baseJdbcDao.pagedQuery(sqls[0],0,rowNum,params);
if(page2.getTotalSize()>0){
	list1=(List)page2.getResult();
}

boolean isShowDocCount=false;
Setitem setitem=setitemService.getSetitem("82bb8269e5054f449bfd82a68cf85287");
isShowDocCount=(setitem!=null && "1".equalsIgnoreCase(setitem.getItemvalue()));

int docCount=0;
if(isShowDocCount){
	String sqlWhere=sql.toString();
	int pos=sqlWhere.indexOf(" from ");
	sqlWhere=sqlWhere.substring(pos);
	pos=sqlWhere.toLowerCase().lastIndexOf(" order by ");
	if(pos>0) sqlWhere=sqlWhere.substring(0,pos);
	int righttype = permissiondetailService.getOpttype("402880321ce00d9c011ce019ae0e0002");//文档报表
    if (righttype % 15 == 0) {
    	String tmpSql ="select count(*) as nums "+sqlWhere;
    	docCount=baseJdbcDao.getJdbcTemplate().queryForInt(tmpSql);
    }else{
    	docCount=page2.getTotalSize();
    }
    data.put("docCount", docCount);
	String sql2="select count(id) "+sqlWhere+" and id in (select distinct objid from Log "+ 
	"where submitor= '"+BaseContext.getRemoteUser().getId()+"')";
	int isread=baseJdbcDao.getJdbcTemplate().queryForInt(sql2);
	int unread=(docCount-isread);
	if(unread<0) unread=0;
	data.put("unread",unread);
}

List<Map> list2=new ArrayList<Map>();
Map<String,Object> m=null;
HtmlTextHelper hth=null;
String currentUserId=currentUser.getId();
String[] allFlashImgs={"",""};
for(Map doc:list1){
	m=new HashMap<String,Object>();
	String val=null;
	for(String field:fieldsList){
		String docid=StringHelper.null2String(doc.get("id"));
		if(field.equalsIgnoreCase("id")){
			m.put("id",docid);
		}else if(field.equalsIgnoreCase("subject")){
			m.put("id",doc.get("id"));
			m.put("title",doc.get("subject"));
			String _subject=StringHelper.null2String(doc.get("subject"));
			String _title=(_subject.length()>titleLength)?_subject.substring(0,(int)titleLength)+"...":_subject;
			String titleColor = titleColorArray[colorIndex++];
			if(colorIndex == titleColorArray.length){ colorIndex = 0; }
			String porname = URLEncoder.encode((String)doc.get("subject"),"UTF-8");
			val="<a title='"+doc.get("subject")+"' style='color:"+titleColor+"' href=\"javascript:onUrl('/document/base/docbaseview.jsp?id=" + doc.get("id") +"','"+_subject+ "','tab"+doc.get("id")+"')\" >"+_title+"</a>";
			String iconNew="<img src=\""+request.getContextPath()+"/images/doc/new.gif\"/>";
			if (logService.hasLog(docid, currentUserId)
                    || currentUserId.equalsIgnoreCase(StringHelper.null2String(doc.get("creator")))){
				iconNew="";
            }

			val+=iconNew;
			m.put("subject",val);
			if(viewType==2 || viewType==3 || viewType==4){
				
				String _content = StringHelper.null2String(doc.get("content"));
				//String[] flashImgs=docbaseService._getImageUrls(_content, "https://localhost:8442/main/main.jsp?portltype=docbaseview&amp;portlid="+ doc.get("id")+"&amp;portltabid=tab"+doc.get("id")+ "&amp;portlname="+porname,imgWidth,GraBpic);
				String[] flashImgs=docbaseService._getImageUrls(_content, "",imgWidth,GraBpic);
				if(viewType==4||viewType==3){
					if(flashImgs!=null){
						allFlashImgs[0]+="|"+flashImgs[0];
						allFlashImgs[1]+="|"+flashImgs[1];
					}
				}else{
					if(flashImgs==null){
						flashImgs=new String[]{BaseContext.getContextpath()+"/images/base/comHeader.jpg","/document/base/docbaseview.jsp?id="+doc.get("id")};
					}
					String tmp="pics="+flashImgs[0]+"&links="+flashImgs[1]+"&borderwidth="+imgWidth+"&borderheight="+(int)(imgWidth*0.75)+"&text="+val;
					m.put("flashImgs", tmp);
				}
				
				String _abstract="";
				if(isAbstract==1){//表示显示摘要
					_abstract =  StringHelper.null2String(doc.get("docabstract"));
                    if(_abstract.length()>abstractLength)
                       _abstract=_abstract.substring(0,(int)abstractLength)+"..." ;
				}
				m.put("abstract", _abstract);
			}//end if.
		}else if(field.equalsIgnoreCase("createdate")){
			m.put("createdate",StringHelper.null2String(doc.get("createdate")));
		}else if(field.equalsIgnoreCase("modifydate")){
			m.put("modifydate",StringHelper.null2String(doc.get("modifydate")));
		}else if(field.equalsIgnoreCase("creator")){
			String creatorName=humresService.getHrmresNameById(StringHelper.null2String(doc.get("creator")));
			m.put("creator","<a href=\"javascript:onUrl('/humres/base/humresview.jsp?id=" + doc.get("creator") +"','"+creatorName+ "','tab"+doc.get("creator")+"')\" >"+creatorName+"</a>");
		}//end if.
	}
	list2.add(m);
}
if(allFlashImgs[0].length()>0)allFlashImgs[0]=allFlashImgs[0].substring(1);
else allFlashImgs[0]=BaseContext.getContextpath()+"/images/base/comHeader.jpg";
if(allFlashImgs[1].length()>0)allFlashImgs[1]=allFlashImgs[1].substring(1);
else allFlashImgs[1]="";
if(viewType==4){
	map1.put("flashImgs", "pics="+allFlashImgs[0]+"&links="+allFlashImgs[1]+"&borderwidth="+imgWidth+"&borderheight="+(int)(imgWidth*0.75));
}else if(viewType==3){
	map1.put("flashImgs", "pics="+allFlashImgs[0]+"&links="+allFlashImgs[1]+"&borderwidth="+imgWidth+"&borderheight="+(int)(imgWidth/0.75));
}
map1.put("list1", list2);
map1.put("rows",list1.size());

if(isShowDocCount){
	map1.put("docCount", NumberHelper.getIntegerValue(data.get("docCount"), 0));
	String _moreUrl=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&reportid=402880321ce00d9c011ce019ae0e0002&con4028819b124662b301124662b7310356_value="+StringHelper.null2String(jsonObj.get("categoryId"));
	map1.put("moreUrl",_moreUrl);
	map1.put("unread", NumberHelper.getIntegerValue(data.get("unread"), 0));
}
%>
<html>
  <head>
</head>
  
  <body>
<table border="0" align="center" width="100%" class="Econtent" cellspacing="1">
<tr>
<td width="<%=map1.get("imgWidth")%>"  style="vertical-align:top;padding-top:5px;">
<div style="">
<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="<%=request.getContextPath()%>/plugin/swflash.cab#version=6,0,0,0" width='<%=map1.get("imgWidth")%>' height='<%=map1.get("imgHeight")%>'>
    <param name="allowScriptAccess" value="sameDomain"/>
    <param name="movie" value="<%=request.getContextPath()%>/images/base/playswf.swf"/>
    <param name="wmode" value="transparent"/>
    <param name="quality" value="high"/>
    <param name="menu" value="false"/>
    <param name="wmode" value="opaque"/>
    <param name="FlashVars" value='<%=map1.get("flashImgs")%>'/>
    <EMBED src="<%=request.getContextPath()%>/images/base/playswf.swf"
    	 allowScriptAccess="sameDomain" 
         FlashVars='<%=map1.get("flashImgs")%>'
         quality="high" menu="false" wmode="transparent" wmode="opaque"
         width='<%=map1.get("imgWidth")%>'
		 height='<%=map1.get("imgHeight")%>'
         TYPE="application/x-shockwave-flash" 
         PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer" />
</object>
</div>
</td>
<td valign="top" style="vertical-align:top;">
<!-- Table.Start -->
<table width="100%" cellspacing="1">
<%
if(list2!=null&&list2.size()>0){
	for(int i=0;i<list2.size();i++){
		Map map=list2.get(i);
		%>
		<tr><td class="itemIcon" width="20">&nbsp;</td>
		<%
		for(int j=0;j<fieldsList.size();j++){
			String f=fieldsList.get(j);
			%>
			<td class="f" align="<%=map.get("titleAlign")%>" width="<%=fieldWidth.get(f)%>%">
				<%=map.get(f)%>
			</td>
		<%
		}
		%>
		</tr>
		<%
		if(isAbstract==1){
			%>
			<tr><td colspan="<%=NumberHelper.string2Int(map1.get("fieldsCount"),0)+1%>"><div class="docAbstract" style="border:0"><label style="color:gray"><%=map.get("abstract")%></label></div></td></tr>
			<%
		}
		if(i<list2.size()-1){
			%>
			<tr height="1"><td class="line" colspan='<%=NumberHelper.string2Int(map1.get("fieldsCount"),0)+1%>'></td></tr>
			<%
		}
	}
}else{
	%>&nbsp;<%=labelService.getLabelNameByKeyId("4028836a366236d30136623cf71b0067")%><%
}
%>
</table>
<!-- Table -->
</td>
</tr>
</table>
<!-- ##合图式End## -->
<%if(NumberHelper.string2Int(map1.get("docCount"),0)>0){
	%>
	<div align="right"><a href="javascript:onUrl('<%=map1.get("moreUrl")%>','文档元素列表','DocbasePortletMore');"/>更多(<span title="未读/文档总数"><%=map1.get("unread")%>/<%=map1.get("docCount")%></span>)...</a>&nbsp;&nbsp;&nbsp;</div>
	<%
}%>
</body>
</html>
