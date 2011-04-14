package org.wvxvws.automation.nodes
{
	public class ComplexNode extends Node
	{
		public var method:String;
		
		public override function get value():*
		{
			var calculated:Array = [];
			var context:Object;
			var inContextMethod:Function;
			
			for each (var member:Node in this._parameters)
			{
				calculated.push(member.value);
			}
			context = super._context(this.method);
			inContextMethod = super._methodResolver(this.method);
			trace("this.method", this.method);
			return inContextMethod.apply(context, calculated);
		}
		
		protected var _parameters:Vector.<Node> = new <Node>[];
		
		public function ComplexNode(value:* = undefined, context:Function = null, 
			methodResolver:Function = null)
		{
			super(value, context, methodResolver);
		}
		
		public function add(child:Node):Node
		{
			this._parameters.push(child);
			return child;
		}
		
		public function remove(child:Node):void
		{
			var index:int = this._parameters.indexOf(child);
			if (index > -1) this._parameters.splice(index, 1);
		}
	}
}