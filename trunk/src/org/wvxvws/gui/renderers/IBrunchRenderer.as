package org.wvxvws.gui.renderers 
{
	
	/**
	 * IBrunchRenderer interface.
	 * @author wvxvw
	 */
	public interface IBrunchRenderer extends IRenderer
	{
		function set leafLabelFunction(value:Function):void;
		
		function set leafLabelField(value:String):void;
	}
	
}