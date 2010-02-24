package  
{
	/**
	 * ...
	 * @author wvxvw
	 */
	public class CSSReader
	{
		protected static const WHITE:String = " \r\n\t";
		protected static const DIGIT:String = "0123456789";
		protected static const LETTER:String = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ_";
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
		
		public function CSSReader(source:String) 
		{
			super();
			this._source = source;
			this._position = 0;
			this._length = this._source.length;
		}
		
		protected function readChar():Boolean
		{
			this._char = this._source.charAt(this._position);
			this._position++;
			return this._position < this._length;
		}
		
		protected function readSelector():Boolean
		{
			var name:Boolean;
			var buff:Vector.<String> = new <String>[];
			readLoop: while (this.readChar())
			{
				switch (true)
				{
					case (WHITE.indexOf(this._char) > -1):
						
					case (LETTER.indexOf(this._char) > -1):
						if (name)
					case (this._char == BRACKET_L):
						break readLoop;
				}
			}
			return this._position < this._length;
		}
		
		protected function readDefinition():Boolean
		{
			
			return this._position < this._length;
		}
		
		protected function readNameValue():Boolean
		{
			
			return this._position < this._length;
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
			return this._position < this._length;
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
			return this._position < this._length;
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
				else if (this._char = SQARE_R) break;
				else throw CSSError.INVALID_NAME;
			}
			return this._position < this._length;
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
			return this._position < this._length;
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
			return this._position < this._length;
		}
		
		protected function readValue():Boolean
		{
			
			return this._position < this._length;
		}
	}
}