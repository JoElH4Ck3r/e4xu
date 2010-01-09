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
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import org.wvxvws.data.IIterator;
	
	[Event(name="add", type="org.wvxvws.data.SetEvent")]
	[Event(name="change", type="org.wvxvws.data.SetEvent")]
	[Event(name="remove", type="org.wvxvws.data.SetEvent")]
	[Event(name="sort", type="org.wvxvws.data.SetEvent")]
	
	/**
	 * DataSet class.
	 * @author wvxvw
	 */
	public class DataSet extends EventDispatcher implements Iterable
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get length():int
		{
			if (this._source) return this._source.length;
			return 0;
		}
		
		public function get type():Class { return this._type; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _source:Object;
		protected var _type:Class;
		protected var _iterator:IIterator;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DataSet(type:Class) 
		{
			super();
			this._type = type;
			var c:Class = getDefinitionByName("__AS3__.vec::Vector.<" + 
				getQualifiedClassName(type) + ">") as Class;
			this._source = new c();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public static methods
		//
		//--------------------------------------------------------------------------
		
		public static function fromXML(from:XML):DataSet
		{
			var ds:DataSet = new DataSet(XML);
			var s:Vector.<XML> = ds._source as Vector.<XML>;
			from.*.(s.push(valueOf()));
			return ds;
		}
		
		public static function fromXMLList(from:XMLList):DataSet
		{
			var ds:DataSet = new DataSet(XML);
			var s:Vector.<XML> = ds._source as Vector.<XML>;
			from.(s.push(valueOf()));
			return ds;
		}
		
		public static function fromArray(from:Array):DataSet
		{
			var ds:DataSet = new DataSet(Object);
			ds._source.push.apply(ds._source, from);
			return ds;
		}
		
		public static function fromVector(from:Object):DataSet
		{
			var ts:String = describeType(from).@name;
			if (ts.indexOf("::Vector") < 0)
				throw new ArgumentError(from + " must be Vector.");
			ts = ts.replace(/.*<(.*)>.*/g, "$1");
			var ds:DataSet = new DataSet(getDefinitionByName(ts) as Class);
			var s:Object = ds._source;
			for each (var o:Object in from) s.push(o);
			return ds;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function add(item:Object, index:int = -1):void
		{
			if (index < 0) this._source.push(item);
			else this._source.splice(index, 0, item);
			if (super.hasEventListener(SetEventType.ADD.toString()))
			{
				super.dispatchEvent(new SetEvent(SetEventType.ADD, item, index));
			}
		}
		
		public function put(item:Object, index:int):void
		{
			this._source[index] = item;
			if (super.hasEventListener(SetEventType.CHANGE.toString()))
			{
				super.dispatchEvent(new SetEvent(SetEventType.CHANGE, item, index));
			}
		}
		
		public function remove(item:Object):void
		{
			var i:int = this._source.indexOf(item);
			this._source.splice(i, 1);
			if (super.hasEventListener(SetEventType.REMOVE.toString()))
			{
				super.dispatchEvent(new SetEvent(SetEventType.REMOVE, item, i));
			}
		}
		
		public function at(index:int):Object { return this._source[index]; }
		
		public function clone():DataSet
		{
			var ds:DataSet = new DataSet(this._type);
			ds._source = this._source.concat();
			return ds;
		}
		
		public function bubbleSort(callback:Function = null):void
		{
			this._source.sort(callback);
			if (super.hasEventListener(SetEventType.SORT.toString()))
			{
				super.dispatchEvent(new SetEvent(SetEventType.SORT, null));
			}
		}
		
		public function sort(callback:Function = null):void
		{
			var n:int = this._source.length;
			var inc:int = n * 0.5 + 0.5;
			var temp:Object;
			var i:int
			var j:int;
			
			while (inc)
			{
				for (i = inc; i < n; i++)
				{
					temp = this._source[i];
					j = i;
					while (j >= inc && 
						(((callback is Function) && 
						callback(this._source[(j - inc) >>> 0], temp)) || 
						(!(callback is Function) && 
						this._source[(j - inc) >>> 0] > temp)))
					{
						this._source[j] = this._source[int(j - inc)];
						j = j - inc;
					}
					this._source[j] = temp
				}
				inc = inc * 0.45454545454545453 + 0.5;
			}
			
			if (super.hasEventListener(SetEventType.SORT.toString()))
			{
				super.dispatchEvent(new SetEvent(SetEventType.SORT, null));
			}
		}
		
		public override function toString():String
		{
			return ("DataSet<" + 
				getQualifiedClassName(this._type) + 
				">[" + this._source.join(",") + "]");
		}
		
		/* INTERFACE org.wvxvws.data.Iterable */
		
		public function getIterator():IIterator
		{
			if (!_iterator) _iterator = new SetIterator(this);
			return _iterator;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
	}
}