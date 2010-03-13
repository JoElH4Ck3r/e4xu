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
	private var _definitions:Object;
	private var _global:CSSGlobal;
	private var _importedDefinitions:List<Namespace>;
	private var _length:Int;
	private var _position:Int;
	private var _source:String;
	private var _table:CSSTable;
	
	private var _currentDefinition:Object;
	private var _currentId:uInt;
	private var _currentKeyword:String;
	private var _currentName:String;
	private var _currentOperator:String;
	private var _currentProperty:String;
	private var _currentRule:CSSRule;
	private var _currentStyle:String;
	private var _currentValue:*;
	
	public function CSSReader(?source:String) 
	{
		if (source != null) this.read(source);
	}
	
	public function read(source:String):Void
	{
		this._source = source;
		this._position = 0;
		this._length = this._source.length;
		this._global = new CSSGlobal();
		this._table = new CSSTable(this._global);
		// TEST
		this.readWhite();
		this.readImports();
		this.readDefine();
		trace(this._importedDefinitions.join("\r"));
		this._definitions
		for (var i:String in this._definitions)
			trace("key : " + i + ", value : " + this._definitions[i]);
		trace(this._position, this._length);
	}
	
	public function table():CSSTable { return this._table; }
	
	private function readChar():Bool
	{
		var irc:uInt;
		var inc:uInt;
		
		this._char = this._source.charAt(this._position);
		if (this._char === SLASH)
		{
			if (this._source.charAt(this._position + 1) === SLASH)
			{
				irc = this._source.indexOf("\r", this._position + 1);
				inc = this._source.indexOf("\n", this._position + 1);
				this._position = Math.min(irc, inc) + 1;
				this._char = this._source.charAt(this._position);
			}
		}
		this._position++;
		return this._length >= this._position;
	}
	
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
		
		this._importedDefinitions = new <Namespace>[];
		main: while (this.readChar())
		{
			if (WHITE.indexOf(this._char) > -1)
				this.readWhite();
			if (this._char !== AT && (state < 0 || state === 2))
			{
				this._position--;
				break main;
			}
			else if (this._char === AT && state === 2)
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
								throw CSSError.INVALID_IMPORT;
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
									buf[buf.length - 1] === DOT && 
									this._char === DOT)
								{
									throw CSSError.INVALID_IMPORT;
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
								throw CSSError.INVALID_IMPORT;
								break main;
							}
						}
					}
					if (i === this._importedDefinitions.length && buf.length)
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
			else if (this._char === AT && state === 2)
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
								throw CSSError.INVALID_DEFINE;
								break main;
							}
						}
					}
					if (i === this._importedDefinitions.length && buf.length)
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
	
	private function readDefinition():Bool
	{
		
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
							if (this._char === EXCLAIM) // this
								isThis = true;
							else if (this._char === QUESTION) // defined
								isDef = true;
							else if (this._char === QUOTE) // string
							{
								isString = true;
							}
							else if (this._char === SHARP) // Int (base 16)
							{
								isNegative = false;
								isInt = true;
							}
							else if (DIGIT.indexOf(this._char) > -1) // Number
							{
								isNegative = false;
								isNumber = true;
							}
							else if (this._char === HYPHEN)
							{
								this.readChar();
								if (DIGIT.indexOf(this._char) > -1)
								{
									isNumber = true;
									this._position--;
								}
								else if (this._char === SHARP)
								{
									isInt = true;
								}
								else throw CSSError.INVALID_DEFINE;
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
							else throw CSSError.INVALID_DEFINE;
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
								throw CSSError.INVALID_DEFINE;
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
								else if(this._char === PIPE)
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
					for each (var ns:Namespace in this._importedDefinitions)
					{
						trace(ns.prefix, prefix);
						if (ns.prefix === prefix)
						{
							cns = ns;
							break;
						}
					}
					if (!cns)
					{
						throw CSSError.INVALID_DEFINE;
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
						else if (this._char === PAREN_L)
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
	
	private function readString():Void
	{
		var escaped:Bool;
		var buf:List<String> = new <String>[];
		var subBuf:List<String> = new <String>[];
		var i:Int;
		
		while (this.readChar())
		{
			if (this._char === ESCAPE)
			{
				escaped = true;
				continue;
			}
			else if (escaped)
			{
				switch (this._char.toLocaleLowerCase())
				{
					case QUOTE:
					case ESCAPE:
						buf.push(this._char);
						break;
					case "n":
						buf.push("\n");
						break;
					case "r":
						buf.push("\r");
						break;
					case "t":
						buf.push("\t");
						break;
					case "x":
					{
						subBuf.length = 0;
						i = 2;
						while (i--)
						{
							this.readChar();
							subBuf.push(this._char);
						}
						buf.push(String.fromCharCode(
							parseInt(subBuf.join(""), 16)));
					}
					break;
					case "u":
					{
						subBuf.length = 0;
						i = 4;
						while (i--)
						{
							this.readChar();
							subBuf.push(this._char);
						}
						buf.push(String.fromCharCode(
							parseInt(subBuf.join(""), 16)));
					}
					break;
				}
				escaped = false;
			}
			else if (this._char === QUOTE)
			{
				this._currentValue = buf.join("");
				break;
			}
			else buf.push(this._char);
		}
	}
	
	private function readNumber():Void
	{
		var buf:List<String> = new <String>[];
		var hasDot:Bool;
		var hasMinus:Bool;
		
		while (this.readChar())
		{
			if (DIGIT.indexOf(this._char) > -1)
			{
				buf.push(this._char);
			}
			else if (this._char === DOT && !hasDot)
			{
				hasDot = true;
				buf.push(this._char);
			}
			else if (this._char === HYPHEN && !hasMinus && !buf.length)
			{
				hasMinus = true;
				buf.push(this._char);
			}
			else 
			{
				this._currentValue = parseFloat(buf.join(""));
				this._position--;
				break;
			}
		}
	}
	
	private function readInt(negaitve:Bool = false):Void
	{
		var buf:StringBuf = new StringBuf();
		var hasMinus:Bool;
		const hex:String = "ABCDEFabcdef";
		
		while (this.readChar())
		{
			if (DIGIT.indexOf(this._char) > -1 || hex.indexOf(this._char) > -1)
			{
				buf.push(this._char);
			}
			else 
			{
				this._currentValue = parseInt(buf.join(""), 16);
				if (negaitve) this._currentValue *= -1;
				this._position--;
				break;
			}
		}
	}
	
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
			throw CSSError.INVALID_NAME;
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
				default: throw CSSError.INVALID_NAME;
			}
		}
		return this._length >= this._position;
	}
	
	private function readKeyword():Bool
	{
		var buf:List<String> = new <String>[];
		var word:String;
		
		while (this.readChar())
		{
			if (LETTER.indexOf(this._char) < 0)
			{
				word = buf.join("");
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
						throw CSSError.INVALID_KEYWORD;
				}
				break;
			}
			else buf.push(this._char);
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
		var i:Int;
		var buf:List<String>;
		
		if (!this.readChar()) return false;
		if (LETTER.indexOf(this._char) < 0)
		{
			throw CSSError.INVALID_NAME;
		}
		buf = new <String>[this._char];
		while (this.readChar())
		{
			if (LETTER.indexOf(this._char) > -1 || 
				DIGIT.indexOf(this._char) > -1)
			{
				buf[i] = this._char;
				i++;
				continue;
			}
			else if (WHITE.indexOf(this._char) > -1)
			{
				this.readWhite();
			}
			else if (this._char == SQARE_R) break;
			else throw CSSError.INVALID_NAME;
		}
		return this._length >= this._position;
	}
	
	private function readStyle():Bool
	{
		var i:Int;
		var buf:List<String>;
		
		if (!this.readChar()) return false;
		if (LETTER.indexOf(this._char) < 0)
		{
			throw CSSError.INVALID_NAME;
		}
		buf = new <String>[this._char];
		while (this.readChar())
		{
			if (LETTER.indexOf(this._char) > -1 || 
				DIGIT.indexOf(this._char) > -1)
			{
				buf[i] = this._char;
				i++;
				continue;
			}
			else if (WHITE.indexOf(this._char) > -1) break;
			else throw CSSError.INVALID_NAME;
		}
		return this._length >= this._position;
	}
	
	private function readId():Bool
	{
		var i:Int;
		var buf:List<String>;
		
		buf = new <String>[];
		while (this.readChar())
		{
			if (DIGIT.indexOf(this._char) > -1)
			{
				buf[i] = this._char;
				i++;
				continue;
			}
			else if (WHITE.indexOf(this._char) > -1) break;
			else throw CSSError.INVALID_NAME;
		}
		return this._length >= this._position;
	}
	
}