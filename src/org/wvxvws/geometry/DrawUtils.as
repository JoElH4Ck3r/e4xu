package org.wvxvws.geometry 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class DrawUtils 
	{
		private static var _gradientBitmapData:BitmapData;
		
		public function DrawUtils() { super(); }
		
		public static function conicalGradient(graphics:Graphics, 
					x:Number, y:Number, radius:Number,
					ratios:Vector.<uint> = null, colors:Vector.<uint> = null):void
		{
			var sector:Shape = drawSector(radius * 0.5, radius * Math.sin(Math.PI / 180));
			var angles:int = 360;
			var transform:ColorTransform = new ColorTransform();
			var red:uint;
			var green:uint;
			var blue:uint;
			if (_gradientBitmapData) _gradientBitmapData.dispose();
			_gradientBitmapData = 
				new BitmapData(radius * 2, radius * 2 , true, 0xFF000000);
			var m:Matrix = new Matrix();
			var color:uint;
			while (angles--)
			{
				sector.rotation = angles;
				m = sector.transform.matrix.clone();
				m.translate(radius * 0.5, radius * 0.5);
				if (angles > 240) red = 0;
				else 
				{
					if (angles > 120) red = (120 - (angles % 120)) * 0xFF / 120;
					else red = angles * 0xFF / 120;
				}
				if (angles < 120) green = 0;
				else
				{
					if (angles > 240) green = (120 - ((angles - 120) % 120)) * 0xFF / 120;
					else green = (angles - 120) * 0xFF / 120;
				}
				if (angles < 240 && angles > 120) blue = 0;
				else
				{
					if (angles >= 240) blue = (angles - 240) * 0xFF / 120;
					else blue = (120 - angles) * 0xFF / 120;
				}
				color = (red << 16) | (green << 8) | blue;
				transform.color = color;
				_gradientBitmapData.draw(sector, m, transform);// , BlendMode.ADD);
			}
			m = new Matrix();
			m.translate(radius * -0.5, radius * -0.5);
			graphics.beginBitmapFill(_gradientBitmapData, m);
			graphics.drawCircle(x, y, radius * 0.5);
			graphics.endFill();
		}
		
		private static function drawSector(len:int, base:Number):Shape
		{
			var s:Shape = new Shape();
			var g:Graphics = s.graphics;
			g.beginFill(0, 1);
			g.lineTo(len, base * -0.5);
			g.lineTo(len, base * 0.5);
			g.lineTo(0, 0);
			g.endFill();
			return s;
		}
	}
	
}