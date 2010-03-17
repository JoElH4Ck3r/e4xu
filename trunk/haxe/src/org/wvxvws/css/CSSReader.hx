/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.css;

class CSSReader 
{
	private static var AMPERSAND:String = "&";
	private static var ASTERISK:String = "*";
	private static var AT:String = "@";
	private static var BRACKET_L:String = "{";
	private static var BRACKET_R:String = "}";
	private static var CIRCUMFLEX:String = "^";
	private static var COMMA:String = ",";
	private static var COLON:String = ":";
	private static var DIGIT:String = "0123456789";
	private static var DOLLAR:String = "$";
	private static var DOT:String = ".";
	private static var EQUALS:String = "=";
	private static var ESCAPE:String = "\\";
	private static var EXCLAIM:String = "!";
	private static var GT:String = ">";
	private static var HYPHEN:String = "-";
	private static var LETTER:String = 
		"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$";
	private static var PAREN_L:String = "(";
	private static var PAREN_R:String = ")";
	private static var QUESTION:String = "?";
	private static var QUOTE:String = "\"";
	private static var PIPE:String = "|";
	private static var PLUS:String = "+";
	private static var SEMICOLON:String = ";";
	private static var SHARP:String = "#";
	private static var SQARE_L:String = "[";
	private static var SQARE_R:String = "]";
	private static var SPACE:String = " ";
	private static var SLASH:String = "/";
	private static var TILDA:String = "~";
	private static var WHITE:String = " \r\n\t";
	
	private static var FALSE:String = "false";
	private static var NULL:String = "null";
	private static var TRUE:String = "true";
	private static var UNDEFINED:String = "undefined";
	
	private static var KEWORD_DEFINE:String = "define";
	private static var KEWORD_ELIF:String = "elif";
	private static var KEWORD_ELSE:String = "else";
	private static var KEWORD_END:String = "end";
	private static var KEWORD_IF:String = "if";
	private static var KEWORD_IMPORT:String = "import";
	private static var KEWORD_RESOURCE:String = "resource";
	
	private var _char:String;
	private var _definitions:Hash<String>;
	//private var _global:CSSGlobal;
	private var _importedDefinitions:List<Ns>;
	private var _length:Int;
	private var _position:Int;
	private var _source:String;
	//private var _table:CSSTable;
	
	private var _currentDefinition:Dynamic;
	private var _currentId:UInt;
	private var _currentKeyword:String;
	private var _currentName:String;
	private var _currentOperator:String;
	private var _currentProperty:String;
	//private var _currentRule:CSSRule;
	private var _currentStyle:String;
	private var _currentValue:Dynamic;
	
	private var _tKeyword:CSSToken;
	private var _tNameSpace:CSSToken;
	private var _tComment:CSSToken;
	private var _tVarName:CSSToken;
	private var _tScopeThis:CSSToken;
	private var _tScopeGlob:CSSToken;
	private var _tNewVal:CSSToken;
	private var _tByRef:CSSToken;
	private var _tByVal:CSSToken;
	private var _tStatProp:CSSToken;
	private var _tInstProp:CSSToken;
	
	private var _tBoolVal:CSSToken;
	private var _tFloatVal:CSSToken;
	private var _tIntVal:CSSToken;
	private var _tNullVal:CSSToken;
	private var _tDynamicVal:CSSToken;
	
	private var _tInvoke:CSSToken;
	private var _tDefinition:CSSToken;
	
	public function new(?source:String) 
	{
		this._tKeyword = new CSSToken();
		this._tKeyword.follows = 
			cast [CSSTokenType.BoolVal, CSSTokenType.Comment, 
			CSSTokenType.Invoke, CSSTokenType.VarName];
		if (source != null) this.read(source);
	}
	
	public function read(source:String):Void
	{
		this._source = source;
		this._position = 0;
		this._length = this._source.length;
		//this._global = new CSSGlobal();
		//this._table = new CSSTable(this._global);
		// TEST
		//this.readWhite();
		//this.readImports();
		//this.readDefine();
		//trace(this._importedDefinitions);
		//this._definitions
		//for (i in this._definitions)
			//trace("key : " + i + ", value : " + this._definitions.get(i));
		//trace(this._position + " : " + this._length);
	}
	
	//public function table():CSSTable { return this._table; }
	
