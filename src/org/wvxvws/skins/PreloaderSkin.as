package org.wvxvws.skins 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Transform;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.IPreloader;
	import org.wvxvws.gui.IProgress;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	
	/**
	 * PreloaderSkin skin.
	 * @author wvxvw
	 */
	public class PreloaderSkin extends Sprite implements IProgress, IMXMLObject, ISkin
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public override function set width(value:Number):void 
		{
			if (_width === value) return;
			_width = value;
			this.init();
		}
		
		public override function set height(value:Number):void 
		{
			if (_height === value) return;
			_height = value;
			this.init();
		}
		
		/* INTERFACE org.wvxvws.gui.IProgress */
		
		public function set percent(value:int):void
		{
			value = Math.max(Math.min(100, value), 0);
			if (_percent === value) return;
			_percent = value;
			this.drawStep();
		}
		
		public function get percent():int { return _percent; }
		
		/* INTERFACE org.wvxvws.gui.skins.ISkin */
		
		public function get host():ISkinnable { return _preloader as ISkinnable; }
		
		public function set host(value:ISkinnable):void
		{
			if (value === _preloader) return;
			_preloader = value as IPreloader;
		}
		
		public function get radius():int { return _radius; }
		
		public function set radius(value:int):void 
		{
			if (_radius === value) return;
			_radius = value;
			this.init();
		}
		
		public function get circleRadius():int { return _circleRadius; }
		
		public function set circleRadius(value:int):void 
		{
			if (_circleRadius === value) return;
			_circleRadius = value;
			this.init();
		}
		
		public function get circleColor():uint { return _circleColor; }
		
		public function set circleColor(value:uint):void 
		{
			if (_circleColor === value) return;
			_circleColor = value;
			this.init();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _radius:int = 32;
		protected var _circleRadius:int = 6;
		protected var _circleColor:uint = 0xA8874E;
		protected var _cRotation:Number = 0;
		protected var _cTransform:Transform;
		protected var _cMatrix:Matrix;
		protected var _container:Sprite;
		protected var _isPlaying:Boolean;
		protected var _preTX:int;
		protected var _preTY:int;
		protected var _percent:int;
		protected var _preloader:IPreloader;
		protected var _width:int;
		protected var _height:int;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PreloaderSkin() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function produce(inContext:Object, ...args):Object 
		{
			return new PreloaderSkin();
		}
		
		public function initialized(document:Object, id:String):void
		{
			if (document is IPreloader)
			{
				_preloader = document as IPreloader;
				(document as DisplayObjectContainer).addChild(this);
			}
			if (!_cTransform) this.init();
		}
		
		//--------------------------------------------------------------------------
		//
		//  protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function init(numCircles:int = 12):void
		{
			var step:int = numCircles * 0.5;
			if (_container && contains(_container)) super.removeChild(_container);
			_container = new Sprite();
			while (numCircles--)
			{
				_container.addChild(this.drawCircle(
					new Point(Math.cos(Math.PI * numCircles / step) * _radius,
					Math.sin(Math.PI * numCircles / step) * _radius)));
			}
			_container.x = _preTX = _width >> 1;
			_container.y = _preTY = _height >> 1;
			_cTransform = new Transform(_container);
			super.addChild(_container);
		}
		
		protected function drawCircle(where:Point):Shape
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(_circleColor);
			s.graphics.drawCircle(where.x, where.y, _circleRadius);
			s.graphics.endFill();
			return _container.addChild(s) as Shape;
		}
		
		protected function drawStep():void
		{
			if (!_cTransform) this.init();
			_cRotation++;
			_cRotation = _cRotation % 360;
			_cMatrix = new Matrix();
			_cMatrix.rotate(_cRotation * Math.PI / 180);
			_cMatrix.translate(_preTX, _preTY);
			_cTransform.matrix = _cMatrix;
		}
	}
}