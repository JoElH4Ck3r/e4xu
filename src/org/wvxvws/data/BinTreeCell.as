﻿package org.wvxvws.data 
{
	//{ imports
		
	//}
	
	/**
	 * BinTreeCell class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class BinTreeCell
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public var value:Object;
		public var left:BinTreeCell;
		public var right:BinTreeCell;
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BinTreeCell(value:Object,
						left:BinTreeCell = null, right:BinTreeCell = null) 
		{
			super();
			this.value = value;
			this.left = left;
			this.right = right;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function valueOf():Object { return this.value; }
		
		public function toString():String { return String(this.value); }
		
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