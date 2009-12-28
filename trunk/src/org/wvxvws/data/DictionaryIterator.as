package org.wvxvws.data 
{
	import flash.utils.Dictionary;
	
	/**
	 * DictionaryIterator class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class DictionaryIterator implements IIterator
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.data.IIterator */
		
		public function get next():Function { return this._next; }
		
		public function get position():int { return this._position; }
		
		public function get current():Function { return this._current; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _where:Dictionary;
		protected var _position:int = -1;
		protected var _currentObj:Object
		
		protected var _next:Function = function():Object
		{
			var isNext:Boolean;
			for (var o:Object in _where)
			{
				if (isNext)
				{
					_currentObj = o;
					this._position++;
					return o;
				}
				if (!_currentObj)
				{
					_currentObj = o;
					return o;
				}
				else if (_currentObj === o) isNext = true;
			}
			if (isNext) _currentObj = null;
			this._position = -1;
			return null;
		}
		
		protected var _current:Function = function():Object { return _currentObj; }
		
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
		
		public function DictionaryIterator(where:Dictionary) 
		{
			super();
			this._where = where;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function reset():void
		{
			this._currentObj = null;
			this._position = -1;
		}
		
		public function hasNext():Boolean
		{
			var isNext:Boolean;
			for (var o:Object in _where)
			{
				if (isNext) return true;
				if (this._currentObj === null) return true;
				if (this._currentObj === o) isNext = true;
			}
			return false;
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