package com.ccp.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;

import com.ccp.service.BPageService;
import com.ccp.service.JqGridService;

public class JqGridServlet extends BaseServlet {

	public String initJqGrid(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("application/json;charset=utf-8");
		
		String pagenumber = request.getParameter("page");
		String pagesize = request.getParameter("rows");
		int pageNumber = NumberUtils.isNumber(pagenumber)?NumberUtils.toInt(pagenumber):1;
		int pageSize = NumberUtils.isNumber(pagesize)?NumberUtils.toInt(pagesize):70;
		JqGridService jqg = new JqGridService();
		response.getWriter().write(jqg.initJqGrid(pageNumber, pageSize));
		return null;
	}
	
	public String initJqGrid1(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("application/json;charset=utf-8");
		
		String pagenumber = request.getParameter("page");
		String pagesize = request.getParameter("rows");
		int pageNumber = NumberUtils.isNumber(pagenumber)?NumberUtils.toInt(pagenumber):1;
		int pageSize = NumberUtils.isNumber(pagesize)?NumberUtils.toInt(pagesize):70;
		JqGridService jqg = new JqGridService();
		response.getWriter().write(jqg.initJqGrid1(pageNumber, pageSize));
		return null;
	}
	
	public String optJqGrid(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("application/json;charset=utf-8");
		
		String oper = request.getParameter("oper").trim();
		String id = request.getParameter("id");
		String tanknum = request.getParameter("tank_num");
		String material = request.getParameter("material");
		String tankheig = request.getParameter("tank_heig");
		String tanktemp = request.getParameter("tank_temp");
		String tankweig = request.getParameter("tank_weig");
		String tankpi = request.getParameter("tank_pi");
		
		JqGridService jqg = new JqGridService();
		if(oper.equalsIgnoreCase("add")){
			jqg.add("tank",tanknum,material,tankheig,tanktemp,tankweig,tankpi);
		}else if(oper.equalsIgnoreCase("edit")){
			jqg.edit("tank",tanknum,material,tankheig,tanktemp,tankweig,tankpi,id);
		}else if(oper.equalsIgnoreCase("del")){
			jqg.del("tank",id);
		}else{
			throw new RuntimeException("oper not found！");
		}
		return null;
	}
	
	public String optJqGrid1(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("application/json;charset=utf-8");
		
		String oper = request.getParameter("oper").trim();
		String id = request.getParameter("id");
		String tanknum = request.getParameter("tanknum");
		String gd = request.getParameter("gd");
		String wd = request.getParameter("wd");
		String yl = request.getParameter("yl");
		String bm = request.getParameter("bm");
		
		JqGridService jqg = new JqGridService();
		if(oper.equalsIgnoreCase("add")){
			jqg.add("th",tanknum,gd,wd,yl,bm);
		}else if(oper.equalsIgnoreCase("edit")){
			jqg.edit("th",tanknum,gd,wd,yl,bm,id);
		}else if(oper.equalsIgnoreCase("del")){
			jqg.del("th",id);
		}else{
			throw new RuntimeException("oper not found！");
		}
		return null;
	}

}
