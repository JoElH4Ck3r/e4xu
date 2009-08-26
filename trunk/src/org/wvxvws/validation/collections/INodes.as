package org.wvxvws.validation.collections 
{
	import org.wvxvws.validation.ValidationError;
	
	/**
	* INodes interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface INodes 
	{
		
		function validate(list:XMLList):Boolean;
		function get error():ValidationError;
	}
	
}