package org.wvxvws.gui.repeaters 
{
	/**
	 * IRepeater interface.
	 * @author wvxvw
	 */
	public interface IRepeater 
	{
		function get index():int;
		function get currentItem():Object;
		function begin(at:int):void;
	}
}