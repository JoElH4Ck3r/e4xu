package org.wvxvws.data 
{
	//{ imports
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	//}
	
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
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		protected static const pool:DataList = new DataList(ListCell);
		
		protected var _source:ListCell;
		protected var _type:Class;
		protected var _last:ListCell;
		protected var _length:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DataList(type:Class) 
		{
			super();
			this._type = type;
			this._source = new ListCell(null, null);
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
			var nextCell:ListCell = _source;
			var prevCell:ListCell;
			
			if (pool.length) freeCell = pool.pop();
			else freeCell = new ListCell(item, null);
			if (position < 0)
			{
				seekCell = this._source;
				this._source = freeCell;
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
			var o:ListCell = _source;
			var prev:ListCell;
			var ret:Object;
			while (o.next)
			{
				prev = o;
				o = o.next;
				i++;
				if (o.target === item)
				{
					ret = o.target;
					prev.next = o.next;
					this._length--;
					break;
				}
			}
			super.dispatchEvent(new SetEvent(SetEvent.REMOVE, i));
			return ret;
		}
		
		public function seek(position:int):Object
		{
			var i:int;
			var o:ListCell = _source;
			while (o.next)
			{
				o = o.next;
				if (++i == position) return o.target as _type;
			}
			return null;
		}
		
		public function find(item:Object):int
		{
			var i:int;
			var o:ListCell = _source;
			while (o.next)
			{
				o = o.next;
				i++;
				if (o.target === item) return i;
			}
			return -1;
		}
		
		public override function toString():String
		{
			var ret:String = "DataList<" + getQualifiedClassName(_type) + ">{";
			var i:int;
			var o:ListCell = _source;
			while (o.next)
			{
				ret += i + ": " + o.target + ", ";
				o = o.next;
				i++;
			}
			if (ret.charAt(ret.length - 1) === " ")
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
			var ret:ListCell = this._source;
			this._source = this._source.next;
			this._length--;
			return ret;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
}