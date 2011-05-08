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
			this._operatorRegExp.lastIndex = 0;
			return this._operatorRegExp;
		}
		
		public function get numberRegExp():RegExp
		{
			this._numberRegExp.lastIndex = 0;
			return this._numberRegExp;
		}
		
		public function get numberStartRegExp():RegExp
		{
			this._numberStartRegExp.lastIndex = 0;
			return this._numberStartRegExp;
		}
		
		public function get quoteRegExp():RegExp
		{
			this._quoteRegExp.lastIndex = 0;
			return this._quoteRegExp;
		}
		
		public function get wordRegExp():RegExp
		{
			this._wordRegExp.lastIndex = 0;
			return this._wordRegExp;
		}
		
		public function get escapeChar():String
		{
			return this._xml.escapeChar[0];
		}
		
		public function get whiteSpaceRegExp():RegExp
		{
			this._whiteSpaceRegExp.lastIndex = 0;
			return this._whiteSpaceRegExp;
		}
		
		public function get alphaNumRegExp():RegExp
		{
			this._alphaNumRegExp.lastIndex = 0;
			return this._alphaNumRegExp;
		}
		
		public function get lineEndRegExp():RegExp
		{
			this._lineEndRegExp.lastIndex = 0;
			return this._lineEndRegExp;
		}
		
		public function get regexEndRegExp():RegExp
		{
			this._regexEndRegExp.lastIndex = 0;
			return this._regexEndRegExp;
		}
		
		public function get regexStartRegExp():RegExp
		{
			this._regexStartRegExp.lastIndex = 0;
			return this._regexStartRegExp;
		}
		
		public function get errors():XMLList { return this._errors.copy(); }
		
		public function get lineCommentStartRegExp():RegExp
		{
			this._lineCommentStartRegExp.lastIndex = 0;
			return this._lineCommentStartRegExp;
		}
		
		public function get blockCommentStartRegExp():RegExp
		{
			this._blockCommentStartRegExp.lastIndex = 0;
			return this._blockCommentStartRegExp;
		}
		
		public function get blockCommentEndRegExp():RegExp
		{
			this._blockCommentEndRegExp.lastIndex = 0;
			return this._blockCommentEndRegExp;
		}
		
		public function get asdocCommentStartRegExp():RegExp
		{
			this._asdocCommentStartRegExp.lastIndex = 0;
			return this._asdocCommentStartRegExp;
		}
		
		public function get asdocKeywordRegExp():RegExp
		{
			this._asdocKeywordRegExp.lastIndex = 0;
			return this._asdocKeywordRegExp;
		}
		
		public function get xmlStartRegExp():RegExp
		{
			this._xmlStartRegExp.lastIndex = 0;
			return this._xmlStartRegExp;
		}
		
		public function get xmlAttributeStartRegExp():RegExp
		{
			this._xmlAttributeStartRegExp.lastIndex = 0;
			return this._xmlAttributeStartRegExp;
		}
		
		public function get bracketRegExp():RegExp
		{
			this._bracketRegExp.lastIndex = 0;
			return this._bracketRegExp;
		}
		
		public function get xmlEndRegExp():RegExp
		{
			this._xmlEndRegExp.lastIndex = 0;
			return this._xmlEndRegExp;
		}
		
		public function get xmlListStartRegExp():RegExp
		{
			this._xmlListStartRegExp.lastIndex = 0;
			return this._xmlListStartRegExp;
		}
		
		public function get xmlListEndRegExp():RegExp
		{
			this._xmlListEndRegExp.lastIndex = 0;
			return this._xmlListEndRegExp;
		}
		
		public function get xmlRegExp():XMLRegExp
		{
			return this._xmlRegExp;
		}
		
		public function get vectorDelimiter():String { return this._xml.vectorDelimiter[0]; }
		
		public function get bracketInfo():BracketsInfo { return this._brakcetsInfo; }
		
		public function get styles():StyleNames { return this._styles; }
		
		private var _xmlAttributeStartRegExp:RegExp;
		private var _whiteSpaceRegExp:RegExp;
		private var _alphaNumRegExp:RegExp;
		private var _lineEndRegExp:RegExp;
		private var _regexEndRegExp:RegExp;
		private var _regexStartRegExp:RegExp;
		private var _quoteRegExp:RegExp;
		private var _lineCommentStartRegExp:RegExp;
		private var _blockCommentStartRegExp:RegExp;
		private var _blockCommentEndRegExp:RegExp;
		private var _asdocCommentStartRegExp:RegExp;
		private var _asdocKeywordRegExp:RegExp;
		private var _wordRegExp:RegExp;
		private var _numberStartRegExp:RegExp;
		private var _numberRegExp:RegExp;
		private var _operatorRegExp:RegExp;
		private var _xmlStartRegExp:RegExp;
		private var _bracketRegExp:RegExp;
		private var _xmlEndRegExp:RegExp;
		private var _xmlListStartRegExp:RegExp;
		private var _xmlListEndRegExp:RegExp;
		
		private var _xmlRegExp:XMLRegExp;
		private var _brakcetsInfo:BracketsInfo;
		private var _styles:StyleNames;
		private var _errors:XMLList;
		
		private var _xml:XML;
		
		public function AS3ParserSettings()
		{
			super();
			this._xml = XML(super.toString());
			this._errors = this._xml.errors;
			this._xmlRegExp = 
				new XMLRegExp(this._xml.xml[0], this.regexFromXML);
			this._brakcetsInfo = new BracketsInfo(this._xml.brackets[0]);
			this._styles = new StyleNames(this._xml.styles[0]);
			
			this._xmlAttributeStartRegExp = this.regexFromXML(this._xml.xmlAttributeStartRegExp[0]);
			this._whiteSpaceRegExp = this.regexFromXML(this._xml.whiteSpaceRegExp[0]);
			this._alphaNumRegExp = this.regexFromXML(this._xml.alphaNumRegExp[0]);
			this._lineEndRegExp = this.regexFromXML(this._xml.lineEndRegExp[0]);
			this._regexEndRegExp = this.regexFromXML(this._xml.regexEndRegExp[0]);
			this._regexStartRegExp = this.regexFromXML(this._xml.regexStartRegExp[0]);
			this._quoteRegExp = this.regexFromXML(this._xml.quoteRegExp[0]);
			this._lineCommentStartRegExp = this.regexFromXML(this._xml.lineCommentStartRegExp[0]);
			this._blockCommentStartRegExp = this.regexFromXML(this._xml.blockCommentStartRegExp[0]);
			this._blockCommentEndRegExp = this.regexFromXML(this._xml.blockCommentEndRegExp[0]);
			this._asdocCommentStartRegExp = this.regexFromXML(this._xml.asdocCommentStartRegExp[0]);
			this._asdocKeywordRegExp = this.regexFromXML(this._xml.asdocKeywordRegExp[0]);
			this._wordRegExp = this.regexFromXML(this._xml.wordRegExp[0]);
			this._numberStartRegExp = this.regexFromXML(this._xml.numberStartRegExp[0]);
			this._numberRegExp = this.regexFromXML(this._xml.numberRegExp[0]);
			this._operatorRegExp = this.regexFromXML(this._xml.operatorRegExp[0]);
			this._xmlStartRegExp = this.regexFromXML(this._xml.xmlStartRegExp[0]);
			this._bracketRegExp = this.regexFromXML(this._xml.bracketRegExp[0]);
			this._xmlEndRegExp = this.regexFromXML(this._xml.xmlEndRegExp[0]);
			this._xmlListEndRegExp = this.regexFromXML(this._xml.xmlListEndRegExp[0]);
			this._xmlListStartRegExp = this.regexFromXML(this._xml.xmlListStartRegExp[0]);
		}
		
		public function generateHTML(insertText:String):String
		{
			var html:String = this._xml.htmlTemplate[0];
			var re:RegExp;
			var styles:Vector.<String> = this._styles.styles();
			
			for each (var source:String in styles)
				html = html.replace(new RegExp(source, "g"));
			return html.replace(/%code%/g, insertText);
		}
		
		public function isKeyword(word:String):Boolean
		{
			return Boolean(this._xml.keywords.child(word).length());
		}
		
		public function isClassName(word:String):Boolean
		{
			return Boolean(this._xml.classnames.child(word).length());
		}
		
		public function isReserved(word:String):Boolean
		{
			return Boolean(this._xml.reserved.child(word).length());
		}
		
		private function regexFromXML(node:XML):RegExp
		{
			return new RegExp(node.text(), node.@options);
		}
	}
}