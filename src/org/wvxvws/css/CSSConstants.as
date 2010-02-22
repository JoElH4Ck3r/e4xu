package  
{
	/**
	 * ...
	 * @author wvxvw
	 */
	public class CSSConstants
	{
		public static const UNDEFINED:CSSConstants = new CSSConstants("undefined");
		public static const INHERITED:CSSConstants = new CSSConstants("inherited");
		
		private static const _CONST_POOL:Object/*Boolean*/ = { };
		
		private var _value:String;
		
		public function CSSConstants(value:String)
		{
			super();
			if (value in _CONST_POOL) throw new Error("Enum error");
			this._value = value;
			_CONST_POOL[value] = true;
		}
		
		public function toString():String { return this._value; }
	}

}