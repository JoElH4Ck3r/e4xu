package org.wvxvws.data 
{
	//{ imports
	import flash.events.EventDispatcher;
	import mx.core.IMXMLObject;
	//}
	
	/**
	 * DataTree class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class DataTree extends EventDispatcher implements IMXMLObject, Iterable
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get length():uint
		{
			if (this._children) return this._children.length;
			return 0;
		}
		
		public function get id():String { return this._id; }
		
		public function get value():Object { return this._value; }
		
		public function set value(value:Object):void 
		{
			if (this._value === value) return;
			this._value = value;
			if (super.hasEventListener(SetEventType.CHANGE.toString()))
				super.dispatchEvent(new SetEvent(SetEventType.CHANGE));
		}
		
		public function get children():Vector.<DataTree> { return this._children; }
		
		public function get descendants():Vector.<DataTree>
		{
			var ret:Vector.<DataTree>;
			var desc:Vector.<DataTree>;
			for each (var dt:DataTree in this._children)
			{
				if (!ret) ret = new <DataTree>[];
				desc = dt.descendants;
				if (desc) ret = ret.concat(desc);
			}
			return ret;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _value:Object;
		protected var _children:Vector.<DataTree>;
		protected var _type:Class;
		protected var _id:String;
		protected var _iterator:TreeIterator;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DataTree(type:Class) 
		{
			super();
			this._type = type;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function add(item:Object, index:int = -1):void
		{
			if (!(item is this._type) && !(item is Vector.<DataTree>)) return;
			if (!this._children) this._children = new <DataTree>[];
			var dt:DataTree = new DataTree(this._type);
			if (item is this._type) dt._value = item;
			else dt._children = item as Vector.<DataTree>;
			if (index < 0) this._children.push(dt);
			else this._children.splice(index, 0, dt);
			if (super.hasEventListener(SetEventType.ADD.toString()))
			{
				super.dispatchEvent(new SetEvent(SetEventType.ADD, item, index));
			}
		}
		
		public function put(item:Object, index:int):void
		{
			if (!(item is this._type) && !(item is Vector.<DataTree>)) return;
			if (!this._children) this._children = new <DataTree>[];
			var dt:DataTree = new DataTree(this._type);
			if (item is this._type) dt._value = item;
			else dt._children = item as Vector.<DataTree>;
			this._children[index] = dt;
			if (super.hasEventListener(SetEventType.CHANGE.toString()))
			{
				super.dispatchEvent(new SetEvent(SetEventType.CHANGE, item, index));
			}
		}
		
		public function remove(item:Object):void
		{
			if (!this._children) return;
			var i:int = this.indexOf(item);
			this._children.splice(i, 1);
			if (super.hasEventListener(SetEventType.REMOVE.toString()))
			{
				super.dispatchEvent(new SetEvent(SetEventType.REMOVE, item, i));
			}
		}
		
		public function at(index:int):Object { return this._children[index]._value; }
		
		public function indexOf(item:Object):int
		{
			if (!this._children || 
				!this._children.length || !(item is this._type))
				return -1;
			var len:int = this._children.length;
			for (var i:int; i < len; i++)
			{
				if (this._children[i]._value === item) return i;
			}
			return -1;
		}
		
		public function valueOf():Object
		{
			if (this._children) return this._children;
			return this._value;
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			this._id = id;
		}
		
		/* INTERFACE org.wvxvws.data.Iterable */
		
		public function getIterator():IIterator
		{
			if (!this._iterator) this._iterator = new TreeIterator(this);
			return this._iterator;
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