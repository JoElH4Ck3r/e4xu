package org.wvxvws.xmlutils 
{
	
	/**
	* Converter class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Converter 
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
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * All of the methods of this class are static, there's no need 
		 * to instantiate it.
		 */
		public function Converter() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		// TODO: Add support to all HTML entities.
		/**
		 * Encodes a string using HTML entities supported by Flash Player.
		 * 
		 * @param	input	String. The string to be encoded.
		 * 
		 * @return	String. The encoded string.
		 */
		public static function encodeHTML(input:String):String
		{
			if (input)
			{
                var xml:XML = <a>{input}</a>;
                return xml.toXMLString().replace(/(^<a>)|(<\/a>$)/g, "");
            }
			return "";
		}
		
		// TODO: Add support to all HTML entities.
		/**
		 * Decodes a string which uses HTML enteties supported by Flash Player.
		 * 
		 * @param	input	String. The string to be decoded.
		 * 
		 * @return	String. The decoded string.
		 */
		public static function decodeHTML(input:String):String
		{
			if (input)
			{
                var xml:XML = <a/>;
                xml.replace(0, input);
                return String(xml);
            }
			return "";
		}
		
		// TODO: encodeUTFHTML
		public static function encodeUTFHTML(input:String):String
		{
			return "";
		}
		
		// TODO: encodeHEXHTML
		public static function encodeHEXHTML(input:String):String
		{
			return "";
		}
		
		// TODO: csvToXML
		public static function csvToXML(input:String):XML
		{
			return null;
		}
		
		// TODO: jsonToXML
		public static function jsonToXML(input:String):XML
		{
			return null;
		}
		
		// TODO: xmlToCSV
		public static function xmlToCSV(input:XML):String
		{
			return "";
		}
		
		// TODO: xmlToJSON
		public static function xmlToJSON(input:XML):String
		{
			return "";
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