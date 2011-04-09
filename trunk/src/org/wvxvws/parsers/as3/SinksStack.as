package org.wvxvws.parsers.as3 
{
	/**
	 * ...
	 * @author wvxvw
	 */
	public class SinksStack
	{
		private const _sinks:Vector.<ISink> = new <ISink>[];
		private var _current:int;
		
		public function SinksStack() { super(); }
		
		// TODO: Again, as before, we may use some better logystics here.
		public function next():ISink
		{
			var sink:ISink;
			if (this._current < this._sinks.length)
			{
				sink = this._sinks[this._current];
				this._current++;
			}
			return sink;
		}
		
		public function reset():void { this._current = 0; }
		
		public function clear():void
		{
			this._sinks.slice(0);
			this.reset();
		}
		
		public function add(sink:ISink):SinksStack
		{
			var index:int = this._sinks.indexOf(sink);
			if (index < 0) this._sinks.push(sink);
			return this;
		}
		
		public function remove(sink:ISink):SinksStack
		{
			var index:int = this._sinks.indexOf(sink);
			if (index > -1)
			{
				this._sinks.splice(index, 1);
				if (index < this._current) this._current--;
			}
			return this;
		}
	}
}