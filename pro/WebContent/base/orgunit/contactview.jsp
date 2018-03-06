<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.eweaver.base.security.model.Sysuser"%>
<%@page import="com.eweaver.base.security.dao.SysuserDao"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%
	String oid = request.getParameter("id");
	String letter = request.getParameter("letter");
%>

<head>

<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js" ></script>
<script type="text/javascript" language="javascript" src="/js/main.js" ></script>
<script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%=request.getContextPath()%>/dwr/util.js'></script>
<script  type='text/javascript' src='/js/workflow.js'></script>
<script  type='text/javascript' src='/app/js/jquery.js'></script>
<script  type='text/javascript' src='/js/rtxint.js'></script>
<script type="text/javascript">
	function searchByLetter(letter){
		location.href="/base/orgunit/contactview.jsp?id=<%=oid%>&letter="+letter;
	}
	
</script>
<script type="text/javascript">
	function deptorientation(id) {
       var td = event.srcElement;
       var x = 0;
       x = event.clientX;
       var y = 0;
       y = event.clientY;
       if (x > 570) {
           x = 570;
        } 
       var sql = "select (select OBJNAME from STATIONINFO where id=h.Mainstation) as zhiwu,exttextfield9 from humres h where id='"+id+"'";
	   DWREngine.setAsync(false);
       DataService.getValues(sql,{
        callback : function(data) {
           var d = data.length;
           if (d > 0) {
              document.all("meetRoomInfoid").style.cssText = 
                  "border: 1px solid #b7b4b0;width:180px;height:50px;position:absolute;" + 
                  "background-color:#f5f4ed;z-index:99;left:"+(x+10)+"px;top:"+(y+10)+"px;";
              	var mriText = document.all("meetRoomInfoid") ;
                mriText.innerHTML = "<p style='padding-left:10px;padding-top:10px;'>职务："+data[0].zhiwu+"</p>";
                mriText.innerHTML += "<p style='padding-left:10px;'>标签："+(data[0].exttextfield9==null?"":data[0].exttextfield9)+"</p>";
           }
        }
       });
       DWREngine.setAsync(true);
     }
     
     function roomoutevent() {
       document.all("meetRoomInfoid").style.cssText = "display:none;";;
    }
</script>
</head>

<body>
<div id="meetRoomInfoid"></div>
  <form action="exportExcel.jsp" style="display:none" id="exceptform" name="exceptform" target="exportframe">
	<input type="text" id="reportsql" name="reportsql" style="display:none"></input>
  </form> 
