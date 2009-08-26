package org.wvxvws.validation.collections 
{
	import org.wvxvws.validation.Node;
	import org.wvxvws.validation.ValidationError;
	
	/**
	* IAttributes interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface IAttributes 
	{
		
		function validate(attributes:Object, owner:Node):Boolean;
		function get error():ValidationError;
	}
	
}