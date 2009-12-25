package org.wvxvws.data 
{
	/**
	 * ListIterator class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class ListIterator
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get current():ListCell { return _current; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _list:DataList;
		protected var _position:int;
		protected var _current:ListCell;
		
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
		
		public function ListIterator(list:DataList) 
		{
			super();
			this._list = list;
			this._current = list.seek(0);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function next():Object
		{
			if (!this._current.next) return null;
			this._position++;
			this._current = this._current.next;
			return this._current.target;
		}
		
		public function reset():void
		{
			this._current = list.seek(0);
			this._position = 0;
		}
		
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