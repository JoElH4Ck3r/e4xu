package org.wvxvws.automation.syntax
{
	import flash.utils.ByteArray;
	
	import org.wvxvws.automation.language.Atom;
	import org.wvxvws.automation.types.$BitVector;
	import org.wvxvws.automation.types.$Char;

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
			
			while (Reader.table.isConstitutent(
				afterNext = Reader.readCharacter(bytes)))
				token += afterNext;
			bytes.position--;
			return $Char.makeChar(token);
		}
		
		/**
		 * SB-IMPL::SHARP-VERTICAL-BAR - no idea what it does...
		 * @param first
		 * @param second
		 * @param bytes
		 * @return 
		 * 
		 */
		public static function multiEscapeHandler(first:String, 
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
		
		/**
		 * Creates vectors
		 * @param first
		 * @param second
		 * @param bytes
		 * @return 
		 * 
		 */
		public static function parenHandler(first:String, 
			second:String, bytes:ByteArray):Atom
		{
			var result:Atom;
			return result;
		}
		
		public static function asteriskHandler(first:String,
			second:String, bytes:ByteArray):Atom
		{
			var accumulator:String = "";
			var next:String;
			
			while (next = Reader.readCharacter(bytes))
			{
				if ("01".indexOf(next) < 0) break;
				else accumulator += next;
			}
			bytes.position--;
			return new $BitVector(accumulator);
		}
	}
}