	/**
	 * Ported
	 */
	private function readChar():Bool
	{
		var irc:UInt;
		var inc:UInt;
		
		this._char = this._source.charAt(this._position);
		if (this._char == SLASH)
		{
			if (this._source.charAt(this._position + 1) == SLASH)
			{
				irc = this._source.indexOf("\r", this._position + 1);
				inc = this._source.indexOf("\n", this._position + 1);
				this._position = Std.int(Math.min(irc, inc) + 1);
				this._char = this._source.charAt(this._position);
			}
		}
		this._position++;
		return this._length >= this._position;
	}
	/*
	private function readSelector():Bool
	{
		var name:Bool;
		var buff:List<String> = new List<String>[];
		var cName:String;
		
		readLoop: while (this.readChar())
		{
			switch (true)
			{
				case (WHITE.indexOf(this._char) > -1):
					this.readWhite();
					break;
				case (LETTER.indexOf(this._char) > -1):
					//if (name)
				case (this._char == BRACKET_L):
					break readLoop;
			}
		}
		this._currentRule = new CSSRule(this._currentName, this._table);
		return this._length >= this._position;
	}
	
	private function readImports():Bool
	{
		var def:Bool;
		var buf:List<String> = new <String>[];
		var uri:String;
		var prefix:String;
		// 0 - import
		// 1 - prefix
		// 2 - uri
		var state:Int = -1;
		var i:Int;
		var word:String;
		
		this._importedDefinitions = new List<Ns>[];
		main: while (this.readChar())
		{
			if (WHITE.indexOf(this._char) > -1)
				this.readWhite();
			if (this._char !== AT && (state < 0 || state == 2))
			{
				this._position--;
				break main;
			}
			else if (this._char == AT && state == 2)
			{
				this._position++;
			}
			state++;
			state %= 3;
			switch (state)
			{
				case 0: // @import
				{
					buf.length = 0;
					for (i = 0; i < 6; i++)
					{
						if (this.readChar()) buf.push(this._char);
						else
						{
							this._position -= (i + 1);
							break main;
						}
					}
					word = buf.join("");
					if (word !== "import")
					{
						this._position -= 7;
						break main;
					}
					else continue main;
				}
				break;
				case 1: // prefix
				{
					buf.length = 0;
					if (this.readChar())
					{
						if (LETTER.indexOf(this._char) > -1)
							buf.push(this._char);
						while (this.readChar())
						{
							if (LETTER.indexOf(this._char) > -1 ||
								DIGIT.indexOf(this._char) > -1)
							{
								buf.push(this._char);
							}
							else if (WHITE.indexOf(this._char) > -1)
							{
								prefix = buf.join("");
								this._position--;
								continue main;
							}
							else
							{
								throw CSSError.InvalidImport;
								break main;
							}
						}
					}
				}
				break;
				case 2: // uri
				{
					buf.length = 0;
					i = this._importedDefinitions.length;
					if (this.readChar())
					{
						if (LETTER.indexOf(this._char) > -1)
							buf.push(this._char);
						while (this.readChar())
						{
							if (LETTER.indexOf(this._char) > -1 ||
								DIGIT.indexOf(this._char) > -1 || 
								this._char == DOT)
							{
								if (buf.length && 
									buf[buf.length - 1] == DOT && 
									this._char == DOT)
								{
									throw CSSError.InvalidImport;
									break main;
								}
								buf.push(this._char);
							}
							else if (WHITE.indexOf(this._char) > -1)
							{
								uri = buf.join("");
								this._importedDefinitions.push(
									new Namespace(prefix, uri));
								continue main;
							}
							else
							{
								throw CSSError.InvalidImport;
								break main;
							}
						}
					}
					if (i == this._importedDefinitions.length && buf.length)
					{
						uri = buf.join("");
						this._importedDefinitions.push(
							new Namespace(prefix, uri));
					}
				}
				break;
			}
		}
		return this._length >= this._position;
	}
	
	private function readDefine():Bool
	{
		var buf:List<String> = new List<String>[];
		var state:Int = -1;
		var name:String;
		var i:Int;
		var word:String;
		
		this._definitions = {};
		
		main: while (this.readChar())
		{
			if (WHITE.indexOf(this._char) > -1)
				this.readWhite();
			if (this._char !== AT && (state < 0 || state == 2))
			{
				this._position--;
				break main;
			}
			else if (this._char == AT && state == 2)
			{
				this._position++;
			}
			state++;
			state %= 3;
			switch (state)
			{
				case 0: // @define
				{
					buf.length = 0;
					for (i = 0; i < 6; i++)
					{
						if (this.readChar()) buf.push(this._char);
						else
						{
							this._position -= (i + 1);
							break main;
						}
					}
					word = buf.join("");
					if (word !== "define")
					{
						this._position -= 6;
						break main;
					}
					else continue main;
				}
				break;
				case 1: // name
				{
					buf.length = 0;
					i = this._importedDefinitions.length;
					if (this.readChar())
					{
						if (LETTER.indexOf(this._char) > -1)
							buf.push(this._char);
						while (this.readChar())
						{
							if (LETTER.indexOf(this._char) > -1 ||
								DIGIT.indexOf(this._char) > -1)
							{
								buf.push(this._char);
							}
							else if (WHITE.indexOf(this._char) > -1)
							{
								name = buf.join("");
								continue main;
							}
							else
							{
								throw CSSError.InvalidDefine;
								break main;
							}
						}
					}
					if (i == this._importedDefinitions.length && buf.length)
					{
						name = buf.join("");
					}
				}
				break;
				case 2: // value
				{
					this._position--;
					this.readValue();
					this._definitions[name] = this._currentValue;
				}
				break;
			}
		}
		return this._length >= this._position;
	}
	
	private function readValue():Bool
	{
		var isNew:Bool;
		var isByRef:Bool;
		var isDef:Bool;
		var isThis:Bool;
		var isString:Bool;
		var isNumber:Bool;
		var isInt:Bool;
		var isNegative:Bool;
		
		var state:Int = -1;
		var i:Int;
		var buf:List<String> = new List<String>[];
		var word:String;
		var prefix:String;
		var cns:Namespace;
		var scope:Object;
		var evalScope:String;
		
		main: while (this.readChar())
		{
			if (WHITE.indexOf(this._char) > -1)
				this.readWhite();
			state++;
			state %= 4;
			trace("state", state, this._char);
			switch (state)
			{
				case 0: // new
				{
					if (this._char == TILDA)
					{
						isNew = true;
					}
					else
					{
						this._position--;
					}
					//state++;
				}
				break;
				case 1: // reference / value
				{
					switch (this._char)
					{
						case AMPERSAND: // by reference
							isByRef = true;
							break;
						case CIRCUMFLEX: // by value
						default:
							if (this._char == EXCLAIM) // this
								isThis = true;
							else if (this._char == QUESTION) // defined
								isDef = true;
							else if (this._char == QUOTE) // string
							{
								isString = true;
							}
							else if (this._char == SHARP) // Int (base 16)
							{
								isNegative = false;
								isInt = true;
							}
							else if (DIGIT.indexOf(this._char) > -1) // Number
							{
								isNegative = false;
								isNumber = true;
							}
							else if (this._char == HYPHEN)
							{
								this.readChar();
								if (DIGIT.indexOf(this._char) > -1)
								{
									isNumber = true;
									this._position--;
								}
								else if (this._char == SHARP)
								{
									isInt = true;
								}
								else throw CSSError.InvalidDefine;
								isNegative = true;
							}
							else if (LETTER.indexOf(this._char) > -1)
							{
								i = 0;
								buf.length = 0;
								buf.push(this._char);
								while (this.readChar() && i < 9)
								{
									if (LETTER.indexOf(this._char) > -1)
									{
										i++;
										buf.push(this._char);
									}
									else break;
								}
								word = buf.join("");
								switch (word)
								{
									case UNDEFINED:
										this._currentValue = undefined;
										break main;
									case NULL:
										this._currentValue = null;
										break main;
									case TRUE:
										this._currentValue = true;
										break main;
									case FALSE:
										this._currentValue = false;
										break main;
									default:
									{
										this._position -= (i + 2);
									}
									break;
								}
							}
							else throw CSSError.InvalidDefine;
							isByRef = false;
					}
					//state++;
				}
				break;
				case 2: // namespace
				{
					if (isInt)
					{
						this._position--;
						this.readInt(isNegative);
						break main;
					}
					else if (isNumber)
					{
						this._position -= 2;
						this.readNumber();
						break main;
					}
					else if (isString)
					{
						this._position--;
						this.readString();
						break main;
					}
					switch (this._char)
					{
						case ASTERISK: // global
						{
							this.readChar();
							if (this._char !== PIPE)
								throw CSSError.InvalidDefine;
							else state++;
						}
						break;
						case EXCLAIM: // this
						case QUESTION: // defined
						{
							
						}
						break;
						default:
						{
							buf.length = 0;
							buf.push(this._char);
							while (this.readChar())
							{
								if (LETTER.indexOf(this._char) > -1 ||
									DIGIT.indexOf(this._char) > -1)
								{
									buf.push(this._char);
								}
								else if(this._char == PIPE)
								{
									prefix = buf.join("");
									break;
								}
							}
						}
						break;
					}
				}
				case 3: // resolve value in namespcase (prefix)
				{
					cns = null;
					for (ns in this._importedDefinitions)
					{
						trace(ns.prefix, prefix);
						if (ns.prefix == prefix)
						{
							cns = ns;
							break;
						}
					}
					if (!cns)
					{
						throw CSSError.InvalidDefine;
						break;
					}
					buf.length = 0;
					scope = cns;
					while (this.readChar())
					{
						if (LETTER.indexOf(this._char) > -1 ||
							DIGIT.indexOf(this._char) > -1)
						{
							buf.push(this._char);
						}
						else if (this._char == PAREN_L)
						{
							// TODO: Not completed - test
							evalScope = buf.join("");
							if (scope is Namespace) scope = scope::[evalScope];
							else scope = scope[evalScope];
							if (isNew)
							{
								this._currentValue = new (scope as Class)();
								break main;
							}
						}
					}
				}
			}
			
		}
		return this._length >= this._position;
	}
	*/
	/**
	 * Ported
	 */
	private function readString():Void
	{
		var escaped:Bool = false;
		var buf:StringBuf = new StringBuf();
		var i:Int = 0;
		var hex:String = "0123456789abcdef";
		var c:String;
		var cc:Int;
		
		while (this.readChar())
		{
			if (this._char == ESCAPE)
			{
				escaped = true;
				continue;
			}
			else if (escaped)
			{
				switch (this._char.toLowerCase())
				{
					case QUOTE:
					case ESCAPE:
						buf.add(this._char);
						break;
					case "n":
						buf.add("\n");
						break;
					case "r":
						buf.add("\r");
						break;
					case "t":
						buf.add("\t");
						break;
					case "x":
					{
						i = 0;
						for (ci in 0...2)
						{
							this.readChar();
							c = this._char.toLowerCase();
							if (hex.indexOf(c) < 0)
								throw CSSError.InvalidName;
							cc = c.charCodeAt(0);
							if (cc < 58) i += (cc - 47);
							else i += (cc - 96);
							i = i << 16;
						}
						buf.addChar(i);
					}
					break;
					case "u":
					{
						i = 0;
						for (ci in 0...4)
						{
							this.readChar();
							c = this._char.toLowerCase();
							if (hex.indexOf(c) < 0)
								throw CSSError.InvalidName;
							cc = c.charCodeAt(0);
							if (cc < 58) i += (cc - 47);
							else i += (cc - 96);
							i = i << 16;
						}
						buf.addChar(i);
					}
					break;
				}
				escaped = false;
			}
			else if (this._char == QUOTE)
			{
				this._currentValue = buf.toString();
				break;
			}
			else buf.add(this._char);
		}
	}
	
