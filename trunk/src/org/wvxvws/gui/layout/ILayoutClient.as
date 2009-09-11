package org.wvxvws.gui.layout 
{
	
	/**
	* ILayoutClient interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface ILayoutClient 
	{
		
		function get validator():LayoutValidator;
		function get invalidProperties():Object;
		
		function get layoutParent():ILayoutClient;
		function set layoutParent(value:ILayoutClient):void;
		
		function get layoutChildren():Vector.<ILayoutClient>;
		
		function validate(properties:Object):void;
		function invalidate(property:String, cleanValue:*):void;
		
	}
	
}