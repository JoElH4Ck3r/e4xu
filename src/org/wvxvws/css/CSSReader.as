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
		protected static const ASTERIX:String = "*";
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
		
		protected var _source:String;
		protected var _position:int;
		protected var _length:int;
		protected var _char:String;
		protected var _table:CSSTable;
		protected var _global:CSSGlobal;
		protected var _importedDefinitions:Vector.<Namespace>;
		
		protected var _currentRule:CSSRule;
		protected var _currentName:String;
		protected var _currentOperator:String;
		protected var _currentProperty:String;
		protected var _currentId:uint;
		protected var _currentStyle:String;
		
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
			this.readImports();
			trace(this._importedDefinitions.join("\r"));
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
				if (this._char !== AT && state < 0) break main;
				state++;
				state %= 3;
				switch (state)
				{
					case 0: // import
					{
						buf.length = 0;
						for (i = 0; i < 6; i++)
						{
							if (this.readChar()) buf.push(this._char);
						}
						word = buf.join("");
						if (word !== "import")
						{
							this._position -= 6;
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
		
		protected function readDefinition():Boolean
		{
			
			return this._length >= this._position;
		}
		
		protected function readNameValue():Boolean
		{
			
			return this._length >= this._position;
		}
		
		protected function readName():Boolean
		{
			var i:int;
			var buf:Vector.<String>;
			
			if (!this.readChar()) return false;
			if (LETTER.indexOf(this._char) < 0)
			{
				throw CSSError.INVALID_NAME;
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
		
		protected function readValue():Boolean
		{
			
			return this._length >= this._position;
		}
	}
}