package org.wvxvws.parsers 
{
	import flash.utils.ByteArray;
	
	/**
	* CodeParser class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class CodeParser 
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
		private static const UID:String = "8b8b0c1e2de4c5e70d004a11cdb62bc2"; // 32
		private static const SPAN_BEGIN:String = "<8b8b0c1e2de4c5e70d004a11cdb62bc2 class=\"xxx\">"; // 46
		private static const SPAN_END:String = "</8b8b0c1e2de4c5e70d004a11cdb62bc2>"; // 35
		
		private static const JCOMMENT_RE_HELPER:String = "$1<8b8b0c1e2de4c5e70d004a11cdb62bc2 class=\"s00\">"; // 35
		
		private static const NOT_SPAN:RegExp = /(.*)<(8b8b0c1e2de4c5e70d004a11cdb62bc2)( class="...">)(.*)(<\/\2>)(.*)/g
		
		private static const JCOMMENT_C:String = "s00";
		private static const COMMENT_C:String = "s01";
		private static const STRING_C:String = "s02";
		private static const NUMBER_C:String = "s03";
		private static const REGEXP_C:String = "s04";
		private static const HTML_C:String = "s05";
		private static const BUILTIN_C:String = "s06";
		private static const TYPE_C:String = "s07";
		
		private static var JCOMMENT:String;
		private static var COMMENT:String;
		private static var STRING:String;
		private static var NUMBER:String;
		private static var REGEXP:String;
		private static var HTML:String;
		private static var BUILTIN:String;
		private static var TYPE:String;
		
		private static var _text:String;
		private static var _bytes:ByteArray;
		private static var _lines:Array;
		
		private static var _isLineComment:Boolean;
		private static var _isJavaComment:Boolean;
		private static var _isJavaCommentEnd:Boolean;
		
		private static var _isString:Boolean;
		private static var _isApostropheString:Boolean;
		
		private static var _isEscaped:Boolean;
		private static var _isPreviousEscaped:Boolean;
		static private var _isRegExp:Boolean;
		static private var _isXML:Boolean;
		static private var _isNumber:Boolean;
		static private var _isHex:Boolean;
		
		static private var _init:Boolean;
		
		private static var traceHelper:int;
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function CodeParser() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function parse(code:Object):String
		{
			var i:int;
			var l:int;
			var s:int;
			var sl:int;
			var st:String;
			var chr:String;
			var reCheck:String;
			if (!_init) _init = init();
			if (code is Class)
			{
				_bytes = new (code as Class)() as ByteArray;
				if (isUTF(_bytes))
				{
					_text = _bytes.toString();
					_lines = _text.split(/\n?\r\n?/gm);
				}
			}
			l = _lines.length;
			while (i < l)
			{
				s = 0;
				st = _lines[i];
				sl = st.length;
				if (_isJavaComment)
				{
					st = st.replace(/^([\t\s]+)/, "$1<8b8b0c1e2de4c5e70d004a11cdb62bc2 class=\"s00\">");
					s += st.indexOf(JCOMMENT) + 45;
					sl = st.length;
				}
				lineLoop: while (s < sl)
				{
					if (_isEscaped) _isPreviousEscaped = true;
					chr = st.charAt(s);
					switch (chr)
					{
						case "\"":
							if (!_isEscaped && !_isLineComment && 
								!_isJavaComment && !_isString && 
								!_isApostropheString && !_isXML && !_isRegExp)
							{
								_isString = true;
								_isApostropheString = false;
								st = st.substr(0, s) + 
								STRING + 
								st.substr(s, st.length);
								sl += 46;
								s += 46;
							}
							else if (!_isEscaped && !_isXML && 
									!_isApostropheString && _isString && 
									!_isJavaComment && !_isRegExp)
							{
								_isString = false;
								_isApostropheString = false;
								st = st.substr(0, s + 1) + 
								SPAN_END + 
								st.substr(s + 1, st.length);
								sl += 35;
								s += 35;
							}
							break;
						case "\'":
							if (!_isEscaped && !_isLineComment && 
								!_isJavaComment && !_isString && 
								!_isApostropheString && !_isRegExp)
							{
								_isString = true;
								_isApostropheString = true;
								st = st.substr(0, s) + 
								STRING + 
								st.substr(s, st.length);
								sl += 46;
								s += 46;
							}
							else if (!_isEscaped && !_isXML && 
									_isApostropheString && !_isString && 
									!_isJavaComment && !_isRegExp)
							{
								_isApostropheString = false;
								_isString = false;
								st = st.substr(0, s + 1) + 
								SPAN_END + 
								st.substr(s + 1, st.length);
								sl += 35;
								s += 35;
							}
							break;
						case "\\":
							_isEscaped = true;
							break;
						case "/":
							if (!_isString && !_isApostropheString && 
								st.charAt(s - 1) == "/")
							{
								_isLineComment = true;
								st = st.substr(0, s - 1) + 
								COMMENT + 
								st.substr(s - 1, st.length);
								break lineLoop;
							}
							else if (!_isString && !_isApostropheString && 
									st.charAt(s - 1) == "*")
							{
								_isJavaComment = false;
								_isJavaCommentEnd = true;
							}
							else if (!_isApostropheString && !_isString &&
									!_isJavaComment && !_isRegExp)
							{
								reCheck = st.substr(s - 1);
								if (st.charAt(s + 1) !== "*" && st.charAt(s + 1) !== "/" &&
									reCheck.match(/^[^\\]\/(.*)[^\\]\//g).length)
								{
									_isRegExp = true;
									st = st.substr(0, s) + 
									REGEXP + 
									st.substr(s, st.length);
									sl += 46;
									s += 46;
								}
							}
							else if (_isRegExp && !_isEscaped)
							{
								_isRegExp = false;
								st = st.substr(0, s + 1) + 
								SPAN_END + 
								st.substr(s + 1, st.length);
								sl += 35;
								s += 35;
							}
							break;
						case "*":
							if (!_isString && !_isApostropheString 
								&& st.charAt(s - 1) == "/")
							{
								st = st.substr(0, s - 1) + 
								JCOMMENT + 
								st.substr(s - 1, st.length);
								_isJavaComment = true;
								break lineLoop;
							}
							break;
						case "0":
						case "1":
						case "2":
						case "3":
						case "4":
						case "5":
						case "6":
						case "7":
						case "8":
						case "9":
							if (!_isJavaComment && !_isLineComment && 
								!_isRegExp && !_isApostropheString && 
								!_isNumber && !_isHex &&
								!_isString && st.charAt(s - 1).match(/\W/g).length)
							{
								if (st.charAt(s + 1) == "x")
								{
									_isHex = true;
								}
								else
								{
									_isNumber = true;
								}
								st = st.substr(0, s) + 
								NUMBER + 
								st.substr(s, st.length);
								sl += 46;
								s += 46;
							}
							else if ((_isNumber && !st.charAt(s + 1).match(/\d/g).length) || 
									(_isHex && !st.charAt(s + 1).match(/\d|A|B|C|D|E|F/gi).length &&
									st.charAt(s + 1) != "x"))
							{
								_isNumber = false;
								_isHex = false;
								st = st.substr(0, s + 1) + 
								SPAN_END + 
								st.substr(s + 1, st.length);
								sl += 35;
								s += 35;
							}
							break;
						case "A":
						case "B":
						case "C":
						case "D":
						case "E":
						case "F":
						case "a":
						case "b":
						case "c":
						case "d":
						case "e":
						case "f":
							if (_isHex && !st.charAt(s + 1).match(/\d|A|B|C|D|E|F/gi).length)
							{
								_isHex = false;
								_isNumber = false;
								st = st.substr(0, s + 1) + 
								SPAN_END + 
								st.substr(s + 1, st.length);
								sl += 35;
								s += 35;
							}
							break;
						default:
							if (_isNumber || _isHex)
							{
								_isHex = false;
								_isNumber = false;
								st = st.substr(0, s) + 
								SPAN_END + 
								st.substr(s, st.length);
								sl += 35;
								s += 35;
							}
					}
					if (_isPreviousEscaped)
					{
						_isEscaped = false;
						_isPreviousEscaped = false;
					}
					s++;
				}
				if (_isApostropheString || _isString) st += SPAN_END;
				if (_isLineComment) st += SPAN_END;
				if (_isRegExp) st += SPAN_END;
				if (_isNumber) st += SPAN_END;
				if (_isHex) st += SPAN_END;
				if (_isJavaComment) st += SPAN_END;
				if (_isJavaCommentEnd)
				{
					_isJavaCommentEnd = false;
					st += SPAN_END;
				}
				_isLineComment = false;
				_isApostropheString = false;
				_isString = false;
				_isRegExp = false;
				_isNumber = false;
				_isHex = false;
				_lines[i] = htmlEncode(st);
				i++;
			}
			return _lines.join("\r");
		}
		
		private static function isUTF(bytes:ByteArray):Boolean
		{
			bytes.position = 0;
			if (bytes.readUnsignedByte() != 0xEF) return false;
			if (bytes.readUnsignedByte() != 0xBB) return false;
			if (bytes.readUnsignedByte() != 0xBF) return false;
			return true;
		}
		
		private static function init():Boolean
		{
			JCOMMENT = SPAN_BEGIN.replace(/xxx/g, JCOMMENT_C);
			COMMENT = SPAN_BEGIN.replace(/xxx/g, COMMENT_C);
			STRING = SPAN_BEGIN.replace(/xxx/g, STRING_C);
			NUMBER = SPAN_BEGIN.replace(/xxx/g, NUMBER_C);
			REGEXP = SPAN_BEGIN.replace(/xxx/g, REGEXP_C);
			HTML = SPAN_BEGIN.replace(/xxx/g, HTML_C);
			BUILTIN = SPAN_BEGIN.replace(/xxx/g, BUILTIN_C);
			TYPE = SPAN_BEGIN.replace(/xxx/g, TYPE_C);
			return true;
		}
		
		private static function htmlEncode(string:String):String
		{
			var result:String = string.replace(NOT_SPAN, encodeHelper);
			if (result == string) return encodeHTML(string) + "<br/>";
			return result + "<br/>";
		}
		
		private static function encodeHelper(...rest):String
		{
			return (encodeHTML(rest[1]) + "<span" + rest[3] + encodeHTML(rest[4]) + 
					(rest[5].length ? "</span>" : "") + encodeHTML(rest[6]));
		}
		
		private static function encodeHTML(input:String):String
		{
			if (input)
			{
                var xml:XML = <a>{ replaceWhiteSpace(input) }</a>;
                return xml.toXMLString().replace(/(^<a>)|(<\/a>$)/g, "").split("\u00A0").join("&nbsp;");
            }
			return "";
		}
		
		private static function replaceWhiteSpace(input:String):String
		{
			return input.split(" ").join("\u00A0").split("\t").join("\u00A0\u00A0\u00A0\u00A0");
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