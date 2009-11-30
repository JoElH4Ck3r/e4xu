package org.wvxvws.gui.skins 
{
	import flash.display.DisplayObject;
	import mx.core.IMXMLObject;
	
	/**
	 * AbstractProducer class.
	 * @author wvxvw
	 */
	public class AbstractProducer implements IMXMLObject, ISkin
	{
		
		public function get host():ISkinnable { return _host; }
		
		public function set host(value:ISkinnable):void
		{
			if (_host === value) return;
			_host = value;
		}
		
		public function get id():String { return _id; }
		
		protected var _id:String;
		protected var _host:ISkinnable;
		
		public function AbstractProducer() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void { _id = id; }
		
		/* INTERFACE org.wvxvws.gui.skins.ISkin */
		
		public function produce(inContext:Object, ...args):Object { return this; }
		
	}
}