	/**
	 * Ported
	 */
	private function readNumber():Void
	{
		var buf:StringBuf = new StringBuf();
		var hasDot:Bool = false;
		var hasMinus:Bool = false;
		var started:Bool = false;
		
		while (this.readChar())
		{
			if (DIGIT.indexOf(this._char) > -1)
			{
				buf.add(this._char);
				started = true;
			}
			else if (this._char == DOT && !hasDot)
			{
				hasDot = true;
				started = true;
				buf.add(this._char);
			}
			else if (this._char == HYPHEN && !hasMinus && !started)
			{
				hasMinus = true;
				started = true;
				buf.add(this._char);
			}
			else
			{
				this._currentValue = Std.parseFloat(buf.toString());
				this._position--;
				break;
			}
		}
	}
	
	/**
	 * Ported
	 */
	private function readInt(negaitve:Bool = false):Void
	{
		var hasMinus:Bool = false;
		var hex:String = "ABCDEFabcdef";
		var n:Int = 0;
		var c:String;
		var cc:Int;
		
		while (this.readChar())
		{
			if (DIGIT.indexOf(this._char) > -1 || hex.indexOf(this._char) > -1)
			{
				c = this._char.toLowerCase();
				cc = c.charCodeAt(0);
				if (cc < 58) n += (cc - 47);
				else n += (cc - 96);
				n = n << 16;
			}
			else
			{
				this._currentValue = n;
				if (negaitve) this._currentValue *= -1;
				this._position--;
				break;
			}
		}
	}
	/*
	private function readName():Bool
	{
		var i:Int;
		var buf:StringBuf;
		
		if (!this.readChar()) return false;
		if (LETTER.indexOf(this._char) < 0 && 
			this._char !== ASTERISK && 
			this._char !== DOT && 
			this._char !== SHARP)
		{
			throw CSSError.InvalidName;
		}
		if (this._char !== ASTERISK || 
			this._char !== DOT || 
			this._char !== SHARP)
		{
			this._currentName = ASTERISK;
			return this._length >= this._position;
		}
		buf = new StringBuf();
		buf.add(this._char);
		readLoop: while (this.readChar())
		{
			if (LETTER.indexOf(this._char) > -1 || 
				DIGIT.indexOf(this._char) > -1)
			{
				buf[i] = this._char;
				i++;
				continue;
			}
			switch (this._char)
			{
				case SPACE:
					this.readWhite();
					break;
				case DOT:
					this.readStyle();
					break;
				case COMMA:
					break readLoop;
				case COLON:
				case SQARE_L:
					this.readProperty();
					break;
				case SHARP:
					this.readId();
					break;
				case GT:
				case TILDA:
				case PLUS:
					
					break readLoop;
				default: throw CSSError.InvalidName;
			}
		}
		return this._length >= this._position;
	}
	
	private function readKeyword():Bool
	{
		var buf:StringBuf = new StringBuf();
		var word:String = "";
		
		while (this.readChar())
		{
			if (LETTER.indexOf(this._char) < 0)
			{
				word = buf.toString();
				switch (word)
				{
					case KEWORD_DEFINE:
					case KEWORD_ELIF:
					case KEWORD_ELSE:
					case KEWORD_END:
					case KEWORD_IF:
					case KEWORD_IMPORT:
					case KEWORD_RESOURCE:
						this._currentKeyword = word;
					default:
						throw CSSError.InvalidKeyword;
				}
				break;
			}
			else buf.add(this._char);
		}
		return this._length >= this._position;
	}
	
	private function readWhite():Bool
	{
		while (this.readChar())
		{
			if (WHITE.indexOf(this._char) < 0)
			{
				this._position--;
				break;
			}
		}
		return this._length >= this._position;
	}
	
	private function readProperty():Bool
	{
		var i:Int = 0;
		var buf:StringBuf;
		
		if (!this.readChar()) return false;
		if (LETTER.indexOf(this._char) < 0)
		{
			throw CSSError.InvalidName;
		}
		buf = new StringBuf();
		buf.add(this._char);
		while (this.readChar())
		{
			if (LETTER.indexOf(this._char) > -1 || 
				DIGIT.indexOf(this._char) > -1)
			{
				buf.addSub(this._char, i, 1);
				i++;
				continue;
			}
			else if (WHITE.indexOf(this._char) > -1)
			{
				this.readWhite();
			}
			else if (this._char == SQARE_R) break;
			else throw CSSError.InvalidName;
		}
		return this._length >= this._position;
	}
	
	private function readStyle():Bool
	{
		var i:Int = 0;
		var buf:StringBuf;
		
		if (!this.readChar()) return false;
		if (LETTER.indexOf(this._char) < 0)
		{
			throw CSSError.InvalidName;
		}
		buf = new StringBuf();
		buf.add(this._char);
		while (this.readChar())
		{
			if (LETTER.indexOf(this._char) > -1 || 
				DIGIT.indexOf(this._char) > -1)
			{
				buf.addSub(this._char, i, 1);
				i++;
				continue;
			}
			else if (WHITE.indexOf(this._char) > -1) break;
			else throw CSSError.InvalidName;
		}
		return this._length >= this._position;
	}
	
	private function readId():Bool
	{
		var i:Int = 0;
		var buf:StringBuf;
		
		buf = new StringBuf();
		while (this.readChar())
		{
			if (DIGIT.indexOf(this._char) > -1)
			{
				buf.addSub(this._char, i, 1);
				i++;
				continue;
			}
			else if (WHITE.indexOf(this._char) > -1) break;
			else throw CSSError.InvalidName;
		}
		return this._length >= this._position;
	}
	*/
}