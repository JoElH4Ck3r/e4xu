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
		
		private var _whiteSpaceRegExp:RegExp;
		private var _alphaNumRegExp:RegExp;
		private var _lineEndRegExp:RegExp;
		private var _regexEndRegExp:RegExp;
		private var _regexStartRegExp:RegExp;
		private var _quoteRegExp:RegExp;
		private var _errors:XMLList;
		
		private var _xml:XML;
		
		public function AS3ParserSettings()
		{
			super();
			this._xml = XML(super.toString());
			this._errors = this._xml.errors;
		}
		
		private function regexFromXML(node:XML):RegExp
		{
			return new RegExp(node.text(), node.@options);
		}
	}

}