package org.wvxvws.automation.language
{
	import org.wvxvws.automation.nodes.Node;

	public class Callable
	{
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
			}
			
			this._context.inpackage(tempContext);
			
			for each (var node:Node in this._parameters)
			{
				result = node.value;
			}
			
			this._context.inpackage(prevPack.name);
			return result;
		}
	}
}