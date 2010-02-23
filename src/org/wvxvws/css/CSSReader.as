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
		protected static const LETTER:String = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ";
		protected static const ALLOWED:String = "-_";
		protected static const DOT:String = ".";
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
			while (this.readChar())
			{
				if (this._char == BRACKET_L)
				{
					
					break;
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
			
			return this._position < this._length;
		}
		
		protected function readValue():Boolean
		{
			
			return this._position < this._length;
		}
	}
}