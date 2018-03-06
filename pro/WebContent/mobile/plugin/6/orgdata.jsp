<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.mobile.plugin.mode.*"%>
<%@ page import="com.eweaver.mobile.plugin.service.*"%>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<%!
public StringBuffer showOrgs(List<Map<String,Object>> list,int level){
        StringBuffer result = new StringBuffer();
        if(list == null || list.isEmpty()) {
            result.append("<span></span>");
        }
        for(int i=0;list!=null&&i<list.size();i++){
            Map<String,Object> org = list.get(i);
            
            String id = (String)org.get("id");
            String name = (String)org.get("name");
            String type = (String)org.get("type");
            String comid = (String)org.get("comid");
            String subid = (String)org.get("subid");
            List<Map<String,Object>> orgs = new ArrayList<Map<String,Object>>();
//            if(!type.equals("3")){
//                orgs = (List) org.get("list");
//            }           
            
            result.append("<table>");
            result.append("<tr>");
            result.append("<td style=\"padding-left:"+(level*10)+"px;word-break:break-all\"  _id=\"" + id + "\" _type=\"" + type + "\" _comid=\"" + comid + "\" _subid=\"" + subid + "\" _level=\"" + level + "\" onclick=\"javascript:getChild(this);\">");
            
            if(!type.equals("3")&&orgs.size()>0){
                result.append("<a onclick=\"expand('"+type+"_"+id+"');return false;\" style='color:blue;text-decoration: none;'>");
                result.append("<img id=\""+type+"_"+id+"_icon\" src=\"/mobile/images/expand_xp.gif\" border=0 align=\"absmiddle\">");
            } else if(!type.equals("3")) {
                result.append("<a onclick=\"expand('"+type+"_"+id+"');return false;\" style='color:blue;text-decoration: none;'>");
                result.append("<img id=\""+type+"_"+id+"_icon\" src=\"/mobile/images/expand_xp.gif\" border=0 align=\"absmiddle\">");
                //result.append("<img id=\""+type+"_"+id+"_icon\" src=\"/mobile/images/collapse_xp.gif\" border=0 align=\"absmiddle\">");
            }
            
            if(type.equals("0")){
            result.append("<img src=\"/mobile/images/country.gif\" border=0 align=\"absmiddle\" onclick=\"expand('this,"+type+"_"+id+"');\">");
            }
            if(type.equals("1")){
                result.append("<img src=\"/mobile/images/country.gif\" border=0 align=\"absmiddle\" onclick=\"expand('this,"+type+"_"+id+"');\">");
            }
            if(type.equals("2")){
                result.append("<img src=\"/mobile/images/custom4.gif\" border=0 align=\"absmiddle\" onclick=\"expand('this,"+type+"_"+id+"');\">");
            }
            if(type.equals("3")){
                result.append("<img src=\"/mobile/images/man.gif\" border=0 align=\"absmiddle\" onclick=\"expand('this,"+type+"_"+id+"');\">");
            }
            
            result.append(name);

            if(!type.equals("3")&&orgs.size()>0){
                result.append("</a>");
            }
            
            if(type.equals("3")){
                
                String mobile = (String)org.get("mobile");
                String telephone = (String)org.get("telephone");
                String email = (String)org.get("email");
                
                if((mobile!=null&&!mobile.equals(""))||(telephone!=null&&!telephone.equals(""))||(email!=null&&!email.equals(""))){
                    result.append("<font style=\"color:#999999\">(需手机支持以下功能)</font>");
                }
                
                if(mobile!=null&&!mobile.equals("")){
                    result.append("<br><img src=\"/mobile/images/mobile.gif\" border=0 width=\"16\" height=\"16\" style=\"padding-top:3px;margin-left:20px;\"/>");
                    result.append("&nbsp;:&nbsp;<a href=\"tel:"+mobile+"\">"+mobile+"</a>");
                    result.append("<br><img src=\"/mobile/images/msg.gif\" border=0 width=\"16\" height=\"16\" style=\"padding-top:3px;margin-left:20px;\"/>");
                    result.append("&nbsp;:&nbsp;<a href=\"sms:"+mobile+"\">发送短信</a>");
                }
                
                if(telephone!=null&&!telephone.equals("")){
                    result.append("<br><img src=\"/mobile/images/tel.gif\"  border=0 width=\"16\" height=\"16\" style=\"padding-top:3px;margin-left:20px;\"/>");
                    result.append("&nbsp;:&nbsp;<a href=\"tel:"+telephone+"\">"+telephone+"</a>");
                }
                
                if(email!=null&&!email.equals("")){
                    result.append("<br><img src=\"/mobile/images/mail.gif\" border=0 width=\"16\" height=\"16\" style=\"padding-top:3px;margin-left:20px;\"/>");
                    result.append("&nbsp;:&nbsp;<a href=\"mailto:"+email+"\">"+email+"</a>");
                }
            }
            
            result.append("</td>");
            result.append("</tr>");
            
//            if(!type.equals("3")&&orgs.size()>0){
//                result.append("<tr>");
//                result.append("<td id=\""+type+"_"+id+"\" style=\"display:none;word-break:break-all\">");
//            
//                result.append(showOrgs(orgs,level+1));
//                
//                result.append("</td>");
//                result.append("</tr>");
//            }
            result.append("</table>");
        }
        return result;
    }
%>

<%
        EweaverClientServiceImpl clientService = (EweaverClientServiceImpl)BaseContext.getBean("eweaverClientServiceImpl");
        String orgType = request.getParameter("orgType");
        String orgComId = request.getParameter("orgComId");
        String orgSubId = request.getParameter("orgSubId");
        String orgDepId = request.getParameter("orgDepId");
        int orgLevel = NumberHelper.string2Int(request.getParameter("orgLevel"),0);
         String organizaions;
        if (orgType != null && orgType.indexOf(",") != -1) {
            String[] types = orgType.split(",");
            organizaions = showOrgs(clientService.getOrganizaions(orgComId, orgSubId, orgDepId, types[1]), orgLevel).toString();
            //organizaions += showOrgs(clientService.getOrganizaions(orgComId, orgSubId, orgDepId, types[0]), orgLevel).toString();
        } else {
            organizaions = showOrgs(clientService.getOrganizaions(orgComId, orgSubId, orgDepId, orgType), orgLevel).toString();
        }             
        response.getWriter().write(organizaions);
        response.getWriter().flush();
        response.getWriter().close();
%>