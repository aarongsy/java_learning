<%@ page contentType="text/html; charset=UTF-8"%>
<FORM name="EweaverForm" action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.AttachAction" enctype="multipart/form-data" method="POST">

	<P>
		title
		<INPUT type="text" name="title">
	</P>
	<P>
		content
		<TEXTAREA name="content" rows="5"></TEXTAREA>
	</P>
	<P>
		file
		<INPUT type="file" name="file1">

	</P>
	<P>
		file
		<INPUT type="file" name="file2">

	</P>
	<P>
		<INPUT type="Submit" name="submit" value="submit">
	</P>
</FORM>
