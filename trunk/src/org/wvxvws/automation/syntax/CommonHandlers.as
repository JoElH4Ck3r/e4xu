package org.wvxvws.automation.syntax
{
	import flash.utils.ByteArray;
	
	import org.wvxvws.automation.language.Atom;
	import org.wvxvws.automation.types.Char;

	public class CommonHandlers
	{
		private static const _hex:String = "0123456789ABCDEF";
		
		public function CommonHandlers() { super(); }
		
		public static function dotHandler(character:String, bytes:ByteArray):Atom
		{
			var result:Atom;
			return result;
		}
		
		public static function escapeHandler(first:String, 
			second:String, bytes:ByteArray):Atom
		{
			var next:String = Reader.readCharacter(bytes);
			var afterNext:String;
			var token:String = next;
			var char:Char;
			
			while (Reader.table.isConstitutent(
				afterNext = Reader.readCharacter(bytes)))
			{
				token += afterNext;
			}
			bytes.position--;
			if (token.length > 1)
			{
				token = Reader.table.toTableCase(token);
				char = Char[token];
				if (!char) throw "unrecognized-character-name";
			}
			else char = Char.makeChar(next);
			return new Atom(token, Char, char);
		}
		
		/**
		 * SB-IMPL::SHARP-VERTICAL-BAR - no idea what it does...
		 * @param first
		 * @param second
		 * @param bytes
		 * @return 
		 * 
		 */
		public static function multyEscapeHandler(first:String, 
			second:String, bytes:ByteArray):Atom
		{
			var result:Atom;
			return result;
		}
		
		public static function xHandler(first:String, 
			second:String, bytes:ByteArray):Atom
		{
			var next:String;
			var hex:String = "";
			var value:uint;
			
			while (next = Reader.readCharacter(bytes).toUpperCase())
			{
				if (_hex.indexOf(next) < 0)
				{
					value = parseInt(hex, 16);
					break;
				}
				hex += next;
			}
			return new Atom(value.toString(), uint, value);
		}
		
		public static function parenHandler(first:String, 
			second:String, bytes:ByteArray):Atom
		{
			var result:Atom;
			return result;
		}
	}
}