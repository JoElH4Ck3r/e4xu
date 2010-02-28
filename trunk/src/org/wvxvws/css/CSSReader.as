package org.wvxvws.css
{
	/**
	 * ...
	 * @author wvxvw
	 */
	public class CSSReader
	{
		protected static const WHITE:String = " \r\n\t";
		protected static const DIGIT:String = "0123456789";
		protected static const LETTER:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$";
		protected static const DOT:String = ".";
		protected static const COMMA:String = ",";
		protected static const COLON:String = ":";
		protected static const SEMICOLON:String = ";";
		protected static const BRACKET_L:String = "{";
		protected static const BRACKET_R:String = "}";
		protected static const PAREN_L:String = "(";
		protected static const PAREN_R:String = ")";
		protected static const SQARE_L:String = "[";
		protected static const SQARE_R:String = "]";
		protected static const ASTERISK:String = "*";
		protected static const SHARP:String = "#";
		protected static const TILDA:String = "~";
		protected static const DOLLAR:String = "$";
		protected static const EQUALS:String = "=";
		protected static const CIRCUMFLEX:String = "^";
		protected static const PIPE:String = "|";
		protected static const PLUS:String = "+";
		protected static const GT:String = ">";
		protected static const SPACE:String = " ";
		protected static const HYPHEN:String = "-";
		protected static const AT:String = "@";
		protected static const AMPERSAND:String = "&";
		protected static const EXCLAIM:String = "!";
		protected static const QUESTION:String = "?";
		protected static const QUOTE:String = "\"";
		protected static const ESCAPE:String = "\\";
		
		protected static const UNDEFINED:String = "undefined";
		protected static const NULL:String = "null";
		protected static const TRUE:String = "true";
		protected static const FALSE:String = "false";
		
		protected var _source:String;
		protected var _position:int;
		protected var _length:int;
		protected var _char:String;
		protected var _table:CSSTable;
		protected var _global:CSSGlobal;
		protected var _importedDefinitions:Vector.<Namespace>;
		protected var _definitions:Object;
		
		protected var _currentRule:CSSRule;
		protected var _currentName:String;
		protected var _currentOperator:String;
		protected var _currentProperty:String;
		protected var _currentId:uint;
		protected var _currentStyle:String;
		protected var _currentDefinition:Object;
		protected var _currentValue:*;
		
		public function CSSReader(source:String = null) 
		{
			super();
			if (source) this.read(source);
		}
		
		public function read(source:String):void
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
		
		protected function readChar():Boolean
		{
			this._char = this._source.charAt(this._position);
			this._position++;
			return this._length >= this._position;
		}
		
		protected function readSelector():Boolean
		{
			var name:Boolean;
			var buff:Vector.<String> = new <String>[];
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
		
		protected function readImports():Boolean
		{
			var def:Boolean;
			var buf:Vector.<String> = new <String>[];
			var uri:String;
			var prefix:String;
			// 0 - import
			// 1 - prefix
			// 2 - uri
			var state:int = -1;
			var i:int;
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
		
		protected function readDefine():Boolean
		{
			var buf:Vector.<String> = new <String>[];
			var state:int = -1;
			var name:String;
			var i:int;
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
		
		protected function readDefinition():Boolean
		{
			
			return this._length >= this._position;
		}
		
		protected function readValue():Boolean
		{
			var isNew:Boolean;
			var isByRef:Boolean;
			var isDef:Boolean;
			var isThis:Boolean;
			var isString:Boolean;
			var isNumber:Boolean;
			var isInt:Boolean;
			var isNegative:Boolean;
			
			var state:int = -1;
			var i:int;
			var buf:Vector.<String> = new <String>[];
			var word:String;
			
			main: while (this.readChar())
			{
				if (WHITE.indexOf(this._char) > -1)
					this.readWhite();
				state++;
				state %= 3;
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
								else if (this._char === SHARP) // int (base 16)
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
											this._position -= i;
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
						}
					}
				}
				
			}
			return this._length >= this._position;
		}
		
		protected function readString():void
		{
			var escaped:Boolean;
			var buf:Vector.<String> = new <String>[];
			var subBuf:Vector.<String> = new <String>[];
			var i:int;
			
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
		
		protected function readNumber():void
		{
			var buf:Vector.<String> = new <String>[];
			var hasDot:Boolean;
			var hasMinus:Boolean;
			
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
		
		protected function readInt(negaitve:Boolean = false):void
		{
			var buf:Vector.<String> = new <String>[];
			var hasMinus:Boolean;
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
		
		protected function readName():Boolean
		{
			var i:int;
			var buf:Vector.<String>;
			
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
			buf = new <String>[this._char];
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
		
		protected function readWhite():Boolean
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
		
		protected function readProperty():Boolean
		{
			var i:int;
			var buf:Vector.<String>;
			
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
		
		protected function readStyle():Boolean
		{
			var i:int;
			var buf:Vector.<String>;
			
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
		
		protected function readId():Boolean
		{
			var i:int;
			var buf:Vector.<String>;
			
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
}