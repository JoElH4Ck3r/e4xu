package org.wvxvws.validation.collections
{
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class NodesUnique extends Nodes
	{
		
		public function NodesUnique(nodes:Array = null) 
		{
			super(nodes);
		}
		
		public override function validate(list:XMLList):Boolean 
		{
			return true;
			//return super.validate(list);
		}
	}
	
}