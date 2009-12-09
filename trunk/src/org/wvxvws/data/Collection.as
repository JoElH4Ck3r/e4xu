package org.wvxvws.data 
{
	import flash.events.EventDispatcher;
	import mx.core.IMXMLObject;
	
	[Event(name="dataChange", type="org.wvxvws.data.DataChangeEvent")]
	
	/**
	* Collection class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Collection extends EventDispatcher implements IMXMLObject
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
		
		protected var _document:Object;
		protected var _id:String;
		protected var _source:Array = [];
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function Collection(source:Array = null) 
		{
			super();
			_source = source;
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		public function get source():Array { return _source; }
		
		public function set source(value:Array):void 
		{
			if (_source === value) return;
			_source = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function push(...rest):int
		{
			var ret:int = _source.unshift.apply(_source, rest);
			super.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, 
										DataChangeEvent.PUSH, rest));
			return ret;
		}
		
		public function unshift(...rest):int
		{
			var ret:int = _source.unshift.apply(_source, rest);
			super.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, 
										DataChangeEvent.UNSHIFT, rest));
			return ret;
		}
		
		public function splice(index:int, quantity:int, ...rest):Array
		{
			var ret:Array = 
				_source.splice.apply(_source, [index, quantity].concat(rest));
			super.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, 
					DataChangeEvent.SPLICE, [index, quantity].concat(rest)));
			return ret;
		}
		
		public function pop():*
		{
			var ret:* = _source.pop();
			super.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, 
										DataChangeEvent.POP, ret));
			return ret;
		}
		
		public function shift():*
		{
			var ret:* = _source.shift();
			super.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, 
										DataChangeEvent.SHIFT, ret));
			return ret;
		}
		
		public function getItemAt(index:int):* { return _source[index]; }
		
		public function setItemAt(index:int, item:*):void
		{
			_source[index] = item;
			super.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, 
								DataChangeEvent.REFRESH, _source[index]));
		}
		
		public function refresh():void
		{
			super.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, 
										DataChangeEvent.REFRESH, null));
		}
		
		public function sort(helper:Function = null):Array
		{
			var ret:Array = _source.sort(helper);
			super.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, 
										DataChangeEvent.SORT, ret));
			return ret;
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
	}
	
}