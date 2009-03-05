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
		private static var _text:String;
		private static var _bytes:ByteArray;
		private static var _lines:Array;
		
		private static var _isLineComment:Boolean;
		private static var _isJavaComment:Boolean;
		private static var _isJavaCommentEnd:Boolean;
		
		private static var _isString:Boolean;
		private static var _isApostropheString:Boolean;
		
		private static var _isEscaped:Boolean;
		static private var _isRegExp:Boolean;
		static private var _isXML:Boolean;
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
			if (code is Class)
			{
				_bytes = new (code as Class)() as ByteArray;
				if (isUTF(_bytes))
				{
					_text = _bytes.toString();
					_lines = _text.split(/\n?\r\n?/gm);
					//trace(_lines.join("\r"));
				}
			}
			l = _lines.length;
			while (i < l)
			{
				s = 0;
				st = _lines[i];
				sl = st.length;
				lineLoop: while (s < sl)
				{
					chr = st.charAt(s);
					switch (chr)
					{
						case "\"":
							if (!_isEscaped && !_isLineComment && 
								!_isJavaComment && !_isString && 
								!_isApostropheString && !_isXML)
							{
								_isString = true;
								_isApostropheString = false;
								st = st.substr(0, s) + 
								"<span class=\"s0\">" + 
								st.substr(s, st.length);
								sl += 17;
								s += 17;
							}
							break;
						case "\'":
							if (!_isEscaped && !_isLineComment && 
								!_isJavaComment && !_isString && 
								!_isApostropheString)
							{
								_isString = true;
								_isApostropheString = true;
								st = st.substr(0, s) + 
								"<span class=\"s0\">" + 
								st.substr(s, st.length);
								sl += 17;
								s += 17;
							}
							break;
						case "\\":
							if (!_isRegExp) _isEscaped = true;
							break;
						case "/":
							if (!_isString && !_isApostropheString && 
								st.charAt(s - 1) == "/")
							{
								_isLineComment = true;
								st = st.substr(0, s - 1) + 
								"<span class=\"s1\">" + 
								st.substr(s - 1, st.length);
								break lineLoop;
							}
							else if (!_isString && !_isApostropheString && 
									st.charAt(s - 1) == "*")
							{
								_isJavaComment = false;
								_isJavaCommentEnd = true;
							}
							break;
						case "*":
							if (!_isString && !_isApostropheString 
								&& st.charAt(s - 1) == "/")
							{
								st = st.substr(0, s - 1) + 
								"<span class=\"s0\">" + 
								st.substr(s - 1, st.length);
								_isJavaComment = true;
								break lineLoop;
							}
							break;
					}
					s++;
				}
				if (_isApostropheString || _isString)
				{
					st += "</span>";
				}
				if (_isLineComment)
				{
					st += "</span>";
				}
				if (_isJavaCommentEnd)
				{
					_isJavaCommentEnd = false;
					st += "</span>";
				}
				_isLineComment = false;
				_isApostropheString = false;
				_isString = false;
				_lines[i] = st;
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
		
		private static function doString(string:String):String
		{
			return "<span class=\"s0\">" + string + "</span>";
		}
		
		private static function doComment(string:String):String
		{
			return "<span class=\"s1\">" + string + "</span>";
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