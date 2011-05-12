package org.wvxvws.automation.syntax
{
	import flash.utils.ByteArray;
	
	import org.wvxvws.automation.language.Atom;

	public class StandardHandlers
	{
		public function StandardHandlers() { super(); }
		
		public static function openParenHandler(
			character:String, bytes:ByteArray):Atom
		{
			bytes.position++;
			return Reader.push(Reader.readCons(bytes));
		}
		
		public static function closingParenHandler(
			character:String, bytes:ByteArray):Atom
		{
			return Reader.pop();
		}
		
		public static function sharpHandler(character:String, bytes:ByteArray):Atom
		{
			var result:Atom;
			return result;
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