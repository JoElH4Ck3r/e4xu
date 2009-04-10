package org.wvxvws.gui 
{
	import flash.display.Sprite;
	import mx.core.IMXMLObject;
	
	/**
	 * Skin class.
	 * @author wvxvw
	 */
	public class Skin extends Sprite implements IMXMLObject
	{
		public var states:Object = {};
		protected var _document:Object;
		protected var _id:String;
		
		public function Skin() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
	}
	
}