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
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	* Preloader class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Preloader extends DIV implements IPreloader
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.gui.IPreloader */
		
		public function get classAlias():String { return _classAlias; }
		
		public function set classAlias(value:String):void
		{
			_classAlias = value;
		}
		
		/* INTERFACE org.wvxvws.gui.IPreloader */
		
		public function set target(value:IEventDispatcher):void
		{
			if (_target == value) return;
			_target = value;
			_target.addEventListener(Event.COMPLETE, completeHandler);
			super.invalidate("_target", _target, false);
		}
		
		public function get target():IEventDispatcher { return _target; }
		
		public function set percent(value:int):void
		{
			if (_percent == value) return;
			_percent = value;
			super.invalidate("_percent", _percent, false);
		}
		
		public function get percent():int { return _percent; }
		
		public function get radius():int { return _radius; }
		
		public function set radius(value:int):void 
		{
			if (_radius == value) return;
			_radius = value;
			super.invalidate("_radius", _radius, true);
		}
		
		public function get circleRadius():int { return _circleRadius; }
		
		public function set circleRadius(value:int):void 
		{
			if (_circleRadius == value) return;
			_circleRadius = value;
			super.invalidate("_circleRadius", _circleRadius, false);
		}
		
		public function get circleColor():uint { return _circleColor; }
		
		public function set circleColor(value:uint):void 
		{
			if (_circleColor == value) return;
			_circleColor = value;
			super.invalidate("_circleColor", _circleColor, false);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _radius:int = 32;
		protected var _circleRadius:int = 6;
		protected var _circleColor:uint = 0xA8874E;
		protected var _highlightColor:uint = 0xFFB833;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _cRotation:Number = 0;
		private var _cTransform:Transform;
		private var _cMatrix:Matrix;
		private var _container:Sprite;
		private var _isPlaying:Boolean;
		private var _preTX:int;
		private var _preTY:int;
		private var _target:IEventDispatcher;
		private var _percent:int;
		private var _classAlias:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Preloader() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function start():void
		{
			_isPlaying = true;
			super.addEventListener(Event.ENTER_FRAME, renderFrame, false, 0, true);
		}
		
		public function stop():void
		{
			_isPlaying = false;
			super.removeEventListener(Event.ENTER_FRAME, renderFrame);
		}
		
		override public function initialized(document:Object, id:String):void 
		{
			super.initialized(document, id);
			_backgroundColor = 0x3E2F1B;
			_backgroundAlpha = 1;
			init();
			start();
		}
		
		override public function validate(properties:Object):void 
		{
			super.validate(properties);
			this.init();
			if (_isPlaying) start();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function init(numCircles:int = 12):void
		{
			this.drawPatternedBacground();
			var step:int = numCircles / 2;
			if (_container && contains(_container))
			{
				removeChild(_container);
			}
			_container = new Sprite();
			while (numCircles--)
			{
				_container.addChild(drawCircle(
					new Point(Math.cos(Math.PI * numCircles / step) * _radius,
					Math.sin(Math.PI * numCircles / step) * _radius)));
			}
			_container.x = _preTX = width >> 1;
			_container.y = _preTY = height >> 1;
			_container.filters = [new DropShadowFilter(_radius >> 1, 90, 0, .2, 8, 8, 1.8),
									new GlowFilter(0, .6, 4, 4, 2, 1, true)];
			super.addChild(_container);
			_cTransform = new Transform(_container);
		}
		
		protected function renderFrame(event:Event):void 
		{
			_cRotation++;
			_cRotation = _cRotation % 360;
			_cMatrix = new Matrix();
			_cMatrix.rotate(_cRotation * Math.PI / 180);
			_cMatrix.translate(_preTX, _preTY);
			_cTransform.matrix = _cMatrix;
		}
		
		protected function drawCircle(where:Point):Shape
		{
			var s:Shape = new Shape();
			var m:Matrix = new Matrix();
			m.createGradientBox(_circleRadius * 2, _circleRadius * 2);
			m.tx = where.x;
			m.ty = where.y;
			s.graphics.beginGradientFill("radial", 
										[_highlightColor, _circleColor, _circleColor, _highlightColor],
										[1, 1, .6, 1], [50, 100, 200, 255], m, "pad", "rgb", .5);
			s.graphics.drawCircle(where.x, where.y, _circleRadius);
			s.graphics.endFill();
			return _container.addChild(s) as Shape;
		}
		
		protected function completeHandler(event:Event):void 
		{
			super.dispatchEvent(event);
		}
		
		protected function drawPatternedBacground():void
		{
			var cl:uint = _backgroundColor;
			var pattern:BitmapData = new BitmapData(50, 50, false, _backgroundColor);
			pattern.fillRect(new Rectangle(0, 0, pattern.width * 0.5, pattern.height), 0x47361F);
			var i:int = pattern.height;
			var line:Rectangle = new Rectangle(0, 0, pattern.width * 0.5, 1);
			while (i >= 0)
			{
				pattern.fillRect(line, _backgroundColor);// 0x47361F);
				line.y = i;
				i -= 5;
			}
			var pWidth:int = width;
			var pHeight:int = height;
			var mtx:Matrix = new Matrix();
			mtx.rotate(Math.PI * 0.25);
			graphics.clear();
			graphics.beginBitmapFill(pattern, mtx, true, true);
			graphics.drawRect(0, 0, pWidth, pHeight);
			graphics.endFill();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}