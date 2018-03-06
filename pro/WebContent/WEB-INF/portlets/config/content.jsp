<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
</head>
<body>
<fmt:bundle basename="resourceBundle">

<c:if test='${requestScope.addFeedError != null}'>
  <div class="portlet-msg-error"><c:out value="${requestScope.addFeedError}" /></div>
</c:if>

<form name='form_<c:out value="${requestScope.responseId}"/>' action="<portlet:actionURL />">
  <span class='portlet-rss'>
    <fmt:message key="portlet.label.addContent"/> :
    <select name="pcColumn" size="1"  class="portlet-form-select" >
      <c:forEach var="i" begin="1" end="${requestScope.columns}" step="1">
        <option value='<c:out value="${i}" />'>第<c:out value="${i}" />列</option>
      </c:forEach>
    </select>
  </span>
  
  <img src="light/images/spacer.gif" style="border:0px;" height="5" width="100%"/>
  <span class='portlet-rss'>
    <input type="image" src="<%=request.getContextPath()%>/images/silk/feed_add.gif" style="border:0px;" align="absmiddle"
      onClick="javascript:showAddFeed(event,'<c:out value="${requestScope.responseId}"/>'); return false;" />
    <a href="javascript:void(0);" onClick="javascript:showAddFeed(event, '<c:out value="${requestScope.responseId}"/>');showMyFeed('<c:out value="${requestScope.responseId}"/>');"><fmt:message key="portlet.button.addMyFeed"/></a>
  </span>
  <img src="light/images/spacer.gif" style="border:0px;" height="5" width="100%"/>
  
  <c:if test="${requestScope.show != null}">
    <!-- show : default -->
    <c:if test='${requestScope.show == "default"}'>
      <span class='portlet-rss'>
        <input type="image" src="light/images/showMod.gif" style="border:0px;"
          onClick="javascript:showMyFeed('<c:out value="${requestScope.responseId}"/>'); return false;" />
        <a href="javascript:void(0);" onclick="javascript:showMyFeed('<c:out value="${requestScope.responseId}"/>');"><fmt:message key="portlet.button.myFeeds"/></a>
      </span>


      <img src="light/images/spacer.gif" style="border:0px;" height="5" width="100%"/>
      <c:forEach var="default" items="${requestScope.defaultLists}" >
        <span class='portlet-rss'>
          <c:if test="${default.icon !=null && default.icon != '' && !default.needPrefix}">
            <input type="image" src="<c:out value='${default.icon}'/>" name="<c:out value='${default.name}'/>"
              onClick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);"
              style="border:0px; width:16; height:16;" />
          </c:if>
          <c:if test="${default.icon !=null && default.icon != '' && default.needPrefix}">
            <input type="image" src="<%= request.getContextPath() %><c:out value='${default.icon}'/>"
              name="<c:out value='${default.name}'/>"
              onClick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);"
              style="border:0px; width:16; height:16;" />
          </c:if>
          <c:if test="${default.icon == null || default.icon == ''}">
			<input type="image" src="<%= request.getContextPath() %>/light/images/portlet.gif" 
              name="<c:out value='${default.name}'/>"
              onClick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);"
              style="border:0px; width:16; height:16;" />
		  </c:if>
          <img src="light/images/spacer.gif" style="border:0px;" height="1" width="3"/>
          <a href="javascript:void(0);" name="<c:out value='${default.name}'/>"
            onclick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);">
            <c:out value='${default.title}'/></a>
        </span>
      </c:forEach>
    </c:if>

    <!-- show : myFeed -->
    <c:if test='${requestScope.show == "myFeed"}'>
      <span class='portlet-rss'>
        <input type="image" src="light/images/hideMod.gif" style="border:0px;"
          onClick="javascript:hideMyFeed('<c:out value="${requestScope.responseId}"/>'); return false;" />
        <a href="javascript:void(0);" onclick="javascript:hideMyFeed('<c:out value="${requestScope.responseId}"/>');"><fmt:message key="portlet.button.myFeeds"/></a>
      </span>

      <c:if test='${empty requestScope.myFeedLists}'>
        <img src="light/images/spacer.gif" style="border:0px;" height="1" width="15"/>
        <fmt:message key="portlet.message.empty"/>
      </c:if>
      
      <c:forEach var="myFeed" items="${requestScope.myFeedLists}" >
        <span class='portlet-rss'>
        <c:if test="${myFeed.icon !=null && myFeed.icon != '' && !myFeed.needPrefix}">
          <input type="image" src="<c:out value='${myFeed.icon}'/>" name="<c:out value='${myFeed.name}'/>"
            onClick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name); return false;"
            style="border:0px; width:16; height:16;" />
        </c:if>
        <c:if test="${myFeed.icon !=null && myFeed.icon != '' && myFeed.needPrefix}">
          <input type="image" src="<%= request.getContextPath() %><c:out value='${myFeed.icon}'/>"
            name="<c:out value='${myFeed.name}'/>" style="border:0px; width:16; height:16;"
            onClick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name); return false;" />
        </c:if>
        <c:if test="${myFeed.icon ==null || myFeed.icon == ''}">
          <input type="image" src="<%= request.getContextPath() %>/light/images/portlet.gif"
            name="<c:out value='${myFeed.name}'/>" style="border:0px; width:16; height:16;"
            onClick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name); return false;"/>
        </c:if>
        <img src="light/images/spacer.gif" style="border:0px;" height="1" width="3"/>
        <a href="javascript:void(0);" onclick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);"
          name="<c:out value='${myFeed.name}'/>"><c:out value='${myFeed.title}'/></a>
        <input type="image" title='<fmt:message key="portlet.button.delete"/>' src="<%= request.getContextPath() %>/light/images/deleteLink.gif" name="<c:out value='${myFeed.name}'/>" style='border: 0px;' height='11' width='11' onClick="document.pressed='delete';document.parameter=this.name;"/>  
        </span>
      </c:forEach>
    </c:if>
  </c:if>
</form>
</fmt:bundle>
</body>
</html>