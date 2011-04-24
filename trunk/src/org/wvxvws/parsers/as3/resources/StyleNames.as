package org.wvxvws.parsers.as3.resources
{
	public class StyleNames
	{
		public function get string():String { return this._string; }
		
		public function get number():String { return this._number; }
		
		public function get regexp():String { return this._regexp; }
		
		public function get operator():String { return this._operator; }
		
		public function get keyword():String { return this._keyword; }
		
		public function get classname():String { return this._classname; }
		
		public function get reserved():String { return this._reserved; }
		
		public function get asdocComment():String { return this._asdocComment; }
		
		public function get asdocKeyword():String { return this._asdocKeyword; }
		
		public function get blockComment():String { return this._blockComment; }
		
		public function get lineComment():String { return this._lineComment; }
		
		public function get xml():String { return this._xml; }
		
		public function get xmlElement():String { return this._xmlElement; }
		
		public function get xmlAttribute():String { return this._xmlAttribute; }
		
		public function get xmlText():String { return this._xmlText; }
		
		public function get xmlPI():String { return this._xmlPI; }
		
		public function get xmlCData():String { return this._xmlCData; }
		
		public function get xmlComment():String { return this._xmlComment; }
		
		public function get codeBase():String { return this._codeBase; }
		
		private var _string:String;
		private var _number:String;
		private var _regexp:String;
		private var _operator:String;
		private var _keyword:String;
		private var _classname:String;
		private var _reserved:String;
		private var _asdocComment:String;
		private var _asdocKeyword:String;
		private var _blockComment:String;
		private var _lineComment:String;
		private var _xml:String;
		private var _xmlElement:String;
		private var _xmlAttribute:String;
		private var _xmlText:String;
		private var _xmlPI:String;
		private var _xmlCData:String;
		private var _xmlComment:String;
		private var _codeBase:String;
		
		public function StyleNames(data:XML)
		{
			super();
			this._string = data.string[0];
			this._number = data.number[0];
			this._regexp = data.regexp[0];
			this._operator = data.operator[0];
			this._keyword = data.keyword[0];
			this._classname = data.classname[0];
			this._reserved = data.reserved[0];
			this._asdocComment = data.asdocComment[0];
			this._asdocKeyword = data.asdocKeyword[0];
			this._blockComment = data.blockComment[0];
			this._lineComment = data.lineComment[0];
			this._xml = data.xml[0];
			this._xmlElement = data.xmlElement[0];
			this._xmlAttribute = data.xmlAttribute[0];
			this._xmlText = data.xmlText[0];
			this._xmlPI = data.xmlPI[0];
			this._xmlCData = data.xmlCData[0];
			this._xmlComment = data.xmlComment[0];
			this._codeBase = data.codeBase[0];
		}
		
		public function styles():Vector.<String>
		{
			return new <String>[
				this._string,
				this._number,
				this._regexp,
				this._operator,
				this._keyword,
				this._classname,
				this._reserved,
				this._asdocComment,
				this._asdocKeyword,
				this._blockComment,
				this._lineComment,
				this._xml,
				this._xmlElement,
				this._xmlAttribute,
				this._xmlText,
				this._xmlPI,
				this._xmlCData,
				this._xmlComment,
				this._codeBase
				];
		}
	}
}