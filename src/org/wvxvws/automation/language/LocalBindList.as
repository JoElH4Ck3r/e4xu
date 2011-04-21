package org.wvxvws.automation.language
{
	import org.wvxvws.automation.nodes.Node;

	public class LocalBindList
	{
		private var _list:Vector.<Node>;
		
		private var _position:int;
		
		public function LocalBindList(list:Vector.<Node>)
		{
			super();
			trace(list.join(" | "));
			this._list = list.slice();
		}
		
		public function next():Node
		{
			var result:Node;
			
			if (this._position < this._list.length)
			{
				result = this._list[this._position];
				this._position++;
			}
			return result;
		}
		
		public function reset():int { return this._position = 0; }
	}
}