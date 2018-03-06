<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.DataService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService" %>
<%@ page import="com.eweaver.base.security.util.PermissionUtil2" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.base.SQLMap" %>

<%!

	/**
	 * 取select字段字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getSelectDicValue(String dicID)
	{
		if(dicID==null||dicID.length()<1)return "";
		String dicValue="";
		DataService ds = new DataService();
		return ds.getValue("select OBJNAME from selectitem where id='"+dicID+"'");
	}
	/**
	 * 取brower框字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getBrowserDicValue(String tab,String idCol,String valueCol,String dicID)
	{
		if(dicID==null||dicID.length()<1)return "";
		String dicValue="";
		DataService ds = new DataService();
		return ds.getValue("select "+valueCol+" from "+tab+" where "+idCol+"='"+dicID+"'");
	}
	
	/**
	 * 取批量brower框字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getBrowserDicValues(String tab,String idCol,String valueCol,String dicID)
	{
		String dicValue="";
		if(dicID==null||dicID.length()<1)return "";
		String[] dicIDs = dicID.split(",");
		DataService ds = new DataService();
		for(int i=0,size=dicIDs.length;i<size;i++)
		{
			dicValue=dicValue+","+ds.getValue("select "+valueCol+" from "+tab+" where "+idCol+"='"+dicIDs[i]+"'");
		}
		if(dicValue.length()<1)dicValue="";
		else dicValue=dicValue.substring(1,dicValue.length());
		return dicValue;
	}
			/**
	 * 取select字段字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String progress(String fieldvalue)
	{
			fieldvalue = "<div id=\"p2\" >\n" +
                                                " <div style=\"width: auto; height: 15px;\" id=\"pbar2\" class=\"x-progress-wrap left-align\">\n" +
                                                "          <div class=\"x-progress-inner\">\n" +
                                                "              <div style=\"width: " +fieldvalue+ "%; height: 15px;\" id=\"ext-gen9\" class=\"x-progress-bar\">\n" +
                                                "              <div style=\"z-index: 99; width: 100px;\" id=\"ext-gen10\" class=\"x-progress-text x-progress-text-back\">" +
                                                "           <div style=\"width: 100px; height: 15px;\" id=\"ext-gen12\">" + fieldvalue + "%" + "</div>" +
                                                "             </div>\n" +
                                                "           </div>\n" +
                                                "          </div>\n" +
                                                "      </div>\n" +
                                                "  </div>";
		return fieldvalue;
	}
	/**
	 * 处理brower框字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String formatBrowser(String browserid,String value)
	{
		String showname = "";
		DataService ds = new DataService();
		RefobjService refobjService = (RefobjService)BaseContext.getBean("refobjService");
		Refobj refobj = refobjService.getRefobj(browserid);
		if (refobj != null) {
			String _refid = StringHelper.null2String(refobj.getId());
			String _refurl = StringHelper.null2String(refobj
					.getRefurl());
			String _viewurl = StringHelper.null2String(refobj
					.getViewurl());
			String _reftable = StringHelper.null2String(refobj
					.getReftable());
			String _keyfield = StringHelper.null2String(refobj
					.getKeyfield());
			String _viewfield = StringHelper.null2String(refobj
					.getViewfield());
			 int isdirect=NumberHelper.getIntegerValue(refobj.getIsdirectinput(),0).intValue();
			String _selfield=StringHelper.null2String(refobj.getSelfield());
			
			String defaultshowname = "";
			String sql="";
		   if (!StringHelper.isEmpty(value)) {
				 sql = "select " + _keyfield + " as objid,"
						+ _viewfield + " as objname from " + _reftable
						+ " where " + _keyfield + " in("
						+ StringHelper.formatMutiIDs(value) + ")";
			}
			if(!StringHelper.isEmpty(sql)){
				List valuelist = ds.getValues(sql);

				for (int i = 0; i < valuelist.size(); i++) {
					Map refmap = (Map) valuelist.get(i);
					String _objid = StringHelper
							.null2String((String) refmap.get("objid"));
					String _objname = StringHelper
							.null2String((String) refmap.get("objname")).replace(" ","&nbsp;");
					if (!StringHelper.isEmpty(_viewurl))
						showname += "<a href=javascript:onUrl('" + _viewurl + _objid +"','"+_objname+ "','tab"+_objid+"') >";
					showname += "&nbsp;"+_objname+"&nbsp;";
					if (!StringHelper.isEmpty(_viewurl))
						showname += "</a>";
				}
			}
		}
		return showname;
	}
	private String add0(int nums,int len)
	{
		String str= String.valueOf(nums);
		for(int i=len,tlen=str.length();i>tlen;i--)
		{
			str="0"+str;
		}
		return str;
	}

%>
