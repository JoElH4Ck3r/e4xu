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
			if (this._width === value || value < 0) return;
			this._width = value;
			this.draw();
		}
		
		public override function set height(value:Number):void 
		{
			if (_height === value || value < 0) return;
			this._height = value;
			this.draw();
		}
		
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
		
		protected var _web0:Rectangle = new Rectangle();
		protected var _web1:Rectangle = new Rectangle();
		protected var _web2:Rectangle = new Rectangle();
		protected var _web3:Rectangle = new Rectangle();
		protected var _web4:Rectangle = new Rectangle();
		protected var _web5:Rectangle = new Rectangle();
		protected var _web6:Rectangle = new Rectangle();
		protected var _web7:Rectangle = new Rectangle();
		protected var _web8:Rectangle = new Rectangle();
		
		protected var _webMatrix0:Matrix = new Matrix();
		protected var _webMatrix1:Matrix = new Matrix();
		protected var _webMatrix2:Matrix = new Matrix();
		protected var _webMatrix3:Matrix = new Matrix();
		protected var _webMatrix4:Matrix = new Matrix();
		protected var _webMatrix5:Matrix = new Matrix();
		protected var _webMatrix6:Matrix = new Matrix();
		protected var _webMatrix7:Matrix = new Matrix();
		protected var _webMatrix8:Matrix = new Matrix();
		
		public function Slices(bitmapData:BitmapData, 
							centralSlice:Rectangle, scaleMode:int = 0) 
		{
			super();
			_bitmapData = bitmapData;
			this._width = this._originalWidth = bitmapData.width;
			_height = this._originalHeight = bitmapData.height;
			_scaleMode = scaleMode;
			this.rebuildWeb(centralSlice);
			this.draw();
		}
		
		protected function rebuildWeb(middle:Rectangle):void
		{
			if (middle.width > this._originalWidth - 2 || 
				middle.height > this._originalHeight - 2)
				throw new RangeError("\"middle\" is to big.");
			if (middle.x < 1 || middle.y < 1)
				throw new RangeError("\"middle\" cannot be positioned in negative space.");
			this._leftWidth = middle.x;
			this._rightWidth = this._originalWidth - (middle.width + this._leftWidth);
			this._web0.width = this._web3.width = this._web6.width = this._leftWidth;
			this._web2.width = this._web5.width = this._web8.width = this._rightWidth;
			this._web1.width = this._web4.width = this._web7.width = middle.width;
			this._topHeight = middle.y;
			this._bottomHeight = this._originalHeight - (middle.height + this._topHeight);
			this._web0.height = this._web1.height = this._web2.height = this._topHeight;
			this._web3.height = this._web4.height = this._web5.height = middle.height;
			this._web6.height = this._web7.height = this._web8.height = this._bottomHeight;
		}
		
		// TODO: inverse grid
		/**
		 * 0 1 2
		 * 3 4 5
		 * 6 7 8
		 */
		protected function draw():void
		{
			var o4Width:Number = this._originalWidth - (this._web0.width + this._web2.width);
			var o4Height:Number = this._originalHeight - (this._web0.height + this._web6.height);
			
			var m4Width:Number = this._width - (this._web0.width + this._web2.width);
			var m4Height:Number = _height - (this._web0.height + this._web6.height);
			
			var a:Number;
			var d:Number;
			
			var g:Graphics = super.graphics;
			
			switch (_scaleMode)
			{
				case 0:
					this._web1.width = this._web4.width = this._web7.width = m4Width;
					this._web3.height = this._web4.height = this._web5.height = m4Height;
					
					a = this._web1.width / o4Width;
					d = this._web3.height / o4Height;
					
					this._web1.x = this._web4.x = this._web7.x = this._web0.width;
					this._web2.x = this._web5.x = this._web8.x = this._web1.width + this._web1.x;
					
					this._web3.y = this._web4.y = this._web5.y = this._web0.height;
					this._web6.y = this._web7.y = this._web8.y = this._web3.height + this._web3.y;
					
					this._webMatrix1.a = this._webMatrix4.a = this._webMatrix7.a = a;
					this._webMatrix3.d = this._webMatrix4.d = this._webMatrix5.d = d;
					
					this._webMatrix1.tx = this._webMatrix4.tx = this._webMatrix7.tx = 
						this._web0.width - this._web0.width * this._web1.width / o4Width;
					
					o4Width = this._web0.width + this._web2.width;
					this._webMatrix2.tx = this._webMatrix5.tx = this._webMatrix8.tx = 
						(this._width - o4Width) - (this._originalWidth - o4Width);
					
					this._webMatrix3.ty = this._webMatrix4.ty = this._webMatrix5.ty = 
						this._web0.height - this._web0.height * this._web3.height / o4Height;
					
					o4Height = this._web0.height + this._web6.height;
					this._webMatrix6.ty = this._webMatrix7.ty = this._webMatrix8.ty = 
						(this._height - o4Height) - (this._originalHeight - o4Height);
					break;
				case 1:
					
					break;
			}
			g.clear();
			g.beginBitmapFill(this._bitmapData, this._webMatrix0, false, true);
			g.drawRect(this._web0.x, this._web0.y, this._web0.width, this._web0.height);
			g.beginBitmapFill(this._bitmapData, this._webMatrix1, false, true);
			g.drawRect(this._web1.x, this._web1.y, this._web1.width, this._web1.height);
			g.beginBitmapFill(this._bitmapData, this._webMatrix2, false, true);
			g.drawRect(this._web2.x, this._web2.y, this._web2.width, this._web2.height);
			g.beginBitmapFill(this._bitmapData, this._webMatrix3, false, true);
			g.drawRect(this._web3.x, this._web3.y, this._web3.width, this._web3.height);
			g.beginBitmapFill(this._bitmapData, this._webMatrix4, false, true);
			g.drawRect(this._web4.x, this._web4.y, this._web4.width, this._web4.height);
			g.beginBitmapFill(this._bitmapData, this._webMatrix5, false, true);
			g.drawRect(this._web5.x, this._web5.y, this._web5.width, this._web5.height);
			g.beginBitmapFill(this._bitmapData, this._webMatrix6, false, true);
			g.drawRect(this._web6.x, this._web6.y, this._web6.width, this._web6.height);
			g.beginBitmapFill(this._bitmapData, this._webMatrix7, false, true);
			g.drawRect(this._web7.x, this._web7.y, this._web7.width, this._web7.height);
			g.beginBitmapFill(this._bitmapData, this._webMatrix8, false, true);
			g.drawRect(this._web8.x, this._web8.y, this._web8.width, this._web8.height);
			g.endFill();
		}
	}
	
}