package org.wvxvws.gui.styles 
{
	//{imports
	import flash.utils.ByteArray;
	import mx.core.IMXMLObject;
	//}
	
	[DefaultProperty("source")]
	
	/**
	* STYLE class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class STYLE implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
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
		
		private var _id:String;
		private var _document:Object;
		private var _source:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function STYLE() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_id = id;
			_document = document;
		}
		
		public function get id():String { return _id; }
		
		public function set source(value:Object):void 
		{
			if (_source) throw new Error("Already set.");
			switch (true)
			{
				case (value is String):
					_source = value as String;
					break;
				case (value is Class):
					_source = new (value as Class)().toString();
					break;
				case (value is ByteArray):
					_source = (value as ByteArray).readUTF();
					break;
				default:
					throw new Error("Wrong source type.");
			}
			trace(_source);
		}
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