package org.wvxvws.automation.nodes
{
	import org.wvxvws.automation.language.ParensPackage;

	public class ComplexNode extends Node
	{
		public var method:String;
		
		public override function get value():*
		{
			var calculated:Array = [];
			var context:Object;
			var inContextMethod:Function;
			var tempValue:*;
			
			context = super._context(this.method);
			inContextMethod = super._methodResolver(this.method);
//			trace("died on:", this.method, inContextMethod, (context is ParensPackage) ? context.name : context);
			for each (var member:Node in this._parameters)
			{
				tempValue = member.value;
				if (tempValue is NamedSymbol)
					tempValue = super._propertyResolver(tempValue);
				calculated.push(tempValue);
			}
//			trace("just before death:", inContextMethod, this.method);
			return inContextMethod.apply(context, calculated);
		}
		
		protected var _parameters:Vector.<Node> = new <Node>[];
		
		public function ComplexNode(value:* = undefined, context:Function = null, 
			methodResolver:Function = null, propertyResolver:Function = null)
		{
			super(value, context, methodResolver, propertyResolver);
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