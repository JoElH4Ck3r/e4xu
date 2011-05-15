package org.wvxvws.automation.types
{
	public class Char
	{
		public static const NEWLINE:Char = new Char("\n");
		
		public static const RETURN:Char = new Char("\r");
		
		public static const SPACE:Char = new Char(" ");
		
		public static const TAB:Char = new Char("\t");
		
		private var _value:String;
		
		private static const _chars:Object = { };
		
		public function Char(value:String)
		{
			super();
			this._value = value.charAt();
		}
		
		public static function makeChar(value:String):Char
		{
			value = value.charAt();
			if (!(value in _chars)) _chars[value] = new Char(value);
			return _chars[value];
		}
		
		public function valueOf():Object { return this._value; }
		
		public function toString():String
		{
			var result:String = this._value;
			
			switch (this)
			{
				case NEWLINE:
					result = "Newline";
					break;
				case SPACE:
					result = "Space";
					break;
				case TAB:
					result = "Tab";
					break;
				case RETURN:
					result = "Return";
					break;
			}
			return "\\" + result;
		}
	}
}