<iframe id="exportframe" name="exportframe" style="display:none"></iframe>  
<%
			DataService dataService = new DataService();
			BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
			String sql="select c.id,c.aid,h.id as zid,c.dept_name,c.kpi_name,h.objname as zz_name,c.col1"+
				" from (select o.id,a.id as aid,o.objname as dept_name, a.objname as kpi_name, o.col1, o.zzcol1"+
				" from (select t.id,t.objname, t.col2, l.col1, t.col1 as zzcol1 from orgunit t, orgunitlink l"+
                " where t.id = '"+oid+"'   and t.id = l.oid) o left join attach a on a.id = o.col2) c"+
				" left join attach h on h.id = c.zzcol1";
			List menumaplist=baseJdbcDao.executeSqlForList(sql);
			Map menumap = new HashMap();
			if(menumaplist.size()>0){
				menumap = (Map)menumaplist.get(0);
			}
			
			String col1=StringHelper.null2String(menumap.get("col1"));
			String dept_name=(String)menumap.get("dept_name");
			String kpi_name=(String)menumap.get("kpi_name");
			String zz_name=(String)menumap.get("zz_name");
			if(!StringHelper.isEmpty(kpi_name) && kpi_name.indexOf(".")>0 ){
				kpi_name=kpi_name.substring(0,kpi_name.indexOf("."));
			}
			if(!StringHelper.isEmpty(zz_name) && zz_name.indexOf(".")>0 ){
				zz_name=zz_name.substring(0,zz_name.indexOf("."));
			}
			String kpi_id=(String)menumap.get("aid");
			String zz_id=(String)menumap.get("zid");
			String sql2=null;
			String exportSql1="select h.id,o.objname as dept_name,h.objname as name,s.objname as sta_name,h.tel1,h.tel2,h.email from HUMRES h, ORGUNIT o, STATIONINFO s where h.id IN(";
			String exportSql2=") AND h.ISDELETE = 0 AND o.ID = h.ORGID AND s.ID = h.MAINSTATION ";
			if(StringHelper.isEmpty(letter)){
				/*sql2 = " select h.id,h.extattachfield2,sta_orgid,o.objname as dept_name,h.objname as name,sta_name,h.tel1,h.tel2,h.email,sta_id";
				sql2+= " from (select h1.*,s1.objname as sta_name,s1.orgid as sta_orgid,s1.id as sta_id from humres h1, stationinfo s1 where h1.station like '%' "+SqlHelper.getConcatStr()+" s1.id "+SqlHelper.getConcatStr()+" '%'  and s1.orgid in ";
				sql2+= " (select OID from ORGUNITLINK where COL1 LIKE '%"+col1+"%')";
				sql2+= " and s1.isdelete < 1) h,ORGUNIT o where 1 = 1 and h.ISDELETE = 0  AND o.ID = h.sta_orgid ";*/
				
				sql2= "select h.*,s1.objname as sta_name,s1.orgid as sta_orgid,s1.id as sta_id,o.objname as dept_name from humres h, stationinfo s1,ORGUNIT o where h.mainstation = s1.id and h.orgid = o.id and s1.orgid in ";
				sql2+= " (select OID from ORGUNITLINK where COL1 LIKE '%"+col1+"%')";
				sql2+= " and s1.isdelete < 1 and h.ISDELETE = 0 and h.HRSTATUS='4028804c16acfbc00116ccba13802935' ";
			}else{
				/*sql2=" select h.id,h.extattachfield2,h.sta_orgid,o.objname as dept_name,h.objname as name,h.sta_name,h.tel1,h.tel2,h.email,sta_id ";
				sql2+=" from (select h2.*,s1.orgid as sta_orgid,s1.id as sta_id,s1.objname as sta_name,s1.id as sta_id from humres h2, sysuser y, stationinfo s1 ";
				sql2+=" where h2.id = y.objid and h2.ISDELETE = 0 and substr(lower(y.longonname), 0, 1) = lower('"+letter+"')) h, ";
				sql2+=" ORGUNIT o where 1 = 1 and h.ISDELETE = 0 AND o.ID = sta_orgid";*/
				sql2=" select h.*,s1.orgid as sta_orgid,s1.id as sta_id,s1.objname as sta_name,o.objname as dept_name from humres h, sysuser y, stationinfo s1,ORGUNIT o  ";
				sql2+=" where h.id = y.objid and h.mainstation = s1.id and h.orgid = o.id and h.ISDELETE = 0 and h.HRSTATUS='4028804c16acfbc00116ccba13802935' ";
				if(dbtype.equals(SQLMap.DBTYPE_ORACLE)){
		    		sql2+=" and substr(lower(y.longonname), 0, 1)= lower('"+letter+"')";
		        }else if(dbtype.equals(SQLMap.DBTYPE_SQLSERVER)){
		        	sql2+=" and substring(lower(y.longonname), 1, 1)= lower('"+letter+"')";
		        }
				sql2+=" and s1.orgid in(select OID from ORGUNITLINK where COL1 LIKE '%"+col1+"%')";
				//sql2+="  and h.station like '%' "+SqlHelper.getConcatStr()+" s1.id "+SqlHelper.getConcatStr()+" '%' ";
			}
			int pagesize = NumberHelper.string2Int(request.getParameter("pagesize"),20);
            int pageno = NumberHelper.string2Int(request.getParameter("pageno"),1);
            //sql2+=" ORDER BY O.DSPORDER,H.DSPORDER,H.OBJNO"; 		
            Page pageObject = dataService.pagedQuery(sql2,pageno,pagesize);
			List list = new ArrayList();
            if(pageObject.getTotalSize()!=0){            	
            	list = (List) pageObject.getResult();
            }
           sql = StringHelper.getEncodeStr(sql);
