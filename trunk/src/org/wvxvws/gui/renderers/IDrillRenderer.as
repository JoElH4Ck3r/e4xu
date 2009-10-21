package org.wvxvws.gui.renderers 
{
	/**
	 * IDrillRenderer interface.
	 * @author wvxvw
	 */
	public interface IDrillRenderer extends IRenderer
	{
		function get closed():Boolean;
		function set closed(value:Boolean):void;
	}
	
}