package org.wvxvws.mxmlutils 
{
	import flash.events.EventDispatcher;
	import mx.core.IMXMLObject;
	
	/**
	* Map class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Map extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get euid():int { return _euid; }
		
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
		
		private static var _uidGenerator:int;
		
		private var _document:Object;
		private var _name:QName;
		private var _euid:int;
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		internal static var instances:Array = [];
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function Map() 
		{
			super();
			_euid = generateUID();
			instances.push(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function hasEvent(eventType:String):Boolean
		{
			var l:Listener;
			for (var p:String in this)
			{
				l = this[p] as Listener;
				if (l && l.eventType == eventType) return true;
			}
			return false;
		}
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_name = new QName(id);
		}
		
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
		
		private static function generateUID():int
		{
			return (++_uidGenerator);
		}
	}
	
}