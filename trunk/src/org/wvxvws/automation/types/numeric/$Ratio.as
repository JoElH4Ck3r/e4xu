package org.wvxvws.automation.types.numeric
{
	public class $Ratio extends $Rational
	{
		// This probably should be a bytearray...
		protected var _a:int;
		
		protected var _b:int;
		
		public function $Ratio(parseFrom:String)
		{
			super(parseFrom);
			var split:Array = parseFrom.split("/");
			this._a = parseInt(split[0], 10);
			this._b = parseInt(split[1], 10);
		}
		
		public override function toString():String
		{
			return this._a + "/" + this._b;
		}
	}
}