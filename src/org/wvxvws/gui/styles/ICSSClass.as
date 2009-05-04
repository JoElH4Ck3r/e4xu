package org.wvxvws.gui.styles
{
	
	/**
	* ICSSClass interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface ICSSClass extends ICSSStyle
	{
		function get clasName():String;
		function appendModifications(style:ICSSStyle):void;
	}
	
}