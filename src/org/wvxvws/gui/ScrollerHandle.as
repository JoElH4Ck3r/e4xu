package org.wvxvws.gui 
{
	//{imports
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
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _min:Sprite = new HandleRefAST() as Sprite;
		protected var _max:Sprite = new HandleAST() as Sprite;
		protected var _middle:Sprite = new HandleBodyAST() as Sprite;
		protected var _rotation:int;
		protected var _direction:Boolean = true;
		protected var _height:int;
		protected var _width:int;
		protected var _scaleX:Number;
		protected var _scaleY:Number;
		protected var _nativeWidth:int;
		protected var _nativeHeight:int;
		
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
			addChild(_min);
			addChild(_max);
			addChild(_middle);
			_nativeWidth = _width = _min.width;
			_nativeHeight = _height = _min.height + _middle.height + _max.height;
			//trace(_min.height, _middle.height, _max.height);
			draw();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function draw():void
		{
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
				//_middle.height = _width;
				_middle.height = 1 + (_height - (_min.height + _max.height)) >> 0;
				//(_height - (_min.width + _max.width)) >> 0;
				_middle.scaleX = 1;
				_middle.y = _min.y;
				_middle.x = _min.width;
				_max.x = (_middle.width + _middle.x) >> 0;
				_max.y = _middle.y = 0;
				//trace("_middle.height, _middle.width", _middle.height, _width, _middle.width, _middle.rotation, _middle.scaleX, _middle.scaleY);
			}
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