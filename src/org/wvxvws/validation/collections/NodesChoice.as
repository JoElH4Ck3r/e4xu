package org.wvxvws.validation.collections 
{
	import org.wvxvws.validation.Node;
	import org.wvxvws.validation.validation_internal;
	import org.wvxvws.validation.ValidationError;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class NodesChoice extends Nodes
	{
		
		public function NodesChoice(nodes:Array = null) 
		{
			super(nodes);
		}
		
		public override function validate(list:XMLList):Boolean 
		{
			if (list.length() > 1)
			{
				super._error = new ValidationError(ValidationError.MUST_BE_SINGLE);
				super._error.validation_internal::setContext(list.toXMLString(), this);
				return false;
			}
			var me:Array = super.clone();
			var isValid:Boolean;
			var bubblingError:ValidationError;
			for each (var node:Node in me)
			{
				if (node.validate(list[0]))
				{
					isValid = true;
					break;
				}
				else if (node.error.errorID !== ValidationError.BAD_NAME)
				{
					bubblingError = node.error;
				}
			}
			if (!isValid)
			{
				super._error = bubblingError;
				super._error.validation_internal::setContext(list.toXMLString(), this);
				return false;
			}
			return true;
		}
	}
	
}