package org.wvxvws.signals 
{
	import flash.utils.Dictionary;
	/**
	 * SignalType class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class SignalType
	{
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _kind:int;
		protected static const KINDS:Dictionary = new Dictionary();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SignalType(kind:int) 
		{
			super();
			var d:Dictionary;
			this._kind = kind;
			if ((this as Object).constructor === SignalType)
				throw SignalError.ABSTRACT_CLASS;
			if (!KINDS[(this as Object).constructor])
				KINDS[(this as Object).constructor] = new Dictionary();
			d = KINDS[(this as Object).constructor];
			if (d[kind] !== undefined)
				throw SignalError.KIND_REGISTERED;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function kind():int { return this._kind; }
	}
}