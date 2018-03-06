var isLightBool = false ;
var rowBgValue = "" ;
function getRowBg()
{	
	isLightBool = !isLightBool ;
	if (isLightBool)
	{
		rowBgValue = "#e7e7e7" ;
	}
	else
	{	
		rowBgValue = "#f5f5f5" ;
	}
	return rowBgValue ;
}
