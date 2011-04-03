package org.wvxvws.parsers.as3 
{
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public interface ISink 
	{
		function read(from:AS3Sinks):Boolean;
		
		function canFollow(from:AS3Sinks):Boolean;
	}
	
}