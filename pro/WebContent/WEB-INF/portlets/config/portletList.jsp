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
        <option value='<c:out value="${i}" />'>Column <c:out value="${i}" /></option>
      </c:forEach>
    </select>
  </span>
  
  <img src="light/images/spacer.gif" style="border:0px;" height="5" width="100%"/>
  <span class='portlet-rss'>
    <input type="image" src="light/images/add.gif" style="border:0px;" align="absmiddle"
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
      <span class='portlet-rss'>
        <input type="image" src="light/images/showMod.gif" style="border:0px;"
          onClick="javascript:showFeaturedFeed('<c:out value="${requestScope.responseId}"/>'); return false;" />
        <a href="javascript:void(0);" onclick="javascript:showFeaturedFeed('<c:out value="${requestScope.responseId}"/>');"><fmt:message key="portlet.button.featuredFeeds"/></a>
      </span>
      <span class='portlet-rss'>
        <input type="image" src="light/images/showMod.gif" style="border:0px;"
          onClick="javascript:showDictionary('<c:out value="${requestScope.responseId}"/>'); return false;" />
        <a href="javascript:void(0);" onclick="javascript:showDictionary('<c:out value="${requestScope.responseId}"/>');"><fmt:message key="portlet.button.feedDictionarys"/></a>
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
        <a href="<%= request.getContextPath() %>/opml/myfeeds.opml" target='_blank'>Export to OPML</a>
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

    <!-- show : featuredFeed -->
    <c:if test='${requestScope.show == "featuredFeed"}'>
      <span class='portlet-rss'>
        <input type="image" src="light/images/hideMod.gif"  style="border:0px;"
          onClick="javascript:hideFeaturedFeed('<c:out value="${requestScope.responseId}"/>'); return false;" />
        <a href="javascript:void(0);"
          onclick="javascript:hideFeaturedFeed('<c:out value="${requestScope.responseId}"/>');"><fmt:message key="portlet.button.featuredFeeds"/></a>
      </span>

      <c:if test='${empty requestScope.featuredFeedLists}'>
        <img src="light/images/spacer.gif" style="border:0px;" height="1" width="15"/>
        <fmt:message key="portlet.message.empty"/>
      </c:if>

      <c:forEach var="default" items="${requestScope.featuredFeedLists}" >
        <c:if test="${default.icon !=null && default.icon != '' && !default.needPrefix}">
          <input type="image" src="<c:out value='${default.icon}'/>" name="<c:out value='${default.name}'/>"
            onClick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);"
            style="border:0px; width:16; height:16;" />
        </c:if>
        <c:if test="${default.icon !=null && default.icon != '' && default.needPrefix}">
          <input type="image" src="<%= request.getContextPath() %><c:out value='${default.icon}'/>"
            name="<c:out value='${default.name}'/>" style="border:0px; width:16; height:16;"
            onClick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);" />
        </c:if>
        <c:if test="${default.icon == null || default.icon == ''}">
			<input type="image" src="<%= request.getContextPath() %>/light/images/portlet.gif" 
              name="<c:out value='${default.name}'/>"
              onClick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);"
              style="border:0px; width:16; height:16;" />
		</c:if>
        <img src="light/images/spacer.gif" style="border:0px;" height="1" width="3"/>
        <a href="javascript:void(0);"
          onclick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);"
          name="<c:out value='${default.name}'/>"><c:out value='${default.title}'/></a>
      </c:forEach>
    </c:if>

    <!-- show : dictionary -->
    <c:if test='${requestScope.show == "dictionary"}'>
      <span class='portlet-rss'>
        <input type="image" src="light/images/hideMod.gif" style="border:0px;"
          onClick="javascript:hideDictionary('<c:out value="${requestScope.responseId}"/>'); return false;" />
        <a href="javascript:void(0);"
          onclick="javascript:hideDictionary('<c:out value="${requestScope.responseId}"/>');"><fmt:message key="portlet.button.feedDictionarys"/></a>
      </span>

      <c:if test='${empty requestScope.feedDictionarys}'>
        <img src="light/images/spacer.gif" style="border:0px;" height="1" width="15"/>
        <fmt:message key="portlet.message.empty"/>
      </c:if>

      <c:forEach var="dic" items="${requestScope.feedDictionarys}" >
        <c:if test='${dic.showed}'>
          <span class='portlet-rss'>
            <img src="light/images/spacer.gif" style="border:0px;" height="1" width="10"/>
            <input type="image" src="light/images/hideMod.gif"
              onClick="javascript:hideDictionaryFeed('<c:out value="${requestScope.responseId}"/>',
                '<c:out value="${dic.name}"/>'); return false;" style="border:0px;" />
            <a href="javascript:void(0);"
              onclick="javascript:hideDictionaryFeed('<c:out value="${requestScope.responseId}"/>',
                '<c:out value="${dic.name}"/>');"><c:out value="${dic.title}"/></a>
          </span>
          
          <c:forEach var="feed" items="${dic.feedLists}" >
            <span class='portlet-rss'>
              <img src="light/images/spacer.gif" style="border:0px;" height="1" width="25"/>
              <c:if test="${feed.icon !=null && feed.icon != '' && !feed.needPrefix}">
                <input type="image" src="<c:out value='${feed.icon}'/>" name="<c:out value='${feed.name}'/>"
                  onClick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);"
                  style="border:0px; width:16; height:16;" />
              </c:if>
              <c:if test="${feed.icon !=null && feed.icon != '' && feed.needPrefix}">
                <input type="image" src="<%= request.getContextPath() %><c:out value='${feed.icon}'/>"
                  name="<c:out value='${feed.name}'/>"
                  onClick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);"
                  style="border:0px; width:16; height:16;" />
              </c:if>
              <c:if test="${feed.icon == null || feed.icon == ''}">
				<input type="image" src="<%= request.getContextPath() %>/light/images/portlet.gif" 
	              name="<c:out value='${default.name}'/>"
	              onClick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);"
	              style="border:0px; width:16; height:16;" />
		  	  </c:if>
              <img src="light/images/spacer.gif" style="border:0px;" height="1" width="3"/>
              <a href="javascript:void(0);" name="<c:out value='${feed.name}'/>"
                onclick="javascript:addContent('<c:out value="${requestScope.responseId}"/>',this.name);">
                <c:out value='${feed.title}'/></a>
            </span>
          </c:forEach>
        </c:if>
        <c:if test='${!dic.showed}'>
          <span class='portlet-rss'>
            <img src="light/images/spacer.gif" style="border:0px;" height="1" width="10"/>
            <input type="image" src="light/images/showMod.gif" style="border:0px;"
              onClick="javascript:showDictionaryFeed('<c:out value="${requestScope.responseId}"/>',
                '<c:out value="${dic.name}"/>'); return false;" />
            <img src="light/images/spacer.gif" style="border:0px;" height="1" width="3"/>
            <a href="javascript:void(0);"
              onclick="javascript:showDictionaryFeed('<c:out value="${requestScope.responseId}"/>',
                '<c:out value="${dic.name}"/>');"><c:out value="${dic.title}"/></a>
          </span>
        </c:if>
      </c:forEach>
    </c:if>
  </c:if>
</form>
</fmt:bundle>
</body>
</html>