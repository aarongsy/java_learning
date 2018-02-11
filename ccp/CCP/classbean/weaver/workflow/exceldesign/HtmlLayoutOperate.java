package weaver.workflow.exceldesign;

import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import weaver.conn.ConnStatement;
import weaver.conn.RecordSet;
import weaver.general.*;
import weaver.hrm.User;
import weaver.systeminfo.SystemEnv;
import weaver.workflow.workflow.WFManager;
import weaver.workflow.workflow.WFNodeFieldManager;
import weaver.hrm.resource.ResourceComInfo;

/**
 * @author liuzy 2015-09-15
 * Html模板改造，模板操作相关方法
 */
public class HtmlLayoutOperate extends BaseBean{
	
	private HttpServletRequest request;
	private User user;
	
	/**
	 * 模板选择页面--分页控件反射路径名称
	 */
	public String reflectWorkflowname(String workflowid){
		RecordSet rs = new RecordSet();
		rs.executeSql("SELECT workflowname FROM workflow_base where id="+workflowid);
		if(rs.next()){
			return Util.null2String(rs.getString("workflowname"));
		}
		return "";
	}

	/**
	 * 模板选择页面--分页控件反射模板名称
	 */
	public String reflectLayoutName(String layoutname, String params){
		String[] param = Util.TokenizerString2(params, "+");
		String isactive = Util.null2String(param[0]);
		int languageid = Util.getIntValue(param[1]);
		if("1".equals(isactive))
			return layoutname+"（"+SystemEnv.getHtmlLabelName(678, languageid)+"）";
		else
			return layoutname+"（"+SystemEnv.getHtmlLabelName(1477, languageid)+"）";
	}
	

	/**
	 * 模板列表获取节点类型Html
	 */
	public String transNodeInfo(String nodetype,String pars){
		String nodename=pars;
		StringBuilder _html = new StringBuilder();
		_html.append("<div class=\"nodeinfoDiv\">")
			.append("<div class=\"nodeimg nodeimg_"+nodetype+"\" title=\"点击可查看节点全部模板\" onclick=\"extendHistoryLayout(this);\"></div>")
			.append("<span class=\"nodespan nodespan_"+nodetype+"\">"+nodename+"</span>")
			.append("</div>");
		return _html.toString();
	}
	
