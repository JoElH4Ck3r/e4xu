package org.wvxvws.data 
{
	
	/**
	 * IIterator interface.
	 * @author wvxvw
	 */
	public interface IIterator 
	{
		function get next():Function;
		function get current():Function;
		function get position():int;
		
		function hasNext():Boolean;
		function reset():void;
	}
	
}