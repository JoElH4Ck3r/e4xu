package org.wvxvws.parsers.as3.resources
{
	public class XMLRegExp
	{
		public function get pi():RegExp { return this._pi; }
		
		public function get comment():RegExp { return this._comment; }
		
		public function get cdata():RegExp { return this._cdata; }
		
		public function get pcdata():RegExp { return this._pcdata; }
		
		public function get attribute():RegExp { return this._attribute; }
		
		public function get name():RegExp { return this._name; }
		
		public function get attributeEQ():RegExp { return this._attributeEQ; }
		
		public function get attributeValue():RegExp { return this._attributeValue; } 
		
		public function get gt():RegExp { return this._gt; }
		
		private var _pi:RegExp;
		
		private var _comment:RegExp;
		
		private var _cdata:RegExp;
		
		private var _pcdata:RegExp;
		
		private var _attribute:RegExp;
		
		private var _name:RegExp;
		
		private var _attributeValue:RegExp;
		
		private var _attributeEQ:RegExp;
		
		private var _gt:RegExp;
		
		public function XMLRegExp(data:XML, regexFromXML:Function)
		{
			super();
			this._pi = regexFromXML(data.pi[0]);
			this._comment = regexFromXML(data.comment[0]);
			this._cdata = regexFromXML(data.cdata[0]);
			this._pcdata = regexFromXML(data.pcdata[0]);
			this._attribute = regexFromXML(data.attribute[0]);
			this._name = regexFromXML(data.name[0]);
			this._attributeValue = regexFromXML(data.attributeValue[0]);
			this._attributeEQ = regexFromXML(data.attributeEQ[0]);
			this._gt = regexFromXML(data.gt[0]);
		}
		
	}
}