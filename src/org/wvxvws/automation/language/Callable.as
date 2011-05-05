package org.wvxvws.automation.language
{
	import org.wvxvws.automation.errors.Restart;
	import org.wvxvws.automation.nodes.EvalNode;
	import org.wvxvws.automation.nodes.Node;

	public class Callable
	{
		public function get error():Restart { return null; }
		public function get length():int { return 0; }
		
		private var _body:Vector.<Node>;
		private var _parameters:ArgumentsList;
		private var _context:LanguageFunctions;
		
		public function Callable(parameters:ArgumentsList, body:Vector.<Node>, 
			context:LanguageFunctions)
		{
			super();
			this._body = body;
			this._parameters = parameters;
			this._context = context;
		}
		
		public function nextOp():Boolean { return false; }
		
		public function call(...nodes):*
		{
			var result:*;
			var tempContext:String = "" + Math.random();
			var pack:ParensPackage;
			var param:Node;
			var prevPack:ParensPackage = this._context.currentPackage();
			var i:int;
			
			this._context.defpackage(tempContext);
			pack = this._context.getpackage(tempContext);
			this._parameters.reset();
			
			while (param = this._parameters.next())
			{
				pack.extern(this._parameters.nameOf(param), nodes[i]);
				i++;
			}
			
			this._context.inpackage(tempContext);
			
			for each (var node:Node in this._body)
			{
				if (node is EvalNode) result = (node as EvalNode).eval();
				else result = node.value;
			}
			
			this._context.inpackage(prevPack.name);
			this._context.removePackage(tempContext);
			return result;
		}
	}
}