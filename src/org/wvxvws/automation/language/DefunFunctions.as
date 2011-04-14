package org.wvxvws.automation.language
{
	import org.wvxvws.automation.ParensParser;
	import org.wvxvws.automation.nodes.Node;

	public class DefunFunctions
	{
		private var _parser:ParensParser;
		
		public function DefunFunctions(parser:ParensParser)
		{
			super();
			this._parser = parser;
		}
		
		public function defun(name:String, argList:ArgumentsList, 
			body:Vector.<Node>):Function
		{
			var callable:Callable = 
				new Callable(argList, body, this._parser.language);
			var pack:ParensPackage;
			var varname:String;
			var parts:Array = name.split(":");
			var lang:LanguageFunctions = this._parser.language;
			
			if (parts.length > 1)
			{
				pack = lang.getpackage(parts[0]);
				varname = parts[1];
			}
			else
			{
				pack = lang.currentPackage();
				varname = parts[0];
			}
			
			pack.intern(varname, callable);
			return callable.call;
		}
		
		public function list(...nodes):ArgumentsList
		{
			var aList:ArgumentsList = new ArgumentsList();
			
			for each (var name:String in nodes)
			{
				aList.add(new Node(), name);
			}
			return aList;
		}
		
		public function lazy(...nodes):Vector.<Node>
		{
			trace("lazy", nodes);
			var vec:Vector.<Node> = new <Node>[];
			for each (var node:Node in nodes) vec.push(node);
			return vec;
		}
	}
}