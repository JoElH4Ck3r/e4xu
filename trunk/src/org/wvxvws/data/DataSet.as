package org.wvxvws.data
{
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	[Event(name="add", type="org.wvxvws.data.SetEvent")]
	[Event(name="change", type="org.wvxvws.data.SetEvent")]
	[Event(name="remove", type="org.wvxvws.data.SetEvent")]
	[Event(name="sort", type="org.wvxvws.data.SetEvent")]
	
	/**
	 * DataSet class.
	 * @author wvxvw
	 */
	public class DataSet extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get length():int
		{
			if (_source) return _source.length;
			return 0;
		}
		
		public function get type():Class { return _type; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _source:Object;
		protected var _type:Class;
		
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
		
		public function DataSet(type:Class) 
		{
			super();
			_type = type;
			var c:Class = getDefinitionByName("__AS3__.vec::Vector.<" + 
				getQualifiedClassName(type) + ">") as Class;
			_source = new c();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public static methods
		//
		//--------------------------------------------------------------------------
		
		public static function fromXML(from:XML):DataSet
		{
			var ds:DataSet = new DataSet(XML);
			from.*.(ds.add(valueOf()));
			return ds;
		}
		
		public static function fromXMLList(from:XMLList):DataSet
		{
			var ds:DataSet = new DataSet(XML);
			from.(ds.add(valueOf()));
			trace(ds.at(0).toXMLString());
			return ds;
		}
		
		public static function fromArray(from:Array):DataSet
		{
			var ds:DataSet = new DataSet(Object);
			for each (var o:Object in from) ds.add(o);
			return ds;
		}
		
		public static function fromVector(from:Object):DataSet
		{
			var type:Class;
			var ts:String = describeType(from).@name;
			if (ts.indexOf("::Vector") < 0)
				throw new ArgumentError(from + " must be Vector.");
			ts = ts.replace(/.*<(.*)>.*/g, "$1");
			type = getDefinitionByName(ts) as Class;
			var ds:DataSet = new DataSet(type);
			for each (var o:Object in from) ds.add(o);
			return ds;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function add(item:Object, index:int = -1):void
		{
			if (index < 0) _source.push(item);
			else _source.splice(index, 0, item);
			if (super.hasEventListener(SetEvent.ADD))
			{
				super.dispatchEvent(new SetEvent(SetEvent.ADD, item, index));
			}
		}
		
		public function put(item:Object, index:int):void
		{
			_source[index] = item;
			if (super.hasEventListener(SetEvent.CHANGE))
			{
				super.dispatchEvent(new SetEvent(SetEvent.CHANGE, item, index));
			}
		}
		
		public function remove(item:Object):void
		{
			var i:int = _source.indexOf(item);
			_source.splice(i, 1);
			if (super.hasEventListener(SetEvent.REMOVE))
			{
				super.dispatchEvent(new SetEvent(SetEvent.REMOVE, item, i));
			}
		}
		
		public function at(index:int):Object { return _source[index]; }
		
		public function clone():DataSet
		{
			var ds:DataSet = new DataSet(_type);
			for each (var o:Object in _source) ds.add(o);
			return ds;
		}
		
		public function sort(on:Function):void
		{
			_source.sort(on);
			if (super.hasEventListener(SetEvent.SORT))
			{
				super.dispatchEvent(new SetEvent(SetEvent.SORT, null));
			}
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