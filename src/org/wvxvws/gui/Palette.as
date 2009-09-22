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

package org.wvxvws.gui 
{
	//{ imports
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.wvxvws.geometry.DrawUtils;
	//}
	
	/**
	 * Palette class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.12.36
	 */
	public class Palette extends DIV
	{
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _black:Shape;
		protected var _colorA:Shape;
		protected var _colorB:Shape;
		protected var _mask:Shape;
		protected var _composite:Sprite;
		protected var _colorCircle:Sprite;
		protected var _selectedColorA:uint = 0xFF00;
		protected var _selectedColorB:uint = 0xFF;
		protected var _grayComponent:Number = 0;
		protected var _innerCircle:Sprite;
		protected var _outerCircle:Sprite;
		protected var _rotateTarget:Sprite;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Palette() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function getColorAt(point:Point):uint
		{
			
			return 0;
		}
		
		public override function validate(properties:Object):void 
		{
			super.validate(properties);
			if (_colorCircle && super.contains(_colorCircle))
				super.removeChild(_colorCircle);
			if (!_colorCircle) 
				_colorCircle = super.addChild(new Sprite()) as Sprite;
			DrawUtils.conicalGradient(_colorCircle.graphics, 0, 0, 
										Math.max(super.width, super.height));
			_colorCircle.x = super.width * 0.5;
			_colorCircle.y = super.height * 0.5;
			drawCircleMask();
			if (_composite && super.contains(_composite))
				super.removeChild(_composite);
			if (!_composite) _composite = super.addChild(new Sprite()) as Sprite;
			drawTriangle();
			_composite.x = super.width >> 1;
			_composite.y = super.height >> 1;
			drawInOutCircles();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function drawCircleMask():void
		{
			if (_mask && super.contains(_mask)) super.removeChild(_mask);
			_mask = new Shape();
			var g:Graphics = _mask.graphics;
			var rad:int = Math.max(super.width, super.height) * 0.5;
			g.beginFill(0xFFFFFF, 1);
			g.drawCircle(super.width * 0.5, super.height * 0.5, rad);
			g.drawCircle(super.width * 0.5, super.height * 0.5, rad - 15);
			g.endFill();
			_mask.cacheAsBitmap = true;
			_colorCircle.cacheAsBitmap = true;
			super.addChild(_mask);
			_colorCircle.mask = _mask;
		}
		
		protected function drawTriangle():void
		{
			var mid:int = Math.max(super.width, super.height) * 0.5;
			var rad:int = mid - 20;
			if (_black && _composite.contains(_black)) 
				_composite.removeChild(_black);
			if (_colorA && _composite.contains(_colorA)) 
				_composite.removeChild(_colorA);
			if (_colorB && _composite.contains(_colorB)) 
				_composite.removeChild(_colorB);
			_black = _composite.addChild(new Shape()) as Shape;
			_colorA = _composite.addChild(new Shape()) as Shape;
			_colorB = _composite.addChild(new Shape()) as Shape;
			var blackM:Matrix = new Matrix();
			blackM.createGradientBox(rad * 2 * Math.cos(Math.PI / 3), 
								rad * 2 * Math.cos(Math.PI / 3), 
								Math.PI / 2, 0, rad * -1 * Math.cos(Math.PI / 3));
			var i:int = 3;
			_black.graphics.beginFill(_grayComponent);
			_colorA.graphics.beginGradientFill(GradientType.LINEAR, 
								[0, _selectedColorA], [0, 1], [0, 0xFF], blackM);
			_colorB.graphics.beginGradientFill(GradientType.LINEAR, 
								[0, _selectedColorB], [0, 1], [0, 0xFF], blackM);
			var angle:Number = (Math.PI * 2 / 3) * i;
			var deg60:Number = Math.PI * 7 / 6;
			_black.graphics.moveTo(rad * Math.cos(deg60 + angle), 
									rad * Math.sin(deg60 + angle));
			_colorA.graphics.moveTo(rad * Math.cos(deg60 + angle), 
									rad * Math.sin(deg60 + angle));
			_colorB.graphics.moveTo(rad * Math.cos(deg60 + angle), 
									rad * Math.sin(deg60 + angle));
			while (i)
			{
				angle = (Math.PI * 2 / 3) * i;
				_black.graphics.lineTo(rad * Math.cos(deg60 + angle), 
										rad * Math.sin(deg60 + angle));
				_colorA.graphics.lineTo(rad * Math.cos(deg60 + angle), 
										rad * Math.sin(deg60 + angle));
				_colorB.graphics.lineTo(rad * Math.cos(deg60 + angle), 
										rad * Math.sin(deg60 + angle));
				i--;
			}
			_black.graphics.endFill();
			_colorA.graphics.endFill();
			_colorB.graphics.endFill();
			_colorA.blendMode = BlendMode.ADD;
			_colorB.blendMode = BlendMode.ADD;
			_colorA.rotation = 120;
			_colorB.rotation = 240;
		}
		
		protected function drawInOutCircles():void
		{
			if (_innerCircle && super.contains(_innerCircle))
				super.removeChild(_innerCircle);
			if (_outerCircle && super.contains(_outerCircle))
				super.removeChild(_outerCircle);
			_innerCircle = super.addChild(new Sprite()) as Sprite;
			_outerCircle = super.addChild(new Sprite()) as Sprite;
			var g:Graphics = _outerCircle.graphics;
			var rad:int = Math.max(super.width, super.height) * 0.5;
			g.beginFill(0);
			g.drawCircle(0, 0, rad);
			g.drawCircle(0, 0, rad - 2);
			g.endFill();
			g.beginFill(0);
			g.moveTo( -5, -1 * rad);
			g.lineTo(0, -1 * rad + 8);
			g.lineTo(5, -1 * rad);
			g.endFill();
			
			g = _innerCircle.graphics;
			g.beginFill(0);
			g.drawCircle(0, 0, rad - 15);
			g.drawCircle(0, 0, rad - 17);
			g.endFill();
			g.beginFill(0);
			g.moveTo( -5, -1 * rad + 17);
			g.lineTo(0, -1 * rad + 9);
			g.lineTo(5, -1 * rad + 17);
			g.endFill();
			_innerCircle.x = _outerCircle.x = super.width >> 1;
			_innerCircle.y = _outerCircle.y = super.height >> 1;
			_innerCircle.addEventListener(MouseEvent.MOUSE_DOWN, 
										startRotation, false, 0, true);
			_outerCircle.addEventListener(MouseEvent.MOUSE_DOWN, 
										startRotation, false, 0, true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function startRotation(event:MouseEvent):void 
		{
			_rotateTarget = event.target as Sprite;
			super.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			if (stage) stage.addEventListener(MouseEvent.MOUSE_UP, stopRotate);
			else super.addEventListener(MouseEvent.MOUSE_UP, stopRotate);
		}
		
		private function stopRotate(event:MouseEvent):void 
		{
			(event.target as IEventDispatcher).removeEventListener(
									MouseEvent.MOUSE_UP, stopRotate);
			super.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void 
		{
			var p:Point = new Point(super.width >> 1, super.height >> 1);
			var t:Point = new Point(super.mouseX, super.mouseY);
			t = t.subtract(p);
			var angle:Number = Math.atan2(t.x, t.y);
			_rotateTarget.rotation = 180 + angle * -180 / Math.PI;
		}
	}
	
}