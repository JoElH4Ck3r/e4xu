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
			if (this._width === value) return;
			this._width = value;
			this.init();
		}
		
		public override function set height(value:Number):void 
		{
			if (this._height === value) return;
			this._height = value;
			this.init();
		}
		
		/* INTERFACE org.wvxvws.gui.IProgress */
		
		public function set percent(value:int):void
		{
			value = Math.max(Math.min(100, value), 0);
			if (this._percent === value) return;
			this._percent = value;
			this.drawStep();
		}
		
		public function get percent():int { return this._percent; }
		
		/* INTERFACE org.wvxvws.gui.skins.ISkin */
		
		public function get host():ISkinnable { return this._preloader as ISkinnable; }
		
		public function set host(value:ISkinnable):void
		{
			if (value === this._preloader) return;
			this._preloader = value as IPreloader;
		}
		
		public function get radius():int { return this._radius; }
		
		public function set radius(value:int):void 
		{
			if (this._radius === value) return;
			this._radius = value;
			this.init();
		}
		
		public function get circleRadius():int { return this._circleRadius; }
		
		public function set circleRadius(value:int):void 
		{
			if (this._circleRadius === value) return;
			this._circleRadius = value;
			this.init();
		}
		
		public function get circleColor():uint { return this._circleColor; }
		
		public function set circleColor(value:uint):void 
		{
			if (this._circleColor === value) return;
			this._circleColor = value;
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
				this._preloader = document as IPreloader;
				(document as DisplayObjectContainer).addChild(this);
			}
			if (!this._cTransform) this.init();
		}
		
		public function dispose():void
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function init(numCircles:int = 12):void
		{
			var step:int = numCircles * 0.5;
			if (this._container && contains(this._container))
				super.removeChild(this._container);
			this._container = new Sprite();
			while (numCircles--)
			{
				this._container.addChild(this.drawCircle(
					new Point(Math.cos(Math.PI * numCircles / step) * this._radius,
					Math.sin(Math.PI * numCircles / step) * this._radius)));
			}
			this._container.x = this._preTX = this._width >> 1;
			this._container.y = this._preTY = this._height >> 1;
			this._cTransform = new Transform(this._container);
			super.addChild(this._container);
		}
		
		protected function drawCircle(where:Point):Shape
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(this._circleColor);
			s.graphics.drawCircle(where.x, where.y, this._circleRadius);
			s.graphics.endFill();
			return this._container.addChild(s) as Shape;
		}
		
		protected function drawStep():void
		{
			if (!this._cTransform) this.init();
			this._cRotation++;
			this._cRotation = this._cRotation % 360;
			this._cMatrix = new Matrix();
			this._cMatrix.rotate(this._cRotation * Math.PI / 180);
			this._cMatrix.translate(this._preTX, this._preTY);
			this._cTransform.matrix = this._cMatrix;
		}
	}
}