	/**
	 * 模板列表获取模板信息 
	 */
	public String transLayoutInfo(String nodeid,String pars){
		String[] parArr=pars.split("\\+");
		int wfid=Util.getIntValue(parArr[0]);
		int layouttype=Util.getIntValue(parArr[1]);
		int languageid = Util.getIntValue(parArr[2], 7);
		RecordSet rs=new RecordSet();
		rs.executeSql("select id,version,layoutname,operuser,opertime from workflow_nodehtmllayout " +
				"where workflowid="+wfid+" and nodeid="+nodeid+" and type="+layouttype+" and isactive=1");
		
		StringBuilder _html = new StringBuilder();
		_html.append("<div class=\"layoutinfo_active\">")
			.append("<input type=\"hidden\" name=\"nodeid\" isactive=\"1\" value=\""+nodeid+"\" />");
		if(rs.next()){
			String layoutid = Util.null2String(rs.getString("id"));
			String layoutname = Util.null2String(rs.getString("layoutname"));
			int version = Util.getIntValue(rs.getString("version"), 0);
			String operuser=Util.null2String(rs.getString("operuser"));
			String opertime=Util.null2String(rs.getString("opertime"));
			_html.append(getExistLayoutInfo(layoutid, layoutname, version, operuser, opertime, languageid));
		}else{
			_html.append("<input type=\"hidden\" name=\"layoutid\" value=\"0\" />")
				.append("<input type=\"hidden\" name=\"version\" value=\"0\" />")
				.append("<div class=\"nonelayout\">");
			if(layouttype==0)
				_html.append(SystemEnv.getHtmlLabelNames("83519,19511",languageid));
			else if(layouttype==1)
				_html.append(SystemEnv.getHtmlLabelNames("83519,257,33144",languageid));
			else if(layouttype==2)
				_html.append(SystemEnv.getHtmlLabelNames("83519,78,33144",languageid));
			_html.append("</div>");
		}
		_html.append("</div>");
		return _html.toString();
	}
	private String getExistLayoutInfo(String layoutid, String layoutname, int version, String operuser, String opertime, int languageid){
		StringBuilder _html = new StringBuilder();
		_html.append("<input type=\"hidden\" name=\"layoutid\" value=\""+layoutid+"\" />")
			.append("<input type=\"hidden\" name=\"version\" value=\""+version+"\" />")
			.append("<div class=\"layoutname\"><a href=\"#\" onclick=\"editBtnClick(this)\">"+layoutname);
		if(version != 2)
			_html.append("("+SystemEnv.getHtmlLabelName(84089,languageid)+")");
		_html.append("</a></div>");
		try{
			ResourceComInfo ResourceComInfo=new ResourceComInfo();
			if(!"".equals(operuser)&&!"".equals(opertime)){
				_html.append("<div class=\"operinfo\">")
					.append(SystemEnv.getHtmlLabelName(623,languageid)).append(" ")
					.append(ResourceComInfo.getLastname(operuser)).append(" ")
					.append(SystemEnv.getHtmlLabelName(82894,languageid)).append(" ")
					.append(opertime).append(" ")
					.append(SystemEnv.getHtmlLabelName(84094,languageid))
					.append("</div>");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return _html.toString();
	}
	
	/**
	 * 模板列表获取操作权限
	 */
	public String transOperBtn(String nodeid,String pars){
		String[] parArr=pars.split("\\+");
		int wfid=Util.getIntValue(parArr[0]);
		int layouttype=Util.getIntValue(parArr[1]);
		int languageid = Util.getIntValue(parArr[2], 7);
		StringBuilder _html = new StringBuilder();
		_html.append("<div class=\"operarea operarea_active\">")
			.append("<div class=\"operbtn oper_create\" onclick=\"createBtnClick(this);\"><div class=\"operbtn_create\">创建</div></div>")
			.append("<div class=\"operbtn oper_edit\" onclick=\"parent.checkServer(editBtnClick,this);\"><div class=\"operbtn_edit\">编辑</div></div>")
			.append("<div class=\"operbtn oper_choose\" onclick=\"chooseBtnClick(this);\"><div class=\"operbtn_choose\">选择</div></div>")
			.append("<div class=\"operbtn oper_delete\" onclick=\"deleteBtnClick(this);\"><div class=\"operbtn_delete\">删除</div></div>")
			.append("<div class=\"operbtn oper_excelimp\" onclick=\"excelimpBtnClick(this);\"><div class=\"operbtn_excelimp\">Excel导入</div></div>")
			.append("<div class=\"operbtn oper_init\" onclick=\"initBtnClick(this);\"><div class=\"operbtn_init\">初始化模板</div></div>")
			.append("<div class=\"operbtn oper_sync\" onclick=\"syncBtnClick(this);\"><div class=\"operbtn_sync\">同步节点</div></div>")
			.append("</div>");
		return _html.toString();
	}
	
	/**
	 * 获得当前节点的历史模板
	 */
	public List getHistoryLayout(String wfid,String nodeid, int layouttype, int languageid){
		List historylist = new ArrayList();
		RecordSet rs = new RecordSet();
		rs.executeSql("select id,version,layoutname,operuser,opertime from workflow_nodehtmllayout " +
				"where workflowid="+wfid+" and nodeid="+nodeid+" and type="+layouttype+" and isactive=0 order by version,id");
		while(rs.next()){
			Map<String,String> layout = new HashMap<String,String>();
			String layoutid = Util.null2String(rs.getString("id"));
			String layoutname = Util.null2String(rs.getString("layoutname"));
			int version = Util.getIntValue(rs.getString("version"), 0);
			String operuser=Util.null2String(rs.getString("operuser"));
			String opertime=Util.null2String(rs.getString("opertime"));
			
			StringBuilder _html = new StringBuilder();
			_html.append("<div class=\"layoutinfo_history\">")
				.append("<input type=\"hidden\" name=\"nodeid\" isactive=\"0\" value=\""+nodeid+"\" />")
				.append(getExistLayoutInfo(layoutid, layoutname, version, operuser, opertime, languageid))
				.append("</div>");
			layout.put("layoutInfo", _html.toString());
			
			_html.setLength(0);
			_html.append("<div class=\"operarea operarea_history\">")
				.append("<div class=\"operbtn_setactive\" onclick=\"setLayoutToActive(this);\" title=\"设为活动模板\"></div>")
				.append("<div class=\"operbtn oper_edit\" onclick=\"parent.checkServer(editBtnClick,this);\"><div class=\"operbtn_edit\">编辑</div></div>")
				.append("<div class=\"operbtn oper_delete\" onclick=\"deleteBtnClick(this);\"><div class=\"operbtn_delete\">删除</div></div>")
				.append("</div>");
			layout.put("operArea", _html.toString());
			
			historylist.add(layout);
		}
		return historylist;
	}
	
	/**
	 * 删除模板
	 */
	public String deleteLayout(int layoutid){
		RecordSet rs = new RecordSet();
		rs.executeSql("delete from workflow_nodehtmllayout where id="+layoutid);
		return "success";
	}

	/**
	 * 节点上表单内容--Html模板选择、模板同步保存
	 * 重新WFNodeFieldManager类setNodeLayout()、setNodeLayoutInner()方法
	 */
	public void saveLayout_all(){
		int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
		int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0); 
		int formid = Util.getIntValue(request.getParameter("formid"), 0);
		int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
		if(wfid <= 0 || nodeid <= 0)
			return;
		
		int htmlid_show = Util.getIntValue(Util.null2String(request.getParameter("showhtmlid")), 0);
		int htmlid_print = Util.getIntValue(Util.null2String(request.getParameter("printhtmlid")), 0);
		int htmlid_mobile = Util.getIntValue(Util.null2String(request.getParameter("mobilehtmlid")), 0);
		int htmlid_pdf = Util.getIntValue(Util.null2String(request.getParameter("pdfhtmlid")), 0);
		
		String syncNodes_show = Util.null2String(request.getParameter("syncNodes"));
		String syncNodes_print = Util.null2String(request.getParameter("printsyncNodes"));
		String syncNodes_mobile = Util.null2String(request.getParameter("syncMNodes"));
		String syncNodes_pdf = Util.null2String(request.getParameter("pdfsyncNodes"));
		//是否选自表单，现在只能把模板设在节点上，所以isform三个参数的值永远是0
		int showhtmlisform = Util.getIntValue(Util.null2String(request.getParameter("showhtmlisform")), 0);
		int printhtmlisform = Util.getIntValue(Util.null2String(request.getParameter("printhtmlisform")), 0);
		int mobilehtmlisform = Util.getIntValue(Util.null2String(request.getParameter("mobilehtmlisform")), 0);
		int pdfhtmlisform = Util.getIntValue(Util.null2String(request.getParameter("pdfhtmlisform")), 0);
//		System.out.println("htmlid_pdf==="+htmlid_pdf+"===syncNodes_pdf==="+syncNodes_pdf);
		//每个模板类别分两步保存
		//第一：保存当前节点模板（选择后、清除后）
		//第二：将节点模板同步到其它节点
		for(int type=0; type<=3; type++){		//0显示模板、1打印模板、2Mobile模板
			int htmlid = -1;
			String syncNodes = "";
			if(type == 0){
				htmlid = htmlid_show;
				syncNodes = syncNodes_show;
			}else if(type == 1){
				htmlid = htmlid_print;
				syncNodes = syncNodes_print;
			}else if(type == 2){
				htmlid = htmlid_mobile;
				syncNodes = syncNodes_mobile;
			}else if(type == 3){
				htmlid = htmlid_pdf;
				syncNodes = syncNodes_pdf;
			}
			saveLayout_singleType(wfid, nodeid, formid, isbill, type, htmlid, syncNodes, user.getUID(), user.getLanguage());
		}
	}
	
	/**
	 * 保存Html打印模板，用于普通模式使用Html打印模板
	 */
	public String saveLayout_print(){
		int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
		int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0); 
		int formid = Util.getIntValue(request.getParameter("formid"), 0);
		int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
		int htmlid_print = Util.getIntValue(Util.null2String(request.getParameter("printhtmlid")), 0);
		String syncNodes_print = Util.null2String(request.getParameter("genprintsyncNodes"));
		return saveLayout_singleType(wfid, nodeid, formid, isbill, 1, htmlid_print, syncNodes_print, user.getUID(), user.getLanguage());
	}
	
