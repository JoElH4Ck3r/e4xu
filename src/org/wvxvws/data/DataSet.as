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
		public function get length():int
		{
			if (_source) return _source.length;
			return 0;
		}
		
		public function get type():Class { return _type; }
		
		protected var _source:Object;
		protected var _type:Class;
		
		public function DataSet(type:Class) 
		{
			super();
			_type = type;
			var c:Class = getDefinitionByName("__AS3__.vec::Vector.<" + 
				getQualifiedClassName(type) + ">") as Class;
			_source = new c();
		}
		
		public static function dataSetFromXML(from:XML):DataSet
		{
			var ds:DataSet = new DataSet(XML);
			from.*.(ds.add(valueOf()));
			return ds;
		}
		
		public static function dataSetFromXMLList(from:XMLList):DataSet
		{
			var ds:DataSet = new DataSet(XML);
			from.(ds.add(valueOf()));
			return ds;
		}
		
		public static function dataSetFromArray(from:Array):DataSet
		{
			var ds:DataSet = new DataSet(Object);
			for each (var o:Object in from) ds.add(o);
			return ds;
		}
		
		public static function dataSetFromVector(from:Object):DataSet
		{
			var type:Class;
			var ts:String = describeType(from).@name;
			if (ts.indexOf("::Vector") < 0)
				throw new ArgumentError("Value must be Vector.");
			ts = ts.replace(/.*<(.*)>.*/g, "$1");
			type = getDefinitionByName(ts) as Class;
			var ds:DataSet = new DataSet(type);
			for each (var o:Object in from) ds.add(o);
			return ds;
		}
		
		public function add(item:Object, index:int = -1):void
		{
			if (index < 0) _source.push(item);
			else _source.splice(index, 0, item);
			if (super.hasEventListener(DataChangeEvent.ADD))
			{
				super.dispatchEvent(
					new DataChangeEvent(DataChangeEvent.ADD, item, index));
			}
		}
		
		public function put(item:Object, index:int):void
		{
			_source[index] = item;
			if (super.hasEventListener(DataChangeEvent.CHANGE))
			{
				super.dispatchEvent(
					new DataChangeEvent(DataChangeEvent.CHANGE, item, index));
			}
		}
		
		public function remove(item:Object):void
		{
			var i:int = _source.indexOf(item);
			_source.splice(i, 1);
			if (super.hasEventListener(DataChangeEvent.REMOVE))
			{
				super.dispatchEvent(
					new DataChangeEvent(DataChangeEvent.REMOVE, item, i));
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
			if (super.hasEventListener(DataChangeEvent.SORT))
			{
				super.dispatchEvent(
					new DataChangeEvent(DataChangeEvent.SORT, null));
			}
		}
	}
}