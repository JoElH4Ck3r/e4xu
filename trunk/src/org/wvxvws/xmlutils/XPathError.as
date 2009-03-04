package org.wvxvws.xmlutils 
{
	
	/**
	* XPathError class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class XPathError extends Error
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		private static const _0:String = "XPathError error.";
		private static const _1:String = "Arguments $1 are invalid.";
		private static const _2:String = "$1 not implemented.";
		
		override public function get errorID():int { return _id; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		private var _id:int;
		private var _args:Array;
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		public function XPathError(id:int, ...args) 
		{
			super("", id);
			if (!isNaN(id)) _id = id;
			if (args) _args = args.slice();
			if (_args) message = XPathError["_" + id].replace(/\$\d+/, createMessage);
			else message = _0;
		}
		
		private function createMessage(...rest):String { return _args.shift(); }
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}