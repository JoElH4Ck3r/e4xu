package org.wvxvws.automation.errors
{
	import flash.sampler.StackFrame;
	
	import org.wvxvws.automation.language.Atom;
	import org.wvxvws.automation.language.Callable;

	public class StackFrame
	{
		public function get current():Callable { return this._callable; }
		
		private var _callable:Callable;
		
		private var _current:int;
		
		private var _parent:StackFrame;
		
		public function StackFrame(parent:StackFrame, callable:Callable)
		{
			super();
			this._callable = callable;
		}
		
		/**
		 * Will have to make this async :(
		 * 
		 */
		public function enter():void
		{
			this._current = 0;
			while (this._current < this._callable.length)
			{
				if (!this._callable.nextOp())
				{
					if (this._callable.error)
					{
						if (!this._callable.error.handle(this))
							break;
					}
				}
			}
			this.exit();
		}
		
		public function exit():void { }
		
		public function reenter(noAtom:Atom):void { }
		
		public function error():void { }
	}
}