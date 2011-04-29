package org.wvxvws.parsers.as3 
{
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public interface ISink 
	{
		function read(from:ISinks):Boolean;
		
		function isSinkStart(from:ISinks):Boolean;
	}
}