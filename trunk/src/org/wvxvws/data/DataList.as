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
	//{ imports
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	//}
	
	[Event(name="add", type="org.wvxvws.data.SetEvent")]
	[Event(name="change", type="org.wvxvws.data.SetEvent")]
	[Event(name="remove", type="org.wvxvws.data.SetEvent")]
	[Event(name="sort", type="org.wvxvws.data.SetEvent")]
	
	/**
	 * DataList class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class DataList extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get length():uint { return _length; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected static const pool:DataList = new DataList(ListCell);
		
		protected var _first:ListCell;
		protected var _type:Class;
		protected var _length:uint;
		protected var _iterator:ListIterator;
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		internal function get first():ListCell { return _first; }
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DataList(type:Class) 
		{
			super();
			this._type = type;
			this._first = new ListCell(null, null);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public static methods
		//
		//--------------------------------------------------------------------------
		
		public static function fromArray(input:Array, type:Class):DataList
		{
			var dl:DataList = new DataList(type);
			var cell:ListCell = dl._first;
			var newCell:ListCell;
			for each (var o:Object in input)
			{
				if (!(o is type)) continue;
				if (pool.length) newCell = pool.pop();
				else newCell = new ListCell(null, null);
				cell.target = o;
				cell.next = newCell;
				cell = newCell;
			}
			return dl;
		}
		
		public static function fromVector(input:Object):DataList
		{
			var type:Class;
			var ts:String = describeType(input).@name;
			if (ts.indexOf("::Vector") < 0)
				throw new ArgumentError(input + " must be Vector.");
			ts = ts.replace(/.*<(.*)>.*/g, "$1");
			type = getDefinitionByName(ts) as Class;
			var dl:DataList = new DataList(type);
			var cell:ListCell = dl._first;
			var newCell:ListCell;
			for each (var o:Object in input)
			{
				if (pool.length) newCell = pool.pop();
				else newCell = new ListCell(null, null);
				cell.target = o;
				cell.next = newCell;
				cell = newCell;
			}
			return dl;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function add(item:Object, position:int = -1):void
		{
			if (!(item is _type)) return;
			position = Math.min(Math.max(-1, position), this._length);
			var freeCell:ListCell;
			var seekCell:ListCell;
			var i:int;
			var nextCell:ListCell = _first;
			var prevCell:ListCell;
			
			if (pool.length) freeCell = pool.pop();
			else freeCell = new ListCell(item, null);
			if (position < 0)
			{
				seekCell = this._first;
				this._first = freeCell;
			}
			else
			{
				while (nextCell.next)
				{
					prevCell = nextCell;
					nextCell = nextCell.next;
					if (++i == position)
					{
						seekCell = nextCell;
						break;
					}
				}
			}
			freeCell.next = seekCell;
			if (prevCell) prevCell.next = freeCell;
			this._length++;
			super.dispatchEvent(new SetEvent(SetEvent.ADD, position));
		}
		
		public function remove(item:Object):Object
		{
			if (!(item is _type)) return null;
			var i:int;
			var cell:ListCell = _first;
			var prev:ListCell;
			var ret:Object;
			while (cell.next)
			{
				prev = cell;
				cell = cell.next;
				i++;
				if (cell.target === item)
				{
					ret = cell.target;
					prev.next = cell.next;
					this._length--;
					break;
				}
			}
			if (this._iterator && cell && this._iterator.current === cell)
			{
				this._iterator.reset();
			}
			super.dispatchEvent(new SetEvent(SetEvent.REMOVE, i));
			return ret;
		}
		
		public function seek(position:int):Object
		{
			var i:int;
			var cell:ListCell = _first;
			while (cell.next)
			{
				cell = cell.next;
				if (++i == position) return cell.target as _type;
			}
			return null;
		}
		
		public function find(item:Object):int
		{
			var i:int;
			var cell:ListCell = _first;
			while (cell.next)
			{
				cell = cell.next;
				i++;
				if (cell.target === item) return i;
			}
			return -1;
		}
		
		public function getIterator(reset:Boolean = true):ListIterator
		{
			if (!this._iterator) this._iterator = new ListIterator(this);
			if (reset) this._iterator.reset();
			return this._iterator;
		}
		
		public function clean(usePool:Boolean = true):void
		{
			this._length = 0;
			var cell:ListCell = this._first;
			var nextCell:ListCell;
			while (cell.next)
			{
				nextCell = cell.next;
				cell.next = null;
				cell.target = null;
				if (usePool) pool.add(cell);
				cell = nextCell;
			}
		}
		
		public function map(callback:Function):void
		{
			var cell:ListCell = this._first;
			var i:int;
			while (cell.next)
			{
				callback(cell.target, i);
				i++;
				cell = cell.next;
			}
		}
		
		public function filter(callback:Function):DataList
		{
			var cell:ListCell = this._first;
			var i:int;
			var dl:DataList = new DataList(this._type);
			var copyLast:ListCell;
			while (cell.next)
			{
				if (callback(cell.target, i))
				{
					if (copyLast) copyLast.next = cell;
					else dl._first = cell;
					copyLast = cell;
				}
				i++;
				cell = cell.next;
			}
			if (copyLast) copyLast.next = null;
			return dl;
		}
		
		public override function toString():String
		{
			var ret:String = "DataList<" + getQualifiedClassName(this._type) + ">{";
			var i:int;
			var cell:ListCell = _first;
			while (cell.next)
			{
				ret += i + ": " + cell.target + ", ";
				cell = cell.next;
				i++;
			}
			if (cell.target) ret += i + ": " + cell.target;
			else if (ret.charAt(ret.length - 1) === " ")
				ret = ret.substr(0, ret.length - 2);
			return ret + "}";
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function pop():ListCell
		{
			if (!this._length) return null;
			var ret:ListCell = this._first;
			this._first = this._first.next;
			this._length--;
			if (this._iterator && this._iterator.current === ret)
			{
				this._iterator.reset();
			}
			return ret;
		}
	}
}