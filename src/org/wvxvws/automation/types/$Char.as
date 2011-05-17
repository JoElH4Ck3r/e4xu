package org.wvxvws.automation.types
{
	import org.wvxvws.automation.language.Atom;
	import org.wvxvws.automation.syntax.Reader;

	public class $Char extends Atom
	{
		public static const NEWLINE:$Char = new $Char("\n");
		
		public static const RETURN:$Char = new $Char("\r");
		
		public static const SPACE:$Char = new $Char(" ");
		
		public static const TAB:$Char = new $Char("\t");
		
		private static const _chars:Object = { };
		
		public function $Char(value:String)
		{
			super(value.charAt(), $Char, value.charAt());
		}
		
		public static function makeChar(value:String):$Char
		{
			if (value.length > 1)
			{
				trace("--- long char name:", "|" + value + "|");
				value = Reader.table.toTableCase(value);
				if (!(value in $Char)) throw "unrecognized-character-name";
				if (!(value in _chars)) _chars[value] = $Char[value];
			}
			else
			{
				trace("--- short char name:", "|" + value + "|");
				if (!(value in _chars)) _chars[value] = new $Char(value);
			}
			return _chars[value];
		}
		
		public function valueOf():Object { return this._value; }
		
		public override function toString():String
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
			return "#\\" + result;
		}
	}
}