package org.wvxvws.automation.nodes
{
	public class LazyNode extends ComplexNode
	{
		// This is a very quick and dirty solution. We would need a better pattern
		// to define lazy caclulations
		public override function get value():*
		{
			var calculated:Array = [];
			var context:Object;
			var inContextMethod:Function;
			
			var condition:Boolean = super._parameters[0].value;
			calculated.push(condition);
			if (condition)
				calculated.push(super._parameters[1].value, null);
			else if (super._parameters.length > 2)
				calculated.push(null, super._parameters[2].value);
			
			context = super._context(this.method);
			inContextMethod = super._methodResolver(this.method);
			return inContextMethod.apply(context, calculated);
		}
		
		public function LazyNode(value:* = undefined, 
			context:Function = null, methodResolver:Function = null)
		{
			super(value, context, methodResolver);
		}
	}
}