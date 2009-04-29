package org.wvxvws.gui 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Transform;
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	* Preloader class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Preloader extends Control implements IPreloader
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
			invalidLayout = true;
		}
		
		public function get target():IEventDispatcher { return _target; }
		
		public function set percent(value:int):void
		{
			if (_percent == value) return;
			_percent = value;
			invalidLayout = true;
		}
		
		public function get percent():int { return _percent; }
		
		public function get radius():int { return _radius; }
		
		public function set radius(value:int):void 
		{
			if (_radius == value) return;
			_radius = value;
			invalidLayout = true;
		}
		
		public function get circleRadius():int { return _circleRadius; }
		
		public function set circleRadius(value:int):void 
		{
			if (_circleRadius == value) return;
			_circleRadius = value;
			invalidLayout = true;
		}
		
		public function get circleColor():uint { return _circleColor; }
		
		public function set circleColor(value:uint):void 
		{
			if (_circleColor == value) return;
			_circleColor = value;
			invalidLayout = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _radius:int = 32;
		protected var _circleRadius:int = 6;
		protected var _circleColor:uint = 0xA8874E;
		
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
		//  Cunstructor
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
			addEventListener(Event.ENTER_FRAME, renderFrame, false, 0, true);
		}
		
		public function stop():void
		{
			_isPlaying = false;
			removeEventListener(Event.ENTER_FRAME, renderFrame);
		}
		
		override public function initialized(document:Object, id:String):void 
		{
			super.initialized(document, id);
			_backgroundColor = 0x3E2F1B;
			_backgroundAlpha = 1;
			init();
			start();
		}
		
		override public function validateLayout(event:Event = null):void 
		{
			super.validateLayout(event);
			init();
			if (_isPlaying) start();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function init(numCircles:int = 12):void
		{
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
			addChild(_container);
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
			s.graphics.beginFill(_circleColor);
			s.graphics.drawCircle(where.x, where.y, _circleRadius);
			s.graphics.endFill();
			return _container.addChild(s) as Shape;
		}
		
		protected function completeHandler(event:Event):void 
		{
			dispatchEvent(event);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}