%>

		<div class="tableWrap" >
			<div class="cpt" style="height:100%;">
		<%
			if(!"".equals(StringHelper.null2String(dept_name))){
			
		%>
				<strong><%=StringHelper.null2String(dept_name)%>
				</strong><br />
		<%	
			}
		 %>
                
               
				<strong style="float:inherit">
						<a href="javascript:searchByLetter('');">All</a>		
						<a href="javascript:searchByLetter('A');">A</a> <a href="javascript:searchByLetter('B');" style="padding-left:6px">B</a> <a href="javascript:searchByLetter('C');" style="padding-left:6px">C</a> <a href="javascript:searchByLetter('D');" style="padding-left:6px">D</a>
						<a href="javascript:searchByLetter('E');" style="padding-left:6px">E</a> <a href="javascript:searchByLetter('F');" style="padding-left:6px">F</a> <a href="javascript:searchByLetter('G');" style="padding-left:6px">G</a> <a href="javascript:searchByLetter('H');" style="padding-left:6px">H</a>
						<a href="javascript:searchByLetter('I');" style="padding-left:6px">I</a> <a href="javascript:searchByLetter('J');" style="padding-left:6px">J</a> <a href="javascript:searchByLetter('K');" style="padding-left:6px">K</a> <a href="javascript:searchByLetter('L');" style="padding-left:6px">L</a>
						<a href="javascript:searchByLetter('M');" style="padding-left:6px">M</a> <a href="javascript:searchByLetter('N');" style="padding-left:6px">N</a> <a href="javascript:searchByLetter('O');" style="padding-left:6px">O</a> <a href="javascript:searchByLetter('P');" style="padding-left:6px">P</a>
						<a href="javascript:searchByLetter('Q');" style="padding-left:6px">Q</a> <a href="javascript:searchByLetter('R');" style="padding-left:6px">R</a> <a href="javascript:searchByLetter('S');" style="padding-left:6px">S</a> <a href="javascript:searchByLetter('T');" style="padding-left:6px">T</a>
						<a href="javascript:searchByLetter('U');" style="padding-left:6px">U</a> <a href="javascript:searchByLetter('V');" style="padding-left:6px">V</a> <a href="javascript:searchByLetter('W');" style="padding-left:6px">W</a> <a href="javascript:searchByLetter('X');" style="padding-left:6px">X</a> 
						<a href="javascript:searchByLetter('Y');" style="padding-left:6px">Y</a> <a href="javascript:searchByLetter('Z');" style="padding-left:6px">Z</a>
				</strong>
				 <div class="float_r" style="padding:0px 0px 0px 0px;">
					<!-- <a href="javascript:void(0)" class="btnStartSign" onclick=""><span>同步到手机</span></a> -->
<%--                    <a href="/workflow/request/workflowprintview.jsp" class="btnStartSign" target="_blank"><span>打印</span></a>--%>
					<!-- <a href="javascript:exportExcel();" class="btnStartSign" onclick=""><span>导出</span></a> -->
                </div>
            </div>
		</div>
	<form action="" id="EweaverForm" name="EweaverForm" method="post">        
		<input type="hidden" name="letter" value="<%=letter %>"/>  
		<input type="hidden" name="id" value="<%=oid %>"/> 		
            <div class="tableWrap" style="margin: 10px 0 0 1px;">                
                <dl class="tabC" id="tabC_1">
                    <dd class="cont" style="display:block">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr class="bg">
							  <th width="5%" align="left" scope="col"><input type="checkbox" id="checkall" onclick="javascript:checkAll(this,'checkone');"></input></th>
                              <th width="15%" scope="col">部门</th>
                              <th width="10%" scope="col">姓名</th>
                              <th width="20%" scope="col">职务</th>
							  <th width="10%" scope="col">电话</th>
							  <th width="10%" scope="col">手机</th>
							  <th width="15%" scope="col">EMAIL</th>
