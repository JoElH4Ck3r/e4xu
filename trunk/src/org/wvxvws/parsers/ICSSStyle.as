package org.wvxvws.parsers 
{
	
	/**
	* ICSSStyle interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface ICSSStyle 
	{
		function getStyle(property:String):*;
		function setStyle(property:String, value:*):void;
	}
	
}