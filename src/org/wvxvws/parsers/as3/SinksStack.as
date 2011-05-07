package org.wvxvws.parsers.as3 
{
	/**
	 * ...
	 * @author wvxvw
	 */
	public class SinksStack
	{
		public function get length():int { return this._sinks.length; }
		
		public function get position():int { return this._current; }
		
		protected const _sinks:Vector.<ISink> = new <ISink>[];
		
		protected var _current:int;
		
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
		
		public function back():SinksStack
		{
			if (this._current > 0) this._current--;
			return this;
		}
		
		public function reset():void { this._current = 0; }
		
		public function clear(stack:SinksStack = null):SinksStack
		{
			var clone:Vector.<ISink> = this._sinks.slice();
			this._sinks.splice(0, this._sinks.length);
			this.reset();
			return fromVector(clone, this._current, stack);
		}
		
		public function restore(stack:SinksStack):SinksStack
		{
			this.clear();
			return fromVector(stack._sinks, stack._current, this);
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
		
		protected static function fromVector(
			sinks:Vector.<ISink>, position:int, stack:SinksStack):SinksStack
		{
			var result:SinksStack = stack || new SinksStack();
			for each (var sink:ISink in sinks)
				result._sinks.push(sink);
			result._current = position;
			return result;
		}
	}
}