<%--							  <th width="15%" scope="col">我的职责及KPI</th>--%>
                          </tr>
                          <%
                          HumresService humresService = (HumresService)BaseContext.getBean("humresService");
							SysuserDao sysuserDao = (SysuserDao)BaseContext.getBean("sysuserDao");
							for (int i = 0; i < list.size(); i++) {
								Map map = (Map)list.get(i);
								
								Humres humres = humresService.getHumresById(StringHelper.null2String(map.get("id")));
								String html="";
								if(humres!=null&&humres.getId()!=null){
									html="<a href='/humres/base/humresview.jsp?id="+humres.getId()+"' target='_blank'>"+humres.getObjname()+"</a>";
									if(humresService.useRTX()){
										Sysuser user = sysuserDao.getSysuserByObjid(humres.getId());
								    	String rtxNo = "";
								    	if(user != null)
								    		rtxNo = user.getLongonname();
								    		if(!StringHelper.isEmpty(rtxNo) && humresService.useRTX())
								    			html += (new StringBuilder("<img onmouseout='roomoutevent()' onmouseover=\"deptorientation('"+StringHelper.null2String(map.get("id"))+"')\" style=\"padding-left:2px\" align=\"absbottom\" width=16 height=16 src=\"")).append(BaseContext.getContextpath()).append("/rtx/images/blank.gif\" onload=\"RAP('").append(rtxNo).append("');\">").toString();
									}
								}
								if(i%2==0){
						  %>
                          <tr>
                          <%}else{%>
						  <tr class="bg">
						  <%}%>
							  <td width="5%"><input type="checkbox" sta="<%=StringHelper.null2String(map.get("sta_id"))%>" name="checkone" value="<%=StringHelper.null2String(map.get("id"))%>"></input></td>
                              <td width="15%"  ><%=StringHelper.null2String(map.get("dept_name"))%></td>
                              <td width="10%" >
                              		<%=html%>
                              </td>
                              <td width="20%"><%=StringHelper.null2String(map.get("sta_name"))%></td>
							  <td width="10%"><%=StringHelper.null2String(map.get("tel1"))%></td>
							  <td width="10%"><a href="#"><!--%=StringHelper.null2String(map.get("tel2"))%--></a></td>
							  <td width="15%"><a href="mailto:<%=StringHelper.null2String(map.get("email"))%>"><%=StringHelper.null2String(map.get("email"))%></a></td>
<%--							  <td width="15%" align="center"><%if(!StringHelper.isEmpty(StringHelper.null2String(map.get("extattachfield2")))){%><a href="/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=StringHelper.null2String(map.get("extattachfield2")).substring(0,32)%>&download=1&nIndex=1" target="_blank">查看</a><%}else{%>--<%}%></td>--%>
                          </tr>
                          <%}%>
                        </table>
                    </dd>
            </div>

