////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) Oleg Sivokon email: olegsivokon@gmail.com
//  
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//  Or visit http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
//
////////////////////////////////////////////////////////////////////////////////

package org.wvxvws.data 
{
	/**
	 * ListIterator class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class ListIterator implements IIterator
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get position():int { return _position; }
		
		/* INTERFACE org.wvxvws.data.IIterator */
		
		public function get next():Function { return this._next; }
		
		public function get current():Function { return this._current; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _list:DataList;
		protected var _position:int = -1;
		protected var _currentCell:ListCell;
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		internal function get currentCell():ListCell { return this._currentCell; }
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ListIterator(list:DataList) 
		{
			super();
			this._list = list;
			this._currentCell = list.first;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function reset():void
		{
			this._currentCell = this._list.first;
			this._position = -1;
		}
		
		public function hasNext():Boolean { return this._currentCell.next !== null; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function _current():Object { return this._currentCell.target; }
		
		protected function _next():Object
		{
			var ret:Object;
			if (!this._currentCell.next) return null;
			ret = this._currentCell.target;
			this._position++;
			this._currentCell = this._currentCell.next;
			return ret;
		}
		
	}
}