package inventory 
{
	//{imports
	import flash.display.Shape;
	//}
	
	/**
	* Cell class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Cell extends Shape implements ICell
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
		
		protected var _filled:Boolean;
		protected var _width:int;
		protected var _height:int;
		
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
		public function Cell(width:int, height:int) 
		{
			super();
			_width = width;
			_height = height;
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
			if (_filled) graphics.beginFill(0, .5);
			else graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
		
		public function get filled():Boolean { return _filled; }
		
		public function set filled(value:Boolean):void 
		{
			_filled = value;
			draw();
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