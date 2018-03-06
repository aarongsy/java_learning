<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>

<textarea id="addFeed.jst" style="display:none;">
<span title='${title}' width='100%' style='clear: both;display: block; text-align:right;'>
<a href='javascript:void(0);' onclick='javascript:hideAddFeed();'>
<img src='<%= request.getContextPath() %>/light/images/close_on.gif' style='border: 0px;'/></a>
</span>
<form name='myFeedForm'>
  <table border='0' cellpadding='0' cellspacing='0' >
    <tr>
      <td class='portlet-table-td-left' >
        <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790020")%>:<!-- RSSÃ¦ÂºÂÃ¥ÂÂ°Ã¥ÂÂ -->
      </td>
    </tr>
    <tr>
    <td class='portlet-table-td-left' >
      <input type='text' name='pcFeed' value='' size='30' />
      <input name='AddFeed' type='button' value='<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>' onclick="javascript:addFeed('${id}');" /><!-- Ã§Â¡Â®Ã¥Â®Â -->
    </td>
    </tr>
  </table>
</form>
</textarea>

<textarea id="moreBgImage.jst" style="display:none;">
<form name='form_moreBgImage'>
<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg1.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg1.png' {if bgImage == 'light/images/portal-bg1.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg2.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg2.png' {if bgImage == 'light/images/portal-bg2.png'}checked='true'{/if}/>     
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg3.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg3.png' {if bgImage == 'light/images/portal-bg3.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg4.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/portal-bg4.png' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg4.png' {if bgImage == 'light/images/portal-bg4.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg5.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/portal-bg5.png' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg5.png' {if bgImage == 'light/images/portal-bg5.png'}checked='true'{/if}/>
</td>
</tr>
      
<tr>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg6.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg6.png' {if bgImage == 'light/images/portal-bg6.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg7.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg7.png' {if bgImage == 'light/images/portal-bg7.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg8.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg8.png' {if bgImage == 'light/images/portal-bg8.png'}checked='true'{/if}/>
</td> 
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg9.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg9.png' {if bgImage == 'light/images/portal-bg9.png'}checked='true'{/if}/>
</td>     
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg10.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg10.png' {if bgImage == 'light/images/portal-bg10.png'}checked='true'{/if}/>
</td>
</tr>

<tr>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg11.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg11.png' {if bgImage == 'light/images/portal-bg11.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg12.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg12.png' {if bgImage == 'light/images/portal-bg12.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg13.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg13.png' {if bgImage == 'light/images/portal-bg13.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg14.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg14.png' {if bgImage == 'light/images/portal-bg14.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg15.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg15.png' {if bgImage == 'light/images/portal-bg15.png'}checked='true'{/if}/>
</td>
</tr>

<tr>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg16.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg16.png' {if bgImage == 'light/images/portal-bg16.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg17.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg17.png' {if bgImage == 'light/images/portal-bg17.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg18.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg18.png' {if bgImage == 'light/images/portal-bg18.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg19.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg19.png' {if bgImage == 'light/images/portal-bg19.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><span height='20' width='100' style='background:url(<%= request.getContextPath() %>/light/images/portal-bg20.png);' ><image height='20' width='100' src='<%= request.getContextPath() %>/light/images/spacer.gif' style='border: 0px' /></span>
<input type='radio' name='ptBg' value='light/images/portal-bg20.png' {if bgImage == 'light/images/portal-bg20.png'}checked='true'{/if}/>
</td>
</tr>

<tr>
<td class='portlet-table-td-right'>
<input type='button' value='${ok}' onclick="javascript:saveBgImage('${id}');" class='portlet-form-button'/>
<input type='button' value='${cancel}' onclick='javascript:cancelBgImage();' class='portlet-form-button'/>
</td>
</tr>

</table>
</form>
</textarea>

<textarea id="moreHeaderImage.jst" style="display:none;">
<form name='form_moreHeaderImage'>
<table border='0' cellpadding='0' cellspacing='0'>
<tr>
<td class='portlet-table-td-left'><image height='40' width='200' src='<%= request.getContextPath() %>/light/images/portal-header1.png' style='border: 0px' />
<input type='radio' name='ptHeader' value='light/images/portal-header1.png' {if headerImage == 'light/images/portal-header1.png'}checked='true'{/if}/>
</td>      
<td class='portlet-table-td-left'><image height='40' width='200' src='<%= request.getContextPath() %>/light/images/portal-header2.png' style='border: 0px' />
<input type='radio' name='ptHeader' value='light/images/portal-header2.png' {if headerImage == 'light/images/portal-header2.png'}checked='true'{/if} />
</td>
</tr>

<tr>
<td class='portlet-table-td-left'><image height='40' width='200' src='<%= request.getContextPath() %>/light/images/portal-header3.png' style='border: 0px' />
<input type='radio' name='ptHeader' value='light/images/portal-header3.png' {if headerImage == 'light/images/portal-header3.png'}checked='true'{/if}/>
</td> 
<td class='portlet-table-td-left'><image height='40' width='200' src='<%= request.getContextPath() %>/light/images/portal-header4.png' style='border: 0px' />
<input type='radio' name='ptHeader' value='light/images/portal-header4.png' {if headerImage == 'light/images/portal-header4.png'}checked='true'{/if}/>
</td> 
</tr>
      
<tr>
<td class='portlet-table-td-left'><image height='40' width='200' src='<%= request.getContextPath() %>/light/images/portal-header5.png' style='border: 0px' />
<input type='radio' name='ptHeader' value='light/images/portal-header5.png' {if headerImage == 'light/images/portal-header5.png'}checked='true'{/if}/>
</td>
<td class='portlet-table-td-left'><image height='40' width='200' src='<%= request.getContextPath() %>/light/images/portal-header6.png' style='border: 0px' />
<input type='radio' name='ptHeader' value='light/images/portal-header6.png' {if headerImage == 'light/images/portal-header6.png'}checked='true'{/if}/>
</td> 
</tr>

<tr>
<td class='portlet-table-td-left'><image height='40' width='200' src='<%= request.getContextPath() %>/light/images/portal-header7.png' style='border: 0px' />
<input type='radio' name='ptHeader' value='light/images/portal-header7.png' {if headerImage == 'light/images/portal-header7.png'}checked='true'{/if}/>
</td> 
<td class='portlet-table-td-left'><image height='40' width='200' src='<%= request.getContextPath() %>/light/images/portal-header8.png' style='border: 0px' />
<input type='radio' name='ptHeader' value='light/images/portal-header8.png' {if headerImage == 'light/images/portal-header8.png'}checked='true'{/if}/>
</td> 
</tr>      
	
<tr>
<td class='portlet-table-td-left'><image height='40' width='200' src='<%= request.getContextPath() %>/light/images/portal-header9.png' style='border: 0px' />
<input type='radio' name='ptHeader' value='light/images/portal-header9.png' {if headerImage == 'light/images/portal-header9.png'}checked='true'{/if}/>
</td> 
<td class='portlet-table-td-left'><image height='40' width='200' src='<%= request.getContextPath() %>/light/images/portal-header10.png' style='border: 0px' />
<input type='radio' name='ptHeader' value='light/images/portal-header10.png' {if headerImage == 'light/images/portal-header10.png'}checked='true'{/if}/>
</td> 
</tr>

<tr>
<td class='portlet-table-td-right'>
<input type='button' value='${ok}' onclick="javascript:saveHeaderImage('${id}');" class='portlet-form-button'/>
<input type='button' value='${cancel}' onclick='javascript:cancelHeaderImage();' class='portlet-form-button'/>
</td>
</tr>
</table>
</form>
</textarea>


<textarea id="pickColor.jst" style="display:none;">
<span title='${title}' width='100%' style='clear: both;display: block; text-align:right;'>
<a href='javascript:void(0);' onclick='javascript:cancelPickColor();'>
<img src='<%= request.getContextPath() %>/light/images/close_on.gif' style='border: 0px;'/></a>
</span>
  <div id="pickerPanel" class="dragPanel">
        <h4 id="pickerHandle">&nbsp;</h4>
        <div id="pickerDiv">
          <img id="pickerbg" src="<%= request.getContextPath() %>/light/scripts/yuicolorpicker/img/pickerbg.png" alt="">
          <div id="selector"><img src="<%= request.getContextPath() %>/light/scripts/yuicolorpicker/img/select.gif"></div>
        </div>

         <div id="hueBg">
          <div id="hueThumb"><img src="<%= request.getContextPath() %>/light/scripts/yuicolorpicker/img/hline.png"></div>
        </div>

        <div id="pickervaldiv">
            <form name="pickerform" onsubmit="return pickerUpdate()">
            <br />
            R <input name="pickerrval" id="pickerrval" type="text" value="0" size="3" maxlength="3" />
            H <input name="pickerhval" id="pickerhval" type="text" value="0" size="3" maxlength="3" />
            <br />
            G <input name="pickergval" id="pickergval" type="text" value="0" size="3" maxlength="3" />
            S <input name="pickergsal" id="pickersval" type="text" value="0" size="3" maxlength="3" />
            <br />
            B <input name="pickerbval" id="pickerbval" type="text" value="0" size="3" maxlength="3" />
            V <input name="pickervval" id="pickervval" type="text" value="0" size="3" maxlength="3" />
            <br />
            <br />
            # <input name="pickerhexval" id="pickerhexval" type="text" value="0" size="6" maxlength="6" />
            <br />
            </form>
        </div>

        <div id="pickerSwatch">&nbsp;</div>
    </div>
    <table border='0' cellpadding='0' cellspacing='0' width="90%">    
    <tr>
    <td class='portlet-table-td-right' >
      <input type='button' value='${ok}' onclick="javascript:savePickColor('${id}','${which}');" class='portlet-form-button'/>
	  <input type='button' value='${cancel}' onclick='javascript:cancelPickColor();' class='portlet-form-button'/>
    </td>
    </tr>
  </table>
</textarea>

<textarea id="configMode.jst" style="display:none;">
<fmt:bundle basename="resourceBundle">
<form name="form_${id}">
<table border='0' cellpadding='0' cellspacing='0' width="95%" >
<tr>
<td colspan='2'>
<img src='<%= request.getContextPath() %>/light/images/spacer.gif' height='10' style='border: 0px' width='200' alt='' />
</td>
</tr>
<tr>
<td class='portlet-table-td-left' width="50%"><fmt:message key="portlet.label.title"/>:
</td>
<td class='portlet-table-td-left'>
<input type='text' name='pcTitle' value='${title}' class='portlet-form-input-field' size='24' /> 
</td>
</tr>
<tr>
<td class='portlet-table-td-left'><fmt:message key="portlet.label.titleBgColor"/>:
</td>
<td class='portlet-table-td-left'>
<div class='color-block' style='background-color:red;' onclick="javascript:setColor('${id}',1,'red');"> </div>
<div class='color-block' style='background-color:orange;' onclick="javascript:setColor('${id}',1,'orange');"> </div>
<div class='color-block' style='background-color:yellow;' onclick="javascript:setColor('${id}',1,'yellow');"> </div>
<div class='color-block' style='background-color:green;' onclick="javascript:setColor('${id}',1,'green');"> </div>
<div class='color-block' style='background-color:blue;' onclick="javascript:setColor('${id}',1,'blue');"> </div>
<div class='color-block' style='background-color:black;' onclick="javascript:setColor('${id}',1,'black');"> </div>
<div class='color-block' style='background-color:white;' onclick="javascript:setColor('${id}',1,'white');"> </div>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'><fmt:message key="portlet.label.titleColor"/>:
</td>
<td class='portlet-table-td-left'>
<div class='color-block' style='background-color:red;' onclick="javascript:setColor('${id}',2,'red');"> </div>
<div class='color-block' style='background-color:orange;' onclick="javascript:setColor('${id}',2,'orange');"> </div>
<div class='color-block' style='background-color:yellow;' onclick="javascript:setColor('${id}',2,'yellow');"> </div>
<div class='color-block' style='background-color:green;' onclick="javascript:setColor('${id}',2,'green');"> </div>
<div class='color-block' style='background-color:blue;' onclick="javascript:setColor('${id}',2,'blue');"> </div>
<div class='color-block' style='background-color:black;' onclick="javascript:setColor('${id}',2,'black');"> </div>
<div class='color-block' style='background-color:white;' onclick="javascript:setColor('${id}',2,'white');"> </div>
</td>
</tr>
<tr>
<td class='portlet-table-td-left'><fmt:message key="portlet.label.contentBgColor"/>:
</td>
<td class='portlet-table-td-left'>
<div class='color-block' style='background-color:red;' onclick="javascript:setColor('${id}',3,'red');"> </div>
<div class='color-block' style='background-color:orange;' onclick="javascript:setColor('${id}',3,'orange');"> </div>
<div class='color-block' style='background-color:yellow;' onclick="javascript:setColor('${id}',3,'yellow');"> </div>
<div class='color-block' style='background-color:green;' onclick="javascript:setColor('${id}',3,'green');"> </div>
<div class='color-block' style='background-color:blue;' onclick="javascript:setColor('${id}',3,'blue');"> </div>
<div class='color-block' style='background-color:black;' onclick="javascript:setColor('${id}',3,'black');"> </div>
<div class='color-block' style='background-color:white;' onclick="javascript:setColor('${id}',3,'white');"> </div>
</td>
</tr>
<tr>
<td class='cright' colspan='2'>
<input name='save' type='button' value='<fmt:message key="portlet.button.save"/>' class='portlet-form-button'
 onclick="javascript:configPortlet('${id}');" />
<input name='default' type='button' value='<fmt:message key="portlet.button.default"/>' class='portlet-form-button'
 onclick="javascript:defaultConfigPortlet('${id}');" />
<input type='button' name='action' onClick="javascript:Light.executeRender('${id}','','normal','');" value='<fmt:message key="portlet.button.cancel"/>' class='portlet-form-button' />
</td>
</tr>
</table>
</form>
</fmt:bundle>
</textarea>
