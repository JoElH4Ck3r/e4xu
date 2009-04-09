package org.wvxvws.gui 
{
	
	/**
	* IRenderer interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface IRenderer 
	{
		function get isValid():Boolean;
		
		function get data():XML;
		function set data(value:XML):void;
		
	}
	
}