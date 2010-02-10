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
		
		protected static const KINDS:Dictionary = new Dictionary();
		
		protected var _types:Vector.<Class>;
		protected var _kind:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SignalType(kind:int, types:Vector.<Class>) 
		{
			super();
			var d:Dictionary;
			this._types = types;
			this._kind = kind;
			if ((this as Object).constructor === SignalType)
				throw SignalError.ABSTRACT_CLASS;
			if (!KINDS[(this as Object).constructor])
				KINDS[(this as Object).constructor] = new Dictionary();
			d = KINDS[(this as Object).constructor];
			if (d[kind] !== undefined)
				throw SignalError.KIND_REGISTERED;
			d[kind] = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function kind():int { return this._kind; }
		
		public function types():Vector.<Class> { return this._types.concat(); }
	}
}