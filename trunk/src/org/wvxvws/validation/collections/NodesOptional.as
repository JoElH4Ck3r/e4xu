package org.wvxvws.validation.collections
{
	import org.wvxvws.validation.Node;
	import org.wvxvws.validation.validation_internal;
	import org.wvxvws.validation.ValidationError;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class NodesOptional extends Nodes
	{
		
		public function NodesOptional(nodes:Array = null) 
		{
			super(nodes);
		}
		
		public override function validate(list:XMLList):Boolean 
		{
			super._error = null;
			var me:Array = super.clone();
			for each (var node:Node in me)
			{
				for each (var xn:XML in list)
				{
					if (node.validate(xn)) break;
					else if (node.error.errorID !== ValidationError.BAD_NAME)
					{
						super._error = node.error;
						return false;
					}
				}
			}
			return true;
		}
	}
	
}