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

package org.wvxvws.gui.skins 
{
	//{imports
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	//}
	
	/**
	* SkinFactory class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Drawings 
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
		
		private static var _gradientBitmapData:BitmapData;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Drawings() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
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
		
		public static function drawRoundedCorners(g:Graphics, rx:int, ry:int,
							top:int, left:int, w:int, h:int, flags:uint):void
		{
			rx = rx > w >> 1 ? w >> 1 : rx;
			ry = ry > h >> 1 ? h >> 1 : ry;
			flags = flags > 15 ? 15 : flags;
			if (flags % 2) g.moveTo(left + rx, top); // LT
			else g.moveTo(left, top);
			if ((12 | flags) >> 1 == 7) // RT
			{
				g.lineTo(left + w - rx, top);
				g.curveTo(left + w, top, left + w, top + ry);
			}
			else g.lineTo(left + w, top);
			if ((8 | flags) >> 2 == 3) // RB
			{
				g.lineTo(left + w, top + h - ry);
				g.curveTo(left + w, top + h, left + w - rx, top + h);
			}
			else g.lineTo(left + w, top + h);
			if (flags > 7) // LB
			{
				g.lineTo(left + rx, top + h);
				g.curveTo(left, top + h, left, top + h - ry);
			}
			else g.lineTo(left, top + h);
			if (flags % 2) // LT
			{
				g.lineTo(left, top + ry);
				g.curveTo(left, top, left + rx, top);
			}
			else g.lineTo(left, top);
		}
		
		public static function drawPolygon(g:Graphics, rx:int, ry:int, top:int, 
				left:int, segments:uint, isStar:Boolean = false, delta:int = 0):void
		{
			
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