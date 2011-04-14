package org.wvxvws.automation.nodes
{
	public class EvalNode extends ComplexNode
	{
		public override function get value():* { return this; }
		
		public function EvalNode(value:* = undefined, context:Function = null, 
			methodResolver:Function = null)
		{
			super(value, context, methodResolver);
		}
		
		public function eval():* { return super.value; }
	}
}