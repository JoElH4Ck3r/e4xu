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
		
		private static const KEYWORDS:Array =
		[
			"class", "dynamic", "extends", "implements", "import", "interface", "new", "case", "do", "while", "else", "if", "for", "in", "switch", "throw", "intrinsic",
			"private", "public", "static", "get", "set", "function", "var", "try", "catch", "finally", "while", "with", "default", "break", "continue", "delete", "return",
			"final", "each", "internal", "native", "override", "protected", "const", "namespace", "package", "include", "use", "AS3"
		];
		
		private static const SECONDARY_KEYWORDS:Array =
		[
			"super", "this", "null", "Infinity", "NaN", "undefined", "true", "false", "is", "as", "instanceof", "typeof"
		];
		
		private static const CLASSES:Array =
		[
			"void", "Null", "ArgumentError", "arguments", "Array", "Boolean", "Class", "Date", "DefinitionError", "Error", "EvalError", "Function", "int", "Math", "Namespace",
			"Number", "Object", "QName", "RangeError", "ReferenceError", "RegExp", "SecurityError", "String", "SyntaxError", "TypeError", "uint", "URIError",
			"VerifyError", "XML", "XMLList", "Accessibility", "AccessibilityProperties", "ActionScriptVersion", "AVM1Movie", "Bitmap", "BitmapData",
			"BitmapDataChannel", "BlendMode", "CapsStyle", "DisplayObject", "DisplayObjectContainer", "FrameLabel", "GradientType", "Graphics",
			"IBitmapDrawable", "InteractiveObject", "InterpolationMethod", "JointStyle", "LineScaleMode", "Loader", "LoaderInfo", "MorphShape", "MovieClip",
			"PixelSnapping", "Scene", "Shape", "SimpleButton", "SpreadMethod", "Sprite", "Stage", "StageAlign", "StageDisplayState", "StageQuality", "StageScaleMode",
			"SWFVersion", "EOFError", "IllegalOperationError", "InvalidSWFError", "IOError", "MemoryError", "ScriptTimeoutError", "StackOverflowError",
			"ActivityEvent", "AsyncErrorEvent", "ContextMenuEvent", "DataEvent", "ErrorEvent", "Event", "EventDispatcher", "EventPhase", "FocusEvent",
			"FullScreenEvent", "HTTPStatusEvent", "IEventDispatcher", "IMEEvent", "IOErrorEvent", "KeyboardEvent", "MouseEvent", "NetStatusEvent", "ProgressEvent",
			"SecurityErrorEvent", "StatusEvent", "SyncEvent", "TextEvent", "TimerEvent", "ExternalInterface", "BevelFilter", "BitmapFilter",
			"BitmapFilterQuality", "BitmapFilterType", "BlurFilter", "ColorMatrixFilter", "ConvolutionFilter", "DisplacementMapFilter",
			"DisplacementMapFilterMode", "DropShadowFilter", "GlowFilter", "GradientBevelFilter", "GradientGlowFilter", "ColorTransform", "Matrix",
			"Point", "Rectangle", "Transform", "Camera", "ID3Info", "Microphone", "Sound", "SoundChannel", "SoundLoaderContext", "SoundMixer", "SoundTransform",
			"Video", "FileFilter", "FileReference", "FileReferenceList", "IDynamicPropertyOutput", "IDynamicPropertyWriter", "LocalConnection",
			"NetConnection", "NetStream", "ObjectEncoding", "Responder", "SharedObject", "SharedObjectFlushStatus", "Socket", "URLLoader",
			"URLLoaderDataFormat", "URLRequest", "URLRequestHeader", "URLRequestMethod", "URLStream", "URLVariables", "XMLSocket",
			"PrintJob", "PrintJobOptions", "PrintJobOrientation", "ApplicationDomain", "Capabilities", "IME", "IMEConversionMode", "LoaderContext",
			"Security", "SecurityDomain", "SecurityPanel", "System", "AntiAliasType", "CSMSettings", "Font", "FontStyle", "FontType", "GridFitType",
			"StaticText", "StyleSheet", "TextColorType", "TextDisplayMode", "TextField", "TextFieldAutoSize", "TextFieldType", "TextFormat",
			"TextFormatAlign", "TextLineMetrics", "TextRenderer", "TextSnapshot", "ContextMenu", "ContextMenuBuiltInItems", "ContextMenuItem",
			"Keyboard", "KeyLocation", "Mouse", "ByteArray", "Dictionary", "Endian", "IDataInput", "IDataOutput", "IExternalizable", "Proxy", "Timer",
			"XMLDocument", "XMLNode", "XMLNodeType"
		];
		
		private static const DOC_KEYWORDS:Array =
		[
			"author", "copy", "default", "deprecated", "eventType", "example", "exampleText", "exception", "haxe", "inheritDoc", "internal", "link", "mtasc", "mxmlc",
			"param", "private", "return", "see", "serial", "serialData", "serialField", "since", "throws", "usage", "version"
		];
		
		private static const UID:String = "8b8b0c1e2de4c5e70d004a11cdb62bc2"; // 32
		private static const SPAN_BEGIN:String = "<8b8b0c1e2de4c5e70d004a11cdb62bc2 class=\"xxx\">"; // 46
		private static const SPAN_END:String = "</8b8b0c1e2de4c5e70d004a11cdb62bc2>"; // 35
		
		private static const JCOMMENT_RE_HELPER:String = "$1<8b8b0c1e2de4c5e70d004a11cdb62bc2 class=\"s00\">"; // 35
		
		private static const NOT_SPAN:RegExp = /<(8b8b0c1e2de4c5e70d004a11cdb62bc2)( class="...">)(.+?)(<\/\1>)/g;
		private static const TRAILING_SPACES:RegExp = /^((\s|\t)+)((.+?)\1)*/g;
		
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
		private static var _isRegExp:Boolean;
		private static var _isXML:Boolean;
		private static var _isNumber:Boolean;
		private static var _isHex:Boolean;
		
		private static var _xmlNodeType:int;
		private static var _isOpenNode:Boolean;
		private static var _xmlBody:String;
		
		private static var _init:Boolean;
		
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
			var xmlTagStartEnd:int;
			var xmlTagEnd:int;
			
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
				else if (_isXML && _isOpenNode)
				{
					xmlTagEnd = lineIsXMLEnd(st);
					if (xmlTagEnd > -1)
					{
						_isXML = false;
						st = st.substr(0, xmlTagEnd) + 
						SPAN_END + 
						st.substr(xmlTagEnd, st.length);
						
						st = st.replace(/^([\t\s]+)/, "$1<8b8b0c1e2de4c5e70d004a11cdb62bc2 class=\"s05\">");
						s += st.indexOf(HTML) + 80;
						sl = st.length;
					}
					else
					{
						_xmlBody += st;
						st = st.replace(/^([\t\s]+)/, "$1<8b8b0c1e2de4c5e70d004a11cdb62bc2 class=\"s05\">");
						sl = st.length;
						s = sl;
					}
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
							else if (_isXML) _xmlBody += chr;
							break;
						case "\'":
							if (!_isEscaped && !_isLineComment && 
								!_isXML && !_isJavaComment && !_isString && 
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
							else if (_isXML) _xmlBody += chr;
							break;
						case "\\":
							_isEscaped = true;
							if (_isXML) _xmlBody += chr;
							break;
						case "/":
							if (!_isXML && !_isString && !_isApostropheString && 
								st.charAt(s - 1) == "/")
							{
								_isLineComment = true;
								st = st.substr(0, s - 1) + 
								COMMENT + 
								st.substr(s - 1, st.length);
								break lineLoop;
							}
							else if (!_isString && !_isApostropheString && 
									!_isXML && st.charAt(s - 1) == "*")
							{
								_isJavaComment = false;
								_isJavaCommentEnd = true;
							}
							else if (!_isApostropheString && !_isString &&
									!_isXML && !_isJavaComment && !_isRegExp)
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
							else if (!_isXML && _isRegExp && !_isEscaped)
							{
								_isRegExp = false;
								st = st.substr(0, s + 1) + 
								SPAN_END + 
								st.substr(s + 1, st.length);
								sl += 35;
								s += 35;
							}
							else if (_isXML) _xmlBody += chr;
							break;
						case "*":
							if (!_isXML && !_isString && !_isApostropheString 
								&& st.charAt(s - 1) == "/")
							{
								st = st.substr(0, s - 1) + 
								JCOMMENT + 
								st.substr(s - 1, st.length);
								_isJavaComment = true;
								break lineLoop;
							}
							else if (_isXML) _xmlBody += chr;
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
								!_isNumber && !_isHex && !_isXML &&
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
							else if ((!_isXML && _isNumber && !st.charAt(s + 1).match(/\d/g).length) || 
									(!_isXML && _isHex && !st.charAt(s + 1).match(/\d|A|B|C|D|E|F/gi).length &&
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
							else if (_isXML) {_xmlBody += chr; trace("entered");}
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
							if (!_isXML && _isHex && 
								!st.charAt(s + 1).match(/\d|A|B|C|D|E|F/gi).length)
							{
								_isHex = false;
								_isNumber = false;
								st = st.substr(0, s + 1) + 
								SPAN_END + 
								st.substr(s + 1, st.length);
								sl += 35;
								s += 35;
							}
							else if (_isXML) _xmlBody += chr;
							break;
						case "<":
							if (!_isXML && !_isJavaComment && !_isApostropheString && 
								!_isString && st.charAt(s - 1) !== "." && 
								st.charAt(s + 1) !== " " && st.charAt(s + 1) !== "\t")
							{
								xmlTagStartEnd = checkForXMLStart(st, s, i);
								if (xmlTagStartEnd > -1)
								{
									trace(s, xmlTagStartEnd);
									_isXML = true;
									st = st.substr(0, s) + 
									HTML + 
									st.substr(s, st.length);
									sl += (46 + xmlTagStartEnd);
									s += (46 + xmlTagStartEnd);
								}
							}
							else if (_isXML) _xmlBody += chr;
							break;
						case ">":
							if (_isXML && checkForXMLEnd(st, s, i))
							{
								_isXML = false;
								_isOpenNode = false;
								st = st.substr(0, s + 1) + 
								SPAN_END + 
								st.substr(s + 1, st.length);
								sl += 35;
								s += 35;
								xmlTagEnd = s;
							}
							else if (_isXML) _xmlBody += chr;
							break;
						default:
							if ((_isNumber || _isHex) && chr != "x" && !chr.match(/\d|A|B|C|D|E|F/gi).length)
							{
								_isHex = false;
								_isNumber = false;
								st = st.substr(0, s) + 
								SPAN_END + 
								st.substr(s, st.length);
								sl += 35;
								s += 35;
							}
							else if (_isXML)
							{
								_xmlBody += chr;
							}
							break;
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
				if (_isXML) st += SPAN_END;
				if (_isJavaCommentEnd)
				{
					_isJavaCommentEnd = false;
					st += SPAN_END;
				}
				_lines[i] = htmlEncode(st);
				if (!_isJavaComment && !_isLineComment)
				{
					_lines[i] = doKeyWords(_lines[i]);
				}
				else if (_isJavaComment)
				{
					_lines[i] = doJDocKeywords(_lines[i]);
				}
				_isLineComment = false;
				_isApostropheString = false;
				_isString = false;
				_isRegExp = false;
				_isNumber = false;
				_isHex = false;
				
				i++;
			}
			l = _lines.length;
			i = 0;
			st = "";
			while (i < l)
			{
				st += "<li class=\"c " + ((i % 2) ? "even" : "odd") + 
					"\"><span class=\"cd\">" + _lines[i] + "</li>\r";
				i++;
			}
			return "<ol class=\"codeOL\">" + st + "</ol>";
		}
		
		static private function doJDocKeywords(input:String):String
		{
			var re:RegExp;
			var s:String;
			for each (s in DOC_KEYWORDS)
			{
				if (input.indexOf("@" + s) < 0) continue;
				re = new RegExp("(@)(" + s + ")(\\W)", "g");
				input = input.replace(re, "<span class=\"s08\">$1$2</span>$3");
			}
			return input;
		}
		
		static private function doKeyWords(input:String):String
		{
			var re:RegExp;
			var s:String;
			for each (s in KEYWORDS)
			{
				if (input.indexOf(s) < 0) continue;
				if (s == "class")
				{
					re = new RegExp("(^|\\W)(" + s + ")([^=\w])", "g");
				}
				else
				{
					re = new RegExp("(^|\\W)(" + s + ")(\\W)", "g");
				}
				input = input.replace(re, "$1<span class=\"s06\">$2</span>$3");
			}
			for each (s in SECONDARY_KEYWORDS)
			{
				if (input.indexOf(s) < 0) continue;
				re = new RegExp("(^|\\W)(" + s + ")(\\W)", "g");
				input = input.replace(re, "$1<span class=\"s06\">$2</span>$3");
			}
			for each (s in CLASSES)
			{
				if (input.indexOf(s) < 0) continue;
				re = new RegExp("(^|\\W)(" + s + ")(\\W)", "g");
				input = input.replace(re, "$1<span class=\"s07\">$2</span>$3");
			}
			return input;
		}
		
		static private function lineIsXMLEnd(input:String, pos:int = 0):int
		{
			var lastIndex:int = input.indexOf(">", pos);
			var xml:XML;
			if (lastIndex < 0) return lastIndex;
			try
			{
				trace(_xmlBody + input.substr(0, lastIndex + 1));
				xml = XML(_xmlBody + input.substr(0, lastIndex + 1));
				return lastIndex;
			}
			catch (error:Error)
			{
				return lineIsXMLEnd(input, lastIndex + 1);
			}
			return -1;
		}
		
		static private function checkForXMLEnd(currentLine:String, lineIndex:int, 
														arrayIndex:int):Boolean
		{
			switch (_xmlNodeType)
			{
				case 1:
					if (currentLine.charAt(lineIndex - 1) == currentLine.charAt(lineIndex - 2) == "-")
					{
						return true;
					}
					break;
				case 2:
					if (currentLine.charAt(lineIndex - 1) == currentLine.charAt(lineIndex - 2) == "]")
					{
						return true;
					}
					break;
				case 3:
					if (currentLine.charAt(lineIndex - 1) == "?")
					{
						return true;
					}
					break;
				case 4:
					if (!_isOpenNode && currentLine.charAt(lineIndex - 1) == "/")
					{
						return true;
					}
					break;
			}
			return false;
		}
		
		static private function checkForXMLStart(currentLine:String, lineIndex:int, 
														arrayIndex:int):int
		{
			var lastGT:int = currentLine.indexOf("/>", lineIndex);
			var tagEnd:int;
			
			var subtr:int;
			
			if (lastGT < 0)
			{
				if (lastGT < lineIndex)
				{
					lastGT = currentLine.indexOf("-->", lineIndex);
					subtr = 3;
				}
				
				if (lastGT < lineIndex)
				{
					lastGT = currentLine.indexOf("]]>", lineIndex);
					subtr = 3;
				}
				if (lastGT < lineIndex)
				{
					lastGT = currentLine.indexOf("?>", lineIndex);
					subtr = 2;
				}
				if (lastGT < lineIndex)
				{
					lastGT = currentLine.indexOf(">", lineIndex);
					_isOpenNode = true;
					subtr = 1;
				}
				
				if (lastGT < lineIndex)
				{
					lastGT = currentLine.length;
					subtr = 0;
				}
				tagEnd = currentLine.length;
				_xmlBody = currentLine.substring(lineIndex, lastGT);// - subtr);
			}
			else
			{
				tagEnd = lastGT - 2;
				_xmlBody = currentLine.substring(lineIndex, tagEnd);
			}
			if (checkValidOpenTag(_xmlBody))
			{
				return tagEnd - (lineIndex + 2);
			}
			else
			{
				_xmlBody = "";
				return -1;
			}
		}
		
		static private function checkValidOpenTag(input:String):Boolean
		{
			if (input.match(/^<--/g).length)
			{
				_xmlNodeType = 1;
				return true;
			}
			if (input.match(/^<!\[CDATA\[/gi).length)
			{
				_xmlNodeType = 2;
				return true;
			}
			if (input.match(/^<\?\w/g).length)
			{
				_xmlNodeType = 3;
				return true;
			}
			if (input.match(/^<\w[\w\.\-\$:_]*([\s\t]+?[\w\.\-\$:_]*\s*=\s*("|')[^\2]*\2)*$/g).length)
			{
				_xmlNodeType = 4;
				return true;
			}
			return false;
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
			//if ((traceHelper++) < 10) trace(string);
			var result:String = string.replace(NOT_SPAN, encodeHelper);
			if (result == string) return encodeHTML(string) + "<span/>";
			return result.replace(TRAILING_SPACES, keepTrailingSpace) + "<span/>";
		}
		
		static private function keepTrailingSpace(...rest):String
		{
			return rest[0].split(" ").join("&nbsp;").split("\t").join("&nbsp;&nbsp;&nbsp;&nbsp;");
		}
		
		private static function encodeHelper(...rest):String
		{
			return ("<span" + rest[2] + encodeHTML(rest[3]) + "</span>");
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