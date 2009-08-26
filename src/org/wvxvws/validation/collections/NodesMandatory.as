package org.wvxvws.validation.collections
{
	import org.wvxvws.validation.Node;
	import org.wvxvws.validation.validation_internal;
	import org.wvxvws.validation.ValidationError;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class NodesMandatory extends Nodes
	{
		
		public function NodesMandatory(nodes:Array = null) { super(nodes); }
		
		public override function validate(list:XMLList):Boolean 
		{
			super._error = null;
			var me:Array = super.clone();
			var isValid:Boolean;
			for each (var node:Node in me)
			{
				isValid = false;
				for each (var xn:XML in list)
				{
					if (node.validate(xn))
					{
						isValid = true;
						break;
					}
				}
				if (!isValid)
				{
					if (node.error.errorID === ValidationError.BAD_NAME)
					{
						super._error = 
							new ValidationError(ValidationError.MISSING_NODE, node);
						super._error.validation_internal::setContext(
													list.toXMLString(), this);
					}
					else
					{
						super._error = node.error;
					}
					return false;
				}
			}
			return true;
		}
	}
	
}