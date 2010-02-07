package org.wvxvws.data 
{
	import flash.utils.Dictionary;
	//{ imports
		
	//}
	
	/**
	 * DataBinTree class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class DataBinTree implements Iterable
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public var rule:Function/*Null<Object>->Null<Object>->Boolean*/;
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _type:Class;
		protected var _leafs:Dictionary = new Dictionary();
		protected var _head:BinTreeCell;
		
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
		
		public function DataBinTree(type:Class, head:BinTreeCell, 
			rule:Function/*Null<Object>->Null<Object>->Boolean*/ = null) 
		{
			super();
			this._type = type;
			this.rule = rule;
			this._head = head;
			this._leafs[head] = true;
		}
		
		/* INTERFACE org.wvxvws.data.Iterable */
		
		public function getIterator():IIterator
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function add(item:Object):void
		{
			var leaf:BinTreeCell;
			var o:Object;
			var l:BinTreeCell;
			var r:BinTreeCell;
			
			if (this.rule is Function) // sorted
			{
				for (o in this._leafs)
				{
					if (!leaf) leaf = o as BinTreeCell;
					else
					{
						if (this.rule(leaf.value, (o as BinTreeCell).value))
							leaf = o;
					}
				}
				l = leaf.left;
				r = leaf.right;
				if (l == r) // both are null, add to left
				{
					leaf.left = new BinTreeCell(item);
					this._leafs[leaf] = false;
				}
				else if (!l)
				{
					if (this.rule(null, item))
						leaf.left = new BinTreeCell(item);
					else
					{
						o = leaf.right;
						leaf.right = new BinTreeCell(item);
						leaf.left = o;
					}
					delete this._leafs[leaf];
				}
				else
				{
					if (this.rule(item, null))
						leaf.right = new BinTreeCell(item);
					else
					{
						o = leaf.left;
						leaf.left = new BinTreeCell(item);
						leaf.right = o;
					}
					delete this._leafs[leaf];
				}
			}
			else // unsorted
			{
				for (o in this._leafs)
				{
					leaf = o as BinTreeCell;
					break;
				}
				if (this._leafs[leaf]) // left
				{
					leaf.left = new BinTreeCell(item);
					this._leafs[leaf.left] = true;
					this._leafs[leaf] = false;
				}
				else // right
				{
					leaf.right = new BinTreeCell(item);
					this._leafs[leaf.right] = true;
					delete this._leafs[leaf];
				}
			}
		}
		
		public function remove(item:Object):void
		{
			
		}
		
		public function at(index:int):Object
		{
			return null;
		}
		
		public function clone():DataSet
		{
			
		}
		
		public function bubbleSort(callback:Function = null):void
		{
			
		}
		
		public function sort(callback:Function = null):void
		{
			
		}
		
		public override function toString():String
		{
			return ("DataBinTree<" + 
				getQualifiedClassName(this._type) + 
				">[" +  "]");
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