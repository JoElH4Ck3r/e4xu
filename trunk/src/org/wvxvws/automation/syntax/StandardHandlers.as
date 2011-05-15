package org.wvxvws.automation.syntax
{
	import flash.utils.ByteArray;
	
	import org.wvxvws.automation.language.Atom;
	import org.wvxvws.automation.language.Cons;

	public class StandardHandlers
	{
		public function StandardHandlers() { super(); }
		
		public static function openParenHandler(
			character:String, bytes:ByteArray):Atom
		{
			var car:Atom;
			var cdr:Atom;
			var result:Cons;
			var next:String;
			
			bytes.position++;
			trace("reading open paren");
			while (bytes.bytesAvailable)
			{
				next = Reader.readCharacter(bytes);
				if (!Reader.table.isWhite(next))
				{
					if (next != ")")
					{
						bytes.position--;
						if (!car) car = Reader.read(bytes);
						else
						{
							bytes.position--;
							result = Cons.cons(car, openParenHandler("(", bytes));
						}
					}
					else if (car) result = Cons.cons(car, null);
				}
			}
			return result;
		}
		
		public static function closingParenHandler(
			character:String, bytes:ByteArray):Atom
		{
			return Reader.pop();
		}
		
		public static function sharpHandler(character:String, bytes:ByteArray):Atom
		{
			var next:String = Reader.readCharacter(bytes);
			next = Reader.readCharacter(bytes);
			return Reader.table.getMacroHandler("#", next)("#", next, bytes);
		}
		
		public static function quoteHandler(character:String, bytes:ByteArray):Atom
		{
			var result:Atom;
			return result;
		}
		
		public static function semicolonHandler(
			character:String, bytes:ByteArray):Atom
		{
			var eol:int;
			
			while (bytes.bytesAvailable)
			{
				eol = bytes.readUnsignedByte();
				if (eol == 0x09 || eol == 0x0A) break;
			}
			return null;
		}
		
		public static function apostropheHandler(
			charcter:String, bytes:ByteArray):Atom
		{
			var result:Atom;
			return result;
		}
		
		public static function commaHandler(character:String, bytes:ByteArray):Atom
		{
			var result:Atom;
			return result;
		}
		
		public static function accentHandler(character:String, bytes:ByteArray):Atom
		{
			var result:Atom;
			return result;
		}
	}
}