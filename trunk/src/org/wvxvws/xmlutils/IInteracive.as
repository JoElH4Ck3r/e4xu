package org.wvxvws.xmlutils 
{
	
	/**
	 * IInteracive interface.
	 * @author wvxvw
	 */
	public interface IInteracive 
	{
		function parent():InteractiveModel;
		function root():InteractiveModel;
		function children():InteractiveList;
		function attributes():InteractiveList;
		function toXMLString():String;
	}
	
}