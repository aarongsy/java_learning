
<%
String filename = (String)request.getParameter("filename");
%>
<script language="Javascript">
	function ShowCommand(cmdName, bShow)
	{
		var PageViewer = ADViewer.Viewer;

		PageViewer.ShowCommand(cmdName, bShow);
	}
</script>

<script type="text/javascript" FOR="ADViewer" EVENT="OnEndLoadItem(bstrItemName,vData,vResult)">
	// ####################################
	// Event OnEndLoadItem
	// bstrItemName  Typically DOCUMENT or SHEET.
	// vData  Data containing item specific information.
	// If itemName is DOCUMENT the data parameter will contain the document name.
	// If itemName is SHEET the data parameter will contain the IAdPage object representing the loaded (or aborted) page.
	// vResult  The success or failure state of the load.
	// ####################################

	if (bstrItemName == "SHEET")
	{
		ShowCommand("PRINT",  false)
		ShowCommand("SAVE",   false)
		ShowCommand("SAVEAS", false)
		ShowCommand("COPY", false)
	}
</script>
<html>
  <head>

  </head>
  
  <body>
	<object id = "ADViewer"
	classid = "clsid:A662DA7E-CCB7-4743-B71A-D817F6D575DF"
	CODEBASE="<%=request.getContextPath()%>/plugin/DwfViewerSetup.cab"
	border = "1"
	width = "99%" 
	height = "99%" VIEWASTEXT>
	<param name = "Src" value="<%=filename%>">
	</object>
  </body>
</html>