<style>
/* --分页按钮及功能-- */
.page { text-align: center; margin-top: 18px; color: #999;}
.page .pagelink {display: inline-block; width: 500px; float: none; clear: both;height: 40px;vertical-align:middle;text-align: center; }
.page .pagelink span { float: left;}
.page .pagelink a { float:left; display: inline-block; margin: 0 3px; height: 19px; line-height: 19px; padding: 0 7px; border: solid 1px #e0e0e0; color: #999; font-family: Verdana, Arial; overflow:hidden;text-align: center;display: block;}
.page .pagelink a:link, .page a:visited, .page a:active {color: #999;}
.page .pagelink a.now { color: #c83e31;}
.page .pagelink a:hover { text-decoration: none; color: #c83e31;}
.page .pagelink a.prev { background: url(../../images/application/ico_page_arrow.gif) center 4px no-repeat;}
.page .pagelink a.next {padding-right: 15px; background: url(../../images/application/ico_page_arrow.gif) 45px -15px no-repeat;}
.page .pageFunction { display: inline; position:relative; top: -7px; float: none; clear: both;}
.page .pageFunction .jumpNum { width: 13px; margin: 0 3px; border: 1px solid #e0e0e0; padding:2px; vertical-align: middle}
.page .pageFunction input.btnJumpTo { border: none; height: 19px; width: 33px; vertical-align:middle; color: #fff; text-align: center; background:#999; line-height: 19px; cursor: pointer}
</style>
<div id="pageNavigator">
<div class="page">
<span class="pagelink">
<input type="hidden" name="pageno" id="pageno" value="<%=pageObject.getCurrentPageNo()%>">
 	<%
 	int cPage = pageObject.getCurrentPageNo();
	int tPage = pageObject.getTotalPageCount();
	if (tPage>1){
	%>
	<%if(pageObject.hasPreviousPage()){%>
		<a class="prev" href="javascript:prePage();">&nbsp;</a>
		
	<%}else{%>
		
		
	<%}%>
	
	<%if(tPage<14){%><!-- 总页数小于14全部显示 -->
		<%for(int i=1;i<=tPage;i++){
				if(i!=cPage){%>
					<a href="javascript:goPage('<%=i%>');"><%=i%></a>  				
  			<%}else{%>
  				<a href="javascript:goPage('<%=cPage %>')" class="now"><%=cPage%></a>
  				
  			<%}
			}
	}else{
		if(cPage<=6){%><!-- 当前页小于6，显示前6页和最后两页 -->
			<%for(int i=1;i<=6;i++){
					if(i!=cPage){%>
						<a href="javascript:goPage('<%=i%>');"><%=i%></a>  					
  				<%}else{%>
  					<a href="##" class="now"><%=i%></a>
  				<%}
				}%>
			<span>...</span><a href="javascript:goPage('<%=tPage-1%>');"><%=tPage-1%></a><a href="javascript:goPage('<%=tPage%>');"><%=tPage%></a>
		<%}else if(tPage-cPage<=6){%><!-- 当前页在最后5页中,显示1.2页和最后5页 -->
			<a href="javascript:goPage('1');">1</a><a href="javascript:goPage('2');">2</a><span>...</span>
			<%for(int i=6;i>=0;--i){
					if((tPage-cPage)!=i){%>
  					<a href="javascript:goPage('<%=tPage-i%>');"><%=tPage-i%></a>  					
  				<%}else{%>
  					<a href="##" class="now"><%=cPage%></a>
  				<%}
				}%>
	<%}else{%><!-- 显示前两条和最后两条及中间7条 -->
		<a href="javascript:goPage('1');">1</a><a href="javascript:goPage('2');">2</a><span>...</span>
		<%for(int i=3;i>=-3;i--){
			if(i==0){%>
  			<a href="##" class="now"><%=cPage%></a>
  		<%}else{%>
  			<a href="javascript:goPage('<%=cPage-i%>');"><%=cPage-i%></a>
  		<%}
		}%>
		<span>...</span><a href="javascript:goPage('<%=tPage-1%>');"><%=tPage-1%></a><a href="javascript:goPage('<%=tPage%>');"><%=tPage%></a>
	<%}
	}%>
    
  <%if(pageObject.hasNextPage()){%>
  	<a href="javascript:nextPage();" class="next">下一页</a>
	<%}else{%>
		
	<%}
	}%>
	</span>
	</div>
	
</div>

   </form>
</body>


 <script type="text/javascript">
	function exportExcel(){
		var id="";
		var sta="";
		var inputlist=document.getElementsByName('checkone');
		for(var i=0;i<inputlist.length;i++){
			if(inputlist[i].checked==true){
				id+="'"+inputlist[i].value+"',";
				sta+="'"+inputlist[i].sta+"',";
			}
		}
		if(id!="" && id.length>0){
			id=id.substr(0,id.length-1);
			sta=sta.substr(0,sta.length-1);
			var sql2 = " select h.id,h.extattachfield2,sta_orgid,o.objname as dept_name,h.objname as name,sta_name,h.tel1,h.tel2,h.email,sta_id ";
				sql2+= " from (select h1.*,s1.objname as sta_name,s1.orgid as sta_orgid,s1.id as sta_id from humres h1, stationinfo s1 where h1.mainstation = s1.id ";
				sql2+= " and s1.isdelete < 1) h,ORGUNIT o where 1 = 1 and h.ISDELETE = 0  AND o.ID = h.sta_orgid ";
				sql2+=" and h.id in ("+id+")";
			document.getElementById('reportsql').value=sql2;
			document.exceptform.submit();
		}else{
			if(confirm("未选中导出记录，是否导出全部通讯录？")){
				var sql= "select h.objname as name,h.*,s1.objname as sta_name,s1.orgid as sta_orgid,s1.id as sta_id,o.objname as dept_name from humres h, stationinfo s1,ORGUNIT o where h.mainstation = s1.id and h.orgid = o.id and s1.orgid in ";
				sql+= " (select OID from ORGUNITLINK where COL1 LIKE '%<%=col1 %>%')";
				sql+= " and s1.isdelete < 1 and h.ISDELETE = 0 and h.HRSTATUS='4028804c16acfbc00116ccba13802935' ";
				document.getElementById('reportsql').value=sql;
				document.exceptform.submit();
			}
		}
	}
	function checkAll(obj,name)
	{
		var inputlist=document.getElementsByName(name);
		for(var i=0;i<inputlist.length;i++){
			inputlist[i].checked=obj.checked;
		}
	
	}
	function goPage(pageno){
	  document.EweaverForm.pageno.value=pageno;
	  document.EweaverForm.submit();
	}  
	function prePage(){
	  var pageno=document.getElementById("pageno");
	  var oValue=pageno.value;
	  oValue=oValue*1-1;
	  pageno.value=oValue;
		document.EweaverForm.submit();
	}  
	function nextPage(){
		var pageno=document.getElementById("pageno");
	  var oValue=pageno.value;
	  oValue=oValue*1+1;
	  pageno.value=oValue;
		document.EweaverForm.submit();
	} 
 </script>
</html>