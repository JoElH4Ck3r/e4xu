package org.wvxvws.gui.skins 
{
	//{imports
	import flash.display.Graphics;
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
		
		public static function drawPolyline(g:Graphics, points:Array /* of Point */):void
		{
			
		}
		
		public static function drawSector(g:Graphics, r:int, angleA:Number, 
												angleB:Number, top:int, left:int):void
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