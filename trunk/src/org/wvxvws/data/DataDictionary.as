package org.wvxvws.data 
{
	//{ imports
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	//}
	
	[Event(name="add", type="org.wvxvws.data.SetEvent")]
	[Event(name="change", type="org.wvxvws.data.SetEvent")]
	[Event(name="remove", type="org.wvxvws.data.SetEvent")]
	
	/**
	 * DataDictionary class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class DataDictionary extends EventDispatcher implements Iterable
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get keyType():Class { return _keyType; }
		
		public function get valueType():Class { return _valueType; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _source:Dictionary;
		protected var _keyType:Class;
		protected var _valueType:Class;
		protected var _iterator:DictionaryIterator;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DataDictionary(keyType:Class, 
										valueType:Class, weakKeys:Boolean = false) 
		{
			super();
			this._source = new Dictionary(weakKeys);
			this._keyType = keyType;
			this._valueType = valueType;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function getValue(key:Object):Object
		{
			return this._source[(key as this._keyType)];
		}
		
		public function getKey(value:Object):Object
		{
			if (!(value is this._valueType)) return null;
			for (var o:Object in this._source)
			{
				if (this._source[o] === value) return o;
			}
			return null;
		}
		
		public function add(key:Object, value:Object):void
		{
			if (!(key is this._keyType) || !(value is this._valueType)) return;
			this._source[key] = value;
			super.dispatchEvent(new SetEvent(SetEvent.ADD, value, -1));
		}
		
		public function removeValue(value:Object):void
		{
			if (!(value is this._valueType)) return;
			var key:Object;
			for (var o:Object in this._source)
			{
				if (this._source[o] === value)
				{
					key = o;
					break;
				}
			}
			delete this._source[key];
			super.dispatchEvent(new SetEvent(SetEvent.REMOVE, value, -1));
		}
		
		public function removeKey(key:Object):void
		{
			if (!(key is this._keyType)) return;
			delete this._source[key];
		}
		
		public function hasKey(key:Object):Boolean
		{
			return (key as this._keyType) in this._source;
		}
		
		public function hasValue(value:Object):Boolean
		{
			if (!(value is _valueType)) return false;
			for (var o:Object in this._source)
			{
				if (this._source[o] === value) return true;
			}
			return false;
		}
		
		public function getIterator():IIterator
		{
			if (!_iterator) _iterator = new DictionaryIterator(_source);
			return this._iterator;
		}
		
		public override function toString():String 
		{
			var ret:String = "Dictionary<" + this._keyType ", " + this._valueType + ">{";
			for (var o:Object in this._source)
			{
				ret += o + ": " + this._source[o] + ", ";
			}
			if (ret.charAt(ret.length - 1) === " ")
				ret = ret.substr(0, ret.length - 2);
			return ret + "}";
		}
	}
}