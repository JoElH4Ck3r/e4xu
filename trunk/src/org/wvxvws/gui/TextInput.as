package org.wvxvws.gui 
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import mx.core.IMXMLObject;
	
	/**
	 * TextInput class.
	 * @author wvxvw
	 */
	public class TextInput extends TextField implements IMXMLObject
	{
		protected var _document:Object;
		protected var _id:String;
		
		public function TextInput() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			if (_document is DisplayObjectContainer) 
				(_document as DisplayObjectContainer).addChild(this);
			_id = id;
		}
		
	}
	
}