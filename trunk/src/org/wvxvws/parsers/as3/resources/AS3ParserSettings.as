package org.wvxvws.parsers.as3.resources
{
	import flash.utils.ByteArray;
	
	[Embed(source='as3-syntax.xml', mimeType='application/octet-stream')]
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class AS3ParserSettings extends ByteArray
	{
		public function get operatorRegExp():RegExp
		{
			if (!this._operatorRegExp)
			{
				this._operatorRegExp = 
					this.regexFromXML(this._xml.operatorRegExp[0]);
			}
			this._operatorRegExp.lastIndex = 0;
			return this._operatorRegExp;
		}
		
		public function get numberRegExp():RegExp
		{
			if (!this._numberRegExp)
			{
				this._numberRegExp = 
					this.regexFromXML(this._xml.numberRegExp[0]);
			}
			this._numberRegExp.lastIndex = 0;
			return this._numberRegExp;
		}
		
		public function get numberStartRegExp():RegExp
		{
			if (!this._numberStartRegExp)
			{
				this._numberStartRegExp = 
					this.regexFromXML(this._xml.numberStartRegExp[0]);
			}
			this._numberStartRegExp.lastIndex = 0;
			return this._numberStartRegExp;
		}
		
		public function get quoteRegExp():RegExp
		{
			if (!this._quoteRegExp)
			{
				this._quoteRegExp = 
					this.regexFromXML(this._xml.quoteRegExp[0]);
			}
			this._quoteRegExp.lastIndex = 0;
			return this._quoteRegExp;
		}
		
		public function get wordRegExp():RegExp
		{
			if (!this._wordRegExp)
			{
				this._wordRegExp = 
					this.regexFromXML(this._xml.wordRegExp[0]);
			}
			this._wordRegExp.lastIndex = 0;
			return this._wordRegExp;
		}
		
		public function get escapeChar():String
		{
			return this._xml.escapeChar[0];
		}
		
		public function get whiteSpaceRegExp():RegExp
		{
			if (!this._whiteSpaceRegExp)
			{
				this._whiteSpaceRegExp = 
					this.regexFromXML(this._xml.whiteSpaceRegExp[0]);
			}
			this._whiteSpaceRegExp.lastIndex = 0;
			return this._whiteSpaceRegExp;
		}
		
		public function get alphaNumRegExp():RegExp
		{
			if (!this._alphaNumRegExp)
			{
				this._alphaNumRegExp = 
					this.regexFromXML(this._xml.alphaNumRegExp[0]);
			}
			this._alphaNumRegExp.lastIndex = 0;
			return this._alphaNumRegExp;
		}
		
		public function get lineEndRegExp():RegExp
		{
			if (!this._lineEndRegExp)
			{
				this._lineEndRegExp = 
					this.regexFromXML(this._xml.lineEndRegExp[0]);
			}
			this._lineEndRegExp.lastIndex = 0;
			return this._lineEndRegExp;
		}
		
		public function get regexEndRegExp():RegExp
		{
			if (!this._regexEndRegExp)
			{
				this._regexEndRegExp = 
					this.regexFromXML(this._xml.regexEndRegExp[0]);
			}
			this._regexEndRegExp.lastIndex = 0;
			return this._regexEndRegExp;
		}
		
		public function get regexStartRegExp():RegExp
		{
			if (!this._regexStartRegExp)
			{
				this._regexStartRegExp = 
					this.regexFromXML(this._xml.regexStartRegExp[0]);
			}
			this._regexStartRegExp.lastIndex = 0;
			return this._regexStartRegExp;
		}
		
		public function get errors():XMLList { return this._errors.copy(); }
		
		public function get lineCommentStartRegExp():RegExp
		{
			if (!this._lineCommentStartRegExp)
			{
				this._lineCommentStartRegExp = 
					this.regexFromXML(this._xml.lineCommentStartRegExp[0]);
			}
			this._lineCommentStartRegExp.lastIndex = 0;
			return this._lineCommentStartRegExp;
		}
		
		public function get blockCommentStartRegExp():RegExp
		{
			if (!this._blockCommentStartRegExp)
			{
				this._blockCommentStartRegExp = 
					this.regexFromXML(this._xml.blockCommentStartRegExp[0]);
			}
			this._blockCommentStartRegExp.lastIndex = 0;
			return this._blockCommentStartRegExp;
		}
		
		public function get blockCommentEndRegExp():RegExp
		{
			if (!this._blockCommentEndRegExp)
			{
				this._blockCommentEndRegExp = 
					this.regexFromXML(this._xml.blockCommentEndRegExp[0]);
			}
			this._blockCommentEndRegExp.lastIndex = 0;
			return this._blockCommentEndRegExp;
		}
		
		public function get asdocCommentStartRegExp():RegExp
		{
			if (!this._asdocCommentStartRegExp)
			{
				this._asdocCommentStartRegExp = 
					this.regexFromXML(this._xml.asdocCommentStartRegExp[0]);
			}
			this._asdocCommentStartRegExp.lastIndex = 0;
			return this._asdocCommentStartRegExp;
		}
		
		public function get asdocKeywordRegExp():RegExp
		{
			if (!this._asdocKeywordRegExp)
			{
				this._asdocKeywordRegExp = 
					this.regexFromXML(this._xml.asdocKeywordRegExp[0]);
			}
			this._asdocKeywordRegExp.lastIndex = 0;
			return this._asdocKeywordRegExp;
		}
		
		private var _whiteSpaceRegExp:RegExp;
		private var _alphaNumRegExp:RegExp;
		private var _lineEndRegExp:RegExp;
		private var _regexEndRegExp:RegExp;
		private var _regexStartRegExp:RegExp;
		private var _quoteRegExp:RegExp;
		private var _errors:XMLList;
		private var _lineCommentStartRegExp:RegExp;
		private var _blockCommentStartRegExp:RegExp;
		private var _blockCommentEndRegExp:RegExp;
		private var _asdocCommentStartRegExp:RegExp;
		private var _asdocKeywordRegExp:RegExp;
		private var _wordRegExp:RegExp;
		private var _numberStartRegExp:RegExp;
		private var _numberRegExp:RegExp;
		private var _operatorRegExp:RegExp;
		
		private var _xml:XML;
		
		public function AS3ParserSettings()
		{
			super();
			this._xml = XML(super.toString());
			this._errors = this._xml.errors;
		}
		
		public function isKeyword(word:String):Boolean
		{
			return Boolean(this._xml.keyword.*[word].length());
		}
		
		public function isClassName(word:String):Boolean
		{
			return Boolean(this._xml.classname.*[word].length());
		}
		
		public function isReserved(word:String):Boolean
		{
			return Boolean(this._xml.reserved.*[word].length());
		}
		
		private function regexFromXML(node:XML):RegExp
		{
			return new RegExp(node.text(), node.@options);
		}
	}

}