package org.wvxvws.parsers.as3
{
	import flash.utils.getQualifiedClassName;

	public class SinksBase
	{
		protected const _stack:SinksStack = new SinksStack();
		
		public function SinksBase() { super(); }
		
		protected function readInternal():void
		{
			this.buildDictionary();
			this.loopSinks();
		}
		
		protected function buildDictionary(stack:SinksStack = null):SinksStack
		{
			return this._stack.clear(stack);
		}
		
		protected function loopSinks():void
		{
			trace("--- entering loopSinks:", this._stack.length, this._stack.position);
			var nextSink:ISink;
			while (nextSink = this._stack.next())
			{
				if (nextSink.isSinkStart(this as ISinks) && 
					nextSink.read(this as ISinks))
					this._stack.reset();
				trace("--- --- sink tried:", getQualifiedClassName(nextSink));
			}
		}
	}
}