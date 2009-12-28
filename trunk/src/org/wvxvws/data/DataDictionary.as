package org.wvxvws.data 
{
	//{ imports
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	//}
	
	/**
	 * DataDictionary class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class DataDictionary extends EventDispatcher
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
		
		protected var _source:Dictionary;
		protected var _keyType:Dictionary;
		protected var _valueType:Dictionary;
		
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
		
		public function DataDictionary(valueType:Class, 
										keyType:Class, weakKeys:Boolean = false) 
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
		
		public function add(value:Object, key:Object):void
		{
			
		}
		
		public function removeValue(value:Object):void
		{
			
		}
		
		public function removeKey(key:Object):void
		{
			
		}
		
		public function getIterator():DictionaryIterator
		{
			return null;
		}
		
		public function getValue(key:Object):Object
		{
			return null;
		}
		
		public function getKey(value:Object):Object
		{
			return null;
		}
		
		public function hasKey(key:Object):Boolean
		{
			
		}
		
		public function hasValue(value:Object):Boolean
		{
			
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