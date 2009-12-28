package org.wvxvws.data 
{
	/**
	 * DictionaryIterator class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class DictionaryIterator
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get position():int { return _position; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _where:DataDictionary;
		protected var _position:int = -1;
		protected var _current:Object;
		
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
		
		public function DictionaryIterator(where:DataDictionary) 
		{
			super();
			this._where = where;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function next():Object
		{
			var ret:Object;
			if (!this._current.next) return null;
			ret = this._current.target;
			this._position++;
			this._current = this._current.next;
			return ret;
		}
		
		public function reset():void
		{
			this._current = this._list.first;
			this._position = -1;
		}
		
		public function getCurrent():Object { return _current.target; }
		
		public function hasNext():Boolean { return this._current.next !== null; }
		
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