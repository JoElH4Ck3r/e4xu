package org.wvxvws.gui 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	//}
	
	/**
	* ScrollerHandle class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class ScrollerHandle extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		override public function get scaleX():Number { return _scaleX; }
		
		override public function set scaleX(value:Number):void 
		{
			_scaleX = value;
			_width = _nativeWidth * _scaleX;
		}
		
		override public function get scaleY():Number { return _scaleY; }
		
		override public function set scaleY(value:Number):void 
		{
			_scaleY = value;
			_height = _nativeHeight * _scaleY;
		}
		
		override public function get width():Number { return _width; }
		
		override public function set width(value:Number):void 
		{
			if (_width == value >> 0) return;
			_width = value >> 0;
			_scaleX = _width / _nativeWidth;
			draw();
		}
		
		override public function get height():Number { return _height; }
		
		override public function set height(value:Number):void 
		{
			if (_height == value >> 0) return;
			_height = value >> 0;
			_scaleX = _height / _nativeHeight;
			draw();
		}
		
		override public function get rotation():Number { return _rotation; }
		
		override public function set rotation(value:Number):void 
		{
			_rotation = ((value / 90) >> 0) * 90;
			_direction = !Boolean(_rotation % 180);
			draw();
		}
		
		public function get minFactory():Function { return _minFactory; }
		
		public function set minFactory(value:Function):void 
		{
			if (value === _minFactory) return;
			_minFactory = value;
			_needRedraw = true;
			draw();
		}
		
		public function get maxFactory():Function { return _maxFactory; }
		
		public function set maxFactory(value:Function):void 
		{
			if (value === _maxFactory) return;
			_maxFactory = value;
			_needRedraw = true;
			draw();
		}
		
		public function get middleFactory():Function { return _middleFactory; }
		
		public function set middleFactory(value:Function):void 
		{
			if (value === _middleFactory) return;
			_middleFactory = value;
			_needRedraw = true;
			draw();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _min:DisplayObject;
		protected var _max:DisplayObject;
		protected var _middle:DisplayObject;
		protected var _rotation:int;
		protected var _direction:Boolean = true;
		protected var _height:int;
		protected var _width:int;
		protected var _scaleX:Number;
		protected var _scaleY:Number;
		protected var _nativeWidth:int;
		protected var _nativeHeight:int;
		
		protected var _minFactory:Function = defaultFactory;
		protected var _maxFactory:Function = defaultFactory;
		protected var _middleFactory:Function = defaultFactory;
		
		protected var _needRedraw:Boolean = true;
		
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
		
		public function ScrollerHandle()
		{
			super();
			draw();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function draw():void
		{
			if (_needRedraw)
			{
				if (_min && contains(_min)) removeChild(_min);
				if (_max && contains(_max)) removeChild(_max);
				if (_middle && contains(_middle)) removeChild(_middle);
				_min = _minFactory() as DisplayObject; 
				_max = _maxFactory() as DisplayObject; 
				_middle = _middleFactory() as DisplayObject; 
				addChild(_min);
				addChild(_max);
				addChild(_middle);
				_nativeWidth = _width = _min.width;
				_nativeHeight = _height = _min.height + _middle.height + _max.height;
				_needRedraw = false;
			}
			if (_direction)
			{
				_middle.y = _min.height >> 0;
				_middle.height = 1 + (_height - (_min.height + _max.height)) >> 0;
				_max.y = (_middle.height + _middle.y) >> 0;
			}
			else
			{
				_min.rotation = _rotation;
				_middle.rotation = _rotation;
				_max.rotation = _rotation;
				
				_middle.x = _min.width >> 0;
				_middle.height = 1 + (_height - (_min.height + _max.height)) >> 0;
				_middle.scaleY = (1 + (_height - (_min.height + _max.height)) >> 0) / 
									_middle.getBounds(_middle).height
				_middle.scaleX = 1;
				_middle.y = _min.y;
				_middle.x = _min.width;
				_max.x = (_middle.width + _middle.x) >> 0;
				_max.y = _middle.y = 0;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function defaultFactory():Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0);
			s.graphics.drawRect(0, 0, 20, 10);
			s.graphics.endFill();
			return s;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}