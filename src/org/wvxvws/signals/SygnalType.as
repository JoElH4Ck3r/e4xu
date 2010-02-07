package org.wvxvws.signals 
{
	/**
	 * SygnalType class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class SygnalType
	{
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _kind:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SygnalType(kind:int) 
		{
			super();
			this._kind = kind;
			if ((this as Object).constructor === SygnalType)
				throw SignalError.ABSTRACT_CLASS;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function kind():int { return this._kind; }
	}
}