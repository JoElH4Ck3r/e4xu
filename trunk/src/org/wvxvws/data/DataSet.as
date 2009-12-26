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
	
	[Event(name="add", type="org.wvxvws.data.SetEvent")]
	[Event(name="change", type="org.wvxvws.data.SetEvent")]
	[Event(name="remove", type="org.wvxvws.data.SetEvent")]
	[Event(name="sort", type="org.wvxvws.data.SetEvent")]
	
	/**
	 * DataSet class.
	 * @author wvxvw
	 */
	public class DataSet extends EventDispatcher
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
			from.*.(ds.add(valueOf()));
			return ds;
		}
		
		public static function fromXMLList(from:XMLList):DataSet
		{
			var ds:DataSet = new DataSet(XML);
			from.(ds.add(valueOf()));
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
			var type:Class;
			var ts:String = describeType(from).@name;
			if (ts.indexOf("::Vector") < 0)
				throw new ArgumentError(from + " must be Vector.");
			ts = ts.replace(/.*<(.*)>.*/g, "$1");
			type = getDefinitionByName(ts) as Class;
			var ds:DataSet = new DataSet(type);
			for each (var o:Object in from) ds.add(o);
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
			if (super.hasEventListener(SetEvent.ADD))
			{
				super.dispatchEvent(new SetEvent(SetEvent.ADD, item, index));
			}
		}
		
		public function put(item:Object, index:int):void
		{
			_source[index] = item;
			if (super.hasEventListener(SetEvent.CHANGE))
			{
				super.dispatchEvent(new SetEvent(SetEvent.CHANGE, item, index));
			}
		}
		
		public function remove(item:Object):void
		{
			var i:int = this._source.indexOf(item);
			this._source.splice(i, 1);
			if (super.hasEventListener(SetEvent.REMOVE))
			{
				super.dispatchEvent(new SetEvent(SetEvent.REMOVE, item, i));
			}
		}
		
		public function at(index:int):Object { return this._source[index]; }
		
		public function clone():DataSet
		{
			var ds:DataSet = new DataSet(this._type);
			for each (var o:Object in this._source) ds.add(o);
			return ds;
		}
		
		public function sort(on:Function):void
		{
			this._source.sort(on);
			if (super.hasEventListener(SetEvent.SORT))
			{
				super.dispatchEvent(new SetEvent(SetEvent.SORT, null));
			}
		}
		
		public override function toString():String
		{
			return ("DataSet<" + 
				getQualifiedClassName(this._type) + 
				">[" + this._source.join(",") + "]");
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
	}
}