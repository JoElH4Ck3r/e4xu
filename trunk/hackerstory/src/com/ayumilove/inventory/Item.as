package com.ayumilove.inventory 
{
	//{imports
	import flash.display.Sprite;
	import flash.geom.Point;
	//}
	
	/**
	* Item class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Item extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		override public function get x():Number { return _virtualItem ? _virtualItem.x : 0; }
		
		override public function set x(value:Number):void 
		{
			_virtualItem.x = value;
			super.x = value;
		}
		
		override public function get y():Number { return _virtualItem ? _virtualItem.y : 0; }
		
		override public function set y(value:Number):void 
		{
			_virtualItem.y = value;
			super.y = value;
		}
		
		public function get virtualItem():InventoryItem { return _virtualItem; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _widthRatio:int;
		protected var _heightRatio:int;
		protected var _virtualItem:InventoryItem;
		
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
		public function Item(widthRatio:int, heightRatio:int, dimensions:Point) 
		{
			super();
			_widthRatio = widthRatio;
			_heightRatio = heightRatio;
			_virtualItem = new InventoryItem(widthRatio, heightRatio, dimensions);
			draw();
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function draw():void
		{
			graphics.clear();
			graphics.lineStyle(1, 0, 1, true);
			graphics.beginFill(0xFFFF, .5);
			graphics.drawRect(0, 0, _virtualItem.width, _virtualItem.height);
			graphics.endFill();
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