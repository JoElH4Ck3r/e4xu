package inventory 
{
	//{imports
	import flash.geom.Point;
	import flash.utils.Dictionary;
	//}
	
	/**
	* InventoryMap class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class InventoryMap extends Dictionary
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
		
		public function InventoryMap(width:int, height:int, cellSize:Point)
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
		
		public function getItem(key:String):InventoryCell
		{
			for (var obj:Object in this)
			{
				if (this[obj] === key) return obj as InventoryCell;
			}
			return null;
		}
		
		public function hasKey(key:String):Boolean
		{
			for (var obj:Object in this)
			{
				if (this[obj] === key) return true;
			}
			return false;
		}
		
		public function hasNumKey(key:int):Boolean
		{
			for (var obj:Object in this)
			{
				if (this[obj] === key) return true;
			}
			return false;
		}
		
		public function getItemNum(key:int):InventoryCell
		{
			for (var obj:Object in this)
			{
				if (this[obj] === key) return obj as InventoryCell;
			}
			return null;
		}
		
		public function addCell(cell:InventoryCell, positionX:int = 0, positionY:int = 0):InventoryCell
		{
			var pos:int = positionY * _width + positionX;
			while (hasNumKey(pos))
			{
				pos++;
				positionX = pos % _width;
				positionY = (pos / _height) >> 0;
				if (pos > width * height) throw new Error("Inventory full.");
			}
			this[cell] = pos;
			cell.x = positionX * cellSize.x;
			cell.y = positionY * cellSize.y;
			cell.width = cellSize.x;
			cell.height = cellSize.y;
			return cell;
		}
		
		public function getNextNum():InventoryCell
		{
			_pointer++;
			if (hasNumKey(_pointer))
			{
				return getItemNum(_pointer) as InventoryCell;
			}
			_pointer = 0;
			return null;
		}
		
		public function getNextKey():InventoryCell
		{
			_pointer++;
			if (hasKey(_pointer.toString()))
			{
				return getItem(_pointer.toString()) as InventoryCell;
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