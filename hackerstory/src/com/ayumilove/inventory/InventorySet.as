package com.ayumilove.inventory 
{
	//{imports
	import flash.geom.Point;
	//}
	
	/**
	* InventorySet class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class InventorySet extends Array
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get width():int { return _width; }
		
		public function get height():int { return _height; }
		
		public function get cellSize():Point { return _cellSize; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _width:int;
		protected var _height:int;
		protected var _cellSize:Point;
		protected var _pointer:int;
		
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
		
		public function InventorySet(width:int, height:int, cellSize:Point)
		{
			super();
			_width = width;
			_height = height;
			_cellSize = cellSize;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function addCell(cell:InventoryCell, positionX:int = 0, positionY:int = 0):InventoryCell
		{
			var pos:int = positionY * _width + positionX;
			if (!super[pos])
			{
				super[pos] = cell;
			}
			else
			{
				while (super[pos]) pos++;
				if (pos > width * height)
				{
					throw new Error("Inventory full");
				}
				super[pos] = cell;
			}
			cell.x = positionX * cellSize.x;
			cell.y = positionY * cellSize.y;
			cell.width = cellSize.x;
			cell.height = cellSize.y;
			return super[pos];
		}
		
		public function getNext():InventoryCell
		{
			if (_pointer < super.length -1)
			{
				_pointer++;
				return super[_pointer];
			}
			_pointer = 0;
			return null;
		}
		
		public function findSpace():InventoryCell
		{
			return null;
		}
		
		public function findSpaceAt(cell:InventoryCell):InventoryCell
		{
			return null;
		}
		
		public function findSpaceAtPoint(point:Point):InventoryCell
		{
			return null;
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