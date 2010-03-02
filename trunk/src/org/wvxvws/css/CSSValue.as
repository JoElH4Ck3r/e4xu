package org.wvxvws.css 
{
	//{ imports
		
	//}
	
	/**
	 * CSSValue class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class CSSValue
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _isByRef:Boolean;
		protected var _isNew:Boolean;
		protected var _isSimple:Boolean;
		protected var _type:Class;
		protected var _ns:Namespace;
		protected var _evalChain:Vector.<String>;
		protected var _cachedValue:*;
		protected var _scope:int;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function CSSValue() 
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function value():*
		{
			if (this._isSimple) return this._cachedValue;
			if (this._isByRef)
			{
				if (this._cachedValue === undefined)
				{
					
				}
			}
		}
		
		public function dispose():void
		{
			if ((this._cachedValue is Object) && 
				this._cachedValue.hasOwnProperty("dispose") && 
				this._cachedValue["dispose"] is Function)
			{
				try { this._cachedValue["dispose"](); }
				catch (error:Error) { }
			}
			this._cachedValue = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
}