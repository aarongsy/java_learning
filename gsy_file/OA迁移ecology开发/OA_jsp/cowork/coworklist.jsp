<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ page import="com.eweaver.cowork.model.*"%>
<%@ page import="com.eweaver.cowork.service.*"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
	<head>
		<style type="text/css">
    TABLE {
        width: 0;
    }
    .x-panel-btns-ct {
        padding: 0px;
    }
    .unread {
        font-weight:bold;
    }
       </style>
		
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/js/ext/ux/AutoRefresher.js"></script>
		<%
		int pageSize=200;
		int gridWidth=700;
		String isall=StringHelper.null2String(request.getParameter("isall"));
		String isformbase=StringHelper.null2String(request.getParameter("isformbase"));
		if(isformbase.equals(""))
		isformbase="1";
		CategoryService cs = (CategoryService)BaseContext.getBean("categoryService");
		FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
		CoworksetService css = (CoworksetService)BaseContext.getBean("coworksetService");
		ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
		String categoryid=StringHelper.null2String(request.getParameter("categoryid"));//"402880311c4f0f04011c4f108ee10002";
		String widths1="";
		if(categoryid.equals("")){
		 out.print(labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b000b"));//未指定分类
		 return;
		}
		Category category = cs.getCategoryById(categoryid);
		  String fieldid="";
		   String colorfield="";
			   String colorfieldname="";
		if(!StringHelper.isEmpty(isall)&&"1".equals(isall)){}else{
		   String formid=category.getFormid();
		   if(StringHelper.isEmpty(formid)){
			Category cgory=cs.getCategoryById(category.getPid());
			formid=cgory.getFormid();
		   }
		   Forminfo forminfo=forminfoService.getForminfoById(formid);
		   if(forminfo.getObjtype().intValue()==1){//抽象表
		   String hql="from Forminfo where objtablename='"+forminfo.getObjtablename()+"'and id!='"+forminfo.getId()+"'";
			  List listf=forminfoService.getForminfoListByHql(hql);
			  if(listf.size()>0){
			   Forminfo f=(Forminfo)listf.get(0);
			   formid=f.getId();
			  }
		   }
	
			List<Coworkset> setlist=css.searchBy("from Coworkset where formid='"+formid+"' and createlayout is null and editlayout is null");
			if (setlist.size() > 0) {
				   Coworkset coworkset = setlist.get(0);
				   fieldid = StringHelper.null2String(coworkset.getCategoryid());
				   colorfield=StringHelper.null2String(coworkset.getColorfield());
			   }
		   
			   if(!StringHelper.isEmpty(colorfield)){
			   colorfieldname=formfieldService.getFormfieldName(colorfield);
			   }
		}
		
		if(category==null||StringHelper.isEmpty(category.getId())){
		 out.print(labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b000b"));//未指定分类
		 return;
		}
		String reportid=category.getReportid();
		if(StringHelper.isEmpty(reportid)){
			reportid=category.getPReportid();
		 if(StringHelper.isEmpty(reportid)){
		 out.print(labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b000c"));//未定义报表
		 return;
		 }
		}
		String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?&isnew=1"+"&action=search&reportid="+reportid;
		int cols=0;
		String fieldstr="";
		String fieldstr1="";
		String cmstr="";
		//

		ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
		PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
		boolean isauth = permissiondetailService.checkOpttype(categoryid, 2);
		SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
		RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
		AttachService attachService = (AttachService) BaseContext.getBean("attachService");
		HumresService humresService=(HumresService)BaseContext.getBean("humresService");
		ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
		List reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
		if(reportfieldList.size()==0){
		reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
		}
		Iterator it = reportfieldList.iterator();
				cols = reportfieldList.size();
				fieldstr+="'requestid'";
				fieldstr1+="requestid";
				Map reporttitleMap = new HashMap();
			   int k=0;
		while(it.hasNext()){
			Reportfield reportfield = (Reportfield) it.next();
			reporttitleMap.put(reportfield.getShowname(),reportfield.getShowname());
			Integer showwidth = reportfield.getShowwidth();
			String widths = "";
			if(showwidth!=null && showwidth.intValue()!=-1){
				widths = "width=" + showwidth + "%";
			}
			Formfield formfields = formfieldService.getFormfieldById(reportfield.getFormfieldid());
			String thtmptype = "";
			if(formfields.getHtmltype() != null){
				thtmptype = formfields.getHtmltype().toString();
			}
			String tfieldtype = "";
			if(formfields.getFieldtype()!=null){
				tfieldtype = formfields.getFieldtype().toString();
			}

			String styler = "";
			if("1".equals(thtmptype) && ("2".equals(tfieldtype) || "3".equals(tfieldtype))){
				styler = "style='text-align :right'";
			}

			String fieldname=formfields.getFieldname() ;
			String showname=reportfield.getShowname();
			int sortable=NumberHelper.getIntegerValue(reportfield.getIsorderfield(),0);
			if(cmstr.equals(""))
			{	
				widths1+="width:"+showwidth*gridWidth/100+"";
				cmstr+=showname;
			}
			else
			{
				widths1+=",width:"+showwidth*gridWidth/100+"";
				cmstr+=","+showname;
			}
			if(fieldstr.equals(""))
			{
				fieldstr+="'"+fieldname+"'";
				fieldstr1+=""+fieldname+"";
			}
			else
			{
				fieldstr+=",'"+fieldname+"'";
				fieldstr1+=","+fieldname+"";
			}
		k++;
	  }
	Reportdef reportdef=reportdefService.getReportdef(reportid);
		%>
		<script type="text/javascript">
Ext.LoadMask.prototype.msg = '<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';
Ext.SSL_SECURE_URL='about:blank';
Ext.onReady(function() {

     function renderCell(value, isnew,colorfield1) {
          var objdesc='';
            if(colorfield1=='<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b000d") %>'){//红
            objdesc='#FFCCFF';
            }else if(colorfield1=='<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b000e") %>'){//黄
             objdesc='#F4E19F';
            }else if(colorfield1=='<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b000f") %>'){//绿
            objdesc='#CCFFCC';
            }else if(colorfield1=='<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0010") %>'){//蓝
             objdesc='#CCFFFF';
            }else if(colorfield1=='<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0011") %>'){//紫
            objdesc='#D2BBE8';
            }else if(colorfield1=='<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0012") %>'){//橙
            objdesc='#F5D6A5';
            }
           if(isnew){
           if(objdesc!=''){
           value=String.format('<span ><font color='+objdesc+'>{0}</font></span>',value);
           }else{
            value=String.format('<span >{0}</span>',value);
            }
            }
            return value;
        }
    // create the Data Store
    var store = new Ext.data.JsonStore({
        url:'<%=action2+"&isjson=1&pagesize="+pageSize+"&isformbase="+isformbase%>',
        root: 'result',
        totalProperty: 'totalCount',
        fields: ['isnew',<%=fieldstr%>],
        baseParams:{sort:'modifytime',dir:'desc'},
        remoteSort: true
    });
	var html="<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\" style=\"border-collapse:collapse;width:100%;\" bordercolor=\"#fffff\" id=\"mainTable\">";
	 html+=" <tr style=\"background:#F2F4F2;border:1px solid #c3daf9;\" height=\"30\">";
	var widths='<%=widths1%>'.split(",");
	var cms = '<%=cmstr%>'.split(",");
	for(var i=0,len=cms.length;i<len;i++)
	{
		html+="<td align=\"center\" style="+widths[i]+" >"+cms[i]+"</td>";
	}
	html+="</tr>";
	store.baseParams.con<%=fieldid%>_value='<%=categoryid%>';
    store.load({params:{start:0, limit:<%=pageSize%>}});
	store.on('load', function(){   
		var totalCount=store.getTotalCount();
		var fieldstrs="<%=fieldstr1%>".split(",");
		
		for(var i=0;i<totalCount;i++)
		{
			var requestid=store.getAt(i).get('requestid');
			var classname = "";
			var isnew=store.getAt(i).get('isnew');
			if(isnew)
			{
				classname="unread";
			}
			html+=" <tr style=\"height:22;\" "+(i%2==0?"bgcolor=\"#ECEBEA\"":"")+" onclick=\"javascript:read('"+requestid+"',this);\" class="+classname+">";
			var colorfieldname=store.getAt(i).get('<%=colorfieldname%>');
			for(var j=1,len1=fieldstrs.length;j<len1;j++)
			{
				if(j==1)
				{
					html+="<td align=\"left\">&nbsp;"+renderCell(store.getAt(i).get(fieldstrs[j]),isnew,colorfieldname)+"</td>";
				}
				else
				{
					html+="<td align=\"left\">&nbsp;"+store.getAt(i).get(fieldstrs[j])+"</td>";
				}
			}
			html+=" </tr>";
		}
		html+=" </table>";
		document.getElementById("content").innerHTML=html;
   });  
    // create the editor grid

})
</script>
	</head>
	<body>
	<br>
	<div width="100%" height="100%" id="content">
	<%=labelService.getLabelNameByKeyId("402883d934c1f9d80134c1f9d9620000") %>.......<!-- 加载中 -->
	</div>
	</body>
</html>
<script>
function read(requestid,obj)
{
	obj.className="";
	var url='<%=request.getContextPath()%>/app/cowork/formbase.jsp?requestid=' + requestid;
	parent.document.getElementById('frameRight').src=url;
}
</script>
