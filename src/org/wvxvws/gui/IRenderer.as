package org.wvxvws.gui 
{
	import mx.core.IMXMLObject;
	
	/**
	* IRenderer interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface IRenderer extends IMXMLObject
	{
		function get isValid():Boolean;
		
		function get data():XML;
		function set data(value:XML):void;
		
	}
	
}