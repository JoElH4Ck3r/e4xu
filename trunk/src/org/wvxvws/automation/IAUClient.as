package org.wvxvws.automation 
{
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public interface IAUClient 
	{
		function get auParent():IAutomationClient;
		function get auChildren():Vector.<IAutomationClient>;
		function get auProperties():Object;
		function get auActions():Vector.<Action>;
		
		function commit(properties:Object):void;
		function call(actions:Vector.<Action>):void;
	}
	
}