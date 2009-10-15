package org.wvxvws.gui.skins 
{
	import flash.display.DisplayObject;
	import mx.core.IMXMLObject;
	
	/**
	 * AbstractProducer class.
	 * @author wvxvw
	 */
	public class AbstractProducer implements IMXMLObject
	{
		public function get id():String { return _id; }
		
		protected var _id:String;
		
		public function AbstractProducer() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void { _id = id; }
		
	}

}