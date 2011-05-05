package org.wvxvws.automation.nodes
{
	public class Lexer
	{
		public var closeHandler:Function;
		public var delimiterHandler:Function;
		public var openHandler:Function;
		public var defaultHandler:Function;
		
		public var nextIsQuote:Boolean;
		
		private var _wasLastWhite:Boolean;
		private var _wasComment:Boolean;

		private var _stingStart:Boolean;
		
		public function Lexer() { super(); }
		
		/**
		 * These are the variables that may affect the reader:
		 * 
		 * *package*
		 * *read-default-float-format*
		 * *readtable*
		 * *read-base*
		 * *read-suppress*   
		 * 
		 * @param character
		 * 
		 */
		public function process(character:String):void
		{
			var hasQuote:Boolean;
//			In Common Lisp symbols with a leading colon in their printed representations are keyword symbols. These are interned in the keyword package.
//			:keyword-symbol
//			A printed representation of a symbol may include a package name. Two colons are written between the name of the package and the name of the symbol.
//			package-name::symbol-name
//			Packages can export symbols. Then only one colon is written between the name of the package and the name of the symbol.
//			package:exported-symbol
							
			// TODO: symbols may have whitespace, but must be delimited by pipes:
			// |This is a symbol with whitespace|
			// TODO: need to be able to escape quotes
			if ((character == "\r" || character == "\n") && this._wasComment)
			{
				this._wasComment = false;
			}
			else if (!this._wasComment)
			{
				switch (character)
				{
					case ")":
						if (!this._stingStart) this.closeHandler();
						else this.defaultHandler();
						this._wasLastWhite = false;
						break;
					case " ":
					case "\t":
					case "\r":
					case "\n":
					case "\v":
						if (this._stingStart) this.defaultHandler();
						else if (!this._wasLastWhite) this.delimiterHandler();
						this._wasLastWhite = true;
						break;
					case "(":
						if (!this._stingStart) this.openHandler();
						else this.defaultHandler();
						this._wasLastWhite = false;
						break;
					case ";":
						if (!this._wasComment && this._stingStart) this.defaultHandler();
						this._wasComment = !this._stingStart;
						this._wasLastWhite = false;
						break;
					case "\"":
						if (!this._wasComment) this._stingStart = !this._stingStart;
						this.defaultHandler();
						this._wasLastWhite = false;
						break;
					case "'":
						if (!this._stingStart && !this._wasComment)
						{
							this.nextIsQuote = true;
							hasQuote = true;
						}
						else this.defaultHandler();
						this._wasLastWhite = false;
						break;
					default:
						this.defaultHandler();
						this._wasLastWhite = false;
				}
				if (!hasQuote) this.nextIsQuote = false;
			}
		}
	}
}