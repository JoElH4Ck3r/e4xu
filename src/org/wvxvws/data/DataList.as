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
	import flash.utils.Dictionary;
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
		
		public function get length():uint { return this._length; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected static const pool:Dictionary = new Dictionary(true);
		
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
			this._first = new ListCell(null, null, null);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected static methods
		//
		//--------------------------------------------------------------------------
		
		protected static function cellFromPool():ListCell
		{
			var ret:ListCell;
			for (var o:Object in pool)
			{
				ret = o as ListCell;
				break;
			}
			delete pool[ret];
			return ret;
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
			var prevCell:ListCell;
			var i:int;
			for each (var o:Object in input)
			{
				if (!(o is type)) continue;
				newCell = cellFromPool();
				if (!newCell) newCell = new ListCell(null, null, null);
				cell.target = o;
				cell.next = newCell;
				cell.prev = prevCell;
				prevCell = cell;
				cell = newCell;
				i++;
			}
			if (prevCell) prevCell.next = null;
			dl._length = i;
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
			var prevCell:ListCell;
			var i:int;
			for each (var o:Object in input)
			{
				newCell = cellFromPool();
				if (!newCell) newCell = new ListCell(null, null, null);
				cell.target = o;
				cell.next = newCell;
				cell.prev = prevCell;
				prevCell = cell;
				cell = newCell;
				i++;
			}
			if (prevCell) prevCell.next = null;
			dl._length = i;
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
			var seekCell:ListCell;
			var i:int;
			var nextCell:ListCell = _first;
			var prevCell:ListCell;
			var freeCell:ListCell = cellFromPool();
			if (!freeCell) freeCell = new ListCell(null, null, null);
			
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
			freeCell.prev = prevCell;
			this._length++;
			super.dispatchEvent(new SetEvent(SetEvent.ADD, freeCell.target, position));
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
					if (cell.next) cell.next.prev = prev;
					this._length--;
					break;
				}
			}
			if (this._iterator && cell && this._iterator.current === cell)
			{
				this._iterator.reset();
			}
			super.dispatchEvent(new SetEvent(SetEvent.REMOVE, ret, i));
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
				if (usePool) pool[cell] = true;
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
		
		public function clone():DataList
		{
			var ret:DataList = new DataList(this._type);
			var cell:ListCell = this._first;
			var clonedCell:ListCell = ret._first;
			var freeCell:ListCell;
			var i:int;
			while (cell.next)
			{
				freeCell = cellFromPool();
				if (!freeCell) freeCell = new ListCell(null, null, null);
				clonedCell.next = freeCell;
				clonedCell.target = cell.target;
				clonedCell.prev = cell.prev;
				clonedCell = freeCell;
				cell = cell.next;
				i++;
			}
			if (i)
			{
				clonedCell.target = cell.target;
				ret._length = ++i;
			}
			return ret;
		}
		
		public function sort(callback:Function = null):void
		{
			var list:ListCell = this._first;
			var list2:ListCell;
			var l1next:ListCell;
			var l1prev:ListCell;

			var l2next:ListCell;
			var l2prev:ListCell;
			var oldHead:ListCell = this._first;
			var useCallback:Boolean = callback is Function;
			
			while (list)
			{
				list2 = list.next;
				
				while (list2)
				{
					if ((useCallback && callback(list.target, list2.target)) || 
						(!useCallback && list < list2))
					{
						l1next = list.next;
						l1prev = list.prev;
						
						l2next = list2.next;
						l2prev = list2.prev;
						
						if (l1next) l1next.prev = list2;
						if (l1prev) l1prev.next = list2;
						
						if (list2 !== l1next) list2.next = l1next;
						else list2.next = list;
						
						if (list2 !== l1prev) list2.prev = l1prev;
						else list2.prev = list;
						
						if (l2next) l2next.prev = list;
						if (l2prev) l2prev.next = list;
						
						if (list !== l2next) list.next = l2next;
						else list.next = list2;
						
						if (list !== l2prev) list.prev = l2prev;
						else list.prev = list2;
						
						l1next = list;
						list = list2;
						list2 = l1next; 
					}
					list2 = list2.next;
				}
				list = list.next;
			}
			
			while (oldHead.prev)
			{
				this._first = oldHead.prev;
				oldHead = oldHead.prev;
			}
			super.dispatchEvent(new SetEvent(SetEvent.SORT, null, -1));
		}
		
		public function bubbleSort(callback:Function):void
		{
			var oldHead:ListCell = this._first;
			var oldTail:ListCell;
			var cellA:ListCell = this._first;
			var cellB:ListCell;
			var useCallback:Boolean = callback is Function;
			
			while (cellA)
			{
				cellB = cellA;
				cellA = cellA.next;
			}
			oldTail = cellB;
			cellA = oldHead;
			cellB = cellA.next;
			while (cellB)
			{
				if ((useCallback && callback(cellA.target, cellB.target)) || 
					(!useCallback && cellA < cellB))
				{
					cellA = cellA.next;
					cellB = cellA.next;
				}
				else
				{
					cellB.prev = cellA.prev;
					oldHead = oldTail;
					oldTail.next = cellA;
					oldTail = oldTail.next;
					oldTail.prev = oldHead;
					oldTail.next = null;
					if (cellB.prev)
					{
						cellA = cellB.prev;
						cellA.next = cellB;
					}
					else
					{
						cellB = cellB.next;
						cellA = cellB.prev;
						cellA.prev = null;
					}
				}
			}
			while (cellA)
			{
				cellB = cellA;
				cellA = cellA.prev;
			}
			this._first = cellB;
			super.dispatchEvent(new SetEvent(SetEvent.SORT, null, -1));
		}
		
		public function toVector():Object
		{
			var cell:ListCell = this._first;
			var c:Class = getDefinitionByName("__AS3__.vec::Vector.<" + 
				getQualifiedClassName(this._type) + ">") as Class;
			var v:Object = new c();
			while (cell)
			{
				v.push(cell.target);
				cell = cell.next;
			}
			return v;
		}
		
		public function toArray():Array
		{
			var cell:ListCell = this._first;
			var v:Array = [];
			while (cell)
			{
				v.push(cell.target);
				cell = cell.next;
			}
			return v;
		}
		
		public override function toString():String
		{
			var ret:String = "DataList<" + getQualifiedClassName(this._type) + ">{";
			var i:int;
			var cell:ListCell = this._first;
			while (cell.next && this._length > i)
			{
				ret += i + ": " + cell.target + ", ";
				cell = cell.next;
				i++;
			}
			if (i) ret += i + ": " + cell.target;
			else if (ret.charAt(ret.length - 1) === " ")
				ret = ret.substr(0, ret.length - 2);
			return ret + "}";
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
	}
}
