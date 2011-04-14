package org.wvxvws.automation.language
{
	import org.wvxvws.automation.nodes.Node;

	public class ArgumentsList
	{
		private var _nodes:Vector.<Node> = new <Node>[];
		private var _nodeAliases:Object = { };
		private var _position:int;
		
		public function ArgumentsList() { super(); }
		
		public function add(node:Node, alias:String):void
		{
			// TODO: global error handling
			if (this._nodeAliases[alias]) 
				throw "Can't have two arguments with the same name";
			this._nodes.push(node);
			this._nodeAliases[alias] = node;
		}
		
		public function next():Node
		{
			var result:Node;
			
			if (this._position < this._nodes.length)
			{
				result = this._nodes[this._position];
				this._position++;
			}
			return result;
		}
		
		public function nameOf(node:Node):String
		{
			var name:String;
			for (var p:String in this._nodeAliases)
			{
				if (node === this._nodeAliases[p])
				{
					name = p;
					break;
				}
			}
			return name;
		}
		
		public function get(alias:String):Node
		{
			return this._nodeAliases[alias];
		}
		
		public function reset():void
		{
			this._position = 0;
		}
	}
}