package com.ccp.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;

import com.ccp.service.BPageService;

public class BPageServlet extends BaseServlet {

	public String initBPage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		String pagenumber = request.getParameter("pageNumber");
		String pagesize = request.getParameter("pageSize");
		int pageNumber = NumberUtils.isNumber(pagenumber)?NumberUtils.toInt(pagenumber):1;
		int pageSize = NumberUtils.isNumber(pagesize)?NumberUtils.toInt(pagesize):70;
		BPageService bps = new BPageService();
		response.getWriter().write(bps.initBPage(pageNumber, pageSize));
		return null;
	}

	public String bPage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		String pagenumber = request.getParameter("pageNumber");
		String pagesize = request.getParameter("pageSize");
		int pageNumber = NumberUtils.isNumber(pagenumber)?NumberUtils.toInt(pagenumber):1;
		int pageSize = NumberUtils.isNumber(pagesize)?NumberUtils.toInt(pagesize):70;
		String num = request.getParameter("num");
		String startTime = request.getParameter("startTime");
		String endTime = request.getParameter("endTime");
		
		BPageService bps = new BPageService();
		response.getWriter().write(bps.bPage(pageNumber, pageSize, num, startTime, endTime));
		return null;
	}
}
