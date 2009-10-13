package org.wvxvws.gui.windows 
{
	
	/**
	 * IWindow interface.
	 * @author wvxvw
	 */
	public interface IPane 
	{
		function get modal():Boolean;
		function set modal(value:Boolean):void;
		
		function get resizable():Boolean;
		function set resizable(value:Boolean):void;
		
		function created():void;
		function destroyed():void;
		function collapsed():void;
		function choosen():void;
		function unchoosen():void;
	}
	
}