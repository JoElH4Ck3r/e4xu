////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) Oleg Sivokon email: olegsivokon@gmail.com
//  
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//  Or visit http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
//
////////////////////////////////////////////////////////////////////////////////

package org.wvxvws.geometry 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	/**
	 * DrawUtils class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.12.36
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