	/**
	 * 模板Tab栏，选择模板保存
	 */
	public String saveLayout_choose(){
		int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
		int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0); 
		int formid = Util.getIntValue(request.getParameter("formid"), 0);
		int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
		int layouttype = Util.getIntValue(request.getParameter("layouttype"));
		int choose_layoutid = Util.getIntValue(request.getParameter("choose_layoutid"));
		int operuser = Util.getIntValue(request.getParameter("operuser"));
		int languageid = Util.getIntValue(request.getParameter("languageid"), 7);
		return saveLayout_singleType(wfid, nodeid, formid, isbill, layouttype, choose_layoutid, "", operuser, languageid);
	}
	
	/**
	 * 表单模板--根据类别（显示、打印、移动）保存
	 */
	private String saveLayout_singleType(int wfid, int nodeid, int formid, int isbill, int type, int htmlid, String syncNodes, int operuser, int languageid){
		if(wfid<=0 || nodeid<=0 || type<0)
			return "fault";
		//得到当前节点修改前的活动模板
		int activeLayoutid = getActiveLayoutid(wfid, nodeid, type);
		if(htmlid > 0){
			if(htmlid != activeLayoutid){		//当前节点模板修改过
				int from_nodeid = -1;
				int from_layouttype = -1;
				RecordSet rs = new RecordSet();
				rs.executeSql("select nodeid,type from workflow_nodehtmllayout where id="+htmlid);
				if(rs.next()){
					from_nodeid = Util.getIntValue(rs.getString("nodeid"));
					from_layouttype = Util.getIntValue(rs.getString("type"));
				}
				if(nodeid == from_nodeid && type == from_layouttype){	//模板切换(同一节点同模板类别)
					setLayoutToActive(wfid, nodeid, type, htmlid);
				}else{		//模板覆盖
					syncLayoutToNode(wfid, type, htmlid, nodeid, operuser, languageid);
				}
			}
			if(!"".equals(syncNodes)){		//模板同步到其它节点
				List syncNodeList = Util.TokenizerString(syncNodes, ",");
		    	for(int i=0; i<syncNodeList.size(); i++){
		    		int to_nodeid = Util.getIntValue((String)syncNodeList.get(i));
		    		syncLayoutToNode(wfid, type, htmlid, to_nodeid, operuser, languageid);
		    	}
			}
		}else{	//清除当前节点活动模板
			if(activeLayoutid > 0)
				clearLayoutActiveAttr(wfid, nodeid, type);
		}
		return "success";
	}
	
	/**
	 * 模板Tab栏--同步到其它节点提交
	 */
	public void syncLayoutToNodes(){
		int wfid = Util.getIntValue(request.getParameter("wfid"));
		int layouttype = Util.getIntValue(request.getParameter("layouttype"));
		int from_layoutid = Util.getIntValue(request.getParameter("from_modeid"));
		String to_nodes = Util.null2String(request.getParameter("to_nodes"));
		List syncNodeList = Util.TokenizerString(to_nodes, ",");
    	for(int i=0; i<syncNodeList.size(); i++){
    		int to_nodeid = Util.getIntValue((String)syncNodeList.get(i));
    		syncLayoutToNode(wfid, layouttype, from_layoutid, to_nodeid, user.getUID(), user.getLanguage());
    	}
	}
	
	/**
	 * 将from_layoutid模板同步to_nodeid节点的活动模板
	 */
	private int syncLayoutToNode(int wfid, int layouttype, int from_layoutid, int to_nodeid, int operuser, int languageid){
		if(wfid<=0 || layouttype<0 || from_layoutid<=0 || to_nodeid<=0)
			return -1;
		String nosynfields = "";
		if(layouttype == 0)
			nosynfields = getNoSyncFields(wfid);
		String nosynfieldsSql = "".equals(nosynfields) ? "" : " and fieldid not in ("+nosynfields+") ";
		
		WFNodeFieldManager WFNodeFieldManager=new WFNodeFieldManager();
		RecordSet rs = new RecordSet();
		int nodetype = -1;
		rs.execute("select n.nodename, f.nodetype from workflow_nodebase n left join workflow_flownode f on f.nodeid=n.id where n.id="+to_nodeid);
		if(rs.next()){
			nodetype = Util.getIntValue(rs.getString("nodetype"), -1);
		}
		//模板内容同步
		int from_nodeid = 0;
		HtmlLayoutBean layout = new HtmlLayoutBean();
		layout.setWorkflowid(wfid);
		layout.setNodeid(to_nodeid);
		layout.setLayoutname(getLayoutName(to_nodeid, layouttype, languageid));
		layout.setType(layouttype);
		layout.setOperuser(operuser);
		
		String sql = "select formid,isbill,nodeid,layoutname,syspath,cssfile,htmlparsescheme,version,datajson,pluginjson,scripts from workflow_nodehtmllayout where id="+from_layoutid;
		rs.executeSql(sql);
		if(rs.next()){
			from_nodeid = Util.getIntValue(rs.getString("nodeid"), 0);
			layout.setFormid(Util.getIntValue(rs.getString("formid"), 0));
			layout.setIsbill(Util.getIntValue(rs.getString("isbill"), 0));
			//layout.setLayoutname(Util.null2String(rs.getString("layoutname")));
			layout.setSyspath(Util.null2String(rs.getString("syspath")));
			layout.setCssfile(Util.getIntValue(rs.getString("cssfile"), 0));
			layout.setHtmlparsescheme(Util.getIntValue(rs.getString("htmlparsescheme"), 0));
			layout.setVersion(Util.getIntValue(rs.getString("version"), 0));
			layout.setDatajson(Util.null2String(rs.getString("datajson")));
			layout.setPluginjson(Util.null2String(rs.getString("pluginjson")));
			layout.setScripts(Util.null2String(rs.getString("scripts")));
		}else
			return -1;
		
		String syspath_tmp_new = "";
		if(layout.getVersion() == 0 || layout.getVersion() == 1){	//老源码Html模板，文件同步
			String htmlStr0 = "";
			String htmlStr1 = "";
			if(!"".equals(layout.getSyspath())){
    			htmlStr0 = WFNodeFieldManager.readHtmlFile(layout.getSyspath());
			}
			rs.execute("select syspath from workflow_nodehtmllayout where workflowid="+wfid+" and nodeid="+to_nodeid+" and type="+layouttype+" and isactive=1");
			if(rs.next()){
				String syspath_t = Util.null2String(rs.getString("syspath"));
				if(!"".equals(syspath_t)){
					htmlStr1 = WFNodeFieldManager.readHtmlFile(syspath_t);
				}
			}
			String htmlStr = WFNodeFieldManager.doTransLayout(htmlStr0, htmlStr1);
			//String syspath = copyHtmlFile(syspath_tmp, nodeid, wfid, layouttype);
			syspath_tmp_new = WFNodeFieldManager.createHtmlFile(to_nodeid, wfid, layouttype, htmlStr);
		}
		layout.setSyspath(syspath_tmp_new);
		int layoutid = operHtmlActiveLayout(layout);
		
		if(layouttype == 0){
			//同步字段属性
			rs.execute("delete from workflow_nodeform where nodeid="+to_nodeid+nosynfieldsSql);
			if(nodetype==0 || nodetype==1 || nodetype==2){
				rs.execute("insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory,orderid) select "+to_nodeid+", fieldid, isview, isedit, ismandatory, orderid from workflow_nodeform where nodeid="+from_nodeid+nosynfieldsSql);
			}else{	//归档节点
				rs.execute("insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory,orderid) select "+to_nodeid+", fieldid, isview, '0', '0', orderid from workflow_nodeform where nodeid="+from_nodeid+nosynfieldsSql);
			}
			//同步属性联动信息
			rs.execute("delete from workflow_nodefieldattr where nodeid="+to_nodeid);
			rs.execute("insert into workflow_nodefieldattr(fieldid, formid, isbill, nodeid, attrcontent, caltype, othertype, transtype,datasourceid) select fieldid, formid, isbill, "+to_nodeid+", attrcontent, caltype, othertype, transtype,datasourceid from workflow_nodefieldattr where nodeid="+from_nodeid);
			//同步明细表权限信息(允许新增明细等)
			WFNodeFieldManager.sysNodeDetailsConfig(from_nodeid, to_nodeid);
			//模式置为Html模板
			setNodeModeToHtml(wfid, to_nodeid);
		}
		rs.execute("select nodeid from workflow_flownodehtml where workflowid="+wfid+" and nodeid="+to_nodeid);
		if(!rs.next()){
			rs.execute("insert into workflow_flownodehtml (workflowid, nodeid, colsperrow) values ("+wfid+", "+to_nodeid+", 1)");
		}
		rs.execute("select nodeid from workflow_flownode where workflowid="+wfid+" and nodeid="+to_nodeid);
		if(!rs.next()){
			rs.execute("insert into workflow_flownode (workflowid, nodeid) values ("+wfid+", "+to_nodeid+")");
		}
		return layoutid;
	}
	
	/**
	 * 更新节点活动模板，insert/update
	 */
	public int operHtmlActiveLayout(HtmlLayoutBean layout){
		int layoutid = -1;
		ConnStatement statement = null;
		try{
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentDate = formatter.format(new Date());
			
			statement = new ConnStatement();
			RecordSet rs = new RecordSet();
			String sql = "select id from workflow_nodehtmllayout where nodeid="+layout.getNodeid()+" and formid="+layout.getFormid()+" and isbill="+layout.getIsbill()+" and type="+layout.getType()+" and isactive=1";
			rs.execute(sql);
			if(rs.next()){
				layoutid = Util.getIntValue(rs.getString("id"), 0);
				sql = "update workflow_nodehtmllayout set layoutname=?,syspath=?,cssfile=?,htmlparsescheme=?," +
						"version=?,operuser=?,opertime=?,datajson=?,pluginjson=?,scripts=? where id=?";
				statement.setStatementSql(sql);
				statement.setString(1, layout.getLayoutname());
				statement.setString(2, layout.getSyspath());
				statement.setInt(3, layout.getCssfile());
				statement.setInt(4, layout.getHtmlparsescheme());
				statement.setInt(5, layout.getVersion()); 
				statement.setInt(6, layout.getOperuser());
				statement.setString(7, currentDate);
				statement.setString(8, layout.getDatajson());
				statement.setString(9, layout.getPluginjson());
				statement.setString(10, layout.getScripts());
				statement.setInt(11, layoutid);
				statement.executeUpdate();
			}else{
				sql = "insert into workflow_nodehtmllayout(workflowid,formid,isbill,nodeid,type,layoutname,syspath,cssfile,htmlparsescheme," +
						"version,operuser,opertime,datajson,pluginjson,scripts,isactive) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				statement.setStatementSql(sql);
				statement.setInt(1, layout.getWorkflowid());
				statement.setInt(2, layout.getFormid());
				statement.setInt(3, layout.getIsbill());
				statement.setInt(4, layout.getNodeid());
				statement.setInt(5, layout.getType());
				statement.setString(6, layout.getLayoutname());
				statement.setString(7, layout.getSyspath());
				statement.setInt(8, layout.getCssfile());
				statement.setInt(9, layout.getHtmlparsescheme());
				statement.setInt(10, layout.getVersion());
				statement.setInt(11, layout.getOperuser());
				statement.setString(12, currentDate);
				statement.setString(13, layout.getDatajson());
				statement.setString(14, layout.getPluginjson());
				statement.setString(15, layout.getScripts());
				statement.setInt(16, 1);
				statement.executeUpdate();
				//新增取插入id
				sql = "select max(id) from workflow_nodehtmllayout where nodeid="+layout.getNodeid()+" and formid="+layout.getFormid()+" and isbill="+layout.getIsbill()+" and type="+layout.getType()+" and isactive=1";
				statement.setStatementSql(sql);
				statement.executeQuery();
				if(statement.next())
					layoutid = Util.getIntValue(statement.getString(1), 0);
			}
		}catch(Exception e){
			writeLog(e);
		}finally{
			try{
				statement.close();
			}catch(Exception e){
				writeLog(e);
			}
		}
		return layoutid;
	}
	
	/**
	 * 根据模板ID更新节点模板
	 */
	public int updateHtmlLayout(HtmlLayoutBean layout, int layoutid){
		ConnStatement statement = null;
		try{
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentDate = formatter.format(new Date());
			
			statement = new ConnStatement();
			RecordSet rs = new RecordSet();
			String sql = "select id from workflow_nodehtmllayout where nodeid="+layout.getNodeid()+" and type="+layout.getType()+" and id="+layoutid;
			rs.execute(sql);
			if(rs.next()){
				sql = "update workflow_nodehtmllayout set layoutname=?,syspath=?,cssfile=?,htmlparsescheme=?," +
						"version=?,operuser=?,opertime=?,datajson=?,pluginjson=?,scripts=? where id=?";
				statement.setStatementSql(sql);
				statement.setString(1, layout.getLayoutname());
				statement.setString(2, layout.getSyspath());
				statement.setInt(3, layout.getCssfile());
				statement.setInt(4, layout.getHtmlparsescheme());
				statement.setInt(5, layout.getVersion()); 
				statement.setInt(6, layout.getOperuser());
				statement.setString(7, currentDate);
				statement.setString(8, layout.getDatajson());
				statement.setString(9, layout.getPluginjson());
				statement.setString(10, layout.getScripts());
				statement.setInt(11, layoutid);
				statement.executeUpdate();
			}else{
				layoutid = -1;
			}
		}catch(Exception e){
			writeLog(e);
		}finally{
			try{
				statement.close();
			}catch(Exception e){
				writeLog(e);
			}
		}
		return layoutid;
	}
	
	/**
	 * 流程不同步的字段
	 */
	private String getNoSyncFields(int wfid){
		String nosynfields = "";
		try{
			WFManager wFManager = new WFManager();
			wFManager.reset();
			wFManager.setWfid(wfid);
			wFManager.getWfInfo();
			nosynfields = wFManager.getNosynfields();
		}catch(Exception e){
		}
		return nosynfields;
	}
	
	/**
	 * 获得模板名称
	 */
	public String getLayoutName(int nodeid, int layouttype, int languageid){
		String layoutname = "";
		RecordSet rs = new RecordSet();
		rs.execute("select nodename from workflow_nodebase where id="+nodeid);
		if(rs.next()){
			layoutname += Util.null2String(rs.getString("nodename"));
		}
		if(layouttype == 0)
			layoutname += SystemEnv.getHtmlLabelName(16450, languageid);
		else if(layouttype == 1)
			layoutname += SystemEnv.getHtmlLabelNames("257,64", languageid);
		else if(layouttype == 2)
			layoutname += SystemEnv.getHtmlLabelName(125554, languageid);
		else if(layouttype == 3)
			layoutname += "PDF";
		System.out.println("layoutname==="+layoutname);
		return layoutname;
	}
	
	/**
	 * 将模板置为活动模板
	 */
	public String setLayoutToActive(int wfid, int nodeid, int layouttype, int layoutid){
		clearLayoutActiveAttr(wfid, nodeid, layouttype);
		
		RecordSet rs = new RecordSet();
		String sql = "update workflow_nodehtmllayout set isactive=1 where workflowid="+wfid+" and nodeid="+nodeid+" and type="+layouttype+" and id="+layoutid;
		rs.executeSql(sql);
		return "success";
	}
	
	/**
	 * 清除节点活动模板标示
	 */
	public void clearLayoutActiveAttr(int wfid, int nodeid, int layouttype){
		RecordSet rs = new RecordSet();
		String sql = "update workflow_nodehtmllayout set isactive=0 where workflowid="+wfid+" and nodeid="+nodeid+" and type="+layouttype;
		rs.executeSql(sql);
	}
	
	/**
	 * 获得节点活动模板ID
	 */
	private int getActiveLayoutid(int wfid, int nodeid, int layouttype){
		int layoutid = -1;
		RecordSet rs = new RecordSet();
		String sql = "select id from workflow_nodehtmllayout where workflowid="+wfid+" and nodeid="+nodeid+" and type="+layouttype+" and isactive=1";
		rs.executeSql(sql);
		if(rs.next())
			layoutid = Util.getIntValue(rs.getString("id"));
		return layoutid;
	}
	
	/**
	 * 将节点模式置为Html模式
	 */
	public int setNodeModeToHtml(int workflowid, int nodeid){
		int retInt = -1;
		try{
			RecordSet rs = new RecordSet();
			rs.executeSql("update workflow_flownode set ismode='2' where workflowid="+workflowid+" and nodeid="+nodeid);
		}catch(Exception e){
			retInt = 0;
		}
		return retInt;
	}
	
	/**
	 * 获取对应节点对应类型活动模板ID
	 */
	public int getActiveHtmlLayout(int wfid, int nodeid, int layouttype){
		int layoutid = 0;	//默认值为零，不可修改
		if(wfid>0 && nodeid>0 && layouttype>=0){
			RecordSet rs = new RecordSet();
			String sql = "select id from workflow_nodehtmllayout where workflowid="+wfid+" and nodeid="+nodeid+" and type="+layouttype+" and isactive=1";
			rs.executeSql(sql);
			if(rs.next()){
				layoutid = Util.getIntValue(rs.getString("id"));
			}
		}
		return layoutid;
	}
	
	/**
	 * 根据模板ID取模板version
	 */
	public int getLayoutVersion(int layoutid){
		int version = 0;
		if(layoutid > 0){
			RecordSet rs = new RecordSet();
			String sql = "select version from workflow_nodehtmllayout where id="+layoutid;
			rs.executeSql(sql);
			if(rs.next()){
				version = Util.getIntValue(rs.getString("version"), 0);
			}
		}
		return version;
	}
	
	/**
	 * 判断节点是否含Html模板(静态方法，多处调用)
	 */
	public static boolean judgeHaveHtmlLayout(int wfid, int nodeid, int layouttype){
		boolean have = false;
		if(wfid>0 && nodeid>0 && layouttype>=0){
			RecordSet rs = new RecordSet();
			String sql = "select id from workflow_nodehtmllayout where workflowid="+wfid+" and nodeid="+nodeid+" and type="+layouttype+" and isactive=1";
			rs.executeSql(sql);
			if(rs.next()){
				have = true;
			}
		}
		return have;
	}

	
	public HttpServletRequest getRequest() {
		return request;
	}

	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
}
