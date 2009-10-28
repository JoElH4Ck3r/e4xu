package org.wvxvws.gui.repeaters 
{
	
	/**
	 * IRepeaterHost interface.
	 * @author wvxvw
	 */
	public interface IRepeaterHost 
	{
		function repeatCallback(currentItem:Object, index:int):Boolean;
	}
	
}