package org.wvxvws.gui.layout 
{
	import flash.utils.Dictionary;
	
	/**
	* ILayoutClient interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface ILayoutClient 
	{
		
		function get validator():LayoutValidator;
		function get invalidProperties():Dictionary;
		
		function get layoutParent():ILayoutClient;
		function set layoutParent(value:ILayoutClient):void;
		
		function get childLayouts():Vector.<ILayoutClient>;
		
		function validate(properties:Dictionary):void;
		function invalidate(property:Invalides, validateParent:Boolean):void;
		
	}
	
}