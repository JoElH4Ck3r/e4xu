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
		private static const SPACE:String = "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t";
		private static const HTML_ENTITIES:Function = function():Object
		{
			this["\u00A0"] = { d:"&#160;", h:"&nbsp;" };
			this["¡"] = { d:"&#161;", h:"&iexcl;" };
			this["¢"] = { d:"&#162;", h:"&cent;" };
			this["£"] = { d:"&#163;", h:"&pound;" };
			this["¤"] = { d:"&#164;", h:"&curren;" };
			this["¥"] = { d:"&#165;", h:"&yen;" };
			this["¦"] = { d:"&#166;", h:"&brvbar;" };
			this["§"] = { d:"&#167;", h:"&sect;" };
			this["¨"] = { d:"&#168;", h:"&uml;" };
			this["©"] = { d:"&#169;", h:"&copy;" };
			this["ª"] = { d:"&#170;", h:"&ordf;" };
			this["«"] = { d:"&#171;", h:"&laquo;" };
			this["¬"] = { d:"&#172;", h:"&not;" };
			this["­"] = { d:"&#173;", h:"&shy;" };
			this["®"] = { d:"&#174;", h:"&reg;" };
			this["¯"] = { d:"&#175;", h:"&macr;" };
			this["°"] = { d:"&#176;", h:"&deg;" };
			this["±"] = { d:"&#177;", h:"&plusmn;" };
			this["²"] = { d:"&#178;", h:"&sup2;" };
			this["³"] = { d:"&#179;", h:"&sup3;" };
			this["´"] = { d:"&#180;", h:"&acute;" };
			this["µ"] = { d:"&#181;", h:"&micro;" };
			this["¶"] = { d:"&#182;", h:"&para;" };
			this["·"] = { d:"&#183;", h:"&middot;" };
			this["¸"] = { d:"&#184;", h:"&cedil;" };
			this["¹"] = { d:"&#185;", h:"&sup1;" };
			this["º"] = { d:"&#186;", h:"&ordm;" };
			this["»"] = { d:"&#187;", h:"&raquo;" };
			this["¼"] = { d:"&#188;", h:"&frac14;" };
			this["½"] = { d:"&#189;", h:"&frac12;" };
			this["¾"] = { d:"&#190;", h:"&frac34;" };
			this["¿"] = { d:"&#191;", h:"&iquest;" };
			this["×"] = { d:"&#215;", h:"&times;" };
			this["÷"] = { d:"&#247;", h:"&divide;" };
			this["À"] = { d:"&#192;", h:"&Agrave;" };
			this["Á"] = { d:"&#193;", h:"&Aacute;" };
			this["Â"] = { d:"&#194;", h:"&Acirc;" };
			this["Ã"] = { d:"&#195;", h:"&Atilde;" };
			this["Ä"] = { d:"&#196;", h:"&Auml;" };
			this["Å"] = { d:"&#197;", h:"&Aring;" };
			this["Æ"] = { d:"&#198;", h:"&AElig;" };
			this["Ç"] = { d:"&#199;", h:"&Ccedil;" };
			this["È"] = { d:"&#200;", h:"&Egrave;" };
			this["É"] = { d:"&#201;", h:"&Eacute;" };
			this["Ê"] = { d:"&#202;", h:"&Ecirc;" };
			this["Ë"] = { d:"&#203;", h:"&Euml;" };
			this["Ì"] = { d:"&#204;", h:"&Igrave;" };
			this["Í"] = { d:"&#205;", h:"&Iacute;" };
			this["Î"] = { d:"&#206;", h:"&Icirc;" };
			this["Ï"] = { d:"&#207;", h:"&Iuml;" };
			this["Ð"] = { d:"&#208;", h:"&ETH;" };
			this["Ñ"] = { d:"&#209;", h:"&Ntilde;" };
			this["Ò"] = { d:"&#210;", h:"&Ograve;" };
			this["Ó"] = { d:"&#211;", h:"&Oacute;" };
			this["Ô"] = { d:"&#212;", h:"&Ocirc;" };
			this["Õ"] = { d:"&#213;", h:"&Otilde;" };
			this["Ö"] = { d:"&#214;", h:"&Ouml;" };
			this["Ø"] = { d:"&#216;", h:"&Oslash;" };
			this["Ù"] = { d:"&#217;", h:"&Ugrave;" };
			this["Ú"] = { d:"&#218;", h:"&Uacute;" };
			this["Û"] = { d:"&#219;", h:"&Ucirc;" };
			this["Ü"] = { d:"&#220;", h:"&Uuml;" };
			this["Ý"] = { d:"&#221;", h:"&Yacute;" };
			this["Þ"] = { d:"&#222;", h:"&THORN;" };
			this["ß"] = { d:"&#223;", h:"&szlig;" };
			this["à"] = { d:"&#224;", h:"&agrave;" };
			this["á"] = { d:"&#225;", h:"&aacute;" };
			this["â"] = { d:"&#226;", h:"&acirc;" };
			this["ã"] = { d:"&#227;", h:"&atilde;" };
			this["ä"] = { d:"&#228;", h:"&auml;" };
			this["å"] = { d:"&#229;", h:"&aring;" };
			this["æ"] = { d:"&#230;", h:"&aelig;" };
			this["ç"] = { d:"&#231;", h:"&ccedil;" };
			this["è"] = { d:"&#232;", h:"&egrave;" };
			this["é"] = { d:"&#233;", h:"&eacute;" };
			this["ê"] = { d:"&#234;", h:"&ecirc;" };
			this["ë"] = { d:"&#235;", h:"&euml;" };
			this["ì"] = { d:"&#236;", h:"&igrave;" };
			this["í"] = { d:"&#237;", h:"&iacute;" };
			this["î"] = { d:"&#238;", h:"&icirc;" };
			this["ï"] = { d:"&#239;", h:"&iuml;" };
			this["ð"] = { d:"&#240;", h:"&eth;" };
			this["ñ"] = { d:"&#241;", h:"&ntilde;" };
			this["ò"] = { d:"&#242;", h:"&ograve;" };
			this["ó"] = { d:"&#243;", h:"&oacute;" };
			this["ô"] = { d:"&#244;", h:"&ocirc;" };
			this["õ"] = { d:"&#245;", h:"&otilde;" };
			this["ö"] = { d:"&#246;", h:"&ouml;" };
			this["ø"] = { d:"&#248;", h:"&oslash;" };
			this["ù"] = { d:"&#249;", h:"&ugrave;" };
			this["ú"] = { d:"&#250;", h:"&uacute;" };
			this["û"] = { d:"&#251;", h:"&ucirc;" };
			this["ü"] = { d:"&#252;", h:"&uuml;" };
			this["ý"] = { d:"&#253;", h:"&yacute;" };
			this["þ"] = { d:"&#254;", h:"&thorn;" };
			this["ÿ"] = { d:"&#255;", h:"&yuml;" };
			return this;
		}
		
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
		//  Constructor
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
		
		public static function encodeHTMLEntities(input:String, decimal:Boolean = false):String
		{
			var table:Object = HTML_ENTITIES();
			var chr:String = "";
			var i:int;
			var lnt:int = input.length;
			var output:String = "";
			var prop:String = decimal ? "d" : "h";
			while (i < lnt)
			{
				chr = input.charAt(i);
				if (chr in table)
				{
					output += table[chr][prop];
				}
				else
				{
					output += chr;
				}
				i++;
			}
			return output;
		}
		
		public static function formatXMLRecursive(xml:XML, level:int = 0):String
		{
			var attribs:Array = [];
			var addedSpace:String = SPACE.substr(0, level);
			if (xml.nodeKind() != "element")
			{
				return addedSpace + xml.toXMLString();
			}
			var childString:String = "";
			
			xml.@*.(attribs.push("\r" + addedSpace + "\t" + 
				qnameToXMLName(namespace(), name()) + "=\"" + valueOf() + "\""));
			var list:XMLList = xml.children();
			var declarations:Array = xml.namespaceDeclarations();
			for each(var ns:Namespace in declarations)
			{
				attribs.push("\r" + addedSpace + "\txmlns:" + 
							ns.prefix + "=\"" + ns.uri + "\"");
			}
			for each(var xn:XML in list)
			{
				childString += (childString ? "\r" : "") + 
					formatXMLRecursive(xn, level + 1);
			}
			return (addedSpace + "<" + qnameToXMLName(xml.namespace(), xml.name()) + 
				(attribs.length ? attribs.join("") : "") + 
				((Boolean(attribs.length) && Boolean(childString)) ? "\r" + addedSpace + 
				"\t>\r" : ((Boolean(attribs.length) && !Boolean(childString)) ? "\r" + 
				addedSpace + "\t/>" : (!Boolean(attribs.length) && 
				Boolean(childString)) ? ">\r" : "")) + (Boolean(childString) ? 
				childString + "\r" + addedSpace + "</" + 
				qnameToXMLName(xml.namespace(), xml.name()) + ">" : 
				(attribs.length ? "" : "/>")));
		}
		
		private static function qnameToXMLName(ns:Namespace, name:QName):String
		{
			var xname:String = name.toString();
			if (xname.indexOf("::") > -1)
			{
				return xname.replace(/^.+?\:\:/, ns.prefix + ":");
			}
			return xname; 
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