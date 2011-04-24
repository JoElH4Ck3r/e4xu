package org.wvxvws.parsers.as3.resources
{
	public class BracketsInfo
	{
		public function get squareOpen():String { return this._squareOpen; }
		
		public function get squareClose():String { return this._squareClose; }
		
		public function get curlyOpen():String { return this._curlyOpen; }
		
		public function get curlyClose():String { return this._curlyClose; }
		
		public function get parenOpen():String { return this._parenOpen; }
		
		public function get parenClose():String { return this._parenClose; }
			
		private var _squareOpen:String;
		private var _squareClose:String;
		private var _curlyOpen:String;
		private var _curlyClose:String;
		private var _parenOpen:String;
		private var _parenClose:String;
		
		public function BracketsInfo(data:XML)
		{
			super();
			this._squareOpen = data.squareOpen[0];
			this._squareClose = data.squareClose[0];
			this._curlyOpen = data.curlyOpen[0];
			this._curlyClose = data.curlyClose[0];
			this._parenOpen = data.parenOpen[0];
			this._parenClose = data.parenClose[0];
		}
	}
}