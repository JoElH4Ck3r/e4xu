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
		
		public function get getValue():Function { return this._getValue; }
		
		public function get getKey():Function { return this._getKey; }
		
		public function get add():Function { return this._add; }
		
		public function get removeValue():Function { return this._removeValue; }
		
		public function get removeKey():Function { return this._removeKey; }
		
		public function get hasKey():Function { return this._hasKey; }
		
		public function get hasValue():Function { return this._hasValue; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _source:Dictionary;
		protected var _keyType:Class;
		protected var _valueType:Class;
		protected var _iterator:DictionaryIterator;
		
		protected var _getValue:Function = function(key:Object):Object
		{
			return _source[(key as _keyType)];
		}
		
		protected var _getKey:Function = function(value:Object):Object
		{
			if (!(value is _valueType)) return null;
			for (var o:Object in _source)
			{
				if (_source[o] === value) return o;
			}
			return null;
		}
		
		protected var _add:Function = function(key:Object, value:Object):void
		{
			if (!(key is _keyType) || !(value is _valueType)) return;
			_source[key] = value;
			dispatchEvent(new SetEvent(SetEvent.ADD, value, -1));
		}
		
		protected var _removeValue:Function = function(value:Object):void
		{
			if (!(value is _valueType)) return;
			var key:Object;
			for (var o:Object in _source)
			{
				if (_source[o] === value)
				{
					key = o;
					break;
				}
			}
			delete _source[key];
			dispatchEvent(new SetEvent(SetEvent.REMOVE, value, -1));
		}
		
		protected var _removeKey:Function = function(key:Object):void
		{
			if (!(key is _keyType)) return;
			delete _source[key];
		}
		
		protected var _hasKey:Function = function(key:Object):Boolean
		{
			return (key as _keyType) in _source;
		}
		
		protected var _hasValue:Function = function(value:Object):Boolean
		{
			if (!(value is _valueType)) return false;
			for (var o:Object in _source)
			{
				if (_source[o] === value) return true;
			}
			return false;
		}
		
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
		
		public function getIterator():IIterator
		{
			if (!_iterator) _iterator = new DictionaryIterator(_source);
			return _iterator;
		}
		
		public override function toString():String 
		{
			var ret:String = "Dictionary<" + _keyType ", " + _valueType + ">{";
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