package  
{
	//{imports
	import com.ayumilove.inventory.Item;
	import com.ayumilove.inventory.ICell;
	import com.ayumilove.inventory.Inventory;
	import com.ayumilove.inventory.InventoryCell;
	import com.ayumilove.inventory.InventoryMap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	//}
	
	/**
	* TestInventory class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class TestInventory extends Sprite
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
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _inventory:Inventory = new Inventory();
		private var _p:Point = new Point(50, 50);
		private var _item:Item;
		private var _shifX:Number;
		private var _shifY:Number;
		private var _lastX:int;
		private var _lastY:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function TestInventory() 
		{
			super();
			addChild(_inventory);
			_item = generateRandomItem();
			_item.addEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
			addChild(_item);
		}
		
		private function item_mouseDownHandler(event:MouseEvent):void 
		{
			_shifX = _item.mouseX;
			_shifY = _item.mouseY;
			_lastX = _item.x;
			_lastY = _item.y;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		private function stage_mouseUpHandler(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			var ic:InventoryCell = _inventory.fit(_item);
			if (ic)
			{
				_item.x = ic.x;
				_item.y = ic.y;
				_item.removeEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
				_item = generateRandomItem();
				addChild(_item);
				_item.addEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
			}
			else
			{
				_item.x = _lastX;
				_item.y = _lastY;
			}
		}
		
		private function stage_mouseMoveHandler(event:MouseEvent):void 
		{
			_item.x = mouseX - _shifX;
			_item.y = mouseY - _shifY;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function generateRandomItem():Item
		{
			var i:Item = new Item( 1 + (Math.random() * 4) >> 0, 1 + (Math.random() * 4) >> 0, _p);
			i.x = 520;
			return i;
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