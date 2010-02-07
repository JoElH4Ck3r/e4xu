﻿package org.wvxvws.data 
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
		
		public var rule:Function;
		
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
		
		public function DataBinTree(type:Class, 
			head:BinTreeCell, rule:Function/*Object->Object->Boolean*/ = null) 
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
			
			if (this.rule is Function)
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
			}
			else
			{
				for (o in this._leafs)
				{
					leaf = o as BinTreeCell;
					break;
				}
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