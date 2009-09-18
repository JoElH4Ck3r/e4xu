package org.wvxvws.gui.renderers 
{
	
	/**
	* IMenuRenderer interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface IMenuRenderer extends IRenderer
	{
		
		function set iconFactory(value:Class):void;
		
		function set hotKeys(value:Vector.<int>):void;
		
		function set kind(value:String):void;
		function get kind():String;
		
		function set clickHandler(value:Function):void;
		
		function set enabled(value:Boolean):void;
	}
	
}