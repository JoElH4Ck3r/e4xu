package org.wvxvws.gui.renderers 
{
	
	/**
	 * IBranchRenderer interface.
	 * @author wvxvw
	 */
	public interface IBranchRenderer extends IRenderer
	{
		function set leafLabelFunction(value:Function):void;
		
		function set leafLabelField(value:String):void;
	}
	
}