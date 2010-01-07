package org.wvxvws.data 
{
	/**
	 * SetIterator class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class SetIterator implements IIterator
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.data.IIterator */
		
		public function get next():Function { return this._next; }
		
		public function get current():Function { return this._current; }
		
		public function get position():int { return this._position; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _where:DataSet;
		protected var _position:int = -1;
		
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
		
		public function SetIterator(where:DataSet) 
		{
			super();
			this._where = where;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function hasNext():Boolean
		{
			return this._position < this._where.length;
		}
		
		public function reset():void { this._position = -1; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function _next():Object { return this._where[++this._position]; }
		
		protected function _current():Object { return this._where[this._position]; }
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
}