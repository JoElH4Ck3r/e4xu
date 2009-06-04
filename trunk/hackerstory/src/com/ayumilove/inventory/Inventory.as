package com.ayumilove.inventory 
{
	//{imports
	import flash.display.Sprite;
	import flash.geom.Point;
	//}
	
	/**
	* Inventory class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Inventory extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _virualInventory:InventoryMap = new InventoryMap(10, 10, new Point(50, 50));
		protected var _map:Array = [];
		
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
		
		public function Inventory()
		{
			super();
			var c:Cell;
			var ic:InventoryCell;
			for (var obj:Object in _virualInventory)
			{
				ic = obj as InventoryCell;
				c = new Cell(ic.width, ic.height);
				c.x = ic.x;
				c.y = ic.y;
				_map[_virualInventory[ic]] = c;
				addChild(c);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function fit(item:Item):InventoryCell
		{
			var c:InventoryCell = _virualInventory.findSpaceAtPoint(item.virtualItem);
			if (!c) return null;
			for (var ic:Object in _virualInventory)
			{
				if ((ic as InventoryCell).filled)
				{
					(_map[_virualInventory[ic]] as Cell).filled = true;
				}
			}
			return c;
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