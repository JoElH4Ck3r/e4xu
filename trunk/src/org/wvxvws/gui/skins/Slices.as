package org.wvxvws.gui.skins 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * Slices class.
	 * @author wvxvw
	 */
	public class Slices extends Sprite
	{
		public static const SCALE_CLASSIC:int = 0;
		public static const SCALE_INVERTED:int = 1;
		
		public override function set width(value:Number):void 
		{
			if (_width === value || value < 0) return;
			_width = value;
			this.draw();
		}
		
		public override function set height(value:Number):void 
		{
			if (_height === value || value < 0) return;
			_height = value;
			this.draw();
		}
		
		protected var _web:Vector.<Rectangle> = 
		new <Rectangle>[new Rectangle(), new Rectangle(), new Rectangle(), 
						new Rectangle(), new Rectangle(), new Rectangle(), 
						new Rectangle(), new Rectangle(), new Rectangle()];
		protected var _webMatrix:Vector.<Matrix> = 
		new <Matrix>[	new Matrix(), new Matrix(), new Matrix(), 
						new Matrix(), new Matrix(), new Matrix(), 
						new Matrix(), new Matrix(), new Matrix()];
		protected var _bitmapData:BitmapData;
		protected var _originalWidth:uint;
		protected var _originalHeight:uint;
		protected var _leftWidth:Number;
		protected var _rightWidth:Number;
		protected var _topHeight:Number;
		protected var _bottomHeight:Number;
		protected var _width:Number;
		protected var _height:Number;
		protected var _scaleMode:int;
		
		public function Slices(bitmapData:BitmapData, 
							centralSlice:Rectangle, scaleMode:int = 0) 
		{
			super();
			_bitmapData = bitmapData;
			_width = _originalWidth = bitmapData.width;
			_height = _originalHeight = bitmapData.height;
			_scaleMode = scaleMode;
			this.rebuildWeb(centralSlice);
			this.draw();
		}
		
		protected function rebuildWeb(middle:Rectangle):void
		{
			if (middle.width > _originalWidth - 2 || middle.height > _originalHeight - 2)
				throw new RangeError("\"middle\" is to big.");
			if (middle.x < 1 || middle.y < 1)
				throw new RangeError("\"middle\" cannot be positioned in negative space.");
			_leftWidth = middle.x;
			_rightWidth = _originalWidth - (middle.width + _leftWidth);
			_web[0].width = _web[3].width = _web[6].width = _leftWidth;
			_web[2].width = _web[5].width = _web[8].width = _rightWidth;
			_web[1].width = _web[4].width = _web[7].width = middle.width;
			_topHeight = middle.y;
			_bottomHeight = _originalHeight - (middle.height + _topHeight);
			_web[0].height = _web[1].height = _web[2].height = _topHeight;
			_web[3].height = _web[4].height = _web[5].height = middle.height;
			_web[6].height = _web[7].height = _web[8].height = _bottomHeight;
		}
		
		/**
		 * 0 1 2
		 * 3 4 5
		 * 6 7 8
		 */
		protected function draw():void
		{
			var o4Width:Number = _originalWidth - (_web[0].width + _web[2].width);
			var o4Height:Number = _originalHeight - (_web[0].height + _web[6].height);
			switch (_scaleMode)
			{
				case 0:
					_web[1].width = _width - (_web[0].width + _web[2].width);
					_web[4].width = _width - (_web[0].width + _web[2].width);
					_web[7].width = _width - (_web[0].width + _web[2].width);
					
					_web[3].height = _height - (_web[0].height + _web[6].height);
					_web[4].height = _height - (_web[0].height + _web[6].height);
					_web[5].height = _height - (_web[0].height + _web[6].height);
					
					_web[1].x = _web[4].x = _web[7].x = _web[0].width;
					_web[2].x = _web[5].x = _web[8].x = _web[1].width + _web[1].x;
					
					_web[3].y = _web[4].y = _web[5].y = _web[0].height;
					_web[6].y = _web[7].y = _web[8].y = _web[3].height + _web[3].y;
					
					_webMatrix[1].a = _web[1].width / o4Width;
					_webMatrix[4].a = _web[1].width / o4Width;
					_webMatrix[7].a = _web[1].width / o4Width;
					
					_webMatrix[3].d = _web[3].height / o4Height;
					_webMatrix[4].d = _web[3].height / o4Height;
					_webMatrix[5].d = _web[3].height / o4Height;
					
					_webMatrix[1].tx = _webMatrix[4].tx = _webMatrix[7].tx = 
						_web[0].width - _web[0].width * _web[1].width / o4Width;
					_webMatrix[2].tx = _webMatrix[5].tx = _webMatrix[8].tx = 
						(_width - (_web[0].width + _web[2].width)) - 
						(_originalWidth - (_web[0].width + _web[2].width));
					
					_webMatrix[3].ty = _webMatrix[4].ty = _webMatrix[5].ty = 
						_web[0].height - _web[0].height * _web[3].height / o4Height;
					
					_webMatrix[6].ty = _webMatrix[7].ty = _webMatrix[8].ty = 
						(_height - (_web[0].height + _web[6].height)) - 
						(_originalHeight - (_web[0].height + _web[6].height));
					break;
				case 1:
					
					break;
			}
			var g:Graphics = super.graphics;
			var i:int;
			var j:int = 9;
			g.clear();
			while (i < j)
			{
				trace(_web[i], _webMatrix[i]);
				g.lineStyle(1, 0xFF);
				g.beginBitmapFill(_bitmapData, _webMatrix[i], false, true);
				//g.beginFill(Math.random() * 0xFFFFFF, 0.5);
				g.drawRect(_web[i].x, _web[i].y, _web[i].width, _web[i].height);
				g.endFill();
				i++;
			}
		}
	}
	
}