package org.wvxvws.automation.errors
{
	import org.wvxvws.automation.language.Atom;
	import org.wvxvws.automation.language.Callable;

	public class Restart
	{
		private var _message:String;
		
		private var _callable:Callable;
		
		private var _atom:Atom;
		
		public function Restart(message:String, inCallable:Callable, onAtom:Atom)
		{
			super();
			this._message = message;
			this._callable = inCallable;
			this._atom = onAtom;
		}
		
		/**
		 * In order to try and do this interactive we will have to do this 
		 * asynchronous... :(
		 * @param frame
		 * @return 
		 * 
		 */
		public function handle(frame:StackFrame):Boolean { return false; }
		
		public static function bubble(message:Restart, continueIn:Callable, continueFrom:Atom):void
		{
			
		}
	}
}