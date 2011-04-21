package org.wvxvws.automation.language
{
	import org.wvxvws.automation.ParensParser;
	import org.wvxvws.automation.nodes.EvalNode;
	import org.wvxvws.automation.nodes.NamedSymbol;
	import org.wvxvws.automation.nodes.Node;

	public class LetFunctions
	{
		private var _parser:ParensParser;
		private var _context:LanguageFunctions;
		
		public function LetFunctions(parser:ParensParser)
		{
			super();
			this._parser = parser;
			this._context = parser.language;
		}
		
		public function bind(variables:LocalBindList, body:Vector.<Node>):EvalNode
		{
			var evalNode:Scope = new Scope(this._parser);
			var varNode:Node;
			var counter:int;
			var oddNode:NamedSymbol;
			var result:*;
			trace("bind");
			variables.reset();
			while (varNode = variables.next())
			{
				if (counter & 1)
					evalNode.bindTo(oddNode, varNode);
				else oddNode = NamedSymbol(evalNode.add(varNode));
				trace(varNode);
				counter++;
			}
			evalNode.eval();
			for each (var node:Node in body)
			{
				if (node is EvalNode) result = (node as EvalNode).eval();
				else result = node.value;
			}
			evalNode.cleanup();
			return evalNode;
		}
		
		public function makeBindingsList(...nodes):LocalBindList
		{
			trace(nodes);
			return new LocalBindList(Vector.<Node>(nodes));
		}
	}
}