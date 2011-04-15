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
		
		public function process(character:String):void
		{
			var hasQuote:Boolean;
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